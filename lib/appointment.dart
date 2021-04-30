import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DrProfile.dart';

class Appointment extends StatefulWidget {
  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
              child: Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('appointments')
                      .where('patientId',isEqualTo: firebaseUser.uid.toString())
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                        if(snapshot.data.docs.isNotEmpty)
                          return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            Timestamp timestamp = snapshot.data.docs
                                .elementAt(index)
                                .data()['dataTime'];
                            var tempDate =
                                new DateTime.fromMicrosecondsSinceEpoch(
                                    timestamp.seconds * 1000000);
                            Map<String, dynamic> tempDr;
                            String _drId = snapshot.data.docs
                                .elementAt(index)
                                .data()['drId'];
                            return Container(
                              padding: EdgeInsets.all(15),
                              child: Card(
                                elevation: 10.0,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('Doctor')
                                        .doc(_drId)
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<DocumentSnapshot> ss) {
                                      if (ss.hasData) {
                                        tempDr = ss.data.data();
                                          return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(100),
                                                  child: Image.network(
                                                    "https://img.freepik.com/free-vector/doctor-character-background_1270-84.jpg",
                                                    height: 100.0,
                                                    width: 100.0,
                                                  ),
                                                ),
                                                Text(
                                                  "Dr. " + tempDr['1 name'],
                                                  style: TextStyle(
                                                    color:
                                                        Colors.deepPurpleAccent,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                                Text(
                                                  tempDr['99 speciality'],
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            launch('tel:' +
                                                                tempDr[
                                                                    '2 phone']);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary: Colors
                                                                      .deepPurpleAccent),
                                                          child:
                                                              Text('Call Now')),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            drProfileData =
                                                                tempDr;
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          DrProfile(),
                                                                ));
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary: Colors
                                                                      .deepPurpleAccent),
                                                          child: Text(
                                                              'View Profile')),
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
                                                    ]),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 5, bottom: 5),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 1,
                                                  color: Colors.black54,
                                                ),
                                                //Text(),
                                                snapshot.data.docs
                                                            .elementAt(index)
                                                            .data()['slot'] !=
                                                        null
                                                    ? Text(
                                                        tempDate.day.toString() +
                                                            ', ' +
                                                            DateFormat('MMMM')
                                                                .format(tempDate)
                                                                .toString() +
                                                            " at : " +
                                                            snapshot.data.docs
                                                                .elementAt(index)
                                                                .data()['slot'],
                                                        style: TextStyle(
                                                          color: Colors
                                                              .deepPurpleAccent,
                                                          fontSize: 20,
                                                        ),
                                                        textAlign: TextAlign.left,
                                                      )
                                                    : Text(
                                                        tempDate.day.toString() +
                                                            ', ' +
                                                            DateFormat('MMMM')
                                                                .format(tempDate)
                                                                .toString() +
                                                            " at : " +
                                                            tempDate.hour.toString() + ':' + tempDate.minute.toString(),
                                                        style: TextStyle(
                                                          color: Colors
                                                              .deepPurpleAccent,
                                                          fontSize: 20,
                                                        ),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Code: " +
                                                      snapshot.data.docs
                                                          .elementAt(index)
                                                          .data()['id_code'],
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 5, bottom: 5),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 1,
                                                  color: Colors.black54,
                                                ),
                                              ]);
                                        return Text('No Appointments');
                                      }
                                      return Center(child: Text('No Data'),);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                    }
                    return Center(child: Text('No Data'));
                  },
                ),
              ),
            ),
    );
  }
}
