## Week 8 — Python API-d ja pipeline'id

### Minu roll
Minu roll: Visualization + Saving (Roll C)

### Ülesande kirjeldus

SISEND:
- Roll B töödeldud DataFrame'id (koondandmed ja KPI-d)

VÄLJUND:
- `visualize_export.py` — diagrammifunktsioonid + eksport

---

## Minu ülesanne

Selle nädala jooksul töötasin Roll C mooduliga. Minu ülesanne oli luua Plotly visualiseerimised töödeldud andmetest ning eksportida tulemused CSV ja HTML failidesse.

Loodud funktsioonid:
- `create_weekly_chart(df_weekly)` — nädalase käibe joondiagramm
- `create_kpi_summary(kpis)` — KPI kokkuvõtte diagramm
- `export_results(df_weekly, kpis)` — salvestab CSV ja HTML failid output kausta
- Google Chat webhook teavituse näidisfunktsioon

---

## Meeskonna tulemuste kokkuvõte

Meeskond ehitas automatiseeritud data pipeline’i, mis:

1. Pärib andmed Supabase API-st
2. Puhastab ja valideerib andmed pandas funktsioonidega
3. Liidab müügi- ja kliendiandmed
4. Arvutab KPI-d ja nädalased koondnäitajad
5. Loob Plotly diagrammid
6. Salvestab tulemused CSV ja HTML failidesse
7. Käivitub ühe käsuga läbi `pipeline.py`

Pipeline jooksis edukalt algusest lõpuni ning genereeris automaatselt järgmised väljundfailid:

- `weekly_results_20260522_1209.csv`
- `weekly_revenue_20260522_1209.html`
- `kpi_summary_20260522_1209.html`

Pipeline logidest oli näha, et süsteem laadis Supabase API kaudu üle 10 000 müügirea ning töötles neist edukalt 8947 kirjet pärast andmete puhastamist ja valideerimist. :contentReference[oaicite:0]{index=0}

Lõplikud KPI tulemused:
- Total revenue: 2 675 896.82 EUR
- Unique customers: 2540
- Average order value: 299.08 EUR
- Total orders: 8947

CSV fail sisaldas järgmisi veerge:
- `sale_date`
- `tulu`
- `tellimuste_arv`
- `keskmine_tellimus`

Näide CSV andmetest:

| sale_date | tulu | tellimuste_arv | keskmine_tellimus |
|------------|------|----------------|-------------------|
| 2023-01-01 | 1108.73 | 1 | 1108.73 |
| 2023-01-08 | 4465.85 | 3 | 1488.62 |
| 2023-01-15 | 7245.42 | 5 | 1449.08 |

Nädalase käibe diagramm visualiseeris müügitulu muutusi ajas ning võimaldas kiiresti märgata aktiivsemaid müügiperioode. KPI summary diagramm koondas peamised ärinäitajad ühte vaatesse ja võimaldas kiiresti võrrelda:
- kogukäivet
- klientide arvu
- keskmist tellimuse väärtust
- tellimuste koguarvu

Projektis kasutati logging süsteemi, mis salvestas pipeline’i kõik etapid alates API päringutest kuni failide eksportimiseni. Pipeline töötas edukalt vähem kui 3 sekundiga. :contentReference[oaicite:1]{index=1}

---

## Logging väljund

Pipeline logging näitas kogu protsessi edenemist:

```text
INFO - Starting pipeline execution
INFO - Extract: get data from source
INFO - Data extraction completed
INFO - Transform: Start cleaning and processing data
INFO - Tables cleaned successfully
INFO - Tables merged successfully
INFO - Calculations executed successfully
INFO - Data transformation completed
INFO - Visualizations created successfully
INFO - Results exported successfully to: output
INFO - Pipeline execution completed in (2.32s)