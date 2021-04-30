import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/de_get_apt_list.dart';
import 'package:flutter_app/my_widgets.dart';
import 'package:intl/intl.dart';

import 'icare_user.dart';
import 'main.dart';

bool status = true;
DateTime now = DateTime.now();

class DrGetSlots extends StatefulWidget {
  @override
  _DrGetSlotsState createState() => _DrGetSlotsState();
}

class _DrGetSlotsState extends State<DrGetSlots> {
  Map<String, dynamic> slots_1,
      slots_2,
      slots_3,
      slots_4,
      slots_5,
      slots_6,
      slots_7;

  void _handleTimeSlotClick(Map<String, dynamic> data, String key) {
    /*print((DateFormat('EEEE')
        .format(DateTime.now().add(Duration(days: 6)))
        .toUpperCase()));*/
  }

  @override
  Widget build(BuildContext context) {
    if (userData['0 verified'] == 'Yes')
      return SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurpleAccent,
                elevation: 5.0
              ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DrGetAptList()));
                },
                child: Text('See Appointments')),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Timeslots')
                    .doc(firebaseUser.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.exists) {

                       if (snapshot.data
                          .data()
                          .containsKey(DateTime.now().weekday.toString()))
                        slots_1 = snapshot.data
                            .data()[DateTime.now().weekday.toString()];
                      if (snapshot.data.data().containsKey(DateTime.now()
                          .add(Duration(days: 1))
                          .weekday
                          .toString()))
                        slots_2 = snapshot.data.data()[DateTime.now()
                            .add(Duration(days: 1))
                            .weekday
                            .toString()];
                      if (snapshot.data.data().containsKey(DateTime.now()
                          .add(Duration(days: 2))
                          .weekday
                          .toString()))
                        slots_3 = snapshot.data.data()[DateTime.now()
                            .add(Duration(days: 2))
                            .weekday
                            .toString()];
                      if (snapshot.data.data().containsKey(DateTime.now()
                          .add(Duration(days: 3))
                          .weekday
                          .toString()))
                        slots_4 = snapshot.data.data()[DateTime.now()
                            .add(Duration(days: 3))
                            .weekday
                            .toString()];
                      if (snapshot.data.data().containsKey(DateTime.now()
                          .add(Duration(days: 4))
                          .weekday
                          .toString()))
                        slots_5 = snapshot.data.data()[DateTime.now()
                            .add(Duration(days: 4))
                            .weekday
                            .toString()];
                      if (snapshot.data.data().containsKey(DateTime.now()
                          .add(Duration(days: 5))
                          .weekday
                          .toString()))
                        slots_6 = snapshot.data.data()[DateTime.now()
                            .add(Duration(days: 5))
                            .weekday
                            .toString()];
                      if (snapshot.data.data().containsKey(DateTime.now()
                          .add(Duration(days: 6))
                          .weekday
                          .toString()))
                        slots_7 = snapshot.data.data()[DateTime.now()
                            .add(Duration(days: 6))
                            .weekday
                            .toString()];

                      return ListView(
                        children: [
                          if (snapshot.data
                              .data()
                              .containsKey(DateTime.now().weekday.toString()))
                            MyTextView(
                              str: 'Today ' + TodayTitle(),
                              size: 20,
                            ),
                          if (snapshot.data
                              .data()
                              .containsKey(DateTime.now().weekday.toString()))
                            Wrap(
                              children: slots_1.keys
                                  .map((e) => Container(
                                      padding: EdgeInsets.all(10),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 5.0,
                                              primary:
                                                  slots_1[e.toString()] == '0'
                                                      ? Colors.deepPurpleAccent
                                                      : Colors.black45),
                                          onPressed: () {
                                            if (slots_1[e.toString()] == '0')
                                              _handleTimeSlotClick(
                                                  slots_1, e.toString());
                                          },
                                          child: Text(
                                            e.toString(),
                                            style: TextStyle(fontSize: 16),
                                          ))))
                                  .toList()
                                  .cast<Widget>(),
                            ),
                          if (snapshot.data.data().containsKey(DateTime.now()
                              .add(Duration(days: 1))
                              .weekday
                              .toString()))
                            MyTextView(
                              str: 'Tomorrow ' + TodayTitle(i: 1),
                              size: 20,
                            ),
                          if (snapshot.data.data().containsKey(DateTime.now()
                              .add(Duration(days: 1))
                              .weekday
                              .toString()))
                            Wrap(
                              children: slots_2.keys
                                  .map((e) => Container(
                                      padding: EdgeInsets.all(10),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 5.0,
                                              primary:
                                                  slots_2[e.toString()] == '0'
                                                      ? Colors.deepPurpleAccent
                                                      : Colors.black45),
                                          onPressed: () {},
                                          child: Text(
                                            e.toString(),
                                            style: TextStyle(fontSize: 16),
                                          ))))
                                  .toList()
                                  .cast<Widget>(),
                            ),
                          if (snapshot.data.data().containsKey(DateTime.now()
                              .add(Duration(days: 2))
                              .weekday
                              .toString()))
                            MyTextView(
                              str: TodayTitle(i: 2),
                              size: 20,
                            ),
                          if (snapshot.data.data().containsKey(DateTime.now()
                              .add(Duration(days: 2))
                              .weekday
                              .toString()))
                            Wrap(
                              children: slots_3.keys
                                  .map((e) => Container(
                                      padding: EdgeInsets.all(10),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 5.0,
                                              primary:
                                                  slots_3[e.toString()] == '0'
                                                      ? Colors.deepPurpleAccent
                                                      : Colors.black45),
                                          onPressed: () {},
                                          child: Text(
                                            e.toString(),
                                            style: TextStyle(fontSize: 16),
                                          ))))
                                  .toList()
                                  .cast<Widget>(),
                            ),
                          if (snapshot.data.data().containsKey(DateTime.now()
                              .add(Duration(days: 3))
                              .weekday
                              .toString()))
                            MyTextView(
                              str: TodayTitle(i: 3),
                              size: 20,
                            ),
                          if (snapshot.data.data().containsKey(DateTime.now()
                              .add(Duration(days: 3))
                              .weekday
                              .toString()))
                            Wrap(
                              children: slots_4.keys
                                  .map((e) => Container(
                                      padding: EdgeInsets.all(10),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 5.0,
                                              primary:
                                                  slots_4[e.toString()] == '0'
                                                      ? Colors.deepPurpleAccent
                                                      : Colors.black45),
                                          onPressed: () {},
                                          child: Text(
                                            e.toString(),
                                            style: TextStyle(fontSize: 16),
                                          ))))
                                  .toList()
                                  .cast<Widget>(),
                            ),
                          if (snapshot.data.data().containsKey(DateTime.now()
                              .add(Duration(days: 4))
                              .weekday
                              .toString()))
                            MyTextView(
                              str: TodayTitle(i: 4),
                              size: 20,
                            ),
                          if (snapshot.data.data().containsKey(DateTime.now()
                              .add(Duration(days: 4))
                              .weekday
                              .toString()))
                            Wrap(
                              children: slots_5.keys
                                  .map((e) => Container(
                                      padding: EdgeInsets.all(10),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 5.0,
                                              primary:
                                                  slots_5[e.toString()] == '0'
                                                      ? Colors.deepPurpleAccent
                                                      : Colors.black45),
                                          onPressed: () {},
                                          child: Text(
                                            e.toString(),
                                            style: TextStyle(fontSize: 16),
                                          ))))
                                  .toList()
                                  .cast<Widget>(),
                            ),
                          if (snapshot.data.data().containsKey(DateTime.now()
                              .add(Duration(days: 5))
                              .weekday
                              .toString()))
                            MyTextView(
                              str: TodayTitle(i: 5),
                              size: 20,
                            ),
                          if (snapshot.data.data().containsKey(DateTime.now()
                              .add(Duration(days: 5))
                              .weekday
                              .toString()))
                            Wrap(
                              children: slots_6.keys
                                  .map((e) => Container(
                                      padding: EdgeInsets.all(10),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 5.0,
                                              primary:
                                                  slots_6[e.toString()] == '0'
                                                      ? Colors.deepPurpleAccent
                                                      : Colors.black45),
                                          onPressed: () {},
                                          child: Text(
                                            e.toString(),
                                            style: TextStyle(fontSize: 16),
                                          ))))
                                  .toList()
                                  .cast<Widget>(),
                            ),
                          if (snapshot.data.data().containsKey(DateTime.now()
                              .add(Duration(days: 6))
                              .weekday
                              .toString()))
                            MyTextView(
                              str: TodayTitle(i: 6),
                              size: 20,
                            ),
                          if (snapshot.data.data().containsKey(DateTime.now()
                              .add(Duration(days: 6))
                              .weekday
                              .toString()))
                            Wrap(
                              children: slots_7.keys
                                  .map((e) => Container(
                                      padding: EdgeInsets.all(10),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 5.0,
                                              primary:
                                                  slots_7[e.toString()] == '0'
                                                      ? Colors.deepPurpleAccent
                                                      : Colors.black45),
                                          onPressed: () {},
                                          child: Text(
                                            e.toString(),
                                            style: TextStyle(fontSize: 16),
                                          ))))
                                  .toList()
                                  .cast<Widget>(),
                            ),
                        ],
                      );
                    }
                    return Center(
                      child: Text('No Data'),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      );
    else
      return Center(
        child: Text('Not Verified'),
      );
  }

  String TodayTitle({int i}) {
    if (i != null) now = DateTime.now().add(Duration(days: i));

    if (i == null)
      return now.day.toString() +
          ',' +
          DateFormat('MMMM').format(now).toString();

    return DateFormat('EEEE').format(now).toUpperCase() +
        ' ' +
        now.day.toString() +
        ',' +
        DateFormat('MMMM').format(now.add(Duration(days: i))).toString();
  }
}
