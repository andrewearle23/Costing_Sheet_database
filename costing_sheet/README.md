# 💼 Deal Costing Sheet (Excel Automation Project)

## 📘 Project Overview

The **Deal Costing Sheet** was developed to replace fragmented costing templates and introduce a **standardized, automated, and auditable** workflow for managing deal cost structures.  
The solution leverages **VBA**, **Power Query**, and **SAP SQL Queries** to build a robust data model that integrates costing, finance, and quoting processes into one Excel-based application.

### 🧭 Objective

Create a **standardized costing template** for PTA (Product Trading Agreements) that:

- Eliminates inaccuracies in cost calculations  
- Handles complex deal structures  
- Improves financial forecasting  
- Provides transparency and detail  
- Reduces version duplication

---

## ⚙️ Deal Structure & Logic

Each deal is broken down into modular cost components:

| Module | Description |
|---------|-------------|
| **Stock Cost** | Calculates cost of materials, including landed and currency-adjusted values |
| **Transport Cost** | Captures logistics and transport pricing per deal |
| **Ad-Hoc Cost** | Tracks additional expenses (Bagging, Packaging, Storage, etc.) |
| **Finance Cost** | Models financing based on cash inflow/outflow timing and cost of capital |
| **Selling Price & GP** | Integrates all cost tables, performs currency conversions, and calculates Gross Profit |

---

## 🧩 Core Components

### 1. **Power Query ETL Flow**

Power Query is the backbone of all data transformation logic in the costing sheet.  
It performs data extraction, transformation, and consolidation from **SAP queries** and **Excel tables**.

#### 🧱 Table Structure Diagram

[stock_cost] ─┐
[transport_cost] ─┼─> Power Query → Combined → [combined_costs]
[ad_hoc_cost] ────┘

markdown
Copy code

**Final Columns:**
`Type`, `Product`, `UoM`, `Quantity`, `Purchase Price`, `Purchase Cost`

#### 🔄 ETL Process Summary

1. **Stock Cost Query**
   - Extracts `Stock Code`, `Description`, `UoM`, `Quantity`, `Price (DS)`, and `Cost (DS)`
   - Adds "Type" = `Product`
   - Aggregates by `Product` and `UoM`
   - Calculates `Unit Price = Cost / Quantity`
   - Converts all amounts to `Currency` type

2. **Transport Cost Query**
   - Extracts deal transport data  
   - Adds "Type" = `Transport` and “Product” = `Transport Cost`  
   - Cleans and converts to currency  

3. **Ad-Hoc Cost Query**
   - Captures other costs (bagging, packaging, etc.)
   - Adds "Type" = `Ad Hoc` and standardizes columns  

4. **Combined Cost Query**
   - Combines all three tables using `Table.Combine`
   - Cleans and filters empty rows
   - Renames fields to standardized naming conventions  
   - Outputs consolidated dataset ready for cost analysis and GP calculation  

---

### 2. **SAP Integrated Queries**

Power Query connects directly to the **SAP SQL Server backend** to fetch real-time data for customer, product, and payment analysis.

#### **Customer List**
- Source: SAP Tables `OCRD`, `OCTG`, and `OCRY`
- Filters for customers only (`CardType = 'C'`)
- Calculates:
  - **Open Invoice Balance**
  - **Open Sales Orders**
  - **Total Exposure = Balance + Orders Balance**
- Performs currency normalization (USD/Local)
- Cleans and outputs formatted customer dataset

#### **Product List**
- Source: SAP Table `OPRC`
- Extracts and cleans **Product Groups**
- Removes null and blank values

#### **Average Payment Days**
- Source: SAP Tables `OINV`, `RCT2`, `ORCT`
- Calculates **average payment days per customer** for the last 12 months
- Joins invoice and payment records
- Outputs Customer Code, Name, and Avg. Payment Days

---

## 🧮 Calculations Summary

| Module | Key Logic |
|---------|------------|
| **Stock Cost** | Currency conversion, landed cost integration, unit price derivation |
| **Transport Cost** | Dynamic cost by transporter, destination, and product type |
| **Ad-Hoc Cost** | Captures flexible cost categories |
| **Finance Cost** | Cash flow model based on predicted inflows/outflows and cost of capital |
| **Gross Profit** | Aggregates all costs and compares to sales input (line item or total) |

---

## 🧠 Automation with VBA (Macro System)

The workbook uses **VBA automation modules (Modules 1–41)** for complete control over data management, quoting, and report generation.

### 🔧 VBA Functionality Summary

#### 💾 Sheet Management
- Add/remove rows from cost tables (Stock, Transport, Ad-Hoc)
- Unhide or toggle sheets dynamically based on user interaction
- Auto-adjust column widths and row visibility

#### 📤 Quoting Automation
- Exports single and multi-product quotes to **PDF**
- Auto-generates **Outlook emails** with personalized templates
- Logs all quote data (number, dates, GP, sales, and costs) into a tracking table
- Handles multiple quote formats:
  - `Quo (Sgl) Prod`
  - `Quo (Sgl) Trans`
  - `Quo (Sgl) All`
  - `Quo (Mult) Prod`
  - `Quo (Mult) Trans`
  - `Quo (Mult) All`

#### 🔁 Data Refresh & Security
- Refreshes all Power Query and connection tables  
- Refreshes Average Payment Days (SAP data)
- Automatically unprotects and reprotects all sheets
- Displays confirmation or error messages dynamically

#### 📊 Cash Flow Interaction
- Expands or hides sections dynamically (rows/columns)
- Adds or deletes rows from the `cf_sales` table
- Toggles visibility of financial models and flow charts

---

## 🧾 Quote Generation Workflow

1. User selects quote type (Single / Multi / Transport)
2. VBA unprotects relevant sheet and exports quote as **PDF**
3. Outlook email draft created with client details and validity
4. Quote logged in “Quote Register” sheet automatically
5. Workbook reprotected and confirmation displayed

---

## 🧠 Technical Highlights

| Feature | Technology |
|----------|-------------|
| **ETL & Transformation** | Power Query (M language) |
| **Database Integration** | SAP SQL Server |
| **Automation & Reporting** | VBA (Macros) |
| **Finance Modelling** | Excel formulas + Cash Flow projections |
| **Quote Distribution** | Outlook Email Integration (VBA) |
| **Version Control** | Auto-named PDFs & Quote Logs |

---

## 🧱 System Architecture (Simplified Flow)

```mermaid
graph TD
A[Excel User Input] --> B[Stock / Transport / Ad-Hoc Tables]
B --> C[Power Query Transform]
C --> D[Combined Cost Table]
D --> E[Finance Model]
E --> F[Selling Price + Gross Profit]
F --> G[Quote Sheets]
G --> H[VBA PDF Export + Email]
H --> I[Quote Register (Log)]
🧩 Impact
Reduced costing errors and inconsistencies

Streamlined quoting process from hours to minutes

Improved visibility into deal profitability

Enhanced collaboration between Finance, Sales, and Operations

Fully auditable cost and quote history

🧰 Technologies Used
Category	Tools / Technologies
Core Application	Microsoft Excel
Automation	VBA (41 custom modules)
ETL / Data Prep	Power Query (M Language)
Database	SAP SQL Server Queries
Reporting / Output	PDF, Outlook Email Integration
Security	Sheet Protection + Controlled Access


