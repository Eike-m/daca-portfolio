# Nädal 2: SQL puhastamine — UrbanStyle andmete kvaliteedikontroll

## Mida ma tegin
Uurisin ja puhastasin UrbanStyle müügiandmete tabelit SQL päringute abil.

Leidsin:
- 5116 duplikaatset rida, mis moodustasid 33,58% kogu tabeli andmemahust ning olid põhjustatud 4013 korduvast `sale_id` väärtusest.
- 1487 `NULL customer_id` väärtust, millest pärast duplikaatide eemaldamist jäi alles 988 unikaalset puuduvat väärtust.
- 9 tuleviku kuupäeva, mis olid vigased või vales formaadis ning parandati seisuga 08.04.2026.

## Peamised leiud
- Kõige suurem probleem oli müügiandmete duplikaatsus — 33,58% tabeli andmetest olid duplikaadid.
- Duplikaadid moonutasid müügi- ja käibenumbreid märkimisväärselt.
- Puuduvad kliendi ID-d ja vigased kuupäevad vähendasid andmete usaldusväärsust.

## Soovitused
- Esmajärjekorras tuleb eemaldada müügiandmete duplikaadid, kuna need mõjutavad otseselt äriraporteid ja käibenumbreid.
- Tuleks luua automaatsed kontrollid, mis takistavad korduvate `sale_id` väärtuste tekkimist tulevikus.
- Puuduvate kliendi ID-de käsitlemiseks tuleks määratleda ühtne äriloogika.

## Meeskonnatöö
- Osalesin meeskonna SQL päringute ja andmekvaliteedi analüüsi koostamisel `sales` tabeli kohta.
- Panustasin Week 2 koondraporti loomisesse.

## Peamised õpid
- Õppisin kasutama SQL päringuid andmekvaliteedi probleemide tuvastamiseks.
- Mõistsin, kui oluline on kontrollida duplikaate, NULL väärtusi ja vigaseid kuupäevi enne analüüsi tegemist.
- Harjutasin SQL puhastusfunktsioonide ja andmete valideerimise kasutamist.

## AI kasutamine
- Kasutasin AI-d SQL päringute kontrollimiseks ja vigade leidmiseks.
- AI aitas mõista, kuidas kasutada `GROUP BY`, `HAVING`, `COALESCE` ja kuupäevade puhastamist.

## Failid
- [`week2_sales_cleaning.sql`](individual/week2_sales_cleaning.sql) — minu SQL puhastamise päringud
- [`week2_sales_cleaning_report.md`](individual/week2_sales_cleaning_report.md) — raport enne ja pärast puhastust

## Meeskonna töö koondraport
- [Week 2 Team Cleaning Report](https://github.com/rattaseppkevin-tech/urbanstyle-TOOTE-grupp/blob/main/week2_team_cleaning_report.pdf)

