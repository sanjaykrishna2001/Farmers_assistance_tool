import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_assistance_tool/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:farmers_assistance_tool/auth/signup.dart';

// ignore: camel_case_types
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

// ignore: camel_case_types
class _loginState extends State<login> {
  late String phoneNo, verificationId, smsCode;
  bool codeSent = false;
  var db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // final Stream<QuerySnapshot> usersStream =
  //     FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('login page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter phone number",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: ('phone number'),
                    prefixText: '+91',
                    prefixIcon: Icon(Icons.phone),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    setState(() {
                      phoneNo = '+91$val';
                    });
                  },
                ),
              ),
              codeSent
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          SizedBox(height: 20),
                          const Text(
                            "Enter Otp",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 25.0, right: 25.0),
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  hintText: ('Enter OTP'),
                                  prefixIcon: Icon(Icons.vpn_key),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    smsCode = val;
                                  });
                                },
                              ))
                        ])
                  : Container(),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 46,
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () async {
                      // print(phoneNo);
                      if (codeSent) {
                        // ignore: empty_catches
                        try {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: smsCode);
                          await auth.signInWithCredential(credential);
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                currentIndex: 0,
                                phoneNo: phoneNo,
                              ),
                            ),
                          );
                        } catch (e) {
                          print("wrong otp $e");
                        }
                      } else {
                        db.collection('users').doc(phoneNo).get().then(
                              (value) async => {
                                print(value.data()),
                                if (value.data() == null)
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const signup(),
                                      ),
                                    ),
                                  }
                                else
                                  {
                                    await FirebaseAuth.instance
                                        .verifyPhoneNumber(
                                      phoneNumber: phoneNo,
                                      verificationCompleted:
                                          (PhoneAuthCredential credential) {},
                                      verificationFailed:
                                          (FirebaseAuthException e) {},
                                      codeSent: (String verificationId,
                                          int? resendToken) {
                                        this.verificationId = verificationId;
                                      },
                                      codeAutoRetrievalTimeout:
                                          (String verificationId) {},
                                    ),
                                    setState(
                                      () {
                                        codeSent = !codeSent;
                                      },
                                    ),
                                  }
                              },
                              onError: (e) => {
                                print("dosent exist!!!!!!"),
                              },
                            );
                      }
                    },
                    child: codeSent
                        ? const Text(
                            ('Verify'),
                            style: TextStyle(fontSize: 20),
                          )
                        : const Text(
                            ('get OTP'),
                            style: TextStyle(fontSize: 20),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have account?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => signup(),
                          ),
                        );
                      },
                      child: const Text(
                        " Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
    // return StreamBuilder<QuerySnapshot>(
    //     stream: usersStream,
    //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //       if (snapshot.hasError) {
    //         print('Something went Wrong');
    //       }
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }

    //       final List storedocs = [];
    //       snapshot.data!.docs.map((DocumentSnapshot document) {
    //         Map a = document.data() as Map<String, dynamic>;
    //         storedocs.add(a);
    //         a['id'] = document.id;
    //         print(storedocs);
    //       }).toList();
    //       return Scaffold(
    //         appBar: AppBar(
    //           title: const Text('login page'),
    //         ),
    //         body: Center(
    //           child: SingleChildScrollView(
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Text(
    //                   "Enter phone number",
    //                   style:
    //                       TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.only(left: 25.0, right: 25.0),
    //                   child: TextFormField(
    //                     keyboardType: TextInputType.phone,
    //                     decoration: const InputDecoration(
    //                       hintText: ('phone number'),
    //                       prefixText: '+91',
    //                       prefixIcon: Icon(Icons.phone),
    //                       enabledBorder: OutlineInputBorder(
    //                           borderSide: BorderSide(color: Colors.grey)),
    //                       border: OutlineInputBorder(),
    //                     ),
    //                     onChanged: (val) {
    //                       setState(() {
    //                         this.phoneNo = '+91' + val;
    //                       });
    //                     },
    //                   ),
    //                 ),
    //                 codeSent
    //                     ? Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: [
    //                             SizedBox(height: 20),
    //                             Text(
    //                               "Enter Otp",
    //                               style: TextStyle(
    //                                   fontSize: 20,
    //                                   fontWeight: FontWeight.bold),
    //                             ),
    //                             Padding(
    //                                 padding: EdgeInsets.only(
    //                                     left: 25.0, right: 25.0),
    //                                 child: TextFormField(
    //                                   keyboardType: TextInputType.phone,
    //                                   decoration: InputDecoration(
    //                                     hintText: ('Enter OTP'),
    //                                     prefixIcon: Icon(Icons.vpn_key),
    //                                     enabledBorder: OutlineInputBorder(
    //                                         borderSide:
    //                                             BorderSide(color: Colors.grey)),
    //                                     border: OutlineInputBorder(),
    //                                   ),
    //                                   onChanged: (val) {
    //                                     setState(() {
    //                                       this.smsCode = val;
    //                                     });
    //                                   },
    //                                 ))
    //                           ])
    //                     : Container(),
    //                 SizedBox(height: 20),
    //                 Align(
    //                   alignment: Alignment.center,
    //                   child: Container(
    //                     height: 46,
    //                     width: 160,
    //                     child: ElevatedButton(
    //                       onPressed: () {
    //                         // AuthService().savePhoneNumber(this.phoneNo);
    //                         // codeSent
    //                         //     ? AuthService().signInWithOTP(
    //                         //         smsCode, verificationId)
    //                         //     : verifyPhone(phoneNo);
    //                         setState(() {
    //                           codeSent = !codeSent;
    //                         });
    //                         // saveData();
    //                       },
    //                       child: codeSent
    //                           ? Text(
    //                               ('Verify'),
    //                               style: TextStyle(fontSize: 20),
    //                             )
    //                           : Text(
    //                               ('get OTP'),
    //                               style: TextStyle(fontSize: 20),
    //                             ),
    //                     ),
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   height: 20,
    //                 ),
    //                 Align(
    //                   alignment: Alignment.center,
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       const Text(
    //                         "Don't have account?",
    //                         style: TextStyle(fontWeight: FontWeight.bold),
    //                       ),
    //                       GestureDetector(
    //                         onTap: () {
    //                           Navigator.push(
    //                             context,
    //                             MaterialPageRoute(
    //                               builder: (context) => signup(),
    //                             ),
    //                           );
    //                         },
    //                         child: const Text(
    //                           " Sign Up",
    //                           style: TextStyle(fontWeight: FontWeight.bold),
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     });
  }
}
