import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoCallPage extends StatefulWidget {
  final String ipAddress;

  VideoCallPage({required this.ipAddress});

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peerConnection;
  bool _isCallActive = false;

  @override
  void initState() {
    super.initState();
    _initializeRenderers();
    _startCall();
  }

  @override
  void dispose() {
    _remoteRenderer.dispose();
    super.dispose();
  }

  void _initializeRenderers() async {
    await _remoteRenderer.initialize();
  }

  Future<void> _startCall() async {
    _peerConnection = await _createPeerConnection();

    _handleSignaling();
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    final Map<String, dynamic> configuration = {
      'iceServers': [
        {
          'urls': 'stun:stun.l.google.com:19302',
        },
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      'mandatory': {
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': true,
      },
      'optional': [],
    };

    RTCPeerConnection peerConnection =
        await createPeerConnection(configuration, offerSdpConstraints);

    peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate != null) {
        _sendIceCandidateToBackend(candidate);
      }
    };

    peerConnection.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video') {
        setState(() {
          _remoteRenderer.srcObject = event.streams[0];
        });
      }
    };

    return peerConnection;
  }

  void _handleSignaling() async {
    RTCSessionDescription description = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(description);

    var offer = {
      'sdp': description.sdp,
      'type': description.type,
    };
    var response = await http.post(
      Uri.parse('http://${widget.ipAddress}:8080/offer'),
      body: json.encode(offer),
      headers: {'Content-Type': 'application/json'},
    );

    var answer = jsonDecode(response.body);
    await _peerConnection!.setRemoteDescription(
      RTCSessionDescription(answer['sdp'], answer['type']),
    );
  }

  void _sendIceCandidateToBackend(RTCIceCandidate candidate) async {
    var iceCandidate = {
      'candidate': candidate.candidate,
      'sdpMid': candidate.sdpMid,
      'sdpMLineIndex': candidate.sdpMLineIndex,
    };

    await http.post(
      Uri.parse('http://${widget.ipAddress}:8080/ice-candidate'),
      body: json.encode(iceCandidate),
      headers: {'Content-Type': 'application/json'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Call with HOD'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: RTCVideoView(_remoteRenderer),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              ),
              onPressed: () {
                _hangUpCall();
                Navigator.pop(context);
              },
              icon: Icon(Icons.call_end),
              label: Text('Hang Up'),
            ),
          ),
        ],
      ),
    );
  }

  void _hangUpCall() {
    if (_peerConnection != null) {
      _peerConnection!.close();
    }
  }
}
