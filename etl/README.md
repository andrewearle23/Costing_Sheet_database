# 🧩 Monday.com → Excel → MySQL ETL Pipeline

## 📘 Overview
This project automates the **ETL (Extract, Transform, Load)** process for a **supply chain costing system**.  
It extracts deal data from **Monday.com**, merges it with **Excel-based cost breakdowns**, transforms and validates the data, and then loads it into a **MySQL database**.

The pipeline handles multiple cost categories such as:
- Deal Overview  
- Stock Costs  
- Transport Costs  
- Ad Hoc Costs  
- Sales Lines  
- Cash Outflows  
- Cash Inflows  

Each stage is logged and tracked for data integrity.

---

## 🧠 Key Features
- ✅ Extracts deal data directly from **Monday.com GraphQL API**
- ✅ Integrates with **Excel workbooks** for cost and sales data
- ✅ Uses **lookup tables** to map foreign key relationships
- ✅ Supports **incremental updates** via `ON DUPLICATE KEY UPDATE`
- ✅ Tracks ETL status via real-time **logging**
- ✅ Modular structure for easy scaling and maintenance

---

## 🧩 Data Flow
**1️⃣ Extract:**  
- Pulls all deal items and column values from a specified Monday.com board.

**2️⃣ Transform:**  
- Cleans and merges data with Excel sheets.  
- Converts names to foreign key IDs using MySQL lookup tables.  
- Calculates metrics like `gross_profit_pct` and `profit_after_fc_pct`.

**3️⃣ Load:**  
- Inserts normalized data into multiple MySQL tables (`deal_overview`, `deal_stock_cost`, `deal_transport_cost`, etc.).  
- Uses upserts (`ON DUPLICATE KEY UPDATE`) to ensure data consistency.

---

## 🧾 Required Database Tables
Your MySQL database should include the following tables:
- `deal_overview`
- `deal_stock_cost`
- `deal_transport_cost`
- `deal_ad_hoc_cost`
- `deal_sales_line`
- `deal_cash_outflow`
- `deal_cash_inflow`
- Lookup tables such as `sales_rep`, `client`, `product`, `deal_status`, `uom`, `transport`, `city`, `ad_hoc`

For schema details, see the companion SQL setup (`/sql/supply_chain_costing_schema.sql`).

---

## 🚀 Setup & Usage

### 1. Clone Repository
```bash
git clone https://github.com/yourusername/etl_monday_mysql.git
cd etl_monday_mysql
2. Install Dependencies
bash
Copy code
pip install -r requirements.txt
requirements.txt

txt
Copy code
pandas
requests
mysql-connector-python
openpyxl
3. Configure Settings
Edit the configuration section at the top of etl_script.py:

python
Copy code
MONDAY_API_KEY = "YOUR_MONDAY_API_TOKEN"
BOARD_ID = 123456789
EXCEL_FOLDER = r"C:\path\to\deal_excels"

DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "your_password",
    "database": "your_database"
}
4. Prepare Data
Place your Excel files (e.g. deal_overview.xlsx, stock_cost.xlsx, etc.) inside the folder defined by EXCEL_FOLDER.

Each file should contain these sheets:

Sheet Name	Description
deal_overview	Main deal data
stock_cost	Stock cost breakdown
transport_cost	Transport costs per deal
ad_hoc_cost	Ad-hoc costs per deal
sales_tbl_One	Detailed sales line items
cf_purch	Cash outflows (purchases)
cf_sales	Cash inflows (sales)

5. Run ETL
bash
Copy code
python etl_script.py
✅ The script will:

Fetch deals from Monday.com

Merge Excel data

Load all cost components into MySQL

Create a log file like:

lua
Copy code
etl_log_20251107_153500.log
🧾 Logging
All activities are logged in real time to both:

Console output

Log file in the root directory (e.g. etl_log_20251107_153500.log)

Example log:

yaml
Copy code
2025-11-07 15:35:12 - INFO - 🚀 ETL process started
2025-11-07 15:35:25 - INFO - ✅ Retrieved 45 Monday.com items
2025-11-07 15:35:31 - INFO - 📄 Processing deal_001.xlsx
2025-11-07 15:35:58 - INFO - ✅ Loaded deal QUO10045 — Stock:12 Transport:3 AdHoc:1 Sales:10 Outflow:2 Inflow:1
2025-11-07 15:36:00 - INFO - ✅ ETL Complete — Deals:45 Stock:320 Transport:75 AdHoc:28 Sales:450 Outflow:88 Inflow:92
🧱 Error Handling
Invalid or missing lookup values default to None

Failures in one file do not stop the pipeline — errors are logged for review

Database operations are committed only after successful processing per file

📊 Example Use Case
This ETL pipeline can be integrated with:

Power BI or Tableau dashboards

Automated cost tracking systems

Finance & sales forecasting pipelines

🧠 Future Improvements
Add asynchronous loading for large data sets

Include data validation layer before MySQL insert

Add notification integration (Slack/Email) for ETL completion

Containerize pipeline using Docker

📜 License

This project is open source and available under the MIT License.
