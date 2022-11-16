import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AddCaptainPage.dart';
import 'AddCustomerPage.dart';
import 'AddVehiclePage.dart';
import 'CaptainHomePage.dart';
import 'CustomerHomePage.dart';
import 'SignUpPage.dart';

class CustomerLoginPage extends StatefulWidget {
  var email;

  CustomerLoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomerLoginPage> createState() => _CustomerLoginPageState();
}

class _CustomerLoginPageState extends State<CustomerLoginPage> {
  late SnackBar sb;
  final _email = TextEditingController();
  final _password = TextEditingController();
  var _message;
  var _msg, _m;
  String ip = "http://192.168.100.19";
  bool _isclick = true;

  Future<void> checkCustomer() async {
    try {
      var res = await http.post(
          Uri.parse('$ip/Project/api/Customer/checkcustomer'),
          body: {"email": _email.text});
      if (res.statusCode == 200) {
        _msg = res.body.toString();
        print(_msg);
        if (_msg == '1') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomerHomePage(email: _email.text)));
        } else if (_msg == '0') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddCustomerPage(
                        email: _email.text,
                      )));
        }
      }
    } on Exception catch (_, exp) {}
  }

  Future<void> checkCaptain() async {
    try {
      print("checking captain");
      var r = await http.post(Uri.parse('$ip/Project/api/Captain/checkcaptain'),
          body: {"email": _email.text});
      print("parsed");
      if (r.statusCode == 200) {
        print("succed");
        _m = r.body.toString();
        print(_m);
        if (_m == '1') {
          checkVehicle();
        } else if (_m == '0') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AddCaptainPage(email: _email.text)));
        }
      } else {
        setState(() {
          _isclick = true;
        });
        _m = r.body.toString();
        sb = SnackBar(content: Text('$_m'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
        print("maslaa");
      }
    } on Exception catch (_, exp) {}
  }

  Future<void> checkVehicle() async {
    try {
      print("checking vehicle");
      var rsp = await http.post(
          Uri.parse('$ip/Project/api/Vehicle/checkvehicle'),
          body: {"email": _email.text});
      if (rsp.statusCode == 200) {
        _m = rsp.body.toString();
        print(_m);
        if (_m == '1') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CaptainHomePage(
                        email: _email.text,
                      )));
        } else if (_m == '0') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddVehiclePage(
                        email: _email.text,
                      )));
        }
      }
    } on Exception catch (_, exp) {}
  }

  Future<void> Post() async {
    try {
      setState(() {
        _isclick = false;
      });
      var response = k
      await
      http.post(Uri.parse('$ip/Project/api/Careem/login'), body: {
        "email": _email.text,
        "password": _password.text,
      }).timeout(const Duration(minutes: 5));
      if (response.statusCode == 200) {
        _message = response.body.toString();
        print(_message);
        if (_message == '"cust"') {
          checkCustomer();
        }
        if (_message == '"cap"') {
          checkCaptain();
        }
      } else {
        setState(() {
          _isclick = true;
          _message = response.body.toString();
          print(_message);
          sb = SnackBar(content: Text('Plzz Enter Correct Email And Password'));
          ScaffoldMessenger.of(context).showSnackBar(sb);
        });
      }
    } on Exception catch (_, exp) {}
  }

  @override
  Widget build(BuildContext context) {
    // var mystyle = TextStyle(fontSize: 40);
    //  var tstyle = TextStyle(fontSize: 30, color: Colors.white);
    return Scaffold(
      appBar: AppBar(
          title: Center(
            child: Text(
              "Login To Your Account",
              textAlign: TextAlign.center,
            ),
          ),
          automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
              height: 650,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.lightBlueAccent,
                        Colors.lightBlue,
                        Colors.blueAccent,
                      ]))),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 50, 10, 30),
              child: Card(
                color: Colors.white,
                shapek: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Column(children: [
                  SizedBox(
                    height: 160,
                    width: 140,
                    child: Image.asset('images/carlogo.png'),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Enter Your Email",
                        labelText: " Enter Your Email",
                        prefixIcon: Icon(Icons.email)),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _password,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Enter Your Password",
                        labelText: "Enter Your Password",
                        prefixIcon: Icon(Icons.password)),
                  ),
                  SizedBox(height: 30),
                  Container(
                    height: 50,
                    width: 110,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: _isclick
                          ? () {
                        if (_email.text == "" || _password.text == "") {
                          sb = SnackBar(
                              content: Text(
                                  'Email And Password Cannot Be Empty'));
                          ScaffoldMessenger.of(context).showSnackBar(sb);
                        } else {
                          Post();
                        }
                      }
                          : null,
                      child:
                      const Text('Login', style: TextStyle(fontSize: 20)),
                      color: Colors.blue,
                      textColor: Colors.white,
                      elevation: 5,
                    ),
                  ),
                  Container(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
                          child: Row(children: [
                            SizedBox(width: 3),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupPage()),
                                );
                              },
                              child: const Text('Create New Account',
                                  style: TextStyle(fontSize: 10)),
                            ),
                          ])))
                ]),
              ))
        ]),
      ),
    );
  }
}
