# Roll B — Peer Review
**Tehniline intervjueerija vaade (Technical Interviewer) · tõenduspõhine versioon**

---

| Programm | Roll | Kuupäev | Portfoolio |
|---|---|---|---|
| DACA Nädal 9 | B (tehniline) | 27.05.2026 | github.com/krista-hein |

| Kandidaat | Commit'e kokku | N8 failid | Repo algus |
|---|---|---|---|
| Krista Hein | 58 (märts–mai 2026) | pipeline.py + 3 moodulit | 24.03.2026 |

---

## 1. Tehniline hindamine

*Hinnanguskaala: ★★★★★ Väga tugev | ★★★★☆ Tugev | ★★★☆☆ Keskmine*

| Tehniline aspekt | Hinnang | Detailne hinnang |
|---|---|---|
| **SQL oskused** | ★★★★☆ | N1–N4: SELECT → ROW_NUMBER → CTE → konversioonianalüüs web_logs+sales |
| **Python / pandas** | ★★★★☆ | N7: merge, dtypes, CSV fallback; N8: logging, try/except, pathlib, sys.argv |
| **Visualiseerimine (Power BI)** | ★★★★☆ | KPI kaardid, viitejoon €20K, "mai anomaalia" annotatsioon, brändivärvid teal #009B8D |
| **Git & GitHub** | ★★★★★ | 58 commit'i, Verified GPG allkirjad, regulaarne rütm märtsist maini |
| **README dokumentatsioon** | ★★★★★ | Igas nädalas, ärikontekst + metoodika + AI kasutamine dokumenteeritud |
| **Koodi modulaarsus & pipeline** | ★★★★★ | pipeline.py + data_fetcher.py + transform.py + visualize_export.py — tegelikult kontrollitud |
| **Commit sõnumite kvaliteet** | ★★★★☆ | Pealkirjad lühikesed ("Adding Week 8 work") — sisukas info on README-des, mitte commit body-s |
| **Tööriistade mitmekülgsus** | ★★★★★ | SQL, Python, Power BI, Plotly, Git, Supabase, Jupyter Notebook — kõik kontrollitud |

---

## 2. Kolm peamist tugevust

### Tugevus 1 — Terviklik modulaarne andmetoru

N8 kaustas on neli eraldi Python faili (pipeline.py, data_fetcher.py, transform.py, visualize_export.py) — tegelikult kontrollitud, mitte ainult kirjeldatud. Granuleeritud veakäsitlus: visualiseerimise viga ei katkesta eksporti. See on teadlik arhitektuuriotsus, mida tootmistaseme koodis nõutakse.

### Tugevus 2 — Ärikontekstuaalne analüüs N1-st N8-ni

Kõik projektid on seotud UrbanStyle äriprobleemidega. Eriti silmapaistev on N6 Power BI dashboard: KPI kaardid, viitejoon kuu eesmärgiga (€20K), "mai anomaalia" annotatsioon graafikul ja "peidetud VIP-id" narratiiv (AOV €319, 47% anonüümsed). N4 kolme CTE-ga konversioonianalüüs web_logs + sales andmetel ületab nädala taseme nõuded.

### Tugevus 3 — Dokumentatsioonikultuur ja aus AI kasutamine

README igas nädalas, sisaldab ärilist konteksti ja metoodikat. AI kasutamine on dokumenteeritud konkreetsete kasutusjuhtudega — N8 eristab NotebookLM (äriloogika) ja Claude (debugging) erinevate eesmärkidega. N2 kasutab ROW_NUMBER() OVER (PARTITION BY ...) ja STRING_AGG — tehnikad, mida nädala tasemest ei nõuta.

---

## 3. Kaks parandusettepanekut

### Ettepanek 1 — Testimispäringud SQL failidest eemaldada

N3 ja N4 SQL failide lõpus on jäänud `select * from sales`, `select * from web_logs` jms. Portfoolios jätab see mulje, et töö pole lõpetatud. Konkreetne samm: enne iga git push kontrollida failide lõpp.

### Ettepanek 2 — Commit sõnumid täpsemaks + N8 README käivitusjuhis täiendada

