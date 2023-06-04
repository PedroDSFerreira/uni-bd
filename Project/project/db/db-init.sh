# Wait to be sure that SQL Server came up
sleep 60s

# Run the setup script to create the DB and the schema in the DB
# Note: make sure that your password matches what is in the Dockerfile
/opt/mssql-tools/bin/sqlcmd -S bd -U sa -P MyPass@word -d master -i schema.sql
/opt/mssql-tools/bin/sqlcmd -S bd -U sa -P MyPass@word -d master -i tables.sql
/opt/mssql-tools/bin/sqlcmd -S bd -U sa -P MyPass@word -d master -i inserts.sql
/opt/mssql-tools/bin/sqlcmd -S bd -U sa -P MyPass@word -d master -i triggers.sql
/opt/mssql-tools/bin/sqlcmd -S bd -U sa -P MyPass@word -d master -i indexes.sql
/opt/mssql-tools/bin/sqlcmd -S bd -U sa -P MyPass@word -d master -i udfs.sql
/opt/mssql-tools/bin/sqlcmd -S bd -U sa -P MyPass@word -d master -i stored-procedures.sql
/opt/mssql-tools/bin/sqlcmd -S bd -U sa -P MyPass@word -d master -i views.sql