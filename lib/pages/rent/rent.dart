import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_assistance_tool/pages/rent/addEquipment.dart';
import 'package:flutter/material.dart';

class Rent extends StatefulWidget {
  final String phoneNo;
  final int currentIndex;

  const Rent({Key? key, required this.currentIndex, required this.phoneNo})
      : super(key: key);

  @override
  State<Rent> createState() => _RentState(currentIndex, phoneNo);
}

class _RentState extends State<Rent> {
  late String phoneNo;
  late int currentIndex;

  _RentState(this.currentIndex, this.phoneNo);

  var db = FirebaseFirestore.instance;

  late List<Map> items;
  late List<Map> filteredItems;
  late TextEditingController searchController;
  String sortOption = 'Price (Low to High)';

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('rent_equipments').snapshots();

  @override
  void initState() {
    super.initState();
    filteredItems = [];
    searchController = TextEditingController();
  }

  void filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = List.from(items);
      } else {
        filteredItems = items.where((item) {
          final itemName = item['equipmentName'].toString().toLowerCase();
          return itemName.contains(query.toLowerCase());
        }).toList();
      }
      sortItems();
    });
  }

  void sortItems() {
    setState(() {
      if (sortOption == 'Price (Low to High)') {
        filteredItems.sort((a, b) => a['price'].compareTo(b['price']));
      } else if (sortOption == 'Price (High to Low)') {
        filteredItems.sort((a, b) => b['price'].compareTo(a['price']));
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        QuerySnapshot<Object?>? querySnapshot = snapshot.data;
        List<QueryDocumentSnapshot<Object?>>? documents = querySnapshot?.docs;
        items = documents?.map((e) => e.data() as Map).toList() ?? [];

        if (filteredItems.isEmpty) {
          filteredItems = List.from(items);
        }

        return Scaffold(
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          filterItems(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search by equipment name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        searchController.clear();
                        filterItems('');
                      },
                      icon: Icon(Icons.clear),
                    ),
                    SizedBox(width: 10),
                    DropdownButton<String>(
                      value: sortOption,
                      onChanged: (String? newValue) {
                        setState(() {
                          sortOption = newValue!;
                          sortItems();
                        });
                      },
                      items: <String>[
                        'Price (Low to High)',
                        'Price (High to Low)'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map thisItem = filteredItems[index];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      color: Colors.orange.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
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
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${thisItem['equipmentName']}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Price: \u20B9${thisItem['price']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Description: ${thisItem['description']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Location: ${thisItem['location']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Contact: ${thisItem['owner']}',
                                  style: TextStyle(fontSize: 16),
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
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.orange,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEquipment(
                    phoneNo: phoneNo,
                  ),
                ),
              );
            },
            label: Text('Add'),
            icon: Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
