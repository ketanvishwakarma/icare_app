import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/dr_home.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/login.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

User firebaseUser;
CollectionReference collectionReference;
String userType;

setColor() async {
  await FlutterStatusbarcolor.setStatusBarColor(Colors.white);
  FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'iCare',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        accentColor: Colors.deepPurpleAccent,
        primaryColor: Colors.pinkAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Gotham',
      ),
      home: App()));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    setColor();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setColor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: FutureBuilder(
          // Initialize FlutterFire
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return Text('Error... Please check you internet ');
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              if (FirebaseAuth.instance.currentUser != null) {
                firebaseUser = FirebaseAuth.instance.currentUser;

                FirebaseFirestore.instance.doc("Doctor/${firebaseUser.uid}").get().then((doc) {
                  if (doc.exists){
                   if(userType == null){
                     setState(() {
                       userType = 'yes';
                     });
                   }
                  }
                  else{
                    if(userType == null){
                      setState(() {
                        userType = 'no';
                      });
                    }
                  }
                });
                if(userType == 'no')
                  return home();
                if(userType == 'yes')
                  return DrHome();
                return CircularProgressIndicator();
              }

              return Login();
            }
            // Otherwise, show something whilst waiting for initialization to complete
            return CircularProgressIndicator();
          },
        )));
  }

}
