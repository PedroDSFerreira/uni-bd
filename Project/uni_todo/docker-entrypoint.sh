#!/bin/bash

echo "Flush the manage.py command if any"

while ! python manage.py flush --no-input 2>&1; do
  echo "Flushing django manage command"
  sleep 3
done

echo "Migrate the Database at startup of project"

# Wait for few minutes and run db migraiton
while ! python manage.py migrate  2>&1; do
   echo "Migration is in progress..."
   sleep 3
done

echo "Django docker is configured successfully."

exec "$@"