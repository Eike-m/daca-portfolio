--ALAÜLESANDE KAART D — Müügikanalid + Kliendid (INNER JOIN + mitme tabeli JOIN)
Ülesanne: Mitme tabeli JOIN: millised müügikanalid toovad enim müüke ja
millised kliendid kasutavad milliseid kanaleid? Koosta müügikanalite analüüs Annale.

--1. Uuri müügikanaleid `sales` tabelis:
-- Vaata, millised müügikanalid on olemas   
 SELECT DISTINCT channel FROM sales ORDER BY channel;   
 -- Märgi üles: mitu erinevat kanalit on? --Online, pood 

 -- Kanalite põhiülevaade:
 -- Milline kanal toob enim müüke?    
 SELECT 
 s.channel AS müügikanal,        
 COUNT(DISTINCT s.customer_id) AS kliente,      
 COUNT(s.sale_id) AS oste,       
 SUM(s.total_price) AS kogumüük   
 FROM sales s    
 GROUP BY s.channel   
 ORDER BY kogumüük DESC;   
--pood, 2278 kliente, oste 6656, kogumüük 1 902 430,30

--Ühenda `sales` ja `customers` — klientide profiil kanali kaupa:
-- Millistest linnadest kliendid milliseid kanaleid kasutavad?   
SELECT       
s.channel AS müügikanal,     
c.city AS linn,       
COUNT(DISTINCT c.customer_id) AS kliente,      
SUM(s.total_price) AS kogumüük    
FROM sales s    
INNER JOIN customers c ON s.customer_id = c.customer_id    
GROUP BY s.channel, c.city   
ORDER BY müügikanal, kogumüük DESC;    
--sain 24 rida erinevaid

-- Millistest linnadest kliendid milliseid kanaleid kasutavad?   
--grupeerin ja sorteerin linna järgi:
SELECT 
    c.city AS linn, 
    s.channel AS müügikanal, 
    COUNT(DISTINCT c.customer_id) AS unikaalseid_kliente, 
    SUM(s.total_price) AS kogumüük
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.city, s.channel
ORDER BY c.city, unikaalseid_kliente DESC;

--mitmest erinevast linnast ostetakse online vs pood
SELECT 
    s.channel AS müügikanal, 
    COUNT(DISTINCT c.city) AS erinevate_linnade_arv
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY s.channel;
--online - 12 erinevat linna
--pood - 12 erinevat linna

--mitu klienti igas linnas kanali lõikes
SELECT 
    s.channel AS müügikanal, 
    c.city AS linn,
    COUNT(DISTINCT s.customer_id) AS klientide_arv
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY s.channel, c.city
ORDER BY s.channel, klientide_arv DESC;

--top 3 iga kanali sees
SELECT *
FROM (
    SELECT 
        s.channel AS müügikanal, 
        c.city AS linn,
        COUNT(DISTINCT s.customer_id) AS klientide_arv,
        ROW_NUMBER() OVER (
            PARTITION BY s.channel 
            ORDER BY COUNT(DISTINCT s.customer_id) DESC
        ) AS rn
    FROM sales s
    INNER JOIN customers c ON s.customer_id = c.customer_id
    GROUP BY s.channel, c.city
) t
WHERE rn <= 3;

--Ühenda 3 tabelit: `sales` + `customers` + `products`:
-- 3 tabeli JOIN: millised tooted müüvad millises kanalis?  
SELECT     
   s.channel AS müügikanal,      
   p.category AS tootekategooria,     
   COUNT(DISTINCT c.customer_id) AS kliente,   
   COUNT(s.sale_id) AS oste,    
   SUM(s.total_price) AS kogumüük,   
   ROUND(AVG(s.total_price), 2) AS keskmine_ost  
   FROM sales s   
   INNER JOIN customers c ON s.customer_id = c.customer_id 
   INNER JOIN products p ON s.product_id = p.product_id  
   GROUP BY s.channel, p.category  
   ORDER BY müügikanal, kogumüük DESC;    
