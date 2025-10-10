
---

## 1. Project Overview

- **Dataset Used:**
  Instacart Market Basket dataset

- **Goal of the Exercise:**
  Transform normalized transactional data into a dimensional star schema for business intelligence and analytics.
  
- **Team Setup:**  
  Group collaboration with task splitting across cleaning, data quality checking, modeling, BI dashboarding, and documentation.
  We adjusted workloads based on availability and supported each other when issues arose.

- **Environment Setup:**  
  - Shared ClickHouse instance running in Docker for group development
  - Local dbt setups for individual testing and building

---

## 2. Architecture & Workflow

- **Pipeline Flow:**  
  *<img width="1021" height="328" alt="image" src="https://github.com/user-attachments/assets/7c013795-2f87-4813-9099-023b1eed4537" /> *  

- **Tools Used:**  
  - Ingestion: dlt (skipped)
  - Database: Clickhouse (Docker setup)
  - Data quality check: dbt (SQL-based transformation)
  - Modeling: dbt (SQL-based transformation)
  - Testing and queries: Dbeaver 
  - Visualization: Metabase

- **Medallion Architecture Application:**  
  - **Bronze (Raw):** Initial ingestion of source data  
  - **Silver (Clean):** Cleaning, type casting, handling missing values  
  - **Gold (Mart):** Business-ready star schema for BI  

---

## 3. Modeling Process

- **Source Structure (Normalized):**
  - **To meet 3NF normalization standards, each table contains data that are relevant to its entity:**
    - No transitive dependencies
    - All non-key attributes depend on the primary key
    - No repeating groups
      
  *3NF ERD:*
    <img width="1089" height="466" alt="INSTA_ERD_CLEAN" src="https://github.com/user-attachments/assets/c535a18f-0636-4852-83d3-1ed8949fd03a" />

- **Star Schema Design:**  
  - Fact Tables: *FactOrders , FactOrderProduct* 
  - Dimension Tables: *Aisles, Departments, Dow, Products, Users,*
    
    <img width="914" height="594" alt="INSTA_STAR_SCHEMA" src="https://github.com/user-attachments/assets/0db34f0c-939a-4c55-8052-5023fd044598" />

- **Challenges / Tradeoffs:**
    - Ensuring dataset normalization to 3NF.
    - Understanding test syntax, schema configuration, and edge case coverage in dbt unit tests.

---

## 4. Collaboration & Setup

- **Task Splitting:**  
  - Ingestion: Python + dlt scripts (skipped)
  - Modeling: distributed among everyone
  - Visualization: Metabase dashboards
  - Documentation: README & presentation outline

- **Shared vs Local Work:**  
  - Shared ClickHouse instance sometimes caused sync/version conflicts
  - Local dbt environments allowed independent testing before merging

- **Best Practices Learned:**  
  - Clear naming convention
  - Documenting assumptions and using tracker for tasks assignments

---

## 5. Business Questions & Insights

- **Business Questions Explored:**  
  1. What are the most reordered products?
  2. What is the top aisle in terms of number of sales?
  3. What is the average basket size per transaction?
  4. What time of the day and day of week has the most transaction?
  5. What is the customer segmentation in terms of low, moderate, high spenders?

- **Dashboards / Queries:**  
  *(Add screenshots, SQL snippets, or summaries of dashboards created in Metabase.)*  

- **Key Insights:**  
  - *(Highlight 1–2 interesting findings. Example: “Rock was the top genre in North America, while Latin genres dominated in South America.”)*  

---

## 6. Key Learnings

- **Technical Learnings:**  
  *(E.g., SQL joins, window functions, dbt builds/tests, schema design.)*  

- **Team Learnings:**  
  *(E.g., collaboration in shared environments, version control, importance of documentation.)*  

- **Real-World Connection:**  
  *(How this exercise relates to actual data engineering workflows in industry.)*  

---

## 7. Future Improvements

- **Next Steps with More Time:**  
  *(E.g., add orchestration with Airflow/Prefect, implement testing, optimize queries, handle larger datasets.)*  

- **Generalization:**  
  *(How this workflow could be applied to other datasets or business domains.)*  


---

✅ By filling this template, your group will produce a professional-style project guide **just like real data engineers** — clear, structured, and insight-driven.
