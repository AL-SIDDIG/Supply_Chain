# Supply Chain Performance Dashboard

SQL • Power BI • Data Analytics

![Dashboard](./PowerBi/assets/overview.png)

[_View full Dashboard on PwerBI Service_](https://app.powerbi.com/groups/me/reports/6738a7d8-b1ca-4afc-a73e-fde5eceb25fe/598c3af910ae4d66c115?experience=power-bi)

[_View Project on LinkedIn_](https://www.linkedin.com/in/al-siddig-amasaib-668a66117/)

## Project Overview

This project analyzes supply chain operations to identify **delivery delays, sales performance, and profitability drivers.**

Using **SQL** for **date cleaning & transformation** and **PowerBI for visualization**, the dashboard provides actionable insights into shipping efficiency, customer demand, and category performance.

The goal is to simulate a **real-world supply chain analytics scenario** and demonstrate end-to-end data analysis skills.

## 🎯 Business Questions Answered

- Which shipping modes cause the most delivery delays?
- How does late delivery rate change over time?
- Which categories and products drive sales and profit?
- How do regions perform in terms of sales and profitability?
- What percentage of orders are delivered late?

## 📁 Dataset

- Source: Kaggle – DataCo Supply Chain Dataset

## 🛠 Tools & Technologies

| Tool       | Purpose                                     |
| ---------- | ------------------------------------------- |
| PostgreSQL | Data loading, cleaning, transformation      |
| SQL        | Data quality checks, business logic         |
| Power BI   | Data modeling, DAX, dashboard visualization |
| VS Code    | SQL development                             |
| pgAdmin 4  | Database management                         |

## Data Cleaning & Preparation (SQL)

Performed entirely using SQL:

- Converted TEXT → numeric fields (sales, profit, quantities)
- Converted TEXT → DATE fields (order date, shipping date)
- Removed:
  - Duplicate header rows
  - Invalid & anomalous records
  - Unnecessary columns (email, passwords)
- Trimmed whitespaces & standardized categories
- Created late_delivery_flag:
  - 1 = Late
  - 0 = On-Time
- Ensured order-level metrics using DISTINCT(order_id)

## 🧠 Key Calculations (DAX)

Using **DAX** I calculate some important mesure that I am going th use in PowerBI

**Late Delivery %**

```DAX
Late Delivery % =
DIVIDE(
    CALCULATE(
        DISTINCTCOUNT(supply_chain_clean[order_id]),
        supply_chain_clean[late_delivery_flag] = 1
    ),
    DISTINCTCOUNT(supply_chain_clean[order_id])
)
```

**Profit Margin**

```DAX
Profit Margin =
DIVIDE([Total Profit], [Total Sales])
```

## 📊 Dashboard Overview

The Power BI dashboard includes:

**KPI Cards**

- Total Sales
- Total Profit
- Profit Margin %
- Late Delivery %
- Total Orders

**Visuals**

- Shipping Mode vs Late Deliveries
- Late Delivery Trend Over Time
- Top Products by Sales
- Category Performance (Sales, Profit, Late %)
- Regional Sales & Profit Comparison
- Yearly Orders & Sales Trend

**Design**

- Dark modern theme
- Conditional formatting on profit
- Custom KPI icons
- Business insight annotations

### 🔍 Key Insights

- Standard Class shipping has the highest late delivery volume, indicating bottlenecks in low-cost shipping.
- 2018 shows the highest late delivery rate, suggesting increased operational strain.
- A small number of products and categories drive the majority of sales.
- Some categories show high sales but low profitability, indicating pricing or cost issues.
- Late delivery rates vary significantly by shipping mode and region.

### 📈 Business Impact

- This analysis helps stakeholders:
- Optimize shipping strategies
- Reduce late deliveries
- Improve category profitability
- Focus on high-value products and regions

## 🚀 How to Run

1. Load dataset into PostgreSQL
2. Run SQL scripts in /sql
3. Open Power BI file
4. Update database connection if needed
5. Refresh data

## 👤 Author

> ALSIDDIG AMASAIB ||

> Data Analyst | SQL • Power BI • Python

> **Email:** siddigalssadig@gmail.com || alsiddigamasaib@gmail.com

> **GitHub:** https://github.com/AL-SIDDIG

> **Linkedin:** https://www.linkedin.com/in/al-siddig-amasaib-668a66117/

## ⭐ Final Notes

This project focuses on:

- Realistic data problems
- Strong SQL foundations
- Business-driven insights
- Clean & professional dashboard design

Feel free to explore, fork, or suggest improvements.
