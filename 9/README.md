# BD: Guião 9


## ​9.1
 
### *a)*

```sql
CREATE PROCEDURE remove_employee (@ssn char(9)) AS
BEGIN
	DELETE FROM company.dbo.dependent WHERE Essn=@ssn;
	DELETE FROM company.dbo.works_on WHERE Essn=@ssn;
	UPDATE company.dbo.department SET Mgr_ssn=Null WHERE Mgr_ssn=@ssn;
	UPDATE company.dbo.employee SET Super_ssn=Null WHERE Super_ssn=@ssn;
	DELETE FROM company.dbo.employee WHERE Ssn=@ssn;
END
```

### *b)* sql

```
CREATE PROCEDURE get_managers (@Fname varchar(128) output, @Lname varchar(128) output, @ssn char(9) output, @num_years int output) AS
BEGIN
	SELECT top 1 @Fname=Fname, @Lname=Lname, @ssn=Ssn, @num_years=DATEDIFF(year,Mgr_start_date, GETDATE())
	FROM
	(SELECT Fname,Lname,Ssn,Mgr_start_date
	FROM company.dbo.employee JOIN company.dbo.department ON Ssn=Mgr_ssn) AS o ORDER BY Mgr_start_date;

END


GO

DECLARE @Fname varchar(128);
DECLARE @Lname varchar(128);
DECLARE @ssn char(9);
DECLARE @num_yrs int;

EXEC dbo.get_managers @Fname output, @Lname output, @ssn output, @num_yrs output;

SELECT @Fname+' '+@Lname AS _name, @ssn AS ssn, @num_yrs AS yrs
```

### *c)* 

```
... Write here your answer ...
```

### *d)* 

```
... Write here your answer ...
```

### *e)* 

```
... Write here your answer ...
```

### *f)* 

```
... Write here your answer ...
```

### *g)* 

```
... Write here your answer ...
```

### *h)* 

```
... Write here your answer ...
```

### *i)* 

```
... Write here your answer ...
```
