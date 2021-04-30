import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'my_widgets.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _phoneNumberController =
      new TextEditingController();
  final TextEditingController _otpController = new TextEditingController();

  User _firebaseUser;

  AuthCredential _phoneAuthCredential;
  String _verificationId;
  bool validUser = false;
  String _status = 'thisDevice';
  String buttonText = 'Verify';
  String progressBar = 'done';
  Size size;

  @override
  void initState() {
    super.initState();
    this._firebaseUser  = FirebaseAuth.instance.currentUser;
  }

  displaySnackBar(text) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.deepPurple,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<void> _submitPhoneNumber() {
    /// NOTE: Either append your phone number country code or add in the code itself
    /// Since I'm in India we use "+91 " as prefix `phoneNumber`
    String phoneNumber = "+91 " + _phoneNumberController.text.toString().trim();

    /// The below functions are the callbacks, separated so as to make code more redable
    void verificationCompleted(AuthCredential phoneAuthCredential) async {
      print('verificationCompleted');
      displaySnackBar('verificationCompleted');
      this._phoneAuthCredential = phoneAuthCredential;
      _login().whenComplete((){
        if (_firebaseUser != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => App()),
          );
        }
      });
    }

    void verificationFailed(FirebaseAuthException error) {
    }

    void codeSent(String verificationId, [int code]) {
      this._verificationId = verificationId;
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      setState(() {
        _status = 'notDevice';
      });
      displaySnackBar('Enter OTP and Press Verify Button');
    }

    FirebaseAuth.instance.verifyPhoneNumber(
      /// Make sure to prefix with your country code
      phoneNumber: phoneNumber,

      /// `seconds` didn't work. The underlying implementation code only reads in `millisenconds`
      timeout: Duration(milliseconds: 10000),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      /// When this function is called there is no need to enter the OTP, you can click on Login button to sigin directly as the device is now verified
      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }

  void _submitOTP() async {
    /// get the `smsCode` from the user
    String smsCode = _otpController.text.toString().trim();

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
    try {
      this._phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: this._verificationId, smsCode: smsCode);
      _login().whenComplete((){
        if (_firebaseUser != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => App()),
          );
        }
      });
    } catch (e) {
      print(e);
    }

  }

  Future<Future> _login() async {
    /// This method is used to login the user
    /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
    return await FirebaseAuth.instance
        .signInWithCredential(this._phoneAuthCredential)
        .then((UserCredential authRes) {
      _firebaseUser = authRes.user;
    }).catchError((e) => print(e));
  }


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
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
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Text(
                      "Hello,",
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: size.width,
                    margin: EdgeInsets.only(bottom: 10, left: 5),
                    child: Text(
                      "Welcome to iCareApp. Here you will get amazing features like health assistant, online appointment booking, health blog for your health.\n",
                      style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  MyTextField(
                      maxLength: 10,
                      textEditingController: _phoneNumberController,
                      keyBoardType: TextInputType.phone,
                      hintText: 'Enter Phone Number'),
                  (_status == 'notDevice')
                      ? MyTextField(
                          maxLength: 6,
                          textEditingController: _otpController,
                          keyBoardType: TextInputType.phone,
                          hintText: 'OTP')
                      : Text(''),
                  buttonText == 'Processing..' && _status != 'notDevice'
                      ? CircularProgressIndicator() : Text(''),

                  Container(
                      //margin: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      width: size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          color: Colors.pinkAccent,
                          onPressed: () {
                            setState(() {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState.validate()) {
                                if (_phoneNumberController.text.isNotEmpty &
                                    _otpController.text.isEmpty) {
                                  if (_firebaseUser != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => App()),
                                    );
                                  } else {
                                    displaySnackBar(
                                        'Please wait for few Seconds');
                                    buttonText = 'Processing..';
                                    _submitPhoneNumber();
                                  }
                                }
                                if (_phoneNumberController.text.isNotEmpty &
                                    _otpController.text.isNotEmpty) {
                                  progressBar = 'waiting';
                                  _submitOTP();
                                  if (_firebaseUser != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => App()),
                                    );
                                  }
                                }
                              }
                            });
                          },
                          child: Text(
                            'Verify',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ))));
  }
}
