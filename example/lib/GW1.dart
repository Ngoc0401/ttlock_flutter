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

  _GatewayPageState(TTGatewayType type, String? wifi) {
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
    if (_wifi == null && _wifiPassword != null && _wifiPassword!.length == 0) {
      _showAndDismiss(ProgressHudType.error, 'Wifi or password cant be empty');
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
      print("Gateway added result");
      print(map);
      _showAndDismiss(ProgressHudType.success, 'Init Gateway Success');
    }, (errorCode, errorMsg) {
      _showAndDismiss(
          ProgressHudType.error, 'errorCode:$errorCode msg:$errorMsg');
      if (errorCode == TTGatewayError.notConnect ||
          errorCode == TTGatewayError.disconnect) {
        print("Please repower and connect the gateway again");
      }
    });
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
              return getChild();
            }),
          ),
        ),
      ),
    );
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
      decoration: InputDecoration(hintText: 'Input wifi password'),
      onChanged: (String content) {
        _wifiPassword = content;
      },
    );

    ElevatedButton initGatewayButton = ElevatedButton(
      child: Text('Init Gateway'),
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
