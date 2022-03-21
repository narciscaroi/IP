"""
    Main file for server
"""
import sqlite3
import jwt
import cryptography
from flask import Flask, request, Response
import constants
import json

app = Flask(__name__)

sign_key_file = open(constants.SIGN_KEY_FILE)
sign_key = sign_key_file.read()
sign_key_file.close()

check_key_file = open(constants.CHECK_KEY_FILE)
check_key = check_key_file.read()
check_key_file.close()


# decode

# decoded = jwt.decode(encoded, check_key, algorithms=['RS256'])
# print(decoded)

@app.route('/')
def hello():
    return "Hello World!"


@app.route('/client_create', methods=['POST', 'OPTIONS'])
def client_create():
    print(request.headers)
    if request.method == 'OPTIONS':
        resp = Response()
        resp.headers['Access-Control-Allow-Origin'] = '*'
        return resp
    recv_username = request.args.get('username')
    recv_first_name = request.args.get('first_name')
    recv_last_name = request.args.get('last_name')
    recv_password = request.args.get('password')
    recv_phone_number = request.args.get('phone_number')
    recv_email = request.args.get('email')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    cur.execute(constants.CLIENT_SELECT.format(recv_username))
    rows = cur.fetchall()
    output = 'an error occurred'
    if len(rows) == 1:
        output = 'username already exists'
    elif len(rows) == 0:
        output = 'success'

    print(recv_username, recv_first_name, recv_last_name,
          recv_password, recv_phone_number, recv_email,
          output)
    if output == 'success':
        cur.execute(constants.CLIENT_INSERT.format(recv_username, recv_first_name, recv_last_name,
                                                   recv_password, recv_phone_number, recv_email))
        con.commit()

    con.close()

    con.close()
    resp = Response(output)
    resp.headers['Access-Control-Allow-Origin'] = '*'
    resp.headers['Access-Control-Allow-Credentials'] = 'true'
    resp.headers['Content-type'] = 'application/json'
    resp.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, X-Requested-With'
    return resp


@app.route('/business_create', methods=['POST', 'OPTIONS'])
def business_create():
    recv_business_id = request.args.get('business_id')
    recv_business_name = request.args.get('business_name')
    recv_password = request.args.get('password')
    recv_phone_number = request.args.get('phone_number')
    recv_email = request.args.get('email')
    recv_address = request.args.get('address')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    cur.execute(constants.BUSINESS_SELECT.format(recv_business_id))
    rows = cur.fetchall()
    output = 'an error occurred'
    if len(rows) == 1:
        output = 'username already exists'
    elif len(rows) == 0:
        output = 'success'

    print(recv_business_id, recv_business_name, recv_password,
          recv_phone_number, recv_email, recv_address,
          output)

    if output == 'success':
        cur.execute(constants.BUSINESS_INSERT.format(recv_business_id, recv_business_name, recv_password,
                                                     recv_phone_number, recv_email, recv_address))
        con.commit()

    con.close()
    resp = Response(output)
    resp.headers['Access-Control-Allow-Origin'] = '*'
    resp.headers['Access-Control-Allow-Credentials'] = 'true'
    resp.headers['Content-type'] = 'application/json'
    resp.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, X-Requested-With'
    return resp


@app.route('/client_login', methods=['POST', 'OPTIONS'])
def client_login():
    recv_username = request.args.get('username')
    recv_password = request.args.get('password')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    cur.execute(constants.CLIENT_SELECT.format(recv_username))
    rows = cur.fetchall()
    output = 'an error occurred'
    if len(rows) == 1:
        if rows[0][0] == recv_password:
            output = 'success'
        else:
            output = 'incorrect password'
    elif len(rows) == 0:
        output = 'username not found'

    con.close()

    if output == 'success':
        encoded = jwt.encode({'username': recv_username, 'password': recv_password}, sign_key, algorithm='RS256')
        decoded = jwt.decode(encoded, check_key, algorithms=['RS256'])
        if type(encoded) == bytes:
            encoded = encoded.decode('utf-8')
        out_str = "success " + encoded
        print(out_str)
        return out_str

    return output


