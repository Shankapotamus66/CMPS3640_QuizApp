import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage({
    Key key,
    this.title,
    this.qNum,
  }) : super(key: key);

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
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int _counter = 0;

  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final db = FirebaseFirestore.instance;
  final id = 40558;
  var valid = 0;
  var qID = "1239T";
  process() async {
    var quiz = await FirebaseFirestore.instance
        .collection('Quizs')
        .where('ID', isEqualTo: id)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                valid = doc[0]['valid'];
              })
            });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Quizs').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('Loading....');
              } else if (snapshot.data.docs.length == 0) {
                return Text("No data");
              } else if (snapshot.data.docs.length != 0) {
                var doc = snapshot.data.docs;
                var reference = doc[0].id;
                var title = doc[0]['title'];
                var tLimit = doc[0]['tLimit'];

                if (doc[0]['valid'] == 1) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: db
                          .collection('Quizs')
                          .doc(reference)
                          .collection('questions')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Loading....');
                        } else {
                          var data = snapshot.data.docs;
                          List<String> answers =
                              List.from(data[widget.qNum]['answers']);
                          var correct = data[widget.qNum]['correct'];
                          var newReference = data[widget.qNum].id;
                          DocumentReference docRef = FirebaseFirestore.instance
                              .collection("Quizs")
                              .doc(reference)
                              .collection('questions')
                              .doc(newReference);
                          final List<int> colorCodes = <int>[600, 100];
                          return Container(
                              child: Column(children: [
                            Container(
                              //height: 150.0,
                              width: double.infinity,
                              padding: const EdgeInsets.all(8.0),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: 120.0,
                                ),
                                child: Card(
                                  color: Colors.blueGrey[900],
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, left: 0.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            'Question ${widget.qNum + 1}:',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Card(
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              minHeight: 100.0,
                                              minWidth: double.infinity,
                                            ),
                                            child: Padding(
                                              //padding: EdgeInsets.symmetric(horizontal: 8.0),
                                              padding: EdgeInsets.only(
                                                  top: 5.0,
                                                  bottom: 5.0,
                                                  left: 8.0,
                                                  right: 8.0),
                                              child: Text(
                                                '${data[widget.qNum]['q_text']}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                height: 300.0,
                                child: ListView.separated(
                                  padding: const EdgeInsets.all(8),
                                  itemCount: answers.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                        onTap: () {
                                          if (widget.qNum < data.length - 1) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        QuestionPage(
                                                            title:
                                                                'Question ${widget.qNum + 2}',
                                                            qNum: (widget.qNum +
                                                                1))));
                                          }
                                          if (index == correct) {
                                            print(docRef.update({
                                              "numCorrect":
                                                  FieldValue.increment(1)
                                            }));
                                          }
                                          print(docRef.update({
                                            "numAttempts":
                                                FieldValue.increment(1)
                                          }));
                                          print('Hello');
                                        },

                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: selectListColor(index),
                                              //color: Colors.green[colorCodes[(index)%2]],
                                              //color: Colors.green[100],
                                              border: Border.all(
                                                  color: selectListColor(index)
                                                  //color: Colors.blue[colorCodes[(index) % 2]],
                                                  ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          height: 50,
                                          child: Center(
                                              child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              '${answers[index]}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            ),
                                          )),
                                        ));
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider(),
                                ))
                          ]));
                        }
                      });
                } else {
                  return StreamBuilder<QuerySnapshot>(
                      stream: db
                          .collection('Quizs')
                          .doc(reference)
                          .collection('questions')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Loading....');
                        } else {
                          var data = snapshot.data.docs;
                          var length = data.length;
                          List<String> answers =
                              List.from(data[widget.qNum]['answers']);
                          var correct = data[widget.qNum]['correct'];
                          var newReference = data[widget.qNum].id;

                          DocumentReference docRef = FirebaseFirestore.instance
                              .collection("Quizs")
                              .doc(reference)
                              .collection('questions')
                              .doc(newReference);
                          return Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8.0),
                              child: Column(children: [
                                Container(
                                  //height: 150.0,
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(0.0),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: 50.0,
                                      minWidth: double.infinity,
                                    ),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.blueGrey[300], width: 2.0),
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 5.0,
                                            bottom: 5.0,
                                            left: 8.0,
                                            right: 8.0),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              width: double.infinity,
                                              child: Card(
                                                color: Colors.blueGrey[300],
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 5.0,
                                                      bottom: 5.0,
                                                      left: 8.0,
                                                      right: 8.0),
                                                  child: Text(
                                                    "WAITING ROOM -\n Quiz ID: ${qID}",
                                                    style: TextStyle(
                                                      fontSize: 23.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Please wait for the instructor to start the quiz.",
                                              style:
                                                  new TextStyle(fontSize: 15.0),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  //height: 150.0,
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(0.0),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: 50.0,
                                      minWidth: double.infinity,
                                    ),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.blueGrey[300], width: 2.0),
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                        child: Column(
                                          children: <Widget>[
                                            Padding(padding: EdgeInsets.only(top: 8.0, bottom: 0.0, left: 8.0, right: 8.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text("Quiz ID: ${qID}",
                                                  style: TextStyle(fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.blueGrey[300],
                                              thickness: 2,
                                            ),
                                            Padding(padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 8.0, right: 8.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text("Title: $title",
                                                  style: TextStyle(fontSize: 15.0),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.blueGrey[300],
                                              thickness: 2,
                                            ),
                                            Padding(padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 8.0, right: 8.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text("Number of questions $length",
                                                  style: TextStyle(fontSize: 15.0),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.blueGrey[300],
                                              thickness: 2,
                                            ),
                                            Padding(padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 8.0, right: 8.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text("Time limit: $tLimit",
                                                  style: TextStyle(fontSize: 15.0),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.blueGrey[300],
                                              thickness: 2,
                                            ),
                                            Padding(padding: EdgeInsets.only(top: 3.0, bottom: 12.0, left: 8.0, right: 8.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text("Description: null",
                                                  style: TextStyle(fontSize: 15.0),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ),
                                  ),
                                ),
                              ]));
                        }
                      });
                }
              } else
                return Text("Sorry");
            },
          )
        ],
      )),
    );
  }

  Color selectListColor(int pos) {
    Color c;
    if (pos % 2 == 0) {
      c = Colors.blueGrey[900];
    } else {
      c = Colors.blueGrey[600];
    }
    return c;
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border(
        left: BorderSide(color: Colors.blue[100], width: 3.0),
        top: BorderSide(color: Colors.blue[300], width: 3.0),
        right: BorderSide(color: Colors.blue[500], width: 3.0),
        bottom: BorderSide(color: Colors.blue[800], width: 3.0),
      ),
      //borderRadius: BorderRadius.all(
      //    Radius.circular(10.0) //         <--- border radius here
      //),
    );
  }
}
