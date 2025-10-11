# **📝 Instacart Market Basket Analysis Documentation - Group 1**

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
  <img width="1021" height="328" alt="image" src="https://github.com/user-attachments/assets/7c013795-2f87-4813-9099-023b1eed4537" /> 

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

## 4. Data Quality Check
Data quality checks ensure that the data used in your pipeline is clean, consistent, and reliable before it is consumed by downstream models, dashboards, or business logic.

#### 🧪 Purpose of Data Quality Checks

- **Ensure structural integrity**
  - Catch missing values (`not_null`)
  - Detect duplicate keys (`unique`)
  - Validate foreign key relationships (`relationships`)

- **Enforce domain constraints**
  - Confirm values fall within expected ranges (e.g., `order_dow` between 0–6)
  - Flag invalid categories (e.g., `eval_set` not in ['prior', 'train', 'test'])

- **Protect downstream logic**
  - Prevent broken joins or misleading aggregations
  - Ensure dashboards and KPIs reflect clean, reliable data

- **Support debugging and monitoring**
  - Surface anomalies early during development

```bash
- Test Result schema.yml:
  PASS=79 WARN=0 ERROR=0 SKIP=0 TOTAL=79
```

##### [View DQ-INSTA-TESTS-GRP-1.md on GitHub](https://github.com/cj-a-murillo/ftw-de-bootcamp-grp1-new/blob/main/dq-insta-tests-grp1.md)
##### [DQ Dashboard - Instacart](http://54.87.106.52:3001/dashboard/52-instacart?tab=77-dq-ref-integrity&text=)
---

## 5. Collaboration & Setup

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
  - Documenting assumptions and using a tracker for task assignments

---

## 6. Business Questions & Insights

- **Business Questions Explored:**  
  1. What are the most reordered products?
  2. What is the top aisle in terms of number of sales?
  3. What is the average basket size per transaction?
  4. What time of the day and day of the week has the most transactions?
  5. What is the customer segmentation in terms of low, moderate, and  high spenders?

- **Dashboards / Queries:**  
  <img width="679" height="780" alt="image" src="https://github.com/user-attachments/assets/f6852322-4f05-430d-9ab8-a8c6c22d5812" />

##### [View Metabase Documentation on GitHub](https://github.com/cj-a-murillo/ftw-de-bootcamp-grp1-new/blob/main/documentations/metabase.md)

---

## 7. Key Learnings

- **Technical Learnings:**  
  - Learned how to define column-level tests (not_null, unique, accepted_values) in schema.yml.
  - Learned macro structure, templating, and parameterization for scalable testing.
  - Normalized data to 3NF: Ensured all non-key attributes are fully dependent on the primary key, eliminating redundancy and improving data integrity across staging models.
    
- **Team Learnings:**  
  - Practiced collaborative modeling and task splitting across  modeling, data quality checks, visualization, and documentation.
  - Learned the value of clear ownership and modular workflows for smoother onboarding and handoffs.

- **Real-World Connection:**  
  - Simulated production workflows:
    - Modeled data in Third Normal Form (3NF) to reduce redundancy and improve integrity
    - Validated models using dbt unit tests for structure and referential accuracy
    - Documented assumptions and logic for team onboarding and stakeholder visibility

---

## 8. Future Improvements

- **Next Steps with More Time:**  
  *(E.g., add orchestration with Airflow/Prefect, implement testing, optimize queries, handle larger datasets.)*  

- **Generalization:**  
  *(How this workflow could be applied to other datasets or business domains.)*  


---
