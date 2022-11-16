import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AddVehiclePage.dart';
import 'CustomerHomePage.dart';
import 'LoginPage.dart';

class AddCaptainPage extends StatefulWidget {
  String email;
  AddCaptainPage({Key? key, required this.email}) : super(key: key);

  @override
  State<AddCaptainPage> createState() => _AddCaptainPageState();
}

class _AddCaptainPageState extends State<AddCaptainPage> {
  final _fname = TextEditingController();
  final _lname = TextEditingController();
  String ip = "http://192.168.0.124";
  late SnackBar sb;
  bool fast = false;
  bool smoke = true;
  final _phone = TextEditingController();
  final _address = TextEditingController();
  String? _message;
  String? fas, smok;
  Future<void> postdata() async {
    try {
      if (fast) {
        fas = "yes";
      } else {
        fas = "no";
      }
      if (smoke) {
        smok = "yes";
      } else {
        smok = "no";
      }

      var response = await http
          .post(Uri.parse("$ip/Project/api/Captain/addCaptain"), body: {
        "fname": _fname.text,
        "lname": _lname.text,
        "address": _address.text,
        "phone": _phone.text,
        "email": widget.email,
        "dfast": fas,
        "smoke": smok,
      });
      if (response.statusCode == 200) {
        var _messsage = response.body.toString();
        sb = SnackBar(content: Text('$_messsage'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AddVehiclePage(
                email: widget.email,
              )),
        );
      } else {
        _message = response.body.toString();
        sb = SnackBar(content: Text('$_message'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => CustomerLoginPage()));
      }
    } on Exception catch (_, exp) {
      print(exp.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Give Your Inforamation',
            textAlign: TextAlign.center,
          ),
        ),
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
            children: [
              SizedBox(
                height: 20.0,
              ),
              Container(
                color: Colors.white,
                child: TextField(
                  controller: _fname,
                  decoration: InputDecoration(
                    hintText: 'First Name',
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
                  controller: _lname,
                  decoration: InputDecoration(
                    hintText: 'LastName',
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
                  controller: _phone,
                  decoration: InputDecoration(
                    hintText: 'Contact No',
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
                  controller: _address,
                  decoration: InputDecoration(
                    hintText: 'Address',
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
                children: [
                  Divider(
                    color: Colors.white,
                  ),
                  Text("Select Your Habits",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          decoration: TextDecoration.underline)),
                  Row(
                    children: [
                      Text("Do You Smoke?",
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                      Checkbox(
                          value: this.smoke,
                          onChanged: (sm) {
                            setState(() {
                              this.smoke = sm!;
                            });
                          })
                    ],
                  ),
                  Row(
                    children: [
                      Text("Do You Drive Fast?",
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                      Checkbox(
                          checkColor: Colors.greenAccent,
                          activeColor: Colors.red,
                          value: this.fast,
                          onChanged: (fas) {
                            setState(() {
                              this.fast = fas!;
                              print(fas);
                            });
                          })
                    ],
                  ),
                  Divider(color: Colors.white),
                  ButtonTheme(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_fname.text == "" ||
                            _lname.text == "" ||
                            _phone.text == "" ||
                            _address == "") {
                          sb = SnackBar(
                              content: Text('Empty Fields Are Not Allowed'));
                          ScaffoldMessenger.of(context).showSnackBar(sb);
                        } else {
                          postdata();
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

  @override
  void dispose() {
    _fname.text = "";
    _lname.text = "";
    _address.text = "";
    _phone.text = "";
    smoke = false;
    fast = false;
    // TODO: implement dispose
    super.dispose();
  }
}
