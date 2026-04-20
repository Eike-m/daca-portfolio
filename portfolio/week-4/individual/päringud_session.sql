--SQL Agressioonid 20.04.2026

select count(*) from sales limit 5;
--10118 rida
select sale_date, total_price from sales; --10118 rida

-- 1. Muudame kõik kuupäevad tekstina õigesse järjekorda (YYYY-MM-DD) AI ABIL
    UPDATE sales 
    SET sale_date = SUBSTRING(sale_date, 7, 4) || '-' || SUBSTRING(sale_date, 4, 2) || '-' || SUBSTRING(sale_date, 1, 2)
    WHERE sale_date LIKE '__/__/____';
-- 2. Muudame tulba tüübi tekstist kuupäevaks AI ABIL
    ALTER TABLE sales ALTER COLUMN sale_date TYPE DATE USING sale_date::DATE;

select
  date_trunc('month', sale_date) AS Kuu,
  sum(total_price) AS Käive
from sales
where sale_date >='2024-01-01'
group by date_trunc('month', sale_date)
   having sum(total_price)>= 150000
order by Käive desc


select count(*) from products
select * from products limit 1;

select category, count(*) AS artiklid
from products
group by category

--anna kliendi nimi ja tema kogukäive

select c.first_name, last_name, sum(total_price) AS Kliendikäive
from customers c
join sales s ON c.customer_id = s.customer_id
group by c.customer_id, c.first_name, c.last_name

--linnade kaupa
select city, count(*) AS arv   
from sales s   
join customers c on c.customer_id = s.customer_id
where sale_date >= '2024-01-01'
group by city

--tahan linnu kus on üle 200 tehingu
having count(*) > 200 --6 rida
order by Arv desc

--teeme 2 näidet alampäringule
--anna periood (YYYY.MM), kuu käive ja eelmise kuu käive

select Periood, käive,
  lag(käive) over (order by periood) AS eelminekuu        --eelmine väärtus üle mille
from
  ( select                                               --sisemine päring kuni 57 rida
     date_trunc('month', sale_date) AS Periood,
     sum(total_price) AS Käive
     from sales
     group by date_trunc('month', sale_date)
  ) AS Kuu_myyk
order by periood
--33 rida (Silveri 26)

--sama päring CTE süntaksiga (Common Table expressions)

WITH 
   Kuu_Myyk AS (select...),
   teinealampäring (select...),
   kolmasalampäing (select...)
select .... from 

with
   Kuu_Myyk AS (
     select                                               
       --date_trunc('month', sale_date) AS Periood,
       to_char(sale_date, 'YYYY.MM') AS Periood,
       sum(total_price) AS Käive
     from sales
     group by to_char(sale_date, 'YYYY.MM') --teisendab tekstiks
       
      --date_trunc('month', sale_date)
   )
select
    Periood,
    Käive,
    Lag(Käive) OVER (order by Periood) AS Eelminekuu
from Kuu_Myyk
order by periood
--33 rida (Silveri 26)
--kui alampäringute arv läheb liiga suureks, mõistlik kasutada CTE  

--AVG - aritmeetiline keskmine
--proovi ka seda, et round-i ette negatiivne arv


