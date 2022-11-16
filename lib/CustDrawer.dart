//import 'package:abc/CustomerLoginPage.dart';
import 'package:flutter/material.dart';

import 'LoginPage.dart';
import 'SchedulePage.dart';

//import 'package:share_plus/share_plus.dart';
//import 'ProfilePage.dart';
//import 'SchedulePage.dart';
class CustDrawer extends StatefulWidget {
  var email;

  CustDrawer({Key? key, required this.email}) : super(key: key);

  @override
  State<CustDrawer> createState() => _CustDrawerState();
}

class _CustDrawerState extends State<CustDrawer> {
  @override
  Widget build(BuildContext context) {
    final name = "Arsal";
    final email = "Arsal@gmail.com";
    return Drawer(
      child: Material(
          color: Colors.indigo,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                child: Column(
                  children: [
                    CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage('images/cardrawer.jpg')),
                    Text("$name",
                        style: TextStyle(color: Colors.white, fontSize: 24)),
                    Text("$email", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              Divider(color: Colors.white70),
              SizedBox(height: 30),
              ListTile(
                leading: Icon(Icons.supervised_user_circle_rounded,
                    color: Colors.white),
                title: Text("Profile", style: TextStyle(color: Colors.white)),
                hoverColor: Colors.white70,
                onTap: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
                },
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.schedule, color: Colors.white),
                title:
                Text("Set Schedule", style: TextStyle(color: Colors.white)),
                hoverColor: Colors.white70,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SchedulePage(
                            email: widget.email,
                          )));
                },
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.schedule, color: Colors.white),
                title: Text("View Your Schedules",
                    style: TextStyle(color: Colors.white)),
                hoverColor: Colors.white70,
                onTap: () {
                  //         Navigator.push(context, MaterialPageRoute(builder: (context)=>SchedulePage()));
                },
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text("Logout", style: TextStyle(color: Colors.white)),
                hoverColor: Colors.white70,
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerLoginPage()));
                },
              ),
              Divider(color: Colors.white70),
              SizedBox(height: 30),
              ListTile(
                leading: Icon(Icons.share, color: Colors.white),
                title: Text("Share This App",
                    style: TextStyle(color: Colors.white)),
                hoverColor: Colors.white70,
                onTap: () {
                  //     Share.share('Now Book Your Ride By just One Click Download And Install this Application');
                },
              ),
              SizedBox(height: 30),
              ListTile(
                leading: Icon(Icons.help, color: Colors.white),
                title: Text("Help", style: TextStyle(color: Colors.white)),
                hoverColor: Colors.white70,
                onTap: () {},
              )
            ],
          )),
    );
  }
}
