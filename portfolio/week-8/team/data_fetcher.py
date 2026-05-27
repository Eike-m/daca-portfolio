# ROLL: API Query (Andmete pärimine)
# UrbanStyle OÜ — Supabase andmete pärimine
# Väljund: 3 funktsiooni, mis tagastavad DataFrame'e

import os

import pandas as pd
from dotenv import load_dotenv
from supabase import create_client, Client


# Samm 1: Lae .env fail ja loo Supabase client
load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_KEY")

try:
    supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
    print("Supabase ühendus loodud.")
except Exception as e:
    print(f"Viga Supabase ühenduse loomisel: {e}")
    print("Kontrolli .env failis SUPABASE_URL ja SUPABASE_KEY väärtusi.")


# Abifunktsioon: pagination kõikidele tabelitele
def fetch_all_rows(table_name: str) -> pd.DataFrame:
    """
    Pärib Supabase tabelist kõik read paginationiga.
    Vajalik, sest API võib vaikimisi tagastada ainult 1000 rida.
    """

    try:
        all_rows = []
        page_size = 1000
        start = 0

        while True:
            end = start + page_size - 1

            response = (
                supabase.table(table_name)
                .select("*")
                .range(start, end)
                .execute()
            )

            data = response.data
            all_rows.extend(data)

            if len(data) < page_size:
                break

            start += page_size

        df = pd.DataFrame(all_rows)
        print(f"{table_name}: laaditud kokku {len(df)} rida")

        return df

    except Exception as e:
        print(f"Viga tabeli {table_name} pärimisel: {e}")
        return pd.DataFrame()


# Samm 2: Müügiandmete pärimine kuupäevafiltritega + pagination
def fetch_sales(start_date: str, end_date: str) -> pd.DataFrame:
    """
    Pärib müügiandmed Supabase'ist vahemikus start_date kuni end_date.
    Kasutab paginationit, et saada kätte ka rohkem kui 1000 rida.
    """

    try:
        all_rows = []
        page_size = 1000
        start = 0

        while True:
            end = start + page_size - 1

            response = (
                supabase.table("sales")
                .select("*")
                .gte("sale_date", start_date)
                .lte("sale_date", end_date)
                .range(start, end)
                .execute()
            )

            data = response.data
            all_rows.extend(data)

            if len(data) < page_size:
                break

            start += page_size

        df_sales = pd.DataFrame(all_rows)

        if df_sales.empty:
            print("Hoiatus: fetch_sales tagastas tühja DataFrame. Kontrolli kuupäevavahemikku.")
        else:
            print(f"Müügiandmeid laaditud kokku: {len(df_sales)} rida")

        return df_sales

    except Exception as e:
        print(f"Viga müügiandmete pärimisel: {e}")
        print("Kontrolli API tunnuseid ja andmebaasi ühendust.")
        return pd.DataFrame()


# Samm 3: Kliendiandmete pärimine + pagination
def fetch_customers() -> pd.DataFrame:
    """
    Pärib kõik kliendiandmed Supabase'ist koos paginationiga.
    """

    df_customers = fetch_all_rows("customers")

    if df_customers.empty:
        print("Hoiatus: fetch_customers tagastas tühja DataFrame.")

    return df_customers


# Samm 4: Tooteandmete pärimine + pagination
def fetch_products() -> pd.DataFrame:
    """
    Pärib kõik tooteandmed Supabase'ist koos paginationiga.
    """

    df_products = fetch_all_rows("products")

    if df_products.empty:
        print("Hoiatus: fetch_products tagastas tühja DataFrame.")

    return df_products


# Samm 5: Testi kõiki funktsioone
if __name__ == "__main__":

    print("\n=== MÜÜGIANDMED ===")
    df_sales = fetch_sales("2023-01-01", "2026-05-22")
    print("Ridade arv:", len(df_sales))
    print(df_sales.head())

    print("\n=== KLIENDIANDMED ===")
    df_customers = fetch_customers()
    print("Ridade arv:", len(df_customers))
    print(df_customers.head())

    print("\n=== TOOTEANDMED ===")
    df_products = fetch_products()
    print("Ridade arv:", len(df_products))
    print(df_products.head())