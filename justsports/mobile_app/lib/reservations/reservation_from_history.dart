import 'package:flutter/material.dart';
import 'package:mobile_app/account_settings/account_storage.dart';
import 'package:mobile_app/constants.dart' as Constants;
import 'package:http/http.dart' as http;

class ReservationFromHistory extends StatefulWidget {
  final String reservationId;
  final String locationId;
  final String businessId;
  final String reservationStart;
  final String reservationEnd;
  final String businessName;
  final String approvedState;
  final String address;
  final String sport;
  final int index;
  final String sentFeedback;
  final String receivedFeedback;

  ReservationFromHistory({Key key,
    @required this.reservationId,
    @required this.locationId,
    @required this.businessId,
    @required this.reservationStart,
    @required this.reservationEnd,
    @required this.businessName,
    @required this.approvedState,
    @required this.address,
    @required this.sport,
    @required this.index,
    @required this.sentFeedback,
    @required this.receivedFeedback}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _StateReservationFromHistory(
          reservationId,
          locationId,
          businessId,
          reservationStart,
          reservationEnd,
          businessName,
          approvedState,
          address,
          sport,
          index,
          sentFeedback,
          receivedFeedback);
}

class _StateReservationFromHistory extends State<ReservationFromHistory> {
  String reservationId;
  String locationId;
  String businessId;
  String reservationStart;
  String reservationEnd;
  String businessName;
  String approvedState;
  String address;
  String sport;
  int index;
  String sentFeedback;
  String receivedFeedback;

  _StateReservationFromHistory(
      this.reservationId,
      this.locationId,
      this.businessId,
      this.reservationStart,
      this.reservationEnd,
      this.businessName,
      this.approvedState,
      this.address,
      this.sport,
      this.index,
      this.sentFeedback,
      this.receivedFeedback
      );

