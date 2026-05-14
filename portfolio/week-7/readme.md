# Nädal 7: Python Pandas — RFM kliendisegmenteerimine

## Minu roll

### Roll D — Visualization (Visualiseerimine ja leiud)

Minu ülesanne oli luua Plotly abil kliendisegmente visualiseerivad diagrammid ning koostada UrbanStyle’i tootehaldurile Marko Saarele ärilised järeldused ja soovitused.

Loodud visualiseerimised:
- kliendisegmentide jaotus,
- hajuvusdiagramm (Recency vs Monetary),
- TOP 10 VIP klienti kogukulutuse järgi,
- kaalutud RFM segmentide jaotus.

Lisaks koostasin:
- äritõlgenduse Markole,
- VIP programmi soovitused,
- win-back kampaania soovitused,
- nurture programmi ideed.

---

## Peamised leiud

- VIP Champions kliendid moodustasid kõige väärtuslikuma kliendisegmendi ning nende kogukulutus jäi enamasti vahemikku 20 000 € – 30 000 €.

- At Risk segment sisaldas üle 500 kliendi, mis näitas vajadust kiirete win-back kampaaniate järele.

- Kaalutud RFM mudel näitas, et kliendi rahaline väärtus mõjutab segmenteerimist oluliselt rohkem kui ainult ostusagedus või viimase ostu aeg.

- TOP 10 VIP klientide analüüs näitas, et suurimate klientide individuaalne kogukulutus ulatus ligi 28 000 euroni.

---

## AI kasutamine

Kasutasin AI abi:
- Plotly diagrammide kujunduse täiustamiseks,
- annotatsioonide ja telgede paigutuse optimeerimiseks,
- pandas ja Plotly süntaksi kontrollimiseks,
- markdown sektsioonide ja äritõlgenduste sõnastamiseks.

AI aitas parandada visualiseerimiste professionaalset kvaliteeti ning kiirendas tehniliste probleemide lahendamist.

# GT - UrbanStyle RFM kliendisegmenteerimine

## Projekti eesmärk

Selle projekti eesmärk oli analüüsida UrbanStyle’i kliendiandmeid Python pandas abil ning jagada kliendid RFM (Recency, Frequency, Monetary) meetodi põhjal erinevatesse segmentidesse.

Analüüsi eesmärk oli aidata UrbanStyle’i tootehalduril Marko Saarel mõista:
- kes on ettevõtte kõige väärtuslikumad kliendid,
- millised kliendid on ostmise lõpetamise riskis,
- kuidas luua personaalsemaid turunduskampaaniaid.

---

# Notebook’i struktuur

## 1. Sissejuhatus

Selles markdown-lahtris kirjeldatakse projekti eesmärki, Marko väljakutset ning RFM analüüsi ärilist eesmärki.

Miks see vajalik on:
- annab notebook’ile konteksti,
- selgitab analüüsi eesmärki,
- muudab töö arusaadavaks teistele lugejatele.

---

## 2. Data Loading — Andmete laadimine ja liitmine

Selles sektsioonis laaditi:
- müügiandmed (`sales.csv`)
- kliendiandmed (`customers.csv`)

ning ühendati need üheks terviklikuks DataFrame’iks.

Kasutatud funktsioonid:
- `pd.read_csv()`
- `pd.merge()`

Miks see vajalik on:
- ühendada kliendi- ja müügiinfo,
- luua alus edasiseks analüüsiks,
- kontrollida andmete kvaliteeti (`shape`, `dtypes`, `head()`).

---

## 3. Data Cleaning — Andmete puhastamine

Selles etapis puhastati andmed enne analüüsi.

Teostatud tegevused:
- duplikaatide eemaldamine,
- NULL väärtuste kontroll,
- kuupäevade teisendamine datetime formaati,
- vigaste ja negatiivsete väärtuste eemaldamine.

Miks see vajalik on:
- tagada korrektne ja usaldusväärne analüüs,
- vältida vigaseid ärijäreldusi,
- parandada andmete kvaliteeti.

---

## 4. RFM Analysis — Kliendisegmenteerimine

Selles sektsioonis arvutati iga kliendi kohta:
- Recency — päevad viimasest ostust,
- Frequency — ostude arv,
- Monetary — kogukulutus.

Kasutatud funktsioonid:
- `groupby()`
- `agg()`
- `pd.qcut()`

Klientidele määrati:
- RFM skoorid,
- kliendisegmendid.

Miks see vajalik on:
- tuvastada kõige väärtuslikumad kliendid,
- leida riskikliendid,
- toetada turundusotsuseid.

---

## 5. Visualization — Visualiseerimine

Selles osas loodi Plotly abil mitu diagrammi:
1. Kliendisegmentide jaotus
2. Hajuvusdiagramm (Recency vs Monetary)
3. TOP 10 VIP klienti
4. Kaalutud RFM segmentide jaotus

### Kliendisegmentide jaotus

![Segmentide jaotus](segmentide_jaotus.png)

### Hajuvusdiagramm

![Scatter plot](scatter_plot.png)

### TOP 10 VIP klienti

![TOP 10 VIP](top10_vip.png)

### Kaalutud RFM segmenteerimine

![Weighted RFM](weighted_rfm.png)

Miks see vajalik on:
- muuta andmed visuaalselt arusaadavaks,
- aidata tuvastada olulisi mustreid,
- toetada juhtimisotsuseid.

---

## 6. Edasijõudnute tase — Kaalutud RFM

Selles etapis loodi:
- kaalutud RFM skoor,
- detailsem segmenteerimine,
- CSV eksport turundusmeeskonna jaoks.

Monetary skoor sai 2x kaalu, sest kliendi rahaline väärtus on ettevõtte jaoks kõige olulisem mõõdik.

Loodi järgmised segmendid:
- VIP Champions
- Loyal Customers
- Regular Customers
- New Customers
- At Risk
- Lost

Kõik segmendid eksporditi faili:
`rfm_segments.csv`

---

## 7. Äritõlgendus ja soovitused

Selles sektsioonis koostati:
- peamised ärilised järeldused,
- soovitused Markole,
- VIP programmi ideed,
- win-back kampaaniad,
- nurture programmi soovitused.

Miks see vajalik on:
- siduda andmeanalüüs reaalse äriväärtusega,
- toetada ettevõtte turundusstrateegiat,
- aidata kasvatada kliendilojaalsust ja käivet.

---

## 8. Meeskonna refleksioon

Viimases markdown-lahtris analüüsis meeskond:
- mis oli suurim üllatus,
- milline on peamine soovitus Markole,
- milliseid lisaandmeid oleks tulevikus vaja.

Miks see vajalik on:
- hinnata analüüsi kvaliteeti,
- mõelda järgmiste analüüside parendustele,
- arendada analüütilist mõtlemist.

---

## AI kasutamine

AI-d kasutati:
- pandas süntaksi kontrollimiseks,
- Plotly visualiseerimiste täiustamiseks,
- annotatsioonide ja kujunduse optimeerimiseks,
- markdown sektsioonide sõnastamiseks,
- README koostamiseks.

AI aitas kiirendada tehnilist tööprotsessi ning parandada visualiseerimiste professionaalset kvaliteeti.

