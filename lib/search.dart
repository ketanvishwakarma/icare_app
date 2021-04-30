import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/DoctorList.dart';
import 'package:flutter_app/my_widgets.dart';


final List<String> specialties = [
  "Dentist",
  "General Physician",
  "Pediatrician",
  "Ayurveda",
  "Orthopedist",
  "Gynecologist/obstetrician",
  "Gynecologist",
  "Homeopath",
  "Cardiologist",
  "General Surgeon",
  "Ophthalmologist",
  "Ophthalmologist/ Eye Surgeon",
  "Dermatologist/cosmetologist",
  "Spa",
  "Dermatologist",
  "Oral Surgeon",
  "Physiotherapist",
  "Dental Surgeon",
  "Urologist",
  "Ear-nose-throat (ent) Specialist",
  "Orthodontist",
  "Diabetologist",
  "Psychiatrist",
  "Endodontist"
];

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final listof = List<String>.generate(10, (i) => "Category $i");


  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: specialties.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              drFilter = specialties[index];
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DroctorList()));
            },
              title: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                child: Text(
                  specialties[index],
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: 20,
                  ),
                ),
              ),
              trailing: Icon(Icons.navigate_next),
          );
        },),
    );
  }
}