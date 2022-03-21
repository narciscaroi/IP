import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:mobile_app/welcome_scr/login.dart';
import "package:http/http.dart" as http;


class CreateAccount extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<CreateAccount> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();

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
                  margin: EdgeInsets.only(top: size.height * 0.05),
                  alignment: Alignment.center,
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                        fontFamily: 'DancingScript',
                        fontSize: size.height * 0.07,
                        color: Colors.teal
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: size.height * 0.005),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/create_account.png',
                    width: size.width * 0.9,
                    height: size.height * 0.15,
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: size.height * 0.05, left: size.width * 0.2),
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
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter your username"
                    ),
                    controller: usernameController,
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: size.height * 0.05, left: size.width * 0.2),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "First Name*",
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
                        hintText: "Enter your first name"
                    ),
                    controller: firstNameController,
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: size.height * 0.05, left: size.width * 0.2),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Last Name*",
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
                        hintText: "Enter your last name"
                    ),
                    controller: lastNameController,
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: size.height * 0.05, left: size.width * 0.2),
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
                        hintText: "Enter your password"
                    ),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: passwordController,
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: size.height * 0.05, left: size.width * 0.2),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email*",
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
                        hintText: "eg: asd@gmail.com",
                    ),
                    controller: emailController,
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: size.height * 0.05, left: size.width * 0.2),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Phone Number*",
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
                        hintText: "07########"
                    ),
                    controller: phoneNumberController,
                  ),
                ),

                Container(
                  height: size.height * 0.05,
                  width: size.width * 0.4,
                  margin: EdgeInsets.only(top: size.height * 0.05),
                  child: ElevatedButton(
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                          fontFamily: 'DancingScript',
                          fontSize: size.height * 0.03,
                          color: Colors.white),),
                    onPressed: () {
                      String result = checkInformations();
                      if (result != "ok") {
                        showAlert("ERROR", result, size, "pop");
                      }
                      else if (result == "ok") {
                        String encrypedPass = encryptPassword();
                        serverResponse(encrypedPass, size).toString();
                      }
                    },
                  ),
                ),

                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: size.height * 0.05,
                        margin: EdgeInsets.only(
                            top: size.height * 0.01,
                            bottom: size.height * 0.1,
                            left: size.width * 0.15
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Already have an account?",
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
                            bottom: size.height * 0.1
                        ),
                        alignment: Alignment.center,
                        child: TextButton(
                          child: Text(
                            "Sign in!",
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
                                  builder: (context) => Login(),
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
      'first_name': firstNameController.text.toString(),
      'last_name': lastNameController.text.toString(),
      'password': encrypedPass,
      'phone_number': phoneNumberController.text.toString(),
      'email': emailController.text.toString()
    };
    String url = 'http://192.168.0.107:5000/client_create?';
    data.forEach((key, value) {
      url += key;
      url += "=";
      url += value;
      if(key != "email")
        url += "&";
    });
    http.Response response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
    );
    String text;
    if (response.body.toString() == "success") {
      text = "You have successfully created your account";
      showAlert("SUCCESS", text, size, "login");
    }
    else if (response.body.toString() == "username already exists") {
      text = "An account with username \"" + usernameController.text.toString() + "\" already exists";
      showAlert("ERROR", text, size, "pop");
    }
  }
  String checkInformations() {
    RegExp exp;
    if (usernameController.text.toString().length < 8) {
      return "Username does not contain at least 8 characters";
    }

    if (usernameController.text.toString().contains(" ")) {
      return "Username must not contain spaces";
    }

    if (firstNameController.text.toString().length < 3) {
      return "First Name does not contain at least 3 characters";
    }

    if (lastNameController.text.toString().length < 3) {
      return "Last Name does not contain at least 3 characters";
    }

    if (passwordController.text.toString().length < 8) {
      return "Password does not contain at least 8 character";
    }

    if(!passwordController.text.toString().contains(new RegExp(r"[A-Z]"))) {
      return "Password must contain at least one uppercase letter";
    }
    if(!passwordController.text.toString().contains(new RegExp(r"[a-z]"))) {
      return "Password must contain at least one lowercase letter";
    }
    if(!passwordController.text.toString().contains(new RegExp(r"[0-9]"))) {
      return "Password must contain at least one number";
    }
    if(!passwordController.text.toString().contains(new RegExp(r"[!@#$%^&*.]"))) {
      return "Password must contain at least one of the following symbols: !@#\$%^&*.";
    }

    exp = new RegExp(r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$", caseSensitive: false);
    if (!exp.hasMatch(emailController.text.toString())) {
      return "Email pattern does not follow the email format";
    }

    if (!phoneNumberController.text.toString().startsWith(new RegExp(r'07'))) {
      return "Phone number must start with 07";
    }
    if (phoneNumberController.text.toString().length < 10) {
      return "Phone number must contain 10 numbers";
    }
    exp = new RegExp(r"^[0-9]*$");
    if (!exp.hasMatch(phoneNumberController.text.toString())) {
      return "Phone number must contain only numbers";
    }
    return "ok";
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