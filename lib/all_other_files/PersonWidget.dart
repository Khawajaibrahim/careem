import 'package:flutter/material.dart';
import 'package:flutter_application_nft_marketplace/Models/nft_models.dart';

class PersonWidget extends StatelessWidget {
  const PersonWidget({super.key, required this.person})
      : assert(person != null);
  final Person person;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.2,
      child: ListTile(
        leading: Image.asset(person.image),
        title: Text(
          person.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(person.price),
        trailing: Text(
          person.time,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
