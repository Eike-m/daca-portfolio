/* Minu esimesed SQL päringud */



-- anna müügitabelist 5 esimest rida 
select * from sales limit 5

select invoice_id, /* sale_date, customer_id, */ total_price, store_location
from sales  -- millisest tabelist
limit 10    -- piira vastuste ridade arvu

-- Anna 10 rida Pärnu müüke, kus summa on 500 või rohkem 
-- Järjesta tulemused summa alusel
select *
from sales
where store_location = 'Pärnu' or total_price >= 500 
order by total_price DESC  --Vaikimisi kasvavalt (ASC), kahanevalt (DESC)
LIMIT 10

-- Anna 10 esimest Tartu müüki, kus summa on mitte suurem kui 200
select *
from sales
where store_location = 'Tartu' and total_price <= 200 
LIMIT 10

-- Sorteerime mitme tunnuse järgi
select invoice_id, total_price, channel, store_location, payment_method
from sales
order by total_price desc, payment_method
limit 50

--Anna sales tabeli ridade arv 
select count (*)
from sales

--Mitmes linnas meil poed on
select distinct store_location
from sales
where store_location IS not null
order by store_location
limit 10

select count (store_location)
from sales

select count (distinct store_location) AS "Linnade arv"
from sales

-- Arvete koguarv, unikaalsete arvete arv
select
count(*) AS Ridade_Arv,
count(distinct invoice_id) AS Unikaalseid,
count(*) - count(distinct invoice_id) AS duplikaate
from sales

