# Promotion-and-Proposal-Analysis-Project

## About the Dataset

This project uses a relational database from CompanyX, containing multiple interconnected tables designed to support analysis of sales performance, promotions, and proposal strategies.

## Key dataset components:

- **SalesOrderHeader & SalesOrderDetail**

Provide the timeline for pre/post-promotion analysis and granular fields like order totals, unit prices, and discount amounts. They allow reconstruction of bundles and evaluation of intended vs. actual discount performance.

- **Product (Production)**

Includes ListPrice and StandardCost, which are crucial for margin and product lifecycle profitability analysis.

- **SpecialOffer & SpecialOfferProduct**

Define discount type, category, and percentage, and specify which products are targeted—enabling measurement of take-up rates and promotion ROI.

- **SalesReason**

Provides qualitative context for orders (e.g., “Price,” “Promotion”), helping differentiate organic vs. promotion-driven sales.


## 🧭 Project Overview

The goal of this project is to support CompanyX in transitioning from broad, non-targeted promotions to a data-driven, customer-specific, and profit-optimized promotion strategy.
The analysis focuses on three main areas:

1. Datawarehouse design
2. Machine Learning Modeling for Profitability & Segmentation
3. Power BI Interactive Reporting

## 📊 Datawarehouse design

The data warehouse is designed to support analysis of promotion patterns, sales performance, and proposal strategies by organizing data into a Star Schema with Slowly Changing Dimension (SCD) Type 2 tables, enabling accurate historical tracking. Sales data serves as the central fact table, as it best reflects the business objective of promotions—driving revenue—and connects more directly to related OLTP tables than promotion data alone. Source tables from the operational database, including customer, product, territory, promotion, and sales order tables, are extracted and transformed into staging tables that mirror the final warehouse structure.
<img width="614" height="704" alt="image" src="https://github.com/user-attachments/assets/45008b24-99a2-42fe-9b90-17c11dda1c67" />

## 🤖 Machine Learning Methods

The machine learning component focuses on deriving insights that guide targeted promotions:

**1. RFM Segmentation**
Customers were classified based on their purchasing recency, frequency, and spending patterns. Segments such as Champions, Loyal, and At-Risk were identified to support personalized promotions.

**2. Profit Driver Modeling (Ridge Regression)**
A regression model was used to quantify how profit per unit is influenced by factors such as:
- Seasonality
- Region/Territory
- Promotion Type
- Customer Segment
=> This helped determine when, where, and to whom promotions generate the highest returns.

**3. Market Basket Analysis**
Association analysis (Apriori) was used to detect product combinations with strong co-purchase patterns.
This supports:
- Bundle creation
- Cross-sell strategies
- Discount simulations for product groups

**4. Price Elasticity Simulation**
Using elasticity estimates, simulations were run to evaluate how different discount rates impact total and unit profit.
This was used to propose optimal discount levels for bundles and campaigns.

## 📊 Power BI Visualization

An interactive Power BI dashboard was created to present insights in a visually intuitive format.

**Key dashboards screenshot:**
![Dashboard1](https://github.com/user-attachments/assets/f0f9ca73-84ae-4f71-8d57-21e201ad265d)
![Dashboard2](https://github.com/user-attachments/assets/28009fc7-ebc9-4e48-b1fd-5e722312fe4e)

## 🎯 Key Insights:

- **Winter and Spring showed the strongest positive impact on profit**, making them optimal windows for high-margin campaigns.

- **North America was the most profitable region**, outperforming markets like the Pacific.

- **Champions respond positively to volume discounts**, while other segments experience reduced profitability under the same promotion type.

- **Product bundling provides significant uplift**, with certain product pairs demonstrating strong affinity.

- **Simulated discounts identified optimal promotional levels**, such as an 11% bundle discount yielding higher total profit than the baseline.

