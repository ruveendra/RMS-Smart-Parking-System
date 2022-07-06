import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_smart_park/main.dart';
import 'package:iot_smart_park/screens/user_signup.dart';
import 'package:iot_smart_park/user_data.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:iot_smart_park/auth_service.dart';
import 'package:iot_smart_park/screens/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<bool> onAuthRunning() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Please Wait'),
        actions: <Widget>[
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you really want to exit the app?'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }

  Future<void> loginFunction(String userID) async {
    Navigator.pop(context, true);
    if (userID == "j5jpI7e1nxcUU7lOeNrgqtdK3eu2") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(role: "admin",)));
    }  else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(role: "user",)));
    }

  }

  final formKey = new GlobalKey<FormState>();

  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    OutlineInputBorder commonBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50.0),
      borderSide: BorderSide(
        color: Theme.of(context).accentColor,
      ),
    );

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: 200,
                        child: Image.asset("assets/images/image2.png"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Welcome To RRS",
                          style: Theme.of(context).textTheme.headline1.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 35.0
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10,),
                        child: TextFormField(
                          controller: _email,
                          autofocus: false,
                          decoration: new InputDecoration(
                            border: commonBorder,
                            focusedBorder: commonBorder,
                            enabledBorder: commonBorder,
                            labelText: 'Email Address',
                            labelStyle: Theme.of(context).textTheme.subtitle1,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: PasswordField(
                          controller: _password,
                          color: Colors.grey,
                          hasFloatingPlaceholder: true,
                          //pattern: r'.*[@$#.*].*',
                          border: commonBorder,
                          focusedBorder: commonBorder,
                          errorMessage: 'must contain special character either . * @ # \$',
                          hintStyle: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Container(
                          width: double.infinity,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 13),
                              backgroundColor: Theme.of(context).accentColor,
                              shape: StadiumBorder(),
                            ),
                            child: Text(
                              'Login',
                              style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () async {
                              onAuthRunning();
                              if (formKey.currentState.validate()) {
                                try {
                                  final form = formKey.currentState;
                                  form.save();
                                  final auth = AuthService();
                                  User user = await auth.signInWithEmailAndPassword(_email.text, _password.text);
                                  print('logged ======= ${user.uid}');
                                  if (user.uid.length > 0 && user.uid != null) {
                                    setState(() {
                                      appUser = user;
                                    });
                                    loginFunction(user.uid).then((value) => loggedUserDetails(user.uid));
                                  }
                                } catch (e) {
                                  setState(() {
                                    _email.clear();
                                    _password.clear();
                                  });
                                  print('Error: $e');
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        'Login Failed',
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Text(
                                        'Invalid E-mail or Password, please try again',
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('close'),
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have an account?",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                                fontSize: 14.0,
                            ),
                          ),
                          TextButton(
                            child: Text(
                                'Register Now',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headline4.copyWith(color: Theme.of(context).accentColor),
                            ),
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp())),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
