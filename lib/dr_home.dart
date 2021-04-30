
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blog.dart';
import 'package:flutter_app/dr_appointments_edit.dart';
import 'package:flutter_app/dr_blog.dart';
import 'package:flutter_app/dr_get_Slots.dart';
import 'package:flutter_app/edit_profile.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/icare_user.dart';

import 'questions.dart';

class DrHome extends StatefulWidget {
  const DrHome({Key key}) : super(key: key);
  @override
  _DrHomeState createState() => _DrHomeState();
}

class _DrHomeState extends State<DrHome> {

  int _selectedIndex = 3;
  final List<Widget> _widgetOptions = <Widget>[
    //CheckSlots(),
    blog(), //0
    Questions(), //1
    DrGetSlots(),//2
    iCareUser(),//3
    //User(),
  ];

  @override
  void initState() {
    super.initState();
    firebaseUser = FirebaseAuth.instance.currentUser;
    collectionReference = FirebaseFirestore.instance.collection('Doctor');
  }


  void navigateSecondPage() {
    if(_selectedIndex == 0)
      Navigator.push(context, MaterialPageRoute(builder: (context) => DrBlogAddPost()));
    if(_selectedIndex == 2)
      Navigator.push(context, MaterialPageRoute(builder: (context) => DrAppointmentsEdit()));
    if(_selectedIndex == 3)
      Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Row(
        children: [
          buildNavBarItem(Icons.inbox, 0),
          buildNavBarItem(Icons.question_answer, 1),
          buildNavBarItem(Icons.event, 2),
          buildNavBarItem(Icons.account_box, 3),
        ],
      ),
      body: _widgetOptions[_selectedIndex],
      floatingActionButton: (_selectedIndex != 1) ? FloatingActionButton(
        onPressed: () {
          navigateSecondPage();
        },
        child: const Icon(Icons.edit),
        backgroundColor: Colors.deepPurpleAccent,
      ) : null,
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
          width: MediaQuery.of(context).size.width /4,
          child: Icon(
            icon,
            color: index == _selectedIndex ? Colors.pinkAccent : Colors.white60,
            size: 30,
          )),
    );
  }
}
