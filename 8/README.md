# BD: Guião 8


## ​8.1. Complete a seguinte tabela.
Complete the following table.

| #    | Query                                                                                                      | Rows  | Cost  | Pag. Reads | Time (ms) | Index used | Index Op.            | Discussion |
| :--- | :--------------------------------------------------------------------------------------------------------- | :---- | :---- | :--------- | :-------- | :--------- | :------------------- | :--------- |
| 1    | SELECT * from Production.WorkOrder                                                                         | 72591 | 0.484 | 531        | 1171      |PK_WorkOrder_WorkOrderID| Clustered Index Scan |            |
| 2    | SELECT * from Production.WorkOrder where WorkOrderID=1234                                                  |   1   | 0.003 | 26         |54         |PK_WorkOrder_WorkOrderID| Clustered Index Seek|            |
| 3.1  | SELECT * FROM Production.WorkOrder WHERE WorkOrderID between 10000 and 10010                               |  11   | 0.003 |26          |61         |PK_WorkOrder_WorkOrderID| Clustered Index Seek|            |
| 3.2  | SELECT * FROM Production.WorkOrder WHERE WorkOrderID between 1 and 72591                                   | 72591 | 0.394 |556         |530        |PK_WorkOrder_WorkOrderID| Clustered Index Seek|            |
| 4    | SELECT * FROM Production.WorkOrder WHERE StartDate = '2007-06-25'                                          |  0    | 0.394 |556         |42         |PK_WorkOrder_WorkOrderID| Clustered Index Scan|            |
| 5    | SELECT * FROM Production.WorkOrder WHERE ProductID = 757                                                   |   9   | 0.003 |46          |75         |IX_WorkOrder_ProductID & PK_WorkOrder_WorkOrderID| NonClustered Index Seek & Clustered Key Lookup|            |
| 6.1  | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 757                              |   9   | 0.003 |46          |32         |IX_WorkOrder_ProductID & PK_WorkOrder_WorkOrderID| NonClustered Index Seek & Clustered Key Lookup|            |
| 6.2  | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945                              |1105   | 0.394 |556         |50         |PK_WorkOrder_WorkOrderID|Clustered Index Scan |            |
| 6.3  | SELECT WorkOrderID FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04'            | 0     | 0.394 |558         |12         |PK_WorkOrder_WorkOrderID|Clustered Index Scan |            |
| 7    | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04' | 0     | 0.394 |558         |12         |PK_WorkOrder_WorkOrderID|Clustered Index Scan |            |
| 8    | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04' | 0     | 0.394 |558         |14         |PK_WorkOrder_WorkOrderID|Clustered Index Scan |            |

## ​8.2.

### a)

```
... Write here your answer ...
```

### b)

```
... Write here your answer ...
```

### c)

```
... Write here your answer ...
```

### d)

```
... Write here your answer ...
```

### e)

```
... Write here your answer ...
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
