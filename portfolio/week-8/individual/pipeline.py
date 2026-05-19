import pandas as pd
from extract import get_data
import logging
import sys

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

logger.info(sys.argv)

logger.info("Starting data extraction")
sales_df = get_data('sales')
customers_df = get_data('customers')
logger.info("Data extraction completed")

df = pd.merge(sales_df, customers_df[['customer_id', 'first_name', 'last_name', 'email', 'phone', 'city']], on = 'customer_id', how = 'left')
logger.info("Data merging completed")

logger.info("First few rows of the merged DataFrame:")
logger.info(df.head())