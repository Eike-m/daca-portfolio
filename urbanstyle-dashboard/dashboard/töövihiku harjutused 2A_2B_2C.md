# Dashboard'i paigutuse kavandamine

## Harjutus 2A: Shu — analüüsi malli järgi  
**Ülesanne:** Vaata alltoodud dashboard'i paigutust ja vasta küsimustele.

# UrbanStyle Investor Dashboard — Q4 2024
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

### Vastused

**Milline element on kõige olulisem (esimesena nähtav)?**  
€305K käive  

**Miks on joondiagramm suurim element?**  
Näitab trendi ajas — kas äri kasvab või mitte  

**Miks on sektordiagrammil ainult 4 kategooriat?**  
Välja on toodud peamised (TOP) linnad, et hoida visuaal selge  

**Kus on filtrid ja miks just seal?**  
All — need on abistavad, mitte esmane info  

**Kas see dashboard vastab Kristi 4 küsimusele? Millisele küsimusele vastab iga element?**  
- **Kas me kasvame?** → Joondiagramm ja +15% kasv  
- **Mis tooted müüvad?** → Tulpdiagramm  
- **Kust tulevad kliendid?** → Sektordiagramm  
- **Kas marketing töötab?** → Keskmine tellimus + käibe kasv + trend  

---

## Harjutus 2C: Rakendus — Data-ink ratio audit  

**Ülesanne:** All on kirjeldatud "halb" dashboard. Leia kõik chart junk elemendid ja kirjelda, milline näeks see välja pärast puhastamist.

### Halva dashboard'i kirjeldus:
- 3D tulpdiagramm gradienttäitega  
- Iga tulba taga vari (drop shadow)  
- Heleroosa mustriga taust  
- Legend kordab x-telje silte  
- 15 ruudustikujoont  
- Numbrid 2 komakohaga (€32 156,78)  
- Pealkiri kaldkirjas ja allajoonitud  
- 3 rida väikekirjas autoriinfot  

### Chart junk elemendid:
- 3D efekt  
- Gradienttäide  
- Varjud  
- Mustriline taust  
- Liigne legend  
- Liiga palju ruudustikujooni  
- Liigne täpsus numbrites  
- Liigne teksti stiil (kaldkiri + allajoon)  
- Ebavajalik autoriinfo  

### Puhastatud versioon (kirjeldus):
Eemaldasin 3D efektid, varjud ja mustrilise tausta, et visuaal oleks lihtne ja selge. Vä