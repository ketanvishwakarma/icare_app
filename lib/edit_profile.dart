import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/icare_user.dart';
import 'package:flutter_app/my_widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'dr_get_speciality.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';

import 'dr_get_speciality.dart';
import 'main.dart';
import 'my_widgets.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

enum gender { Male, Female, Other }
// ignore: missing_return

class _EditProfileState extends State<EditProfile> {

  Position position;
  Coordinates coordinates;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();

  gender _character = gender.Other;
  DateTime selectedDate = DateTime.now();


  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final bloodGroup = ['A+', 'A-', 'AB+', 'AB-', 'B+', 'B-', 'O+', 'O-'];

  String _stringAddress;

  Size size;

  @override
  void initState() {
    super.initState();
    if (userData.length > 4) {
      var dob = userData['5 dob'];
      print(dob);
      selectedDate = DateTime(int.parse(dob.toString().split('-')[0]),int.parse(dob.toString().split('-')[1]),int.parse(dob.toString().split('-')[2]));
      coordinates = new Coordinates(userData['_ latitude'], userData['_ longitude']);
      _nameController.text = userData['1 name'];
      _stringAddress = userData['6 address'];
      _emailController.text = userData['3 email'];
      _bloodGroupController.text = userData['7 bloodGroup'];
      _weightController.text = userData['8 weight'];
      _feesController.text = userData['9 fees'];
      _experienceController.text = userData['999 experience'];
      _educationController.text = userData['9999 education'];
      if (userData['4 gender'] == 'Male') _character = gender.Male;
      if (userData['4 gender'] == 'Female') _character = gender.Male;
    }
  }

