-- print tabelle
select * from cliente
select * from conto
select * from tipo_conto
select * from tipo_transazione
select * from transazioni

-- 1 Età
create temporary table task_1 as
select id_cliente,
	date_format(from_days(datediff(now() , data_nascita)), '%Y') + 0 as eta
from cliente

-- 2 Numero di transazioni in uscita su tutti i conti
create temporary table task_2 as
select
	cont.id_cliente,
	count(trans.id_conto) as numero_transazioni_uscita
from
banca.conto cont
inner join banca.transazioni trans
on cont.id_conto = trans.id_conto
where id_tipo_trans not in (0, 1, 2)
group by 1

-- 3 Numero di transazioni in entrata su tutti i conti
create temporary table task_3 as
select
	cont.id_cliente,
	count(trans.id_conto) as numero_transazioni_entrata
from
banca.conto cont
inner join banca.transazioni trans
on cont.id_conto = trans.id_conto
where id_tipo_trans in (0, 1, 2)
group by 1

-- 4 Importo transato in uscita su tutti i conti
create temporary table task_4 as
select
    cont.id_cliente,
	sum(trans.importo) as somma_importo_uscite
from
banca.conto cont
inner join banca.transazioni trans
on cont.id_conto = trans.id_conto
where trans.id_tipo_trans not in (0, 1, 2)
group by 1

-- 5 Importo transato in entrata su tutti i conti
create temporary table task_5 as
select
	cont.id_cliente,
	sum(trans.importo) as somma_importo_entrate
from
banca.conto cont
inner join banca.transazioni trans
on cont.id_conto = trans.id_conto
where trans.id_tipo_trans in (0, 1, 2)
group by 1

-- 6 Numero totale di conti posseduti
create temporary table task_6 as
select
	cont.id_cliente,
    count(cont.id_cliente) as numero_conti
from
banca.conto cont
group by 1

-- 7 Numero di conti posseduti per tipologia (un indicatore per tipo)
create temporary table task_7 as
select
	id_cliente,
    count(case when id_tipo_conto = 0 then 1 end) as conto_base,
    count(case when id_tipo_conto = 1 then 1 end) as conto_business,
    count(case when id_tipo_conto = 2 then 1 end) as conto_privati,
    count(case when id_tipo_conto = 3 then 1 end) as conto_famiglie
from
banca.conto
group by 1

-- 8 Numero di transazioni in uscita per tipologia (un indicatore per tipo)
create temporary table task_8 as
select
    cont.id_cliente,
	count(case when trans.id_tipo_trans = 3 then 1 end) as acuisto_su_amazon_numero_transazioni_uscite,
    count(case when trans.id_tipo_trans = 4 then 1 end) as rata_mutuo_numero_transazioni_uscite,
    count(case when trans.id_tipo_trans = 5 then 1 end) as hotel_numero_transazioni_uscite,
    count(case when trans.id_tipo_trans = 6 then 1 end) as biglietto_aereo_numero_transazioni_uscite,
    count(case when trans.id_tipo_trans = 7 then 1 end) as supermercato_numero_transazioni_uscite
from
banca.conto cont
inner join banca.transazioni trans
on cont.id_conto = trans.id_conto
where trans.id_tipo_trans not in (0, 1, 2)
group by 1

-- 9 Numero di transazioni in entrata per tipologia (un indicatore per tipo)
create temporary table task_9 as
select
    cont.id_cliente,
	count(case when trans.id_tipo_trans = 0 then 1 end) as stipendio_numero_transazioni_entrate,
    count(case when trans.id_tipo_trans = 1 then 1 end) as pensione_numero_transazioni_entrate,
    count(case when trans.id_tipo_trans = 2 then 1 end) as dividendi_numero_transazioni_entrate
from
banca.conto cont
inner join banca.transazioni trans
on cont.id_conto = trans.id_conto
where trans.id_tipo_trans in (0, 1, 2)
group by 1

-- 10 Importo transato in uscita per tipologia di conto (un indicatore per tipo)
create temporary table task_10 as
select
    cont.id_cliente,
	sum(if(trans.id_tipo_trans = 3,trans.importo, 0)) as acuisto_su_amazon_importo_cumulato_uscita,
    sum(if(trans.id_tipo_trans = 4,trans.importo, 0)) as rata_mutuo_importo_cumulato_uscita,
    sum(if(trans.id_tipo_trans = 5,trans.importo, 0)) as hotel_importo_cumulato_uscita,
    sum(if(trans.id_tipo_trans = 6,trans.importo, 0)) as biglietto_aereo_importo_cumulato_uscita,
    sum(if(trans.id_tipo_trans = 7,trans.importo, 0)) as supermercato_importo_cumulato_uscita
