import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Detection extends StatefulWidget {
  final String phoneNo;
  final int currentIndex;
  const Detection({super.key, required this.currentIndex, required this.phoneNo});

  @override
  State<Detection> createState() => _DetectionState(currentIndex, phoneNo);
}

class _DetectionState extends State<Detection> {
  late String phoneNo;
  late int currentIndex;
  _DetectionState(this.currentIndex, this.phoneNo);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        color: Colors.brown,
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
              'This is disease detection page',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