@app.route('/business_login', methods=['POST', 'OPTIONS'])
def business_login():
    recv_username = request.args.get('business_id')
    recv_password = request.args.get('password')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    cur.execute(constants.BUSINESS_SELECT.format(recv_username))
    rows = cur.fetchall()
    output = 'an error occurred'
    if len(rows) == 1:
        if rows[0][0] == recv_password:
            output = 'success'
    elif len(rows) == 0:
        output = 'username not found'

    con.close()

    resp = Response(output)

    if output == 'success':
        encoded = jwt.encode({'business_id': recv_username, 'password': recv_password, 'type': 'business'},
                             sign_key, algorithm='RS256')
        if type(encoded) == bytes:
            encoded = encoded.decode('utf-8')
        resp = Response(encoded)
        resp.set_cookie('JWT', encoded)

    resp.headers['Access-Control-Allow-Origin'] = '*'
    resp.headers['Access-Control-Allow-Credentials'] = 'true'
    resp.headers['Content-type'] = 'application/json'
    resp.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, X-Requested-With'
    return resp


@app.route('/delete_client', methods=['POST'])
def delete_client():
    client = request.args.get('JWT')
    decoded = jwt.decode(client, check_key, algorithms=['RS256'])
    print(decoded)

    username = decoded.get('username')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    print(constants.CLIENT_DELETE.format(username))
    cur.execute(constants.CLIENT_DELETE.format(username))
    con.commit()
    con.close()

    output = "success"
    return output


@app.route('/delete_business_client', methods=['POST'])
def delete_business_client():
    client = request.args.get('JWT')
    decoded = jwt.decode(client, check_key, algorithms=['RS256'])
    print(decoded)
    business_id = decoded.get('business_id')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    print(constants.BUSINESS_DELETE.format(business_id))
    cur.execute(constants.BUSINESS_DELETE.format(business_id))
    con.commit()
    con.close()

    output = "success"
    resp = Response(output)

    resp.headers['Access-Control-Allow-Origin'] = '*'
    resp.headers['Access-Control-Allow-Credentials'] = 'true'
    resp.headers['Content-type'] = 'application/json'
    resp.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, X-Requested-With'

    return resp


@app.route('/get_all_locations', methods=['GET'])
def get_all_locations():
    con = sqlite3.connect('project.db')
    cur = con.cursor()
    cur.execute(constants.CLIENT_GET_ALL_LOCATIONS)
    rows = cur.fetchall()
    lst = []
    for row in rows:
        data = {'location_id': row[constants.LLOCATION_ID],
                'business_id': row[constants.LBUSINESS_ID],
                'address': row[constants.LADDRESS],
                'business_name': row[constants.LBUSINESS_NAME]}
        lst.append(data)

    output = json.dumps(lst)

    con.close()
    return output


@app.route('/get_all_sports', methods=['GET'])
def get_all_sports():
    con = sqlite3.connect('project.db')
    cur = con.cursor()
    cur.execute(constants.CLIENT_GET_ALL_SPORTS)
    rows = cur.fetchall()
    lst = []
    for row in rows:
        data = {'sport_name': row[constants.SSPORT_NAME]}
        lst.append(data)

    output = json.dumps(lst)

    con.close()

    return output


@app.route('/get_business_locations', methods=['GET'])
def get_business_locations():
    client = request.args.get('JWT')
    decoded = jwt.decode(client, check_key, algorithms=['RS256'])
    print(decoded)
    business_id = decoded.get('business_id')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    cur.execute(constants.BUSINESS_GET_LOCATIONS.format(business_id))
    rows = cur.fetchall()

    lst = []
    for row in rows:
        data = {'location_id': row[constants.LLOCATION_ID], 'address': row[constants.LADDRESS]}
        lst.append(data)

    output = json.dumps(lst)

    con.close()

    resp = Response(output)

    resp.headers['Access-Control-Allow-Origin'] = '*'
    resp.headers['Access-Control-Allow-Credentials'] = 'true'
    resp.headers['Content-type'] = 'application/json'
    resp.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, X-Requested-With'

    return resp


