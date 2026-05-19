## Samm 3: Supabase Python Client
from supabase import create_client
from dotenv import load_dotenv
import os
import pandas as pd

# 1. Ühenda Supabase'iga
load_dotenv()
url = os.getenv("SUPABASE_URL")
key = os.getenv("SUPABASE_KEY")
supabase = create_client(url, key)

# 2. Lihtne päring — kõik tellimused
response = supabase.table('sales').select('*').execute()
df = pd.DataFrame(response.data)
print(f"Laaditud {len(df)} tellimust")
print(df.head())

## API päringute harjutused
## Harjutus 1A:Kopeeri järgmine kood ja käivita see. Kui sul pole Supabase ühendust, kasuta alternatiivset varianti näidisandmetega. 
## Variant A — Supabase ühendusega
from supabase import create_client
from dotenv import load_dotenv
import os, pandas as pd

load_dotenv()
supabase = create_client(os.getenv("SUPABASE_URL"), os.getenv("SUPABASE_KEY"))
df_orders = pd.DataFrame(supabase.table('sales').select('*').execute().data)
df_customers = pd.DataFrame(supabase.table('customers').select('*').execute().data)
print(f"Tellimusi: {len(df_orders)}, Kliente: {len(df_customers)}")

## Variant B — ilma Supabase'ita (näidisandmed):
import pandas as pd

# Simuleeri API vastust (sama struktuur, mis Supabase tagastaks)
orders_data = [{"sale_id": i, "customer_id": 1000 + (i % 7) + 1,
     "sale_date": f"2024-{(i % 12)+1:02d}-{(i % 28)+1:02d}",
     "total_price": round(30 + (i * 17.3) % 200, 2)} for i in range(50)]

customers_data = [
    {"customer_id": 1001, "first_name": "Juri", "city": "Tallinn"},
    {"customer_id": 1002, "first_name": "Kati", "city": "Tartu"},
    {"customer_id": 1003, "first_name": "Maris", "city": "Tallinn"},
    {"customer_id": 1004, "first_name": "Peeter", "city": "Parnu"},
    {"customer_id": 1005, "first_name": "Liina", "city": "Tartu"},
    {"customer_id": 1006, "first_name": "Andres", "city": "Parnu"},
    {"customer_id": 1007, "first_name": "Tiina", "city": "Tallinn"},
]

df_orders = pd.DataFrame(orders_data)
df_customers = pd.DataFrame(customers_data)

print(f"Tellimusi: {len(df_orders)}, Kliente: {len(df_customers)}")
print(df_orders.head())

# Küsimused tulemuse kohta:
# Mitu tellimust laaditi? - 50
# Mitu klienti on andmestikus? - 7 
# Mis veergude tüübid on DataFrame'is (dtypes)?
print(df_orders.dtypes)
# sale_id - int64
# customer_id - int64
# sale_date - str
# total_price - float64
# Mis erinevust märkad API laadimise ja CSV laadimise vahel? - API kaudu tulevad andmed otse andmebaasist reaalajas, CSV puhul tuleb fail enne käsitsi alla laadida. 
# API on automatiseerimiseks mugavam ja andmed on alati värskemad.


#Harjutus 1B: Ha — filtreeri ja kombineeri 
# Ülesanne: Kirjuta kood, mis toob Supabase'ist (või näidisandmetest) ainult konkreetse linna tellimused ja arvutab kokkuvõtte.
# Variant A (Supabase): 
# .select('*').eq('city', 'Tallinn').order('total_price', desc=True)
# Variant B (pandas):
df_tallinn = df_orders.merge(df_customers, on='customer_id')
df_tallinn = df_tallinn[df_tallinn['city'] == 'Tallinn'].sort_values('total_price', ascending=False)
print(f"Tallinna tellimusi: {len(df_tallinn)}, Käive: {df_tallinn['total_price'].sum():.2f} EUR")

# Nüüd kirjuta ISE: Too andmed teise linna (Tartu VÕI Pärnu) kohta ja arvuta: tellimuste arv, kogukäive, keskmine tellimus.
# Sinu kood:
df_tartu = df_orders.merge(df_customers, on='customer_id')

df_tartu = df_tartu[df_tartu['city'] == 'Tartu'].sort_values(
'total_price',
ascending=False
)

