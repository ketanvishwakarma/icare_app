import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextInputType keyBoardType;
  final int maxLength;
  final bool obscureText;
  final bool checkWidgetType;
  final TextEditingController textEditingController;

  const MyTextField(
      {Key key,
      this.hintText,
      this.keyBoardType,
      this.maxLength,
      this.obscureText,
      this.checkWidgetType,
      this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent[200],
        borderRadius: BorderRadius.circular(29),
      ),
      width: size.width,
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
          autofocus: false,
          autocorrect: true,
          maxLines: null,
          controller: textEditingController,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please Enter Data';
              /*ScaffoldMessenger
                  .of(context)
                  .showSnackBar(SnackBar(content: Text('Please Enter Data')));
*/
            }
            return null;
          },
          obscureText: (obscureText == null) ? false : true,
          maxLength: maxLength,
          keyboardType: keyBoardType,
          cursorColor: Colors.pinkAccent,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          decoration: new InputDecoration(
            errorStyle: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            counterText: '',
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.white60,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            border: InputBorder.none,
          )),
    );
  }
}
class MyTextView extends StatelessWidget {
  final String str;
  final double size;
  final FontWeight weight;
  const MyTextView({Key key, this.str, this.weight, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
      top: 20,
      right: 20,
      left: 20,
    ),
      child: Text(
        str,
        style: TextStyle(
          color: Colors.deepPurpleAccent,
          fontWeight: weight,
          fontSize: size == null ? 20 : size,
        ),
      ),
    );
  }
}

