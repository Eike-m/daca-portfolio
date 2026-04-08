--Samm 1: test koopia loomine
CREATE TABLE sales_test AS SELECT * FROM sales;

-- Kontrolli ridade arvu
SELECT COUNT(*) AS ridade_arv FROM sales_test; -- kokku 15234 rida 

--Samm 2. Leia duplikaadid:
--millised tellimused korduvad? mitu unikaalset sale_id korduvad?
--See ütleb, millised sale_id väärtused esinevad rohkem kui ühe korra.
--Näiteks sale_id = 101 võib esineda 5 korda, sale_id = 102 3 korda jne.
--See ei ütle, kui palju täpselt ridu on duplikaatsed, vaid mitu erinevat sale_id väärtust on korduvate seas.
SELECT sale_id, COUNT(*) AS koopiate_arv
FROM sales_test
GROUP BY sale_id
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

--4013 duplikaatset sale_id

--Samm 3. Loe kokku duplikaatsete ridade arv: mitu rida on üleliigset
SELECT COUNT(*) AS duplikaat_read
FROM sales_test
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales_test
    GROUP BY sale_id
);

--Duplikaatseid ridu on 5116

--Samm 4: Leia NULL väärtused kriitilistes väljades:

SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE sale_date IS NULL) AS null_sale_date,
    COUNT(*) FILTER (WHERE total_price IS NULL) AS null_total_price
FROM sales_test;

--1487 null_customer_id - puudub kliendi viide
--0 null_sale_date - kõik read veerus on täidetud, puuduvaid kuupäevi ei ole
--0 null_total_price - kõik read veerus on täidetud, puuduvad summad


--Samm 5. Kontrolli kuupäevade formaati — kas on tuleviku kuupäevi?
SELECT COUNT(*) AS tuleviku_kuupaevad
FROM sales_test
WHERE sale_date > CURRENT_DATE;
--tuli veateade
--õige päring:
--Seadista andmebaas mõistma Eesti/Euroopa kuupäevaformaati (PP/KK/AAAA)
SET datestyle TO 'ISO, DMY';

--Teisenda tekstiväli kuupäevaks (::DATE), et saaksid seda tänasega võrrelda
SELECT COUNT(*) AS tuleviku_kuupaevad
FROM sales_test
WHERE sale_date::DATE > CURRENT_DATE;

--Selgitus:
--SET datestyle TO 'ISO, DMY': 
See ütleb PostgreSQL-ile, et kui ta kohtab tekstis kaldkriipse (nt 25/01), 
siis esimene number on päev ja teine kuu.
Ilma selleta eeldaks andmebaas USA süsteemi ja annaks vea, kui päev on suurem kui 12
--sale_date::DATE: See on tüübiteisendus ehk casting. 
See muudab tekstina salvestatud kuupäeva ajutiselt päris kuupäeva tüübiks, et SQL saaks kasutada võrdlusmärke nagu >

--Kustuta duplikaadid (jäta alles ainult esimene rida iga sale_id kohta)
DELETE FROM sales_test
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales_test
    GROUP BY sale_id
);

-- Asenda NULL customer_id
UPDATE sales_test
SET customer_id = 0
WHERE customer_id IS NULL;

-- Paranda tuleviku kuupäevad
UPDATE sales_test
SET sale_date = CURRENT_DATE
WHERE sale_date > CURRENT_DATE;
--see päring annab veateate

SET datestyle TO 'ISO, DMY';
UPDATE sales_test
SET sale_date = CURRENT_DATE::TEXT
WHERE sale_date::DATE > CURRENT_DATE;

-- Kontrolli tulemust
SELECT COUNT(*) AS ridu_parast FROM sales_test;

--Ridu pärast 10118

--Päring võrdluseks:
SELECT 'Algne seis (sales)' AS staatus, COUNT(*) AS ridade_arv FROM sales
UNION ALL
SELECT 'Puhastatud seis (sales_test)', COUNT(*) FROM sales_test;

--Päring mis näitab vigade kadumist:
SELECT 
    'Enne puhastamist' AS periood,
    COUNT(*) AS ridu_kokku,
    COUNT(*) - COUNT(customer_id) AS null_kliendid,
    (SELECT COUNT(*) FROM sales WHERE sale_date > CURRENT_DATE) AS tuleviku_kp
FROM sales
UNION ALL
SELECT 
    'Pärast puhastamist',
    COUNT(*),
    COUNT(*) FILTER (WHERE customer_id = 0), -- customer_id on nüüd 0, mitte NULL
    COUNT(*) FILTER (WHERE sale_date > CURRENT_DATE)
FROM sales_test;
--tuli veateade:
Error: Failed to run sql query: ERROR: 42883: operator does not exist: text > date LINE 5: (SELECT COUNT(*) FROM sales WHERE sale_date > CURRENT_DATE) AS tuleviku_kp ^ HINT: No operator matches the given name and argument types. You might need to add explicit type casts.

-- Määrame stiili igaks juhuks uuesti, et vältida viga "25/01/2023" puhul
SET datestyle TO 'ISO, DMY'; 

SELECT 
    'Enne puhastamist' AS periood,
    COUNT(*) AS ridu_kokku,
    COUNT(*) - COUNT(customer_id) AS null_kliendid,
    (SELECT COUNT(*) FROM sales WHERE sale_date::DATE > CURRENT_DATE) AS tuleviku_kp
FROM sales
UNION ALL
SELECT 
    'Pärast puhastamist',
    COUNT(*),
    COUNT(*) FILTER (WHERE customer_id = 0), -- customer_id on nüüd 0, mitte NULL
    COUNT(*) FILTER (WHERE sale_date::DATE > CURRENT_DATE)
FROM sales_test;

SELECT 'Algne seis (sales)' AS staatus, COUNT(*) AS ridade_arv FROM sales
UNION ALL
SELECT 'Puhastatud seis (sales_test)', COUNT(*) FROM sales_test;