print(f"Tartu tellimusi: {len(df_tartu)}")
print(f"Kogukäive: {df_tartu['total_price'].sum():.2f} EUR")
print(f"Keskmine tellimus: {df_tartu['total_price'].mean():.2f} EUR")

# Juhivad küsimused:
# Milline linn oli suurema kogukäibega?
# Tallinn oli suurema kogukäibega.
#
# Kas API filter (.eq) on kiirem kui pandas filter? Miks?
# Jah, API filter on tavaliselt kiirem, sest andmebaasist tuuakse ainult vajalikud andmed.
#
# Millal on mõistlik filtreerida API tasemel vs pandas tasemel?
# API tasemel on mõistlik filtreerida siis, kui andmeid on palju.
# Pandas tasemel on mugavam filtreerida siis, kui andmed on juba Pythonisse laaditud.


# Harjutus 1C: Rakendus — loo oma päring 
# Ülesanne: Mõtle äriküsimusele, millele Marko vajaks vastust. Kirjuta API päring (või pandas filter), mis toob vajalikud andmed.
# Ideed:
# Viimase 30 päeva tellimused (kuupäevafiltriga)
# Ainult suured tellimused (total_price > 100)
# Konkreetse kliendi ostuajalugu

# Harjutus 1C: Ainult suured tellimused
# Äriküsimus: Millised tellimused on üle 100 euro?

large_orders = df_orders[df_orders["total_price"] > 100]

print("Suured tellimused üle 100 EUR:")
print(large_orders.head())
print(large_orders.shape)
print(large_orders.describe())

# Tulemused:
# Suuri tellimusi (>100 EUR) oli 30.
# Keskmine tellimus oli umbes 166.79 EUR.
# Kõige suurem tellimus oli 227.90 EUR.
#
# See on äriliselt kasulik, sest aitab leida kõrgema väärtusega oste
# ja mõista, millised tellimused toovad rohkem käivet.

# describe() andis:
# count → mitu tellimust
# mean → keskmine
# min/max → väikseim ja suurim tellimus
# std → kui erinevad tellimused omavahel on

# Concrete Practice: Automatiseerimise harjutused 
# Harjutus 2A: Ha — kirjuta oma esimene funktsioon 
# Ülesanne: Kopeeri ja käivita järgmine kood, mis sisaldab parameetritega raportifunktsiooni.
from datetime import datetime

def weekly_sales_report(df, report_date=None):
    """Genereeri iganädalane müügiraport.

    Args:
        df: DataFrame müügitellimustega
        report_date: Raporti kuupäev (vaikimisi täna)
    Returns:
        dict: Raporti kokkuvõte
    """
    if report_date is None:
        report_date = datetime.now().strftime('%Y-%m-%d')
    return {
        'report_date': report_date,
        'total_orders': len(df),
        'total_revenue': round(df['total_price'].sum(), 2),
        'avg_order': round(df['total_price'].mean(), 2),
    }

# Käivita
result = weekly_sales_report(df_orders)
for key, value in result.items():
    print(f"  {key}: {value}")

# Küsimused:
#
# Mis on funktsiooni report_date parameeter ja miks tal on vaikeväärtus?
# report_date määrab raporti kuupäeva. Vaikeväärtus on olemas selleks,
# et kui kasutaja ise kuupäeva ei anna, kasutatakse automaatselt tänast kuupäeva.
#
# Kuidas muuta funktsiooni nii, et see võtaks ka linna parameetri?
# Funktsioonile võiks lisada näiteks city parameetri ja filtreerida DataFrame selle järgi.
#
# Mis juhtub, kui df on tühi?
# Siis total_orders on 0 ja mean võib tagastada NaN väärtuse.

# Harjutus 2B: Ha — automatiseeri RFM arvutamine 
# Ülesanne: Kirjuta funktsioon, mis automatiseerib eelmise nädala RFM analüüsi. Funktsiooni sisend on DataFrame ja viitekuupäev, väljund on RFM DataFrame segmentidega.

