import 'dart:convert';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:flutter_application_nft_marketplace/Models/nft_models.dart';
import 'package:flutter_application_nft_marketplace/Widgets/PersonWidget.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    await Future.delayed(Duration(seconds: 2));
    var personJson = await rootBundle.loadString("assets/Files/data.json");
    var decodeData = jsonDecode(personJson);
    print(decodeData);
    var personData = decodeData["Person"];
    print(personData);
    PersonModel.person = List.from(personData)
        .map<Person>((person) => Person.FromMap(person))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<String> items = [
      'Last 24 Hours',
      'Last 12 Hours',
      'Last Month',
      'Last Year',
      'Last Week',
    ];
    String? selectedValue;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: .0),
                      child: SizedBox(
                        width: 170,
                        child: InkWell(
                          onTap: () {
                            print("ConnectWallet Pressed");
                          },
                          child: Container(
                            height: 48,
                            width: 154,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Color.fromARGB(255, 214, 214, 214),
                                )),
                            child: Center(
                              child: Text(
                                "Connect Wallet",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 86, 70, 255),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 24,
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          image: new DecorationImage(
                            image: new AssetImage("assets/images/search.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 1),
                        child: Container(
                          height: 20,
                          width: 17,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            image: new DecorationImage(
                              image: new AssetImage(
                                  "assets/images/Notification.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: SizedBox(
                      height: 70,
                      child: Container(
                        child: TabBar(
                          unselectedLabelColor: Colors.black,
                          indicatorColor: Color.fromARGB(255, 86, 70, 255),
                          tabs: [
                            Tab(
                              text: "Activity",
                            ),
                            Tab(
                              text: "Ranking",
                            ),
                          ],
                          labelColor: Color.fromARGB(255, 86, 70, 255),
                          indicator: DotIndicator(
                            color: Color.fromARGB(255, 86, 70, 255),
                            distanceFromCenter: 16,
                            radius: 3,
                            paintingStyle: PaintingStyle.fill,
                          ),
                        ),
                        height: 70,
                        width: 390,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 26.0, top: 15.0),
                    child: SizedBox(
                      width: 130,
                      child: Container(
                        child: CustomDropdownButton2(
                          hint: 'Last Week',
                          dropdownItems: items,
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 40, top: 12),
                    child: SizedBox(
                      width: 40,
                      child: Container(
                        height: 40,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                              color: Color.fromARGB(255, 235, 234, 234)),
                          image: new DecorationImage(
                            image: new AssetImage(
                                "assets/images/Property 1=Filter, Property 2=24.png"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              (PersonModel.person != null && PersonModel.person.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30.0, top: 30),
                      child: Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: PersonModel.person.length,
                          itemBuilder: (context, index) {
                            return PersonWidget(
                              person: PersonModel.person[index],
                            );
                          },
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
