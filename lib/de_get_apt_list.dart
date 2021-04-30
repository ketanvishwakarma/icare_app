import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/dr_enter_code.dart';
import 'package:flutter_app/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class DrGetAptList extends StatefulWidget {
  @override
  _DrGetAptListState createState() => _DrGetAptListState();
}

var aptDetails;

class _DrGetAptListState extends State<DrGetAptList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Today\'s Appointments',
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
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('appointments').orderBy('dataTime')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      Timestamp timestamp = snapshot.data.docs.elementAt(index).data()['dataTime'];
                      var tempDate = new DateTime.fromMicrosecondsSinceEpoch(
                          timestamp.seconds * 1000000);
                      //tempDate = DateFormat("yyyy-MM-dd HH:mm:").parse(tempDate.toString(),true);
                      tempDate = tempDate.toUtc();
                      Map<String, dynamic> tempDr;
                      String _pId = snapshot.data.docs
                          .elementAt(index)
                          .data()['patientId'];
                      if((snapshot.data.docs.elementAt(index).data()['status'] == 'pending') && snapshot.data.docs.elementAt(index).data()['drId'] == firebaseUser.uid.toString()
                       && tempDate.day == DateTime.now().day && tempDate.month == DateTime.now().month && tempDate.year == DateTime.now().year)
                        return Container(
                        padding: EdgeInsets.all(15),
                        child: Card(
                          elevation: 10.0,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('Patient')
                                  .doc(_pId)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> ss) {
                                if (ss.hasData) {
                                  tempDr = ss.data.data();
                                  return ListTile(
                                      leading: Icon(
                                        Icons.account_circle,
                                        color: Colors.deepPurpleAccent,
                                        size: 40,
                                      ),
                                      title: Text(tempDr['1 name'] + ' at ' + snapshot.data.docs.elementAt(index).data()['slot'],
                                          style: TextStyle(
                                            color: Colors.pinkAccent,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left),
                                      subtitle: Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  tempDr['4 gender'] +
                                                      ' | ' +
                                                      tempDr['7 bloodGroup']
                                                          .toString()
                                                          .toUpperCase() +
                                                      ' | ' +
                                                      tempDr['8 weight'] +
                                                      ' kg',
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 15,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Text(
                                                  tempDr['6 address'],
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 15,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        launch('tel:' +
                                                            tempDr['2 phone']);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: Colors
                                                                  .deepPurpleAccent),
                                                      child: Text('Call Now')),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        final Uri
                                                            _emailLaunchUri =
                                                            Uri(
                                                                scheme:
                                                                    'mailto',
                                                                path:
                                                                    'icare2021@gmail.com',
                                                                queryParameters: {
                                                              'subject':
                                                                  'Cancel_Appointment[${snapshot.data.docs.elementAt(index).data()['id_code']}]'
                                                            });
                                                        launch(_emailLaunchUri
                                                            .toString());
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: Colors
                                                                  .deepPurpleAccent),
                                                      child: Text('Cancel')),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          aptDetails = snapshot.data.docs.elementAt(index).data();
                                                        });
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DrEnterCode(),
                                                            ));
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: Colors
                                                                  .deepPurpleAccent),
                                                      child: Text('Code')),
                                                ]),
                                              ])));
                                }
                                return Center(
                                  child: Text('No Appointments'),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                      return Text('');
                    },
                  );
                }
                return Center(child: Text('No Data'));
              },
            ),
          ),
        ));
  }
}
