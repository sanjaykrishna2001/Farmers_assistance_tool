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
            .where((item) =>
                item['cropName']
                    .toString()
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()))
            .toList();

        return Scaffold(
          floatingActionButton: FloatingActionButton(
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
            child: const Icon(Icons.add),
          ),
          body: Container(
            color: Colors.orange,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Search by Crop Name',
                      suffixIcon: IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchText = '';
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map thisItem = filteredItems[index];

                      return Card(
                        margin: const EdgeInsets.all(10),
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
                                  Row(
                                    children: [
                                      Text(
                                        'Crop Name: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      Text(
                                        '${thisItem['cropName']}',
                                        style: const TextStyle(fontSize: 17),
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
                                        '${thisItem['price']}',
                                        style: const TextStyle(fontSize: 17),
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
                                        style: const TextStyle(fontSize: 17),
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
                                        style: const TextStyle(fontSize: 17),
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
                                        style: const TextStyle(fontSize: 17),
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
          ),
        );
      },
    );
  }
}
