import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_assistance_tool/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/home.dart';

// ignore: camel_case_types
class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

// ignore: camel_case_types
class _signupState extends State<signup> {
  late String phoneNo, verificationId, smsCode, userName;
  bool codeSent = false;
  var db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('signUp page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter your name",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: ('name'),
                    prefixIcon: Icon(Icons.person_outline),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    setState(() {
                      userName = val;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
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
                          const SizedBox(height: 20),
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
                          final user = <String, String>{
                            "name": userName,
                            "phone": phoneNo,
                          };

                          db.collection("users").doc(phoneNo).set(user).onError(
                              (e, _) => print("Error writing document: $e"));
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
                                if (value.data() != null)
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const login(),
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
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have account?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => login(),
                          ),
                        );
                      },
                      child: const Text(
                        " Login Up",
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
  }
}