def calculate_rfm(df, reference_date=None):
    """Arvuta RFM skoorid ja segmendid.

    Args:
        df: DataFrame tellimustega (veerud: customer_id, sale_date, total_price)
        reference_date: Viitekuupäev Recency arvutamiseks

    Returns:
        DataFrame: RFM skoorid ja segmendid iga kliendi kohta
    """

    import pandas as pd

    if reference_date is None:
        reference_date = pd.to_datetime('today')
    else:
        reference_date = pd.to_datetime(reference_date)

    df['sale_date'] = pd.to_datetime(df['sale_date'])

    # Recency: päevi viimasest ostust
    recency = df.groupby('customer_id')['sale_date'].max().reset_index()
    recency.columns = ['customer_id', 'last_purchase']

    recency['recency_days'] = (
        reference_date - recency['last_purchase']
    ).dt.days

    # Frequency: ostude arv
    frequency = (
        df.groupby('customer_id')
        .size()
        .reset_index(name='frequency')
    )

    # Monetary: kogukulutus
    monetary = (
        df.groupby('customer_id')['total_price']
        .sum()
        .reset_index()
    )

    monetary.columns = ['customer_id', 'monetary']

    # Liida kokku
    rfm = recency[['customer_id', 'recency_days']].merge(
        frequency,
        on='customer_id'
    ).merge(
        monetary,
        on='customer_id'
    )

    # Skooride määramine
    rfm['R_score'] = pd.qcut(
        rfm['recency_days'],
        q=3,
        labels=[3, 2, 1]
    ).astype(int)

    rfm['F_score'] = pd.qcut(
        rfm['frequency'].rank(method='first'),
        q=3,
        labels=[1, 2, 3]
    ).astype(int)

    rfm['M_score'] = pd.qcut(
        rfm['monetary'],
        q=3,
        labels=[1, 2, 3]
    ).astype(int)

    rfm['RFM_score'] = (
        rfm['R_score']
        + rfm['F_score']
        + rfm['M_score']
    )

    # Segmenteerimine
    def assign_segment(score):
        if score >= 8:
            return 'VIP Champions'
        elif score >= 6:
            return 'Loyal Customers'
        elif score >= 4:
            return 'Potential Customers'
        else:
            return 'At Risk'

    rfm['segment'] = rfm['RFM_score'].apply(assign_segment)

    return rfm


# Testi
rfm_result = calculate_rfm(
    df_orders,
    reference_date='2024-08-01'
)

print(rfm_result.sort_values('RFM_score', ascending=False))

print("\nSegmentide jaotus:")
print(rfm_result['segment'].value_counts())

# Juhivad küsimused:
#
# Miks on reference_date parameeter oluline?
# See on oluline, sest RFM recency arvutus sõltub kuupäevast.
# Kui kuupäev on parameetrina, saab sama funktsiooni kasutada eri aegadel.
#
# Kuidas muudaksid segmentide piire, kui UrbanStyle'il oleks 10000 klienti?
# Siis kasutaksin täpsemaid gruppe ja võib-olla rohkem segmente,
# sest suurema kliendibaasi puhul on vaja kliente detailsemalt eristada.
#
# Miks on see funktsiooni kujul parem kui W7 lahtine kood?
# Funktsiooni saab uuesti kasutada ja automaatselt käivitada.
# Ei pea iga kord sama koodi käsitsi uuesti kirjutama.

# Harjutus 2C: Rakendus — loo oma raportifunktsioon 
# Ülesanne: Mõtle ülesandele, mida Anna või Marko peab regulaarselt tegema. Kirjuta funktsioon, mis seda automatiseerib.
# Ideed:
# top_products_report(df, n=10) — TOP N toodete raport
# churn_risk_alert(df, days_threshold=60) — kliendid, kes pole N päeva ostnud
#city_comparison(df, cities=['Tallinn', 'Tartu']) — linnade võrdlus

def city_comparison(df_orders, df_customers, cities=['Tallinn', 'Tartu']):
    """Võrdleb linnade tellimuste arvu, kogukäivet ja keskmist tellimust."""

    df = df_orders.merge(df_customers, on='customer_id')

    city_data = df[df['city'].isin(cities)]

    result = city_data.groupby('city').agg(
        orders=('sale_id', 'count'),
        total_revenue=('total_price', 'sum'),
        avg_order=('total_price', 'mean')
    ).reset_index()

    return result


# Test 1
city_result = city_comparison(df_orders, df_customers)
print(city_result)

# Test 2
city_result_2 = city_comparison(df_orders, df_customers, cities=['Tallinn', 'Parnu'])
print(city_result_2)

