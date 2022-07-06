import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iot_smart_park/auth_service.dart';
import 'dart:async';
import 'package:iot_smart_park/screens/home_page.dart';
import 'package:iot_smart_park/screens/login_page.dart';
import 'package:iot_smart_park/config/app_config.dart' as config;
import 'package:iot_smart_park/user_data.dart';

double deviceRatio;

String userEmail;
String userRole;
String userName;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(() {
    print('Completed');
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Colors.white,
        brightness: Brightness.light,
        accentColor: config.Colors().mainColor(1),
        focusColor: config.Colors().accentColor(1),
        hintColor: config.Colors().secondColor(1),
        textTheme: TextTheme(
          button: TextStyle(color: Colors.white),
          headline5: TextStyle(fontSize: 20.0, color: config.Colors().secondColor(1)),
          headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: config.Colors().secondColor(1)),
          headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: config.Colors().secondColor(1)),
          headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().mainColor(1)),
          headline1: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300, color: config.Colors().secondColor(1)),
          subtitle1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: config.Colors().secondColor(1)),
          headline6: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: config.Colors().mainColor(1)),
          bodyText2: TextStyle(fontSize: 12.0, color: config.Colors().secondColor(1)),
          bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: config.Colors().secondColor(1)),
          caption: TextStyle(fontSize: 12.0, color: config.Colors().secondColor(0.6)),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<String> loggedUserDetails(String userID) async{
  await FirebaseFirestore.instance.collection("user").doc(userID).get().then((DocumentSnapshot snapshot){
    userName = snapshot.data()['name'];
  });
  return 'success';
}

class _MyHomePageState extends State<MyHomePage> {

  Future<void> currentLoggedUser() async {
    final auth = AuthService();
    try{
      var currentUser = await auth.getCurrentUser();
      if(currentUser!=null){
        setState(() {
          appUser = currentUser;
        });
        if (currentUser.uid == "j5jpI7e1nxcUU7lOeNrgqtdK3eu2") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(role: "admin",)));
        }  else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(role: "user",)));
        }
      }
      if(currentUser == null){
        Timer(Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage())));
      }
    }catch (e){
      print('Error: $e');
    }
  }

  void initState(){
    super.initState();
    currentLoggedUser();
  }

  @override
  Widget build(BuildContext context) {

    deviceRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              child: Image.asset("assets/images/image2.png"),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 80, top: 50),
              child: Transform.scale(
                scale: 1.5,
                child: Text(
                  "Remote Reservation\nSystem",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: Transform.scale(
                scale: 1.5,
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
