import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'CustomerHomePage.dart';

class CustFinishPage extends StatefulWidget {
  var cusemail;
  var capemail;
  var distance;
  var picklat;
  var picklon;
  var fair;

  var droplon;

  var droplat;

  CustFinishPage({
    Key? key,
    required this.cusemail,
    required this.capemail,
    required this.distance,
    required this.picklat,
    required this.picklon,
    required this.droplat,
    required this.droplon,
    required this.fair,
  }) : super(key: key);

  @override
  State<CustFinishPage> createState() => _CustFinishPageState();
}

class _CustFinishPageState extends State<CustFinishPage> {
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
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Timer test")),
      body: Column(
        children: <Widget>[
          Center(
            child: Container(
              child: Center(
                  child: Text(
                    "You Will Reach Your Destination In",
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
                      markers.add(Marker(
                          markerId: MarkerId('myMarker'),
                          infoWindow: InfoWindow(title: "Source Point"),
                          position: LatLng(double.parse(widget.picklat),
                              double.parse(widget.picklon))));

                      markers.add(Marker(
                          markerId: MarkerId('capMarker'),
                          infoWindow: InfoWindow(title: "Destination Point"),
                          position: LatLng(double.parse(widget.droplat),
                              double.parse(widget.droplon))));
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
                getBill();
              },
              child: const Text('Get Bill', style: TextStyle(fontSize: 20)),
              color: Colors.indigo,
              textColor: Colors.white,
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRating() => RatingBar.builder(
      minRating: 1,
      initialRating: rating,
      itemSize: 46,
      itemBuilder: (context, _) => Icon(Icons.star),
      onRatingUpdate: (rat) => setState(() {
        rating = rat;
      }));

  void showRating(BuildContext context) => showDialog(
    builder: (context) => AlertDialog(
      title: Text("Rate The Captain"),
      insetPadding: EdgeInsets.fromLTRB(40, 150, 40, 150),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Please Leave a Star Rating "),
          SizedBox(height: 30),
          buildRating(),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              saveCaptainrRating();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CustomerHomePage(email: widget.cusemail)));
            },
            child: Text("OK"))
      ],
    ),
    context: context,
  );

  Future<void> saveCaptainrRating() async {
    try {
      if (rating == 0) {
        sb = SnackBar(content: Text('Please Give A Rating To Customer'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
      } else {
        var response = await http.post(
            Uri.parse("$ip/Project/api/Customer/saveCaptainRating"),
            body: {
              "email": widget.capemail,
              "rank": rating.toString(),
            });
        if (response.statusCode == 200) {
          print("data posted");
          var _messsage = response.body.toString();
          print(_messsage);
          sb = SnackBar(content: Text('Feedback is Saved'));
          ScaffoldMessenger.of(context).showSnackBar(sb);
        } else {
          sb = SnackBar(content: Text('Something Went Wrong'));
          ScaffoldMessenger.of(context).showSnackBar(sb);
        }
      }
    } on Exception catch (_, exp) {
      print(exp.toString());
    }
  }

  Future<void> getBill() async {
    try {
      var response = await http
          .post(Uri.parse("$ip/Project/api/Customer/getBillDetail"), body: {
        "capemail": widget.capemail,
        "cusemail": widget.cusemail,
      });
      if (response.statusCode == 200) {
        var m = response.body.toString();
        if (m == '"notfound"') {
          sb = SnackBar(content: Text('WAIT FOR CAPTAIN TO ENTER BILL'));
          ScaffoldMessenger.of(context).showSnackBar(sb);
        } else {
          var ms = response.body.toString();
          setState(() {
            rideprice = ms.split("/")[0].split('"')[1];
            giveprice = ms.split("/")[1].split('"')[0];
          });
          showBill(context);
        }
      }
    } on Exception catch (_, exp) {
      print(exp.toString());
    }
  }

  void showBill(BuildContext context) => showDialog(
    builder: (context) => SingleChildScrollView(
      child: AlertDialog(
        title: Text("Bill"),
        insetPadding: EdgeInsets.fromLTRB(40, 150, 40, 150),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("The Total Cost Of Ride= $rideprice"),
            SizedBox(height: 30),
            Text("The Total Cost You Give= $giveprice"),
          ],
        ),
        actions: [
          RaisedButton(
              color: Colors.indigo,
              onPressed: () async {
                Navigator.pop(context);
                await acceptBill();
              },
              child: Text("Accept")),
          RaisedButton(
              color: Colors.indigo,
              onPressed: () async {
                Navigator.pop(context);
                await rejectBill();
              },
              child: Text("Reject"))
        ],
      ),
    ),
    context: context,
  );

  Future<void> rejectBill() async {
    var response = await http
        .post(Uri.parse("$ip/Project/api/Customer/rejectBill"), body: {
      "capemail": widget.capemail,
      "cusemail": widget.cusemail,
    });
    if (response.statusCode == 200) {
      sb = SnackBar(content: Text('Bill Has Been Rejected'));
      ScaffoldMessenger.of(context).showSnackBar(sb);
    } else {
      sb = SnackBar(content: Text('Bill Cannot Be Rejected'));
      ScaffoldMessenger.of(context).showSnackBar(sb);
    }
  }

  Future<void> acceptBill() async {
    var response = await http
        .post(Uri.parse("$ip/Project/api/Customer/acceptBill"), body: {
      "capemail": widget.capemail,
      "cusemail": widget.cusemail,
    });
    if (response.statusCode == 200) {
      sb = SnackBar(content: Text('Bill Has Been Accepted'));
      ScaffoldMessenger.of(context).showSnackBar(sb);
      showRating(context);
    } else {
      sb = SnackBar(content: Text('Bill Cannot Be Accepted'));
      ScaffoldMessenger.of(context).showSnackBar(sb);
    }
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }
}