# Kontrolltabel:
# Funktsioon võrdleb valitud linnade müügitulemusi.
# See on Markole kasulik, sest ta näeb, millistes linnades on rohkem tellimusi ja käivet.
# Funktsioonil on mitu parameetrit ja cities parameetril on vaikeväärtus.
# Funktsioon tagastab tulemuse return abil.

# 3.3 Concrete Practice: Pipeline harjutused 
# Harjutus 3A: Ha — ehita mini-pipeline 
# Ülesanne: Kopeeri ja käivita järgmine lihtsustatud pipeline, mis töötab ka ilma Supabase ühenduseta.

import pandas as pd
import plotly.express as px
from datetime import datetime

# === EXTRACT ===
def extract_orders():
    """Simuleeri andmete toomist API-st."""
    print("[EXTRACT] Laadin...")
    data = {'customer_id': [1001,1002,1003,1001,1002,1004,1003,1001,1005,1004,
                            1002,1003,1005,1001,1006,1004,1002,1007,1003,1005],
            'sale_date': pd.date_range('2024-01-15', periods=20, freq='10D'),
            'total_price': [89.99,45.50,120.00,67.30,55.00,210.00,33.50,145.00,
                            78.00,92.00,160.00,44.00,88.50,230.00,37.00,175.00,
                            110.00,65.00,95.00,125.00],
            'city': ['Tallinn','Tartu','Tallinn','Tallinn','Tartu','Parnu','Tallinn',
                     'Tallinn','Tartu','Parnu','Tartu','Tallinn','Tartu','Tallinn',
                     'Parnu','Parnu','Tartu','Tallinn','Tallinn','Tartu']}
    df = pd.DataFrame(data)
    print(f"[EXTRACT] {len(df)} tellimust laaditud")
    return df

# === TRANSFORM ===
def transform_monthly(df):
    """Arvuta kuuraport."""
    print("[TRANSFORM] Arvutan...")
    monthly = df.groupby(df['sale_date'].dt.to_period('M')).agg(
        tellimusi=('sale_date', 'count'), kaive=('total_price', 'sum')
    ).reset_index()
    monthly['sale_date'] = monthly['sale_date'].astype(str)
    monthly['kaive'] = monthly['kaive'].round(2)
    print(f"[TRANSFORM] {len(monthly)} kuud")
    return monthly

# === LOAD ===
def load_report(monthly):
    """Salvesta CSV ja graafik."""
    ts = datetime.now().strftime('%Y%m%d_%H%M')
    monthly.to_csv(f'monthly_report_{ts}.csv', index=False)
    px.bar(monthly, x='sale_date', y='kaive',
           title=f'UrbanStyle kuukäive ({ts})',
           labels={'sale_date': 'Kuu', 'kaive': 'Käive (EUR)'}
    ).write_html(f'monthly_chart_{ts}.html')
    print(f"[LOAD] CSV + HTML salvestatud")

# === RUN ===
print("PIPELINE START")
df = extract_orders()
monthly = transform_monthly(df)
load_report(monthly)
print("PIPELINE COMPLETE")
print(monthly.to_string(index=False))

# Vastused:
#
# Mitu faili pipeline lõi?
# Pipeline lõi 2 faili: CSV faili ja HTML graafiku.
#
# Mis formaadis on graafik salvestatud?
# Graafik on salvestatud HTML formaadis.
#
# Kuidas muudaksid seda pipeline'i, et see arvutaks ka linnade kaupa?
# Lisaksin transform etappi groupby city järgi, näiteks:
city_report = df.groupby('city').agg(
    tellimusi=('sale_date', 'count'),
    kaive=('total_price', 'sum'),
    keskmine_tellimus=('total_price', 'mean')
).reset_index()

print(city_report)

# Harjutus 3B: Ha — lisa pipeline'ile RFM 
# Ülesanne: Lisa ülaltoodud pipeline'ile RFM Transform etapp. Kasuta Osa 2 calculate_rfm funktsiooni (või kirjuta lihtsustatud versioon).
# Struktuur (täida lüngad):

