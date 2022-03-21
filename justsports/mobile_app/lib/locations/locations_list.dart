import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/constants.dart' as Constants;
import 'package:mobile_app/locations/sports_from_location.dart';
import 'package:mobile_app/welcome_scr/welcome_screen.dart';

class LocationsList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _StateLocationsList();
}

class _StateLocationsList extends State<LocationsList> {
  List<String> locationsId = [];
  List<String> businessId = [];
  List<String> addresses = [];
  List<String> businessName = [];

  @override
  void initState() {
    super.initState();
  }

  Future<List<String>> _fetchDataAllLocations() async {
    String url = Constants.ip + '/get_all_locations';
    http.Response response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    String lst = response.body.toString().replaceAll("{", "");
    lst = lst.replaceAll("}", "");
    lst = lst.replaceAll("[", "");
    lst = lst.replaceAll("]", "");
    List<String> lista = lst.trim().split(",");
    for(String s in lista) {
      if(s.contains("\"location_id\"")) {
        locationsId.add(s.split(": ")[1]);
      } else if (s.contains("\"business_id\"")) {
        businessId.add(s.split(": ")[1].replaceAll("\"", ""));
      } else if (s.contains("\"address\"")) {
        addresses.add(s.split(": ")[1].replaceAll("\"", ""));;
      } else if(s.contains("\"business_name\"")) {
        businessName.add(s.split(": ")[1].replaceAll("\"", ""));
      }
    }
    return locationsId;
  }

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
                        Text(
                          'All Locations',
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
                        future: _fetchDataAllLocations(),
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
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => GetLocationSports(
                                                          locationId: locationsId[index],
                                                          businessId: businessId[index],
                                                          businessName: businessName[index],
                                                          address: addresses[index],
                                                        ),
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