@app.route('/get_sports_from_location', methods=['GET'])
def get_sports():
    business_id = request.args.get('business_id')
    location_id = request.args.get('location_id')

    con = sqlite3.connect('project.db')
    cur = con.cursor()
    print(constants.CLIENT_GET_SPORTS.format(business_id, location_id))
    cur.execute(constants.CLIENT_GET_SPORTS.format(business_id, location_id))
    rows = cur.fetchall()

    lst = []
    for row in rows:
        data = {'sport_name': row[constants.SSPORT_NAME]}
        lst.append(data)

    output = json.dumps(lst)

    con.close()

    resp = Response(output)
    return resp


@app.route('/get_locations_with_sport', methods=['GET'])
def get_locations_with_sport():
    sport_name = request.args.get('sport_name')

    con = sqlite3.connect('project.db')
    cur = con.cursor()
    print(constants.CLIENT_GET_LOCATIONS.format(sport_name))
    cur.execute(constants.CLIENT_GET_LOCATIONS.format(sport_name))
    rows = cur.fetchall()

    lst = []
    for row in rows:
        print(row)
        data = {'location_id': row[constants.LLOCATION_ID],
                'business_id': row[constants.LBUSINESS_ID],
                'address': row[constants.LADDRESS],
                'business_name': row[constants.LBUSINESS_NAME]}
        lst.append(data)

    output = json.dumps(lst)

    con.close()

    resp = Response(output)
    return resp


@app.route('/get_business_sports', methods=['GET'])
def get_business_sports():
    client = request.args.get('JWT')
    decoded = jwt.decode(client, check_key, algorithms=['RS256'])
    print(decoded)
    business_id = decoded.get('business_id')
    location_id = request.args.get('location_id')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    print(constants.BUSINESS_GET_SPORTS.format(business_id, location_id))
    cur.execute(constants.BUSINESS_GET_SPORTS.format(business_id, location_id))
    rows = cur.fetchall()

    lst = []
    for row in rows:
        data = {'sport_name': row[constants.SSPORT_NAME]}
        lst.append(data)

    con.close()

    output = json.dumps(lst)

    resp = Response(output)

    resp.headers['Access-Control-Allow-Origin'] = '*'
    resp.headers['Access-Control-Allow-Credentials'] = 'true'
    resp.headers['Content-type'] = 'application/json'
    resp.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, X-Requested-With'

    return resp


@app.route('/get_history', methods=['GET'])
def get_history():
    client = request.args.get('JWT')
    decoded = jwt.decode(client, check_key, algorithms=['RS256'])

    username = decoded.get('username')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    print(constants.CLIENT_GET_HISTORY.format(username))
    cur.execute(constants.CLIENT_GET_HISTORY.format(username))
    rows = cur.fetchall()

    lst = []
    for row in rows:
        data = {'reservation_id': row[constants.RRESERVATION_ID],
                'location_id': row[constants.RLOCATION_ID],
                'business_id': row[constants.RBUSINESS_ID],
                'reservation_start': row[constants.RRESERVATION_START],
                'reservation_end': row[constants.RRESERVATION_END],
                'approved': row[constants.RAPPROVED],
                'business_name': row[constants.RBUSINESS_NAME],
                'sport_name': row[constants.RSPORT_NAME],
                'address': row[constants.RSNDADDRESS],
                'recv_feedback': row[constants.CLIENT_RECV_FEEDBACK],
                'sent_feedback': row[constants.CLIENT_SENT_FEEDBACK]}
        lst.append(data)

    con.close()

    output = json.dumps(lst)

    resp = Response(output)

    return resp