def transform_rfm(df, reference_date='2024-08-01'):
    """Arvuta RFM segmendid."""
    print("[TRANSFORM-RFM] Arvutan...")

    ref = pd.to_datetime(reference_date)

    rfm = df.groupby('customer_id').agg(
        last_purchase=('sale_date', 'max'),
        frequency=('sale_date', 'count'),
        monetary=('total_price', 'sum')
    ).reset_index()

    rfm['recency_days'] = (ref - rfm['last_purchase']).dt.days

    rfm['segment'] = rfm.apply(
        lambda row: 'VIP' if row['monetary'] > 200 and row['frequency'] >= 3
                    else 'Loyal' if row['frequency'] >= 3
                    else 'At Risk' if row['recency_days'] > 120
                    else 'Regular',
        axis=1
    )

    return rfm


def load_rfm(rfm):
    """Salvesta RFM CSV ja Plotly scatter graafik."""
    ts = datetime.now().strftime('%Y%m%d_%H%M')

    rfm.to_csv(f'rfm_report_{ts}.csv', index=False)

    px.scatter(
        rfm,
        x='recency_days',
        y='monetary',
        color='segment',
        size='frequency',
        title=f'RFM segmendid ({ts})'
    ).write_html(f'rfm_chart_{ts}.html')

    print("[LOAD-RFM] RFM CSV + HTML salvestatud")


# Käivita laiendatud pipeline
df = extract_orders()
monthly = transform_monthly(df)
rfm = transform_rfm(df)

load_report(monthly)
load_rfm(rfm)

print(rfm)

# Juhivad küsimused:
#
# Mitu segmenti su RFM-is on?
# Seda näen käsuga: print(rfm['segment'].value_counts())
# Minu RFM analüüsis oli 2 segmenti: VIP ja Regular.

# Milline klient on VIP?
# Seda näen käsuga: print(rfm[rfm['segment'] == 'VIP'])
# VIP kliendid olid customer_id 1001, 1002, 1003, 1004 ja 1005.

# Kuidas lisaksid logimise?
# Lisaksin print() asemel logging.info() teated iga etapi algusesse ja lõppu.

# Harjutus 3C: Rakendus — disaini oma pipeline 
# Ülesanne: Mõtle äriprobleemile, mida Marko või Anna tuleb regulaarselt lahendada. Disaini pipeline struktuur (sa ei pea kogu koodi kirjutama — piisab struktuurist).
# Template:
# Pipeline nimi:
# UrbanStyle Weekly Sales & VIP Report

# Sagedus:
# Iga nädal

# EXTRACT:
# - Allikas: Supabase API
# - Tabelid/andmed: sales ja customers

# TRANSFORM:
# - Samm 1: Puhasta ja kontrolli andmed
# - Samm 2: Arvuta kuukäive ja tellimuste statistika
# - Samm 3: Tee RFM analüüs ja leia VIP kliendid

# LOAD:
# - Väljund 1: CSV raport output kausta
# - Väljund 2: HTML graafikud ja RFM raport

# VALIDEERUMINE:
# - Kontroll 1: Kas DataFrame ei ole tühi
# - Kontroll 2: Kas vajalikud veerud (customer_id, total_price) on olemas

# Vigade käsitlemine:
# Kui Extract ebaõnnestub, logitakse error ja pipeline peatub
# või kasutatakse varukoopia CSV faili.

# Miks automatiseerida:
# Automatiseerimine säästab aega ja raportid uuenevad automaatselt
# ilma käsitsi tööta.

# Concrete Practice: Integreeriv harjutus — Marko täispipeline 
# Ülesanne: Ehita lõplik pipeline, mis ühendab API (või simuleeritud) andmete toomise, RFM arvutamise, kuuraportite loomise ja visualiseerimise.

import os
import pandas as pd
import plotly.express as px
from datetime import datetime

# ============================================================
# MARKO IGANÄDALANE RFM PIPELINE
# ============================================================

