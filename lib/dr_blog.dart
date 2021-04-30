import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:flutter_app/icare_user.dart';
import 'package:flutter_app/my_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dr_get_speciality.dart';
import 'main.dart';

class DrBlogAddPost extends StatefulWidget {
  @override
  _DrBlogAddPostState createState() => _DrBlogAddPostState();
}

class _DrBlogAddPostState extends State<DrBlogAddPost> {

  String status = 'close';
  String _imageMedical;
  String thumbnailUrl;
  final _picker = ImagePicker();
  var id = UniqueKey().toString().substring(1,7);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('post');

  Future<Future> uploadImg(PickedFile pickedFile, str) async {
    File file = File(pickedFile.path);
    try {
      await ref.child('$id.jpg').putFile(file).whenComplete(() {
        ref.child('$id.jpg').getDownloadURL().then((value) => thumbnailUrl = value);
      });
    } catch (e) {
      print(e);
    }
  }

  Future _getImage(str) async {
    PickedFile pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile.path != null) {
      if (str == '_imageMedical') {
        uploadImg(pickedFile, str).then((value) {
          setState(() {
            _imageMedical = 'yes';
            status = 'close';
          });
        });
      }
    } else {
      print('No image selected.');
    }
  }

  Future<void> addPost() async {
    List _empty = [];
    await FirebaseFirestore.instance.collection('post').doc(id).set({
      'title' : _titleController.text,
      'link' : _linkController.text.toString(),
      'thumb': thumbnailUrl.toString(),
      'counter' : _empty,
      'views' : 0,
      'time' : DateTime.now(),
      'owner' : firebaseUser.uid,
      'postby' : userData['1 name'],
    }).then((value) => Navigator.of(context).pop());
  }
  @override
  Widget build(BuildContext context) {
    if(userData['0 verified'] == 'Yes')
      return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
              child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      MyTextField(hintText: 'Title',textEditingController: _titleController,),
                      MyTextField(hintText: 'Link',textEditingController: _linkController,),
                      Card(
                        elevation: 1,
                        child: ListTile(
                          onTap: () => {_getImage('_imageMedical')},
                          title: Text(
                            'Upload Thumbnail',
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
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(29),
                          child: FlatButton(
                            padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            color: (_imageMedical != null)
                                ? Colors.pinkAccent
                                : Colors.black45,
                            onPressed: () {
                              if (_imageMedical != null) {
                                addPost();
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
                  )
              )
          ));
    else
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('Not Verified'),
        ),
      );
  }
}
