import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_assistance_tool/pages/crop_sell/addCrop.dart';
import 'package:flutter/material.dart';

class Crop extends StatefulWidget {
  final String phoneNo;
  final int currentIndex;
  const Crop({super.key, required this.currentIndex, required this.phoneNo});

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _cropsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        //  if(snapshot.hasData){
        // ignore: prefer_typing_uninitialized_variables, avoid_init_to_null
        // snapshot.data!.docs.map((DocumentSnapshot document) {
        //   Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        // });
        QuerySnapshot<Object?>? querySnapshot = snapshot.data;
        List<QueryDocumentSnapshot<Object?>>? documents = querySnapshot?.docs;
        //Convert the documents to Maps
        List<Map>? items = documents?.map((e) => e.data() as Map).toList();

        return Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.orange,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(10)),
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
                          child: const Text("Add")),
                    ),
                  ),
                  Container(
                    color: Colors.blue,
                    child: Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: items?.length,
                        itemBuilder: (BuildContext context, int index) {
                          //Get the item at this index
                          Map thisItem = items![index];
                          //REturn the widget for the list items
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black)),
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              title: Container(
                                margin: EdgeInsets.only(bottom: 5),
                                height: 200,
                                width: 150,
                                child: thisItem.containsKey('image')
                                    ? Image.network('${thisItem['image']}')
                                    : Container(),
                              ),
                              subtitle: Container(
                                color: Colors.green,
                                child: Column(children: [
                                  Row(
                                    children: [
                                      const Text("crop Name:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17)),
                                      Text(' ${thisItem['cropName']}',
                                          style: const TextStyle(fontSize: 17)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Price:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17)),
                                      Text(' ${thisItem['price']}',
                                          style: const TextStyle(fontSize: 17)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Description:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17)),
                                      Text(' ${thisItem['description']}',
                                          style: const TextStyle(fontSize: 17)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Location:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17)),
                                      Text(' ${thisItem['location']}',
                                          style: const TextStyle(fontSize: 17)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Contact:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17)),
                                      Text(' ${thisItem['owner']}',
                                          style: const TextStyle(fontSize: 17)),
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // const Text(
                  //   "hello",
                  //   style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  // ),
                  // const Text(
                  //   'Your phone number is',
                  //   style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  // ),
                  // Text(
                  //   phoneNo,
                  //   style: const TextStyle(
                  //       fontSize: 17, fontWeight: FontWeight.bold),
                  // ),
                  // const Text(
                  //   'This is crop selling page',
                  //   style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
