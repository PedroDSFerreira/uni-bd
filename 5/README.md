# BD: Guião 5


## ​Problema 5.1
 
### *a)*

```
π Fname,Minit,Lname,Ssn,Pname (employee ⨝ Ssn=Essn (project ⨝ Pnumber=Pno works_on))
```


### *b)* 

```
π Fname,Minit,Lname (employee ⨝ employee.Super_ssn=supervisor.Ssn (ρ supervisor π Ssn σ Fname='Carlos' ∧ Minit='D' ∧ Lname='Gomes' (employee)))
```


### *c)* 

```
γ Pname; total_hours←sum(Hours) (project ⨝ Pnumber=Pno works_on)
```


### *d)* 

```
π Fname,Minit,Lname σ Dnumber=3 ∧ Hours>20 ∧ Pname='Aveiro Digital' (employee ⨝ Ssn=Essn (department ⨝ Dnumber=Dnum (project ⨝ Pnumber=Pno works_on)))
```


### *e)* 

```
π Fname,Minit,Lname (σ Pno=null (employee ⟕ Ssn=Essn works_on))
```


### *f)* 

```
(γ Dname;SalaryAvg←avg(Salary) (σ Sex='F' (employee ⨝ Dno=Dnumber department)))
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


## ​Problema 5.2

### *a)*

```
... Write here your answer ...
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


## ​Problema 5.3

### *a)*

```
... Write here your answer ...
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
