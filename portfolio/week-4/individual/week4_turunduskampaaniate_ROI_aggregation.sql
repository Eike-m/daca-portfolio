--ALAÜLESANDE KAART — ROLL D: Turunduskampaaniate ROI
--Turunduskanalite koondandmed. Ühenda müük, kliendid ja veebilogi kanalitega:

SELECT 
    w.source AS turunduskanal, 
    COUNT(DISTINCT c.customer_id) AS kliente, 
    COUNT(DISTINCT o.sale_id) AS tellimusi, 
    SUM(o.total_price) AS kogukäive, 
    ROUND(AVG(o.total_price), 2) AS keskmine_tellimus 
FROM sales o 
JOIN customers c ON o.customer_id = c.customer_id 
LEFT JOIN web_logs w ON c.customer_id = w.customer_id 
GROUP BY w.source 
ORDER BY kogukäive DESC;


--puhastame kirjapildi, tühikud, alakriipsud jne 
SELECT 
    -- 1. TRIM eemaldab tühikud, 2. LOWER muudab väiketähtedeks, 3. REPLACE asendab _ tühikuga
    -- 4. INITCAP teeb esitähed suureks, 5. COALESCE asendab tühjad väärtused (NULL)
    COALESCE(INITCAP(REPLACE(LOWER(TRIM(w.source)), '_', ' ')), 'Määramata kanal') AS puhastatud_kanal, 
    COUNT(DISTINCT c.customer_id) AS kliente, 
    COUNT(DISTINCT o.sale_id) AS tellimusi, 
    SUM(o.total_price) AS kogukäive
FROM sales o 
JOIN customers c ON o.customer_id = c.customer_id 
LEFT JOIN web_logs w ON c.customer_id = w.customer_id 
GROUP BY puhastatud_kanal 
ORDER BY kogukäive DESC;

--ühtlustan ka fb ja facebook ja ads, insta ka samuti
SELECT 
    CASE
        -- 🔵 Facebook Ads
        WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('facebook ads', 'fb ads') 
            THEN 'Facebook Ads'

        -- 🔵 Facebook orgaaniline
        WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('facebook', 'fb') 
            THEN 'Facebook'

        -- 🟣 Instagram Ads
        WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('instagram ads', 'ig ads') 
            THEN 'Instagram Ads'

        -- 🟣 Instagram orgaaniline
        WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('instagram', 'ig') 
            THEN 'Instagram'

        -- 🟡 muud kanalid puhastatult
        ELSE COALESCE(
            INITCAP(REPLACE(LOWER(TRIM(w.source)), '_', ' ')),
            'Määramata kanal'
        )
    END AS kanal,

    COUNT(DISTINCT c.customer_id) AS kliente,
    COUNT(DISTINCT o.sale_id) AS tellimusi,
    SUM(o.total_price) AS kogukäive

FROM sales o 
JOIN customers c 
    ON o.customer_id = c.customer_id 

LEFT JOIN web_logs w 
    ON c.customer_id = w.customer_id 

GROUP BY 1
ORDER BY kogukäive DESC;

-- Kanali efektiivsus CTE-ga — kirjuta ise:
--CTE 1: kanali kogumüük (GROUP BY kanal)  --puhastatud kirjapildid jne 
--seda päringut ei kasutanud lõpuks, kuna fb=facebook, ig=instagram jne
WITH kanali_myyk AS (
    SELECT 
        -- Puhastame kanali nime: eemaldame tühikud, muudame väiketähtedeks, 
        -- asendame alakriipsud tühikutega ja teeme esitähed suureks.
        -- COALESCE märgib määramata kanalid nimega 'Määramata kanal' [2, 3].
        COALESCE(INITCAP(REPLACE(LOWER(TRIM(w.source)), '_', ' ')), 'Määramata kanal') AS kanal, 
        -- Arvutame kogukäibe
        SUM(o.total_price) AS kogukäive, 
        -- Loendame unikaalsed tellimused, et vältida andmete kordistumist [4]
        COUNT(DISTINCT o.sale_id) AS tellimusi
    FROM sales o 
    -- Kasutame LEFT JOIN-i, et ka ilma veebilogita tellimused jääksid alles [2, 3]
    LEFT JOIN web_logs w ON o.customer_id = w.customer_id 
    GROUP BY kanal
)
-- Kuvame CTE 1 tulemused
SELECT * FROM kanali_myyk
ORDER BY kogukäive DESC;

