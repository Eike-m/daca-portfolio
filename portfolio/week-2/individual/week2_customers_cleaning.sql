--Kliendiandmete puhastamine

--Kustata eelnev customers_test tabel
DROP TABLE customers_test;

--Loo test koopia
CREATE TABLE customers_test AS SELECT * FROM customers;

SELECT COUNT(*) AS ridade_arv FROM customers_test;
--3150 rida

--Leia duplikaatsed e-mailid:
SELECT email, COUNT(*) AS koopiate_arv
FROM customers_test
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;
--129 rida duplikaatseid emaile

--mitu rida on unikaalseid e-maile
SELECT COUNT(DISTINCT email) AS unikaalsed_emailid
FROM customers_test;

--palju on dupl ja unik ridu emailides
SELECT
    COUNT(*) AS kokku,
    COUNT(DISTINCT email) AS unikaalseid_emaile,
    COUNT(*) - COUNT(DISTINCT email) AS duplikaatseid
FROM customers_test;
--unik -2640
--dupl - 510

Samm 3. Leia puuduvad nimed:
SELECT
    COUNT(*) FILTER (WHERE first_name IS NULL OR first_name = '') AS null_eesnimi,
    COUNT(*) FILTER (WHERE last_name IS NULL OR last_name = '') AS null_perenimi
FROM customers_test;
--eesnimi 0
--perenimi 0

Samm 4. Kontrolli linnade nimekujusid — kas on ebajärjekindlusi?
SELECT city, COUNT(*) AS arv
FROM customers_test
GROUP BY city
ORDER BY city;
--54 rida

Samm 5. Kontrolli kontaktandmeid — puuduvad telefoninumbrid ja e-mailid:
SELECT
    COUNT(*) FILTER (WHERE phone IS NULL OR phone = '') AS null_telefon,
    COUNT(*) FILTER (WHERE email IS NULL OR email = '') AS null_email
FROM customers_test;
--null telef 0
--null email 380

--puhastamise raport

--puhastamine
-- Asenda NULL nimed
UPDATE customers_test
SET first_name = 'Tundmatu'
WHERE first_name IS NULL OR first_name = '';

-- Asendan NULL e-maili aadressid
UPDATE customers_test
SET email = 'puudub'
WHERE email IS NULL OR email = '';

-- Ühtlusta linnanimed INITCAP + TRIM abil
UPDATE customers_test
SET city = INITCAP(TRIM(city))
WHERE city != INITCAP(TRIM(city));

-- Standardiseeri e-mailid väiketähtedeks
UPDATE customers_test
SET email = LOWER(TRIM(email))
WHERE email != LOWER(TRIM(email));


-- Kontrolli tulemust --12 rida
SELECT city, COUNT(*) AS arv
FROM customers_test
GROUP BY city ORDER BY city;

Lisa CASE WHEN formaadistandardiseerimiseks:
-- Näide: standardiseeri telefoninumbrid
SELECT phone,
    CASE
        WHEN phone LIKE '+372%' THEN phone
        WHEN phone LIKE '372%' THEN '+' || phone
        WHEN LENGTH(phone) = 7 THEN '+372' || phone
        ELSE phone
    END AS standardne_telefon
FROM customers_test
WHERE phone IS NOT NULL
LIMIT 10;

--mitu rida on unik telef ja dupl.telefone
SELECT
    COUNT(*) AS kokku,
    COUNT(DISTINCT phone) AS unikaalseid_phone,
    COUNT(*) - COUNT(DISTINCT phone) AS duplikaatseid
FROM customers_test;

-- Lisan tabelisse rea indikaatori
ALTER TABLE customers_test
ADD COLUMN id SERIAL;

-- Kustutan tabelist duplikaatread.
DELETE 
--Select * 
FROM customers_test
WHERE id IN (
    SELECT id
    FROM (
        SELECT id ,
               ROW_NUMBER() OVER (
                   PARTITION BY first_name, last_name, email, phone
                   ORDER BY id
               ) AS rn
        FROM customers_test
    ) duplikaadid
    WHERE rn > 1 -- kustutamisele minevad read
);

--kontroll
--Kontroll
Siin on konkreetsed SQL päringud ja meetodid kontrollimiseks:
1. Üldine ridade arvu kontroll
Kõigepealt veendu, et sa ei ole puhastamise käigus kogemata ridu kustutanud (kuna sa kasutasid UPDATE, mitte DELETE, peab ridade arv klappima)
.
SELECT 
    (SELECT COUNT(*) FROM customers) AS algne_arv,
    (SELECT COUNT(*) FROM customers_test) AS puhastatud_arv;
