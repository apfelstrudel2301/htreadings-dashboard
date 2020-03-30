import pymysql
import os
import json

RDS_ENDPOINT = os.environ.get('RDS_ENDPOINT')
DB_NAME = os.environ.get('DB_NAME')
DB_USERNAME = os.environ.get('DB_USERNAME')


def lambda_handler(event, context):
    password = 'adminadmin'
    try:
        conn = pymysql.connect(RDS_ENDPOINT, user=DB_USERNAME, passwd=password, db=DB_NAME, connect_timeout=5)
        cursor = conn.cursor()
        cursor.execute('CREATE TABLE htreadings (id INTEGER PRIMARY KEY AUTO_INCREMENT, timestamp DATETIME, temperature FLOAT, humidity FLOAT)')
        conn.commit()
        conn.close()
        return {
            'statusCode': 200,
            'body': json.dumps('Created table htreadings successfully.')
        }
    except Exception as error:
        return {
            'statusCode': 500,
            'body': json.dumps('Error when creating table htreadings DB: {}'.format(error))
        }