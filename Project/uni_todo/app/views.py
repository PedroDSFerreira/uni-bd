from django.shortcuts import render
from django.http import HttpResponse
from django.db import connection



def index(request):
    return render(request, 'app/index.html')


def insert(request):
    insert_data('db/inserts/test.sql')
    return HttpResponse("Data inserted")

def insert_data(file):
    """Insert data into the database from sql file"""
    with connection.cursor() as cursor:
        with open(file) as f:
            for line in f.readlines():
                cursor.execute(line)