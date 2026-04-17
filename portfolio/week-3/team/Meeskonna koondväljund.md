# Nädal 3: SQL JOINs

## UrbanStyle'i „Äritõe“ Tuvastamine  
**Müügikanalite, toodete ja klientide tervikanalüüs**  

- **Meeskond:** Tooteanalüüsi osakond  
- **Tegelane:** Toomas Kask  
- **Kuupäev:** 15.04.2026  

---

## ALAÜLESANDE KAART A – Müük + Kliendid (Krista)

### Kokkuvõte Annale

#### Kes on parimad kliendid?
- Meie TOP 10 klientidest peaaegu pooled on pärit Pärnust  
- Enamus TOP 10 kliente on teinud üle 70 ostu  
- Kogumüügi summad jäävad vahemikku **20 124,61 € – 27 688,02 €**

#### Millisest linnast tuleb enim müüke?
- **Tallinn:** 3601 müüki – **1 006 252,88 €**
- **Tartu:** 1764 müüki – **523 286,64 €**
- **Pärnu:** 1231 müüki – **374 005,86 €**
- Teised linnad jäävad alla 1000 müügi

📊 Tähelepanek:
- Pärnu kliendid: **4,7 ostu kliendi kohta (kõrgeim)**
- Kõrgeim keskmine ostu hind: **Paide**

#### Milline loyalty_tier on kõige kasumlikum?
- Puuduv (NULL): ~1000 klienti → **1 071 805,32 €**
- **Silver:** 560 klienti → **593 470,07 €**
- **Gold:** 491 klienti → **533 601,64 €**
- **Bronze:** 476 klienti → **423 854,75 €**

📊 Järeldus:
- Esmapilgul NULL tundub parim  
- Tegelikult on **Gold tier kõige efektiivsem (müük/kliendi kohta)**

#### Üle keskmise kulutajad
- **24,2% klientidest**

---

## ALAÜLESANDE KAART B – Kliendid ilma ostudeta

### Raport: "Kadunud klientide" analüüs

- **513 klienti** on loonud konto, kuid pole ostu teinud  
- Suurimad grupid:
  - Tallinn: 212
  - Tartu: 123  

📊 Tähelepanek:
- Paljud registreerusid juba **jaanuaris 2020**
- Tõenäoliselt brändist võõrdunud

💡 Soovitus:
- Saata **win-back e-mail**
- Pakkumine:  
  **"Sinu esimene Urban Style'i ost -15%"**

---

## ALAÜLESANDE KAART C – Tooted + Inventuur (LEFT JOIN) (Kevin)

### Müümata tooted
- Tuvastati **12 toodet**, mida pole kordagi müüdud  
- Laoseis: **0**

📊 Järeldus:
- Tooted on nähtaval, kuid reaalselt puuduvad laos  
- Näited: eksperimentaalsed tooted (nt puust müts, keraamiline sall)

💡 Soovitus:
- Eemaldada süsteemist

---

### Kategooriate edukus
- **Parim kategooria:** Jalanõud  
  - 73 toodet  
  - Müük: **774 000 €+**

- **Meeste riided:** 82 toodet (rohkem, aga väiksem müük)

### Müügihitt
- **Õhulised sünteetilised sporditossud**
  - 35 müüki  
  - **27 347,04 €**

📊 Tähelepanek:
- TOP 10 domineerivad:
  - Jalanõud  
  - Naiste jakid ja seelikud  

---

### Inventuuri soovitused
- ❌ Eemaldada 12 müümata toodet  
- ⚠️ Parandada kahjumlike vintage-toodete hinnastus  
- ⚡ Tellida juurde populaarsed tooted:
  - **Cargo püksid:** laoseis **-46**

📊 Fookus:
- Jalanõud  
- Meeste riided  
- Naiste riided  

---

## ALAÜLESANDE KAART D – Müügikanalid + Kliendid (Eike)

### Andmete puhastus
- Eemaldati **5116 duplikaatset rida**

---

### Kanalite jaotus
- **Pood:**
  - 6656 ostu  
  - **1 902 430,30 €**
  - **66% müügist**

- **Online:**
  - 3462 ostu  
  - **1 006 787,68 €**
  - **34% müügist**

---

### Efektiivsus
- Pood: **835,13 € / klient (2278 klienti)**  
- Online: **590,12 € / klient (1706 klienti)**  

📊 Järeldus:
- Online madalam väärtus, kuid **suurem kasvupotentsiaal**

---

### Tootespetsiifika
- **Online:**
  - Parim kategooria: Jalanõud  
  - Top toode: Õhulised sünteetilised sporditossud  

- **Pood:**
  - Parim kategooria: Naiste riided  
  - Top toode: Praktiline džersii seelik  

---

### VIP-klient
- **Kevin Org (ID 2997)**
  - 78 ostu  
  - **23 467,13 €**
  - Kalleim ost:
    - Õhulised goretex tennised → **1750,95 €** (online)

---

### Linnade võrdlus
- **Tallinn:** 3801 ostu (37,6%)  
- **Tartu:** 1797 ostu (17,8%)  
- **Pärnu:** 1058 ostu (10,5%)  
- **Online (NULL):** 3462 ostu (34,2%)

---

### Suurim üllatus
- Online-kanal on peaaegu sama tugev kui Tallinn  
  - **34,2% vs 37,6%**

---

### Soovitused Annale

#### 1. Eelarve suund
- Suunata turundus **online-kanalisse**
- Eesmärk: **60% müügist e-kanalist**

#### 2. Regionaalne fookus
- Tugevdada **Pärnu digireklaami**
- Suunata kliendid e-poodi

---

### Kokkuvõte
UrbanStyle’i kasvumootor:
- **Online-kanal + Tallinna pood sünergias**

📊 Mõju:
- Tugev bränd Tallinnas → kandub online’i  
- Võimaldab müüki üle Eesti  
- 24/7 kättesaadavus  

---

## SOOVITUSED

### 1. Online-kanalisse investeerimine
- **590 € vs 835 € kliendi kohta**
- Suurim kasvupotentsiaal  
- Eesmärk: **60% müügist e-kanalist**

### 2. 513 kadunud klienti
- Win-back kampaania  
- **-15% esmaostu soodustus**  
- Fookus:
  - Tallinn (212)
  - Tartu (123)

### 3. Inventuur – kiirtoimingud
- Eemaldada 12 müümata toodet  
- Tellida juurde:
  - Cargo püksid (**-46 ühikut**)  
- Parandada vintage-toodete hinnastus  