# Supply Chain Costing Database

This project contains a **MySQL relational database** that models the costing process for deals in a supply chain company.  
It is designed to replicate and improve upon the logic of an existing Excel costing sheet, making it easier to manage, query, and analyze costing data across multiple deals.

---

## 🧠 Project Overview

Each **deal** (identified by a unique Deal Number) brings together multiple cost elements:

- **Stock Costs** – purchase and inventory costs for goods supplied  
- **Transport Costs** – logistics and delivery expenses  
- **Ad-Hoc Costs** – one-off costs such as clearance, packaging, or permits  
- **Sales Summary** – sales values, gross profit, and cost analysis  
- **Cashflow Timing** – inflows and outflows for financing cost calculations  
- **Deal Overview** – overarching financial and status information per deal

The database mirrors these elements as normalized relational tables.

---

## 🗂️ Database Structure

### Core Tables
| Table | Description |
|--------|--------------|
| `deal` | Main header table containing deal metadata and summary values |
| `deal_stock_cost` | Stock purchase details (product, quantity, cost) |
| `deal_transport_cost` | Transport charges and routes |
| `deal_ad_hoc_cost` | Ad-hoc or special costs related to the deal |
| `deal_sales_line` | Sales and gross profit breakdown per deal |
| `deal_cash_inflow` | Cash inflow timing and terms from the customer |
| `deal_cash_outflow` | Cash outflow timing and supplier payments |

### Supporting / Reference Tables
| Table | Description |
|--------|--------------|
| `sales_rep` | Sales representative master list |
| `client` | Client details, including payment terms and credit info |
| `product` | Product master data |
| `stock_item` | Stock references and unit of measure links |
| `unit_of_measure` | Units such as MT, L, or Kg |
| `transport_company` | List of transport providers |
| `ad_hoc_cost_type` | Types of ad-hoc costs (e.g., Clearance, Bagging) |
| `deal_status`, `inco_term` | Lookup tables for deal stages and incoterms |
| `city`, `country`, `location` | Geographic reference data |

---

## 💾 Files

- `schema_dump.sql` – Full MySQL dump containing table structure and optional sample data  
- `README.md` – Documentation for the project (this file)

---

## ⚙️ How to Use

1. Create a database in MySQL:
   ```sql
   CREATE DATABASE supply_chain_costing;
   USE supply_chain_costing;
