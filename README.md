# Promotion-and-Proposal-Analysis-Project
About the Dataset

This project uses a relational database from CompanyX, containing multiple interconnected tables designed to support analysis of sales performance, promotions, and proposal strategies.

Key dataset components:

Sales Tables

SalesOrderHeader & SalesOrderDetail
Provide the timeline for pre/post-promotion analysis and granular fields like order totals, unit prices, and discount amounts. They allow reconstruction of bundles and evaluation of intended vs. actual discount performance.

Product Table

Product (Production)
Includes ListPrice and StandardCost, which are crucial for margin and product lifecycle profitability analysis.

Promotion Tables

SpecialOffer & SpecialOfferProduct
Define discount type, category, and percentage, and specify which products are targeted—enabling measurement of take-up rates and promotion ROI.

Sales Reason

SalesReason
Provides qualitative context for orders (e.g., “Price,” “Promotion”), helping differentiate organic vs. promotion-driven sales.

Supporting Dimensions

Customer demographics

Territories (regional performance)

Shipping methods
All supporting a complete analytical business view.

🧭 Project Overview

CompanyX aims to transition from a generic marketing strategy to a data-driven, personalized framework. This project builds an end-to-end BI solution that transforms operational data into actionable insights.

Core analytical goals:

Customer Segmentation
Classify customers to enable personalized targeting instead of broad promotions.

Product Affinity Analysis
Identify frequently co-purchased items to design profitable bundles.

Promotion Optimization
Predict optimal timing, offer type, and customer targets to maximize ROI.

