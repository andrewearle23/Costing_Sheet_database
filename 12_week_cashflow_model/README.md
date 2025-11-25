📘 12-Week Rolling Cashflow Dashboard

This Power BI dashboard provides a 12-week forward-looking cashflow forecast, combining inflows, outflows, profitability, and deal-level insight into one interactive financial analytics view.
It is built on top of a MySQL data model and includes cashflow event generation, weekly aggregation logic, and commercial relationships between products, clients, and sales reps.

🖼️ Dashboard Screenshot

🎯 Dashboard KPIs

At the top of the dashboard, six KPIs summarise the upcoming 12-week cash position:

KPI	Description
Net Cash (12 Weeks)	Total inflows – total outflows
Total Inflow	All deposit + balance inflows expected
Total Outflow	All supplier payment outflows
Worst Weekly Net Cash	Lowest net cash point in the forecast
Best Weekly Net Cash	Highest weekly net inflow
Active Deals	Count of deals contributing cashflow events

These give finance, treasury, and management teams a clear understanding of upcoming liquidity risks and opportunities.

📊 Included Visuals
1. KPI Summary Bar

Provides an immediate top-level picture of:

Liquidity outlook

Deal volume

Best/worst expected weekly positions

Overall inflow/outflow balance

2. Net Cash vs Cumulative Net Cash Trend

A combined column + line chart showing:

Weekly net cash

Running cumulative position

Inflection points (recovery vs deterioration)

Labels showing exact weekly impacts

This helps identify cash gaps or congestion periods.

3. Profit Per Client and Deal Status

A horizontal bar chart summarizing:

Profit After Finance Cost per client

Split by deal status: WON vs LOST

Ranking clients by profitability contribution

Useful for commercial, sales, and product strategy teams.

4. 12-Week Cashflow Matrix (Deals Won Only)

A financial-style matrix presenting:

ISO Week

Inflow

Outflow

Net Total

Net totals are conditionally formatted:

🟩 Green → Positive net cash

🟥 Red → Negative net cash

This offers a clean, audit-friendly breakdown.

5. Deal-Level Performance Table

Includes per-deal KPIs:

Sales

Gross Profit

GP%

Profit After Finance Cost

Sales Rep

Client

Product

This allows users to drill into deal-driven drivers behind cash movements.

🧱 Underlying Data Model

The Power BI dashboard is powered by a MySQL schema consisting of:

deal (commercial contract header)

deal_cash_inflow / deal_cash_outflow (timed cash movements)

stock_item, product, client, sales_rep, inco_term, deal_status

cashflow_forecast_events (deposit/balance inflows/outflows)

cashflow_weekly / cashflow_12week (weekly aggregated view)

A calendar table with ISO week logic ensures correct weekly grouping and alignment.

🚀 Key Features

Fully synthetic yet realistic commercial & cashflow data

Deals automatically generate inflow/outflow events

Forecasting logic handles:

Deposit percentages

Balance terms

Uplift days

Travel days

Payment terms

12-week rolling window view

Finance-style conditional formatting

Executive-level KPIs with DAX logic