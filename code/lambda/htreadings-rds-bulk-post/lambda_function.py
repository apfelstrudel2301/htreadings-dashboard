import json
import pymysql
import datetime
import os

RDS_ENDPOINT = os.environ.get('RDS_ENDPOINT')
DB_NAME = os.environ.get('DB_NAME')
DB_USERNAME = os.environ.get('DB_USERNAME')

def lambda_handler(event, context):
    sensordata_list = json.loads(event['body'])
    password = 'adminadmin'
    for sensordata in sensordata_list:
        if not all(k in sensordata for k in ('temperature', 'humidity', 'timestamp')):
            return {
                'statusCode': 400,
                'body': json.dumps('Invalid body. Not all attributes present.')
            }
        timestamp = sensordata['timestamp']
        temperature = sensordata['temperature']
        humidity = sensordata['humidity']
        try:
            temperature = float(temperature)
            humidity = float(humidity)
            timestamp = datetime.datetime.strptime(timestamp, "%Y-%m-%d %H:%M:%S.%f")
        except ValueError:
            return {
                'statusCode': 400,
                'body': json.dumps('Attributes cannot be cast.')
            }
    # Truncate table and bulk insert
    try:
        conn = pymysql.connect(RDS_ENDPOINT, user=DB_USERNAME, passwd=password, db=DB_NAME, connect_timeout=5)
        cursor = conn.cursor()
        cursor.execute("TRUNCATE TABLE htreadings")
        cursor.executemany("""
        INSERT INTO htreadings (timestamp, temperature, humidity)
        VALUES (%(timestamp)s, %(temperature)s, %(humidity)s)
        """, sensordata_list)
        conn.commit()
        conn.close()

    except Exception as error:
        return {
            'statusCode': 500,
            'body': json.dumps('Error when inserting into DB: {}'.format(error))
        }
    return {
            'statusCode': 200,
            'body': json.dumps('Inserted successfully.')
        }