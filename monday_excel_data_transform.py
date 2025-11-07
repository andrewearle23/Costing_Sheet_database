import pandas as pd
import requests
import mysql.connector

# === CONFIGURATION ===
MONDAY_API_KEY = "YOUR_MONDAY_API_TOKEN"
BOARD_ID = 123456789  # Replace with your Monday board ID
EXCEL_FILE = "deal_overview.xlsx"
TABLE_NAME = "deal_overview"

DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "your_password",
    "database": "your_database"
}

# === STEP 1: Get data from Monday.com ===
query = f"""
{{
  boards (ids: {BOARD_ID}) {{
    items_page(limit: 200) {{
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

headers = {"Authorization": MONDAY_API_KEY, "Content-Type": "application/json"}
response = requests.post("https://api.monday.com/v2", json={"query": query}, headers=headers)
data = response.json()

items = data["data"]["boards"][0]["items_page"]["items"]

columns_needed = [
    "Client",
    "Product",
    "Sales Rep",
    "Deal Status",
    "Date Created",
    "Date Closed",
    "Quote Submitted",
    "Quote Due Date"
]

rows = []
for item in items:
    row = {"Name": item["name"]}
    for col in item["column_values"]:
        if col["title"] in columns_needed:
            row[col["title"]] = col["text"]
    rows.append(row)

monday_df = pd.DataFrame(rows)

# === STEP 2: Read Excel financial data ===
excel_df = pd.read_excel(EXCEL_FILE, sheet_name="deal_overview")
excel_df.rename(columns={"Deal Number": "Name"}, inplace=True)

# === STEP 3: Merge Monday.com + Excel ===
merged_df = pd.merge(monday_df, excel_df, on="Name", how="left")

# === STEP 4: Connect to MySQL ===
conn = mysql.connector.connect(**DB_CONFIG)
cursor = conn.cursor(dictionary=True)

# === STEP 5: Load lookup tables ===
def load_lookup_dict(table, id_col, name_col):
    cursor.execute(f"SELECT {id_col}, {name_col} FROM {table}")
    return {row[name_col].strip(): row[id_col] for row in cursor.fetchall()}

sales_rep_lookup = load_lookup_dict("sales_rep", "sales_rep_id", "sales_rep_name")
client_lookup = load_lookup_dict("client", "client_id", "client_name")
product_lookup = load_lookup_dict("product", "product_ref", "product_name")
status_lookup = load_lookup_dict("deal_status", "status_code", "description")

# === STEP 6: Map names to IDs ===
def safe_lookup(lookup_dict, key):
    if pd.isna(key):
        return None
    return lookup_dict.get(key.strip(), None)

merged_df["sales_rep_id"] = merged_df["Sales Rep"].apply(lambda x: safe_lookup(sales_rep_lookup, x))
merged_df["client_id"] = merged_df["Client"].apply(lambda x: safe_lookup(client_lookup, x))
merged_df["product_ref"] = merged_df["Product"].apply(lambda x: safe_lookup(product_lookup, x))
merged_df["status_code"] = merged_df["Deal Status"].apply(lambda x: safe_lookup(status_lookup, x))

# === STEP 7: Prepare table fields ===
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

# === STEP 8: Upsert (Insert or Update) ===
insert_sql = f"""
INSERT INTO {TABLE_NAME} (
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
    cursor.execute(insert_sql, row.to_dict())

conn.commit()
cursor.close()
conn.close()

print("✅ Monday.com + Excel data successfully synced to MySQL.")

