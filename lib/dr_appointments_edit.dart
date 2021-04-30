import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/my_widgets.dart';
import 'package:flutter_app/time_picker_util.dart';

import 'checkSlots.dart';
import 'icare_user.dart';

class DrAppointmentsEdit extends StatefulWidget {
  @override
  _DrAppointmentsEditState createState() => _DrAppointmentsEditState();
}

DateTime startTime;
DateTime endTime;
int interval = 0;

bool egBook = false;
bool dayMon = false;
bool dayTue = false;
bool dayWed = false;
bool dayThu = false;
bool dayFri = false;
bool daySat = false;
bool daySun = false;

class _DrAppointmentsEditState extends State<DrAppointmentsEdit> {
  final TextEditingController _slotDurationController = TextEditingController();

  @override
  void initState() {
    startTime = DateTime.now();
    endTime = DateTime.now().add(Duration(hours: 3));
    super.initState();
  }

  displayDialog(text) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Invalid Input'),
        content: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: userData['0 verified'] == 'No'
              ? Text('Not Verified')
              : Column(
                  children: <Widget>[
                    MyTextView(str: 'Select Your Appointment Start Time'),
                    Container(
                      height: size.height * .2,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: startTime,
                        onDateTimeChanged: (DateTime addSelectedDate) {
                          setState(() {
                            counter = 0;
                            startTime = addSelectedDate;
                          });
                        },
                      ),
                    ),
                    MyTextView(str: 'Select Your Appointment End Time'),
                    Container(
                      height: size.height * .2,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: endTime,
                        onDateTimeChanged: (DateTime addSelectedDate) {
                          setState(() {
                            counter = 0;
                            endTime = addSelectedDate;
                          });
                        },
                      ),
                    ),
                    MyTextView(str: 'How Much Time Each Appointment Takes..'),
                    MyTextField(
                      hintText: 'In Minutes',
                      maxLength: 2,
                      keyBoardType: TextInputType.number,
                      textEditingController: _slotDurationController,
                    ),
                    MyTextView(str: 'Emergency Booking!!'),
                    CheckboxListTile(
                      activeColor: Colors.green,
                      selectedTileColor: Colors.green,
                      title: Text('Emergency Booking',style: TextStyle(color: egBook ? Colors.green : Colors.black87),),
                      value: egBook,
                      onChanged: (bool value) {
                        setState(() {
                          egBook = value;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    MyTextView(str: 'Select Days!!'),
                    CheckboxListTile(
                      title: Text('Monday'),
                      value: dayMon,
                      onChanged: (bool value) {
                        setState(() {
                          dayMon = value;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: Text('Tuesday'),
                      value: dayTue,
                      onChanged: (bool value) {
                        setState(() {
                          dayTue = value;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: Text('Wednesday'),
                      value: dayWed,
                      onChanged: (bool value) {
                        setState(() {
                          dayWed = value;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: Text('Thursday'),
                      value: dayThu,
                      onChanged: (bool value) {
                        setState(() {
                          dayThu = value;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: Text('Friday'),
                      value: dayFri,
                      onChanged: (bool value) {
                        setState(() {
                          dayFri = value;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: Text('Saturday'),
                      value: daySat,
                      onChanged: (bool value) {
                        setState(() {
                          daySat = value;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: Text('Sunday'),
                      value: daySun,
                      onChanged: (bool value) {
                        setState(() {
                          daySun = value;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      width: size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          color: Colors.pinkAccent,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (_slotDurationController.text != null &&
                                (dayMon ||
                                    dayTue ||
                                    dayWed ||
                                    dayThu ||
                                    dayFri ||
                                    daySat ||
                                    daySun)) {
                              setState(() {
                                interval =
                                    int.parse(_slotDurationController.text);
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckSlots()));
                              //Navigator.pop(context);
                            } else {
                              displayDialog(_slotDurationController.text);
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
                ),
        ),
      )),
    );
  }
}
