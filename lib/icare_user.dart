import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/dr_get_documents.dart';
import 'package:flutter_app/main.dart';

import 'my_widgets.dart';
import 'questions.dart';

/*
* --- Pending --
*   User own question
*   Saved Post
*   text with link : rate app,
*     share app,
*     about app, contact,
*     privacy policy
*   are you doctor?
*     doctor details distinct : fees, specialization,
*       proof : medical reg, degree, Gov. photo id
        Timeslot table , day and time,
*   sign out
* */

Map<String, dynamic> userData;

class iCareUser extends StatefulWidget {
  @override
  _iCareUserState createState() => _iCareUserState();
}

class _iCareUserState extends State<iCareUser> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: collectionReference.doc(firebaseUser.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userData = snapshot.data.data();
            var sortedKeys = userData.keys.toList()..sort();
            if (snapshot.data.data().containsKey('1 name')) {

              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: sortedKeys.length,
                  itemBuilder: (BuildContext context, int index) {

                    if (userType == 'no') {
                      if (index == 8)
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DrGetDocuments(),
                            ));
                          },
                          title: Text('Are you doctor?'),
                        );
                      if (index == 9)
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Questions(),
                            ));
                          },
                          title: Text('My Questions'),
                        );
                    }

                    String _temp = sortedKeys.elementAt(index).toString();
                    if (sortedKeys.elementAt(index).toUpperCase().toString()
                            .split(' ')
                            .first ==
                        '_')
                      return SizedBox(
                        height: 0,
                      );
                    return Card(
                      elevation: 1,
                      child: ListTile(
                        title: Text(
                          sortedKeys
                              .elementAt(index)
                              .toUpperCase()
                              .toString()
                              .split(' ')
                              .last,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(
                          userData[_temp.toString()],
                          style: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  });
            } else {
              return new SafeArea(
                  child: Container(
                child: MyTextView(str: 'Hey There,\nplease enter your details'),
              ));
            }
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
