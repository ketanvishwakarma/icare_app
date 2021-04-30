import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/dr_home.dart';

import 'dr_appointments_edit.dart';
import 'dr_get_Slots.dart';
import 'horizontal_time_picker.dart';
import 'main.dart';
import 'time_picker_util.dart';

class CheckSlots extends StatefulWidget {
  @override
  _CheckSlotsState createState() => _CheckSlotsState();
}

Future<Future> slots() async {
  await collectionReference
      .doc(firebaseUser.uid)
      .update({'99999 egbook' : egBook.toString()});

  if (dayMon)
    await FirebaseFirestore.instance
        .collection('Timeslots')
        .doc(firebaseUser.uid)
        .set({'1': dbTimeSlots});
  if (dayTue)
    await FirebaseFirestore.instance
        .collection('Timeslots')
        .doc(firebaseUser.uid)
        .update({'2': dbTimeSlots});
  if (dayWed)
    await FirebaseFirestore.instance
        .collection('Timeslots')
        .doc(firebaseUser.uid)
        .update({'3': dbTimeSlots});
  if (dayThu)
    await FirebaseFirestore.instance
        .collection('Timeslots')
        .doc(firebaseUser.uid)
        .update({'4': dbTimeSlots});
  if (dayFri)
    await FirebaseFirestore.instance
        .collection('Timeslots')
        .doc(firebaseUser.uid)
        .update({'5': dbTimeSlots});
  if (daySat)
    await FirebaseFirestore.instance
        .collection('Timeslots')
        .doc(firebaseUser.uid)
        .update({'6': dbTimeSlots});
  if (daySun)
    await FirebaseFirestore.instance
        .collection('Timeslots')
        .doc(firebaseUser.uid)
        .update({'7': dbTimeSlots});
}

class _CheckSlotsState extends State<CheckSlots> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                HorizontalTimePicker(
                  key: UniqueKey(),
                  startTimeInHour: startTime.hour,
                  endTimeInHour: endTime.hour,
                  timeIntervalInMinutes: interval,
                  dateForTime: DateTime.now(),
                  selectedTimeTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                    height: 1.0,
                  ),
                  timeTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                    height: 1.0,
                  ),
                  defaultDecoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border.fromBorderSide(BorderSide(
                      color: Color.fromARGB(255, 151, 151, 151),
                      width: 1,
                      style: BorderStyle.solid,
                    )),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Colors.pinkAccent,
                    border: Border.fromBorderSide(BorderSide(
                      color: Color.fromARGB(255, 151, 151, 151),
                      width: 1,
                      style: BorderStyle.solid,
                    )),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  disabledDecoration: const BoxDecoration(
                    color: Colors.black26,
                    border: Border.fromBorderSide(BorderSide(
                      color: Color.fromARGB(255, 151, 151, 151),
                      width: 1,
                      style: BorderStyle.solid,
                    )),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  showDisabled: true,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      padding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      color: Colors.pinkAccent,
                      onPressed: () {
                        slots().whenComplete(() {
                          setState(() {
                            status = true;
                          });
                        });
                        counter = 0;
                        FocusScope.of(context).unfocus();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => DrHome()),
                                (Route<dynamic> route) => false);
                      },
                      child: Text(
                        'Done',
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
            )),
      ),
    );
  }
}