--online - müüvad jalanõud
--poes - müüvad meeste riided

--millised tooted müüvad mis kanalis
SELECT 
    s.channel AS müügikanal,
    p.product_name AS toode,
    COUNT(*) AS ostude_arv,
    SUM(s.total_price) AS kogumüük
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY s.channel, p.product_name
ORDER BY s.channel, kogumüük DESC;
--online - Õhuline sünteetiline sporditossud


--iga kanali top tooted
SELECT *
FROM (
    SELECT 
        s.channel,
        p.product_name,
        SUM(s.total_price) AS kogumüük,
        RANK() OVER (PARTITION BY s.channel ORDER BY SUM(s.total_price) DESC) AS rnk
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    GROUP BY s.channel, p.product_name
) t
WHERE rnk <= 3;

--milline kanal toob enim müüke
SELECT 
    s.channel,
    COUNT(s.sale_id) AS ostude_arv,
    SUM(s.total_price) AS kogumyyk
FROM sales s
GROUP BY s.channel
ORDER BY kogumyyk DESC;

--osakaal kanali sees
SELECT 
    s.channel,
    p.product_name,
    SUM(s.total_price) AS müük,
    ROUND(
        SUM(s.total_price) * 100.0 / 
        SUM(SUM(s.total_price)) OVER (PARTITION BY s.channel),
        2
    ) AS protsent_kanalist
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY s.channel, p.product_name
ORDER BY s.channel, protsent_kanalist DESC;

--kõige suurema protsendiga on õhuline sünteetiline sporditossud 1,38% online kanali müügist

--tooted mis müüvad hästi ainult ühes  kanalis
SELECT 
    p.product_name,
    COUNT(DISTINCT s.channel) AS kanalite_arv,
    SUM(s.total_price) AS kogumyyk
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
HAVING COUNT(DISTINCT s.channel) = 1
ORDER BY kogumyyk DESC;

--kõige suurema käibega toode
SELECT 
    p.product_name,
    SUM(s.total_price) AS kogumyyk
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY kogumyyk DESC
LIMIT 1;

--top tooded igas kanalis ja toote kategooria
SELECT *
FROM (
    SELECT 
        s.channel AS kanal,
        p.category AS kategooria,
        p.product_name AS toode,
        SUM(s.total_price) AS kogumyyk,
        ROW_NUMBER() OVER (
            PARTITION BY s.channel 
            ORDER BY SUM(s.total_price) DESC
        ) AS rnk
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    GROUP BY 
        s.channel,
        p.category,
        p.product_name
) t
WHERE rnk = 1
ORDER BY kogumyyk DESC;
--pood-naiste riided-Praktiline džersii seelik 17 248.68
--online - jalanõud- Õhuline sünteetiline sporditossud 13 890.56

SELECT 
    p.product_name,
    s.channel,
    SUM(s.total_price) AS kogumyyk
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name, s.channel
ORDER BY kogumyyk DESC
LIMIT 1;

--pood praktiline džersii seelik, 17248,68

--online paremini müünud toode
SELECT 
    p.product_name,
    SUM(s.total_price) AS kogumyyk
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE s.channel = 'online'
GROUP BY p.product_name
ORDER BY kogumyyk DESC
LIMIT 1;
--õhuline sünteetiline sporditossud 13890,56

--Leia kõige efektiivsem kanal (müük per klient):
 SELECT 
    s.channel AS müügikanal,
    COUNT(DISTINCT s.customer_id) AS kliente,  
    SUM(s.total_price) AS kogumüük, 
    ROUND(SUM(s.total_price) / COUNT(DISTINCT s.customer_id), 2) AS müük_per_klient  
    FROM sales s 
    GROUP BY s.channel  
    ORDER BY müük_per_klient DESC;   

