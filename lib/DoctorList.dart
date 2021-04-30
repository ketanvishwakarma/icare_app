import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/BookApt.dart';
import 'package:flutter_app/DrProfile.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'icare_user.dart';

class DroctorList extends StatefulWidget {
  @override
  _DroctorList createState() => _DroctorList();
}

String drFilter;

class _DroctorList extends State<DroctorList> {
  @override
  Widget build(BuildContext context) {

    Map<dynamic, dynamic> drList = {};
    List listDistance = [];

    return Scaffold(

      backgroundColor: Colors.white,
      body: new Container(
          child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Doctor')
                      .where('99 speciality', isEqualTo: drFilter)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {

                      double distance;
                      listDistance.clear();
                      if(snapshot.data.docs.length != 0){

                        for(var e in snapshot.data.docs){
                          distance = Geolocator.distanceBetween(userData['_ latitude'], userData['_ longitude'], e.data()['_ latitude'], e.data()['_ longitude']) / 1000;
                          var _data = e.data();
                          _data.putIfAbsent('_ id', () => e.reference.id.toString());
                          drList[distance] = _data;
                          listDistance = drList.keys.toList()..sort();
                        }
                        return new ListView.builder(
                            shrinkWrap: true,
                            itemCount: listDistance.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                  child: GestureDetector(
                                    onTap: () {
                                      drProfileData = drList[listDistance.elementAt(index)];
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DrProfile(),
                                          ));
                                    },
                                    child: Column(children: <Widget>[
                                      ListTile(
                                          leading: Icon(
                                            Icons.account_circle,
                                            color: Colors.deepPurpleAccent,
                                            size: 40,
                                          ),
                                          title: Text(
                                              "Dr. " +
                                                  drList[listDistance.elementAt(index)]['1 name'] + ' | ' + double.parse(listDistance.elementAt(index).toString()).toStringAsFixed(2) + ' KM',
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
                                                  //mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "  ",
                                                      style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 5,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      drList[listDistance.elementAt(index)][
                                                      '999 experience'] +
                                                          " Years Experience | Fees " + drList[listDistance.elementAt(index)][
                                                      '9 fees'],
                                                      style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 15,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Row(
                                                        children: [
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                launch('tel:' +
                                                                    drList[listDistance.elementAt(index)][
                                                                    '2 phone']);
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                  primary: Colors.deepPurpleAccent
                                                              ),
                                                              child:
                                                              Text('Call Now')),
                                                          SizedBox(width: 20,),
                                                          if(drList[listDistance.elementAt(index)]['0 verified'] == 'Yes')
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  drProfileData = drList[listDistance.elementAt(index)];
                                                                  drID  = drList[listDistance.elementAt(index)]['_ id'];
                                                                  drProfileData = snapshot.data.docs[index].data();
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (context) =>
                                                                              BookApt()));
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                    primary: Colors.deepPurpleAccent
                                                                ),
                                                                child:
                                                                Text('Book Now')),
                                                          if(drList[listDistance.elementAt(index)][
                                                          '0 verified'] == 'No')
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                    primary: Colors.deepPurpleAccent
                                                                ),
                                                                child:
                                                                Text('Not Available')),
                                                        ]),
                                                  ])))
                                    ]),
                                  ));
                            });
                      }
                      else
                        return Center(child: Text('No Data Found!!'));

                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }))),
    );
  }
}