@app.route('/get_business_history', methods=['GET'])
def get_business_history():
    client = request.args.get('JWT')
    decoded = jwt.decode(client, check_key, algorithms=['RS256'])
    business_id = decoded.get('business_id')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    print(constants.BUSINESS_GET_HISTORY.format(business_id))
    cur.execute(constants.BUSINESS_GET_HISTORY.format(business_id))
    rows = cur.fetchall()

    lst = []
    for row in rows:
        print(row)
        data = {'reservation_id': row[constants.RRESERVATION_ID],
                'location_id': row[constants.RLOCATION_ID],
                'business_id': row[constants.RBUSINESS_ID],
                'client_username': row[constants.RCLIENT_USERNAME],
                'reservation_start': row[constants.RRESERVATION_START],
                'reservation_end': row[constants.RRESERVATION_END],
                'approved': row[constants.RAPPROVED],
                'location_address': row[constants.RADDRESS],
                'sport_name': row[constants.RSPORT_NAME],
                'recv_feedback': row[constants.BUSINESS_RECV_FEEDBACK],
                'sent_feedback': row[constants.BUSINESS_SENT_FEEDBACK]}
        lst.append(data)

    con.close()

    output = json.dumps(lst)

    resp = Response(output)

    resp.headers['Access-Control-Allow-Origin'] = '*'
    resp.headers['Access-Control-Allow-Credentials'] = 'true'
    resp.headers['Content-type'] = 'application/json'
    resp.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, X-Requested-With'

    return resp


@app.route('/create_reservation', methods=['POST'])
def create_reservation():
    client = request.args.get('JWT')
    decoded = jwt.decode(client, check_key, algorithms=['RS256'])

    username = decoded.get('username')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    location_id = request.args.get('location_id')
    business_id = request.args.get('business_id')
    reservation_start = request.args.get('reservation_start')
    reservation_end = request.args.get('reservation_end')
    sport_name = request.args.get('sport_name')

    print(constants.CLIENT_CREATE_RESERVATION.format(business_id,
                                                     location_id,
                                                     sport_name,
                                                     location_id,
                                                     business_id,
                                                     username,
                                                     reservation_start,
                                                     reservation_end,
                                                     sport_name))
    cur.execute(constants.CLIENT_CREATE_RESERVATION.format(business_id,
                                                           location_id,
                                                           sport_name,
                                                           location_id,
                                                           business_id,
                                                           username,
                                                           reservation_start,
                                                           reservation_end,
                                                           sport_name))
    con.commit()
    con.close()

    output = "ok"

    resp = Response(output)
    return resp


@app.route('/get_location_reservations', methods=['GET'])
def get_location_reservations():
    client = request.args.get('JWT')
    decoded = jwt.decode(client, check_key, algorithms=['RS256'])
    business_id = decoded.get('business_id')
    location_id = request.args.get('location_id')
    sport_name = request.args.get('sport_name')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    print(constants.BUSINESS_GET_LOCATION_RESERVATIONS.format(business_id, location_id, sport_name))
    cur.execute(constants.BUSINESS_GET_LOCATION_RESERVATIONS.format(business_id, location_id, sport_name))
    rows = cur.fetchall()

    lst = []
    for row in rows:
        print(row)
        data = {'reservation_id': row[constants.RRESERVATION_ID],
                'location_id': row[constants.RLOCATION_ID],
                'business_id': row[constants.RBUSINESS_ID],
                'client_username': row[constants.RCLIENT_USERNAME],
                'reservation_start': row[constants.RRESERVATION_START],
                'reservation_end': row[constants.RRESERVATION_END],
                'approved': row[constants.RAPPROVED],
                'location_address': row[constants.RADDRESS],
                'sport_name': row[constants.RSPORT_NAME]}
        lst.append(data)

    con.close()

    output = json.dumps(lst)

    resp = Response(output)

    resp.headers['Access-Control-Allow-Origin'] = '*'
    resp.headers['Access-Control-Allow-Credentials'] = 'true'
    resp.headers['Content-type'] = 'application/json'
    resp.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, X-Requested-With'

    return resp