--algne 3150, puhastatud 3150

2. NULL nimede asendamise kontroll
Sa asendasid tühjad nimed väärtusega 'Tundmatu'. Kontrolli, kas algses tabelis on neid alles ja kas test-tabelis on need asendatud
.
SELECT 
    'Algne tabel' AS tabel, COUNT(*) AS tühjad_nimed 
FROM customers WHERE first_name IS NULL OR first_name = ''
UNION ALL
SELECT 
    'Test tabel', COUNT(*) 
FROM customers_test WHERE first_name = 'Tundmatu';
--algne 0, puhastatud tabel 0

3. Linnanimede ühtlustamise kontroll
Linnanimede puhul on kõige parem näha vahet unikaalsete kirjete arvus. Kui puhastus töötas, peaks "tallinn", "Tallinn" ja " Tallinn " olema nüüd üheks koondunud
.
SELECT 
    (SELECT COUNT(DISTINCT city) FROM customers) AS unikaalseid_linnu_algselt,
    (SELECT COUNT(DISTINCT city) FROM customers_test) AS unikaalseid_linnu_testis;
--algselt 54, peale puhastamist 12

Vihje: Kui "puhastatud" arv on väiksem, siis ühtlustamine õnnestus
.
4. E-mailide väiketähtede kontroll
Saad kontrollida, kas test-tabelisse jäi veel mõni e-mail, mis sisaldab suuri tähti
.
SELECT email 
FROM customers_test 
WHERE email != LOWER(email) 
LIMIT 10;
Oodatav tulemus on 0 rida, mis tähendab, et kõik on korrektselt väiketähtedeks muudetud

SELECT phone, COUNT(*) AS mitu_korda
FROM customers_test
GROUP BY phone
HAVING COUNT(*) > 1
ORDER BY mitu_korda DESC;

--mitu rida on unik telef ja dupl.telefone
SELECT
    COUNT(*) AS kokku,
    COUNT(DISTINCT phone) AS unikaalseid_phone,
    COUNT(*) - COUNT(DISTINCT phone) AS duplikaatseid
FROM customers_test;

SELECT phone, COUNT(*) AS kordusi
FROM customers_test
GROUP BY phone
HAVING COUNT(*) > 1
ORDER BY kordusi DESC;

SELECT
  COUNT(*) - COUNT(DISTINCT phone) AS duplikaadi_ridu
FROM customers_test;
--150

--puhastus
DELETE FROM customers_test
WHERE id NOT IN (
    SELECT MIN(id)
    FROM customers_test
    GROUP BY phone
);

--kontroll
SELECT
  COUNT(*) - COUNT(DISTINCT phone) AS duplikaate
FROM customers_test;

-- 0 duplikaati

--ridade võrdlus peale puhastust
SELECT
  'ENNE (customers)' AS staatus,
  COUNT(*) AS ridade_arv
FROM customers

UNION ALL

SELECT
  'PÄRAST (customers_test)' AS staatus,
  COUNT(*) AS ridade_arv
FROM customers_test;
--enne 3150
--peale 3000

--võrdlus enne ja pärast puhastamist
SELECT
  'ENNE (customers)' AS staatus,

  COUNT(*) AS kokku_ridu,

  -- EMAIL
  COUNT(DISTINCT email) AS unikaalsed_emailid,
  COUNT(*) - COUNT(DISTINCT email) AS emaili_duplikaadi_ridu,

  -- PHONE
  COUNT(DISTINCT phone) AS unikaalsed_phone,
  COUNT(*) - COUNT(DISTINCT phone) AS phonei_duplikaadi_ridu,

  -- CITY (AINULT UNIKAALSED, ilma duplikaatideta)
  COUNT(DISTINCT city) AS unikaalsed_linnad

FROM customers

UNION ALL

SELECT
  'PÄRAST (customers_test)' AS staatus,

  COUNT(*) AS kokku_ridu,

  -- EMAIL
  COUNT(DISTINCT email),
  COUNT(*) - COUNT(DISTINCT email),

  -- PHONE
  COUNT(DISTINCT phone),
  COUNT(*) - COUNT(DISTINCT phone),

  -- CITY (AINULT UNIKAALSED)
  COUNT(DISTINCT city)

FROM customers_test;