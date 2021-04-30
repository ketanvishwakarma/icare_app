import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'icare_user.dart';
import 'main.dart';
import 'my_widgets.dart';

class AddQuestion extends StatefulWidget {
  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final TextEditingController _questionController = TextEditingController();
  var id = UniqueKey().toString().substring(1, 7);

  Future<void> _addQuestion() async {
    await FirebaseFirestore.instance.collection('question').doc(id).set({
      'title': _questionController.text,
      'answer': '',
      'time': DateTime.now(),
      'owner': firebaseUser.uid,
      'status': 'pending',
      'questionby': userData['1 name'],
    }).then((value) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Write Question',
            style: TextStyle(color: Colors.black54),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.black54, //change your color here
          ),
        ),
        body: SafeArea(
            child: Container(
                padding: EdgeInsets.only(left: 20,right: 20),
                child: Column(
                  children: [
                    MyTextField(
                      hintText: 'minimum 8 characters',
                      textEditingController: _questionController,
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          color: (_questionController.text.length >= 8)
                              ? Colors.pinkAccent
                              : Colors.black45,
                          onPressed: () {
                            if (_questionController.text.length >= 8) {
                              _addQuestion();
                            }
                          },
                          child: Text(
                            'Submit',
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
                ))));
  }
}
