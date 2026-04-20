--Tabelite ühendamine

--Anna iga müügitehingu juurde ka kliendi nimi, 10 rida
--Mis veerud tabelites on?
select * from sales_test limit 10
select * from customers_test limit 1

select sale_id, invoice_id, sale_date, product_id, total_price, first_name, last_name, email
from sales_test s --võtab müügitabelist, ei pea panema sales AS s
inner join customers_test c on s.customer_id = c.customer_id --võtab klienditabelist ja võrdleb mõlema tabeli customer_id-d, pole tähtsust kumba pidi võrdled
limit 10

--9624 rida müügitehingutest --customer id puudu
select * from sales_test limit 100 -- siin tuleb ilma limitita 10118
select * from customers_test order by customer_id limit 10;
/*
--struktuur
select väljade loetelu
from tabel1 t1
join tabel2 t2 ON t1 pk =t2 fk  - sidumistingimus
where total_price > 1000        - filtreerimistingimus
group by t1.customer_id         - grupeerimistingimus
having sum(total_price > 10000) - gruppide filtreerimistingimus
*/

select count(*) from sales_test limit 1 --10118
select count(*)from customers_test limit 1 --3150

SELECT COUNT(*)
FROM sales_test s
INNER JOIN customers_test c
  ON s.customer_id = c.customer_id;

  --test tabel 9130
  --sales tabel kui andmed puhastamata 13747

  --Leia kõik kliendid kes on ostnud, ka need kes pole ostnud
SELECT
    c.first_name, c.last_name, c.city,
    s.sale_id, s.total_price
FROM customers c
inner JOIN sales s ON c.customer_id = s.customer_id -- kliendi tabelis olemas ja ostnud
ORDER BY s.total_price DESC NULLS LAST -- 0 kõige lõppu
LIMIT 20;

SELECT
    c.first_name, c.last_name, c.city,
    s.sale_id, s.total_price
FROM customers c left JOIN sales s ON c.customer_id = s.customer_id
--from sales.s c right join customers
--left JOIN sales s ON c.customer_id = s.customer_id -- kliendi tabelis olemas ja ei ole ostnud

ORDER BY s.total_price DESC NULLS LAST -- 0 kõige lõppu
LIMIT 20;

--Left join, anna ainult need kliendid kes pole ostnud
SELECT
    c.first_name, c.last_name, c.city,
    s.sale_id, s.total_price
FROM customers c
left JOIN sales s ON c.customer_id = s.customer_id 
where s.sale_id IS NULL
ORDER BY s.total_price DESC NULLS LAST -- 0 kõige lõppu
LIMIT 20;

--mitu klienti on andmebaasis, kes pole midagi ostnud - Silveril 425, minul 592
select count(*) 
from sales_test s
right join customers_test c ON s.customer_id = c.customer_id
where s.sale_id is null

SELECT Count(*)
FROM sales s
RIGHT JOIN customers c ON s.customer_id = c.customer_id  
WHERE s.sale_id IS NULL;

-- Mitu klienti on andmebaasis niisuguseid, kes ei ole midagi ostnud 
SELECT Count(*)
FROM sales s
RIGHT JOIN customers c ON s.customer_id = c.customer_id  
WHERE s.sale_id IS NULL;

--top20
SELECT
    c.first_name || ' ' || c.last_name AS klient,
    c.city,
    COUNT(s.sale_id) AS ostude_arv,
    SUM(s.total_price) AS kogumuuk
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
ORDER BY kogumuuk DESC
LIMIT 20;

--3 tabelit kokku pandud
SELECT
    c.first_name || ' ' || c.last_name AS klient, --paneb ühte veergu
    c.city,
    p.product_name,
    p.category,
    s.quantity,
    s.total_price
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id --sales ja customers on seotud 1.tabelina
INNER JOIN products p ON s.product_id = p.product_id -- seob eelmise joini ühisosaga ja product tabeli
ORDER BY s.total_price DESC
LIMIT 20;

https://sql-joins.leopard.in.ua/

--müügid linnade kaupa koondvaade - peaks olema 12 rida
SELECT
    c.city AS linn,
    COUNT(DISTINCT c.customer_id) AS kliente,
    COUNT(s.sale_id) AS oste,
    SUM(s.total_price) AS kogumuuk
FROM sales_test s
INNER JOIN customers_test c ON s.customer_id = c.customer_id
GROUP BY c.city
ORDER BY kogumuuk DESC;

--kas need tulevad kaasa kellel on sales_id puudu

select sum(oste) 
from (
  SELECT
    c.city AS linn,
    COUNT(DISTINCT c.customer_id) AS kliente,
    COUNT(s.sale_id) AS oste,
    SUM(s.total_price) AS kogumuuk
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.city
ORDER BY kogumuuk DESC
) AS vahetabel

--silveri vastus 9624 - kas tulid kaasa need read kellel oli customer id puudu - ei tulnud kaasa!
--silveri päring
SELECT Sum(oste)
FROM (
    SELECT
        c.city AS linn,
        COUNT(DISTINCT c.customer_id) AS kliente,
        COUNT(s.sale_id) AS oste,
        SUM(s.total_price) AS kogumuuk
    FROM sales_test s
    INNER JOIN customers_test c ON s.customer_id = c.customer_id
    GROUP BY c.city
    ORDER BY kogumuuk DESC
) AS VaheTabel

--select count (*) from sales where
select * from sales limit 10
