# Week 1 — Customer Data Landscape

## Kokkuvõte

Uurisin kliendiandmete tabelit, kus oli kokku **3150 rida** ja **9 veergu**.

Analüüsi käigus jäi kohe silma, et:
- enamus andmeid olid veergudes olemas,
- veergudes `email` ja `loyalty_tier` esines puuduvaid väärtusi,
- veerus `city` olid andmed ebakorrektsed:
  - erinevad suur- ja väiketähed,
  - liigsed tühikud nime ees või järel,
  - sama linn erineva kirjapildiga.

## Peamised leiud

- Kokku oli **3150 klienti**.
- Dubleerivaid kliendikirjeid ei olnud.
- Kõik eesnimed olid olemas.
- Puuduvaid e-maile oli **380 (12.1%)**.
- Dubleerivaid e-maile oli **510 (16.2%)**.
- Unikaalseid e-maile oli **2640 (71.7%)**.

## Linnade analüüs

`DISTINCT` päringut kasutades selgus, et linnade väärtused ei olnud standardiseeritud. Sama linn esines erineval kujul:
- suur- ja väiketähtedega,
- liigsete tühikutega,
- erineva kirjapildiga.

Seetõttu käsitles SQL `DISTINCT` funktsioon neid eraldi väärtustena.

## Tähelepanekud

Üllatav oli see, et kõik eesnimed olid olemas, kuid samal ajal esines palju puuduvaid ja dubleerivaid e-maile.

## Soovitused edasiseks analüüsiks

- Kontrollida kliendikaardi (`customer_id`) sisu, näiteks nime ja e-maili kombinatsioone, et tuvastada võimalikud samad kliendid.
- Korrastada puuduolevad ja ebakorrektsed andmed enne edasist analüüsi.
- Standardiseerida `city` veeru väärtused, et vältida sama linna esinemist erineval kujul.