--milline klient on kõige rohkem ostnud
SELECT *
FROM (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS klient,
        p.product_name AS toode,
        COUNT(s.sale_id) AS ostude_arv,
        SUM(s.total_price) AS kogumüük,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_id 
            ORDER BY COUNT(s.sale_id) DESC
        ) AS rnk
    FROM sales s
    JOIN customers c ON s.customer_id = c.customer_id
    JOIN products p ON s.product_id = p.product_id
    GROUP BY 
        c.customer_id,
        c.first_name,
        c.last_name,
        p.product_name
) t
WHERE rnk = 1
ORDER BY kogumüük DESC;

--klient kes on teinud kõige rohkem oste
SELECT 
    c.customer_id,
    COUNT(s.sale_id) AS ostude_arv,
    SUM(s.total_price) AS kogumüük
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY ostude_arv DESC
LIMIT 1;
--customer id 2997, 78 ostu, kogu summas 23 467.13
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS klient,
    COUNT(s.sale_id) AS ostude_arv,
    SUM(s.total_price) AS kogumüük
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY 
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY ostude_arv DESC
LIMIT 1;
--customer id 2997, Kevin Org, 78 ostu, 23 467,13 kogusummas

--top toode suurimal kliendil ja ostukanal -- --top toode õhuline goretex tennised, 1750.95, online pood
SELECT *
FROM (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS klient,
        p.product_name AS toode,
        s.channel AS kanal,
        s.total_price AS hind,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_id 
            ORDER BY s.total_price DESC
        ) AS rnk
    FROM sales s
    JOIN customers c ON s.customer_id = c.customer_id
    JOIN products p ON s.product_id = p.product_id
) t
WHERE rnk = 1
AND customer_id = (
    SELECT c.customer_id
    FROM sales s
    JOIN customers c ON s.customer_id = c.customer_id
    GROUP BY c.customer_id
    ORDER BY COUNT(s.sale_id) DESC
    LIMIT 1
);

 Kirjuta müügikanalite analüüs Annale (3-5 lauset): milline kanal toob enim müüke? Milline kanal toob enim kliente? Milline on kõige efektiivsem (müük per klient)? Mis on erinevus linnade vahel? Konkreetne soovitus.


--Edasijõudnute tables
--Lisa kaupluste võrdlus: leia iga kaupluse müügikanalite jaotus:
SELECT       s.store_location AS kauplus,       s.channel AS müügikanal,       COUNT(s.sale_id) AS oste,       SUM(s.total_price) AS kogumüük,       ROUND(SUM(s.total_price) / COUNT(s.sale_id), 2) AS keskmine_ost   FROM sales s   GROUP BY s.store_location, s.channel   ORDER BY kauplus, kogumüük DESC;   
--vastuses tuleb ka kauplus NULL- online- oste 3462 --see võib viidata sellele et store location on tabelis tühi, veebimüükidel ei ole asukohta füüsilist

--Järeldus
--Kas Tallin, Tartu ja Pärnu kasutavad kanaleid erinevalt?
Jah, kasutavad
Tallinn: 3801 oste (37,6% mahust) selge lipulaev
Tartu: 1797 oste (17,8% mahust) stabiilne ja tugev turg
Pärnu: 1058 oste (10,5% mahust) väikseim füüsiline pood
Online (NULL asukoht): 3462 oste (34,2% mahust) suuruselt teine "asukoht" pärast Tallinnat  

--Kas mõni kauplus peaks rohkem online-müügile panustama?
Online-kanal on tehingute arvult peaaegu sama suur kui Tallinna pood. 
34,2% tehingute maht näitab, et veebist ostetakse tõenäoliselt keskmisest kallimaid tooteid või on seal suur kasvupotentsiaal

--Kuhu peaks Anna turunduseelarvet suunama?
Anna Mets peaks suunama eelarvet just online-kanali ja Pärnu piirkonna digireklaami, kuna Pärnu füüsiline pood on mahult kõige väiksem (10,5%)
ja sealsed kliendid võiksid mugavamalt liikuda e-poodi.