from
banca.conto cont
inner join banca.transazioni trans
on cont.id_conto = trans.id_conto
where trans.id_tipo_trans not in (0, 1, 2)
group by 1

-- 11 Importo transato in entrata per tipologia di conto (un indicatore per tipo)
create temporary table task_11 as
select
    cont.id_cliente,
	sum(if(trans.id_tipo_trans = 0,trans.importo, 0)) as stipendio_importo_cumulato_entrata,
    sum(if(trans.id_tipo_trans = 1,trans.importo, 0)) as pensione_importo_cumulato_entrata,
    sum(if(trans.id_tipo_trans = 2,trans.importo, 0)) as dividendi_importo_cumulato_entrata
from
banca.conto cont
inner join banca.transazioni trans
on cont.id_conto = trans.id_conto
where trans.id_tipo_trans in (0, 1, 2)
group by 1

-- test rows
select * from task_1
select * from task_2
select * from task_3
select * from task_4
select * from task_5
select * from task_6
select * from task_7
select * from task_8
select * from task_9
select * from task_10
select * from task_11

select * from tmp_table
select * from tmp_table2
select * from tmp_table3
select * from tmp_table4
select * from tmp_table5
select * from tmp_table6
select * from tmp_table7
select * from tmp_table8
select * from tmp_table9

-- table join
-- 1 2
create temporary table tmp_table as
select 
	t1.id_cliente,
    t1.eta,
    t2.numero_transazioni_uscita
 from banca.task_1 t1 inner join banca.task_2 t2 on t1.id_cliente = t2.id_cliente
 -- % 3
create temporary table tmp_table2 as
select 
	tmp.id_cliente,
    tmp.eta,
    tmp.numero_transazioni_uscita,
    t3.numero_transazioni_entrata
 from banca.tmp_table tmp inner join banca.task_3 t3 on tmp.id_cliente = t3.id_cliente
 -- % 4
create temporary table tmp_table3 as
select 
	tmp.id_cliente,
    tmp.eta,
    tmp.numero_transazioni_uscita,
    tmp.numero_transazioni_entrata,
    t4.somma_importo_uscite
 from banca.tmp_table2 tmp inner join banca.task_4 t4 on tmp.id_cliente = t4.id_cliente
 -- % 5
create temporary table tmp_table4 as
select 
	tmp.id_cliente,
    tmp.eta,
    tmp.numero_transazioni_uscita,
    tmp.numero_transazioni_entrata,
    tmp.somma_importo_uscite,
    t5.somma_importo_entrate
 from banca.tmp_table3 tmp inner join banca.task_5 t5 on tmp.id_cliente = t5.id_cliente
 -- % 6
create temporary table tmp_table5 as
select 
	tmp.id_cliente,
    tmp.eta,
    tmp.numero_transazioni_uscita,
    tmp.numero_transazioni_entrata,
    tmp.somma_importo_uscite,
    tmp.somma_importo_entrate,
    t6.numero_conti
 from banca.tmp_table4 tmp inner join banca.task_6 t6 on tmp.id_cliente = t6.id_cliente
 -- % 7
create temporary table tmp_table6 as
select 
	tmp.id_cliente,
    tmp.eta,
    tmp.numero_transazioni_uscita,
    tmp.numero_transazioni_entrata,
    tmp.somma_importo_uscite,
    tmp.somma_importo_entrate,
    tmp.numero_conti,
    t7.conto_base,
    t7.conto_business,
    t7.conto_privati,
    t7.conto_famiglie
 from banca.tmp_table5 tmp inner join banca.task_7 t7 on tmp.id_cliente = t7.id_cliente
 -- % 8
