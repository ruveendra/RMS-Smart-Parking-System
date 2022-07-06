import 'package:iot_smart_park/screens/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List userRecords = [];

class SelectedUser extends StatefulWidget {
  @override
  _SelectedUserState createState() => _SelectedUserState();
}

class _SelectedUserState extends State<SelectedUser> {

  Future<void> userLogOut() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [],
      ),
      body: Stack(
        children: [
          Center(
            child: ListView.builder(
              itemCount: userRecords.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Container(
                    //width: MediaQuery.of(context).size.width/100*90,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            height: 250,
                            child: Image.network(
                              userRecords[index][2],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "${userRecords[index][0].substring(0, 2)}-${userRecords[index][0].substring(2, 5)}-${userRecords[index][0].substring(5, 9)}   at   ${userRecords[index][0].substring(9, 11)}:${userRecords[index][0].substring(11, 13)}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              scrollDirection: Axis.vertical,
            ),
          ),
        ],
      ),
    );
  }
}


