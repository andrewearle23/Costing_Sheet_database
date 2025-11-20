📊 12-Week Rolling Cashflow Forecast

A MySQL → Power BI financial forecasting model

This model delivers a 12-week forward-looking cashflow forecast using a SQL-based data model and an interactive Power BI dashboard. The solution forecasts cash inflows, cash outflows, and net cash movement per deal, grouped by ISO week, with filters for Product, Client, and Sales Rep.

🚀 Overview

Generates a 12-week rolling cashflow projection

Aggregates inflows and outflows per deal, per week

Provides deal-level breakdown and weekly totals

Highlights positive/negative cash positions

Supports commercial, finance, and treasury teams

🧱 Architecture Summary
1. Data Source (MySQL)

The SQL layer prepares all data required for the forecast:

Creates a unified financial events dataset (cash inflows + cash outflows).

Calculates expected payment dates based on deal terms.

Converts all events into ISO week buckets.

Produces a clean 12-week rolling dataset for Power BI.

2. Data Model (Power BI)

Power BI imports and models the following:

Weekly cashflow view (core fact table)

Deal data (product, client, sales rep relationships)

Date table (to manage week numbers and week start dates)

Relationships:

Date → Cashflow (1-to-many)

Deal → Cashflow (1-to-many)

Product, Client, Sales Rep → Deal (1-to-many)

3. DAX Measures

Power BI calculates:

Cash Outflow (negative)

Cash Inflow (positive)

Net Cash (inflow – outflow)

12-week window filter

Conditional formatting indicators (red/green)

📊 Dashboard Features
Matrix Layout

A Power BI matrix visual shows:

Week numbers as column headers

Week start dates as secondary headers

Cash Outflow section (with deal breakdown)

Cash Inflow section (with deal breakdown)

Total Cash row (net cash per week)

Colour Coding

Outflows → 🔴 Red

Inflows → 🟢 Green

Net Cash →

🟢 Green (positive)

🔴 Red (negative)

⚪ Neutral (zero)

Filters

Product

Client

Sales Rep

These allow users to isolate deals, customers, or segments to understand cashflow contributions.

📁 Files Included in This Repository

SQL Documentation
Explanation of the SQL views used to generate weekly cashflow data.

Power BI Modeling Notes
Data model structure, relationships, and measures.

Dashboard Mock-ups
Example visual showing the final dashboard style.

PDF Report (Optional)
A generated summary for portfolio demonstration.

✔️ Summary

This solution provides:

A complete forecasting pipeline from SQL → Power BI

A reusable 12-week cashflow model for deal-based businesses

A clean, interactive dashboard suitable for finance and operations

A strong portfolio example demonstrating SQL, DAX, data modeling, and reporting