  String approvedText;
  Color approvedColor;
  TextEditingController sentFeedbackController = new TextEditingController();
  TextEditingController receivedFeedbackController = new TextEditingController();
  bool cancelVisibility;
  @override
  Widget build(BuildContext context) {
    if(int.parse(approvedState) == -1) {
      approvedText = "Denied";
      approvedColor = Colors.red;
      cancelVisibility = false;
    } else if (int.parse(approvedState) == 0) {
      approvedText = "Pending";
      approvedColor = Colors.yellow;
    } else if (int.parse(approvedState) == 1) {
      approvedText = "Accepted";
      approvedColor = Colors.green;
    } else if (int.parse(approvedState) == -2) {
      approvedText = "Canceled";
      approvedColor = Colors.redAccent;
      cancelVisibility = false;
    }
    if (cancelVisibility == null) {
      DateTime dte = DateTime.parse(reservationEnd);
      DateTime dtn = DateTime.now();
      if(dte.isAfter(dtn)) {
        cancelVisibility = true;
      } else {
        cancelVisibility = false;
      }
    }
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
                      "Reservation number " + index.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 25),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                )
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    "Business name:",
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                  Text(
                    businessName,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    "Business id:",
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                  Text(
                    businessId,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10,),
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    "Reservation start:",
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                  Text(
                    reservationStart,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    "Reservation end:",
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                  Text(
                    reservationEnd,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    "Address:",
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                  Text(
                    address,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    "Status",
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                  Text(
                    approvedText,
                    style: TextStyle(
                        color: approvedColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.only(left: size.width/2 - 90 ),
              child: Row(
                children: [
                  Text(
                    "Your Feedback",
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                  IconButton(
                      iconSize: 25,
                      icon: Icon(Icons.feedback),
                      onPressed: () {
                        showClientFeedback();
                      }
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(width: size.width/2 - 100,),
                Text(
                  "Business Feedback",
                  style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
                IconButton(
                    iconSize: 25,
                    icon: Icon(Icons.feedback),
                    onPressed: () {
                      print(receivedFeedback);
                      showBusinessFeedback();
                    }
                )
              ],
            ),
            Visibility(
              visible: cancelVisibility,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Container(
                margin: EdgeInsets.only(top: 50, left: size.width/6, right: size.width/6),
                child: Card(
                  color: Colors.red,
                  child: TextButton(
                    child: Text(
                      "Cancel reservation",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                    onPressed: () {
                      showCancelReservation();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showCancelReservation() {
    Size size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: size.width * 2/3,
              height: 100,
              child: Column(
                children: [
                  Container(
                    child: Text(
                      "Are you sure you want to cancel?",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(width: size.width/6,),
                      TextButton(
                        child: Text(
                          "Back",
                          style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text(
                          "Yes",
                          style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                        onPressed: () async {
                          String response = await serverCancelResponse();
                          if(response == "ok") {
                            int count = 0;
                            Navigator.of(context).popUntil((_) => count++ >= 4);
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Future<String> serverCancelResponse() async {
    String url = Constants.ip + "/reservation_cancel?";
    url += "business_id=";
    url += businessId;
    url += "&location_id=";
    url += locationId;
    url += "&reservation_id=";
    url += reservationId;
    url += "&sport_name=";
    url += sport;
    http.Response response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
    );
    print(response.body.toString());
    return response.body.toString();
  }
  Future<String> serverSentFeedbackResponse() async {
    AccountStorage secureStorage = AccountStorage();
    String JWT = await secureStorage.readSecureData("token");
    String url = Constants.ip + "/post_client_feedback_for_reservation?";
    url += "JWT=";
    url += JWT;
    url += "&business_id=";
    url += businessId;
    url += "&location_id=";
    url += locationId;
    url += "&reservation_id=";
    url += reservationId;
    url += "&message=";
    url += sentFeedbackController.text.toString();
    url += "&stars=5";
    http.Response response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
    );
    print(response.body.toString());
    return response.body.toString();
  }

  showClientFeedback() {
    Size size = MediaQuery.of(context).size;
    DateTime dte = DateTime.parse(reservationEnd);
    DateTime dtn = DateTime.now();
    if(sentFeedback == "no feedback yet" && (dte.isBefore(dtn)) && approvedText == "Accepted") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "No feedback yet. Please send one!",
                style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              content: Container(
                width: size.width * 2/3,
                height: 120,
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      reverse: true,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        controller: sentFeedbackController,
                        decoration: InputDecoration.collapsed(
                            hintText: "Please Write your feedback",
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          child: Text(
                            "Back",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: (size.width * 2/3)/20,),
                        TextButton(
                          child: Text(
                            "Clear Text",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                          onPressed: () {
                            sentFeedbackController.clear();
                          },
                        ),
                        SizedBox(width: (size.width * 2/3)/20,),
                        TextButton(
                          child: Text(
                            "Send",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                          onPressed: () async {
                            String response = await serverSentFeedbackResponse();
                            if(response == "ok") {
                              int count = 0;
                              Navigator.of(context).popUntil((_) => count++ >= 4);
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
      );
    } else if(sentFeedback == "no feedback yet" && approvedText == "Denied") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                width: size.width * 2/3,
                height: 120,
                child: Column(
                  children: [
                    Text(
                      "Reservation was denied",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                    SizedBox(height: 20,),
                    TextButton(
                      child: Text(
                        "Ok",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          }
      );
    } else if (sentFeedback == "no feedback yet" && approvedText == "Canceled") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                width: size.width * 2/3,
                height: 120,
                child: Column(
                  children: [
                    Text(
                      "Reservation was canceled by you",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                    SizedBox(height: 20,),
                    TextButton(
                      child: Text(
                        "Ok",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          }
      );
    } else if (sentFeedback == "no feedback yet" && (dte.isAfter(dtn)) && approvedText != "Denied" && approvedText != "Canceled"){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                width: size.width * 2/3,
                height: 120,
                child: Column(
                  children: [
                    Text(
                      "Reservation did not finish",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                    SizedBox(height: 20,),
                    TextButton(
                      child: Text(
                        "Ok",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          }
      );
    } else if(sentFeedback != "no feedback yet") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                height: 150,
                child: Column(
                  children: [
                    Text(
                      "Your feedback",
                      style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.w500,
                          fontSize: 25),
                    ),
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        child: Text(
                          sentFeedback,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    TextButton(
                      child: Text(
                        "Ok",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          }
      );
    }
  }
  showBusinessFeedback() {
    Size size = MediaQuery.of(context).size;
    if(receivedFeedback == "no feedback yet") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                width: size.width * 2/3,
                height: 120,
                child: Column(
                  children: [
                    Text(
                      "You had not receive feedback yet",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                    SizedBox(height: 20,),
                    TextButton(
                      child: Text(
                        "Ok",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          }
      );
    } else if (receivedFeedback != "no feedback yet") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                height: 150,
                child: Column(
                  children: [
                    Text(
                      "Business feedback",
                      style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.w500,
                          fontSize: 25),
                    ),
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        child: Text(
                          receivedFeedback,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    TextButton(
                      child: Text(
                        "Ok",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          }
      );
    }
  }

}