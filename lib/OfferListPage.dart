import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:math';
import 'CapRidePage.dart';

class OfferListPage extends StatefulWidget {
  var email;
  var clat;
  var clon;

  OfferListPage(
      {Key? key, required this.email, required this.clat, required this.clon})
      : super(key: key);

  @override
  State<OfferListPage> createState() => _OfferListPageState();
}

class _OfferListPageState extends State<OfferListPage> {
  bool loop = true;
  late SnackBar sb;
  int length = 0;
  final List<TextEditingController> _offer = [];
  String ip = "http://192.168.0.124";

  Future<List<dynamic>> getCustomerOffer() async {
    var jsonResult;
    var response = await http
        .post(Uri.parse("$ip/Project/api/Customer/getCustomer"), body: {
      "capEmail": widget.email,
    });
    if (response.statusCode == 202) {
      length = 0;
      var s = response.body.toString();
      String em = s.split('/')[0].split('"')[1];
      String dist = s.split('/')[1];
      String fair = s.split('/')[2].split('"')[0];
      sb = SnackBar(content: Text('Your Offer Accepted By $s'));
      ScaffoldMessenger.of(context).showSnackBar(sb);
      setState(() {
        loop = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CapRidePage(
                capemail: widget.email,
                cusemail: em,
                distance: dist,
                caplat: widget.clat,
                caplon: widget.clon,
                fair: fair,
              )));
      return [];
    }
    if (response.statusCode == 200) {
      print("getting output");
      jsonResult = convert.jsonDecode(response.body);
      print(jsonResult);
      length = jsonResult.length;
      return jsonResult;
    } else {
      print("offer not found");
      var _message = response.body.toString();
      sb =
          SnackBar(content: Text('There is no Offer at this time please wait'));
      ScaffoldMessenger.of(context).showSnackBar(sb);
    }

    return [];
  }

  Stream<List<dynamic>> getOffer() async* {
    while (loop) {
      await Future.delayed(Duration(seconds: 5));
      yield await getCustomerOffer();
    }
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Offers '),
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: getOffer(),
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
                                  snapshot.data![index]["cusEmail"].toString(),
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.indigo)),
                              title: Text(
                                  snapshot.data![index]["distance"].toString() +
                                      " KM ",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.red)),
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
                                  "Customer Offered Price:",
                                  style: TextStyle(color: Colors.indigo),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  width: 120,
                                  child: Text(
                                      snapshot.data![index]["cusFair"]
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 18)),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                    acceptRequest(
                                        widget.email,
                                        snapshot.data![index]["cusEmail"]
                                            .toString(),
                                        snapshot.data![index]["cusFair"]
                                            .toString(),
                                        snapshot.data![index]["distance"]
                                            .toString());
                                  },
                                  child: const Text('Accept',
                                      style: TextStyle(fontSize: 18)),
                                  color: Colors.indigo,
                                  textColor: Colors.white,
                                  elevation: 5,
                                ),
                                SizedBox(width: 20),
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                    deleteRequest(
                                        widget.email,
                                        snapshot.data![index]["cusEmail"]
                                            .toString(),
                                        _offer[index].text);
                                  },
                                  child: const Text('Reject',
                                      style: TextStyle(fontSize: 15)),
                                  color: Colors.indigo,
                                  textColor: Colors.white,
                                  elevation: 5,
                                ),
                                SizedBox(width: 20),
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                    postFair(
                                        widget.email,
                                        snapshot.data![index]["cusEmail"]
                                            .toString(),
                                        _offer[index].text);
                                  },
                                  child: const Text('Offer',
                                      style: TextStyle(fontSize: 15)),
                                  color: Colors.indigo,
                                  textColor: Colors.white,
                                  elevation: 5,
                                ),
                              ],
                            ),
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

  Future<void> postFair(String capEmail, String cusEmail, String fair) async {
    try {
      var response = await http.post(
          Uri.parse("$ip/Project/api/Careem/addCaptainDeal"),
          body: {"capEmail": capEmail, "cusEmail": cusEmail, "capFair": fair});
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

  Future<void> deleteRequest(
      String capEmail, String cusEmail, String fair) async {
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

  Future<void> acceptRequest(
      String capEmail, String cusEmail, String fair, String distance) async {
    if (fair == "Not Offered") {
      sb = SnackBar(content: Text('Wait For Customer Offer'));
      ScaffoldMessenger.of(context).showSnackBar(sb);
    } else {
      var response = await http.post(
          Uri.parse("$ip/Project/api/Careem/dealAcceptCap"),
          body: {"cusEmail": cusEmail, "capEmail": capEmail, "capFair": fair});
      if (response.statusCode == 200) {
        var _messsage = response.body.toString();
        sb = SnackBar(content: Text('$_messsage'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
        // Navigator.push(
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

  @override
  dispose() async {
    super.dispose();
    loop = false;
    // await http.post(Uri.parse("$ip/Project/api/Captain/deleteCaptain"),
    //     body: {"cusEmail": widget.email});
    // TODO: implement dispose
  }
}
