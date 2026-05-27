"""ALAÜLESANDE KAART - Roll D: Automation Script"""

"""ÜLESANNE:
Ühenda rollide A, B ja C moodulid üheks pipeline'iks. Lisa
logimine ja ajastamisloogika. Marko tahab, et kogu protsess
käivituks ühe käsuga.

SISEND: Rollide A, B, C funktsioonid (import)
VÄLJUND: pipeline.py — orkestreerija: extract -> transform -> export
"""

import time
from datetime import datetime
import logging
import sys
from pathlib import Path


"""⚠️NOTE! Enne pipeline function RUN käivitamist on vaja "Samm 1: Extract" all määrata raporti alguskuupäev"""


# --- OUTPUT KAUST ---
BASE_DIR = Path(__file__).parent
output_path = BASE_DIR / "output"
output_path.mkdir(parents=True, exist_ok=True)


# --- LOGGING SETUP ---
log_file = output_path / f"pipeline_{datetime.now().strftime('%Y_%m_%d')}.log"

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)-8s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    handlers=[
        logging.FileHandler(log_file, encoding="utf-8"),
        logging.StreamHandler(sys.stdout)
    ]
)

logger = logging.getLogger(__name__)


# --- DATE ARGUMENT PARSING ---
def get_report_date():
    if "--date" in sys.argv:
        date_index = sys.argv.index("--date") + 1
        return sys.argv[date_index]
    return datetime.now().strftime('%Y-%m-%d')


report_date = get_report_date()
logger.info(f"Genereerin raporti seisuga: {report_date}")


# --- IMPORTS ---
from data_fetcher import fetch_sales, fetch_customers, fetch_products
from transform import clean_data, calculate_kpis, merge_datasets, calculate_weekly_aggregates
from visualize_export import create_weekly_chart, create_kpi_summary, export_results


# --- PIPELINE FUNCTION ---
def run_pipeline():
    start_time = time.time()
    logger.info("Starting pipeline execution")

    try:
        # --- Samm 1: Extract ---
        logger.info("Extract: get data from source")

        start_date = "2023-01-01"
        end_date = report_date

        df_sales = fetch_sales(start_date, end_date)
        df_customers = fetch_customers()
        df_products = fetch_products()

        logger.info("Data extraction completed")

        # --- Validate Extract ---
        logger.info("Validate Extract: checking dataframes")

        if df_sales.empty or df_customers.empty or df_products.empty:
            logger.error("Validate Extract: One or more dataframes are empty.")
            return

        # --- Samm 2: Transform ---
        logger.info("Transform: Start cleaning and processing data")

        df_customers_clean = clean_data(df_customers)
        df_sales_clean = clean_data(df_sales)

        logger.info("Tables cleaned successfully")

        df_merged = merge_datasets(df_sales_clean, df_customers_clean)
        logger.info("Tables merged successfully")

        df_kpis = calculate_kpis(df_merged)
        df_weekly = calculate_weekly_aggregates(df_merged)

        logger.info("Calculations executed successfully")
        logger.info("Data transformation completed")

        # --- Validate Transform ---
        logger.info("Validate: check data quality")

        if df_merged.empty or df_weekly.empty:
            logger.error("VALIDATE: One or more dataframes are empty.")
            return

        # --- Samm 3: Load/Export ---
        logger.info("Load: create visualizations and export results to output directory")

        try:
            create_weekly_chart(df_weekly)
            create_kpi_summary(df_kpis)
            logger.info("Visualizations created successfully")
        except Exception as e:
            logger.warning(f"Error occurred while creating visualizations: {str(e)}. Continuing with export.")

        try:
            export_results(df_weekly, df_kpis, output_dir=output_path)
            logger.info(f"Results exported successfully to: {output_path}")
        except Exception as e:
            logger.error(f"Error occurred while exporting results: {str(e)}")
            return

        elapsed_time = time.time() - start_time
        logger.info(f"Pipeline execution completed in ({elapsed_time:.2f}s)")

    except Exception as e:
        logger.error(f"Pipeline execution failed: {str(e)}")


# --- MAIN ---
if __name__ == "__main__":
    run_pipeline()


# DEMO ETTEVALMISTUS

# Peamine järeldus:
# Pipeline töötab algusest lõpuni ja automatiseerib
# andmete pärimise, töötlemise, visualiseerimise ning eksportimise.

# Otsus:
# Marko ei pea enam raportit käsitsi koostama,
# vaid saab kasutada automaatselt loodud CSV ja HTML väljundeid.

# Mis meid üllatas:
# Üllatas, kui kiiresti saab eraldi moodulid
# üheks töötavaks pipeline’iks ühendada.

# SÜNTEESIKÜSIMUSED

# 1. Kui palju aega pipeline kokku hoiab?
# Pipeline hoiab aega kokku, sest käsitsi andmete laadimine,
# puhastamine, KPI arvutamine ja eksportimine võiks võtta
# umbes 3–4 tundi nädalas, kuid automatiseeritud pipeline
# teeb selle mõne sekundiga ühe käsuga.

# 2. Milline soovitus Markole automatiseerimise laiendamiseks?
# Pipeline’ile võiks lisada automaatse weekly emaili või
# Google Chat teavituse, mis saadab KPI kokkuvõtte ja
# hoiatab näiteks käibe languse või churn riski korral.

# 3. Mis juhtub, kui Supabase on maas?
# Kui Supabase ühendus ebaõnnestub, siis try/except
# veakäsitlus logib vea ning pipeline ei crash’i täielikult.
# Tulevikus võiks lisada fallback lahenduse või retry loogika.

# Pipeline töötab õigesti: ta tõmbab andmed API-st, arvutab nädalase tulu ja salvestab tulemuse HTML graafikuna ning CSV failina.