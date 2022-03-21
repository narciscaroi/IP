import 'package:flutter/material.dart';
import 'package:mobile_app/account_settings/account_storage.dart';
import 'package:mobile_app/locations/locations_list.dart';
import 'package:mobile_app/nav_drawer.dart';
import 'package:mobile_app/sports/sports_list.dart';

class MainMenu extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(
          "Menu",
          style: TextStyle(
              fontSize: size.width * 0.1,
              fontFamily: 'DancingScript',
              color: Colors.white
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Column(
              children: [
                Container(
                  height: size.height * 0.1,
                  width: size.width * 0.8,
                  margin: EdgeInsets.only(top: size.height * 0.1),
                  child: ElevatedButton(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: size.width * 0.1,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: size.width * 0.05),
                          child: Text(
                            "Sports",
                            style: TextStyle(
                                fontSize: size.width * 0.10,
                                fontFamily: 'DancingScript',
                                color: Colors.white
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: size.height * 0.005, left: size.width * 0.05),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/sport_list.png',
                            width: size.width * 0.15,
                            height: size.height * 0.10,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SportsList(),
                          )
                      );
                    },
                  ),
                ),
                Container(
                  height: size.height * 0.25,
                  margin: EdgeInsets.only(top: size.height * 0.05),
                  child: Image.asset(
                    'assets/images/logo_with_text.png',
                    width: size.width * 0.7,
                    height: size.height * 0.3,
                  ),
                ),
                Container(
                  height: size.height * 0.1,
                  width: size.width * 0.8,
                  margin: EdgeInsets.only(top: size.height * 0.05),
                  child: ElevatedButton(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: size.width * 0.1,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: size.width * 0.05),
                          child: Text(
                            "Locations",
                            style: TextStyle(
                                fontSize: size.width * 0.10,
                                fontFamily: 'DancingScript',
                                color: Colors.white
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: size.height * 0.005, left: size.width * 0.05),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/fields_list.png',
                            width: size.width * 0.15,
                            height: size.height * 0.10,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationsList(),
                          )
                      );
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