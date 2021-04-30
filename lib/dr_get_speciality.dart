
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'edit_profile.dart';
import 'icare_user.dart';
import 'search.dart';

class DrSelectSpeciality extends StatefulWidget {
  @override
  _DrSelectSpecialityState createState() => _DrSelectSpecialityState();
}

String drSpeciality;

class _DrSelectSpecialityState extends State<DrSelectSpeciality> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Select Your Specialization'),backgroundColor: Colors.deepPurpleAccent,),
      body: Container(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: specialties.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  elevation: 1,
                  child: ListTile(
                      title: Text(
                        specialties.elementAt(index),
                        style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: Icon(
                        Icons.favorite_border,
                        color: Colors.black45,
                      ),
                      onTap: () {
                        setState(() {
                          userData['99 speciality'] = specialties[index];
                          drSpeciality = specialties[index];
                        });
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditProfile(),
                        ));
                      }));
            }),
      ),
    );
  }
}
