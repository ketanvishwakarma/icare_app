import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/icare_user.dart';
import 'package:flutter_app/my_widgets.dart';
import 'package:image_picker/image_picker.dart';

import 'main.dart';

class DrGetDocuments extends StatefulWidget {
  @override
  _DrGetDocumentsState createState() => _DrGetDocumentsState();
}

class _DrGetDocumentsState extends State<DrGetDocuments> {
  String status = 'close';
  String _imageMedical, _imageQualification, _imageGov;

  final _picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
      .ref()
      .child(firebaseUser.uid)
      .child('images');

  Future<Future> uploadImg(PickedFile pickedFile, str) async {
    setState(() {
      status = str;
    });
    File file = File(pickedFile.path);
    try {
      await ref.child('$str.jpg').putFile(file);
    } catch (e) {
      print(e);
    }
  }

  Future _getImage(str) async {
    PickedFile pickedFile = await _picker.getImage(source: ImageSource.camera);
    if (pickedFile.path != null) {
      if (str == '_imageMedical') {
        uploadImg(pickedFile, str).then((value) {
          setState(() {
            _imageMedical = 'yes';
            userType = 'yes';
            status = 'close';
          });
        });
      }
      if (str == '_imageQualification') {
        uploadImg(pickedFile, str).then((value) {
          setState(() {
            _imageQualification = 'yes';
            status = 'close';
          });
        });
      }
      if (str == '_imageGov') {
        uploadImg(pickedFile, str).then((value) {
          setState(() {
            _imageGov = 'yes';
            status = 'close';
          });
        });
      }
    } else {
      print('No image selected.');
    }
  }


  Future<Future> addUser() async {
    // Call the user's CollectionReference to add a new user
    userData['0 verified'] = 'No';
    await FirebaseFirestore.instance.collection('Doctor').doc(firebaseUser.uid).set(userData).then((value) => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        App()), (Route<dynamic> route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                MyTextView(
                    str:
                        'Hey Doctor, Please Upload Your Documents So We Can Verify Your Profile'),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 1,
                  child: ListTile(
                    onTap: () => {_getImage('_imageMedical')},
                    title: Text(
                      'Medical Registration Proof',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: status == '_imageMedical'
                        ? CircularProgressIndicator()
                        : Icon(
                            Icons.add_a_photo,
                            color: _imageMedical != null
                                ? Theme.of(context).accentColor
                                : null,
                          ),
                  ),
                ),
                Card(
                  elevation: 1,
                  child: ListTile(
                    onTap: () => {_getImage('_imageQualification')},
                    title: Text(
                      'Qualification Proof',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: status == '_imageQualification'
                        ? CircularProgressIndicator()
                        : Icon(
                            Icons.add_a_photo,
                            color: _imageQualification != null
                                ? Theme.of(context).accentColor
                                : null,
                          ),
                  ),
                ),
                Card(
                  elevation: 1,
                  child: ListTile(
                    onTap: () => {_getImage('_imageGov')},
                    title: Text(
                      'Government issued Photo ID Proof',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: status == '_imageGov'
                        ? CircularProgressIndicator()
                        : Icon(
                            Icons.add_a_photo,
                            color: _imageGov != null
                                ? Theme.of(context).accentColor
                                : null,
                          ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: FlatButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      color: (_imageMedical != null &&
                              _imageGov != null &&
                              _imageQualification != null)
                          ? Colors.pinkAccent
                          : Colors.black45,
                      onPressed: () {
                       if (_imageMedical != null &&
                            _imageGov != null &&
                            _imageQualification != null) {
                          addUser();
                        }
                      },
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
