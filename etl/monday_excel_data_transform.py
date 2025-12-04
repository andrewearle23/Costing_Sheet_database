import os
import pandas as pd
import requests
import mysql.connector
import logging
from datetime import datetime

# Configuration
MONDAY_API_KEY = "YOUR_MONDAY_API_TOKEN"
BOARD_ID = 123456789  # Monday board ID
EXCEL_FOLDER = r"C:\path\to\deal_excels"
LOG_FILE = f"etl_log_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"

DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "your_password",
    "database": "your_database"
}

# Logging Setup
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    handlers=[logging.FileHandler(LOG_FILE, mode='w'), logging.StreamHandler()]
)
logging.info("ETL process started")

# Fetch Monday.com Data
def fetch_monday_items(board_id):
    items, cursor = [], None
    headers = {"Authorization": MONDAY_API_KEY, "Content-Type": "application/json"}
    while True:
        query = f"""
        {{
          boards(ids: {board_id}) {{
            items_page(limit: 200, cursor: {f'"{cursor}"' if cursor else 'null'}) {{
              cursor
              items {{
                name
                column_values {{ title text }}
              }}
            }}
          }}
        }}
        """
        resp = requests.post("https://api.monday.com/v2", json={"query": query}, headers=headers)
        data = resp.json()["data"]["boards"][0]["items_page"]
        items.extend(data["items"])
        cursor = data.get("cursor")
        if not cursor:
            break
    logging.info(f"✅ Retrieved {len(items)} Monday.com items")
    return items


# Load Monday.com Data
monday_items = fetch_monday_items(BOARD_ID)
columns_needed = [
    "Client", "Product", "Sales Rep", "Deal Status",
    "Date Created", "Date Closed", "Quote Submitted", "Quote Due Date"
]
monday_df = pd.DataFrame([
    {"Name": i["name"], **{c["title"]: c["text"] for c in i["column_values"] if c["title"] in columns_needed}}
    for i in monday_items
])

# MySQL Connection and Lookups
conn = mysql.connector.connect(**DB_CONFIG)
cursor = conn.cursor(dictionary=True)

def load_lookup(t, id_col, name_col):
    cursor.execute(f"SELECT {id_col}, {name_col} FROM {t}")
    return {r[name_col].strip(): r[id_col] for r in cursor.fetchall()}

# Reference lookups
sales_rep_lookup = load_lookup("sales_rep", "sales_rep_id", "sales_rep_name")
client_lookup = load_lookup("client", "client_id", "client_name")
product_lookup = load_lookup("product", "product_ref", "product_name")
status_lookup = load_lookup("deal_status", "status_code", "description")
uom_lookup = load_lookup("uom", "uom_id", "uom_name")
transport_lookup = load_lookup("transport", "transport_id", "transport_name")
city_lookup = load_lookup("city", "city_code", "city_name")
ad_hoc_lookup = load_lookup("ad_hoc", "ad_hoc_id", "ad_hoc_name")

def safe_lookup(dic, val): return None if pd.isna(val) else dic.get(str(val).strip())

# Loop through excel Files
files = [f for f in os.listdir(EXCEL_FOLDER) if f.endswith((".xlsx", ".xls"))]
total = {"deals":0,"stock":0,"transport":0,"adhoc":0,"sales":0,"outflow":0,"inflow":0}

