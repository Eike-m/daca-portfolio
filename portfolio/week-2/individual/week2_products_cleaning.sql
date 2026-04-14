--Tooteandmete puhastamine

--Kustata eelnev products_test tabel
DROP TABLE products_test;

--Samm 1: test koopia loomine
CREATE TABLE products_test AS SELECT * FROM products;

--Mitu rida on tabelis? -- 362
SELECT COUNT(*) AS ridade_arv FROM products_test;

Samm 2. Leia duplikaadid — kas on korduvaid tootenimesid? --12 duplikaatset tootenime
SELECT product_name, COUNT(*) AS koopiate_arv
FROM products_test
GROUP BY product_name
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

Samm 3. Leia NULL väärtused kriitilistes väljades:
SELECT
    COUNT(*) FILTER (WHERE product_name IS NULL OR product_name = '') AS null_nimi,
    COUNT(*) FILTER (WHERE category IS NULL OR category = '') AS null_kategooria,
    COUNT(*) FILTER (WHERE cost_price IS NULL) AS null_hind,
    COUNT(*) FILTER (WHERE supplier IS NULL OR supplier = '') AS null_supplier,
    COUNT(*) FILTER (WHERE subcategory IS NULL OR subcategory = '') AS null_subcategory
FROM products_test;

--0 väärtused puuduvad

--mis veerud on
SELECT *
FROM products_test
LIMIT 5;


-- Kontrolli loogilisi vigu — kas on ebareaalseid hindu?
-- Kas on negatiivseid hindu?
SELECT COUNT(*) AS negatiivne_hind
FROM products_test
WHERE cost_price < 0;
--0 neg hinda

-- Kas on äärmuslikke hindu (> 1000€)?
SELECT product_name, cost_price
FROM products_test
WHERE cost_price > 1000
ORDER BY cost_price DESC;
--0 äärmuslikku hinda

--Kontrolli kategooriate järjekindlust:
SELECT category, COUNT(*) AS arv
FROM products_test
GROUP BY category
ORDER BY category;

--5 erinevat kategooriat

--Puhastamisraport
--Samm 6. Koosta  puhastamisraport
Kategooria	          Leitud probleeme	Kirjeldus
Duplikaadid	           12               Sama tootenimi mitu korda
NULL nimi/hind          0	            Puuduvad kriitilised väljad
Loogilised vead         0               Negatiivne või äärmuslik hind
Ebajärjekindlad kateg.  0	            Erinevad nimekujud (Shoes vs shoes)
NULL bränd/kat.     	0	            Puuduv klassifitseerimine
KOKKU probleeme	        12


--Puhastamine
-- Ühtlusta kategooriate nimed
UPDATE products_test
SET category = INITCAP(TRIM(category))
WHERE category != INITCAP(TRIM(category));

-- Kontrolli tulemust
SELECT category, COUNT(*) AS arv
FROM products_test
GROUP BY category ORDER BY category;

--Lisa CASE WHEN kategooriate standardiseerimiseks:
UPDATE products_test
SET category = CASE
    WHEN LOWER(TRIM(category)) IN ('shoes', 'jalanõud', 'footwear') THEN 'Shoes'
    WHEN LOWER(TRIM(category)) IN ('shirts', 'särgid', 'tops') THEN 'Shirts'
    WHEN LOWER(TRIM(category)) IN ('pants', 'püksid', 'trousers') THEN 'Pants'
    ELSE INITCAP(TRIM(category))
END;

--eemalda duplikaadid

SELECT product_name, COUNT(*) FROM products_test GROUP BY product_name HAVING COUNT(*) > 1;

kontroll
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY product_name
               ORDER BY product_id
           ) AS rn
    FROM products_test
) t
WHERE rn > 1;

--duplikaatide kustutamine
DELETE FROM products_test
WHERE product_id IN (
    SELECT product_id
    FROM (
        SELECT product_id,
               ROW_NUMBER() OVER (
                   PARTITION BY product_name
                   ORDER BY product_id
               ) AS rn
        FROM products_test
    ) t
    WHERE rn > 1
);

kontroll - 0
SELECT product_name, COUNT(*) AS arv
FROM products_test
GROUP BY product_name
HAVING COUNT(*) > 1;

--unikaalsed tootenimed--350
SELECT COUNT(DISTINCT product_name) AS unikaalsed_tooted
FROM products_test;

--Kontroll - peale puhastamist 350
SELECT
    'products_test' AS tabel,
    COUNT(*) AS read
FROM products_test;

--võrdlus enne ja pärast
SELECT 'originaal' AS tabel, COUNT(*) AS ridasid FROM products  --362
UNION ALL
SELECT 'test', COUNT(*) FROM products_test
UNION ALL
SELECT 'puhastatud', COUNT(*) FROM products_test;  --350 peale eemaldamist


--unikaalsed tooted
SELECT
    'enne' AS staatus,
    COUNT(DISTINCT product_name) AS unikaalsed_tooted
FROM products

UNION ALL

SELECT
    'parast',
    COUNT(DISTINCT product_name)
FROM products_test;