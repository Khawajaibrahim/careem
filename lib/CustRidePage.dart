import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'CustFinishPage.dart';
import 'CustomerHomePage.dart';

class RidePage extends StatefulWidget {
  var cusemail;
  var capemail;
  var distance;
  var picklat;
  var picklon;
  var fair;

  var dlat;

  var dlon;

  RidePage({
    Key? key,
    required this.cusemail,
    required this.capemail,
    required this.distance,
    required this.picklat,
    required this.picklon,
    required this.dlat,
    required this.dlon,
    required this.fair,
  }) : super(key: key);

  @override
  State<RidePage> createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> {
  String ip = "http://192.168.0.124";
  List<Marker> markers = [];
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  Timer? _timer;
  double _start = 10;
  String caplat = "0", caplon = "0";
  late SnackBar sb;
  double rating = 0;
  String rideprice = "0";
  String giveprice = "0";
  String dist = "10";
  int count = 0;
  Future<void> getCaptainLocation() async {
    try {
      var response = await http.post(
          Uri.parse("$ip/Project/api/Customer/getCaptainLocation"),
          body: {
            "email": widget.capemail,
          });
      if (response.statusCode == 200) {
        print("data posted");
        String _msg = response.body.toString();
        setState(() {
          caplat = _msg.split('""')[0].split("/")[0].split('"')[1];
          caplon = _msg.split('""')[0].split("/")[1].split('"')[0];
        });
        print(_msg);
      } else {
        print("data not posted");
      }
    } on Exception catch (_, exp) {}
  }

  @override
  void initState() {
    _start = (double.parse(widget.distance) * 5).ceilToDouble();
    super.initState();
    const onemin = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      onemin,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CustFinishPage(
                    cusemail: widget.cusemail,
                    capemail: widget.capemail,
                    distance: dist,
                    picklat: widget.picklat,
                    picklon: widget.picklon,
                    droplat: widget.dlat,
                    droplon: widget.dlon,
                    fair: widget.fair,
                  )));
        } else {
          setState(() {
            _start--;
            count++;
          });
        }
      },
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Wait Fot Captain")),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                child: Center(
                    child: Text(
                      "Captain Will Reach To You in ",
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    )),
              ),
            ),
            Center(
                child: Text(
                  "$_start  Minute",
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                )),
            Container(
                height: 500,
                width: 400,
                color: Colors.black12,
                child: Center(
                    child: GoogleMap(
                      markers: Set.from(markers),
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(33.64352174389097, 73.0776060372591),
                          zoom: 14),
                      onMapCreated: (GoogleMapController controller) async {
                        await getCaptainLocation();
                        await getDistance();
                        markers.add(Marker(
                            markerId: MarkerId('myMarker'),
                            infoWindow: InfoWindow(title: "Your Point"),
                            position: LatLng(double.parse(widget.picklat),
                                double.parse(widget.picklon))));

                        markers.add(Marker(
                            markerId: MarkerId('capMarker'),
                            infoWindow: InfoWindow(title: "Captain Point"),
                            position: LatLng(
                                double.parse(caplat), double.parse(caplon))));
                      },
                    ))),
            SizedBox(height: 10),
            Container(
              height: 70,
              width: 355,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  _start = -1;
                  if (count > 1) {
                    showCancelDialog(context);
                  } else {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerHomePage(
                              email: widget.cusemail,
                            )));
                  }
                },
                child:
                const Text('Cancel Ride', style: TextStyle(fontSize: 16)),
                color: Colors.indigo,
                textColor: Colors.white,
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getDistance() async {
    try {
      var response = await http
          .post(Uri.parse("$ip/Project/api/Captain/getRideLocation"), body: {
        "email": widget.cusemail,
      });
      if (response.statusCode == 200) {
        String _msg = response.body.toString();
        setState(() {
          dist = _msg.split('""')[0].split("/")[2].split('"')[0];
        });
        print(_msg);
      } else {
        print("data not posted");
      }
    } on Exception catch (_, exp) {}
  }

  void showCancelDialog(BuildContext context) => showDialog(
    builder: (context) => SingleChildScrollView(
      child: AlertDialog(
        title: Text("Are You Sure?"),
        insetPadding: EdgeInsets.fromLTRB(40, 150, 40, 150),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Extra Charges Will Be Deducted For Cancelling Ride"),
            SizedBox(height: 30),
          ],
        ),
        actions: [
          RaisedButton(
              color: Colors.indigo,
              onPressed: () async {
                Navigator.pop(context);
                await deductBalance();
              },
              child: Text("OK"))
        ],
      ),
    ),
    context: context,
  );

  Future<void> deductBalance() async {
    var response = await http
        .post(Uri.parse("$ip/Project/api/Customer/deductBalance"), body: {
      "email": widget.cusemail,
    });
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CustomerHomePage(
                email: widget.cusemail,
              )));
    }
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }
}
