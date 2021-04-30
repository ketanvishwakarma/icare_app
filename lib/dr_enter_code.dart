import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/de_get_apt_list.dart';

import 'dr_answer.dart';
import 'my_widgets.dart';

class DrEnterCode extends StatefulWidget {
  @override
  _DrEnterCodeState createState() => _DrEnterCodeState();
}

class _DrEnterCodeState extends State<DrEnterCode> {

  final TextEditingController _codeController = TextEditingController();
  Future<void> _addAnswer() async {
    String code = aptDetails['id_code'].toString();
    await FirebaseFirestore.instance.collection('appointments').doc(code).update({
      'status': 'done',
      }).then((value) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Enter Verification Code',
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
                      hintText: '6 digit code',
                      maxLength: 6,
                      textEditingController: _codeController,
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
                            if (_codeController.text.length == 6) {
                              if(_codeController.text.toString() == aptDetails['id_code'])
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