Commit'id on üherealised pealkirjad ("Adding Week 8 work") — sisukas info on README-des, mis on hea, aga commit body oleks tugevam signaal. Git konventsiooni järgi: esimene rida max 72 märki + detailid body-s inglise keeles. Lisaks N8 README 3. samm on tühi — puudub käsk:

```bash
python pipeline.py --start-date 2023-01-01 --date 2026-05-27
```

---

## 4. Kokkuvõtlik hindamistabel

| Hindamiskriteerium | Tulemus |
|---|---|
| Koodi kvaliteet (loetavus, struktuur) | ✅ Tugev — modulaarne pipeline, pandas best practices |
| Tööriistade tundmine | ✅ Täielik junior DA komplekt kaetud |
| SQL tase | ✅ Põhitõedest CTE-de ja ROW_NUMBER-ini |
| Python tase | ✅ pandas, Plotly, API-d, automatiseerimine |
| Visualiseerimine | ✅ Power BI — KPI kaardid, viitejoon, annotatsioon |
| Dokumentatsioon (README) | ✅ Põhjalik ja struktureeritud |
| Commit ajalugu | ✅ 58 commit'i, Verified GPG, regulaarne rütm |
| Commit sõnumite kvaliteet | ⚠️ Pealkirjad lühikesed, sisukas info README-des |
| Ärikontekstuaalsus | ✅ Erakordne — kõik projektid UrbanStyle-põhiselt |
| GitHub pinned repo-d | ⚠️ Ühtegi repo pole pinned |

---

## 5. Hiring Scorecard — tehniline hindamine (Roll B), max 25 punkti

| Kriteerium | SQL | Python | Visualiseerimine | Git & dokumentatsioon | Dokumentatsioon |
|---|---|---|---|---|---|
| Skoor | 4 | 4 | 4 | 5 | 5 |

**Koondskoor: 22 / 25 → ✅ PALKA (lävend 20+)**

---

## 6. Värbamissoovitus

### ✅ JAH — soovitame edasistele vestlustele

**Põhjendus (tehniline intervjueerija vaatepunktist):**

Krista Hein demonstreerib harvaesineva kombinatsiooni: (1) laiaulatuslik tööriistakomplekt — SQL, Python/pandas, Power BI, Plotly, Git, Supabase; (2) ärikontekstuaalne mõtlemine — kõik projektid lähtuvad konkreetsest sidusrühma vajadusest; (3) tõendatud modulaarne pipeline — neli eraldi Python faili, kontrollitud selle hindamise käigus; (4) järjepidev dokumentatsioonikultuur — README igas nädalas, AI kasutamine ausalt kirjeldatud.

**Sobivus UrbanStyle'i konteksti:**

UrbanStyle (~45 töötajat, ~3M EUR käive, 150% kasv 2 aastaga) vajab mitmekülgset analüütikut, kes tuleb toime kiires kasvukeskkonnas. Mitmekanalilised andmed (e-commerce + füüsilised poed) nõuavad nii SQL kui Python oskust — mõlemad on portfoolios tugevalt esindatud.

**Remote ja rahvusvaheline kontekst (Soome + Saksamaa):**

Värbamisjuhendi abimaterjalid rõhutavad, et hajutatud meeskonna jaoks on kriitilised iseseisvus ja dokumentatsioonikultuur. Soome kolleegide jaoks on oluline otsekohesus ja iseseisev töötamine — Krista portfoolio näitab just seda: igal nädalal on iseseisvalt valminud README ärikontekstiga. Saksamaa konteksti jaoks on oluline põhjalikkus ja struktureeritus — N8 pipeline.py kahesuunaline logimine, granuleeritud veakäsitlus ja modulaarne arhitektuur vastavad sellele standardile.

Tehniline intervjuu peaks fookustuma konkreetsetele SQL/Python ülesannetele ärikontekstis ning individual vs team panuse selgitamisele.

---

*Grupitöö: DACA Nädal 9 — karjääri ettevalmistus | Roll B: tehniline intervjueerija | Portfoolio: github.com/krista-hein/daca-portfolio*

*AI kasutamine: AI-d kasutati portfoolio struktuuri analüüsimiseks ja hindamiskriteeriumide koostamiseks. Kõik hinnangud põhinevad konkreetsetel vaatlustel repositooriumis ning on kirjutatud hindaja sõnadega.*
