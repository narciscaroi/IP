import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/account_settings/account_storage.dart';
import 'package:mobile_app/constants.dart' as Constants;
import 'package:mobile_app/reservations/reservation_page.dart';
import 'package:mobile_app/welcome_scr/welcome_screen.dart';

class GetLocationSports extends StatefulWidget {
  final String locationId;
  final String businessId;
  final String businessName;
  final String address;
  GetLocationSports({Key key, @required this.locationId,
    @required this.businessId,
    @required this.businessName,
    @required this.address}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _StateGetLocSports(locationId,
          businessId,
          businessName,
          address);
}

class _StateGetLocSports extends State<GetLocationSports> {
  String locationId;
  String businessId;
  String businessName;
  String address;
  _StateGetLocSports(this.locationId,
      this.businessId,
      this.businessName,
      this.address);
  List<String> locationSportsList;

  @override
  void initState() {
    super.initState();
  }

  Future<List<String>> _fetchDataAllLocSports() async {
    String url = Constants.ip + '/get_sports_from_location?';
    url += "business_id=";
    url += businessId;
    url += "&location_id=";
    url += locationId;
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
    locationSportsList = lstLoc;
    return lstLoc;
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
                    padding: EdgeInsets.fromLTRB(0, 20, 30, 25),
                    child: Row(
                      children: <Widget>[
                        IconButton(

                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          businessName + "'s sports",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    )
                ),
                Container(
                    height: 500,
                    child: FutureBuilder(
                        future: _fetchDataAllLocSports(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: locationSportsList.length,
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
                                                child: Text(locationSportsList[index],
                                                  style: TextStyle(
                                                      color: Colors.teal,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'DancingScript',
                                                      fontSize: 30
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  AccountStorage securityStorage = new AccountStorage();
                                                  String clientUsername = await securityStorage.readSecureData("username");
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => ReservationPage(locationId: locationId,
                                                              businessId: businessId,
                                                              businessName: businessName,
                                                              address: address,
                                                              sport: locationSportsList[index],
                                                              clientUsername: clientUsername),
                                                      ),
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
                          else
                            return Container();
                        }
                    )
                ),
              ],
            ))
    );
  }
}