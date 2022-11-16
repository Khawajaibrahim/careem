import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:math';
import 'dart:async';
import 'CustRidePage.dart';

class CaptainList extends StatefulWidget {
  var plat;
  var plon;
  var email;
  var pfast;
  var psmoke;
  var category;

  var dlat;

  var dlon;

  CaptainList({
    Key? key,
    required this.plat,
    required this.plon,
    required this.dlat,
    required this.dlon,
    required this.email,
    required this.psmoke,
    required this.pfast,
    required this.category,
  }) : super(key: key);

  @override
  State<CaptainList> createState() => _CaptainListState();
}

class _CaptainListState extends State<CaptainList> {
  bool loop = true;

  int length = 0;

  final _fair = TextEditingController();

  final List<TextEditingController> _offer = [];

  static List<dynamic> jsonResult = [];

  late SnackBar sb;

  String ip = "http://192.168.0.124";

  Future<List<dynamic>> getCaptains() async {
    try {
      var response = await http
          .post(Uri.parse("$ip/Project/api/Captain/GetActiveCaptains"), body: {
        "email": widget.email,
        "clat": widget.plat,
        "clon": widget.plon,
        "category": widget.category,
        "pfast": widget.pfast,
        "psmoke": widget.psmoke,
      });
      if (response.statusCode == 202) {
        length = 0;
        var s = response.body.toString();
        String em = s.split('/')[0].split('"')[1];
        String dist = s.split('/')[1];
        String fair = s.split('/')[2].split('"')[0];
        sb = SnackBar(content: Text('Your Offer Accepted By $em'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
        setState(() {
          loop = false;
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => RidePage(
                  cusemail: widget.email,
                  capemail: em,
                  distance: dist,
                  picklat: widget.plat,
                  picklon: widget.plon,
                  dlat: widget.dlat,
                  dlon: widget.dlon,
                  fair: fair,
                )));
        return [];
      }
      if (response.statusCode == 200) {
        print("getting output");
        jsonResult = convert.jsonDecode(response.body) as List<dynamic>;
        print(jsonResult);
        length = jsonResult.length;
        return jsonResult;
      } else {
        print("data not posted");
        // var _message = response.body.toString();
        // sb = SnackBar(content: Text('$_message'));
      }
    } on Exception catch (_, exp) {}
    return [];
  }

  Stream<List<dynamic>> getCaptainsList() async* {
    while (loop) {
      await Future.delayed(Duration(seconds: 5));
      yield await getCaptains();
    }
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Captain '),
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: getCaptainsList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount: length,
                itemBuilder: (context, index) {
                  _offer.add(new TextEditingController());
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      color: Colors.grey.shade400,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Text(
                                  snapshot.data![index]["capEmail"].toString(),
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.indigo)),
                              title: Text(
                                  snapshot.data![index]["distance"].toString() +
                                      " KM ",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.red)),
                            ),
                            Text(
                                "Rating: " +
                                    snapshot.data![index]["rank"].toString(),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.indigo)),
                            Row(
                              children: [
                                Text(
                                  "Offer Your Price:",
                                  style: TextStyle(color: Colors.indigo),
                                ),
                                SizedBox(width: 57),
                                Container(
                                  width: 120,
                                  child: TextField(
                                    controller: _offer[index],
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text(
                                  "Captain Offered Price:",
                                  style: TextStyle(color: Colors.indigo),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  width: 120,
                                  child: Text(
                                      snapshot.data![index]["capFair"]
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 18)),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                SizedBox(width: 20),
                                Container(
                                  width: 130,
                                  height: 40,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    onPressed: () {
                                      acceptRequest(
                                        widget.email,
                                        snapshot.data![index]["capEmail"]
                                            .toString(),
                                        snapshot.data![index]["capFair"]
                                            .toString(),
                                        snapshot.data![index]["distance"]
                                            .toString(),
                                      );
                                    },
                                    child: const Text('Accept',
                                        style: TextStyle(fontSize: 18)),
                                    color: Colors.indigo,
                                    textColor: Colors.white,
                                    elevation: 5,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  width: 130,
                                  height: 40,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    onPressed: () {
                                      deleteRequest(
                                          widget.email,
                                          snapshot.data![index]["capEmail"]
                                              .toString(),
                                          _offer[index].text);
                                    },
                                    child: const Text('Reject',
                                        style: TextStyle(fontSize: 18)),
                                    color: Colors.indigo,
                                    textColor: Colors.white,
                                    elevation: 5,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(width: 20),
                                Container(
                                  height: 40,
                                  width: 130,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    onPressed: () {
                                      postFair(
                                          widget.email,
                                          snapshot.data![index]["capEmail"]
                                              .toString(),
                                          _offer[index].text);
                                    },
                                    child: const Text('Offer',
                                        style: TextStyle(fontSize: 18)),
                                    color: Colors.indigo,
                                    textColor: Colors.white,
                                    elevation: 5,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  height: 40,
                                  width: 130,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    onPressed: () {
                                      postDeclineFair(
                                        widget.email,
                                        snapshot.data![index]["capEmail"]
                                            .toString(),
                                        " Your Offer Is Declined On " +
                                            snapshot.data![index]["capFair"]
                                                .toString(),
                                      );
                                    },
                                    child: const Text('Decline Price',
                                        style: TextStyle(fontSize: 14)),
                                    color: Colors.indigo,
                                    textColor: Colors.white,
                                    elevation: 5,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }

  Future<void> postFair(String cusEmail, String capEmail, String fair) async {
    try {
      if (fair == "") {
        sb = SnackBar(content: Text('Enter Amount To Offer'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
      } else {
        var response = await http
            .post(Uri.parse("$ip/Project/api/Careem/addCustomerDeal"), body: {
          "cusEmail": cusEmail,
          "capEmail": capEmail,
          "cusFair": fair
        });
        if (response.statusCode == 200) {
          var _messsage = response.body.toString();
          sb = SnackBar(content: Text('$_messsage'));
          ScaffoldMessenger.of(context).showSnackBar(sb);
        } else {
          var _messsage = response.body.toString();
          sb = SnackBar(content: Text('$_messsage'));
          ScaffoldMessenger.of(context).showSnackBar(sb);
        }
      }
    } on Exception catch (_, exp) {}
  }

  Future<void> postDeclineFair(
      String cusEmail, String capEmail, String fair) async {
    try {
      if (fair == " Your Offer Is Declined On Not Offered") {
        sb = SnackBar(content: Text('First Wait For Captain Offer'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
      } else {
        var response = await http
            .post(Uri.parse("$ip/Project/api/Careem/declineDeal"), body: {
          "cusEmail": cusEmail,
          "capEmail": capEmail,
          "cusFair": fair
        });
        if (response.statusCode == 200) {
          var _messsage = response.body.toString();
          sb = SnackBar(content: Text('$_messsage'));
          ScaffoldMessenger.of(context).showSnackBar(sb);
        } else {
          var _messsage = response.body.toString();
          sb = SnackBar(content: Text('$_messsage'));
          ScaffoldMessenger.of(context).showSnackBar(sb);
        }
      }
    } on Exception catch (_, exp) {}
  }

  Future<void> acceptRequest(
      String cusEmail, String capEmail, String fair, String distance) async {
    if (fair == "Not Offered") {
      sb = SnackBar(content: Text('Wait For Captain Offer'));
      ScaffoldMessenger.of(context).showSnackBar(sb);
    } else {
      var response = await http.post(
          Uri.parse("$ip/Project/api/Careem/dealAcceptCus"),
          body: {"cusEmail": cusEmail, "capEmail": capEmail, "capFair": fair});
      if (response.statusCode == 200) {
        var _messsage = response.body.toString();
        sb = SnackBar(content: Text('$_messsage'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => RidePage(
        //               capemail: capEmail,
        //               cusemail: cusEmail,
        //               distance: distance,
        //             )));
      } else {
        sb = SnackBar(
            content: Text('You Cannot Accept Please Wait For Captain Reply'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
      }
    }
  }

  Future<void> deleteRequest(
      String cusEmail, String capEmail, String fair) async {
    try {
      var response = await http.post(
          Uri.parse("$ip/Project/api/Careem/deleteOffer"),
          body: {"cusEmail": cusEmail, "capEmail": capEmail});
      if (response.statusCode == 200) {
        var _messsage = response.body.toString();
        sb = SnackBar(content: Text('$_messsage'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
      } else {
        var _messsage = response.body.toString();
        sb = SnackBar(content: Text('$_messsage'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
      }
    } on Exception catch (_, exp) {}
  }

  @override
  dispose() async {
    super.dispose();
    loop = false;
    // TODO: implement dispose
  }
}
