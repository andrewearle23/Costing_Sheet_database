import os
import pandas as pd
import requests
import mysql.connector
import logging
from datetime import datetime

# === CONFIGURATION ===
MONDAY_API_KEY = "YOUR_MONDAY_API_TOKEN"
BOARD_ID = 123456789  # Replace with your Monday board ID
EXCEL_FOLDER = "C:/path/to/deal_excels"  # Folder containing all Excel files
LOG_FILE = f"etl_log_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"

DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "your_password",
    "database": "your_database"
}

# === LOGGING SETUP ===
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    handlers=[
        logging.FileHandler(LOG_FILE, mode='w'),
        logging.StreamHandler()
    ]
)

logging.info("🚀 ETL process started")

# === STEP 1: Fetch all data from Monday.com (with pagination) ===
def fetch_monday_items(board_id):
    items = []
    cursor = None
    headers = {"Authorization": MONDAY_API_KEY, "Content-Type": "application/json"}

    while True:
        query = f"""
        {{
          boards(ids: {board_id}) {{
            items_page(limit: 200, cursor: {f'"{cursor}"' if cursor else 'null'}) {{
              cursor
              items {{
                name
                column_values {{
                  id
                  title
                  text
                }}
              }}
            }}
          }}
        }}
        """

        response = requests.post("https://api.monday.com/v2", json={"query": query}, headers=headers)
        data = response.json()
        page = data["data"]["boards"][0]["items_page"]
        items.extend(page["items"])
        cursor = page.get("cursor")

        if not cursor:
            break

    logging.info(f"✅ Retrieved {len(items)} items from Monday.com board {board_id}")
    return items


# === STEP 2: Load Monday.com data ===
monday_items = fetch_monday_items(BOARD_ID)

columns_needed = [
    "Client", "Product", "Sales Rep", "Deal Status",
    "Date Created", "Date Closed", "Quote Submitted", "Quote Due Date"
]

rows = []
for item in monday_items:
    row = {"Name": item["name"]}
    for col in item["column_values"]:
        if col["title"] in columns_needed:
            row[col["title"]] = col["text"]
    rows.append(row)

monday_df = pd.DataFrame(rows)

# === STEP 3: Connect to MySQL and load lookups ===
conn = mysql.connector.connect(**DB_CONFIG)
cursor = conn.cursor(dictionary=True)

def load_lookup_dict(table, id_col, name_col):
    cursor.execute(f"SELECT {id_col}, {name_col} FROM {table}")
    return {row[name_col].strip(): row[id_col] for row in cursor.fetchall()}

sales_rep_lookup = load_lookup_dict("sales_rep", "sales_rep_id", "sales_rep_name")
client_lookup = load_lookup_dict("client", "client_id", "client_name")
product_lookup = load_lookup_dict("product", "product_ref", "product_name")
status_lookup = load_lookup_dict("deal_status", "status_code", "description")
uom_lookup = load_lookup_dict("uom", "uom_id", "uom_name") if "uom" in [t["Tables_in_"+DB_CONFIG["database"]] for t in cursor.execute("SHOW TABLES", multi=True)] else {}

def safe_lookup(lookup_dict, key):
    if pd.isna(key):
        return None
    return lookup_dict.get(key.strip(), None)


# === STEP 4: Loop through each Excel file ===
deal_files = [f for f in os.listdir(EXCEL_FOLDER) if f.endswith(".xlsx") or f.endswith(".xls")]

total_deals = 0
total_stocks = 0