--peale puhastamist
WITH kanali_myyk AS (
    SELECT 
        CASE
            -- 🔵 Facebook Ads
            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('facebook ads', 'fb ads') 
                THEN 'Facebook Ads'

            -- 🔵 Facebook orgaaniline
            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('facebook', 'fb') 
                THEN 'Facebook'

            -- 🟣 Instagram Ads
            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('instagram ads', 'ig ads') 
                THEN 'Instagram Ads'

            -- 🟣 Instagram orgaaniline
            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('instagram', 'ig') 
                THEN 'Instagram'

            -- 🟡 muud kanalid puhastatult
            ELSE COALESCE(
                INITCAP(REPLACE(LOWER(TRIM(w.source)), '_', ' ')),
                'Määramata kanal'
            )
        END AS kanal,

        SUM(o.total_price) AS kogukäive,
        COUNT(DISTINCT o.sale_id) AS tellimusi

    FROM sales o 
    LEFT JOIN web_logs w 
        ON o.customer_id = w.customer_id 

    GROUP BY 1
)

SELECT *
FROM kanali_myyk
ORDER BY kogukäive DESC;

-- CTE 2: kanali unikaalsete klientide arv    
--seda ei kasutanud lõpuks, fb, ig teema
WITH kanali_unikaalsed_kliendid AS (
    SELECT 
        -- Puhastame nimed ja asendame tühjad (NULL) väärtused nimetusega 'Määramata kanal'
        COALESCE(INITCAP(REPLACE(LOWER(TRIM(w.source)), '_', ' ')), 'Määramata kanal') AS kanal, 
        -- COUNT(DISTINCT) tagab unikaalsete klientide loendamise vastavalt äritõele
        COUNT(DISTINCT o.customer_id) AS unikaalsed_kliendid
    FROM sales o 
    -- Ühendame müügid ja veebilogid, et seostada klient kanaliga
    LEFT JOIN web_logs w ON o.customer_id = w.customer_id 
    GROUP BY 1
)
-- Kuvame CTE 2 tulemuse
SELECT * FROM kanali_unikaalsed_kliendid
ORDER BY unikaalsed_kliendid DESC;

--kanali unikaalsete klientide arv peale puhastamist
WITH kanali_unikaalsed_kliendid AS (
    SELECT 
        CASE
            -- 🔵 Facebook Ads
            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('facebook ads', 'fb ads') 
                THEN 'Facebook Ads'

            -- 🔵 Facebook orgaaniline
            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('facebook', 'fb') 
                THEN 'Facebook'

            -- 🟣 Instagram Ads
            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('instagram ads', 'ig ads') 
                THEN 'Instagram Ads'

            -- 🟣 Instagram orgaaniline
            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('instagram', 'ig') 
                THEN 'Instagram'

            -- 🟡 muud kanalid
            ELSE COALESCE(
                INITCAP(REPLACE(LOWER(TRIM(w.source)), '_', ' ')),
                'Määramata kanal'
            )
        END AS kanal,

        COUNT(DISTINCT o.customer_id) AS unikaalsed_kliendid

    FROM sales o 
    LEFT JOIN web_logs w 
        ON o.customer_id = w.customer_id 

    GROUP BY 1
)
SELECT *
FROM kanali_unikaalsed_kliendid
ORDER BY unikaalsed_kliendid DESC;

--Lõpppäring: ühenda CTE-d ja arvuta müük per klient (efektiivsus) 
-- HAVING: ainult kanalid, kus > vali ise piir tellimust -- valisin 500

