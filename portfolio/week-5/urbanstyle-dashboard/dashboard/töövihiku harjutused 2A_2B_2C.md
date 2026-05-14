# Dashboard'i paigutuse kavandamine

## Harjutus 2A: Shu — analüüsi malli järgi  
**Ülesanne:** Vaata alltoodud dashboard'i paigutust ja vasta küsimustele.

# UrbanStyle Investor Dashboard — Q4 2024 (joonis)

```text
┌─────────────────────────────────────────────────────┐
│ UrbanStyle Investor Dashboard — Q4 2024              │
├──────────┬──────────┬──────────┬────────────────────┤
│ €305K    │ 2 500    │ €32      │ +15% kasv          │
│ Käive    │ Kliendid │ Kesk.tell│ vs Q3              │
├──────────┴──────────┴──────────┴────────────────────┤
│                                                     │
│        Müügitulu trend (joondiagramm)               │
│                                                     │
│   €                                                 │
│   │        ╭───╮                                    │
│   │      ╭─╯   ╰─╮                                  │
│   │   ╭─╯        ╰──╮                               │
│   │ ╭╯              ╰──╮                            │
│   └───────────────────────────→ Kuud                │
│                                                     │
├──────────────────────────┬──────────────────────────┤
│ TOP 5 toodet             │ Müük linnade lõikes      │
│                          │                          │
│ Denim Jacket ████ 45K    │ Tallinn  ██████ 42%      │
│ Sneakers      ███  35K   │ Online   ████   28%      │
│ Hoodie        ██   28K   │ Tartu    ███    18%      │
│                          │ Pärnu    ██     12%      │
├──────────────────────────┴──────────────────────────┤
│ [ Periood ▼ ] [ Linn ▼ ] [ Kategooria ▼ ]          │
└─────────────────────────────────────────────────────┘

# Dashboard analüüs ja Data-Ink Ratio audit

## Küsimused ja vastused

**Milline element on kõige olulisem (esimesena nähtav)?**  
€305K käive  

**Miks on joondiagramm suurim element?**  
Näitab trendi ajas — kas me kasvame või mitte  

**Miks on sektordiagrammil ainult 4 kategooriat?**  
Välja on toodud TOP linnad, et hoida visuaal lihtne ja arusaadav  

**Kus on filtrid ja miks just seal?**  
All — need ei ole kõige olulisemad ja ei tohiks varjutada põhiinfot  

**Kas see dashboard vastab Kristi 4 küsimusele? Millisele küsimusele vastab iga element?**  

- **Kas me kasvame?** → Joondiagramm ja +15% kasv  
- **Mis tooted müüvad?** → Tulpdiagramm  
- **Kust tulevad kliendid?** → Sektordiagramm  
- **Kas marketing töötab?** → Keskmine tellimus + käibe kasv + trend  

---

## Harjutus 2C: Data-Ink Ratio audit  

### Halva dashboard'i kirjeldus

- 3D tulpdiagramm gradienttäitega  
- Iga tulba taga vari (drop shadow)  
- Heleroosa mustriga taust  
- Legend kordab x-telje silte  
- 15 ruudustikujoont  
- Numbrid 2 komakohaga (€32 156,78)  
- Pealkiri kaldkirjas ja allajoonitud  
- 3 rida väikekirjas autoriinfot  

### Chart junk elemendid

- 3D efekt  
- Gradienttäide  
- Varjud  
- Mustriline taust  
- Dubleeriv legend  
- Liigne ruudustik  
- Liigne täpsus numbrites  
- Liigne teksti stiil  
- Ebavajalik autoriinfo  

### Puhastatud versioon

Eemaldasin 3D efektid, varjud ja tausta, et visuaal oleks puhas ja selge.  
Vähendasin ruudustiku hulka ning eemaldasin dubleeriva legendi.  
Numbrid esitasin lihtsamalt, ilma liigsete komakohtadeta.  
Tulemus on selge ja kergesti loetav dashboard, kus fookus on andmetel.