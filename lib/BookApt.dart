import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/DrProfile.dart';
import 'package:flutter_app/icare_user.dart';
import 'package:flutter_app/main.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'my_widgets.dart';

String drID;
bool emergency = false;

DateTime dateTime;
String data;
Map<String, dynamic> slotsDb;

class BookApt extends StatefulWidget {
  static const platform = const MethodChannel("razorpay_flutter");

  @override
  _BookAptState createState() => _BookAptState();
}

class _BookAptState extends State<BookApt> {
  Razorpay _razorpay;

  Map<String, dynamic> slots_1,
      slots_2,
      slots_3,
      slots_4,
      slots_5,
      slots_6,
      slots_7;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout({int i}) async {
    int amount = int.parse(drProfileData['9 fees']) * 100;
    if (i != null) amount = amount * i;
    var options = {
      'key': 'rzp_test_rhHDB1kSvuKkxC',
      'amount': amount,
      'name': 'iCare',
      'timeout': 60, // in seconds
      'description': 'Appointment Fees',
      'prefill': {'contact': userData['2 phone'], 'email': userData['3 email']},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    String id_code = UniqueKey().toString().substring(1, 7);

    String stringDateTime;
    if(emergency == false){
      stringDateTime = dateTime.toString().split(' ').first +' '+ data + ':00Z';
      dateTime = DateTime.parse(stringDateTime);
    }
    Map<String, dynamic> bookingData = {
      'emergency': emergency.toString(),
      'dataTime': emergency ? DateTime.now().toUtc() : dateTime.toUtc(),
      'paymentId': response.paymentId,
      'patientId': firebaseUser.uid,
      'drId': drID,
      'slot': data,
      'status': 'pending',
      'id_code': id_code
    };

    FirebaseFirestore.instance.collection('appointments').doc(id_code).set(bookingData);

    if(emergency == false)
      Navigator.pop(context);
    slotsDb.update(data, (value) => id_code);
    FirebaseFirestore.instance
        .collection('Timeslots')
        .doc(drID)
        .update({dateTime.weekday.toString(): slotsDb}).whenComplete(() {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Booking Successful'),
          content: Text('Payment ID : ' + response.paymentId),
          elevation: 10.0,
          backgroundColor: Colors.white,
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 2.0, primary: Colors.deepPurpleAccent),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Done',
                  style: TextStyle(fontSize: 16),
                )),
          ],
        ),
      );
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pop(context);
    Map msg = json.decode(response.message);
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('PaymentError'),
        content: Text('Payment Error Code : ' +
            response.code.toString() +
            '\nMessage : ' +
            msg['error']['description']),
        elevation: 10.0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 2.0, primary: Colors.deepPurpleAccent),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Ok',
                style: TextStyle(fontSize: 16),
              )),
        ],
      ),
    );


    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ERROR: " + response.code.toString() + " - " + response.message)));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('External Wallet'),
        content: Text('Wallet Name : ' + response.walletName),
        elevation: 10.0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 2.0, primary: Colors.deepPurpleAccent),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Ok',
                style: TextStyle(fontSize: 16),
              )),
        ],
      ),
    );
    //print("ICareRazorEXTERNAL_WALLET: " + response.walletName);
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("EXTERNAL_WALLET: " + response.walletName)));
  }

  @override
  Widget build(BuildContext context) {
    void _handleTimeSlot(DateTime dt, var d, Map<String, dynamic> sdb) {
      dateTime = dt;
      data = d;
      slotsDb = sdb;
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Confirm Book'),
          elevation: 10.0,
          content: ListTile(
              title: Text('Fees'),
              trailing: Text(
                drProfileData['9 fees'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              )),
          backgroundColor: Colors.white,
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 2.0, primary: Colors.deepPurpleAccent),
                onPressed: () {
                  openCheckout();
                },
                child: Text(
                  'Pay',
                  style: TextStyle(fontSize: 16),
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 2.0, primary: Colors.deepPurpleAccent),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16),
                )),
          ],
        ),
      );
    }

        return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Timeslots')
                .doc(drID)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.exists) {
                  if (snapshot.data
                      .data()
                      .containsKey(DateTime.now().weekday.toString()))
                    slots_1 =
                        snapshot.data.data()[DateTime.now().weekday.toString()];
                  if (snapshot.data.data().containsKey(
                      DateTime.now().add(Duration(days: 1)).weekday.toString()))
                    slots_2 = snapshot.data.data()[DateTime.now()
                        .add(Duration(days: 1))
                        .weekday
                        .toString()];
                  if (snapshot.data.data().containsKey(
                      DateTime.now().add(Duration(days: 2)).weekday.toString()))
                    slots_3 = snapshot.data.data()[DateTime.now()
                        .add(Duration(days: 2))
                        .weekday
                        .toString()];
                  if (snapshot.data.data().containsKey(
                      DateTime.now().add(Duration(days: 3)).weekday.toString()))
                    slots_4 = snapshot.data.data()[DateTime.now()
                        .add(Duration(days: 3))
                        .weekday
                        .toString()];
                  if (snapshot.data.data().containsKey(
                      DateTime.now().add(Duration(days: 4)).weekday.toString()))
                    slots_5 = snapshot.data.data()[DateTime.now()
                        .add(Duration(days: 4))
                        .weekday
                        .toString()];
                  if (snapshot.data.data().containsKey(
                      DateTime.now().add(Duration(days: 5)).weekday.toString()))
                    slots_6 = snapshot.data.data()[DateTime.now()
                        .add(Duration(days: 5))
                        .weekday
                        .toString()];
                  if (snapshot.data.data().containsKey(
                      DateTime.now().add(Duration(days: 6)).weekday.toString()))
                    slots_7 = snapshot.data.data()[DateTime.now()
                        .add(Duration(days: 6))
                        .weekday
                        .toString()];

                  return ListView(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(20),
                              elevation: 5.0,
                              primary: drProfileData['99999 egbook'] == 'true'
                                  ? Colors.green
                                  : Colors.black45),
                          onPressed: () {
                            if (drProfileData['99999 egbook'] == 'true') {
                              emergency = true;
                              data = DateTime.now().hour.toString() + ':' + DateTime.now().minute.toString();
                              openCheckout(i: 2);
                              }
                          },
                          child: Text(
                            'Emergency book',
                            style: TextStyle(fontSize: 18),
                          )),
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
                                          primary: slots_1[e.toString()] == '0'
                                              ? Colors.deepPurpleAccent
                                              : Colors.black45),
                                      onPressed: () {
                                        if (slots_1[e.toString()] == '0')
                                          _handleTimeSlot(DateTime.now(),
                                              e.toString(), slots_1);
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
                                          primary: slots_2[e.toString()] == '0'
                                              ? Colors.deepPurpleAccent
                                              : Colors.black45),
                                      onPressed: () {
                                        if (slots_2[e.toString()] == '0')
                                          _handleTimeSlot(
                                              DateTime.now()
                                                  .add(Duration(days: 1)),
                                              e.toString(),
                                              slots_2);
                                      },
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
                                          primary: slots_3[e.toString()] == '0'
                                              ? Colors.deepPurpleAccent
                                              : Colors.black45),
                                      onPressed: () {
                                        if (slots_3[e.toString()] == '0')
                                          _handleTimeSlot(
                                              DateTime.now()
                                                  .add(Duration(days: 2)),
                                              e.toString(),
                                              slots_3);
                                      },
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
                                          primary: slots_4[e.toString()] == '0'
                                              ? Colors.deepPurpleAccent
                                              : Colors.black45),
                                      onPressed: () {
                                        if (slots_4[e.toString()] == '0')
                                          _handleTimeSlot(
                                              DateTime.now()
                                                  .add(Duration(days: 3)),
                                              e.toString(),
                                              slots_4);
                                      },
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
                                          primary: slots_5[e.toString()] == '0'
                                              ? Colors.deepPurpleAccent
                                              : Colors.black45),
                                      onPressed: () {
                                        if (slots_5[e.toString()] == '0')
                                          _handleTimeSlot(
                                              DateTime.now()
                                                  .add(Duration(days: 4)),
                                              e.toString(),
                                              slots_5);
                                      },
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
                                          primary: slots_6[e.toString()] == '0'
                                              ? Colors.deepPurpleAccent
                                              : Colors.black45),
                                      onPressed: () {
                                        if (slots_6[e.toString()] == '0')
                                          _handleTimeSlot(
                                              DateTime.now()
                                                  .add(Duration(days: 5)),
                                              e.toString(),
                                              slots_6);
                                      },
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
                                          primary: slots_7[e.toString()] == '0'
                                              ? Colors.deepPurpleAccent
                                              : Colors.black45),
                                      onPressed: () {
                                        if (slots_7[e.toString()] == '0')
                                          _handleTimeSlot(
                                              DateTime.now()
                                                  .add(Duration(days: 6)),
                                              e.toString(),
                                              slots_7);
                                      },
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
        ));
  }

  String TodayTitle({int i}) {
    DateTime _now = DateTime.now();
    if (i != null) _now = DateTime.now().add(Duration(days: i));

    if (i == null)
      return _now.day.toString() +
          ',' +
          DateFormat('MMMM').format(_now).toString();

    return DateFormat('EEEE').format(_now).toUpperCase() +
        ' ' +
        _now.day.toString() +
        ',' +
        DateFormat('MMMM').format(_now).toString();
  }
}