WITH kanali_kogumyyk AS (
    -- CTE 1: Kanali puhastatud kogumüük ja tellimuste arv
    SELECT 
        COALESCE(INITCAP(REPLACE(LOWER(TRIM(w.source)), '_', ' ')), 'Määramata kanal') AS kanal, 
        SUM(o.total_price) AS kogukäive, 
        COUNT(DISTINCT o.sale_id) AS tellimuste_arv
    FROM sales o 
    LEFT JOIN web_logs w ON o.customer_id = w.customer_id 
    GROUP BY 1
),
kanali_unikaalsed_kliendid AS (
    -- CTE 2: Kanali puhastatud unikaalsete klientide arv
    SELECT 
        COALESCE(INITCAP(REPLACE(LOWER(TRIM(w.source)), '_', ' ')), 'Määramata kanal') AS kanal, 
        COUNT(DISTINCT o.customer_id) AS unikaalsed_kliendid
    FROM sales o 
    LEFT JOIN web_logs w ON o.customer_id = w.customer_id 
    GROUP BY 1
)
-- LÕPPPÄRING: Ühendame andmed ja arvutame müügi unikaalse kliendi kohta
SELECT 
    m.kanal AS turunduskanal, 
    m.tellimuste_arv,
    m.kogukäive, 
    k.unikaalsed_kliendid, 
    -- Arvutame efektiivsuse: kogukäive jagatud unikaalsete klientide arvuga
    ROUND(m.kogukäive / NULLIF(k.unikaalsed_kliendid, 0), 2) AS myyk_per_klient
FROM kanali_kogumyyk m
JOIN kanali_unikaalsed_kliendid k ON m.kanal = k.kanal
-- HAVING: Filtreerime välja kanalid, kus on vähem kui 500 tellimust
-- See piir tagab, et Kristi esitlusel on ainult statistiliselt olulised kanalid
GROUP BY m.kanal, m.tellimuste_arv, m.kogukäive, k.unikaalsed_kliendid
HAVING m.tellimuste_arv > 500
ORDER BY myyk_per_klient DESC;

--peale fb ja ig korrigeerimist
WITH kanali_kogumyyk AS (
    SELECT 
        CASE
            -- Facebook Ads
            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('facebook ads', 'fb ads') 
                THEN 'Facebook Ads'

            -- Facebook orgaaniline
            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('facebook', 'fb') 
                THEN 'Facebook'

            -- Instagram Ads
            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('instagram ads', 'ig ads') 
                THEN 'Instagram Ads'

            -- Instagram orgaaniline
            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('instagram', 'ig') 
                THEN 'Instagram'

            -- muud kanalid
            ELSE COALESCE(
                INITCAP(REPLACE(LOWER(TRIM(w.source)), '_', ' ')),
                'Määramata kanal'
            )
        END AS kanal, 

        SUM(o.total_price) AS kogukäive, 
        COUNT(DISTINCT o.sale_id) AS tellimuste_arv

    FROM sales o 
    LEFT JOIN web_logs w 
        ON o.customer_id = w.customer_id 

    GROUP BY 1
),

kanali_unikaalsed_kliendid AS (
    SELECT 
        CASE
            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('facebook ads', 'fb ads') 
                THEN 'Facebook Ads'

            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('facebook', 'fb') 
                THEN 'Facebook'

            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('instagram ads', 'ig ads') 
                THEN 'Instagram Ads'

            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('instagram', 'ig') 
                THEN 'Instagram'

            ELSE COALESCE(
                INITCAP(REPLACE(LOWER(TRIM(w.source)), '_', ' ')),
                'Määramata kanal'
            )
        END AS kanal, 

        COUNT(DISTINCT o.customer_id) AS unikaalsed_kliendid

    FROM sales o 
    LEFT JOIN web_logs w 
        ON o.customer_id = w.customer_id 

    GROUP BY 1
)

SELECT 
    m.kanal AS turunduskanal, 
    m.tellimuste_arv,
    m.kogukäive, 
    k.unikaalsed_kliendid, 

    ROUND(
        m.kogukäive / NULLIF(k.unikaalsed_kliendid, 0),
        2
    ) AS myyk_per_klient

FROM kanali_kogumyyk m
JOIN kanali_unikaalsed_kliendid k 
    ON m.kanal = k.kanal

GROUP BY 
    m.kanal, 
    m.tellimuste_arv,
    m.kogukäive, 
    k.unikaalsed_kliendid

HAVING m.tellimuste_arv > 500

ORDER BY myyk_per_klient DESC;

