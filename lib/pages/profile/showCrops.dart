import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/login.dart';

class ShowCrops extends StatefulWidget {
  final String phoneNo;
  const ShowCrops({Key? key, required this.phoneNo}) : super(key: key);

  @override
  State<ShowCrops> createState() => _ShowCropsState(phoneNo);
}

class _ShowCropsState extends State<ShowCrops> {
  late String phoneNo;
  _ShowCropsState(this.phoneNo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crops'),
      ),
      body: Container(
        color: Colors.grey[200],
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('crops')
              .where('owner', isEqualTo: phoneNo)
              .get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No data found'),
              );
            }

            final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

            return RefreshIndicator(
              onRefresh: () {
                return Future.delayed(Duration(seconds: 1), () {
                  setState(() {}); // Refresh the UI
                });
              },
              child: ListView.builder(
                itemCount: documents.length,
                itemBuilder: (BuildContext context, int index) {
                  final document = documents[index];

                  final String documentId = document.id;
                  final String cropName = document['cropName'];
                  final String description = document['description'];
                  final String imageUrl = document['image'];
                  final String location = document['location'];
                  final String price = document['price'].toString();
                  final String quantity = document['quantity'].toString();

                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade100,
                            Colors.orange.shade200,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(8.0),
                              ),
                              image: DecorationImage(
                                image: imageUrl.isNotEmpty
                                    ? NetworkImage(imageUrl) as ImageProvider<Object>
                                    : AssetImage('your_default_image_asset') as ImageProvider<Object>,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cropName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Price: $price',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Quantity: $quantity',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Location: $location',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Description: $description',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _showEditDialog(
                                          documentId,
                                          cropName,
                                          description,
                                          price,
                                          quantity,
                                          location,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.orange, // Set button color to orange
                                      ),
                                      child: Text('Edit'),
                                    ),
                                    SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        _showConfirmationDialog(documentId, cropName);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red, // Set button color to red
                                      ),
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog(String documentId, String cropName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete $cropName?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCrop(documentId, cropName);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCrop(String documentId, String cropName) async {
    try {
      await FirebaseFirestore.instance.collection('crops').doc(documentId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully deleted crop: $cropName',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh the page
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to delete crop: $cropName',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showEditDialog(String documentId, String cropName, String description, String price, String quantity, String location) async {
    final TextEditingController cropNameController = TextEditingController(text: cropName);
    final TextEditingController descriptionController = TextEditingController(text: description);
    final TextEditingController priceController = TextEditingController(text: price);
    final TextEditingController quantityController = TextEditingController(text: quantity);
    final TextEditingController locationController = TextEditingController(text: location);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Crop'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: cropNameController,
                  decoration: InputDecoration(
                    labelText: 'Crop Name',
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                  ),
                ),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _updateCrop(
                  documentId,
                  cropNameController.text,
                  descriptionController.text,
                  priceController.text,
                  quantityController.text,
                  locationController.text,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateCrop(String documentId, String cropName, String description, String price, String quantity, String location) async {
    try {
      await FirebaseFirestore.instance.collection('crops').doc(documentId).update({
        'cropName': cropName,
        'description': description,
        'price': double.parse(price),
        'quantity': int.parse(quantity),
        'location': location,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully updated crop: $cropName',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh the page
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update crop: $cropName',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
