import 'package:flutter/material.dart';
import 'package:mobile_app/welcome_scr/create_account.dart';
import 'package:mobile_app/welcome_scr/login.dart';

class WelcomeScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.1),
                  alignment: Alignment.center,
                  child: Text(
                    "Welcome to JustSports",
                    style: TextStyle(
                        fontFamily: 'DancingScript',
                        fontSize: size.height * 0.05,
                        color: Colors.teal
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: size.height * 0.05),
                  alignment: Alignment.center,
                  child: Image.asset(
                      'assets/images/sports_welcome.png',
                      width: size.width * 0.8,
                      height: size.height * 0.25,
                  ),
                ),


                Container(
                  height: size.height * 0.05,
                  width: size.width * 0.4,
                  margin: EdgeInsets.only(top: size.height * 0.1),
                  child: ElevatedButton(
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontFamily: 'DancingScript',
                          fontSize: size.height * 0.035,
                          color: Colors.white),),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ));
                    },
                  ),
                ),

                Container(
                  height: size.height * 0.05,
                  width: size.width * 0.4,
                  margin: EdgeInsets.only(top: size.height * 0.1),
                  child: ElevatedButton(
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                          fontFamily: 'DancingScript',
                          fontSize: size.height * 0.03,
                          color: Colors.white),),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateAccount(),
                          ));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
}