import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iot_smart_park/screens/login_page.dart';
import 'package:iot_smart_park/main.dart';
import 'package:iot_smart_park/auth_service.dart';
import 'package:iot_smart_park/user_data.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {

  final String role;

  const HomePage({Key key, this.role}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> userLogOut() async {
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }

  final TextEditingController _plate = new TextEditingController();

  final formKey = new GlobalKey<FormState>();

  OutlineInputBorder commonBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(50.0),
    borderSide: BorderSide(
      color: Colors.black,
    ),
  );

  void reserve(String sensor) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          ),
          child: Center(
            child: Form(
              key: formKey,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(50, 40, 50, 30),
                    child: Image.asset("assets/images/image1.png"),
                  ),
                  Text(
                    'You Can Reserve This Parking Slot,\nPlease Enter Your Vehicle Plate Number',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    child: TextFormField(
                      controller: _plate,
                      autofocus: false,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'empty field..!';
                        }
                        return null;
                      },
                      decoration: new InputDecoration(
                        border: commonBorder,
                        focusedBorder: commonBorder,
                        enabledBorder: commonBorder,
                        labelText: 'Number Plate',
                        labelStyle: Theme.of(context).textTheme.subtitle1,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 13),
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: Theme.of(context).accentColor,
                                  width: 2.0
                                )
                              ),
                            ),
                            child: Text(
                              'CLOSE',
                              style: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).accentColor),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 13),
                              backgroundColor: Theme.of(context).accentColor,
                              shape: StadiumBorder(),
                            ),
                            child: Text(
                              'RESERVE',
                              style: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () async {
                              formKey.currentState.save();
                              if (formKey.currentState.validate()) {
                                await FirebaseDatabase.instance.reference().child(sensor).child("value").set("r");
                                await FirebaseDatabase.instance.reference().child(sensor).child("vehicle").set(_plate.text);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'RRS',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
              currentAccountPicture: CircleAvatar(
                radius: 90,
                child: CircleAvatar(
                  radius: 85,
                  backgroundColor: Color.fromARGB(255, 100, 100, 100),
                  child: Padding(
                    padding: EdgeInsets.all(20),

                  ),
                ),
              ),
              accountName: Text("${appUser.displayName}", style: TextStyle(color: Theme.of(context).primaryColor),),
              accountEmail: Text("${appUser.email}", style: TextStyle(color: Theme.of(context).primaryColor),),
            ),
            ListTile(
              onTap: () async {
                try {
                  final auth = AuthService();
                  await auth.signOut();
                  userLogOut();
                } catch (e) {
                  print('Error: $e');
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Logout Failed',
                        textAlign: TextAlign.center,
                      ),
                      content: Text(
                        'Something went wrong..!, please try again',
                        textAlign: TextAlign.center,
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('close'),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
              title: Text(
                'Log Out',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: (deviceRatio * 10) / 4 + 10.5,
                  color: Colors.grey[800],
                ),
              ),
              trailing: Icon(
                Icons.exit_to_app,
                color: Colors.grey[800],
              ),
            ),
          ],
          ),
        ),
      body: Stack(
        children: [
          ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25, top: 20),
                child: widget.role != "admin" ? Text(
                  appUser != null ? "Hi ${appUser.displayName.toString().split(" ")[0]} !" : "Hi !",
                  style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).accentColor, fontSize: 34),
                ) : Text(
                  appUser != null ? "Admin Panel" : "",
                  style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).accentColor, fontSize: 34),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, bottom: 20),
                child: Text(
                  "Welcome to RRS.",
                  style: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).accentColor),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 25, right: 25,),
                child: Container(
                  height: 400.0,
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "|       IN       |",
                                style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.grey),
                              ),
                              Container(
                                width: 30,
                                height: 210,
                                color: Colors.grey,
                              ),
                              Text(
                                "|      OUT      |",
                                style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: double.infinity,
                          height: 380,
                          child: CustomPaint(
                            painter: DashRectPainter(),
                          ),
                        ),
                      ),

                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(

                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 2.0,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: StreamBuilder(
                                          stream: FirebaseDatabase.instance.reference().child('sensor1').onValue,
                                          builder: (context, snapshot){
                                            var data = snapshot.data.snapshot.value['value'];
                                            if(snapshot.hasData){
                                              if (data == 1) {
                                                return Transform.rotate(
                                                  angle: math.pi / 180 * -90,
                                                  child: Transform.scale(
                                                    scale: 1.5,
                                                    child: Image.asset("assets/images/car.png", fit: BoxFit.contain,),
                                                  ),
                                                );
                                              } else if (data == 0) {
                                                return MaterialButton(
                                                  onPressed: (){
                                                    reserve("sensor1");
                                                  },
                                                  child: Container(
                                                    child: Text(
                                                      "A01",
                                                      textAlign: TextAlign.center,
                                                      style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 50, fontWeight: FontWeight.w500,color: Colors.grey,),
                                                    ),
                                                  ),
                                                );
                                              } else if (data == 'r') {
                                                return Container(
                                                  child: widget.role != "admin" ? Text(
                                                    "RESERVED",
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.red,),
                                                  ) : Text(
                                                    "RESERVED by \n${snapshot.data.snapshot.value['vehicle']}",
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.red,),
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            }else{
                                              return Container();
                                            }
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: StreamBuilder(
                                            stream: FirebaseDatabase.instance.reference().child('sensor2').onValue,
                                            builder: (context, snapshot){
                                              var data = snapshot.data.snapshot.value['value'];
                                              if(snapshot.hasData){
                                                if (data == 1) {
                                                  return Transform.rotate(
                                                    angle: math.pi / 180 * 90,
                                                    child: Transform.scale(
                                                      scale: 1.5,
                                                      child: Image.asset("assets/images/car.png", fit: BoxFit.contain,),
                                                    ),
                                                  );
                                                } else if (data == 0) {
                                                  return MaterialButton(
                                                    onPressed: (){
                                                      reserve("sensor2");
                                                    },
                                                    child: Container(
                                                      child: Text(
                                                        "A03",
                                                        textAlign: TextAlign.center,
                                                        style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 50, fontWeight: FontWeight.w500,color: Colors.grey,),
                                                      ),
                                                    ),
                                                  );
                                                } else if (data == 'r') {
                                                  return Container(
                                                    child: widget.role != "admin" ? Text(
                                                      "RESERVED",
                                                      textAlign: TextAlign.center,
                                                      style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.red,),
                                                    ) : Text(
                                                      "RESERVED by \n${snapshot.data.snapshot.value['vehicle']}",
                                                      textAlign: TextAlign.center,
                                                      style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.red,),
                                                    ),
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              }else{
                                                return Container();
                                              }
                                            },
                                          ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 2.0,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: StreamBuilder(
                                          stream: FirebaseDatabase.instance.reference().child('sensor3').onValue,
                                          builder: (context, snapshot){
                                            var data = snapshot.data.snapshot.value['value'];
                                            if(snapshot.hasData){
                                              if (data == 1) {
                                                return Transform.rotate(
                                                  angle: math.pi / 180 * -90,
                                                  child: Transform.scale(
                                                    scale: 1.5,
                                                    child: Image.asset("assets/images/car.png", fit: BoxFit.contain,),
                                                  ),
                                                );
                                              } else if (data == 0) {
                                                return MaterialButton(
                                                  onPressed: (){
                                                    reserve("sensor3");
                                                  },
                                                  child: Container(
                                                    child: Text(
                                                      "A02",
                                                      textAlign: TextAlign.center,
                                                      style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 50, fontWeight: FontWeight.w500,color: Colors.grey,),
                                                    ),
                                                  ),
                                                );
                                              } else if (data == 'r') {
                                                return Container(
                                                  child: widget.role != "admin" ? Text(
                                                    "RESERVED",
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.red,),
                                                  ) : Text(
                                                    "RESERVED by \n${snapshot.data.snapshot.value['vehicle']}",
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.red,),
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            }else{
                                              return Container();
                                            }
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: StreamBuilder(
                                          stream: FirebaseDatabase.instance.reference().child('sensor4').onValue,
                                          builder: (context, snapshot){
                                            var data = snapshot.data.snapshot.value['value'];
                                            if(snapshot.hasData){
                                              if (data == 1) {
                                                return Transform.rotate(
                                                  angle: math.pi / 180 * 90,
                                                  child: Transform.scale(
                                                    scale: 1.5,
                                                    child: Image.asset("assets/images/car.png", fit: BoxFit.contain,),
                                                  ),
                                                );
                                              } else if (data == 0) {
                                                return MaterialButton(
                                                  onPressed: (){
                                                    reserve("sensor4");
                                                  },
                                                  child: Container(
                                                    child: Text(
                                                      "A04",
                                                      textAlign: TextAlign.center,
                                                      style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 50, fontWeight: FontWeight.w500,color: Colors.grey,),
                                                    ),
                                                  ),
                                                );
                                              } else if (data == 'r') {
                                                return Container(
                                                  child: widget.role != "admin" ? Text(
                                                    "RESERVED",
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.red,),
                                                  ) : Text(
                                                    "RESERVED by \n${snapshot.data.snapshot.value['vehicle']}",
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.red,),
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            }else{
                                              return Container();
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 2.0,
                                ),
                              ),
                              Expanded(
                                child: Container(

                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}

class DashRectPainter extends CustomPainter {
  double strokeWidth;
  Color color;
  double gap;

  DashRectPainter({this.strokeWidth = 3.0, this.color = Colors.grey, this.gap = 9.0});

  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double x = size.width;
    double y = size.height;

    Path _topPath = getDashedPath(
      a: math.Point(0, 0),
      b: math.Point(x, 0),
      gap: gap,
    );

    Path _rightPath = getDashedPath(
      a: math.Point(x, 0),
      b: math.Point(x, y),
      gap: gap,
    );

    Path _bottomPath = getDashedPath(
      a: math.Point(0, y),
      b: math.Point(x, y),
      gap: gap,
    );

    Path _leftPath = getDashedPath(
      a: math.Point(0, 0),
      b: math.Point(0.001, y),
      gap: gap,
    );

    canvas.drawPath(_topPath, dashedPaint);
    canvas.drawPath(_rightPath, dashedPaint);
    canvas.drawPath(_bottomPath, dashedPaint);
    canvas.drawPath(_leftPath, dashedPaint);
  }

  Path getDashedPath({
    @required math.Point<double> a,
    @required math.Point<double> b,
    @required gap,
  }) {
    Size size = Size(b.x - a.x, b.y - a.y);
    Path path = Path();
    path.moveTo(a.x, a.y);
    bool shouldDraw = true;
    math.Point currentPoint = math.Point(a.x, a.y);

    num radians = math.atan(size.height / size.width);

    num dx = math.cos(radians) * gap < 0
        ? math.cos(radians) * gap * -1
        : math.cos(radians) * gap;

    num dy = math.sin(radians) * gap < 0
        ? math.sin(radians) * gap * -1
        : math.sin(radians) * gap;

    while (currentPoint.x <= b.x && currentPoint.y <= b.y) {
      shouldDraw
          ? path.lineTo(currentPoint.x, currentPoint.y)
          : path.moveTo(currentPoint.x, currentPoint.y);
      shouldDraw = !shouldDraw;
      currentPoint = math.Point(
        currentPoint.x + dx,
        currentPoint.y + dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
