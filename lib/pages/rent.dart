import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Rent extends StatefulWidget {
  final String phoneNo;
  final int currentIndex;
  const Rent({super.key, required this.currentIndex, required this.phoneNo});

  @override
  State<Rent> createState() => _RentState(currentIndex, phoneNo);
}

class _RentState extends State<Rent> {
  late String phoneNo;
  late int currentIndex;
  _RentState(this.currentIndex, this.phoneNo);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        color: Colors.orange,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "hello",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Your phone number is',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              phoneNo,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'This is eqipment renting page',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
