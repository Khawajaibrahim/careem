import 'package:flutter/material.dart';

import 'StandPointPage.dart';

class CaptainHomePage extends StatefulWidget {
  var email;
  CaptainHomePage({Key? key, required this.email}) : super(key: key);

  @override
  State<CaptainHomePage> createState() => _CaptainHomePageState();
}

class _CaptainHomePageState extends State<CaptainHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: Center(
              child: Text(
                'Careem Replica(Captain)',
              ),
            ),
            automaticallyImplyLeading: false),
        //  drawer: CustDrawer(),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(height: 650, color: Colors.white70),
              Column(
                children: [
                  Container(
                    height: 240,
                    width: 400,
                    child: Image.asset(
                      'images/mobilecar.jpg',
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Container(
                          child: Image.asset('images/car.jpg',
                              height: 100, width: 100, fit: BoxFit.fill)),
                      SizedBox(width: 20),
                      Image.asset(
                        'images/schedule.jpg',
                        height: 100,
                        width: 100,
                      ),
                      SizedBox(width: 20),
                      Image.asset(
                        'images/view.png',
                        height: 100,
                        width: 100,
                        fit: BoxFit.fill,
                      ),
                    ]),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 5),
                      Container(
                        width: 100,
                        height: 50,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StandPointPage(
                                    email: widget.email,
                                  )),
                            );
                          },
                          child: const Text('Serve Ride',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11)),
                          textColor: Colors.white,
                          color: Colors.indigo,
                          elevation: 5,
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        height: 50,
                        width: 100,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>SchedulePage()),
                            //   );
                          },
                          child: const Text('View Schedules',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11)),
                          textColor: Colors.white,
                          color: Colors.indigo,
                          elevation: 5,
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 100,
                        height: 50,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            //   Navigator.push(context, MaterialPageRoute(builder: (context)=>PreviousRidePage()),
                            //   );
                          },
                          child: const Text('Previous Rides',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11)),
                          textColor: Colors.white,
                          elevation: 5,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Image.asset("images/bluecar.jpg",
                      width: 360, height: 200, fit: BoxFit.fill),
                ],
              ),
            ],
          ),
        ));
  }
}