create temporary table tmp_table7 as
select 
	tmp.id_cliente,
    tmp.eta,
    tmp.numero_transazioni_uscita,
    tmp.numero_transazioni_entrata,
    tmp.somma_importo_uscite,
    tmp.somma_importo_entrate,
    tmp.numero_conti,
    tmp.conto_base,
    tmp.conto_business,
    tmp.conto_privati,
    tmp.conto_famiglie,
    t8.acuisto_su_amazon_numero_transazioni_uscite,
    t8.rata_mutuo_numero_transazioni_uscite,
    t8.hotel_numero_transazioni_uscite,
    t8.biglietto_aereo_numero_transazioni_uscite,
    t8.supermercato_numero_transazioni_uscite
 from banca.tmp_table6 tmp inner join banca.task_8 t8 on tmp.id_cliente = t8.id_cliente
 -- % 9
create temporary table tmp_table8 as
select 
	tmp.id_cliente,
    tmp.eta,
    tmp.numero_transazioni_uscita,
    tmp.numero_transazioni_entrata,
    tmp.somma_importo_uscite,
    tmp.somma_importo_entrate,
    tmp.numero_conti,
    tmp.conto_base,
    tmp.conto_business,
    tmp.conto_privati,
    tmp.conto_famiglie,
    tmp.acuisto_su_amazon_numero_transazioni_uscite,
    tmp.rata_mutuo_numero_transazioni_uscite,
    tmp.hotel_numero_transazioni_uscite,
    tmp.biglietto_aereo_numero_transazioni_uscite,
    tmp.supermercato_numero_transazioni_uscite,
    t9.stipendio_numero_transazioni_entrate,
    t9.pensione_numero_transazioni_entrate,
    t9.dividendi_numero_transazioni_entrate
 from banca.tmp_table7 tmp inner join banca.task_9 t9 on tmp.id_cliente = t9.id_cliente
 -- % 10
create temporary table tmp_table9 as
select 
	tmp.id_cliente,
    tmp.eta,
    tmp.numero_transazioni_uscita,
    tmp.numero_transazioni_entrata,
    tmp.somma_importo_uscite,
    tmp.somma_importo_entrate,
    tmp.numero_conti,
    tmp.conto_base,
    tmp.conto_business,
    tmp.conto_privati,
    tmp.conto_famiglie,
    tmp.acuisto_su_amazon_numero_transazioni_uscite,
    tmp.rata_mutuo_numero_transazioni_uscite,
    tmp.hotel_numero_transazioni_uscite,
    tmp.biglietto_aereo_numero_transazioni_uscite,
    tmp.supermercato_numero_transazioni_uscite,
    tmp.stipendio_numero_transazioni_entrate,
    tmp.pensione_numero_transazioni_entrate,
    tmp.dividendi_numero_transazioni_entrate,
    t10.acuisto_su_amazon_importo_cumulato_uscita,
    t10.rata_mutuo_importo_cumulato_uscita,
    t10.hotel_importo_cumulato_uscita,
    t10.biglietto_aereo_importo_cumulato_uscita,
    t10.supermercato_importo_cumulato_uscita
 from banca.tmp_table8 tmp inner join banca.task_10 t10 on tmp.id_cliente = t10.id_cliente
 -- % 11
create table output_db_bancario as
select 
	tmp.id_cliente,
    tmp.eta,
    tmp.numero_transazioni_uscita,
    tmp.numero_transazioni_entrata,
    tmp.somma_importo_uscite,
    tmp.somma_importo_entrate,
    tmp.numero_conti,
    tmp.conto_base,
    tmp.conto_business,
    tmp.conto_privati,
    tmp.conto_famiglie,
    tmp.acuisto_su_amazon_numero_transazioni_uscite,
    tmp.rata_mutuo_numero_transazioni_uscite,
    tmp.hotel_numero_transazioni_uscite,
    tmp.biglietto_aereo_numero_transazioni_uscite,
    tmp.supermercato_numero_transazioni_uscite,
    tmp.stipendio_numero_transazioni_entrate,
    tmp.pensione_numero_transazioni_entrate,
    tmp.dividendi_numero_transazioni_entrate,
    tmp.acuisto_su_amazon_importo_cumulato_uscita,
    tmp.rata_mutuo_importo_cumulato_uscita,
    tmp.hotel_importo_cumulato_uscita,
    tmp.biglietto_aereo_importo_cumulato_uscita,
    tmp.supermercato_importo_cumulato_uscita,
    t11.stipendio_importo_cumulato_entrata,
    t11.pensione_importo_cumulato_entrata,
    t11.dividendi_importo_cumulato_entrata
 from banca.tmp_table9 tmp inner join banca.task_11 t11 on tmp.id_cliente = t11.id_cliente
 
 select * from output_db_bancario
 
 
