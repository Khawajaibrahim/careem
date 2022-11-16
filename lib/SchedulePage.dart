//import 'package:abc/CarSelectionPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_pickerr/time_pickerr.dart';

//import 'BargainPage.dart';
import 'PickupLocationPage.dart';

class SchedulePage extends StatefulWidget {
  var email;

  SchedulePage({Key? key, required this.email}) : super(key: key);
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String _selectedDate = '';

  String _dateCount = '';

  String _range = '';

  String _rangeCount = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
        // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.toString();
      } else {
        _rangeCount = args.value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Set Your Schedule '),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Text('Selected Dates : $_dateCount',style:TextStyle(fontSize: 18,fontWeight:FontWeight.bold)),
              SizedBox(height: 40),
              Center(
                  child: Text('Select The Days',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              SizedBox(height: 20),
              Card(
                child: SfDateRangePicker(
                  selectionColor: Colors.indigo,
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.multiple,
                ),
              ),
              CustomHourPicker(),
              Center(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PickupLocationPage(
                            email: widget.email,
                          )),
                    );
                  },
                  child: const Text('Confirm',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