# --- EXTRACT ---
def extract():
    """Too andmed simuleeritud API-st."""
    print("[EXTRACT] Alustan...")

    orders = pd.DataFrame({
        'customer_id': [1001,1002,1003,1001,1002,1004,1003,1001,1005,1004,
                        1002,1003,1005,1001,1006,1004,1002,1007,1003,1005],
        'sale_date': pd.date_range('2024-01-15', periods=20, freq='10D'),
        'total_price': [89.99,45.50,120.00,67.30,55.00,210.00,33.50,145.00,
                        78.00,92.00,160.00,44.00,88.50,230.00,37.00,175.00,
                        110.00,65.00,95.00,125.00],
        'city': ['Tallinn','Tartu','Tallinn','Tallinn','Tartu','Parnu',
                 'Tallinn','Tallinn','Tartu','Parnu','Tartu','Tallinn',
                 'Tartu','Tallinn','Parnu','Parnu','Tartu','Tallinn',
                 'Tallinn','Tartu']
    })

    customers = pd.DataFrame({
        'customer_id': [1001,1002,1003,1004,1005,1006,1007],
        'first_name': ['Juri','Kati','Maris','Peeter','Liina','Andres','Tiina'],
        'last_name': ['Tamm','Kask','Sepp','Rebane','Ots','Puu','Kuusk']
    })

    print(f"[EXTRACT] {len(orders)} tellimust, {len(customers)} klienti")
    return orders, customers


# --- TRANSFORM ---
def transform(orders, customers, reference_date='2024-08-01'):
    """Puhasta, arvuta RFM, loo kuuraport."""
    print("[TRANSFORM] Alustan...")

    ref = pd.to_datetime(reference_date)

    df = pd.merge(orders, customers, on='customer_id', how='left')

    monthly = df.groupby(df['sale_date'].dt.to_period('M')).agg(
        tellimusi=('sale_date', 'count'),
        kaive=('total_price', 'sum')
    ).reset_index()

    monthly['sale_date'] = monthly['sale_date'].astype(str)
    monthly['kaive'] = monthly['kaive'].round(2)

    rfm = df.groupby('customer_id').agg(
        last_purchase=('sale_date', 'max'),
        frequency=('sale_date', 'count'),
        monetary=('total_price', 'sum'),
        nimi=('first_name', 'first')
    ).reset_index()

    rfm['recency_days'] = (ref - rfm['last_purchase']).dt.days

    rfm['segment'] = rfm.apply(
        lambda r: 'VIP' if r['monetary'] > 300 and r['frequency'] >= 3
        else 'Loyal' if r['frequency'] >= 3
        else 'At Risk' if r['recency_days'] > 120
        else 'Regular',
        axis=1
    )

    print(f"[TRANSFORM] {len(rfm)} klienti segmenteeritud")

    return {'monthly': monthly, 'rfm': rfm}


# --- VALIDATE ---
def validate(results):
    """Kontrolli andmete kvaliteeti."""
    ok = len(results['rfm']) > 0 and results['monthly']['kaive'].sum() > 0

    print(f"[VALIDATE] {'OK' if ok else 'PROBLEEM!'}")

    return ok


# --- LOAD ---
def load(results):
    """Salvesta CSV ja graafikud output kausta."""
    os.makedirs("output", exist_ok=True)

    ts = datetime.now().strftime('%Y%m%d_%H%M')

    results['rfm'].to_csv(f'output/rfm_report_{ts}.csv', index=False)

    px.scatter(
        results['rfm'],
        x='recency_days',
        y='monetary',
        color='segment',
        size='frequency',
        hover_data=['nimi'],
        title=f'UrbanStyle RFM ({ts})',
        labels={
            'recency_days': 'Päevi viimasest ostust',
            'monetary': 'Kogukulutus (EUR)'
        }
    ).write_html(f'output/rfm_chart_{ts}.html')

    px.bar(
        results['monthly'],
        x='sale_date',
        y='kaive',
        title=f'Kuukäive ({ts})',
        labels={
            'sale_date': 'Kuu',
            'kaive': 'EUR'
        }
    ).write_html(f'output/monthly_chart_{ts}.html')

    print("[LOAD] 1 CSV + 2 HTML salvestatud output kausta")


# --- RUN ---
print("=" * 50)
print("  MARKO IGANÄDALANE RFM PIPELINE")
print("=" * 50)

start = datetime.now()

orders, customers = extract()
results = transform(orders, customers)

if validate(results):
    load(results)

print(f"  VALMIS ({(datetime.now() - start).total_seconds():.1f}s)")
print("=" * 50)


# Kokkuvõte
print("\n--- SEGMENDID ---")
print(
    results['rfm'][['nimi', 'frequency', 'monetary', 'segment']]
    .sort_values('monetary', ascending=False)
    .to_string(index=False)
)

print("\n--- KUURAPORT ---")
print(results['monthly'].to_string(index=False))


