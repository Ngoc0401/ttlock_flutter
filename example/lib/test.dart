import 'package:flutter/material.dart';
import 'package:bmprogresshud/progresshud.dart';
import 'package:ttlock_flutter/ttgateway.dart';
import 'package:ttlock_flutter/ttlock.dart';

import 'config.dart';

class GatewayPage extends StatefulWidget {
  GatewayPage({required this.type, this.wifi}) : super();
  final String? wifi;
  final TTGatewayType type;

  @override
  _GatewayPageState createState() => _GatewayPageState();
}

class _GatewayPageState extends State<GatewayPage> {
  BuildContext? _context;
  String? _wifi;
  String? _wifiPassword;

  void _showLoading() {
    ProgressHud.of(_context!).showLoading();
  }

  void _showAndDismiss(ProgressHudType type, String text) {
    ProgressHud.of(_context!).showAndDismiss(type, text);
  }

  void _initGateway() {
    Map<String, dynamic> paramMap = {
      "wifi": _wifi,
      "wifiPassword": _wifiPassword,
      "type": widget.type.index,
      "gatewayName": Config.gatewayName,
      "uid": Config.uid,
      "ttlockLoginPassword": Config.ttlockLoginPassword,
    };

    _showLoading();
    TTGateway.init(
      paramMap,
      (map) {
        print("Kết quả khởi tạo gateway");
        print(map);
        _showAndDismiss(ProgressHudType.success, 'Khởi tạo gateway thành công');
      },
      (errorCode, errorMsg) {
        _showAndDismiss(
            ProgressHudType.error, 'Mã lỗi: $errorCode - Tin nhắn: $errorMsg');
        if (errorCode == TTGatewayError.notConnect ||
            errorCode == TTGatewayError.disconnect) {
          print("Vui lòng khởi động lại và kết nối lại gateway");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gateway"),
      ),
      body: Material(
        child: ProgressHud(
          child: Container(
            child: Builder(builder: (context) {
              _context = context;
              return Column(
                children: <Widget>[
                  TextField(
                    textAlign: TextAlign.center,
                    controller: TextEditingController(text: widget.wifi),
                    enabled: false,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    decoration:
                        InputDecoration(hintText: 'Nhập mật khẩu Wi-Fi'),
                    onChanged: (String content) {
                      _wifiPassword = content;
                    },
                  ),
                  ElevatedButton(
                    child: Text('Khởi tạo Gateway'),
                    onPressed: _initGateway,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
