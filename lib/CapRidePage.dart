import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'EndRidePage.dart';

class CapRidePage extends StatefulWidget {
  var cusemail;
  var capemail;
  var distance;

  var caplon;

  var caplat;

  var fair;

  CapRidePage({
    Key? key,
    required this.cusemail,
    required this.capemail,
    required this.distance,
    required this.caplat,
    required this.caplon,
    required this.fair,
  }) : super(key: key);

  @override
  State<CapRidePage> createState() => _CapRidePageState();
}

class _CapRidePageState extends State<CapRidePage> {
  String ip = "http://192.168.0.124";
  bool go = false;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  Timer? _timer;
  double _start = 10;
  String cuslat = "0", cuslon = "0";
  List<Marker> markers = [];
  String dist = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _start = (double.parse(widget.distance) * 5).ceilToDouble();
    const onemin = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      onemin,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            go = true;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Future<void> getCustomerLocation() async {
    try {
      var response = await http.post(
          Uri.parse("$ip/Project/api/Captain/getCustomerLocation"),
          body: {
            "email": widget.cusemail,
          });
      if (response.statusCode == 200) {
        print("data posted");
        String _msg = response.body.toString();
        setState(() {
          cuslat = _msg.split('""')[0].split("/")[0].split('"')[1];
          cuslon = _msg.split('""')[0].split("/")[1].split('"')[0];
        });
        print(_msg);
      } else {
        print("data not posted");
      }
    } on Exception catch (_, exp) {}
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Captain Ride Page")),
      body: Column(
        children: <Widget>[
          Container(
            child: Center(
                child: Text(
                  "You Can Start Ride In ",
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                )),
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
                      await getCustomerLocation();
                      markers.add(Marker(
                          markerId: MarkerId('myMarker'),
                          icon: BitmapDescriptor.defaultMarker,
                          infoWindow: InfoWindow(title: "Your Point"),
                          position: LatLng(double.parse((widget.caplat).toString()),
                              double.parse((widget.caplon).toString()))));

                      markers.add(Marker(
                          markerId: MarkerId('capMarker'),
                          infoWindow: InfoWindow(title: "Customer Point"),
                          icon: BitmapDescriptor.defaultMarker,
                          position:
                          LatLng(double.parse(cuslat), double.parse(cuslon))));
                    },
                  ))),
          Container(
            width: 400,
            height: 60,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: go
                  ? () async {
                await getDistance();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EndRidePage(
                          capemail: widget.capemail,
                          cusemail: widget.cusemail,
                          picklat: cuslat,
                          picklon: cuslon,
                          fair: widget.fair,
                          distance: dist,
                        )));
              }
                  : null,
              child: const Text('Start', style: TextStyle(fontSize: 20)),
              color: Colors.indigo,
              textColor: Colors.white,
              elevation: 5,
            ),
          ),
        ],
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

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }
}