@app.route('/block_time_window', methods=['POST'])
def block_time_window():
    client = request.args.get('JWT')
    decoded = jwt.decode(client, check_key, algorithms=['RS256'])
    business_id = decoded.get('business_id')
    location_id = request.args.get('location_id')
    reservation_start = request.args.get('reservation_start')
    reservation_end = request.args.get('reservation_end')
    sport_name = request.args.get('sport_name')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    print(constants.BUSINESS_BLOCK_WINDOW.format(business_id, location_id, sport_name,
                                                 location_id, business_id, reservation_start,
                                                 reservation_end, sport_name))
    cur.execute(constants.BUSINESS_BLOCK_WINDOW.format(business_id, location_id, sport_name,
                                                       location_id, business_id, reservation_start,
                                                       reservation_end, sport_name))
    con.commit()
    con.close()

    resp = Response("ok")

    resp.headers['Access-Control-Allow-Origin'] = '*'
    resp.headers['Access-Control-Allow-Credentials'] = 'true'
    resp.headers['Content-type'] = 'application/json'
    resp.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, X-Requested-With'

    return resp


@app.route('/unblock_time_window', methods=['POST'])
def unblock_time_window():
    client = request.args.get('JWT')
    decoded = jwt.decode(client, check_key, algorithms=['RS256'])
    business_id = decoded.get('business_id')
    location_id = request.args.get('location_id')
    reservation_start = request.args.get('reservation_start')
    reservation_end = request.args.get('reservation_end')
    sport_name = request.args.get('sport_name')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    print(constants.BUSINESS_UNBLOCK_WINDOW.format(location_id, business_id, reservation_start,
                                                   reservation_end, sport_name))
    cur.execute(constants.BUSINESS_UNBLOCK_WINDOW.format(location_id, business_id, reservation_start,
                                                         reservation_end, sport_name))
    con.commit()
    con.close()

    resp = Response("ok")

    resp.headers['Access-Control-Allow-Origin'] = '*'
    resp.headers['Access-Control-Allow-Credentials'] = 'true'
    resp.headers['Content-type'] = 'application/json'
    resp.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, X-Requested-With'

    return resp


@app.route('/reservation_approval', methods=['POST'])
def reservation_approval():
    client = request.args.get('JWT')
    decoded = jwt.decode(client, check_key, algorithms=['RS256'])
    business_id = decoded.get('business_id')
    location_id = request.args.get('location_id')
    reservation_id = request.args.get('reservation_id')
    sport_name = request.args.get('sport_name')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    print(constants.RESERVATION_APPROVE_DENY_CANCEL.format(1, reservation_id, business_id,
                                                           location_id, sport_name))
    cur.execute(constants.RESERVATION_APPROVE_DENY_CANCEL.format(1, reservation_id, business_id,
                                                                 location_id, sport_name))
    con.commit()
    con.close()

    resp = Response("ok")

    resp.headers['Access-Control-Allow-Origin'] = '*'
    resp.headers['Access-Control-Allow-Credentials'] = 'true'
    resp.headers['Content-type'] = 'application/json'
    resp.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, X-Requested-With'

    return resp


@app.route('/reservation_denial', methods=['POST'])
def reservation_denial():
    client = request.args.get('JWT')
    decoded = jwt.decode(client, check_key, algorithms=['RS256'])
    business_id = decoded.get('business_id')
    location_id = request.args.get('location_id')
    reservation_id = request.args.get('reservation_id')
    sport_name = request.args.get('sport_name')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    print(constants.RESERVATION_APPROVE_DENY_CANCEL.format(-1, reservation_id, business_id,
                                                           location_id, sport_name))
    cur.execute(constants.RESERVATION_APPROVE_DENY_CANCEL.format(-1, reservation_id, business_id,
                                                                 location_id, sport_name))
    con.commit()
    con.close()

    resp = Response("ok")

    resp.headers['Access-Control-Allow-Origin'] = '*'
    resp.headers['Access-Control-Allow-Credentials'] = 'true'
    resp.headers['Content-type'] = 'application/json'
    resp.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, X-Requested-With'

    return resp


