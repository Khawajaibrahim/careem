import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart' as http;
import 'OfferListPage.dart';


class StandPointPage extends StatefulWidget {
  var email;

  StandPointPage({Key? key, required this.email}) : super(key: key);

  @override
  State<StandPointPage> createState() => _StandPointPageState();
}

class _StandPointPageState extends State<StandPointPage> {
  var mystyle = TextStyle(fontSize: 15);
  List<Marker> markers = [];
  bool status = false;
  LatLng? ppoint;
  var clat, clon;
  late SnackBar sb;
  String ip = "http://192.168.0.124";

  activestatus(bool stat) async {
    var response = await http
        .post(Uri.parse("$ip/Project/api/Captain/updateStatus"), body: {
      "email": widget.email,
      "status": stat.toString(),
    });
    if (response.statusCode == 200) {
      var _messsage = response.body.toString();
      sb = SnackBar(content: Text('$_messsage'));
      ScaffoldMessenger.of(context).showSnackBar(sb);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: new AppBar(
      //   title: new Text('SELECT YOUR PICKUP POINT',
      //       style: TextStyle(fontSize: 16)),
      // ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 60,
                  color: Colors.indigo,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        width: 29,
                      ),
                      Text("SET YOUR STATUS",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 2, 2, 0),
                        child: FlutterSwitch(
                          width: 80.0,
                          height: 35.0,
                          valueFontSize: 15.0,
                          toggleSize: 45.0,
                          value: status,
                          borderRadius: 30.0,
                          padding: 8.0,
                          showOnOff: true,
                          onToggle: (val) {
                            setState(() {
                              status = val;
                            });
                            activestatus(status);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    height: 640,
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
                            if (status == true) {
                              setState(() {
                                ppoint = latlng;
                                print(ppoint);
                                clat = latlng.latitude;
                                clon = latlng.longitude;
                                postLocation();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OfferListPage(
                                        clat: clat,
                                        clon: clon,
                                        email: widget.email,
                                      )),
                                );
                                markers:
                                markers.add(Marker(
                                    markerId: MarkerId('myMarker'),
                                    draggable: true,
                                    position:
                                    LatLng(latlng.latitude, latlng.longitude)));
                              });
                            } else {
                              sb = SnackBar(
                                  content: Text('Set Your Status Active First'));
                              ScaffoldMessenger.of(context).showSnackBar(sb);
                            }
                          },
                        ))),
                SizedBox(height: 10),
              ],
            ),
          ),
        ));
  }

  Future<void> postLocation() async {
    try {
      var response = await http
          .post(Uri.parse("$ip/Project/api/Captain/updateLocation"), body: {
        "email": widget.email,
        "clat": clat.toString(),
        "clon": clon.toString(),
        "status": "true",
      });
      if (response.statusCode == 200) {
        var _messsage = response.body.toString();
        sb = SnackBar(content: Text('$_messsage'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
      } else {
        var _message = response.body.toString();
        sb = SnackBar(content: Text('$_message'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
      }
    } on Exception catch (_, exp) {}
  }
}
