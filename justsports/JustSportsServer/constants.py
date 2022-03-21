SIGN_KEY_FILE = 'id_rsa'
CHECK_KEY_FILE = 'id_rsa.pub'

CLIENT_INSERT = "INSERT INTO INDIVIDUAL_CLIENTS VALUES" \
                "('{}', '{}', '{}', '{}', {}, '{}')"

BUSINESS_INSERT = "INSERT INTO BUSINESS_CLIENTS VALUES" \
                "('{}', '{}', '{}', {}, '{}', '{}')"

CLIENT_SELECT = "SELECT PASSWORD FROM INDIVIDUAL_CLIENTS" \
                " WHERE USERNAME='{}'"

BUSINESS_SELECT = "SELECT PASSWORD FROM BUSINESS_CLIENTS" \
                  " WHERE BUSINESS_ID='{}'"

CLIENT_DELETE = "DELETE FROM INDIVIDUAL_CLIENTS WHERE USERNAME='{}'"

BUSINESS_DELETE = "DELETE FROM BUSINESS_CLIENTS WHERE BUSINESS_ID='{}'"

LLOCATION_ID = 0
LBUSINESS_ID = 1
LADDRESS = 2
LBUSINESS_NAME = 3

CLIENT_GET_ALL_LOCATIONS = "SELECT L.LOCATION_ID, L.BUSINESS_ID, L.ADDRESS, B.BUSINESS_NAME" \
                           " FROM LOCATIONS L, BUSINESS_CLIENTS B WHERE" \
                           " L.BUSINESS_ID=B.BUSINESS_ID"
CLIENT_GET_ALL_SPORTS = "SELECT DISTINCT SPORT_NAME FROM SPORTS"

BUSINESS_GET_LOCATIONS = "SELECT * FROM LOCATIONS WHERE BUSINESS_ID='{}'"

SSPORT_NAME = 0
SBUSINESS_ID = 1
SLOCATION_ID = 2
SADDRESS = 3
SBUSINESS_NAME = 4

CLIENT_GET_SPORTS = "SELECT SPORT_NAME FROM SPORTS WHERE BUSINESS_ID='{}' AND LOCATION_ID = {}"
CLIENT_GET_LOCATIONS = "SELECT L.LOCATION_ID, L.BUSINESS_ID, L.ADDRESS, B.BUSINESS_NAME" \
                       " FROM LOCATIONS L, SPORTS S, BUSINESS_CLIENTS B" \
                       " WHERE" \
                       " B.BUSINESS_ID = L.BUSINESS_ID" \
                       " AND" \
                       " L.LOCATION_ID = S.LOCATION_ID" \
                       " AND" \
                       " L.BUSINESS_ID = S.BUSINESS_ID" \
                       " AND" \
                       " S.SPORT_NAME = '{}'" \

BUSINESS_GET_SPORTS = "SELECT * FROM SPORTS WHERE BUSINESS_ID='{}' AND LOCATION_ID={}"

RRESERVATION_ID = 0
RLOCATION_ID = 1
RBUSINESS_ID = 2
RCLIENT_USERNAME = 3
RRESERVATION_START = 4
RRESERVATION_END = 5
RAPPROVED = 6
RBUSINESS_NAME = 7
RADDRESS = 7
RSPORT_NAME = 8
RSNDADDRESS = 9
CLIENT_RECV_FEEDBACK = 10
CLIENT_SENT_FEEDBACK = 11
CLIENT_GET_HISTORY = "SELECT R.RESERVATION_ID, R.LOCATION_ID," \
                     " R.BUSINESS_ID, R.CLIENT_USERNAME," \
                     " R.RESERVATION_START," \
                     " R.RESERVATION_END," \
                     " R.APPROVED," \
                     " B.BUSINESS_NAME," \
                     " R.SPORT_NAME," \
                     " L.ADDRESS," \
                     " IFNULL(G.MESSAGE, 'no feedback yet') RECV_MESSAGE," \
                     " IFNULL(F.MESSAGE, 'no feedback yet') SENT_MESSAGE" \
                     " FROM RESERVATIONS R, BUSINESS_CLIENTS B, LOCATIONS L" \
                     " LEFT OUTER JOIN BUSINESS_FEEDBACKS F" \
                     " ON F.RESERVATION_ID=R.RESERVATION_ID" \
                     " AND F.BUSINESS_ID=R.BUSINESS_ID" \
                     " AND F.LOCATION_ID=R.LOCATION_ID" \
                     " LEFT OUTER JOIN CLIENT_FEEDBACKS G" \
                     " ON G.RESERVATION_ID=R.RESERVATION_ID" \
                     " AND G.BUSINESS_ID=R.BUSINESS_ID AND" \
                     " G.LOCATION_ID=R.LOCATION_ID" \
                     " WHERE R.CLIENT_USERNAME='{}'" \
                     " AND" \
                     " R.BUSINESS_ID=B.BUSINESS_ID" \
                     " AND" \
                     " L.LOCATION_ID=R.LOCATION_ID" \
                     " AND" \
                     " L.BUSINESS_ID=R.BUSINESS_ID" \
                     " ORDER BY DATE(R.RESERVATION_START) DESC"

