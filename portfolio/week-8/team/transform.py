# ROLL: Data Processing (Andmete töötlemine)
# UrbanStyle OÜ — universaalsed andmete transformeerimisfunktsioonid

import pandas as pd


# Samm 1: Uuenenud ja paindlik andmete puhastamine
def clean_data(df: pd.DataFrame) -> pd.DataFrame:
    """
    Puhastab DataFrame'i universaalselt: eemaldab duplikaadid ja
    töötleb veerge ainult siis, kui need on tabelis olemas.
    """
    print("--- clean_data() käivitatud ---")
    df_clean = df.copy()

    # 1. Eemalda duplikaadid (kehtib igale tabelile)
    algne_read = df_clean.shape[0]
    df_clean = df_clean.drop_duplicates()
    print(f"Eemaldatud {algne_read - df_clean.shape[0]} duplikaatset rida.")

    # 2. Puhasta kuupäevad AINULT siis, kui vastav veerg on olemas
    if "sale_date" in df_clean.columns:
        df_clean["sale_date"] = pd.to_datetime(df_clean["sale_date"])
        # Kui tegu on müügitabeliga, eemaldame read, kus kuupäev puudub
        df_clean = df_clean.dropna(subset=["sale_date"])

    if "registration_date" in df_clean.columns:
        df_clean["registration_date"] = pd.to_datetime(df_clean["registration_date"])

    # 3. Käitle kriitilised NULL väärtused ilma kõiki andmeid kaotamata
    if "customer_id" in df_clean.columns:
        # Müügireal või kliendireal peab ID olemas olema, muidu on rida kasutu
        df_clean = df_clean.dropna(subset=["customer_id"])

    # 4. Kontrolli negatiivseid hindu ainult müügitabelis
    if "total_price" in df_clean.columns:
        df_clean = df_clean[df_clean["total_price"] > 0]

    print(f"Puhastamine lõpetatud. Ridu järele jäänud: {df_clean.shape[0]}")
    return df_clean


# Samm 2: Nädalased koondnäitajad (Müügitabelile)
def calculate_weekly_aggregates(df: pd.DataFrame) -> pd.DataFrame:
    """
    Grupeerib andmed nädalate kaupa ja arvutab tulu ning tellimuste statistika.
    """
    print("--- calculate_weekly_aggregates() ---")

    if "sale_date" not in df.columns or "total_price" not in df.columns:
        print("Viga: Nädalase koondi jaoks puuduvad vajalikud veerud!")
        return pd.DataFrame()

    weekly = (
        df.resample("W", on="sale_date")
        .agg(
            tulu=("total_price", "sum"),
            tellimuste_arv=("sale_id", "count"),
            keskmine_tellimus=("total_price", "mean"),
        )
        .reset_index()
    )

    weekly["keskmine_tellimus"] = weekly["keskmine_tellimus"].round(2)
    return weekly


# Samm 3: KPI-de arvutamine (Müügitabelile)
def calculate_kpis(df: pd.DataFrame) -> dict:
    """
    Arvutab peamised ärinäitajad (KPI-d) ja tagastab sõnastiku.
    """
    print("--- calculate_kpis() ---")

    kpis = {
        "total_revenue": round(df["total_price"].sum(), 2),
        "unique_customers": df["customer_id"].nunique(),
        "avg_order_value": round(df["total_price"].mean(), 2),
        "total_orders": len(df),
    }

    print("Arvutatud KPI-d:", kpis)
    return kpis


# Samm 4: Andmestike liitmine
def merge_datasets(df_sales: pd.DataFrame, df_customers: pd.DataFrame) -> pd.DataFrame:
    """
    Liidab müügi- ja kliendiandmed customer_id järgi.
    """
    print("--- merge_datasets() ---")

    df_merged = pd.merge(df_sales, df_customers, on="customer_id", how="left")
    print(f"Liidetud andmestiku kuju (shape): {df_merged.shape}")

    return df_merged


# Samm 5: Testplokk näidisandmetega
if __name__ == "__main__":
    print("=== TESTIMINE ALANUD ===")

    # Test-müügiandmed
    df_sales_test = pd.DataFrame(
        {
            "sale_id": [1, 2, 3, 3],
            "customer_id": [101, 102, 103, 103],
            "sale_date": ["2024-06-01", "2024-06-08", "2024-06-15", "2024-06-15"],
            "total_price": [120.0, 50.0, 200.0, 200.0],
        }
    )

    # Test-kliendiandmed (siin pole kuupäevi ega hindu!)
    df_customers_test = pd.DataFrame(
        {
            "customer_id": [101, 102, 103],
            "name": ["Alice", "Bob", "Carol"],
            "city": ["Tallinn", "Tartu", "Pärnu"],
        }
    )

    # Proovime puhastada MÕLEMAT tabelit sama funktsiooniga
    print("\n[Test 1] Puhastame müügitabeli:")
    mueugid_puhtad = clean_data(df_sales_test)

    print("\n[Test 2] Puhastame klienditabeli (Enam ei teki viga!):")
    kliendid_puhtad = clean_data(df_customers_test)

    print("\n=== TESTID LÄBITUD EDUKALT ===")