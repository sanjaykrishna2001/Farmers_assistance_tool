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
  bool searchByEquipmentName = true; // Flag to toggle search by equipment name or location

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
      if (query.isEmpty) {
        filteredItems = List.from(items);
      } else {
        filteredItems = items.where((item) {
          final itemName = item['equipmentName'].toString().toLowerCase();
          final location = item['location'].toString().toLowerCase();
          if (searchByEquipmentName) {
            return itemName.contains(query.toLowerCase());
          } else {
            return location.contains(query.toLowerCase());
          }
        }).toList();
      }
    });
  }

  void toggleSearchBy() {
    setState(() {
      searchByEquipmentName = !searchByEquipmentName;
      searchController.clear();
      filterItems('');
    });
  }

  void _showFilterOptions(BuildContext context) {
    final List<PopupMenuEntry<bool>> options = <PopupMenuEntry<bool>>[
      PopupMenuItem<bool>(
        value: true,
        child: const ListTile(
          leading: Icon(Icons.search),
          title: Text('Search by Equipment Name'),
        ),
      ),
      PopupMenuItem<bool>(
        value: false,
        child: const ListTile(
          leading: Icon(Icons.search),
          title: Text('Search by Location'),
        ),
      ),
    ];

    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<bool>(
      context: context,
      position: position,
      items: options,
    ).then((value) {
      if (value != null) {
        setState(() {
          searchByEquipmentName = value;
          searchController.clear();
          filterItems('');
        });
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
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          filterItems(value);
                        },
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          hintText: searchByEquipmentName
                              ? 'Search by equipment name'
                              : 'Search by location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.search,
                              size: 28, color: Colors.grey),
                          suffixIcon: PopupMenuButton<bool>(
                            onSelected: (value) {
                              setState(() {
                                searchByEquipmentName = value;
                                searchController.clear();
                                filterItems('');
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return <PopupMenuEntry<bool>>[
                                PopupMenuItem<bool>(
                                  value: true,
                                  child: const ListTile(
                                    leading: Icon(Icons.search),
                                    title: Text('Search by Equipment Name'),
                                  ),
                                ),
                                PopupMenuItem<bool>(
                                  value: false,
                                  child: const ListTile(
                                    leading: Icon(Icons.search),
                                    title: Text('Search by Location'),
                                  ),
                                ),
                              ];
                            },
                            icon: const Icon(Icons.more_vert),
                          ),
                        ),
                      ),
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
                                top: const Radius.circular(10),
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
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Price: ₹${thisItem['price']} (price per day)',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Description: ${thisItem['description']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Location: ${thisItem['location']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Contact: ${thisItem['owner']}',
                                  style: const TextStyle(fontSize: 16),
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
            label: const Text('Add'),
            icon: const Icon(Icons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
