# BD: Guião 8


## ​8.1. Complete a seguinte tabela.
Complete the following table.

| #    | Query                                                                                                      | Rows  | Cost  | Pag. Reads | Time (ms) | Index used | Index Op.            | Discussion |
| :--- | :--------------------------------------------------------------------------------------------------------- | :---- | :---- | :--------- | :-------- | :--------- | :------------------- | :--------- |
| 1    | SELECT * from Production.WorkOrder                                                                         | 72591 | 0.484 | 531        | 1171      |WorkOrderID (PK)| Clustered Index Scan |            |
| 2    | SELECT * from Production.WorkOrder where WorkOrderID=1234                                                  |   1   | 0.003 | 26         |27         |WorkOrderID (PK)| Clustered Index Seek|            |
| 3.1  | SELECT * FROM Production.WorkOrder WHERE WorkOrderID between 10000 and 10010                               |  11   | 0.003 |26          |24         |WorkOrderID (PK)| Clustered Index Seek|            |
| 3.2  | SELECT * FROM Production.WorkOrder WHERE WorkOrderID between 1 and 72591                                   | 72591 | 0.394 |556         |1505       |WorkOrderID (PK)| Clustered Index Seek|            |
| 4    | SELECT * FROM Production.WorkOrder WHERE StartDate = '2012-05-14'                                          |  55   | 0.394 |550         |152|WorkOrderID (PK)| Clustered Index Scan|            |
| 5    | SELECT * FROM Production.WorkOrder WHERE ProductID = 757                                                   |   9   | 0.003 |20          |47|ProductID| NonClustered Index Seek & Clustered Key Lookup|            |
| 6.1  | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 757                              |   9   | 0.003 |30          |14|ProductID Covered (StartDate)| NonClustered Index Seek|            |
| 6.2  | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945                              |1105   | 0.005 |36          |41|ProductID Covered (StartDate)|NonClustered Index Seek |            |
| 6.3  | SELECT WorkOrderID FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2011-12-04'            | 1     | 0.005 |38          |27|ProductID Covered (StartDate)|NonClustered Index Seek |            |
| 7    | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2011-12-04' | 1     | 0.005 |38          |28|ProductID and StartDate|NonClustered Index Seek |            |
| 8    | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2011-12-04' | 1     | 0.003 |34          |15|Composite (ProductID, StartDate)|NonClustered Index Seek |            |

## ​8.2.

### a)

```
CREATE UNIQUE CLUSTERED INDEX idx_rid ON dbo.mytemp(rid)
```

### b)

```
Fragmentação: 98.8%
Ocupação: 69.9%
```

### c)

```
Fillfactor 65%: 61264
Fillfactor 80%: 61790
Fillfactor 90%: 65867
```

### d)

```
Fillfactor 65%: 54150
Fillfactor 80%: 54922
Fillfactor 90%: 53871
```

### e)

```
Os tempos de inserção aumentam com o aumento do número de índices, ou seja, a performance é pior com todos os índices.
```

## ​8.3.

```
i. CREATE UNIQUE CLUSTERED INDEX idx_ssn ON EMPLOYEE(Ssn);
ii. CREATE COMPOSITE NONCLUSTERED INDEX idx_name ON EMPLOYEE(Fname, Lname);
iii. CREATE NONCLUSTERED INDEX idx_dno ON EMPLOYEE(Dno);
iv. CREATE UNIQUE CLUSTERED INDEX idx_essn_pno ON WORKS_ON(Essn, Pno);
v. CREATE UNIQUE CLUSTERED INDEX idx_essn_dname ON DEPENDENT(Essn, Dependent_name);
vi. CREATE COMPOSITE NONCLUSTERED INDEX idx_pnumber_dnum ON PROJECT(Pnumber, Dnum);
```
