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
  _GatewayPageState createState() => _GatewayPageState(type, wifi);
}

class _GatewayPageState extends State<GatewayPage> {
  BuildContext? _context;
  String? _wifi;
  String? _wifiPassword;
  TTGatewayType? _type;
  bool _isGatewayInitialized = false;
  String _gatewayName = '';

  _GatewayPageState(TTGatewayType type, String? wifi) {
    super.initState();
    _wifi = wifi;
    _type = type;
  }

  void _showLoading() {
    ProgressHud.of(_context!).showLoading();
  }

  void _showAndDismiss(ProgressHudType type, String text) {
    ProgressHud.of(_context!).showAndDismiss(type, text);
  }

  void _initGateway_2(String? wifi, String? wifiPassword) {
    if (_wifi == null || _wifiPassword == null) {
      _showAndDismiss(
          ProgressHudType.error, 'Wifi hoặc mật khẩu không thể để trống');
      return;
    }

    Map<String, dynamic> paramMap = {
      "wifi": wifi,
      "wifiPassword": wifiPassword,
      "type": _type!.index,
      "gatewayName": Config.gatewayName,
      "uid": Config.uid,
      "ttlockLoginPassword": Config.ttlockLoginPassword,
    };

    _initGateway(paramMap);
  }

  void _unlockRemote() {
    Map<String, dynamic> paramMap = {
      "type": _type!.index,
      "gatewayName": "G2_aac37c", // Thay thế bằng tên gateway của bạn
      "uid": Config.uid,
      "ttlockLoginPassword": Config.ttlockLoginPassword,
    };

    _showLoading();

    TTGateway.unlockRemote(paramMap, (map) {
      print("Kết quả mở khóa từ xa");
      print(map);
      _showAndDismiss(ProgressHudType.success, 'Mở khóa từ xa thành công');
    }, (errorCode, errorMsg) {
      _showAndDismiss(
        ProgressHudType.error,
        'errorCode:$errorCode msg:$errorMsg',
      );
    });
  }

  void _initGateway_3_4() {
    Map<String, dynamic> paramMap = {
      "type": _type!.index,
      "gatewayName": Config.gatewayName,
      "uid": Config.uid,
      "ttlockLoginPassword": Config.ttlockLoginPassword,
    };

    _initGateway(paramMap);
  }

  void _initGateway(Map<String, dynamic> paramMap) {
    _showLoading();
    TTGateway.init(paramMap, (map) {
      print("Kết quả thêm gateway");
      print(map);
      _showAndDismiss(ProgressHudType.success, 'Khởi tạo Gateway thành công');

      String gatewayName = map['gatewayName'] ?? '';
      setState(() {
        _isGatewayInitialized = true;
        _gatewayName = gatewayName;
      });
    }, (errorCode, errorMsg) {
      _showAndDismiss(
          ProgressHudType.error, 'errorCode:$errorCode msg:$errorMsg');
      if (errorCode == TTGatewayError.notConnect ||
          errorCode == TTGatewayError.disconnect) {
        print("Vui lòng tắt và kết nối lại Gateway");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isGatewayInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Gateway"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Gateway đã được khởi tạo thành công:",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                _gatewayName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              // Hiển thị các thông tin khác của gateway tại đây
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // primary: Colors.blue,
                  //onPrimary: Colors.white,
                  textStyle: TextStyle(fontSize: 16),
                ),
                onPressed: _unlockRemote,
                child: Text('Mở Khóa'),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Gateway"),
        ),
        body: Material(
          child: ProgressHud(
            child: Container(
              child: Builder(
                builder: (context) {
                  _context = context;
                  return getChild();
                },
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget getChild() {
    TextField wifiTextField = TextField(
      textAlign: TextAlign.center,
      controller: TextEditingController(text: _wifi),
      enabled: false,
    );

    TextField wifiPasswordTextField = TextField(
      textAlign: TextAlign.center,
      controller: TextEditingController(text: _wifiPassword),
      decoration: InputDecoration(hintText: 'Nhập mật khẩu wifi'),
      onChanged: (String content) {
        _wifiPassword = content;
      },
    );

    ElevatedButton initGatewayButton = ElevatedButton(
      child: Text('Khởi tạo Gateway'),
      onPressed: () {
        FocusScope.of(_context!).requestFocus(FocusNode());
        if (_type == TTGatewayType.g2) {
          _initGateway_2(_wifi, _wifiPassword);
        } else {
          _initGateway_3_4();
        }
      },
    );

    if (_type == TTGatewayType.g2) {
      return Column(
        children: <Widget>[
          wifiTextField,
          wifiPasswordTextField,
          initGatewayButton,
        ],
      );
    } else {
      return Center(child: initGatewayButton);
    }
  }
}
