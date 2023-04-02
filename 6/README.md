# BD: Guião 6

## Problema 6.1

### *a)* Todos os tuplos da tabela autores (authors);

```sql
SELECT * FROM authors;
```

### *b)* O primeiro nome, o último nome e o telefone dos autores;

```sql
SELECT authors.au_fname, authors.au_lname, authors.phone FROM authors;
```

### *c)* Consulta definida em b) mas ordenada pelo primeiro nome (ascendente) e depois o último nome (ascendente); 

```sql
SELECT authors.au_fname, authors.au_lname, authors.phone FROM authors ORDER BY authors.au_fname, authors.au_lname;
```

### *d)* Consulta definida em c) mas renomeando os atributos para (first_name, last_name, telephone); 

```sql
SELECT authors.au_fname AS first_name, authors.au_lname AS last_name, authors.phone AS telephone FROM authors ORDER BY authors.au_fname, authors.au_lname;
```

### *e)* Consulta definida em d) mas só os autores da Califórnia (CA) cujo último nome é diferente de ‘Ringer’; 

```sql
SELECT authors.au_fname AS first_name, authors.au_lname AS last_name, authors.phone AS telephone FROM authors WHERE authors.au_lname != 'Ringer' AND [state] = 'CA' ORDER BY authors.au_fname, authors.au_lname;
```

### *f)* Todas as editoras (publishers) que tenham ‘Bo’ em qualquer parte do nome; 

```sql
SELECT * FROM publishers WHERE pub_name like '%Bo%';
```

### *g)* Nome das editoras que têm pelo menos uma publicação do tipo ‘Business’; 

```sql
SELECT DISTINCT pub_name FROM (titles JOIN publishers ON publishers.pub_id=titles.pub_id) WHERE type='Business';
```

### *h)* Número total de vendas de cada editora; 

```sql
SELECT pub_name, SUM(ytd_sales) AS total_sales
FROM publishers JOIN titles ON publishers.pub_id=titles.pub_id
GROUP BY pub_name
```

### *i)* Número total de vendas de cada editora agrupado por título; 

```sql
SELECT title, pub_name, ytd_sales
FROM publishers JOIN titles ON publishers.pub_id=titles.pub_id
```

### *j)* Nome dos títulos vendidos pela loja ‘Bookbeat’; 

```sql
SELECT title FROM (titles JOIN (
	SELECT title_id FROM (stores JOIN sales ON stores.stor_id=sales.stor_id) 
		WHERE stor_name='Bookbeat') AS store_titles ON titles.title_id=store_titles.title_id)
```

### *k)* Nome de autores que tenham publicações de tipos diferentes; 

```sql
SELECT au_fname, au_lname
FROM authors JOIN (SELECT au_id
	FROM (titles JOIN titleauthor ON titles.title_id=titleauthor.title_id) 
		GROUP BY au_id
			HAVING COUNT(DISTINCT type) > 1) AS diff_types ON authors.au_id=diff_types.au_id;
```

### *l)* Para os títulos, obter o preço médio e o número total de vendas agrupado por tipo (type) e editora (pub_id);

```sql
SELECT type, pub_id, AVG(price) AS avg_price, SUM(ytd_sales) AS total_sales
FROM titles
GROUP BY type, pub_id
```

### *m)* Obter o(s) tipo(s) de título(s) para o(s) qual(is) o máximo de dinheiro “à cabeça” (advance) é uma vez e meia superior à média do grupo (tipo);

```sql
SELECT type, AVG(advance) AS avg_advance
FROM titles
GROUP BY type
HAVING MAX(advance) > 1.5*AVG(advance)
```

### *n)* Obter, para cada título, nome dos autores e valor arrecadado por estes com a sua venda;

```sql
SELECT title, author, ytd_sales*price*royaltyper/100*royalty/100 AS total_earnings
FROM titles JOIN 
		(SELECT authors.au_id, au_fname + ' ' + au_lname AS author, title_id, royaltyper
		FROM titleauthor JOIN authors ON titleauthor.au_id=authors.au_id) AS a
	ON titles.title_id=a.title_id
GROUP BY title, royalty, price, author, ytd_sales, royaltyper
```

