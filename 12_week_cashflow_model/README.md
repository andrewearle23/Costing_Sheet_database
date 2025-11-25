# 📊 12-Week Rolling Cashflow Forecast System

MySQL → Power BI Financial Analytics

This project delivers a complete cashflow forecasting solution that transforms deal-level commercial data into a 12-week forward-looking liquidity model.
It includes SQL-driven cashflow event logic, a normalised MySQL database, and a clean, professional Power BI dashboard.

All data is fully synthetic but designed to reflect realistic commercial behaviour.

## 🧱 1. MySQL Cashflow Data Model

A normalised relational schema that captures all deal, pricing, client, product, and cashflow timing activity.

Core Entities

Deals (commercial contracts)

Cash inflows (deposit and balance receipts)

Cash outflows (supplier deposits and balances)

Clients, products, sales reps

Stock items and cost structures

Incoterms, deal status codes

Weekly calendar and ISO week mappings

Key Features

SQL logic generates forecasted cashflow events

Unified inflow/outflow view (cashflow_forecast_events)

Weekly aggregation (cashflow_weekly) aligned to ISO week

Rolling 12-week reporting view (cashflow_12week)

Complete referential integrity between all entities

Use Cases

Liquidity planning (12-week horizon)

Cashflow risk identification

Client & product cash contribution analysis

Treasury visibility and deal cash dependency

🖼️ Database Schema

Upload your schema screenshot and update the path below.

![Database Schema](images/db_schema.png)

## 📘 2. Power BI Cashflow Dashboard

An interactive financial reporting interface built on top of the cashflow SQL model.

Dashboard 12 week Finance Model

12_week_cashflow_model/images/12_week_db_overview.png

Dashboard Highlights

Executive KPI summary (Net Cash, Inflow, Outflow, etc.)

Weekly inflow/outflow patterns

Cumulative liquidity curve

Client profitability and deal status comparison

Deal-level performance table with GP%, NP%

Financial-style matrix with conditional formatting

## 🧮 3. KPI Definitions (DAX)

These DAX measures power the top-level KPI cards.

Total Inflow :=
CALCULATE(
    SUM(cashflow_12week[weekly_amount]),
    cashflow_12week[type] = "Inflow"
)

Total Outflow :=
CALCULATE(
    SUM(cashflow_12week[weekly_amount]),
    cashflow_12week[type] = "Outflow"
)

Net Cash :=
[Total Inflow] + [Total Outflow]

Worst Weekly Net Cash :=
MINX(
    VALUES(cashflow_12week[week_start]),
    CALCULATE([Net Cash])
)

Best Weekly Net Cash :=
MAXX(
    VALUES(cashflow_12week[week_start]),
    CALCULATE([Net Cash])
)

Active Deals :=
DISTINCTCOUNT(cashflow_12week[deal_no])

## 📊 4. Dashboard Visuals Explained
KPI Summary Bar

Shows the overall cashflow strength and deal activity in the 12-week window.

Net Cash & Cumulative Curve

Combined column + line view:

Weekly net cash

Running liquidity balance

Inflection points and recovery periods

12-Week Cashflow Matrix

A financial-style breakdown (Inflow, Outflow, Net).
Conditional formatting highlights positive vs negative weekly totals.

Profit Per Client & Deal Status

Client ranking based on Profit After Finance Cost, split by WON/LOST deals.

Deal Performance Table

Deal-level metrics including:

Sales

Gross Profit

GP%

NP%

Client, Product, Sales Rep

Useful for bottom-up analysis.

## 🔄 5. Cashflow Generation Workflow

SQL computes deposit, balance, uplift, travel, and payment dates

All events converted into cashflow movements

Weekly buckets generated using ISO week logic

12-week rolling window exposed to Power BI

DAX performs KPIs, formatting, and cumulative logic

🔒 Data Notice

All data is fully synthetic and anonymised.

The structure and behaviour reflect real business logic for demonstration purposes only.
