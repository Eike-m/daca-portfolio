--Dashboard'i paigutuse kavandamine 
--Harjutus 2A: Shu — analüüsi malli järgi 
Ülesanne: Vaata alltoodud dashboard'i paigutust ja vasta küsimustele.
┌─────────────────────────────────────────────────────┐
│  UrbanStyle Investor Dashboard — Q4 2024            │
├──────────┬──────────┬──────────┬────────────────────┤
│ €305K    │ 2 500    │ €32      │ +15% kasv          │
│ Käive    │ Kliendid │ Kesk.tell│ vs Q3              │
├──────────┴──────────┴──────────┴────────────────────┤
│                                                     │
│  Müügitulu trend (joondiagramm, Jan-Dec)            │
│  Y: EUR, X: Kuud                                    │
│                                                     │
├──────────────────────────┬──────────────────────────┤
│  TOP 5 toodet            │  Müük linnade lõikes     │
│  (horisontaalne tulp)    │  (sektordiagramm)        │
│                          │  Tallinn 42%             │
│  Denim Jacket  ████ 45K  │  Online  28%             │
│  Sneakers      ███  35K  │  Tartu   18%             │
│  Hoodie        ██   28K  │  Pärnu   12%             │
├──────────────────────────┴──────────────────────────┤
│  [ Periood ▼ ]  [ Linn ▼ ]  [ Kategooria ▼ ]       │
└─────────────────────────────────────────────────────┘
Küsimused:
Milline element on kõige olulisem (esimesena nähtav)? €305K käive
Miks on joondiagramm suurim element? Näitab trendi ajas - kas me kasvame või mitte
Miks on sektordiagrammil ainult 4 kategooriat? Toodud välja Top linnad
Kus on filtrid ja miks just seal? all ja need pole kõige tähtsamad
Kas see dashboard vastab Kristi 4 küsimusele? Millisele küsimusele vastab iga element?
"Kas me kasvame?" → Joondiagramm ja +15% kasv
"Mis tooted müüvad?" → Tulpdiagramm
"Kust tulevad kliendid?" → Sektordiagramm
"Kas marketing töötab?" → Keskmine tellimus + käibe kasv + trend


--Harjutus 2C: Rakendus — Data-ink ratio audit 
--Ülesanne: All on kirjeldatud "halb" dashboard. Leia kõik chart junk elemendid ja kirjelda, milline näeks see välja pärast puhastamist.
Halva dashboard'i kirjeldus:
3D tulpdiagramm gradienttäitega
Iga tulba taga vari (drop shadow)
Heleroosa mustriga taust
Legend kordab x-telje silte
15 ruudustikujoont
Numbrid 2 komakohaga (€32 156,78)
Pealkiri kaldkirjas ja allajoonitud
3 rida väikekirjas autoriinfot
Chart junk elemendid (leia vähemalt 7): Pakun kõik, kui siis võib jääda 3 rida väikekirjas autoriinfot
Milline näeks see välja pärast puhastamist (kirjelda 3-4 lausega): 
--Eemaldasin 3D efektid, varjud, tausta. Numbrid korrektsed, ilma komakohata
