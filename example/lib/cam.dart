import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:bmprogresshud/progresshud.dart';
import 'scan_page.dart';
import 'config.dart';

class RTSPPlayerWidget extends StatefulWidget {
  @override
  _RTSPPlayerWidgetState createState() => _RTSPPlayerWidgetState();
}

class _RTSPPlayerWidgetState extends State<RTSPPlayerWidget> {
  BuildContext? _context;

  void _startScanGateway() {
    if (Config.uid == 0 || Config.ttlockLoginPassword.length == 0) {
      String text = 'Please config the ttlockUid and the ttlockLoginPassword';
      ProgressHud.of(_context!).showAndDismiss(ProgressHudType.error, text);
      return;
    }
    _startScan(ScanType.gateway);
  }

  void _startScanLock() {
    _startScan(ScanType.lock);
  }

  void _startScan(ScanType scanType) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return ScanPage(
        scanType: scanType,
      );
    }));
  }

  late VlcPlayerController _vlcPlayerController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _vlcPlayerController.dispose();
    super.dispose();
  }

  void _initializePlayer() {
    _vlcPlayerController = VlcPlayerController.network(
      'rtsp://admin:Admin123@mtkhp2408.cameraddns.net:554/cam/realmonitor?channel=1&subtype=0&unicast=true',
      hwAcc: HwAcc.FULL,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RTSP Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            VlcPlayer(
              controller: _vlcPlayerController,
              aspectRatio: 16 / 9,
              placeholder: Center(child: CircularProgressIndicator()),
            ),
            ElevatedButton(
              child:
                  Text('Lock', style: TextStyle(fontWeight: FontWeight.w600)),
              onPressed: _startScanLock,
            ),
            ElevatedButton(
              child: Text('Gateway',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              onPressed: _startScanGateway,
            )
          ],
        ),
      ),
    );
  }
}
