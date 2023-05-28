from time import sleep
from django.db import connection
import os

def read_sql_file(file):
    """Reads a SQL file and executes it against the database."""
    with connection.cursor() as cursor:
        with open(file) as f:
            sql = f.read()
            cursor.execute(sql)

def setup_db():
    """Sets up the database by reading the SQL files in the db directory."""
    read_sql_file("db/schema.sql")
    read_sql_file("db/creates.sql")
    read_sql_file("db/inserts.sql")
    proc_files = os.listdir("db/procs/")
    read_sql_file("db/triggers.sql")

    for file in proc_files:
        if file.endswith(".sql"):
            proc_file_path = os.path.join("db/procs/", file)
            read_sql_file(proc_file_path)
            
def main():
    sleep(5)
    setup_db()