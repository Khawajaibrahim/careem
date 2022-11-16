import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'CaptainList.dart';
import 'CarSelectionPage.dart';

class DropOffLocationPage extends StatefulWidget {
  var p_lon;
  var p_lat;
  var email;
  DropOffLocationPage(
      {Key? key, required this.p_lat, required this.p_lon, required this.email})
      : super(key: key);

  @override
  State<DropOffLocationPage> createState() => _DropOffLocationPageState();
}

class _DropOffLocationPageState extends State<DropOffLocationPage> {
  var mystyle = TextStyle(fontSize: 15);
  List<Marker> markers = [];
  LatLng? dpoint;
  late SnackBar sb;
  var d, cd;
  var dlat, dlon;
  String ip = "http://192.168.0.124";
  Future<void> Distance(var lat1, var long1, var lat2, var long2) async {
    try {
      var response = await http
          .post(Uri.parse("$ip/Project/api/Careem/DistanceCalculate"), body: {
        "plat": lat1.toString(),
        "plon": long1.toString(),
        "dlat": lat2.toString(),
        "dlon": long2.toString(),
      });
      if (response.statusCode == 200) {
        print("data posted");
        var _messsage = response.body.toString();
        print(_messsage);
        setState(() {
          d = _messsage;
        });
      } else {
        print("data not posted");
        // var _message = response.body.toString();
        // sb = SnackBar(content: Text('$_message'));
      }
    } on Exception catch (_, exp) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('SELECT YOUR DROPOFF POINT',
              style: TextStyle(fontSize: 16)),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 1),
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 358,
                      color: Colors.blue.shade600,
                      child: Text(
                        "    Your Total Distance =$d KM",
                        style: TextStyle(fontSize: 18, color: Colors.white70),
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                  ],
                ),
                Container(
                    height: 530,
                    width: 400,
                    color: Colors.black12,
                    child: Center(
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(33.64352174389097, 73.0776060372591),
                              zoom: 14),
                          markers: Set.from(markers),
                          onMapCreated: (GoogleMapController controller) {},
                          onTap: (LatLng latlng) {
                            setState(() {
                              print("$latlng yeh wala");
                              dlat = latlng.latitude;
                              dlon = latlng.longitude;
                              print(dpoint);
                              print(dlat);
                              print(dlon);
                              d = Distance(widget.p_lat, widget.p_lon, dlat, dlon);
                              // sb = SnackBar(content: Text('$d'));
                              // ScaffoldMessenger.of(context).showSnackBar(sb);
                              markers:
                              markers.add(Marker(
                                  markerId: MarkerId('myMarker'),
                                  draggable: true,
                                  position:
                                  LatLng(latlng.latitude, latlng.longitude)));
                            });
                          },
                        ))),
                SizedBox(height: 10),
                Container(
                  width: 400,
                  height: 60,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      if (dlat == null || dlon == null) {
                        sb = SnackBar(
                            content: Text('Give Your Destination Point'));
                        ScaffoldMessenger.of(context).showSnackBar(sb);
                      } else {
                        postLocation();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CarSelectionPage(
                                    plat: widget.p_lat,
                                    plon: widget.p_lon,
                                    dlat: dlat.toString(),
                                    dlon: dlon.toString(),
                                    email: widget.email)));
                      }
                    },
                    child:
                    const Text('Confirm', style: TextStyle(fontSize: 20)),
                    color: Colors.indigo,
                    textColor: Colors.white,
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> postLocation() async {
    try {
      var response = await http.post(
          Uri.parse("$ip/Project/api/Customer/updateCustomerLocation"),
          body: {
            "email": widget.email,
            "plat": widget.p_lat.toString(),
            "plon": widget.p_lon.toString(),
            "dlat": dlat.toString(),
            "dlon": dlon.toString(),
          });
      if (response.statusCode == 200) {
        var _messsage = response.body.toString();
        sb = SnackBar(content: Text('$_messsage'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => CaptainHomePage()));
      } else {
        var _message = response.body.toString();
        sb = SnackBar(content: Text('$_message'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
      }
    } on Exception catch (_, exp) {}
  }
}
