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
γ Dname;SalaryAvg←avg(Salary) (σ Sex='F' (employee ⨝ Dno=Dnumber department))
```


### *g)* 

```
π Fname,Minit,Lname (σ Relatives>2 (γ Fname,Minit,Lname;Relatives←count(Ssn) (dependent ⨝ Essn=Ssn employee)))
```


### *h)* 

```
π Fname,Minit,Lname (σ Essn=null (dependent ⟖ Essn=Ssn (department ⨝ Mgr_ssn=Ssn employee)))
```


### *i)* 

```
π Fname,Minit,Lname,Address (γ Fname,Minit,Lname,Address;cnt←count(Ssn) (employee ⨝Ssn=Essn (works_on ⨝Pno=Pnumber (σ Plocation='Aveiro' (project ⨝Dnum=department.Dnumber (σ Dlocation≠'Aveiro' (department ⨝ department.Dnumber=dept_location.Dnumber dept_location)))))))
```


## ​Problema 5.2

### *a)*

```
π nome, nif σ numero=null (fornecedor ⟕ nif=fornecedor encomenda)
```

### *b)* 

```
γ nome, codigo; AvgUn←avg(item.unidades) (item ⨝ (codigo=codProd) produto)
```


### *c)* 

```
γ mean←avg(cnt) γ numero;cnt←count(numero) (produto ⨝codigo=codProd (encomenda ⨝numero=numEnc item))
```


### *d)* 

```
... Write here your answer ...
```


## ​Problema 5.3

### *a)*

```
π nome (σ numPresc=null (paciente ⟕prescricao.numUtente=paciente.numUtente prescricao))
```

### *b)* 

```
γ especialidade;numPresc←count(especialidade) (prescricao ⨝numMedico=numSNS medico)
```


### *c)* 

```
γ nome;num_prescricao←count(nome) (prescricao ⨝farmacia=nome farmacia)
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
