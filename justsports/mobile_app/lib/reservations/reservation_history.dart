import 'package:flutter/material.dart';
import 'package:mobile_app/account_settings/account_storage.dart';
import 'package:mobile_app/constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'package:mobile_app/welcome_scr/welcome_screen.dart';

class ReservationHistory extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _StateReservationHistory();
}

class _StateReservationHistory extends State<ReservationHistory> {
  List<String> reservationId = [];
  List<String> locationsId = [];
  List<String> businessId = [];
  List<String> reservationStart = [];
  List<String> reservationEnd = [];
  List<String> businessName = [];

  @override
  void initState() {
    super.initState();
  }

  Future<List<String>> _fetchDataAllReservationHistory() async {
    final AccountStorage secureStorage = AccountStorage();
    String token = await secureStorage.readSecureData("token").whenComplete(() => String);
    String url = Constants.ip + '/get_history?JWT=';
    url += token;
    http.Response response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    print(response.body.toString());
    String lst = response.body.toString().replaceAll("{", "");
    lst = lst.replaceAll("}", "");
    lst = lst.replaceAll("[", "");
    lst = lst.replaceAll("]", "");
    List<String> lista = lst.trim().split(",");
    for(String s in lista) {
      if(s.contains("\"reservation_id\"")) {
        reservationId.add(s.split(": ")[1]);
      } else if (s.contains("\"location_id\"")) {
        locationsId.add(s.split(": ")[1]);
      } else if (s.contains("\"business_id\"")) {
        businessId.add(s.split(": ")[1].replaceAll("\"", ""));
      } else if (s.contains("\"reservation_start\"")) {
        reservationStart.add(s.split(": ")[1].replaceAll("\"", ""));;
      } else if (s.contains("\"reservation_end\"")) {
        reservationEnd.add(s.split(": ")[1].replaceAll("\"", ""));;
      }else if(s.contains("\"business_name\"")) {
        businessName.add(s.split(": ")[1].replaceAll("\"", ""));
      }
    }
    print(reservationId);
    print(locationsId);
    print(businessId);
    print(reservationStart);
    print(reservationEnd);
    print(businessName);
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
                          'All Reservations',
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
                        future: _fetchDataAllReservationHistory(),
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
                                                          fontSize: 25
                                                      ),
                                                    ),
                                                    Text("Reservation Started: " + reservationStart[index],
                                                      style: TextStyle(
                                                          color: Colors.teal,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: 'DancingScript',
                                                          fontSize: 20
                                                      ),
                                                    ),
                                                    Text("Reservation Ended: " + reservationEnd[index],
                                                      style: TextStyle(
                                                          color: Colors.teal,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: 'DancingScript',
                                                          fontSize: 20
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => WelcomeScreen(),
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
