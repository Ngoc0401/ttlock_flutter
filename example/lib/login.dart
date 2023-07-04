import 'package:flutter/material.dart';
import 'package:ttlock_flutter_example/cam.dart';
import 'package:ttlock_flutter_example/forgot.dart';
import 'package:ttlock_flutter_example/gateway_page.dart';

import 'package:bmprogresshud/progresshud.dart';
import 'package:ttlock_flutter_example/home_page.dart';
import 'package:ttlock_flutter_example/signup.dart';
import 'scan_page.dart';
import 'config.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200,
                height: 100,
                //color: Color.fromARGB(255, 136, 101, 98),
                child: Image.network('https://i.imgur.com/6GD809g.jpg'),
                // child: Image.asset('assets/images/k.jpg'),
              ),
              SizedBox(height: 30.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 20.0),
              // GestureDetector(
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => HomePage()),
              //       );
              //     },
              //     child: new Container(
              //       width: 100.0,
              //       padding: new EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              //       color: Colors.green,
              //       child: new Column(children: [
              //         new Text("Login"),
              //       ]),
              //     )),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RTSPPlayerWidget()),
                  );
                },
                child: Text('  Login  '),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signup()),
                  );
                },
                child: Text('Sign up'),
              ),
              SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Forgot()),
                  );
                },
                child: Text('Forgot Password?'),
              ),
            ],
          ),
        ));
  }
}
