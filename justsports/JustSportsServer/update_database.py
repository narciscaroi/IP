"""
    Database structure:

    -- INDIVIDUAL_CLIENTS --
    #USERNAME       VARCHAR2(20)
    FIRST_NAME      VARCHAR2(20)
    LAST_NAME       VARCHAR2(20)
    PASSWORD        VARCHAR2(64)
    PHONE_NUMBER    NUMBER(10)
    EMAIL           VARCHAR2(50)

    -- BUSINESS_CLIENTS --
    #BUSINESS_ID    VARCHAR2(20)
    BUSINESS_NAME   VARCHAR2(20)
    PASSWORD        VARCHAR2(64)
    PHONE_NUMBER    NUMERIC(10)
    EMAIL           VARCHAR2(50)
    ADDRESS         VARCHAR2(128)

    -- LOCATIONS --
    LOCATION_ID    NUMERIC(10)
    BUSINESS_ID     VARCHAR2(20)  FK
    ADDRESS         VARCHAR2(128)
    PRIMARY KEY(LOCATION_ID, BUSINESS_ID)

    -- RESERVATIONS --
    #RESERVATION_ID     NUMERIC(10)
    LOCATION_ID         NUMERIC(10)  FK_LOCATION
    BUSINESS_ID         VARCHAR2(20) FK_LOCATION
    CLIENT_USERNAME     VARCHAR2(20) FK_USER
    RESERVATION_START   DATE
    RESERVATION_END     DATE
    APPROVED            NUMERIC(1)

    -- SPORTS --
    SPORT_NAME      VARCHAR2(20)
    BUSINESS_ID     VARCHAR2(20)    FK
    LOCATION_ID     NUMERIC(10)     FK
    PRIMARY KEY(SPORTS_NAME, BUSINESS_ID, LOCATION_ID)

    -- BUSINESS_FEEDBACKS --
    FEEDBACK_ID         NUMERIC(10)
    CLIENT_USERNAME     VARCHAR2(20) FK
    BUSINESS_ID         VARCHAR2(20) FK
    MESSAGE             VARCHAR2(1024)
    STARS               NUMERIC(1)
    PRIMARY KEY(FEEDBACK_ID, BUSINESS_ID)

    -- CLIENT_FEEDBACKS --
    FEEDBACK_ID         NUMERIC(10)
    CLIENT_USERNAME     VARCHAR2(20) FK
    BUSINESS_ID         VARCHAR2(20) FK
    MESSAGE             VARCHAR2(1024)
    STARS               NUMERIC(1)
    PRIMARY KEY(FEEDBACK_ID, CLIENT_USERNAME)
"""
import sqlite3
from hashlib import sha256


def encrypt_str(original_str):
    return sha256(original_str.encode()).hexdigest()


if __name__ == '__main__':
    con = sqlite3.connect('project.db')
    print(encrypt_str('Te$5'))

    out_str = '''INSERT INTO BUSINESS_CLIENTS
                    VALUES
                    (
                    "testtest",
                    "test_company",
                    "aaa0b05bb5771095a0fda52cf375b9d4880a6fcdba2a19ff886f1e2f98a6515d",
                    6666666666,
                    "test@hatz.com",
                    "sector0"
                    )'''
    #
    # print(out_str)
    #
    res = con.execute(out_str)

    # print(res)

    # for i in res:
    #     print(i)

    con.commit()
    con.close()
