import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_assistance_tool/pages/crop_sell/addCrop.dart';
import 'package:flutter/material.dart';

class Crop extends StatefulWidget {
  final String phoneNo;
  final int currentIndex;

  const Crop({Key? key, required this.currentIndex, required this.phoneNo})
      : super(key: key);

  @override
  State<Crop> createState() => _CropState(currentIndex, phoneNo);
}

class _CropState extends State<Crop> {
  late String phoneNo;
  late int currentIndex;

  _CropState(this.currentIndex, this.phoneNo);

  var db = FirebaseFirestore.instance;

  final Stream<QuerySnapshot> _cropsStream =
      FirebaseFirestore.instance.collection('crops').snapshots();

  String _searchText = '';
  String _searchBy = 'Crop Name';
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _cropsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        QuerySnapshot<Object?>? querySnapshot = snapshot.data;
        List<QueryDocumentSnapshot<Object?>>? documents = querySnapshot?.docs;
        List<Map>? items = documents?.map((e) => e.data() as Map).toList();

        List<Map> filteredItems = items!
            .where((item) => _searchBy == 'Crop Name'
                ? item['cropName']
                    .toString()
                    .toLowerCase()
                    .contains(_searchText.toLowerCase())
                : item['location']
                    .toString()
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()))
            .toList();

        return Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.orange,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCrop(
                    phoneNo: phoneNo,
                  ),
                ),
              );
            },
            label: const Text('Add'),
            icon: const Icon(Icons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchText = value;
                            });
                          },
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            labelText: _searchBy == 'Crop Name'
                                ? 'Search by Crop Name'
                                : 'Search by Location',
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            prefixIcon:
                                Icon(Icons.search, size: 28, color: Colors.grey),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchText = '';
                                });
                              },
                              icon: const Icon(Icons.clear, color: Colors.grey),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            floatingLabelBehavior:
                                FloatingLabelBehavior.never,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: PopupMenuButton<String>(
                          itemBuilder: (BuildContext context) {
                            return ['Crop Name', 'Location'].map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                          onSelected: (String selectedChoice) {
                            setState(() {
                              _searchBy = selectedChoice;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map thisItem = filteredItems[index];

                    return Card(
                      color: Colors.orange.shade100, // Card background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 200, // Fixed height for the image container
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10), // Rounded top corners
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  thisItem.containsKey('image')
                                      ? '${thisItem['image']}'
                                      : 'your_default_image_url',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                                10), // Padding around the Text widgets inside the Card
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Crop Name: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            17, // Font size for the equipment name text
                                      ),
                                    ),
                                    Text(
                                      '${thisItem['cropName']}',
                                      style: TextStyle(
                                          fontSize:
                                              17), // Font size for the other texts
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Price: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      '₹${thisItem['price']}', // Add rupee symbol to the price
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Text(
                                      ' (price per Kg)', // Add "price per KG" in brackets at the end
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Quantity: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      "${thisItem['quantity']}Kg's",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Description: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      '${thisItem['description']}',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Location: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      '${thisItem['location']}',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Contact: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      '${thisItem['owner']}',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
