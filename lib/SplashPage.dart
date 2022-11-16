import 'dart:async';
import 'package:flutter/material.dart';
import 'LoginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () async {
      await Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => CustomerLoginPage()));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Image.asset(
                  "images/carr.jpg",
                  fit: BoxFit.fill,
                )),
          ),
          Expanded(child: Center(child: CircularProgressIndicator()))
        ]));
  }
}
