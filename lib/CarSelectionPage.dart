import 'package:flutter/material.dart';
import 'CapRidePage.dart';
import 'CaptainList.dart';

class CarSelectionPage extends StatefulWidget {
  var plat;
  var plon;
  var email;

  var dlat;

  var dlon;

  CarSelectionPage({
    Key? key,
    required this.plat,
    required this.plon,
    required this.dlat,
    required this.dlon,
    required this.email,
  }) : super(key: key);

  @override
  State<CarSelectionPage> createState() => _CarSelectionPageState();
}

class _CarSelectionPageState extends State<CarSelectionPage> {
  var category = '';
  bool smok = true;
  bool ride = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Select Your Requirements'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                color: Colors.indigo,
                child: Text(
                  "Select The Preffered Habits In Captain",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 71),
                  Container(
                    child: Text("Smoker",
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                  SizedBox(width: 10),
                  Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.indigo,
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
                  SizedBox(width: 70),
                  Container(
                    child: Text("Fast Rider",
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                  Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.indigo,
                      value: this.ride,
                      onChanged: (son) {
                        setState(() {
                          this.ride = son!;
                          print(ride);
                        });
                      })
                ],
              ),
              SizedBox(width: 20),
              Divider(color: Colors.black),
              Container(
                color: Colors.indigo,
                child: Text("Select The Car Type",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              SizedBox(height: 20),
              Row(children: [
                SizedBox(width: 20),
                Container(
                  height: 130,
                  width: 145,
                  child: Image.asset('images/bike.jpg', fit: BoxFit.fill),
                ),
                SizedBox(width: 30),
                Container(
                  height: 130,
                  width: 145,
                  child: Image.asset('images/mini.jpg', fit: BoxFit.fill),
                )
              ]),
              SizedBox(height: 20),
              Row(children: [
                SizedBox(width: 35),
                Container(
                  height: 40,
                  width: 125,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () {
                      category = 'bike';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CaptainList(
                              email: widget.email,
                              plat: widget.plat,
                              plon: widget.plon,
                              dlat: widget.dlat,
                              dlon: widget.dlon,
                              category: category,
                              psmoke: smok ? "yes" : "no",
                              pfast: ride ? "yes" : "no",
                            )),
                      );
                    },
                    child: const Text('BIKE', style: TextStyle(fontSize: 15)),
                    color: Colors.indigo,
                    textColor: Colors.white,
                    elevation: 5,
                  ),
                ),
                SizedBox(width: 40),
                Container(
                  height: 40,
                  width: 125,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () {
                      category = 'mini';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CaptainList(
                              email: widget.email,
                              plat: widget.plat,
                              plon: widget.plon,
                              dlat: widget.dlat,
                              dlon: widget.dlon,
                              psmoke: smok ? "yes" : "no",
                              pfast: ride ? "yes" : "no",
                              category: category,
                            )),
                      );
                    },
                    child: const Text('MINI', style: TextStyle(fontSize: 15)),
                    color: Colors.indigo,
                    textColor: Colors.white,
                    elevation: 5,
                  ),
                ),
              ]),
              SizedBox(height: 50),
              Row(children: [
                SizedBox(width: 20),
                Container(
                  child: Image.asset('images/bussiness.jpg', fit: BoxFit.fill),
                  height: 120,
                  width: 145,
                ),
                SizedBox(width: 30),
                Container(
                  child: Image.asset('images/luxury.jpg', fit: BoxFit.fill),
                  height: 120,
                  width: 145,
                )
              ]),
              SizedBox(height: 20),
              Row(children: [
                SizedBox(width: 35),
                Container(
                  height: 40,
                  width: 125,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () {
                      category = 'bussiness';

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CaptainList(
                              email: widget.email,
                              plat: widget.plat,
                              plon: widget.plon,
                              dlat: widget.dlat,
                              dlon: widget.dlon,
                              category: category,
                              psmoke: smok ? "yes" : "no",
                              pfast: ride ? "yes" : "no",
                            )),
                      );
                    },
                    child:
                    const Text('BUSSINESS', style: TextStyle(fontSize: 15)),
                    color: Colors.indigo,
                    textColor: Colors.white,
                    elevation: 5,
                  ),
                ),
                SizedBox(width: 40),
                Container(
                  height: 40,
                  width: 125,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () {
                      category = 'luxury';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CaptainList(
                              email: widget.email,
                              plat: widget.plat,
                              plon: widget.plon,
                              dlat: widget.dlat,
                              dlon: widget.dlon,
                              category: category,
                              psmoke: smok ? "yes" : "no",
                              pfast: ride ? "yes" : "no",
                            )),
                      );
                    },
                    child: const Text('LUXURY', style: TextStyle(fontSize: 15)),
                    color: Colors.indigo,
                    textColor: Colors.white,
                    elevation: 5,
                  ),
                ),
              ]),
            ],
          ),
        ));
  }
}
