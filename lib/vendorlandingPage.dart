import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pfd_flutter/advanceOrder.dart';
import 'package:pfd_flutter/givePoints.dart';
import 'package:pfd_flutter/landingPage.dart';
import 'package:pfd_flutter/main_menu.dart';
import 'package:pfd_flutter/main_start.dart';
import 'package:pfd_flutter/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pfd_flutter/test.dart';
import 'package:pfd_flutter/userQrCode.dart';
import 'currentOrder.dart';
import 'scanQrCode.dart';
import 'package:pfd_flutter/canteenPage.dart';
import 'package:intl/intl.dart';

class VendorLandingPage extends StatefulWidget {
  const VendorLandingPage({super.key});

  @override
  State<VendorLandingPage> createState() => _VendorLandingPageState();
}

class _VendorLandingPageState extends State<VendorLandingPage> {
  final FirebaseAuth fAuth = FirebaseAuth.instance;
  final fStore = FirebaseFirestore.instance;
  String name = '';
  var points = 0;
  int credit = 0;
  String? uid;
  User? fUser;

  Future fetchUserData() async {
    fUser = fAuth.currentUser!;
    uid = fUser!.uid;

    await fStore.collection('Users').doc(fUser!.uid).get().then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          name = snapshot.data()!['name'];
          points = snapshot.data()!['points'];
          credit = snapshot.data()!['credit'];
        });
      }
    });
  }

  Future claimPoints() async {
    uid = fAuth.currentUser!.uid;
    DocumentReference doc = fStore.collection('Users').doc(uid);

    await fStore.collection('Users').doc(uid).get().then((snapshot) {
      if (snapshot.exists) {
        if (points < 5) {
          int diff = 5 - points;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('$diff points more to redeem'),
          ));
        } else {
          points = snapshot.data()!['points'];
          doc.update({'credit': FieldValue.increment(points)});
          doc.update({'points': 0});
        }
      }
    });
  }

  @override
  void initState() {
    // fAuth.signOut();
    fetchUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF9CF00),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF9CF00),
        elevation: 0,
        title: Image.asset(
          'images/IconBlack.png',
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.width * 0.6,
        ),
        actions: [
          IconButton(
            icon: Image.asset('images/user.png'),
            iconSize: 50,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.04,
                horizontal: MediaQuery.of(context).size.width * 0.08,
              ),
              child: SizedBox(
                width: 340,
                child: Text(
                  "Welcome, $name",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 2,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.1,
                          vertical: MediaQuery.of(context).size.height * 0.02),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '$points points', //Need to do backend
                          style: const TextStyle(
                              color: Color(0xFFF9CF00),
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.1,
                          vertical: MediaQuery.of(context).size.height * 0.02),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'credit: ${NumberFormat.simpleCurrency(locale: 'en_SG', decimalDigits: 2).format(credit / 500)}', //Need to do backend
                          style: const TextStyle(
                              color: Color(0xFFF9CF00),
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: const Color(0xFFF9CF00),
                            borderRadius: BorderRadius.circular(18)),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ScanQR()),
                                );
                              },
                              // ignore: prefer_const_constructors
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(35),
                                ),
                                // ignore: prefer_const_constructors
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.05),
                                  child: const Text(
                                    'Scan QR Code',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: const Color(0xFFF9CF00),
                            borderRadius: BorderRadius.circular(18)),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                claimPoints().then((value) => fetchUserData());
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           (const GivePoints())),
                                // );
                              },
                              // ignore: prefer_const_constructors
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                ),
                                // ignore: prefer_const_constructors
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.05),
                                  child: const Text(
                                    'Claim all points',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: const Color(0xFFF9CF00),
                            borderRadius: BorderRadius.circular(18)),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CurrentOrder()),
                                );
                              },
                              // ignore: prefer_const_constructors
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                ),
                                // ignore: prefer_const_constructors
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.05),
                                  child: const Text(
                                    'Current orders',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: const Color(0xFFF9CF00),
                            borderRadius: BorderRadius.circular(18)),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AdvanceOrder()),
                                );
                              },
                              // ignore: prefer_const_constructors
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                ),
                                // ignore: prefer_const_constructors
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.05),
                                  child: const Text(
                                    'Advanced Orders',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
