# BD: Guião 3


## ​Problema 3.1
 
### *a)*

```
Cliente(nome, endereco, num_carta, NIF)
Aluguer(numero, duracao, data, numero_balcao, nif_cliente, matricula_veiculo)
Balcao(nome, numero, endereco)
Veiculo(matricula, ano, marca, codigo_tipo_veiculo)
Similaridade(codigo_tipo_veiculo_1, codigo_tipo_veiculo_2)
Tipo_veiculo(designacao, arcondicionado, codigo)
Ligeiro(codigo_tipo_veiculo, numlugares, portas, combustivel)
Pesado(codigo_tipo_veiculo, peso, passageiros)
```


### *b)* 

```
Cliente
CK: NIF, num_carta; PK: NIF; FK: -

Aluguer:
CK: numero; PK: numero; FK: numero_balcao, nif_cliente, matricula_veiculo

Balcao:
CK: numero; PK: numero; FK: -

Veiculo:
CK: matricula; PK: matricula; FK: codigo_tipo_veiculo

Tipo_veiculo:
CK: codigo; PK: codigo; FK: -

Similaridade:
CK: codigo_tipo_veiculo_1, codigo_tipo_veiculo_2; PK: codigo_tipo_veiculo_1, codigo_tipo_veiculo_2; FK: codigo_tipo_veiculo_1, codigo_tipo_veiculo_2

Ligeiro:
CK: codigo_tipo_veiculo; PK: codigo_tipo_veiculo; FK: codigo_tipo_veiculo

Pesado:
CK: codigo_tipo_veiculo; PK: codigo_tipo_veiculo; FK: codigo_tipo_veiculo
```


### *c)* 

![ex_3_1c!](ex_3_1c.png "AnImage")


## ​Problema 3.2

### *a)*

```
... Write here your answer ...
```


### *b)* 

```
... Write here your answer ...
```


### *c)* 

![ex_3_2c!](ex_3_2c.png "AnImage")


## ​Problema 3.3


### *a)* 2.1

![ex_3_3_a!](ex_3_3a.png "AnImage")

### *b)* 2.2

![ex_3_3_b!](ex_3_3b.png "AnImage")

### *c)* 2.3

![ex_3_3_c!](ex_3_3c.png "AnImage")

### *d)* 2.4

![ex_3_3_d!](ex_3_3d.png "AnImage")