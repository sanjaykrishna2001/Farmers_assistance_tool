import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Crop extends StatefulWidget {
  final String phoneNo;
  final int currentIndex;
  const Crop({super.key, required this.currentIndex, required this.phoneNo});

  @override
  State<Crop> createState() => _CropState(currentIndex, phoneNo);
}

class _CropState extends State<Crop> {
  late String phoneNo;
  late int currentIndex;
  _CropState(this.currentIndex, this.phoneNo);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        color: Colors.greenAccent,
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
              'This is crop selling page',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
