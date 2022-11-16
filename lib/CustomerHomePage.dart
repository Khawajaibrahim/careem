import 'package:flutter/material.dart';
import 'CustDrawer.dart';
import 'PickupLocationPage.dart';

//import 'PreviousRidePage.dart';
import 'SchedulePage.dart';

class CustomerHomePage extends StatefulWidget {
  var email;

  CustomerHomePage({Key? key, required this.email}) : super(key: key);
  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  var mystyle = TextStyle(fontSize: 20);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text(
              'Careem Replica',
            ),
          ),
        ),
        drawer: CustDrawer(
          email: widget.email,
        ),
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
                      SizedBox(width: 40),
                      Container(
                          child: Image.asset('images/car.jpg',
                              height: 100, width: 100, fit: BoxFit.fill)),
                      SizedBox(width: 40),
                      Image.asset(
                        'images/schedule.jpg',
                        height: 100,
                        width: 100,
                      ),
                      SizedBox(width: 20),
                      // Image.asset(
                      //   'images/view.png',
                      //   height: 100,
                      //   width: 100,
                      //   fit: BoxFit.fill,
                      // ),
                    ]),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 45),
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
                                  builder: (context) => PickupLocationPage(
                                    email: widget.email,
                                  )),
                            );
                          },
                          child: const Text('Book Ride',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11)),
                          textColor: Colors.white,
                          color: Colors.indigo,
                          elevation: 5,
                        ),
                      ),
                      SizedBox(width: 50),
                      Container(
                        height: 50,
                        width: 100,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SchedulePage(
                                    email: null,
                                  )),
                            );
                          },
                          child: const Text('Set Schedule',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11)),
                          textColor: Colors.white,
                          color: Colors.indigo,
                          elevation: 5,
                        ),
                      ),
                      SizedBox(width: 20),
                      // Container(
                      //   width: 100,
                      //   height: 50,
                      //   child: RaisedButton(
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(20)),
                      //     onPressed: () {
                      //       //   Navigator.push(context, MaterialPageRoute(builder: (context)=>PreviousRidePage()),
                      //       //   );
                      //     },
                      //     child: const Text('Previous Rides',
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(fontSize: 11)),
                      //     textColor: Colors.white,
                      //     elevation: 5,
                      //     color: Colors.indigo,
                      //   ),
                      // ),
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
