import 'package:farmers_assistance_tool/pages/crop_sell/crop.dart';
import 'package:farmers_assistance_tool/pages/detection/detection.dart';
import 'package:farmers_assistance_tool/pages/profile/profile.dart';
import 'package:farmers_assistance_tool/pages/rent/rent.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String phoneNo;
  final int currentIndex;

  const HomePage({Key? key, required this.phoneNo, required this.currentIndex})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(phoneNo, currentIndex);
}

class _HomePageState extends State<HomePage> {
  late String phoneNo, name = 'kk';
  late int currentIndex;

  _HomePageState(this.phoneNo, this.currentIndex);

  // Rest of your code...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmers Assistance Tool'),
        backgroundColor: Colors.green, // Set the background color of the AppBar
        centerTitle: true, // Center the title horizontally
      ),
      body: showWidget(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green, // Set the color of the selected item
        unselectedItemColor:
            Colors.grey, // Set the color of the unselected items
        backgroundColor:
            Colors.white, // Set the background color of the BottomNavigationBar
        items: const [
          BottomNavigationBarItem(
            label: 'Rent',
            icon: Icon(Icons.agriculture),
          ),
          BottomNavigationBarItem(
            label: 'Detection',
            icon: Icon(Icons.alarm),
          ),
          BottomNavigationBarItem(
            label: 'Crop Sell',
            icon: Icon(Icons.sell),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  Widget showWidget() {
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
    return Container(); // Return an empty container as a fallback
  }
}
