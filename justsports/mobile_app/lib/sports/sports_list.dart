import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:mobile_app/locations/locations_list.dart';
import 'package:mobile_app/sports/locations_with_sport.dart';
import 'package:mobile_app/welcome_scr/create_account.dart';
import 'package:mobile_app/welcome_scr/welcome_screen.dart';
import 'package:mobile_app/constants.dart' as Constants;

class SportsList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _StateSportsList();
}

class _StateSportsList extends State<SportsList> {
  Future locationsFuture;
  List<String> locationList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        appBar: AppBar(
//          title: Text('Login Screen App'),
//        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    padding: EdgeInsets.fromLTRB(0,20,30,25),
                    child: Row(
                      children: <Widget>[
                        IconButton(

                          icon: Icon(Icons.arrow_back_ios),
                          onPressed:(){
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'All Sports',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    )),
                Container(
                    height: 500,
                    child: FutureBuilder(
                        future: _fetchDataAllSports(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: locationList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(

                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              child: Icon(
                                                Icons.arrow_forward,
                                                color: Colors.teal,
                                              ),
                                            ),
                                            Container(
                                              child: TextButton(
                                                child: Text(locationList[index],
                                                  style: TextStyle(
                                                      color: Colors.teal,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'DancingScript',
                                                      fontSize: 30
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => GetLocationsWithSport(sport: locationList[index]),
                                                      )
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 20,),

                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            );
                          }
                          else return Container();
                        }
                    )
                ),
              ],
            ))
    );
  }


  Future<List<String>> _fetchDataAllSports() async {
    String url = Constants.ip + '/get_all_sports';
    http.Response response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    String listLocation = response.body.toString().replaceAll("{","");
    listLocation = listLocation.replaceAll("[", "");
    listLocation = listLocation.replaceAll("\"", "");
    listLocation = listLocation.replaceAll(":", "");
    listLocation = listLocation.replaceAll("}", "");
    listLocation = listLocation.replaceAll(",", "");
    listLocation = listLocation.replaceAll("]", "");
    List<String> lstLoc = listLocation.trim().split("sport_name ");
    lstLoc.removeWhere((element) => element == "");
    for(int i = 0; i < lstLoc.length; i++) {
      lstLoc[i] = lstLoc[i].trim();
    }
    locationList = lstLoc;
    return lstLoc;
  }
}