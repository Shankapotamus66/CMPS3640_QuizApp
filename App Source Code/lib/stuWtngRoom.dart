import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_appkk/questionPage.dart';

class WaitingPage extends StatefulWidget {
  WaitingPage({Key key, this.title, this.qNum,}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final int qNum;
  @override
  _WaitingPageState createState() => _WaitingPageState();
}



class _WaitingPageState extends State<WaitingPage> {
  int _counter = 0;
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final db = FirebaseFirestore.instance;
  final id = 40558;
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Waiting Room',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 30
          ),
        ),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              StreamBuilder<QuerySnapshot>(

                stream: FirebaseFirestore.instance.collection('Quizs').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Loading....');
                  }

                  else if (snapshot.data.docs.length == 0) {
                    return Text("No data");
                  }
                  else if (snapshot.data.docs.length != 0) {
                    var doc = snapshot.data.docs;
                    var reference = doc[0].id;
                    var title = doc[0]['title'];
                    var tLimit = doc[0]['tLimit'];
                    if (doc[0]['valid'] == 1){

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => QuestionPage(title: "Question 1", qNum: 0)
                          )
                      );
                      return Text('Hello');
                    }
                    return StreamBuilder<QuerySnapshot>(
                        stream: db.collection('Quizs').doc(reference).collection(
                            'questions').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text('Loading....');
                          }
                          else {
                            var data = snapshot.data.docs;
                            var length = data.length;
                            List<String> answers = List.from(data[widget.qNum]['answers']);
                            var correct = data[widget.qNum]['correct'];
                            var newReference = data[widget.qNum].id;

                            DocumentReference docRef = FirebaseFirestore.instance.collection("Quizs").doc(reference).collection('questions').doc(newReference);
                            return Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Column(children: [

                              new Align (child: new Text("Please wait for the instructor to start the quiz1",
                                style: new TextStyle(fontSize: 20.0),), //so big text
                                alignment: FractionalOffset.topLeft,),
                              new Divider(color: Colors.blue,),
                              new Align (child: new Text("Title: $title"),
                                alignment: FractionalOffset.topLeft,),
                              new Divider(color: Colors.blue,),
                              new Align (child: new Text("Number of questions $length"),
                                alignment: FractionalOffset.topLeft,),
                              new Divider(color: Colors.blue,),
                              new Align (child: new Text("Time limit: $tLimit"),
                                alignment: FractionalOffset.topLeft,),
                              new Divider(color: Colors.blue,),
                              new Align (child: new Text("Description: null"),
                                alignment: FractionalOffset.topLeft,),
                              new Divider(color: Colors.blue,),
                              new Row(mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[ //add some actions, icons...etc
                                  //new FlatButton(onPressed: () {}, child: new Text("EDIT")),
                                  //new FlatButton(onPressed: () {},
                                  //   child: new Text("DELETE",
                                  //    style: new TextStyle(color: Colors.redAccent),))
                                ],),
                            ]
                            )
                            );
                          }
                        }
                    );
                  }
                  else
                    return Text("Sorry");
                },
              )
            ],
          )
      ),
    );
  }

}