@app.route('/reservation_cancel', methods=['POST'])
def reservation_cancel():
    business_id = request.args.get('business_id')
    location_id = request.args.get('location_id')
    reservation_id = request.args.get('reservation_id')
    sport_name = request.args.get('sport_name')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    print(constants.RESERVATION_APPROVE_DENY_CANCEL.format(-2, reservation_id, business_id,
                                                           location_id, sport_name))
    cur.execute(constants.RESERVATION_APPROVE_DENY_CANCEL.format(-2, reservation_id, business_id,
                                                                 location_id, sport_name))
    con.commit()
    con.close()

    resp = Response("ok")
    return resp


@app.route('/get_client_client_feedback_for_reservation', methods=['GET'])
def get_client_client_feedback_for_reservation():
    client = request.args.get('JWT')
    decoded = jwt.decode(client, check_key, algorithms=['RS256'])

    client_username = decoded.get('username')
    business_id = request.args.get('business_id')
    location_id = request.args.get('location_id')
    reservation_id = request.args.get('reservation_id')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    print(constants.GET_BUSINESS_FEEDBACK.format(business_id,
                                                 client_username,
                                                 location_id,
                                                 reservation_id))
    cur.execute(constants.GET_BUSINESS_FEEDBACK.format(business_id,
                                                       client_username,
                                                       location_id,
                                                       reservation_id))

    rows = cur.fetchall()

    output = 'an error occurred'
    if len(rows) == 1:
        output = rows[0][0]
    elif len(rows) == 0:
        output = 'no feedback yet'
    con.close()
    resp = Response(output)

    return resp


@app.route('/get_client_business_feedback_for_reservation', methods=['GET'])
def get_client_business_feedback_for_reservation():
    client = request.args.get('JWT')
    decoded = jwt.decode(client, check_key, algorithms=['RS256'])

    client_username = decoded.get('username')
    business_id = request.args.get('business_id')
    location_id = request.args.get('location_id')
    reservation_id = request.args.get('reservation_id')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    print(constants.GET_CLIENT_FEEDBACK.format(business_id,
                                               client_username,
                                               location_id,
                                               reservation_id))
    cur.execute(constants.GET_CLIENT_FEEDBACK.format(business_id,
                                                     client_username,
                                                     location_id,
                                                     reservation_id))

    rows = cur.fetchall()

    output = 'an error occurred'
    if len(rows) == 1:
        output = rows[0][0]
    elif len(rows) == 0:
        output = 'no feedback yet'
    con.close()
    resp = Response(output)
    return resp


@app.route('/post_client_feedback_for_reservation', methods=['POST'])
def post_client_feedback_for_reservation():
    client = request.args.get('JWT')
    decoded = jwt.decode(client, check_key, algorithms=['RS256'])

    client_username = decoded.get('username')
    business_id = request.args.get('business_id')
    location_id = request.args.get('location_id')
    reservation_id = request.args.get('reservation_id')
    message = request.args.get('message')
    stars = request.args.get('stars')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    print(constants.SEND_BUSINESS_FEEDBACK.format(client_username,
                                                  business_id,
                                                  location_id,
                                                  reservation_id,
                                                  message,
                                                  stars))
    cur.execute(constants.SEND_BUSINESS_FEEDBACK.format(client_username,
                                                        business_id,
                                                        location_id,
                                                        reservation_id,
                                                        message,
                                                        stars))
    con.commit()
    con.close()
    resp = Response("ok")
    return resp


@app.route('/get_business_business_feedback_for_reservation', methods=['GET'])
def get_business_business_feedback_for_reservation():
    client = request.args.get('JWT')
    decoded = jwt.decode(client, check_key, algorithms=['RS256'])

    business_id = decoded.get('business_id')
    client_username = request.args.get('client_username')
    location_id = request.args.get('location_id')
    reservation_id = request.args.get('reservation_id')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    print(constants.GET_CLIENT_FEEDBACK.format(business_id,
                                               client_username,
                                               location_id,
                                               reservation_id))
    cur.execute(constants.GET_CLIENT_FEEDBACK.format(business_id,
                                                     client_username,
                                                     location_id,
                                                     reservation_id))

    rows = cur.fetchall()

    output = 'an error occurred'
    if len(rows) == 1:
        output = rows[0][0]
    elif len(rows) == 0:
        output = 'no feedback yet'
    con.close()
    resp = Response(output)

    resp.headers['Access-Control-Allow-Origin'] = '*'
    resp.headers['Access-Control-Allow-Credentials'] = 'true'
    resp.headers['Content-type'] = 'application/json'
    resp.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, X-Requested-With'

    return resp


