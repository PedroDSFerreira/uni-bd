# syntax=docker/dockerfile:1
FROM python:3

# set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /app/code

# mssql dependencies
# https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver15#ubuntu17
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install unixodbc-dev msodbcsql17 -y



# python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade -r requirements.txt

COPY . .
RUN chmod +x docker-entrypoint.sh
# ENTRYPOINT [ "/app/code/docker-entrypoint.sh" ]