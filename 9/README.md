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

```sql
CREATE TRIGGER mgr_restrain ON company.dbo.department
AFTER INSERT, UPDATE AS
BEGIN
	DECLARE @Ssn char(9);
	SELECT @Ssn=Mgr_ssn FROM inserted;

	IF EXISTS(SELECT Mgr_ssn FROM inserted WHERE Mgr_ssn=@Ssn)
	BEGIN
		ROLLBACK TRAN;
		RAISERROR('Funcionário já é gestor de um departartamento', 16, 1);
	END
END
```

### *d)* 

```sql
CREATE TRIGGER salary_restrain ON employee
INSTEAD OF INSERT, UPDATE
AS
BEGIN

    DECLARE @Salary as float;
    DECLARE @Mgr_salary as float = NULL;
    DECLARE @IsUpdate as int;

    SELECT @Salary=Salary FROM inserted;
    SELECT @IsUpdate=COUNT(*) FROM deleted;


    SELECT @Mgr_salary=employee.Salary
    FROM inserted JOIN department ON inserted.Dno=Dnumber
        JOIN employee ON Mgr_ssn=Employee.Ssn
    WHERE employee.Salary<@Salary;

    if(@IsUpdate = 0)
    BEGIN
        if (@Mgr_salary = NULL)
        BEGIN
            INSERT INTO employee
            SELECT *
            FROM inserted;
        END
    ELSE
        BEGIN
            INSERT INTO employee
            SELECT Fname, Minit, Lname, Ssn, Bdate, [Address], Sex, @Mgr_salary-1, Super_ssn, Dno
            FROM inserted;
        END
    END
    ELSE
    BEGIN
        if (@Mgr_salary = NULL)
        BEGIN
            UPDATE employee
            SET Fname=inserted.Fname, Minit=inserted.Minit, Lname=inserted.Lname, Ssn=inserted.Ssn, Bdate=inserted.Bdate, [Address]=inserted.[Address], Sex=inserted.Sex, Salary=inserted.Salary, Super_ssn=inserted.Super_ssn, Dno=inserted.Dno
            FROM deleted JOIN inserted ON deleted.Ssn=inserted.Ssn;
        END
        ELSE
        BEGIN
            UPDATE employee
            SET Fname=inserted.Fname, Minit=inserted.Minit, Lname=inserted.Lname, Ssn=inserted.Ssn, Bdate=inserted.Bdate, [Address]=inserted.[Address], Sex=inserted.Sex, Salary=@Mgr_salary-1, Super_ssn=inserted.Super_ssn, Dno=inserted.Dno
            FROM deleted JOIN inserted ON deleted.Ssn=inserted.Ssn;
        END
    END

END
```

### *e)* 

```sql
CREATE FUNCTION get_emp_projs (@ssn char(9))
RETURNS TABLE 
AS 
	RETURN(SELECT Pname, Plocation 
			FROM works_on JOIN employee ON Essn=Ssn
				JOIN project ON Pno=Pnumber
				WHERE Ssn=@ssn);
```

### *f)* 

```sql
CREATE FUNCTION get_top_salaries(@dno int)
RETURNS TABLE
AS
	RETURN(
	SELECT Fname+' '+Minit+' '+Lname AS [Name] FROM employee WHERE Dno=@dno AND Salary >= (
		SELECT AVG(Salary) FROM employee WHERE Dno=@dno));
```

### *g)* 

```sql
CREATE FUNCTION employeeDeptHighAverage(@dno int) RETURNS @table TABLE (pname varchar(128), number int, plocation varchar(256), dnum int, budget float, totalbudget float)
as
BEGIN

    DECLARE @pname as varchar(128), @number as int, @plocation as varchar(256), @dnum as int, @budget as float, @totalbudget as float;

    DECLARE C CURSOR FAST_FORWARD
    FOR SELECT Pname, Pnumber, Plocation, Dnumber, Sum(Salary*[Hours]/40)
        FROM    department 
                JOIN project ON Dnumber=Dnum
                JOIN works_on ON Pnumber=Pno
                JOIN employee ON Essn=Ssn
        WHERE Dnumber=@dno
        GROUP BY Pname, Pnumber, Plocation, Dnumber;

    OPEN C;

    FETCH C INTO @pname, @number, @plocation, @dnum, @budget;
    SELECT @totalbudget = 0;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @totalbudget += @budget;
        INSERT INTO @table VALUES (@pname, @number, @plocation, @dnum, @budget, @totalbudget)
        FETCH C INTO @pname, @number, @plocation, @dnum, @budget;
    END

    CLOSE C;

    DEALLOCATE C;

    return;
END
```

### *h)* 

```sql
CREATE TRIGGER delete_dep_trigger ON department
INSTEAD OF DELETE
AS
BEGIN

    IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_NAME = 'deleted_department'))
        BEGIN
            CREATE TABLE deleted_department (Dname varchar(128) NOT NULL, Dnumber int PRIMARY KEY, Mgr_ssn char(9), Mgr_start_date date);
        END

    DELETE FROM project WHERE Dnum in (SELECT Dnumber FROM deleted);
    UPDATE employee SET Dno=NULL WHERE DNO IN (SELECT Dnumber FROM deleted);
    INSERT INTO deleted_department SELECT * FROM DELETED;
    DELETE FROM department WHERE Dnumber IN (SELECT Dnumber FROM deleted);

END
```

### *i)* 

```
Relativamente aos stored procedures, as UDFs têm os mesmos benefícios relativamente a compilação, otimização, integridade de dados e segurança, tendo a vantagem de poder ser integrados em consultas, de poder ser utilizado como uma fonte de dados nas mesmas e em cláusulas WHERE/HAVING, e de aceitar parâmetros de entrada (algo que não é possível com views).
```
