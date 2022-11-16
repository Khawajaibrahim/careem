import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class EndRidePage extends StatefulWidget {
  var cusemail;
  var capemail;

  var picklon;

  var picklat;

  var fair;

  var distance;

  EndRidePage({
    Key? key,
    required this.cusemail,
    required this.capemail,
    required this.picklat,
    required this.picklon,
    required this.fair,
    required this.distance,
  }) : super(key: key);

  @override
  State<EndRidePage> createState() => _EndRidePageState();
}

class _EndRidePageState extends State<EndRidePage> {
  String ip = "http://192.168.0.124";

  double rating = 0;

  late SnackBar sb;

  List<Marker> markers = [];

  String droplat = "0", droplon = "0";

  bool accepted = false;

  late TextEditingController rprice = new TextEditingController();

  bool buttonvisible = true;

  double resultedfair = 0;

  bool go = false;

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  Timer? _timer;

  double _start = 20;

  @override
  void initState() {
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

  Future<void> getRideLocation() async {
    try {
      var response = await http
          .post(Uri.parse("$ip/Project/api/Captain/getRideLocation"), body: {
        "email": widget.cusemail,
      });
      if (response.statusCode == 200) {
        print("data posted");
        String _msg = response.body.toString();
        setState(() {
          droplat = _msg.split('""')[0].split("/")[0].split('"')[1];
          droplon = _msg.split('""')[0].split("/")[1];
        });
        print(_msg);
      } else {
        print("data not posted");
      }
    } on Exception catch (_, exp) {}
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Ride In Progress")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Center(
                  child: Text(
                    "Your Ride Will End In ",
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  )),
            ),
            Center(
                child: Text(
                  "$_start  Minutes",
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
                        await getRideLocation();
                        markers.add(Marker(
                            markerId: MarkerId('myMarker'),
                            infoWindow: InfoWindow(title: "Your Point"),
                            position: LatLng(
                                double.parse((widget.picklat).toString()),
                                double.parse((widget.picklon.toString())))));

                        markers.add(Marker(
                            markerId: MarkerId('capMarker'),
                            infoWindow: InfoWindow(title: "Customer Point"),
                            position: LatLng(
                                double.parse(droplat), double.parse(droplon))));
                      },
                    ))),
            Container(
              width: 400,
              height: 60,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () async {
                  _start = 0.0;
                  await getBalance();
                  showBill(context, widget.fair);
                  //       showRating(context);
                },
                child: const Text('End Ride', style: TextStyle(fontSize: 20)),
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

  Future<void> getBalance() async {
    var balanceresponse = await http
        .post(Uri.parse("$ip/Project/api/Captain/getCustomerBalance"), body: {
      "cusemail": widget.cusemail,
    });
    setState(() {
      String decidedridefair = balanceresponse.body;
      resultedfair = double.parse(decidedridefair.split('"')[1]) +
          double.parse(widget.fair);
    });
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
    builder: (context) => SingleChildScrollView(
      child: AlertDialog(
        title: Text("Rate The Customer"),
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
                saveCustomerRating();
              },
              child: Text("OK"))
        ],
      ),
    ),
    context: context,
  );

  Future<void> saveCustomerRating() async {
    try {
      if (rating == 0) {
        sb = SnackBar(content: Text('Please Give A Rating To Customer'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
      } else {
        var response = await http.post(
            Uri.parse("$ip/Project/api/Captain/saveCustomerRating"),
            body: {
              "email": widget.cusemail,
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

  void showBill(BuildContext context, fair) => showDialog(
    builder: (context) => SingleChildScrollView(
      child: AlertDialog(
        title: Text("Bill"),
        insetPadding: EdgeInsets.fromLTRB(40, 150, 40, 150),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("The Total Cost Of Ride= $resultedfair"),
            SizedBox(height: 30),
            TextField(
                controller: rprice,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Enter Received Price",
                  labelText: " Enter Received Price",
                )),
          ],
        ),
        actions: [
          RaisedButton(
              color: buttonvisible ? Colors.indigo : Colors.white,
              onPressed: () async {
                Navigator.pop(context);
                await savebill();
              },
              child: Text("OK"))
        ],
      ),
    ),
    context: context,
  );

  Future<void> savebill() async {
    accepted = false;
    if (rprice.text == "") {
      sb = SnackBar(content: Text('Please Enter The Amount'));
      ScaffoldMessenger.of(context).showSnackBar(sb);
      buttonvisible = true;
    } else {
      var response =
      await http.post(Uri.parse("$ip/Project/api/Captain/saveBill"), body: {
        "cusemail": widget.cusemail,
        "ridefair": resultedfair.toString(),
        "givenfair": rprice.text,
        "capemail": widget.capemail,
      });
      if (response.statusCode == 200) {
        print("Bill Posted");
        var _messsage = response.body.toString();
        print(_messsage);
        sb = SnackBar(content: Text(_messsage));
        ScaffoldMessenger.of(context).showSnackBar(sb);
        while (!accepted) {
          await Future.delayed(Duration(seconds: 5));
          await checkstatus();
        }
      } else {
        sb = SnackBar(content: Text('Something Went Wrong'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
      }
    }
  }

  Future<void> checkstatus() async {
    var response = await http
        .post(Uri.parse("$ip/Project/api/Captain/checkBalanceStatus"), body: {
      "cusemail": widget.cusemail,
      "capemail": widget.capemail,
    });
    if (response.statusCode == 200) {
      var msg = response.body.toString();
      if (msg == '"accept"') {
        setState(() {
          accepted = true;
        });
        sb = SnackBar(content: Text('Customer Agreed With Price Details'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
        updateBalance();

        showRating(context);
      } else {
        if (msg == '"reject"') {
          setState(() {
            accepted = true;
          });
          showBill(context, widget.fair);
          sb = SnackBar(
              content: Text('Customer Reject the Price Plzz Enter Again'));
          ScaffoldMessenger.of(context).showSnackBar(sb);
          buttonvisible = true;
        }
        if (msg == '"wait"') {
          sb = SnackBar(content: Text('Wait For a Customer Response'));
          ScaffoldMessenger.of(context).showSnackBar(sb);
        }
      }
    }
  }

  Future<void> updateBalance() async {
    double sendfair = double.parse(rprice.text) - resultedfair;
    var response = await http.post(
        Uri.parse("$ip/Project/api/Captain/updateCustomerBalance"),
        body: {
          "email": widget.cusemail,
          "balance": sendfair.toString(),
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
