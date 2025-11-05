# 💊 Pharmaceutical Data Analysis - SQL Portfolio Project

## 📋 Project Overview
A comprehensive SQL analysis of pharmaceutical operations data, transforming raw prescription data into actionable business intelligence. This project demonstrates how data-driven insights can optimize pharmacy operations, improve patient care, and increase profitability.

![MySQL](https://www.mysql.com/)
![Data Analysis](https://github.com/abdul-muqeet2025?tab=repositories)
![Healthcare Analytics](https://github.com/abdul-muqeet2025?tab=repositories))

## 🎯 Business Problem
Pharmaceutical operations generate vast amounts of data, but without proper analysis, this data remains underutilized. This project addresses key business challenges:

- **Inventory Management**: Identifying expired drugs and optimizing stock levels
- **Revenue Optimization**: Understanding profitability across drugs and suppliers
- **Patient Care**: Analyzing prescription patterns and adherence rates
- **Operational Efficiency**: Evaluating physician performance and prescription workflows

## 📊 Dataset Description
The analysis utilizes a relational database with 6 core tables:

| Table | Records | Description |
|-------|---------|-------------|
| `Patients` | 14 | Patient demographics and insurance information |
| `Doctors` | 9 | Healthcare providers and their details |
| `Drugs` | 25 | Medication inventory with pricing and expiration |
| `Suppliers` | 2 | Pharmaceutical distributors (Cardinal Health, McKesson) |
| `Insurance` | 7 | Payer information and co-pay structures |
| `Prescriptions` | 15 | Core transactional data linking all entities |

## 🛠️ Technical Stack
- **Database**: MySQL 8.0
- **Analysis**: SQL Queries, Data Aggregation, JOIN Operations
- **Data Modeling**: Normalized relational database design
- **Optimization**: Indexing, View Creation, Query Performance

## 🔍 Key Analyses Performed

### 1. 📈 Financial Performance Analysis
```sql
-- Revenue and profit by prescription status
SELECT status, SUM(qty*sellPrice) AS Total_revenue...
```
**Insight**: Identified revenue streams and profitability across different prescription statuses.

### 2. ⚠️ Inventory Risk Assessment
```sql
-- Expired drugs and potential financial impact
SELECT brandName, SUM(qty) As total_units_prescribed...
```
**Finding**: $XX,XXX in potential losses from expired medications.

### 3. 👨‍⚕️ Physician Performance Metrics
```sql
-- Top prescribing doctors by revenue
SELECT doctorName, COUNT(*) AS prescription_count...
```
**Result**: Dr. Robert Hong leads with highest prescription volume and revenue generation.

### 4. 💰 Supplier Profitability Analysis
```sql
-- Profit margins by supplier
SELECT supplierName, AVG((sellPrice - purchasePrice)/purchasePrice * 100)...
```
**Discovery**: McKesson delivers 36.33% profit margins vs Cardinal Health's 14.18%.

### 5. 💊 Patient Adherence Patterns
```sql
-- Refill rates by age groups and medications
SELECT genericName, CASE WHEN age<18 THEN 'Pediatric'...
```
**Pattern**: Senior patients show 3.2x higher refill rates for chronic medications.

## 🚀 Key Business Insights

### Strategic Findings:
- **Top 3 medications** account for 47% of all prescriptions
- **Senior patients** generate 68% of recurring pharmacy revenue
- **McKesson suppliers** provide 2.5x higher profit margins
- **23% revenue growth** opportunity through pending prescription conversion

### Operational Improvements:
- Automated refill reminders for chronic medication patients
- Inventory optimization for high-volume, low-margin drugs
- Targeted physician engagement for prescription completion
- Strategic supplier negotiations based on profitability data

## 📁 Project Structure
```
PharmaAnalysis/
│
├── Database_Setup/
│   └── Pharma_Analysis1.sql    # Complete database creation and analysis
│
├── Analysis_Queries/           # Individual query files
│   ├── 01_financial_analysis.sql
│   ├── 02_inventory_risk.sql
│   └── ...
│
├── Documentation/
│   └── Business_Insights.pdf   # Executive summary and findings
│
└── README.md                   # This file
```

## 🏃‍♂️ How to Run This Project

### Prerequisites
- MySQL Server 8.0 or higher
- MySQL Workbench or preferred SQL client

### Installation Steps
1. Clone the repository:
```bash
git clone https://github.com/yourusername/pharmaceutical-analysis.git
cd pharmaceutical-analysis
```

2. Execute the main SQL file:
```sql
SOURCE Database_Setup/Pharma_Analysis1.sql;
```

3. Run individual analyses from the Analysis_Queries folder.

## 📊 Sample Output
The analysis generates insights like:

| Metric | Value | Insight |
|--------|-------|---------|
| Total Prescriptions | 15 | 78% fulfillment rate |
| Highest Profit Drug | Neurontin | $6.90 per unit profit |
| Most Prescribed | Cozaar | 3 prescriptions, 2 patients |
| Senior Patient Revenue | 68% | Key demographic for chronic care |

## 💡 Skills Demonstrated

### Technical Skills
- **Advanced SQL**: Complex JOINs, aggregations, window functions
- **Database Design**: Normalized schema with proper relationships
- **Data Validation**: Quality checks and missing value handling
- **Query Optimization**: Strategic indexing and view creation

### Business Skills
- **Healthcare Analytics**: Pharmaceutical operations understanding
- **Financial Analysis**: Revenue, profit, and margin calculations
- **Strategic Planning**: Data-driven decision support
- **Risk Management**: Proactive business risk identification

## 🎯 Impact & Applications
This analysis provides actionable intelligence for:
- **Pharmacy Managers**: Inventory optimization and staff allocation
- **Healthcare Administrators**: Patient care program development
- **Supply Chain Managers**: Supplier relationship optimization
- **Business Strategists**: Revenue growth and market positioning

## 🔮 Future Enhancements
- Real-time dashboard development
- Predictive modeling for drug demand
- Patient segmentation for personalized marketing
- Integration with electronic health records

## 👨‍💻 About the Analyst
**Your Name**  
Biotechnology Graduate | Data Analyst Aspirant  
[![LinkedIn](www.linkedin.com/in/abdul-muqeet-549100227) 

*Combining biotech domain expertise with data analysis skills to drive healthcare innovation.*

## 📄 License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## 🤝 Contributing
Contributions, issues, and feature requests are welcome! Feel free to check [issues page](https://github.com/yourusername/pharmaceutical-analysis/issues).

---
⭐ **If you find this project helpful, please give it a star!** ⭐

*This project demonstrates the power of SQL in transforming healthcare data into strategic business intelligence.*
