import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/dr_answer.dart';
import 'package:flutter_app/main.dart';

import 'add_question.dart';

class Questions extends StatefulWidget {
  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          userType == 'yes' ? 'Questions' : 'Your Questions',
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black54, //change your color here
        ),
      ),
      body: userType == 'yes'
          ? Container(
        padding: EdgeInsets.only(left: 20,right:20),
            child: SafeArea(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('question')
                      .where('status', isEqualTo: 'pending')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data.docs.length > 0) {
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              elevation: 5.0,
                              alignment: Alignment.centerLeft,
                            ),
                            onPressed: () {
                              questionId = snapshot.data.docs.elementAt(index).reference.id;
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DrAnswer())); },
                            child: Text(
                                snapshot.data.docs
                                    .elementAt(index)
                                    .data()['title'],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.deepPurpleAccent,
                                )),
                          );
                        },
                      );
                    }
                    return Center(child: Text('No Data Found'));
                  },
                ),
              ),
          )
          : SafeArea(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('question')
                    .where('owner', isEqualTo: firebaseUser.uid.toString())
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data.docs.length > 0) {
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5.0,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    snapshot.data.docs
                                        .elementAt(index)
                                        .data()['title'],
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.deepPurpleAccent,
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                snapshot.data.docs
                                            .elementAt(index)
                                            .data()['status']
                                            .toString() ==
                                        'pending'
                                    ? Text('answer is pending',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ))
                                    : Text(
                                        snapshot.data.docs
                                            .elementAt(index)
                                            .data()['answer'],
                                        style: TextStyle(
                                          fontSize: 15,
                                        )),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Center(child: Text('No Data Found'));
                },
              ),
            ),
      floatingActionButton: userType == 'yes' ? null : FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddQuestion(),
              ));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}