# Küsimused:
#
# Mitu RFM segmenti pipeline tuvastas?
# Pipeline tuvastas 3 segmenti: VIP, Loyal ja Regular.
#
# Kes on kõige väärtuslikum klient?
# Kõige väärtuslikum klient on Juri, sest tema monetary väärtus on 532.29.
#
# Milline kuu oli kõige kasumlikum?
# Kõige kasumlikum kuu oli 2024-03, sest käive oli 388.50.
#
# Kui pipeline'i Extract ebaõnnestub, mis juhtub?
# Praegu jääks pipeline veaga seisma.
# Seda saaks parandada try/except plokiga, logginguga ja vajadusel varuandmetega.

# ============================================================
# WEEK 8 - TEADMISTE KONTROLL
# ============================================================

# Küsimus 1:
# Marko tahab tõmmata UrbanStyle müügiandmeid otse Supabase'ist Pythonisse.
# Milline lähenemine on TURVALINE?
#
# A) Salvestada API key .env faili ja lugeda python-dotenv abil
# B) Kirjutada API key otse Python koodi
# C) Saata API key emailiga kolleegidele
# D) Laadida API key üles GitHubi
#
# Minu vastus:
# A


# Küsimus 2:
# Milline Supabase Python Client päring vastab SQL lausele:
# SELECT * FROM sales WHERE city = 'Tallinn' ORDER BY total_price DESC?
#
# A) supabase.query(...)
# B) supabase.sql(...)
# C) supabase.get(...)
# D) supabase.table('sales').select('*').eq(...).order(...).execute()
#
# Minu vastus:
# D


# Küsimus 3:
# Anna kirjutas funktsiooni, aga see ei tööta. Mis on viga?
#
# A) print() funktsioon on vale
# B) df[df['city'] == city] süntaks on vale
# C) Funktsioonil puudub return — result on None
# D) f-string formaat ei tööta
#
# Minu vastus:
# C


# Küsimus 4:
# Mis on ETL pipeline'i kolm etappi õiges järjekorras?
#
# A) Execute, Test, Launch
# B) Extract, Transform, Load
# C) Enter, Transform, Leave
# D) Evaluate, Track, Log
#
# Minu vastus:
# B


# Küsimus 5:
# Marko pipeline ebaonnestub öösel.
# Milline koodistruktuur püüaks vea korrektselt?
#
# A) try: fetch_data() except Exception as e: logger.error(...)
# B) if api_connected: fetch_data()
# C) assert api_connected == True
# D) fetch_data() or print("Viga")
#
# Minu vastus:
# A


# Küsimus 6:
# Miks on parem filtreerida API tasemel kui kõik andmed alla laadida?
#
# A) API filter on alati kiirem
# B) API filtrid on täpsemad
# C) Pandas ei suuda filtreerida
# D) Vähem andmeid liigub üle võrgu = kiirem ja vähem mälu
#
# Minu vastus:
# D


# Küsimus 7:
# Milline valideerimise kontroll on kõige olulisem?
#
# A) Kontrollida Python versiooni
# B) Kontrollida, kas Extract tagastas andmeid
# C) Kontrollida võrguühendust
# D) Kontrollida kasutaja login'it
#
# Minu vastus:
# B


# Küsimus 8:
# Milline on .env faili ja .gitignore õige kasutus?
#
# A) .env sisaldab koodi
# B) .env ja .gitignore on sama asi
# C) .env sisaldab saladusi ja .gitignore takistab nende GitHubi laadimist
# D) .gitignore sisaldab API key'd
#
# Minu vastus:
# C


# Küsimus 9:
# Selgita 2-3 lausega:
# miks Marko tahab andmepipeline'i, mitte lihtsalt pandas skripti?
#
# Minu vastus:
# Pipeline automatiseerib kogu protsessi ja raportid uuenevad automaatselt.
# See säästab aega ja vähendab käsitsi tehtavaid vigu.
# Pipeline ühendab andmete laadimise, töötlemise ja salvestamise ühte süsteemi.


# Küsimus 10:
# Kirjuta funktsioon total_revenue(df),
# mis tagastab kogukäibe ümardatuna 2 kohani.

def total_revenue(df):
    """Arvuta kogukäive DataFrame'ist."""

    try:
        total = round(df['total_price'].sum(), 2)
        return total

    except Exception as e:
        print(f"Viga: {e}")
        return None
