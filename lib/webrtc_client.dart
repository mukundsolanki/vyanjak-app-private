import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;

class WebRTCClient extends StatefulWidget {
  @override
  _WebRTCClientState createState() => _WebRTCClientState();
}

class _WebRTCClientState extends State<WebRTCClient> {
  late RTCPeerConnection _peerConnection;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  bool _inCalling = false;
  final String signalingServerUrl = 'http://172.16.40.26:8080/offer'; // Update with your server IP

  @override
  void initState() {
    super.initState();
    _initializeRenderers();
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
              child: RTCVideoView(_localRenderer, mirror: true),
            ),
            Expanded(
              child: RTCVideoView(_remoteRenderer),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _inCalling ? null : () => _createPeerConnection(),
                  child: Text('Call'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _inCalling ? () => _hangUp() : null,
                  child: Text('Hang Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
