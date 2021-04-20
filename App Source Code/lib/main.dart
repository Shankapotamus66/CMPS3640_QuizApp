import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './questionPage.dart';
import './instructorView.dart';
import './studentView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        brightness: Brightness.light,
        backgroundColor: Colors.blueGrey.shade100,
        primaryColor: Colors.blueGrey[900],
        accentColor: Colors.blue,
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Quiz App'),

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title,}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  // This widget is the root of your application.

  final id = 40558;
  @override

  Widget build(BuildContext context) {
    return Scaffold (
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title,
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
                const SizedBox(height: 175, width: 150),
                text1Section,
                new SizedBox(
                  width: 200, height: 40,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => StudentView()
                          )
                      );
                    },
                    child: const Text('Student', style: TextStyle(fontSize: 20)),
                  ),
                ),
               SizedBox(
                 height: 20,
               ),
               SizedBox(
                  width: 200, height: 40,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => InstructorView(title: 'Question', qNum: 0)
                          )
                      );
                    },
                    child: const Text('Instuctor', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
          )
        ),
    );
  }

  Widget text1Section = Container(
    padding: const EdgeInsets.only(bottom: 15),
    child: Text(
      'Select Area',
      style: TextStyle(fontSize: 18),
      softWrap: true,
    ),
  );

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border(
        left: BorderSide( color: Colors.blue[100], width: 3.0),
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