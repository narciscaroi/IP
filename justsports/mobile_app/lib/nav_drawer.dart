import 'package:flutter/material.dart';
import 'package:mobile_app/account_settings/account_menu.dart';
import 'package:mobile_app/reservations/reservation_history.dart';
import 'package:mobile_app/reservations/reservation_history.dart';
import 'package:mobile_app/welcome_scr/login.dart';

class NavDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _StatenavDrawer();
}

class _StatenavDrawer extends State<NavDrawer> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: size.height * 0.35,
            margin: EdgeInsets.only(
                top: size.height * 0.01),
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal[800],
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: AssetImage(
                    "assets/images/logo_with_text.png",
                  ),
                ),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(size.width * 0.2),
                    bottomLeft: Radius.circular(size.width * 0.2)
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.teal,
                      spreadRadius: size.width*0.003),
                ],
                border: null,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.library_books,
            ),
            title: Text(
              "Reservations",
              style: TextStyle(
                  fontSize: size.width * 0.1,
                  fontFamily: 'DancingScript',
                  color: Colors.teal
              ),
            ),
            onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReservationHistory(),
                )
              ),
            },
          ),
          ListTile(
            leading: Icon(
              Icons.account_box,
            ),
            title: Text(
              "Account",
              style: TextStyle(
                  fontSize: size.width * 0.1,
                  fontFamily: 'DancingScript',
                  color: Colors.teal
              ),
            ),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountMenu(),
                  )
              ),
            },
          ),
        ],
      ),
    );
  }
}