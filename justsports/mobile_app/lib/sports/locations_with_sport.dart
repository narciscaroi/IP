import 'package:flutter/material.dart';
import 'package:mobile_app/account_settings/account_storage.dart';
import 'package:mobile_app/constants.dart' as Constants;
import "package:http/http.dart" as http;
import 'package:flutter/foundation.dart';
import 'package:mobile_app/reservations/reservation_page.dart';
import 'package:mobile_app/welcome_scr/welcome_screen.dart';

class GetLocationsWithSport extends StatefulWidget {
  final String sport;
  GetLocationsWithSport({Key key, @required this.sport}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateGetLocWithSport(sport);
}

class _StateGetLocWithSport extends State<GetLocationsWithSport> {
  String sportName;
  _StateGetLocWithSport(this.sportName);
  List<String> locationsId = [];
  List<String> businessId = [];
  List<String> addresses = [];
  List<String> businessName = [];

  @override
  void initState() {
    super.initState();
  }

  Future<List<String>> _fetchDataAllLocWithSports() async {
    String url = Constants.ip + '/get_locations_with_sport?sport_name=';
    url += sportName;
    http.Response response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    String lst = response.body.toString().replaceAll("{", "");
    lst = lst.replaceAll("}", "");
    lst = lst.replaceAll("[", "");
    lst = lst.replaceAll("]", "");
    List<String> lista = lst.trim().split(",");
    print(response.body.toString());
    for(String s in lista) {
      if(s.contains("\"location_id\"")) {
        locationsId.add(s.split(": ")[1]);
      } else if (s.contains("\"business_id\"")) {
        businessId.add(s.split(": ")[1].replaceAll("\"", ""));
      } else if (s.contains("\"address\"")) {
        addresses.add(s.split(": ")[1].replaceAll("\"", ""));
      } else if(s.contains("\"business_name\"")) {
        businessName.add(s.split(": ")[1].replaceAll("\"", ""));
      }
    }
    return locationsId;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                        SizedBox(width: 0),
                        Text(
                          sportName + " locations",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 25
                          ),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    )
                ),
                Container(
                    height: size.height,
                    child: FutureBuilder(
                        future: _fetchDataAllLocWithSports(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: locationsId.length,
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
                                                child: Column(
                                                  children: [
                                                    Text("Firm name: " + businessName[index],
                                                      style: TextStyle(
                                                          color: Colors.teal,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: 'DancingScript',
                                                          fontSize: 30
                                                      ),
                                                    ),
                                                    Text("Address: " + addresses[index],
                                                      style: TextStyle(
                                                          color: Colors.teal,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: 'DancingScript',
                                                          fontSize: 30
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onPressed: () async {
                                                  AccountStorage securityStorage = new AccountStorage();
                                                  String clientUsername = await securityStorage.readSecureData("username");
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => ReservationPage(
                                                            locationId: locationsId[index],
                                                            businessId: businessId[index],
                                                            businessName: businessName[index],
                                                            address: addresses[index],
                                                            sport: sportName,
                                                            clientUsername: clientUsername),
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

}