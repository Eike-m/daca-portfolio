# Nädal 2: SQL Basics -- UrbanStyle'i andmete puhastamine

## Mida ma tegin
Uurisin müügiandmete tabelit SQL päringutega
- Leidsin:
   - duplikaate oli 5116 rida, mis moodustavad 33,58% kogu tabeli andmemahust ja on põhjustatud 4013 korduvast sale_id-st ja need on vaja kustutada.
   -  NULL customer_id oli 1487, pärast duplikaatide eemaldamist jäi 988 unikaalset NULL-i, mis sai asendatud ID-ga 0
   - Tuleviku kuupäevi oli 9, need vigased ja vales formaadis kuupäevad on parandatud 08.04.2026 seisuga.

- Peamine leid: oli see, et 33,58% müügiandmetest olid duplikaadid.

- Esmajärjekorras tuleb eemaldada müügiandmete duplikaadid (5116 rida), kuna need moodustavad 33,58% andmetest ja moonutavad käivet märkimisväärselt.

- Osalesin meeskonnatöö SQL päringute tegemisel "sales" tabeli kohta.

## Peamised õpid
- Jälgida tähelepanelikult päringuid, mida teed
- Jälgida, et päringu tegemisel on kõik õigesti, nt kas * on olemas ja termin õige nt sale-sales

## Failid
- [`week1_\[tabel\]_exploration.sql`](individual/week2_sales_cleaning.sql) -- minu SQL päringud
- ['week2_sales_cleaning report.md' ](<individual/week2_sales_cleaning report.md>) -- võrdlev raport enne ja pärast puhastust

## Meeskonna töö koondraportile
- [https://github.com/rattaseppkevin-tech/urbanstyle-TOOTE-grupp/blob/main/week2_team_cleaning_report.pdf]
