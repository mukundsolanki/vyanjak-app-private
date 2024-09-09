import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;

class IncomingConnect extends StatefulWidget {
  final String ipAddress;

  IncomingConnect({required this.ipAddress});

  @override
  _IncomingConnectState createState() => _IncomingConnectState();
}

class _IncomingConnectState extends State<IncomingConnect> {
  late RTCPeerConnection _peerConnection;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  bool _inCalling = false;
  late String signalingServerUrl;
  bool _showLocalStream = false;

  @override
  void initState() {
    super.initState();
    signalingServerUrl = 'http://${widget.ipAddress}:8080/offer';
    _initializeRenderers();
    _createPeerConnection();
  }

  Future<void> _initializeRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> _createPeerConnection() async {
    final Map<String, dynamic> configuration = {
      "iceServers": [
        {"urls": "stun:stun.l.google.com:19302"},
      ]
    };

    _peerConnection = await createPeerConnection(configuration);

    // Log ICE connection state changes
    _peerConnection.onIceConnectionState = (RTCIceConnectionState state) {
      print("ICE connection state changed: $state");
    };

    // Get user media (camera and microphone)
    _localStream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    });

    // Add local stream to peer connection
    _localStream!.getTracks().forEach((track) {
      _peerConnection.addTrack(track, _localStream!);
    });

    // Display local stream
    _localRenderer.srcObject = _localStream;

    // Handle incoming stream
    _peerConnection.onTrack = (event) {
      print("Received remote track: ${event.track.kind}");
      if (event.track.kind == 'video') {
        setState(() {
          _remoteRenderer.srcObject = event.streams[0];
        });
      }
    };

    // Create an offer and send it to the signaling server
    RTCSessionDescription offer = await _peerConnection.createOffer();
    await _peerConnection.setLocalDescription(offer);

    print("Sending offer to the signaling server.");

    // Send offer to the signaling server
    var response = await http.post(
      Uri.parse(signalingServerUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'sdp': offer.sdp,
        'type': offer.type,
      }),
    );

    if (response.statusCode == 200) {
      // Handle the answer from the server
      var responseData = json.decode(response.body);
      RTCSessionDescription answer = RTCSessionDescription(
        responseData['sdp'],
        responseData['type'],
      );
      print("Received answer from signaling server.");
      await _peerConnection.setRemoteDescription(answer);
    } else {
      print('Failed to connect to the signaling server.');
    }
  }

  Future<void> _hangUp() async {
    await _localStream?.dispose();
    await _peerConnection.close();
    _localRenderer.srcObject = null;
    _remoteRenderer.srcObject = null;

    setState(() {
      _inCalling = false;
    });

    SystemNavigator.pop();
  }

  void _toggleLocalStream() {
    setState(() {
      _showLocalStream = !_showLocalStream;
    });
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter WebRTC Demo'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: _showLocalStream
                  ? RTCVideoView(_localRenderer, mirror: true)
                  : Container(),
            ),
            Expanded(
              child: RTCVideoView(_remoteRenderer),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _hangUp(),
                  child: Text('Hang Up'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed:
                      _toggleLocalStream,
                  child: Text(
                      _showLocalStream ? 'Hide My Camera' : 'Show My Camera'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
