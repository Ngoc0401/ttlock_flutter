import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late VlcPlayerController _vlcController;

  @override
  void initState() {
    super.initState();
    _vlcController = VlcPlayerController.network(
      '',
    );
  }

  @override
  void dispose() {
    _vlcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Screen'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String username = usernameController.text;
              String password = passwordController.text;
              String cameraUrl =
                  'rtsp://$username:$password@mtkhp2408.cameraddns.net:554/cam/realmonitor?channel=1&subtype=0&unicast=true';
              _vlcController.setMediaFromNetwork(
                cameraUrl,
                autoPlay: true,
              );
            },
            child: Text('Hiển thị Camera'),
          ),
          SizedBox(height: 16.0),
          VlcPlayer(
            controller: _vlcController,
            aspectRatio: 16 / 9,
            placeholder: Container(),
          ),
        ],
      ),
    );
  }
}
