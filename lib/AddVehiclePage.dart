import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'CaptainHomePage.dart';
import 'LoginPage.dart';

class AddVehiclePage extends StatefulWidget {
  String email;
  AddVehiclePage({Key? key, required this.email}) : super(key: key);
  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final _lname = TextEditingController();
  bool value = true;
  late SnackBar sb;
  String selectedValue = "no";
  final _name = TextEditingController();
  final _number = TextEditingController();
  final _color = TextEditingController();
  final _cc = TextEditingController();
  final _model = TextEditingController();
  var _baby;
  final _class = TextEditingController();
  String? _message, _cat;
  String ip = "http://192.168.0.124";
  Future<void> postdata() async {
    try {
      if (value == true) {
        _baby = "yes";
      } else {
        _baby = "No";
      }
      if (selectedValue == "mehran" || selectedValue == "cultus") {
        _cat = "mini";
      } else if (selectedValue == "corolla" || selectedValue == "alto") {
        _cat = "bussiness";
      } else if (selectedValue == "bike") {
        _cat = "bike";
      } else if (selectedValue == "civic" || selectedValue == "vitz") {
        _cat = "luxury";
      }

      var response = await http
          .post(Uri.parse("$ip/Project/api/Vehicle/addVehicle"), body: {
        "name": selectedValue,
        "number": _number.text,
        "color": _color.text,
        "cc": _cc.text,
        "model": _model.text,
        "class": _cat,
        "babyseat": _baby,
        "email": widget.email,
      });
      if (response.statusCode == 200) {
        var _messsage = response.body.toString();
        sb = SnackBar(content: Text('$_messsage'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CaptainHomePage(
                  email: widget.email,
                )));
      } else {
        _message = response.body.toString();
        sb = SnackBar(content: Text('$_message'));
        ScaffoldMessenger.of(context).showSnackBar(sb);
      }
    } on Exception catch (_, exp) {}
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Select Your Car"), value: "no"),
      DropdownMenuItem(child: Text("Suzuki Mehran"), value: "mehran"),
      DropdownMenuItem(child: Text("Suzuki Cultus"), value: "cultus"),
      DropdownMenuItem(child: Text("Toyota Corolla"), value: "corolla"),
      DropdownMenuItem(child: Text("Suzuki Alto"), value: "alto"),
      DropdownMenuItem(child: Text("Honda Civic"), value: "civic"),
      DropdownMenuItem(child: Text("Toyota Vitz"), value: "vitz"),
      DropdownMenuItem(child: Text("Bike"), value: "bike"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Give Your Vehicle Information',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: 660,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.lightBlueAccent,
                      Colors.lightBlue,
                      Colors.blueAccent,
                    ])),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: 320,
                    height: 50,
                    color: Colors.white,
                    child: DropdownButton(
                        items: dropdownItems,
                        value: selectedValue,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 25,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        underline: Container(
                          height: 3,
                          color: Colors.indigo,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            print(newValue);
                            selectedValue = newValue!;
                          });
                        }),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    color: Colors.white,
                    child: TextField(
                      controller: _number,
                      decoration: InputDecoration(
                        hintText: 'Number',
                        hintStyle: TextStyle(fontSize: 20.0),
                        border: UnderlineInputBorder(),
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    color: Colors.white,
                    child: TextField(
                      controller: _color,
                      decoration: InputDecoration(
                        hintText: 'Color',
                        hintStyle: TextStyle(fontSize: 20.0),
                        border: UnderlineInputBorder(),
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    color: Colors.white,
                    child: TextField(
                      controller: _model,
                      decoration: InputDecoration(
                        hintText: 'Model',
                        hintStyle: TextStyle(fontSize: 20.0),
                        border: UnderlineInputBorder(),
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    color: Colors.white,
                    child: TextField(
                      controller: _cc,
                      decoration: InputDecoration(
                        hintText: 'CC',
                        hintStyle: TextStyle(fontSize: 20.0),
                        border: UnderlineInputBorder(),
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Text("Baby Seat ?",
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                      Checkbox(
                          value: this.value,
                          onChanged: (bool? val) {
                            setState(() {
                              this.value = val!;
                            });
                          })
                    ],
                  ),
                  Column(
                    children: [
                      ButtonTheme(
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_number.text == "" ||
                                _color.text == "" ||
                                _cc.text == "" ||
                                _model.text == "" ||
                                selectedValue == "n") {
                              sb = SnackBar(content: Text('INCORRECT INPUT'));
                              ScaffoldMessenger.of(context).showSnackBar(sb);
                            } else {
                              postdata();
                            } //move to verification page to verify email
                          },
                          child: Text(
                            'Add Vehicle',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _color.text = "";
    _number.text = "";
    _model.text = "";
    _baby = false;
    selectedValue = "no";
    // TODO: implement dispose
    super.dispose();
  }
}