--lisan ka % juurde
WITH kanali_kogumyyk AS (
    SELECT 
        CASE
            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('facebook ads', 'fb ads') 
                THEN 'Facebook Ads'

            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('facebook', 'fb') 
                THEN 'Facebook'

            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('instagram ads', 'ig ads') 
                THEN 'Instagram Ads'

            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('instagram', 'ig') 
                THEN 'Instagram'

            ELSE COALESCE(
                INITCAP(REPLACE(LOWER(TRIM(w.source)), '_', ' ')),
                'Määramata kanal'
            )
        END AS kanal, 

        SUM(o.total_price) AS kogukäive, 
        COUNT(DISTINCT o.sale_id) AS tellimuste_arv

    FROM sales o 
    LEFT JOIN web_logs w 
        ON o.customer_id = w.customer_id 

    GROUP BY 1
),

kanali_unikaalsed_kliendid AS (
    SELECT 
        CASE
            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('facebook ads', 'fb ads') 
                THEN 'Facebook Ads'

            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('facebook', 'fb') 
                THEN 'Facebook'

            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('instagram ads', 'ig ads') 
                THEN 'Instagram Ads'

            WHEN LOWER(REPLACE(TRIM(w.source), '_', ' ')) IN ('instagram', 'ig') 
                THEN 'Instagram'

            ELSE COALESCE(
                INITCAP(REPLACE(LOWER(TRIM(w.source)), '_', ' ')),
                'Määramata kanal'
            )
        END AS kanal, 

        COUNT(DISTINCT o.customer_id) AS unikaalsed_kliendid

    FROM sales o 
    LEFT JOIN web_logs w 
        ON o.customer_id = w.customer_id 

    GROUP BY 1
)

SELECT 
    m.kanal AS turunduskanal, 
    m.tellimuste_arv,
    m.kogukäive, 
    k.unikaalsed_kliendid, 

    -- 💰 efektiivsus
    ROUND(
        m.kogukäive / NULLIF(k.unikaalsed_kliendid, 0),
        2
    ) AS myyk_per_klient,

    -- 📊 % käibest
    ROUND(
        100.0 * m.kogukäive / NULLIF(SUM(m.kogukäive) OVER (), 0),
        2
    ) AS kaibe_osakaal_pct,

    -- 👥 % klientidest
    ROUND(
        100.0 * k.unikaalsed_kliendid / NULLIF(SUM(k.unikaalsed_kliendid) OVER (), 0),
        2
    ) AS kliendid_osakaal_pct

FROM kanali_kogumyyk m
JOIN kanali_unikaalsed_kliendid k 
    ON m.kanal = k.kanal

GROUP BY 
    m.kanal, 
    m.tellimuste_arv,
    m.kogukäive, 
    k.unikaalsed_kliendid

HAVING m.tellimuste_arv > 500

ORDER BY myyk_per_klient DESC;

--Kampaaniate kuised trendid — kirjuta ise:
--GROUP BY kanal, kuu 
--SUM(total_price) ja COUNT(DISTINCT customer_id)
-- HAVING: ainult kanalid, kus > vali piir tellimust kuus        --200!
-- ORDER BY kuu, kogukäive DESC
SELECT 
    -- Sinu "trikk": kanalite puhastamine ja ühendamine ühtseks grupiks
    CASE 
        WHEN LOWER(w.source) LIKE '%fb%' OR LOWER(w.source) LIKE '%facebook%' THEN 'Facebook Ads'
        WHEN LOWER(w.source) LIKE '%ig%' OR LOWER(w.source) LIKE '%instagram%' THEN 'Instagram Ads'
        WHEN w.source IS NULL THEN 'Määramata kanal'
        ELSE INITCAP(REPLACE(LOWER(TRIM(w.source)), '_', ' '))
    END AS kanal,
    
    -- Grupeerime kuu lõikes 2024. aastal
    DATE_TRUNC('month', o.sale_date) AS kuu,
    
    -- Agregeeritud näitajad: kogukäive, unikaalsed kliendid ja tellimuste arv
    SUM(o.total_price) AS kogukaive,
    COUNT(DISTINCT o.customer_id) AS unikaalsed_kliendid,
    COUNT(o.sale_id) AS tellimuste_arv
