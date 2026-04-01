# Nädal 1: SQL Basics -- UrbanStyle'i andmete uurimine

## Mida ma tegin
- Uurisin kliendiandmete tabelit SQL päringutega
- Leidsin, et kliente kokku oli 3150, dubleerivaid ei olnud
- Kliendi andmetest olid kõik eesnimed olemas, samas puuduvaid e-maile oli 380 ning dubleerivaid e-maile oli 510
- Peamine leid: enamus andmeid oli veergudes olemas. Veergudes „email“ ja „loyalty_tier“ on puuduvaid andmeid. Veerus „city“ on andmed ebakorrektsed: linnanimed on erineva kirjapildiga (suured ja väikesed tähed) ning esineb liigseid tühikuid (nt nime ees või järel).

- Edasiseks analüüsiks tuleks esmalt kontrollida kliendikaardi (customer_id) sisu, nt nimi ja e-mail, et tuvastada võimalikud samad kliendid.
- Tuleks korrastada ka puuduolevad andmed.

- Osalesin meeskonnatöö SQL päringute tegemisel "customer" tabeli kohta.

## Peamised õpid
- Jälgida tähelepanelikult päringuid, mida teed
- Jälgida, et päringu tegemisel on kõik õigesti, nt kas * on olemas ja termin õige nt sale-sales

## Failid
- `week1_[tabel]_exploration.sql` -- minu SQL päringud
- `week1_results_screenshot.png` -- tulemuste pilt

## Meeskonna töö
- [Link meeskonna Data Landscape slaidile]
