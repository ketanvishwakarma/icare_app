import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';

import 'icare_user.dart';
import 'my_widgets.dart';


var questionId;

class DrAnswer extends StatefulWidget {
  const DrAnswer({Key key}) : super(key: key);
  @override
  _DrAnswerState createState() => _DrAnswerState();
}

class _DrAnswerState extends State<DrAnswer> {
  final TextEditingController _questionController = TextEditingController();
  Future<void> _addAnswer() async {
    await FirebaseFirestore.instance.collection('question').doc(questionId).update({
      'answer': _questionController.text,
      'status': 'done',
      'answerby': userData['1 name'],
      'answerbyID': firebaseUser.uid,
    }).then((value) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Write Answer',
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
                      keyBoardType: TextInputType.multiline,
                      hintText: 'Answer',
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
                          color: Colors.pinkAccent,
                          onPressed: () {
                            if (_questionController.text.length >= 8) {
                              _addAnswer();
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
