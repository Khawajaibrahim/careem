import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AddCaptainPage.dart';
import 'AddCustomerPage.dart';
import 'CaptainHomePage.dart';
import 'LoginPage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _conpass = TextEditingController();
  late SnackBar sb;
  String? role = "";
  String _messsage = '';
  String ip = "http://192.168.0.104";
  Future<void> postdata() async {
    try {
      var response = await http.post(
          Uri.parse("$ip/Project/api/Careem/addLogin"),
          body: {"email": _email.text, "password": _pass.text, "role": role});
      if (response.statusCode == 200) {
        _messsage = response.body.toString();
        sb = SnackBar(content: Text('$_messsage'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CustomerLoginPage()));
      } else {
        _messsage = response.body.toString();
        sb = SnackBar(content: Text('$_messsage'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
      }
    } on Exception catch (_, exp) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Careem Replica'),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.lightBlueAccent,
                    Colors.lightBlue,
                    Colors.blueAccent,
                  ])),
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Container(
                color: Colors.white,
                child: TextField(
                  controller: _email,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(fontSize: 20.0),
                    border: UnderlineInputBorder(),
                    filled: true,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                color: Colors.white,
                child: TextField(
                  controller: _pass,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(fontSize: 20.0),
                    border: UnderlineInputBorder(),
                    filled: true,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                color: Colors.white,
                child: TextField(
                  controller: _conpass,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(fontSize: 20.0),
                    border: UnderlineInputBorder(),
                    filled: true,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'SignUp AS?',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          'Customer',
                          style: TextStyle(fontSize: 15.0, color: Colors.white),
                        ),
                        leading: Radio(
                          value: 'cust',
                          groupValue: role,
                          onChanged: (value) {
                            setState(() {
                              role = value.toString();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          'Captain',
                          style: TextStyle(fontSize: 15.0, color: Colors.white),
                        ),
                        leading: Radio(
                          value: 'cap',
                          groupValue: role,
                          onChanged: (value) {
                            setState(() {
                              role = value.toString();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              SizedBox(
                height: 20.0,
              ),
              Column(
                children: <Widget>[
                  ButtonTheme(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_email.text == "" ||
                            _pass.text == "" ||
                            _conpass.text == "" ||
                            role == "") {
                          sb = SnackBar(content: Text('INCORRECT INPUT'));
                          ScaffoldMessenger.of(context).showSnackBar(sb);
                        } else {
                          if (!(_pass.text == _conpass.text)) {
                            sb = SnackBar(content: Text('Password Mismatched'));
                            ScaffoldMessenger.of(context).showSnackBar(sb);
                          } else {
                            postdata();
                          }
                        } //move to verification page to verify email
                      },
                      child: Text(
                        'Sign Up',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Already have an account?',
                        style: TextStyle(fontSize: 10.0),
                      ),
                      TextButton(
                        child: Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          //Move To Login page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerLoginPage()),
                          );
                        },
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