### *o)* Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, a faturação total, o valor da faturação relativa aos autores e o valor da faturação relativa à editora;

```sql
SELECT ytd_sales, title, ytd_sales*price AS total_revenue, ytd_sales*price*royalty/100 AS authors_share, price*ytd_sales*(100-royalty)/100 AS publishers_share
FROM titles JOIN 
		(SELECT authors.au_id, au_fname + ' ' + au_lname AS author, title_id, royaltyper
		FROM titleauthor JOIN authors ON titleauthor.au_id=authors.au_id) AS a
	ON titles.title_id=a.title_id
GROUP BY title, royalty, price, author, ytd_sales, royaltyper
```

### *p)* Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, o nome de cada autor, o valor da faturação de cada autor e o valor da faturação relativa à editora;

```sql
SELECT ytd_sales, title, author, ytd_sales*price*royaltyper/100*royalty/100 AS authors_share, price*ytd_sales*(100-royalty)/100 AS publishers_share
FROM titles JOIN 
		(SELECT authors.au_id, au_fname + ' ' + au_lname AS author, title_id, royaltyper
		FROM titleauthor JOIN authors ON titleauthor.au_id=authors.au_id) AS a
	ON titles.title_id=a.title_id
GROUP BY title, royalty, price, author, ytd_sales, royaltyper
```

### *q)* Lista de lojas que venderam pelo menos um exemplar de todos os livros;

```sql
SELECT stor_name, title
FROM titles JOIN
		(SELECT stor_name, title_id
		FROM sales JOIN stores ON sales.stor_id=stores.stor_id) AS s
	ON titles.title_id=s.title_id
GROUP BY stor_name, title
HAVING (SELECT DISTINCT COUNT(title)) >= (SELECT COUNT(title) FROM titles)
```

### *r)* Lista de lojas que venderam mais livros do que a média de todas as lojas;

```sql
SELECT stor_name, SUM(qty) as books_sold
FROM sales JOIN stores ON sales.stor_id=stores.stor_id
GROUP BY stor_name
HAVING SUM(qty) > (SELECT AVG(b) FROM (SELECT stor_name, SUM(qty) AS b
					FROM sales JOIN stores ON sales.stor_id=stores.stor_id
					GROUP BY stor_name) AS s)
```

### *s)* Nome dos títulos que nunca foram vendidos na loja “Bookbeat”;

```sql
SELECT title
FROM titles
WHERE title NOT IN (SELECT DISTINCT title 
					FROM titles JOIN sales ON titles.title_id=sales.title_id
								JOIN stores ON sales.stor_id=stores.stor_id
					WHERE stor_name='Bookbeat')
```

### *t)* Para cada editora, a lista de todas as lojas que nunca venderam títulos dessa editora; 

```sql
SELECT pub_name, stor_name
FROM publishers, stores
EXCEPT
	(SELECT publishers.pub_name, stores.stor_name
	FROM publishers JOIN titles ON publishers.pub_id=titles.pub_id
					JOIN sales ON titles.title_id=sales.title_id
					JOIN stores ON sales.stor_id=stores.stor_id)
ORDER BY pub_name
```

## Problema 6.2

### ​5.1

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_1_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_1_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```sql
SELECT Fname,Minit,Lname,Ssn,Pname
FROM 	project JOIN works_on ON Pnumber=Pno
				JOIN employee ON Ssn=Essn
```

##### *b)* 

```sql
SELECT Fname,Minit,Lname
FROM employee JOIN
		(SELECT Ssn
		FROM employee
		WHERE Fname='Carlos' AND Minit='D' AND Lname='Gomes') AS supervisor
	ON employee.Super_ssn=supervisor.Ssn
```

##### *c)* 

```sql
SELECT Pname, SUM(Hours) AS total_hours
FROM project JOIN works_on ON Pnumber=Pno
GROUP BY Pname
```

##### *d)* 

