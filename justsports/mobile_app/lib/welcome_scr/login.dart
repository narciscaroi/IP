import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_app/account_settings/account_storage.dart';
import 'package:mobile_app/main_menu.dart';
import 'package:mobile_app/welcome_scr/create_account.dart';
import 'package:crypto/crypto.dart';
import "package:http/http.dart" as http;
import 'package:mobile_app/constants.dart' as Constants;

class Login extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<Login> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
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
                    "Login",
                    style: TextStyle(
                        fontFamily: 'DancingScript',
                        fontSize: size.height * 0.07,
                        color: Colors.teal
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: size.height * 0.05),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/login.png',
                    width: size.width * 0.8,
                    height: size.height * 0.25,
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: size.height * 0.03, left: size.width * 0.2),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Username*",
                    style: TextStyle(
                      fontFamily: 'DancingScript',
                      fontSize: size.height * 0.03,
                      color: Colors.teal,
                    ),
                  ),
                ),

                Container(
                  height: size.height * 0.05,
                  width: size.width * 0.6,
                  margin: EdgeInsets.only(top: size.height * 0.005),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter your username",
                    ),
                    controller: usernameController,
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: size.height * 0.03, left: size.width * 0.2),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password*",
                    style: TextStyle(
                      fontFamily: 'DancingScript',
                      fontSize: size.height * 0.03,
                      color: Colors.teal,
                    ),
                  ),
                ),

                Container(
                  height: size.height * 0.05,
                  width: size.width * 0.6,
                  margin: EdgeInsets.only(top: size.height * 0.005),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter your Password"
                    ),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: passwordController,
                  ),
                ),

                Container(
                  height: size.height * 0.05,
                  width: size.width * 0.4,
                  margin: EdgeInsets.only(top: size.height * 0.07),
                  child: ElevatedButton(
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontFamily: 'DancingScript',
                          fontSize: size.height * 0.035,
                          color: Colors.white),
                    ),
                    onPressed: () {
                      String encryptedPass = encryptPassword();
                      serverResponse(encryptedPass, size);
                    },
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: size.height * 0.05,
                        margin: EdgeInsets.only(top: size.height * 0.01, bottom: size.height * 0.01, left: size.width * 0.2),
                        alignment: Alignment.center,
                        child: Text(
                          "Don't have an account?",
                          style: TextStyle(
                              fontFamily: 'DancingScript',
                              fontSize: size.height * 0.03,
                              color: Colors.teal),
                        ),
                      ),
                      Container(
                        height: size.height * 0.06,
                        margin: EdgeInsets.only(
                            top: size.height * 0.01,
                            bottom: size.height * 0.01
                        ),
                        alignment: Alignment.center,
                        child: TextButton(
                          child: Text(
                            "Sign up!",
                            style: TextStyle(
                                fontFamily: 'DancingScript',
                                fontSize: size.height * 0.03,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateAccount(),
                                )
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
  Future<void> serverResponse(String encrypedPass, Size size) async {
    Map data = {
      'username': usernameController.text.toString(),
      'password': encrypedPass,
    };
    String url = Constants.ip + '/client_login?';

    data.forEach((key, value) {
      url += key;
      url += "=";
      url += value;
      if(key != "password")
        url += "&";
    });
    http.Response response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
    );
    String text;

    if (response.body.toString().startsWith("success ")) {
      String token = response.body.toString().substring(8);

      final AccountStorage secureStorage = AccountStorage();
      secureStorage.writeSecureData("username", usernameController.text.toString());
      secureStorage.writeSecureData("token", token);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainMenu(),
          )
      );
    }
    else if (response.body.toString() == "username not found") {
      text = "The username \"" + usernameController.text.toString() + "\" was not found";
      showAlert("ERROR", text, size, "pop");
    }
    else if (response.body.toString() == "incorrect password") {
      text = "Incorrect password for this username \"" + usernameController.text.toString() +"\"";
      showAlert("ERROR", text, size, "pop");
    }
  }

  AlertDialog showAlert(String title, String result, Size size, String goTo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(result),
          actions: [
            ElevatedButton(
              child: Text(
                "OK",
                style: TextStyle(
                    fontFamily: 'DancingScript',
                    fontSize: size.height * 0.03,
                    color: Colors.white),),
              onPressed: () {
                if (goTo == "pop") {
                  Navigator.of(context).pop();
                } else if (goTo == "login") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      )
                  );
                }
              },
            ),
          ],
        );
      }, //builder
    );
  }

  String encryptPassword() {
    List<int> bytes = utf8.encode(passwordController.text.toString());
    String hash = sha256.convert(bytes).toString();
    return hash;
  }
}