for f in files:
    path = os.path.join(EXCEL_FOLDER, f)
    logging.info(f"📄 Processing {f}")

    try:
        # Deal Overview
        deal = pd.read_excel(path, sheet_name="deal_overview").rename(columns={"Deal Number": "Name"})
        merged = monday_df.merge(deal, on="Name", how="left")
        merged["sales_rep_id"] = merged["Sales Rep"].apply(lambda x: safe_lookup(sales_rep_lookup, x))
        merged["client_id"] = merged["Client"].apply(lambda x: safe_lookup(client_lookup, x))
        merged["product_ref"] = merged["Product"].apply(lambda x: safe_lookup(product_lookup, x))
        merged["status_code"] = merged["Deal Status"].apply(lambda x: safe_lookup(status_lookup, x))
        merged.rename(columns={
            "Name": "deal_no", "Date Created": "date_created", "Quote Due Date": "quote_due_date",
            "Quote Submitted": "quote_submitted_date", "Date Closed": "date_closed",
            "Sales": "sales_total", "Cost of Sales": "cost_of_sales",
            "Gross Profit": "gross_profit", "Finance Cost": "finance_cost",
            "Profit After FC": "profit_after_fc"
        }, inplace=True)
        merged["gross_profit_pct"] = (merged["gross_profit"]/merged["sales_total"])*100
        merged["profit_after_fc_pct"] = (merged["profit_after_fc"]/merged["sales_total"])*100
        sql_deal = """
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
            sales_total=VALUES(sales_total), cost_of_sales=VALUES(cost_of_sales),
            gross_profit=VALUES(gross_profit), profit_after_fc=VALUES(profit_after_fc)
        """
        for _, r in merged.iterrows(): cursor.execute(sql_deal, r.to_dict())
        total["deals"] += len(merged)

        # Stock Cost
        stock = pd.read_excel(path, sheet_name="stock_cost").rename(columns={
            "Deal Number":"deal_no","Stock Code":"stock_ref","Product Name":"product_name",
            "UoM":"uom_name","Quantity":"quantity","Price":"unit_price","Total Cost":"total_cost"})
        stock["product_ref"]=stock["product_name"].apply(lambda x:safe_lookup(product_lookup,x))
        stock["uom_id"]=stock["uom_name"].apply(lambda x:safe_lookup(uom_lookup,x))
        sql_stock = """
        INSERT INTO deal_stock_cost (deal_no, stock_ref, uom_id, product_ref, quantity, unit_price, total_cost)
        VALUES (%(deal_no)s,%(stock_ref)s,%(uom_id)s,%(product_ref)s,%(quantity)s,%(unit_price)s,%(total_cost)s)
        ON DUPLICATE KEY UPDATE quantity=VALUES(quantity), unit_price=VALUES(unit_price), total_cost=VALUES(total_cost)
        """
        for _, r in stock.iterrows(): cursor.execute(sql_stock, r.to_dict())
        total["stock"] += len(stock)

        # Transport Cost
        transport = pd.read_excel(path, sheet_name="transport_cost").rename(columns={
            "Transporter":"transport_name","Deal No.":"deal_no","Collection Point":"collection_name",
            "Delivery Point":"delivery_name","Quantity":"quantity","Quant Per Truck":"quantity_per_truck",
            "Price":"unit_price","Total Cost":"total_cost"})
        transport["transport_id"]=transport["transport_name"].apply(lambda x:safe_lookup(transport_lookup,x))
        transport["collection_city_code"]=transport["collection_name"].apply(lambda x:safe_lookup(city_lookup,x))
        transport["delivery_city_code"]=transport["delivery_name"].apply(lambda x:safe_lookup(city_lookup,x))
        sql_transport = """
        INSERT INTO deal_transport_cost (
            deal_no, transport_ref, transport_id, collection_city_code, delivery_city_code,
            quantity, quantity_per_truck, unit_price, total_cost
        ) VALUES (
            %(deal_no)s,%(transport_name)s,%(transport_id)s,%(collection_city_code)s,%(delivery_city_code)s,
            %(quantity)s,%(quantity_per_truck)s,%(unit_price)s,%(total_cost)s)
        ON DUPLICATE KEY UPDATE quantity=VALUES(quantity), unit_price=VALUES(unit_price), total_cost=VALUES(total_cost)
        """
        for _, r in transport.iterrows(): cursor.execute(sql_transport, r.to_dict())
        total["transport"] += len(transport)

        # Ad Hoc Cost
        adhoc = pd.read_excel(path, sheet_name="ad_hoc_cost").rename(columns={
            "Deal No.":"deal_no","AD Hoc Cost":"ad_hoc_name","UoM":"uom_name",
            "Quantity":"quantity","Price":"unit_price","Total Cost":"total_cost"})
        adhoc["ad_hoc_id"]=adhoc["ad_hoc_name"].apply(lambda x:safe_lookup(ad_hoc_lookup,x))
        adhoc["uom_id"]=adhoc["uom_name"].apply(lambda x:safe_lookup(uom_lookup,x))
        sql_adhoc = """
        INSERT INTO deal_ad_hoc_cost (deal_no, cost_ref, ad_hoc_id, quantity, unit_price, total_cost)
        VALUES (%(deal_no)s,%(ad_hoc_name)s,%(ad_hoc_id)s,%(quantity)s,%(unit_price)s,%(total_cost)s)
        ON DUPLICATE KEY UPDATE quantity=VALUES(quantity), unit_price=VALUES(unit_price), total_cost=VALUES(total_cost)
        """
        for _, r in adhoc.iterrows(): cursor.execute(sql_adhoc, r.to_dict())
        total["adhoc"] += len(adhoc)

        # Sales Lines
        sales = pd.read_excel(path, sheet_name="sales_tbl_One").rename(columns={
            "Type":"line_type","Product":"product_name","UoM":"uom_name","Quantity":"quantity",
            "Purchase Price":"purchase_price","Sales Price":"sales_price","GP Price":"gp_price","GP %":"gp_pct",
            "Purchase Cost":"purchase_cost","Sales Total":"sales_total","GP Total":"gp_total"})
        sales["product_ref"]=sales["product_name"].apply(lambda x:safe_lookup(product_lookup,x))
        sales["uom_id"]=sales["uom_name"].apply(lambda x:safe_lookup(uom_lookup,x))
        sales["deal_no"]=merged["deal_no"].iloc[0]
        sql_sales = """
        INSERT INTO deal_sales_line (
            deal_no, line_type, product_ref, description, uom_id, quantity,
            purchase_price, sales_price, gp_price, gp_pct,
            purchase_cost, sales_total, gp_total
        ) VALUES (
            %(deal_no)s,%(line_type)s,%(product_ref)s,%(product_name)s,%(uom_id)s,%(quantity)s,
            %(purchase_price)s,%(sales_price)s,%(gp_price)s,%(gp_pct)s,
            %(purchase_cost)s,%(sales_total)s,%(gp_total)s
        )
        ON DUPLICATE KEY UPDATE quantity=VALUES(quantity), sales_price=VALUES(sales_price), gp_total=VALUES(gp_total)
        """
        for _, r in sales.iterrows(): cursor.execute(sql_sales, r.to_dict())
        total["sales"] += len(sales)

        # Cash Outflow
        outflow = pd.read_excel(path, sheet_name="cf_purch").rename(columns={
            "Stock Code":"stock_ref","UoM":"uom_name","Quantity":"quantity",
            "Purch Cost":"purchase_price","Deposit %":"deposit_pct","Deposit Date":"deposit_date",
            "Balance Date":"balance_date","Total Cost":"total_cost"})
        outflow["deal_no"]=merged["deal_no"].iloc[0]
        sql_outflow = """
        INSERT INTO deal_cash_outflow (
            deal_no, stock_ref, quantity, purchase_price, deposit_pct,
            deposit_date, balance_date, total_cost
        ) VALUES (
            %(deal_no)s,%(stock_ref)s,%(quantity)s,%(purchase_price)s,%(deposit_pct)s,
            %(deposit_date)s,%(balance_date)s,%(total_cost)s
        )
        ON DUPLICATE KEY UPDATE quantity=VALUES(quantity), purchase_price=VALUES(purchase_price),
        total_cost=VALUES(total_cost)
        """
        for _, r in outflow.iterrows(): cursor.execute(sql_outflow, r.to_dict())
        total["outflow"] += len(outflow)

        # Cash Inflow
        inflow = pd.read_excel(path, sheet_name="cf_sales").rename(columns={
            "Deal No.":"deal_no","UoM":"uom_name","Quantity":"quantity","Sales Price":"sales_price",
            "Deposit%":"deposit_pct","Deposit Date":"deposit_date","Uplift Start":"uplift_start",
            "Uplift (Days)":"uplift_days","Travel (Days)":"travel_days","Terms (Days)":"terms_days",
            "Balance%":"balance_pct","Total Amount":"total_sales"})
        sql_inflow = """
        INSERT INTO deal_cash_inflow (
            deal_no, quantity, sales_price, deposit_pct, deposit_date,
            uplift_start, uplift_days, travel_days, terms_days, balance_pct, total_sales
        ) VALUES (
            %(deal_no)s,%(quantity)s,%(sales_price)s,%(deposit_pct)s,%(deposit_date)s,
            %(uplift_start)s,%(uplift_days)s,%(travel_days)s,%(terms_days)s,%(balance_pct)s,%(total_sales)s
        )
        ON DUPLICATE KEY UPDATE sales_price=VALUES(sales_price), total_sales=VALUES(total_sales)
        """
        for _, r in inflow.iterrows(): cursor.execute(sql_inflow, r.to_dict())
        total["inflow"] += len(inflow)

        conn.commit()
        logging.info(f"Loaded deal {merged['deal_no'].iloc[0]} — Stock:{len(stock)} Transport:{len(transport)} AdHoc:{len(adhoc)} Sales:{len(sales)} Outflow:{len(outflow)} Inflow:{len(inflow)}")

    except Exception as e:
        logging.error(f"❌ Error processing {f}: {e}")

cursor.close()
conn.close()
logging.info(f"ETL Complete — Deals:{total['deals']} Stock:{total['stock']} Transport:{total['transport']} AdHoc:{total['adhoc']} Sales:{total['sales']} Outflow:{total['outflow']} Inflow:{total['inflow']}")
logging.info(f"📄 Log saved to {LOG_FILE}")