for file_name in deal_files:
    file_path = os.path.join(EXCEL_FOLDER, file_name)
    logging.info(f"📄 Processing file: {file_name}")

    try:
        # === Read deal_overview sheet ===
        deal_df = pd.read_excel(file_path, sheet_name="deal_overview")
        deal_df.rename(columns={"Deal Number": "Name"}, inplace=True)

        # Match with Monday data
        merged_df = pd.merge(monday_df, deal_df, on="Name", how="left")

        # Map names to IDs
        merged_df["sales_rep_id"] = merged_df["Sales Rep"].apply(lambda x: safe_lookup(sales_rep_lookup, x))
        merged_df["client_id"] = merged_df["Client"].apply(lambda x: safe_lookup(client_lookup, x))
        merged_df["product_ref"] = merged_df["Product"].apply(lambda x: safe_lookup(product_lookup, x))
        merged_df["status_code"] = merged_df["Deal Status"].apply(lambda x: safe_lookup(status_lookup, x))

        merged_df.rename(columns={
            "Name": "deal_no",
            "Date Created": "date_created",
            "Quote Due Date": "quote_due_date",
            "Quote Submitted": "quote_submitted_date",
            "Date Closed": "date_closed",
            "Sales": "sales_total",
            "Cost of Sales": "cost_of_sales",
            "Gross Profit": "gross_profit",
            "Finance Cost": "finance_cost",
            "Profit After FC": "profit_after_fc"
        }, inplace=True)

        merged_df["gross_profit_pct"] = (merged_df["gross_profit"] / merged_df["sales_total"]) * 100
        merged_df["profit_after_fc_pct"] = (merged_df["profit_after_fc"] / merged_df["sales_total"]) * 100
        merged_df = merged_df.where(pd.notnull(merged_df), None)

        # === UPSERT deal_overview ===
        insert_sql_deal = """
        INSERT INTO deal_overview (
            deal_no, sales_rep_id, client_id, product_ref, status_code,
            date_created, quote_due_date, quote_submitted_date, date_closed,
            sales_total, cost_of_sales, gross_profit, finance_cost, profit_after_fc,
            gross_profit_pct, profit_after_fc_pct
        ) VALUES (
            %(deal_no)s, %(sales_rep_id)s, %(client_id)s, %(product_ref)s, %(status_code)s,
            %(date_created)s, %(quote_due_date)s, %(quote_submitted_date)s, %(date_closed)s,
            %(sales_total)s, %(cost_of_sales)s, %(gross_profit)s, %(finance_cost)s, %(profit_after_fc)s,
            %(gross_profit_pct)s, %(profit_after_fc_pct)s
        )
        ON DUPLICATE KEY UPDATE
            sales_rep_id = VALUES(sales_rep_id),
            client_id = VALUES(client_id),
            product_ref = VALUES(product_ref),
            status_code = VALUES(status_code),
            date_created = VALUES(date_created),
            quote_due_date = VALUES(quote_due_date),
            quote_submitted_date = VALUES(quote_submitted_date),
            date_closed = VALUES(date_closed),
            sales_total = VALUES(sales_total),
            cost_of_sales = VALUES(cost_of_sales),
            gross_profit = VALUES(gross_profit),
            finance_cost = VALUES(finance_cost),
            profit_after_fc = VALUES(profit_after_fc),
            gross_profit_pct = VALUES(gross_profit_pct),
            profit_after_fc_pct = VALUES(profit_after_fc_pct);
        """

        for _, row in merged_df.iterrows():
            cursor.execute(insert_sql_deal, row.to_dict())
            total_deals += 1

        # === Read stock_cost sheet ===
        stock_df = pd.read_excel(file_path, sheet_name="stock_cost")
        stock_df.rename(columns={
            "Deal Number": "deal_no",
            "Stock Code": "stock_ref",
            "Product Name": "product_name",
            "UoM": "uom_name",
            "Quantity": "quantity",
            "Price": "unit_price",
            "Total Cost": "total_cost"
        }, inplace=True)

        stock_df["product_ref"] = stock_df["product_name"].apply(lambda x: safe_lookup(product_lookup, x))
        stock_df["uom_id"] = stock_df["uom_name"].apply(lambda x: safe_lookup(uom_lookup, x) if uom_lookup else None)
        stock_df = stock_df.where(pd.notnull(stock_df), None)

        insert_sql_stock = """
        INSERT INTO deal_stock_cost (
            deal_no, stock_ref, uom_id, product_ref, quantity, unit_price, total_cost
        ) VALUES (
            %(deal_no)s, %(stock_ref)s, %(uom_id)s, %(product_ref)s, %(quantity)s, %(unit_price)s, %(total_cost)s
        )
        ON DUPLICATE KEY UPDATE
            uom_id = VALUES(uom_id),
            product_ref = VALUES(product_ref),
            quantity = VALUES(quantity),
            unit_price = VALUES(unit_price),
            total_cost = VALUES(total_cost);
        """

        for _, row in stock_df.iterrows():
            cursor.execute(insert_sql_stock, row.to_dict())
            total_stocks += 1

        conn.commit()
        logging.info(f"✅ Loaded deal {merged_df['deal_no'].iloc[0]} with {len(stock_df)} stock items")

    except Exception as e:
        logging.error(f"❌ Error processing {file_name}: {e}")

cursor.close()
conn.close()

logging.info(f"✅ ETL complete: {total_deals} deals and {total_stocks} stock lines loaded.")
logging.info(f"📄 Log file saved to {LOG_FILE}")