```sql
SELECT Fname,Minit,Lname
FROM project JOIN works_on ON Pnumber=Pno
			JOIN department ON Dnumber=Dnum
			JOIN employee ON Ssn=Essn
WHERE Dnumber=3 AND Hours>20 AND Pname='Aveiro Digital'
```

##### *e)* 

```sql
SELECT Fname,Minit,Lname
FROM employee LEFT JOIN works_on ON Ssn=Essn
WHERE Pno IS NULL 
```

##### *f)* 

```sql
SELECT Dname, AVG(Salary) AS SalaryAvg 
FROM employee JOIN department ON Dno=Dnumber
WHERE Sex='F'
GROUP BY Dname
```

##### *g)* 

```sql
SELECT Fname,Minit,Lname 
FROM (SELECT Fname,Minit,Lname,count(Ssn) AS Relatives 
			FROM dependent JOIN employee ON Essn=Ssn
		 	GROUP BY Fname,Minit,Lname) AS employee
WHERE employee.Relatives>2
```

##### *h)* 

```sql
SELECT Fname,Minit,Lname
FROM employee 
	JOIN department ON Mgr_ssn=Ssn
	LEFT JOIN dependent ON Essn=Ssn
WHERE Essn IS NULL
```

##### *i)* 

```sql
SELECT Fname, Minit, Lname, Address
FROM works_on JOIN
	(SELECT *
	FROM project JOIN
		(SELECT department.Dnumber
		FROM department JOIN dept_location ON department.Dnumber=dept_location.Dnumber
		WHERE Dlocation!='Aveiro') AS dept
	ON Dnum=dept.Dnumber
	WHERE Plocation='Aveiro') AS proj
ON Pno=Pnumber
JOIN employee ON Ssn=Essn
```

### 5.2

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_2_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_2_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```sql
SELECT nome, nif
FROM fornecedor LEFT JOIN encomenda ON nif=fornecedor
WHERE numero IS NULL
```

##### *b)* 

```sql
SELECT nome, codigo, avg(item.unidades) AS avg_un
FROM item JOIN produto ON codigo=codProd
GROUP BY nome, codigo
```


##### *c)* 

```sql
SELECT AVG(cnt) AS mean
FROM (SELECT numEnc, COUNT(numEnc) AS cnt
			FROM produto JOIN item ON codigo=codProd
		 	GROUP BY numEnc) AS enc
```


##### *d)* 

```sql
SELECT produto.codigo, produto.nome, item.unidades, fornecedor.nif
FROM encomenda 	JOIN fornecedor ON fornecedor=nif
				JOIN item ON numEnc=numero
				JOIN produto ON codigo=codProd
```

### 5.3

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_3_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_3_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```sql
SELECT nome 
FROM paciente LEFT JOIN prescricao ON prescricao.numUtente=paciente.numUtente
WHERE numPresc IS NULL
```

##### *b)* 

```sql
SELECT especialidade, COUNT(especialidade) AS numPresc
FROM prescricao JOIN medico ON numMedico=numSNS
GROUP BY especialidade
```


##### *c)* 

```sql
SELECT nome, COUNT(nome) AS num_prescricao
FROM prescricao JOIN farmacia ON farmacia=nome
GROUP BY nome
```


##### *d)* 

```sql
SELECT nome 
FROM farmaco LEFT JOIN presc_farmaco ON nome=nomeFarmaco
WHERE farmaco.numRegFarm=906 AND numPresc IS NULL
```

##### *e)* 

```sql
SELECT farmacia.nome, COUNT(farmacia.nome) AS num_farmacos
FROM farmaco 	JOIN farmaceutica ON numRegFarm=numReg
				JOIN presc_farmaco ON presc_farmaco.numRegFarm=numReg
				JOIN prescricao ON prescricao.numPresc=presc_farmaco.numPresc
				JOIN farmacia ON farmacia.nome=prescricao.farmacia
GROUP BY farmacia.nome
```

##### *f)* 

```sql
SELECT nome
FROM paciente NATURAL JOIN
	(SELECT numUtente, COUNT(numMedico) AS num_med 
	FROM prescricao
	GROUP BY numUtente) AS med
WHERE num_med > 1
```
