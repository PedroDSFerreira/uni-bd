FROM mcr.microsoft.com/mssql/server:2019-latest 

# Create app directory
WORKDIR /app

# Copy initialization scripts
COPY . .

# Expose port 1433 in case accessing from other container
# Expose port externally from docker-compose.yml
EXPOSE 1433


# Run Microsoft SQL Server and initialization script (at the same time)
CMD /bin/bash ./entrypoint.sh