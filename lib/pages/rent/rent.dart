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
      filteredItems = items.where((item) {
        final itemName = item['equipmentName'].toString().toLowerCase();
        return itemName.contains(query.toLowerCase());
      }).toList();
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

        return Scaffold(
          appBar: AppBar(
            title: Text('Rent'),
            actions: [
              IconButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: SearchBar(this),
                  );
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
          body: Container(
            color: Colors.white,
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
                              'Price: \$${thisItem['price']}',
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

class SearchBar extends SearchDelegate<String> {
  final _RentState rentState;

  SearchBar(this.rentState);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      rentState.filterItems(query);
    });

    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: rentState.filteredItems.length,
        itemBuilder: (BuildContext context, int index) {
          Map thisItem = rentState.filteredItems[index];

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
                        'Price: \$${thisItem['price']}',
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