@app.route('/get_business_client_feedback_for_reservation', methods=['GET'])
def get_business_client_feedback_for_reservation():
    client = request.args.get('JWT')
    decoded = jwt.decode(client, check_key, algorithms=['RS256'])

    business_id = decoded.get('business_id')
    client_username = request.args.get('client_username')
    location_id = request.args.get('location_id')
    reservation_id = request.args.get('reservation_id')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    print(constants.GET_BUSINESS_FEEDBACK.format(business_id,
                                                 client_username,
                                                 location_id,
                                                 reservation_id))
    cur.execute(constants.GET_BUSINESS_FEEDBACK.format(business_id,
                                                       client_username,
                                                       location_id,
                                                       reservation_id))

    rows = cur.fetchall()

    output = 'an error occurred'
    if len(rows) == 1:
        output = rows[0][0]
    elif len(rows) == 0:
        output = 'no feedback yet'
    con.close()
    resp = Response(output)

    resp.headers['Access-Control-Allow-Origin'] = '*'
    resp.headers['Access-Control-Allow-Credentials'] = 'true'
    resp.headers['Content-type'] = 'application/json'
    resp.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, X-Requested-With'

    return resp


@app.route('/post_business_feedback_for_reservation', methods=['POST'])
def post_business_feedback_for_reservation():
    client = request.args.get('JWT')
    decoded = jwt.decode(client, check_key, algorithms=['RS256'])

    business_id = decoded.get('business_id')
    client_username = request.args.get('client_username')
    location_id = request.args.get('location_id')
    reservation_id = request.args.get('reservation_id')
    message = request.args.get('message')
    stars = request.args.get('stars')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    print(constants.SEND_CLIENT_FEEDBACK.format(client_username,
                                                business_id,
                                                location_id,
                                                reservation_id,
                                                message,
                                                stars))
    cur.execute(constants.SEND_CLIENT_FEEDBACK.format(client_username,
                                                      business_id,
                                                      location_id,
                                                      reservation_id,
                                                      message,
                                                      stars))
    con.commit()
    con.close()
    resp = Response("ok")

    resp.headers['Access-Control-Allow-Origin'] = '*'
    resp.headers['Access-Control-Allow-Credentials'] = 'true'
    resp.headers['Content-type'] = 'application/json'
    resp.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, X-Requested-With'

    return resp


@app.route('/get_location_reservations_client', methods=['GET'])
def get_location_reservations_client():
    business_id = request.args.get('business_id')
    location_id = request.args.get('location_id')
    sport_name = request.args.get('sport_name')

    con = sqlite3.connect('project.db')
    cur = con.cursor()

    print(constants.BUSINESS_GET_LOCATION_RESERVATIONS.format(business_id, location_id, sport_name))
    cur.execute(constants.BUSINESS_GET_LOCATION_RESERVATIONS.format(business_id, location_id, sport_name))
    rows = cur.fetchall()

    lst = []
    for row in rows:
        print(row)
        data = {'reservation_id': row[constants.RRESERVATION_ID],
                'location_id': row[constants.RLOCATION_ID],
                'business_id': row[constants.RBUSINESS_ID],
                'client_username': row[constants.RCLIENT_USERNAME],
                'reservation_start': row[constants.RRESERVATION_START],
                'reservation_end': row[constants.RRESERVATION_END],
                'approved': row[constants.RAPPROVED],
                'location_address': row[constants.RADDRESS],
                'sport_name': row[constants.RSPORT_NAME]}
        lst.append(data)

    con.close()

    output = json.dumps(lst)

    resp = Response(output)

    return resp


if __name__ == '__main__':
    app.debug = False
    app.run(host='0.0.0.0', port=5000)
