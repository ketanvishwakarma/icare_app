import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Map<String, dynamic> drProfileData;

class DrProfile extends StatefulWidget {
  @override
  _DrProfile createState() => _DrProfile();
}

class _DrProfile extends State<DrProfile> {
  @override
  Widget build(BuildContext context) {
    var sortedKeys = drProfileData.keys.toList()..sort();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sortedKeys.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0)
                      return Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            "https://img.freepik.com/free-vector/doctor-character-background_1270-84.jpg",
                            height: 200.0,
                            width: 200.0,
                          ),
                        ),
                      );
                    if (index == 1)
                      return Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Center(
                          child: Text("Dr. " + drProfileData['1 name'],
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      );

                    if(sortedKeys
                        .elementAt(index)
                        .toUpperCase()
                        .toString()
                        .split(' ')
                        .first == '_')
                      return SizedBox(height: 0,);
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
                          drProfileData[sortedKeys.elementAt(index).toString()],
                          style: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),

          ),
    );
  }
}
