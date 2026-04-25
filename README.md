# 📊 Bank Risk & Transaction Analytics | Reduced Financial Loss Exposure Through Risk Segmentation

------

## 📌 End-to-End Data Analysis to Detect High-Risk Accounts, Prevent Losses, and Improve Financial Decision-Making

------

## 📊 Project Overview

Financial institutions lose millions due to **poor visibility into account risk and transaction behavior**.

In this project, I simulated a **real-world banking environment with messy data** and built an **end-to-end solution** to:

- Identify **high-risk accounts**  
- Detect **transaction anomalies**  
- Quantify **financial loss exposure**  

The result: a **data-driven framework** to help banks proactively manage risk and reduce losses.

🔗 **Live Dashboard:**  
https://app.powerbi.com/groups/me/reports/a8689f7f-4fce-4c7b-a3fa-4d7754b4e4f2?pbi_source=desktop

------

## ❗ Business Problem

Banks often operate with **limited visibility** into:

- Which customers are generating financial losses  
- Where risky transactions are occurring  
- How much exposure exists across accounts  

👉 This leads to:

- Uncontrolled **negative balances**  
- Increased **fraud risk**  
- Poor **risk management decisions**  

👉 **Key Question:**  
How can we identify and reduce financial risk **before it impacts profitability**?

------

## 🎯 Objectives

- Detect **high-risk accounts** based on financial behavior  
- Identify **abnormal transaction patterns**  
- Measure total **financial loss exposure**  
- Segment customers by **risk and balance level**  
- Deliver **actionable insights** to reduce risk and improve decisions  

------

## 🧠 Data Processing & Transformation (SQL)

To simulate real-world conditions, the dataset included **dirty and inconsistent data**, requiring a full data cleaning process.

### 🔹 Key Data Challenges
- Inconsistent date formats  
- Null values and incomplete records  
- Invalid relationships (CustomerID mismatches)  
- Duplicate transactions  
- Outliers and abnormal values  

### 🔹 Data Cleaning Approach
- Standardized text fields using **UPPER()**  
- Converted dates using **TRY_CONVERT()**  
- Removed duplicates using **ROW_NUMBER()**  
- Handled null values and invalid records  
- Built business logic for:
  - Risk classification  
  - Transaction flow (**Money In / Money Out**)  

### 📂 Final Data Model
- Customers_Final  
- Accounts_Final  
- Transactions_Final  
- Bank_Final (analytical dataset for reporting)  

👉 Result: **Clean, reliable dataset ready for business analysis**

------

### 📊 Dashboard Overview (Power BI)
## 🔍 Business Question 1: How is the overall financial performance and customer behavior?

This section analyzes transaction trends, customer segmentation, and account distribution to understand overall bank performance.

<img width="1429" height="801" alt="loanbank2proyect1" src="https://github.com/user-attachments/assets/de9b6790-dade-4865-a670-e847e252b47c" />

<img width="1431" height="806" alt="loanbank2proyectpart2" src="https://github.com/user-attachments/assets/0bd080d5-2055-4ca0-b21e-54193f0c8cd6" />

Why?
Because both show:

Transactions over time
Customer distribution
Account types
Revenue / balances


### 📊 SECOND SECTION
## 🔍 Business Question 2: Who are the key customers and what drives value?

<img width="1431" height="806" alt="loanbank2proyectpart2" src="https://github.com/user-attachments/assets/0bd080d5-2055-4ca0-b21e-54193f0c8cd6" />

<img width="1429" height="801" alt="loanbank2proyect1" src="https://github.com/user-attachments/assets/de9b6790-dade-4865-a670-e847e252b47c" />

Explain:

Top customers
Balance by name
Customer segmentation (age, gender)

### THIRD SECTION
## ⚠️ Business Question 3: Where is the financial risk and how can it be reduced?

This section focuses on identifying high-risk accounts, financial loss exposure, and abnormal transaction behavior.

<img width="1430" height="805" alt="loanbank2proyectpart3riskdashboard" src="https://github.com/user-attachments/assets/6589db00-b7c5-4687-84ed-e7f91e28d627" />


--------------
------

## 🧠 Key Insights

- A segment of accounts is in **negative balance**, directly impacting profitability  
- Financial loss exposure is **concentrated in a small group of customers**  
- High-risk outflow transactions suggest **potential leakage or fraud**  
- Risk follows a **Pareto distribution (80/20)**  
- Medium-balance customers represent an **opportunity to prevent future losses**  

------

## 💡 Business Impact

- Identified **high-risk accounts** responsible for most losses  
- Quantified total **negative balance exposure** (key KPI)  
- Enabled **proactive monitoring** of risk and transactions  
- Provided a framework to **reduce losses and improve profitability**  

👉 **Estimated impact:**  
Potential reduction in financial losses through **targeted risk control strategies**

------

## 📌 Business Recommendations

- Implement **debt recovery strategies** for high-risk customers  
- Monitor and flag **high-risk transactions in real time**  
- Improve **customer segmentation models**  
- Introduce **automated alerts** for abnormal financial behavior  
- Incentivize **medium-risk customers** to maintain positive balances  

------

## 🛠️ Tools & Technologies

- SQL Server → Data cleaning, transformation, and modeling  
- Power BI → Dashboard development and visualization  
- DAX → Business metrics and calculations  

------

## 🚀 What Makes This Project Valuable

- ✔ Simulates **real-world messy data scenarios**  
- ✔ Demonstrates **end-to-end workflow (ETL → Analysis → Visualization)**  
- ✔ Focuses on **business impact**, not just technical execution  
- ✔ Applies **risk analysis** (high-demand skill in finance & fintech)  

------

## 👤 Author

**Abraham Isaac Riveros Mckay Reyes**  
Data Analyst | SQL | Power BI | Business Intelligence  

📧 Email: abrahamrmr@hotmail.com  
🔗 LinkedIn: https://www.linkedin.com/in/abraham-riveros-ab23751a9/

-------------------------------------
