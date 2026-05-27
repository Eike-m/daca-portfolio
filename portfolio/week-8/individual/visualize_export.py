# Roll C: Visualization + Saving

# ÜLESANNE:
# Loo Plotly diagrammid töödeldud andmetest ja ekspordi tulemused failidesse (CSV + HTML). Marko tahab visuaalset ülevaadet, mida
# saab jagada kogu meeskonnaga.

# SISEND: Roll B töödeldud DataFrame'id (koondandmed, KPI-d)
# VÄLJUND: visualize_export.py — diagrammifunktsioonid + eksport

# Kirjuta create_weekly_chart(df_weekly) — Plotly joondiagramm nädalastest tululiikumistest

import os
from pathlib import Path
from datetime import datetime

import pandas as pd
import plotly.express as px
import requests

def create_weekly_chart(df_weekly):
    """Loob nädalase tulu joondiagrammi."""

    # Loome Plotly joondiagrammi
    fig = px.line(

        # DataFrame nädalaste andmetega
        df_weekly,

        # X-telg = kuupäev/nädal
        x="sale_date",

        # Y-telg = tulu
        y="tulu",

        # Diagrammi pealkiri
        title="Nädalane tulu"
    )

    # Tagastame valmis diagrammi objekti
    return fig

# Selgitus:

# Funktsioon create_weekly_chart() võtab sisendiks
# nädalaste koondandmete DataFrame'i.

# Plotly Express px.line() loob joondiagrammi,
# kus X-teljel on kuupäevad ja Y-teljel tulu.

# Funktsioon tagastab fig objekti,
# mida saab hiljem HTML faili salvestada.

# Kirjuta create_kpi_summary(kpis) — Plotly indicator või tabel, mis näitab peamisi KPI-sid

def create_kpi_summary(kpis):
    """Loob KPI kokkuvõtte diagrammi."""

    # Teisendame KPI dictionary DataFrame'iks
    kpi_df = pd.DataFrame([

        # Iga rida = üks KPI mõõdik
        {"metric": "Total revenue", "value": kpis.get("total_revenue")},
        {"metric": "Unique customers", "value": kpis.get("unique_customers")},
        {"metric": "Average order value", "value": kpis.get("avg_order_value")},
        {"metric": "Total orders", "value": kpis.get("total_orders")}

    ])

    # Loome Plotly tulpdiagrammi KPI-de jaoks
    fig = px.bar(

        # Kasutame KPI DataFrame'i
        kpi_df,

        # X-telg = KPI nimi
        x="metric",

        # Y-telg = KPI väärtus
        y="value",

        # Diagrammi pealkiri
        title="KPI kokkuvõte"
    )

    # Tagastame diagrammi objekti
    return fig

# Selgitus:

# Funktsioon create_kpi_summary() võtab sisendiks
# KPI dictionary ehk peamised ärinäitajad.

# KPI-d teisendatakse DataFrame'iks,
# et Plotly saaks neid diagrammina kuvada.

# px.bar() loob tulpdiagrammi,
# mis näitab peamisi KPI mõõdikuid.

# Funktsioon tagastab fig objekti,
# mida saab hiljem HTML faili salvestada.

# Lisa email/Google Workspace Chat teavitusfunktsioon, mis saadab pipeline'i õnnestumise teatise koos kokkuvõtvate numbritega (nt smtplib või lihtne webhook).

def send_chat_notification(kpis):
    """Valmistab ette Google Chat webhook teavituse."""

    webhook_url = "PASTE_WEBHOOK_URL_SIIA"

    message = {
        "text":
        f"Pipeline õnnestus!\n"
        f"Kogukäive: {kpis.get('total_revenue')} EUR\n"
        f"Kliente: {kpis.get('unique_customers')}\n"
        f"Keskmine tellimus: {kpis.get('avg_order_value')} EUR\n"
        f"Tellimusi kokku: {kpis.get('total_orders')}"
    }

    print("[NOTIFICATION]")
    print(message)

    # Päris saatmine oleks:
    # requests.post(webhook_url, json=message)

#  Kirjuta export_results(df, output_dir) — salvesta DataFrame CSV-sse ajatempliga failinimega + diagrammid HTML-ina

def export_results(df_weekly, kpis, output_dir=None):
    """Salvestab Roll B tulemused DataFrame'i CSV-sse ja diagrammid HTML failidena."""

# Kui output_dir pole eraldi antud, siis loome output kausta samasse kohta, kus see fail asub
    if output_dir is None:
        output_dir = Path(__file__).parent / "output"

# Loome output kausta, kui seda veel ei eksisteeri
    output_dir.mkdir(parents=True, exist_ok=True)

# Ajatempel aitab vältida failide ülekirjutamist
    date_str = datetime.now().strftime("%Y%m%d_%H%M")

# Loome nädalase tulu joondiagrammi
    weekly_chart = create_weekly_chart(df_weekly)

# Loome KPI kokkuvõtte diagrammi
    kpi_chart = create_kpi_summary(kpis)

# Salvestame nädalased andmed CSV failina
    df_weekly.to_csv(
        output_dir / f"weekly_results_{date_str}.csv",
        index=False
    )

# Salvestame nädalase tulu diagrammi HTML failina
    weekly_chart.write_html(
        output_dir / f"weekly_revenue_{date_str}.html"
    )

# Salvestame KPI diagrammi HTML failina
    kpi_chart.write_html(
        output_dir / f"kpi_summary_{date_str}.html"
    )
# Valmistame ette Google Chat teavituse
    send_chat_notification(kpis)

# Kuvame terminalis kinnituse
    print("[EXPORT] CSV ja HTML failid salvestatud output kausta")

# Testi: käivita ja kontrolli, et failid tekivad output/ kausta

if __name__ == "__main__":

    df_weekly_test = pd.DataFrame({
        "sale_date": ["2024-06-02", "2024-06-09", "2024-06-16"],
        "tulu": [1200, 1800, 1500],
        "tellimuste_arv": [10, 15, 12],
        "keskmine_tellimus": [120, 120, 125]
    })

    kpis_test = {
        "total_revenue": 4500,
        "unique_customers": 25,
        "avg_order_value": 121.62,
        "total_orders": 37
    }

    export_results(df_weekly_test, kpis_test)

# INTEGRATSIOONIKONTROLL:
# [x] visualize_export.py aktsepteerib Roll B väljundit
# [x] df_weekly veerud sobivad Plotly diagrammile
# [x] KPI dictionary võtmed sobivad KPI summary funktsioonile


