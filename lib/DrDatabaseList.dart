import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrDatabaseList extends StatefulWidget {
  @override
  _DrDatabaseList createState() => _DrDatabaseList();
}

class _DrDatabaseList extends State<DrDatabaseList> {

  final dbRef = FirebaseDatabase.instance.reference().child("DrList");

  List<Map<dynamic, dynamic>> lists = [];
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: width,
            height: height,
            margin: EdgeInsets.only(top: 40),
            child: FutureBuilder (
                future: dbRef.once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    lists.clear();
                    Map<dynamic, dynamic> values = snapshot.data.value;
                    values.forEach((key, values) {
                      lists.add(values);
                    });
                    return new Expanded(child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: lists.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Name: " + lists[index]["email"]),
                                Text("Age: "+ lists[index]["mobile"]),
                                Text("Type: " +lists[index]["password"]),
                              ],
                            ),
                          );
                        }));
                  }
                  return CircularProgressIndicator();
                })
        ));
  }

}
