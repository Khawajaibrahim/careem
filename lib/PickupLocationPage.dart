import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'DropoffLocationPage.dart';

class PickupLocationPage extends StatefulWidget {
  var email;
  PickupLocationPage({Key? key, required this.email}) : super(key: key);
  @override
  State<PickupLocationPage> createState() => _PickupLocationPageState();
}

class _PickupLocationPageState extends State<PickupLocationPage> {
  var mystyle = TextStyle(fontSize: 15);
  List<Marker> markers = [];
  LatLng? ppoint;
  var plat, plon;
  late SnackBar sb;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('SELECT YOUR PICKUP POINT',
              style: TextStyle(fontSize: 16)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 5),
              Container(
                  height: 570,
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
                            ppoint = latlng;
                            print(ppoint);
                            plat = latlng.latitude;
                            plon = latlng.longitude;
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
                    if (ppoint == null) {
                      sb = SnackBar(content: Text('Give Your Pickup Point'));
                      ScaffoldMessenger.of(context).showSnackBar(sb);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DropOffLocationPage(
                                p_lat: plat.toString(),
                                p_lon: plon.toString(),
                                email: widget.email)),
                      );
                    }
                  },
                  child: const Text('Confirm', style: TextStyle(fontSize: 20)),
                  color: Colors.indigo,
                  textColor: Colors.white,
                  elevation: 5,
                ),
              ),
            ],
          ),
        ));
  }
}
