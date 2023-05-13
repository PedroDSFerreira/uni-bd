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

### *b)* 

```
... Write here your answer ...
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
