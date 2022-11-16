// ignore: file_names
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'CustomerHomePage.dart';
import 'LoginPage.dart';

class AddCustomerPage extends StatefulWidget {
  String email;
  AddCustomerPage({Key? key, required this.email}) : super(key: key);

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final _fname = TextEditingController();
  final _lname = TextEditingController();
  bool smok = true;
  bool smk = false;
  bool ride = false;
  late SnackBar sb;
  final _phone = TextEditingController();
  final _address = TextEditingController();
  String? _message;
  String? s, rs, fast;
  String ip = "http://192.168.0.124";
  Future<void> postdata() async {
    try {
      if (smk) {
        s = "yes";
      } else {
        s = "no";
      }
      if (ride) {
        fast = "yes";
      } else {
        fast = "no";
      }
      if (smok) {
        rs = "yes";
      } else {
        rs = "no";
      }
      var response = await http
          .post(Uri.parse("$ip/Project/api/Customer/addCustomer"), body: {
        "fname": _fname.text,
        "lname": _lname.text,
        "address": _address.text,
        "phone": _phone.text,
        "email": widget.email,
        "smoke": s,
        "rsmoke": rs,
        "rfast": fast,
      });
      print(response.body);
      if (response.statusCode == 200) {
        var _messsage = response.body.toString();
        sb = SnackBar(content: Text('$_messsage'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
        await addCustomerLocation();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CustomerHomePage(email: widget.email)));
      } else {
        _message = response.body.toString();
        sb = SnackBar(content: Text('$_message'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => CustomerLoginPage()));
      }
    } on Exception catch (_, exp) {}
  }

  Future<void> addCustomerLocation() async {
    var response = await http
        .post(Uri.parse("$ip/Project/api/Customer/addCustomerLocation"), body: {
      "email": widget.email,
    });
    if (response.statusCode == 200) {
      sb = SnackBar(content: Text('Location Also Added'));
      ScaffoldMessenger.of(context).showSnackBar(sb);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Give Your Information',
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
                  Row(
                    children: [
                      Text("Do You Smoke?",
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                      Checkbox(
                          value: this.smk,
                          onChanged: (smok) {
                            setState(() {
                              this.smk = smok!;
                            });
                          })
                    ],
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Text("Prefer Traveling With ?",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          decoration: TextDecoration.underline)),
                  Row(
                    children: [
                      Text("Smoker",
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                      Checkbox(
                          checkColor: Colors.greenAccent,
                          activeColor: Colors.red,
                          value: this.smok,
                          onChanged: (son) {
                            setState(() {
                              this.smok = son!;
                              print(smok);
                            });
                          })
                    ],
                  ),
                  Row(
                    children: [
                      Text("Fast Rider",
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                      Checkbox(
                          checkColor: Colors.greenAccent,
                          activeColor: Colors.red,
                          value: this.ride,
                          onChanged: (son) {
                            setState(() {
                              this.ride = son!;
                              print(ride);
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
    _address.text = "";
    _lname.text = "";
    _phone.text = "";
    smk = false;
    smok = false;
    // TODO: implement dispose
    super.dispose();
  }
}
