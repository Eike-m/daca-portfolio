# Nädal 1: SQL Basics — UrbanStyle'i andmete uurimine

## Projekti eesmärk

Week 1 eesmärk oli uurida UrbanStyle kliendiandmeid SQL päringute abil ning analüüsida andmete kvaliteeti, võimalikke duplikaate ja puuduvaid väärtusi.

## Mida ma tegin

- Uurisin kliendiandmete tabelit SQL päringutega.
- Kontrollisin duplikaate, NULL väärtusi ja andmete korrektsust.
- Kasutasin SQL päringuid nagu:
  - SELECT
  - DISTINCT
  - COUNT
  - WHERE
  - ORDER BY
- Analüüsisin veerge `email`, `city` ja `loyalty_tier`.

## Peamised leiud

- Kliente kokku oli **3150**.
- Dubleerivaid kliendikirjeid ei olnud.
- Puuduvaid e-maile oli **380 (12.1%)**.
- Dubleerivaid e-maile oli **510 (16.2%)**.
- Unikaalseid e-maile oli **2640 (71.7%)**.
- Veerus `city` esines ebakorrapärasusi:
  - erinevad suur- ja väiketähed,
  - liigsed tühikud,
  - sama linn erineva kirjapildiga.
- Kõik eesnimed olid olemas, kuid e-mailide kvaliteedis esines probleeme.

## Järeldused

- Edasiseks analüüsiks tuleks esmalt kontrollida kliendikaardi (`customer_id`) sisu, näiteks nime ja e-maili, et tuvastada võimalikud samad kliendid.
- Tuleks korrastada puuduolevad ja ebakorrektsed andmed enne edasist analüüsi.
- Andmete standardiseerimine parandaks tulevaste analüüside kvaliteeti.

## Meeskonnatöö

- Osalesin meeskonnatöö SQL päringute tegemisel `customers` tabeli kohta.
- Panustasin andmekvaliteedi probleemide ja kliendiandmete analüüsimisse.

## Peamised õpid

- Õppisin tähelepanelikumalt kontrollima SQL päringute süntaksit ja loogikat.
- Sain aru, kui oluline on kontrollida tabeli- ja veerunimesid (`sales` vs `sale` jne).
- Õppisin kasutama SQL päringuid andmete kvaliteedi hindamiseks.

## Failid

- `week1_sales_exploration.sql` — minu SQL päringud
- `screenshots/` — SQL päringute tulemuste pildid
- `week1_data_landscape.md` — meeskonna kokkuvõte andmete analüüsist

## AI kasutamine

Kasutasin AI abi SQL süntaksi kontrollimiseks, DISTINCT ja COUNT päringute mõistmiseks ning andmekvaliteedi analüüsi tõlgendamiseks.

## Meeskonna töö
- https://github.com/rattaseppkevin-tech/urbanstyle-TOOTE-grupp/blob/main/v%C3%A4ljund_w1.md
