// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../home.dart';

class AddCrop extends StatefulWidget {
  final String phoneNo;
  const AddCrop({super.key, required this.phoneNo});

  @override
  State<AddCrop> createState() => _AddCropState(phoneNo);
}

class _AddCropState extends State<AddCrop> {
  late String phoneNo;
  _AddCropState(this.phoneNo);
  late String cropName, price, description, location, quantity;
  late bool uploaded = false;
  XFile? file;
  var db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Crop"),
      ),
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter your Crop Name",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: ('Crop Name'),
                  prefixIcon: Icon(Icons.agriculture),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  setState(() {
                    cropName = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Enter Price per Kg",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: ('Price in rupees'),
                  prefixIcon: Icon(Icons.currency_rupee),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  setState(() {
                    price = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Enter quantity availablle",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: ('Quantity in Kg'),
                  prefixIcon: Icon(Icons.currency_rupee),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  setState(() {
                    quantity = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Description",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: ('Description'),
                  prefixIcon: Icon(Icons.description),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  setState(() {
                    description = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Location",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: ('Location'),
                  prefixIcon: Icon(Icons.description),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  setState(() {
                    location = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                uploaded
                    ? const Text(
                        "image Uploaded",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    : const Text(
                        "Upload image",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                if (uploaded)
                  Container(
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_circle_outline),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              file = null;
                              uploaded = false;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                else
                  IconButton(
                      onPressed: () async {
                        ImagePicker imagePicker = ImagePicker();
                        file = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        setState(() {
                          if (file != null) {
                            uploaded = true;
                          }
                        });
                      },
                      icon: const Icon(Icons.upload)),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: Container(
                  height: 46,
                  width: 160,
                  child: ElevatedButton(
                      onPressed: () async {
                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDirImages =
                            referenceRoot.child("crops");
                        late String fileName =
                            DateTime.now().microsecondsSinceEpoch.toString();
                        Reference referenceImageToUpload =
                            referenceDirImages.child(fileName);
                        String imageUrl;
                        try {
                          await referenceImageToUpload
                              .putFile(File(file!.path));
                          imageUrl =
                              await referenceImageToUpload.getDownloadURL();
                          Map<String, String> data = {
                            'cropName': cropName,
                            'price': price,
                            'quantity': quantity,
                            'description': description,
                            'location': location,
                            'image': imageUrl,
                            'owner': phoneNo
                          };
                          db.collection("crops").add(data);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                currentIndex: 2,
                                phoneNo: phoneNo,
                              ),
                            ),
                          );
                        } catch (e) {
                          const Center(child: Text("Error in image upload "));
                        }
                      },
                      child: const Text("Submit"))),
            )
          ],
        )),
      ),
    );
  }
}