BUSINESS_RECV_FEEDBACK = 9
BUSINESS_SENT_FEEDBACK = 10
BUSINESS_GET_HISTORY = "SELECT R.RESERVATION_ID, R.LOCATION_ID," \
                       " R.BUSINESS_ID, R.CLIENT_USERNAME," \
                       " R.RESERVATION_START," \
                       " R.RESERVATION_END," \
                       " R.APPROVED," \
                       " L.ADDRESS," \
                       " R.SPORT_NAME," \
                       " IFNULL(F.MESSAGE, 'no feedback yet') RECV_MESSAGE," \
                       " IFNULL(G.MESSAGE, 'no feedback yet') SENT_MESSAGE" \
                       " FROM" \
                       " RESERVATIONS R, LOCATIONS L" \
                       " LEFT OUTER JOIN BUSINESS_FEEDBACKS F" \
                       " ON F.RESERVATION_ID=R.RESERVATION_ID" \
                       " AND F.BUSINESS_ID=R.BUSINESS_ID" \
                       " AND F.LOCATION_ID=R.LOCATION_ID" \
                       " LEFT OUTER JOIN CLIENT_FEEDBACKS G" \
                       " ON G.RESERVATION_ID=R.RESERVATION_ID" \
                       " AND G.BUSINESS_ID=R.BUSINESS_ID AND" \
                       " G.LOCATION_ID=R.LOCATION_ID" \
                       " WHERE" \
                       " R.BUSINESS_ID=L.BUSINESS_ID" \
                       " AND" \
                       " R.LOCATION_ID=L.LOCATION_ID" \
                       " AND" \
                       " R.BUSINESS_ID='{}'" \
                       " ORDER BY DATE(R.RESERVATION_START) DESC"

CLIENT_CREATE_RESERVATION = "INSERT INTO RESERVATIONS" \
                            " VALUES( (SELECT COUNT(*) FROM RESERVATIONS" \
                            " WHERE BUSINESS_ID='{}'" \
                            " AND LOCATION_ID={}" \
                            " AND SPORT_NAME='{}') + 1," \
                            " {}, '{}', '{}'," \
                            " '{}', '{}', 0, '{}')"

BUSINESS_GET_LOCATION_RESERVATIONS = "SELECT R.RESERVATION_ID, R.LOCATION_ID," \
                                     " R.BUSINESS_ID, R.CLIENT_USERNAME," \
                                     " R.RESERVATION_START," \
                                     " R.RESERVATION_END," \
                                     " R.APPROVED," \
                                     " L.ADDRESS," \
                                     " R.SPORT_NAME" \
                                     " FROM" \
                                     " RESERVATIONS R, LOCATIONS L" \
                                     " WHERE" \
                                     " R.BUSINESS_ID=L.BUSINESS_ID" \
                                     " AND" \
                                     " R.LOCATION_ID=L.LOCATION_ID" \
                                     " AND" \
                                     " R.BUSINESS_ID='{}'" \
                                     " AND" \
                                     " R.LOCATION_ID={}" \
                                     " AND" \
                                     " R.SPORT_NAME='{}'" \
                                     " ORDER BY DATE(R.RESERVATION_START) DESC"

BUSINESS_BLOCK_WINDOW = "INSERT INTO RESERVATIONS" \
                        " VALUES" \
                        " (" \
                        " (SELECT COUNT(*) FROM RESERVATIONS" \
                        " WHERE BUSINESS_ID='{}'" \
                        " AND LOCATION_ID={}" \
                        " AND SPORT_NAME='{}') + 1," \
                        " {}," \
                        " '{}'," \
                        " 'reserved'," \
                        " '{}'," \
                        " '{}'," \
                        " 1," \
                        " '{}')"

BUSINESS_UNBLOCK_WINDOW = "DELETE FROM RESERVATIONS" \
                          " WHERE" \
                          " LOCATION_ID={}" \
                          " AND" \
                          " BUSINESS_ID='{}'" \
                          " AND" \
                          " RESERVATION_START='{}'" \
                          " AND" \
                          " RESERVATION_END='{}'" \
                          " AND" \
                          " SPORT_NAME='{}'"

RESERVATION_APPROVE_DENY_CANCEL = "UPDATE RESERVATIONS" \
                                  " SET APPROVED={}" \
                                  " WHERE" \
                                  " RESERVATION_ID={}" \
                                  " AND" \
                                  " BUSINESS_ID='{}'" \
                                  " AND" \
                                  " LOCATION_ID={}" \
                                  " AND" \
                                  " SPORT_NAME='{}'"

GET_BUSINESS_FEEDBACK = "SELECT MESSAGE FROM BUSINESS_FEEDBACKS" \
                        " WHERE" \
                        " BUSINESS_ID='{}'" \
                        " AND" \
                        " CLIENT_USERNAME='{}'" \
                        " AND" \
                        " LOCATION_ID={}" \
                        " AND" \
                        " RESERVATION_ID={}"

GET_CLIENT_FEEDBACK = "SELECT MESSAGE FROM CLIENT_FEEDBACKS" \
                      " WHERE" \
                      " BUSINESS_ID='{}'" \
                      " AND" \
                      " CLIENT_USERNAME='{}'" \
                      " AND" \
                      " LOCATION_ID={}" \
                      " AND" \
                      " RESERVATION_ID={}"

SEND_BUSINESS_FEEDBACK = "INSERT INTO" \
                         " BUSINESS_FEEDBACKS" \
                         " VALUES(" \
                         " '{}', '{}', {}, {}, '{}', {}" \
                         ")"

SEND_CLIENT_FEEDBACK = "INSERT INTO" \
                       " CLIENT_FEEDBACKS" \
                       " VALUES(" \
                       " '{}', '{}', {}, {}, '{}', {}" \
                       ")"
