import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_assistance_tool/auth/login.dart';
import 'package:farmers_assistance_tool/pages/crop_sell/crop.dart';
import 'package:farmers_assistance_tool/pages/detection.dart';
import 'package:farmers_assistance_tool/pages/profile/profile.dart';
import 'package:farmers_assistance_tool/pages/rent/rent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String phoneNo;
  final int currentIndex;
  const HomePage(
      {super.key, required this.phoneNo, required this.currentIndex});

  @override
  State<HomePage> createState() => _HomePageState(phoneNo, currentIndex);
}

class _HomePageState extends State<HomePage> {
  late String phoneNo, name = 'kk';
  late int currentIndex;
  _HomePageState(this.phoneNo, this.currentIndex);

  var db = FirebaseFirestore.instance;

  Map<String, dynamic>? val;

  @override
  Widget build(BuildContext context) {
    // db.collection('users').doc(phoneNo).get().then(
    //       (value) => {
    //         val = value.data(),
    //         name = val!["name"],
    //       },
    //       onError: (e) => {
    //         // ignore: avoid_print
    //         print("dosent exist!!!!!!"),
    //       },
    //     );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmers assistance tool'),
      ),
      body: showwidget(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            label: 'rent',
            icon: Icon(Icons.agriculture),
          ),
          BottomNavigationBarItem(
            label: 'detection',
            icon: Icon(Icons.alarm),
          ),
          BottomNavigationBarItem(
            label: 'crop sell',
            icon: Icon(Icons.sell),
          ),
          BottomNavigationBarItem(
            label: 'profile',
            icon: Icon(Icons.person),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index) => {
          setState(() {
            currentIndex = index;
          }),
        },
      ),
    );
  }

  showwidget() {
    if (currentIndex == 0) {
      return Rent(
        currentIndex: currentIndex,
        phoneNo: phoneNo,
      );
    } else if (currentIndex == 1) {
      return Detection(
        currentIndex: currentIndex,
        phoneNo: phoneNo,
      );
    } else if (currentIndex == 2) {
      return Crop(
        currentIndex: currentIndex,
        phoneNo: phoneNo,
      );
    } else if (currentIndex == 3) {
      return Profile(
        currentIndex: currentIndex,
        phoneNo: phoneNo,
      );
    }
  }

  Future<String> namef() async {
    await db.collection('users').doc(phoneNo).get().then(
          (value) => {
            val = value.data(),
          },
          onError: (e) => {
            // ignore: avoid_print
            print("dosent exist!!!!!!"),
          },
        );
    return val!["name"];
  }
}