FROM sales o
-- Kasutame LEFT JOIN-i, et mitte kaotada kanalita (NULL) tellimusi [5]
LEFT JOIN web_logs w ON o.customer_id = w.customer_id

-- FILTRI LISAMINE: Ainult 2024. aasta andmed [6, 7]
WHERE o.sale_date >= '2024-01-01' AND o.sale_date <= '2024-12-31'

GROUP BY 1, 2

-- HAVING: Ainult kanalid, kus on üle 200 tellimuse kuus
HAVING COUNT(o.sale_id) > 200

-- Järjestamine: kuu kronoloogiliselt ja käibe järgi kahanevalt
ORDER BY kuu, kogukaive DESC;

--Baas (70%): Sammud 1 ja 3 (GROUP BY + HAVING kanalite ja kuiste trendide kohta).
--Edasijõudnute (30%):
--Samm 2 — CTE-ga kanali efektiivsuse arvutamine. Lisa window function kuust-kuusse kasvu leidmiseks:
--LAG(SUM(o.total_price)) OVER (      PARTITION BY w.source    
--ORDER BY DATE_TRUNC('month', o.sale_date)    ) AS eelmise_kuu_käive

WITH kanali_koond AS (
    -- 1. samm: Koondame andmed ja puhastame kanalite nimed
    SELECT 
        CASE 
            WHEN LOWER(w.source) LIKE '%fb%' OR LOWER(w.source) LIKE '%facebook%' THEN 'Facebook Ads'
            WHEN LOWER(w.source) LIKE '%ig%' OR LOWER(w.source) LIKE '%instagram%' THEN 'Instagram Ads'
            WHEN w.source IS NULL THEN 'Määramata kanal'
            ELSE INITCAP(REPLACE(LOWER(TRIM(w.source)), '_', ' '))
        END AS puhastatud_kanal,
        DATE_TRUNC('month', o.sale_date) AS kuu,
        SUM(o.total_price) AS kogukaive,
        COUNT(o.sale_id) AS tellimuste_arv
    FROM sales o
    LEFT JOIN web_logs w ON o.customer_id = w.customer_id
    WHERE o.sale_date >= '2024-01-01' AND o.sale_date <= '2024-12-31'
    GROUP BY 1, 2
    -- Filtreerime välja kanalid, kus on vähemalt 500 tellimust kuus (Sinu valitud piir)
    HAVING COUNT(o.sale_id) > 500 
)
SELECT 
    puhastatud_kanal,
    kuu,
    kogukaive,
    tellimuste_arv,
    -- Window function eelmise kuu käibe leidmiseks
    LAG(kogukaive) OVER (
        PARTITION BY puhastatud_kanal 
        ORDER BY kuu
    ) AS eelmise_kuu_kaive,
    -- Kuust-kuusse kasvu protsent Kristi raporti jaoks
    ROUND(
        (kogukaive - LAG(kogukaive) OVER (PARTITION BY puhastatud_kanal ORDER BY kuu)) 
        / NULLIF(LAG(kogukaive) OVER (PARTITION BY puhastatud_kanal ORDER BY kuu), 0) * 100, 
        1
    ) AS kasvu_protsent
FROM kanali_koond
-- SORTEERIMINE: esmalt kronoloogiliselt kuu järgi ja siis käibe järgi kahanevalt
ORDER BY kuu, kogukaive DESC;

--kogu käive
SELECT 
    CASE
        WHEN LOWER(w.source) LIKE '%fb%' OR LOWER(w.source) LIKE '%facebook%' THEN 'Facebook Ads'
        WHEN LOWER(w.source) LIKE '%ig%' OR LOWER(w.source) LIKE '%instagram%' THEN 'Instagram Ads'
        WHEN w.source IS NULL THEN 'Määramata kanal'
        ELSE INITCAP(REPLACE(LOWER(TRIM(w.source)), '_', ' '))
    END AS puhastatud_kanal,
    SUM(o.total_price) AS kogukaive
FROM sales o
LEFT JOIN web_logs w ON o.customer_id = w.customer_id
GROUP BY 1
ORDER BY kogukaive DESC;