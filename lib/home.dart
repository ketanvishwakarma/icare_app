import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/appointment.dart';
import 'package:flutter_app/blog.dart';
import 'package:flutter_app/icare_user.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/search.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

import 'assistant.dart';
import 'edit_profile.dart';

class home extends StatefulWidget {
  const home({Key key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}


class _homeState extends State<home> {
  int _selectedIndex = 4;
  final List<Widget> _widgetOptions = <Widget>[
    blog(), //0
    Assistant(), //1
    Search(), //2
    Appointment(), //3
    iCareUser(), //4
    //User(),
  ];

  @override
  void initState() {

    firebaseUser = FirebaseAuth.instance.currentUser;
    collectionReference = FirebaseFirestore.instance.collection('Patient');
    FirebaseFirestore.instance
        .collection('Patient')
        .where('2 phone', isEqualTo: firebaseUser.phoneNumber)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        addUser();
      }
    });

    super.initState();
  }

  Future<void> addUser() async {
    // Call the user's CollectionReference to add a new user
    return await FirebaseFirestore.instance
        .collection('Patient')
        .doc(firebaseUser.uid)
        .set({
          '2 phone': firebaseUser.phoneNumber.toString(),
          '_ latitude': 37.4219983,
          '_ longitude': -122.084,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  void navigateSecondPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditProfile()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Row(
        children: [
          buildNavBarItem(Icons.inbox, 0),
          buildNavBarItem(Icons.keyboard_voice, 1),
          buildNavBarItem(Icons.search, 2),
          buildNavBarItem(Icons.event, 3),
          buildNavBarItem(Icons.account_box, 4),
        ],
      ),
      body: _widgetOptions[_selectedIndex],
      floatingActionButton: (_selectedIndex == 4)
          ? FloatingActionButton(
              onPressed: () {
                navigateSecondPage();
              },
              child: const Icon(Icons.edit),
              backgroundColor: Colors.pinkAccent,
            )
          : null,
    );
  }

  Widget buildNavBarItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
          color: Colors.deepPurpleAccent,
          height: 60,
          width: MediaQuery.of(context).size.width / 5,
          child: Icon(
            icon,
            color: index == _selectedIndex ? Colors.white : Colors.white60,
            size: 30,
          )),
    );
  }
}
