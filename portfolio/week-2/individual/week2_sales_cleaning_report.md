# „Sales“ tabeli puhastamisraport

## Andmete kvaliteedi ülevaade

| Kategooria           | Leitud probleeme | Kirjeldus |
|---------------------|------------------|-----------|
| Duplikaadid         | 5116             | Tuvastatud 5116 liigset rida, mis moodustavad 33,58% kogu tabeli andmemahust ja on põhjustatud 4013 korduvast sale_id-st ning vajavad kustutamist |
| NULL customer_id    | 1487             | Puuduv kliendi viide |
| NULL sale_date      | 0                | Puuduv kuupäev |
| NULL total_price    | 0                | Puuduv summa |
| Tuleviku kuupäevad  | 9                | Kuupäev > tänane |
| **KOKKU probleeme** | **6612**         | Kokku leitud anomaaliate arv enne puhastamist `sales_test` tabelis |

# „Sales“ tabeli puhastamise võrdlev raport: enne ja pärast

## Andmete kvaliteedi ülevaade

| Kategooria            | Enne puhastamist | Pärast puhastamist | Selgitus |
|----------------------|------------------|--------------------|----------|
| Ridade koguarv       | 15234            | 10118              | Eemaldatud 5116 liigset rida |
| Duplikaadid          | 5116 (33,58%)    | 0                  | Eemaldatud duplikaadid, mille põhjustasid 4013 korduvat sale_id-d |
| NULL customer_id     | 1487             | 0                  | Pärast duplikaatide eemaldamist jäi 988 unikaalset NULL-i, mis sai asendatud ID-ga 0 |
| NULL sale_date       | 0                | 0                  | Kontrollitud – puudujääke ei esinenud |
| NULL total_price     | 0                | 0                  | Kontrollitud – kõikidel tehingutel oli summa olemas |
| Tuleviku kuupäevad   | 9                | 0                  | 9 vigast ja vales formaadis kuupäeva on parandatud (seisuga 08.04.2026) |
| **Kokku probleeme**  | **6612**         | **988**            |  |

## Kokkuvõte

- Suurimaks üllatuseks oli see, et 33,58% müügiandmetest ehk 5116 rida olid duplikaadid.

- Soovitus Toomasele: esmajärjekorras tuleb eemaldada müügiandmete duplikaadid (5116 rida), kuna need moodustavad 33,58% andmetest ja moonutavad käivet märkimisväärselt.

- Puuduvad andmed: Pärast duplikaatide eemaldamist jäi 1487-st puuduvast customer_id-st alles 988 unikaalset tehingut, millel puudub seos kliendiga. Need on asendatud väärtusega 0.


