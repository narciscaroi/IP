import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/constants.dart' as Constants;
import 'package:mobile_app/main_menu.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ReservationPage extends StatefulWidget {
  final String locationId;
  final String businessId;
  final String businessName;
  final String address;
  final String sport;
  final String clientUsername;

  ReservationPage({Key key, @required this.locationId,
    @required this.businessId,
    @required this.businessName,
    @required this.address,
    @required this.sport,
    @required this.clientUsername}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _StateReservationPage(locationId,
          businessId,
          businessName,
          address,
          sport,
          clientUsername);
}

class _StateReservationPage extends State<ReservationPage> {
  String locationId;
  String businessId;
  String businessName;
  String address;
  String sport;
  String clientUsername;
  _StateReservationPage(this.locationId,
      this.businessId,
      this.businessName,
      this.address,
      this.sport,
      this.clientUsername);

  String startDate;
  String endDate;
  DateRangePickerController _controller = DateRangePickerController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                      "Reservation page",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                )
            ),
            Container(
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        "Business name:",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      ),
                      Text(
                        businessName,
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      ),
                      Text(""),
                      SizedBox(width: (size.width/2) - businessName.length/2,),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Business id:",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      ),
                      Text(
                        businessId,
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      ),
                      Text(""),
                      SizedBox(width: (size.width/2) - businessId.length/2,),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Location address:",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      ),
                      Text(
                        address,
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      ),
                      Text(""),
                      SizedBox(width: (size.width/2) - address.length/2,),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Sport:",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      ),
                      Text(
                        sport,
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      ),
                      Text(""),
                      SizedBox(width: (size.width/2) - address.length/2,),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: TextButton(
                child: Text(
                  "Calendar",
                  style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w500,
                      fontSize: 50),
                ),
                onPressed: () {
                  if(startDate != null)
                    startDate = startDate.trim().split(" ")[0];
                  showCalendar();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  serverResponse() async {
    String url = Constants.ip + '/create_reservation?';
    url += "location_id=";
    url += locationId;
    url += "&business_id=";
    url += businessId;
    url += "&client_username=";
    url += clientUsername;
    url += "&reservation_start=";
    url += startDate;
    url += "&reservation_end=";
    url += endDate;

    http.Response response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
    );
  }

  showCalendar() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(""),
            content: Card(
              child: SfDateRangePicker(
                view: DateRangePickerView.month,
                initialDisplayDate: DateTime.now(),
                selectionMode: DateRangePickerSelectionMode.single,
                controller: _controller,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  startDate = formatDate(args.value, [yyyy, '-', mm, '-', dd]);
                  endDate = startDate.toString();
                },
              ),
            ),
            actions: [
              Row(
                children: [
                  Container(
                    child: TextButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    child: TextButton(
                      child: Text(
                        "Ok",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      ),
                      onPressed: () {
                        showTimerPicker();
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
    );
  }

  showTimerPicker() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),

    );
    if (newTime != null) {
      startDate += " ";
      startDate += newTime.toString().trim().replaceAll("TimeOfDay(", "").replaceAll(")", "");
      print(startDate);
      endTimePicker();
    }
  }

  endTimePicker() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),

    );
    if (newTime != null) {
      endDate += " ";
      endDate += newTime.toString().trim().replaceAll("TimeOfDay(", "").replaceAll(")", "");
      print(endDate);
      DateTime dts = DateTime.parse(startDate);
      DateTime dte = DateTime.parse(endDate);
      print(dts);
      print(dte);
      if(dts.isBefore(dte)) {
        print("da e");
        serverResponse();
        Navigator.push(context, MaterialPageRoute(builder: (context) => MainMenu()));
      }
      else {
        Navigator.of(context).pop();
      }
    }
  }
}