  Future<Position> _determinePosition() async {
    position =
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    coordinates = Coordinates(
        position.latitude, position.longitude);

    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var first = addresses.first;
    /*print('locality ${first.locality},adminArea ${first
        .adminArea},\nsubLocality ${first.subLocality}, subAdminArea ${first
        .subAdminArea},\naddressLine${first.addressLine},featureName ${first
        .featureName},thoroughfare${first.thoroughfare}, subThoroughfare ${first
        .subThoroughfare}');
*/
    setState(() {
      _stringAddress = first.addressLine;
    });

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // ignore: missing_return
  Future<Future> addUserGlobal() async {
    // Call the user's CollectionReference to add a new user
    userType == 'yes' ?
    await collectionReference
        .doc(firebaseUser.uid)
        .update({
      '1 name': _nameController.text.trim(),
      '2 phone': firebaseUser.phoneNumber,
      '3 email': _emailController.text.trim(),
      '4 gender': _character
          .toString()
          .split('.')
          .last,
      '5 dob': '${selectedDate.toLocal()}'.split(' ')[0],
      '_ latitude': coordinates.latitude,
      '_ longitude': coordinates.longitude,
      '6 address': _stringAddress,
      '7 bloodGroup': _bloodGroupController.text.trim(),
      '8 weight': _weightController.text.trim(),
      '9 fees': _feesController.text.trim(),
      '99 speciality': drSpeciality,
      '999 experience': _experienceController.text.trim(),
      '9999 education': _educationController.text.trim(),
    })
        .then((value) => value)
        .catchError((error) => print("Failed to add user: $error")) :
    await collectionReference
        .doc(firebaseUser.uid)
        .update({
      '1 name': _nameController.text.trim(),
      '2 phone': firebaseUser.phoneNumber,
      '3 email': _emailController.text.trim(),
      '4 gender': _character
          .toString()
          .split('.')
          .last,
      '5 dob': '${selectedDate.toLocal()}'.split(' ')[0],
      '6 address': _stringAddress,
      '_ latitude': coordinates.latitude,
      '_ longitude': coordinates.longitude,
      '7 bloodGroup': _bloodGroupController.text.trim(),
      '8 weight': _weightController.text.trim(),
    })
        .then((value) => value)
        .catchError((error) => print("Failed to add user: $error"));
  }

  _selectDate(BuildContext context) async {


    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
              primaryColor: Colors.deepPurpleAccent,
              backgroundColor: Colors.deepPurpleAccent,
              accentColor: Colors.deepPurpleAccent),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  displaySnackBar(text) {
    final snackBar = SnackBar(content: Text(text));
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  displayDialog(text) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            title: Text('Invalid Input'),
            content: Text(text),
          ),
    );
  }

  bool checkEmail(email) {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }


  @override
  Widget build(BuildContext context) {
    size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Container(
            width: size.width,
            height: size.height,
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: new SingleChildScrollView(
                child: new Form(
                  key: _formKey,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset("assets/images/logo.jpg"),
                        width: size.width,
                        margin: EdgeInsets.only(top: 50),
                      ),
                      Container(
                        width: size.width,
                        margin: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: Text(
                          "",
                          style: TextStyle(
                            color: Colors.pinkAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      //Text('$_status'),
                      MyTextField(
                          textEditingController: _nameController,
                          keyBoardType: TextInputType.text,
                          hintText: 'Name'),
                      MyTextField(
                          textEditingController: _emailController,
                          keyBoardType: TextInputType.emailAddress,
                          hintText: 'Email-ID'),
                      MyTextField(
                          textEditingController: _weightController,
                          keyBoardType: TextInputType.number,
                          maxLength: 3,
                          hintText: 'Weight'),
                      MyTextField(
                          textEditingController: _bloodGroupController,
                          keyBoardType: TextInputType.text,
                          maxLength: 3,
                          hintText: 'BloodGroup'),
                      ListTile(
                        onTap: _determinePosition,
                        title: Text(_stringAddress.toString()),
                        trailing: Icon(Icons.my_location,color: Colors.deepPurpleAccent,),
                        ),
                      if (userType == 'yes')
                        Column(
                          children: [
                            MyTextField(
                                textEditingController: _feesController,
                                keyBoardType: TextInputType.number,
                                maxLength: 4,
                                hintText: 'Fees'),
                            MyTextField(
                                textEditingController: _experienceController,
                                keyBoardType: TextInputType.number,
                                maxLength: 2,
                                hintText: 'Experience Years'),
                            MyTextField(
                                textEditingController: _educationController,
                                keyBoardType: TextInputType.text,
                                hintText: 'Education'),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DrSelectSpeciality(),
                                ));
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                width: size.width,
                                child: Text(
                                  userData['99 speciality'] != null ?
                                  'Select Speciality : ${userData['99 speciality']}' :
                                  'Select Speciality : $drSpeciality' ,
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ],
                        ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        width: size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(children: [
                              Text(
                                'Male',
                                style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Radio<gender>(
                                value: gender.Male,
                                groupValue: _character,
                                onChanged: (gender value) {
                                  setState(() {
                                    _character = value;
                                  });
                                },
                              ),
                            ]),
                            Column(children: [
                              Text(
                                'Female',
                                style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Radio<gender>(
                                value: gender.Female,
                                groupValue: _character,
                                onChanged: (gender value) {
                                  setState(() {
                                    _character = value;
                                  });
                                },
                              ),
                            ]),
                            Column(children: [
                              Text(
                                'Other',
                                style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Radio<gender>(
                                value: gender.Other,
                                groupValue: _character,
                                onChanged: (gender value) {
                                  setState(() {
                                    _character = value;
                                  });
                                },
                              ),
                            ]),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          width: size.width,
                          child: Text(
                            userData['5 dob'] != null ?
                            'DateOfBirth : ${userData['5 dob']}' :
                            'DateOfBirth : ' +
                                "${selectedDate.toLocal()}".split(' ')[0],
                            style: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
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
                            padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            color: Colors.pinkAccent,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState.validate()) {
                                if (int.parse(
                                    _weightController.text.toString()) >=
                                    150) {
                                  displayDialog(
                                      '${_weightController
                                          .text} is invalid weight');
                                }
                                if (bloodGroup.contains(
                                    _bloodGroupController.text
                                        .toString()
                                        .toUpperCase()) ==
                                    false) {
                                  displayDialog(
                                      '${_bloodGroupController
                                          .text} is invalid blood group');
                                }
                                if (checkEmail(
                                    _emailController.text.toString()) ==
                                    false) {
                                  displayDialog(
                                      '${_emailController
                                          .text} is invalid email address');
                                }
                                if (_stringAddress == null) {
                                  displayDialog(
                                      'Invalid address');
                                }
                                addUserGlobal().whenComplete(
                                        () => Navigator.of(context).pop());
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
                ))));
  }
}
