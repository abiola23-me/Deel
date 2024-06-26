# app.py
from flask import Flask, request
import psycopg2
import os

app = Flask(__name__)

db_host = os.environ.get('DB_HOST')
db_name = os.environ.get('DB_NAME')
db_user = os.environ.get('DB_USER')
db_password = os.environ.get('DB_PASSWORD')

def get_db_connection():
    conn = psycopg2.connect(
        host=db_host,
        database=db_name,
        user=db_user,
        password=db_password
    )
    return conn

@app.route('/')
def index():
    ip = request.remote_addr
    reversed_ip = '.'.join(ip.split('.')[::-1])
    return f"Your reversed IP is: {reversed_ip}"

@app.route('/db')
def db_test():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT version()')
    db_version = cur.fetchone()
    cur.close()
    conn.close()
    return f"DB Version: {db_version}"
  @app.route('/db')
def db_test():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT version()')
    db_version = cur.fetchone()
    cur.close()
    conn.close()
    return f"DB Version: {db_version}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
