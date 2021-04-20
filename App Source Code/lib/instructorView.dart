import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './InstQuizSum.dart';

class InstructorView extends StatefulWidget {
  InstructorView({
    Key key,
    this.title,
    this.qNum,
  }) : super(key: key);

  final String title;
  final int qNum;

  @override
  _InstructorViewState createState() => _InstructorViewState();
}

class _InstructorViewState extends State<InstructorView> {
  int _counter = 0;

  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final db = FirebaseFirestore.instance;
  final id = 40558;
  var email;
  var qID;
  @override
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Instructor',
            //textAlign: TextAlign.center,
            //centerTitle: true,
            style: TextStyle(fontSize: 25),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(25.0),
            child: Column(
              //child: new Padding(padding: EdgeInsets.all(20.0)),
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 125,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Enter Login Info:',
                          style: new TextStyle(
                              color: Colors.black, fontSize: 15.0)),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(),
                      ),
                      //contentPadding: EdgeInsets.only(bottom: 20.0),
                      hintText: 'Enter your email',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your email';
                      }
                      email = value;
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Enter the Quiz ID',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid ID';
                      }
                      qID = value;
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState.validate()) {
                        print(email);
                        print(qID);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InstQuizSum(
                                    title: 'Quiz', qNum: (widget.qNum + 1))));
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
