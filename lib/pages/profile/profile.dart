import 'package:farmers_assistance_tool/pages/profile/showCrops.dart';
import 'package:farmers_assistance_tool/pages/profile/showEquipments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/login.dart';

class Profile extends StatefulWidget {
  final String phoneNo;
  final int currentIndex;
  const Profile({Key? key, required this.currentIndex, required this.phoneNo})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState(currentIndex, phoneNo);
}

class _ProfileState extends State<Profile> {
  late String phoneNo;
  late int currentIndex;
  _ProfileState(this.currentIndex, this.phoneNo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .where('phone', isEqualTo: phoneNo)
              .get()
              .then((QuerySnapshot querySnapshot) {
            if (querySnapshot.size > 0) {
              return querySnapshot.docs.first;
            } else {
              throw Exception('No matching document found');
            }
          }),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child:
                    CircularProgressIndicator(), // Placeholder widget while loading
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                    'Error: ${snapshot.error}'), // Error message if retrieval fails
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Text(
                    'No data found'), // Placeholder widget if no data is available
              );
            }

            final document = snapshot.data!;

            // Extract the fields from the document
            final String name = document['name'];
            final String phone = document['phone'];

            // Display the details in a widget
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text(
                      'Phone',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      phone,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowEquipments(phoneNo: phoneNo),
                      ),
                    );
                  },
                  child: Text(
                    'Show Your Added Equipments',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowCrops(phoneNo: phoneNo),
                      ),
                    );
                  },
                  child: Text(
                    'Show Your Added Crops',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const login(),
                      ),
                    );
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    backgroundColor: Colors.red, // Set the button color to red
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
