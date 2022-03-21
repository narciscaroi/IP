import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/account_settings/account_storage.dart';
import 'package:mobile_app/welcome_scr/login.dart';
import 'package:crypto/crypto.dart';
import 'package:mobile_app/welcome_scr/welcome_screen.dart';
import 'package:mobile_app/constants.dart' as Constants;
import 'package:http/http.dart' as http;

class AccountMenu extends StatefulWidget {
  State<StatefulWidget> createState() => new _StateAccountMenu();
}

class _StateAccountMenu extends State<AccountMenu> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
        color: Colors.white,
          child: ListView(
            children: <Widget>[
              Container(
                height: size.height * 0.05,
                width: size.width * 0.4,
                margin: EdgeInsets.only(top: size.height * 0.07),
                child: ListTile(
                  leading: Icon(
                    Icons.delete_forever,
                  ),
                  title: Text(
                    "Delete account",
                    style: TextStyle(
                        fontSize: size.width * 0.1,
                        fontFamily: 'DancingScript',
                        color: Colors.teal
                    ),
                  ),
                  onTap: () => {
                    showAlert(
                        "Are you sure you want to delete your account? ",
                        size),
                  },
                ),
              ),
              Container(
                height: size.height * 0.05,
                width: size.width * 0.4,
                margin: EdgeInsets.only(top: size.height * 0.07),
                child: ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                  ),
                  title: Text(
                    "Sign out",
                    style: TextStyle(
                        fontSize: size.width * 0.1,
                        fontFamily: 'DancingScript',
                        color: Colors.teal
                    ),
                  ),
                  onTap: () async => {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => WelcomeScreen()
                        ),
                            (Route<dynamic> route) => false
                    ),
                  },
                ),
              ),
            ],
          )
        ),
    );
  }
  AlertDialog showAlert(String msg, Size size) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Account"),
          content: Text(msg),
          actions: <Widget>[
            Row(
              children: <Widget>[
                TextButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: size.width * 0.05,
                          fontFamily: 'DancingScript',
                          color: Colors.teal
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                ),
                TextButton(
                    child: Text(
                      "Yes",
                      style: TextStyle(
                          fontSize: size.width * 0.05,
                          fontFamily: 'DancingScript',
                          color: Colors.teal
                      ),
                    ),
                    onPressed: () async {
                      String result = await serverResponse().whenComplete(() => String);
                      if(result == "success") {
                        deleteTokenAndUss();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => WelcomeScreen()
                            ),
                                (Route<dynamic> route) => false
                        );
                      }
                    }
                ),
              ],
            ),
          ],
        );
      }, //builder
    );
  }

  Future<String> serverResponse() async {
    final AccountStorage secureStorage = AccountStorage();
    String token = await secureStorage.readSecureData("token").whenComplete(() => String);
    String url = Constants.ip + "/delete_client?JWT=";
    url += token;
    http.Response response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
    );
    if(response.body.toString() == "success") {
      deleteTokenAndUss();
    }
    return response.body.toString();
  }
  deleteTokenAndUss() async {
    final AccountStorage secureStorage = AccountStorage();
    await secureStorage.deleteSecureData("username");
    await secureStorage.deleteSecureData("token");
  }
}