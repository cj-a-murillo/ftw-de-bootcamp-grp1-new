## 🍒🧺 Instacart Market Analysis: Business Insights & Metabase Implementation

This file documents the analysis performed on the e-commerce dataset, detailing the key business questions explored, the Metabase dashboard components created, sql queries, and the primary insights derived from the data.

### Business Questions & Insights 

**1. What are the most reordered products?**
**2. What is the top aisle in terms of number of sales?**
**3. What is the average basket size per transaction?**
**4. What time of the day and day of week has the most transaction?**
**5. What is the customer segmentation in terms of low, moderate, and high spenders?**
**6. What is the rate of reordered products versus first-time purchases?**

---
## 🧑‍💻 Sample Queries

**1. Most Reordered Products**
```
SELECT
    p.product_name,
    SUM(fp.reordered) AS total_reorders
FROM
    g1_insta_FactOrderProduct fp 
JOIN
    g1_insta_DimProducts p ON fp.product_id = p.product_id
WHERE
    fp.reordered = 1 -- Filter for actual reorders
GROUP BY
    p.product_name
ORDER BY
    total_reorders DESC
LIMIT 10; -- Adjust limit as needed
```

**2.  Top Aisled by Transaction Volume**

```
SELECT
    a.aisle,
    COUNT(fp.order_id) AS total_transactions
FROM
    g1_insta_FactOrderProduct fp 
JOIN
    g1_insta_DimAisles a ON fp.aisle_id = a.aisle_id
GROUP BY
    a.aisle
ORDER BY
    total_transactions DESC
LIMIT 10; -- Adjust limit as needed
```

**3. Average Basket Size**
```
SELECT
    AVG(product_count) AS average_basket_size
FROM (
    SELECT
        order_id,
        COUNT(product_id) AS product_count 
    FROM
        g1_insta_FactOrder
    GROUP BY
        order_id
) AS order_products;
```
**4. Transactions by Day of the Week**
```
SELECT
    dd.day, 
    COUNT(fo.order_id) AS total_transactions
FROM
    g1_insta_FactOrder fo
JOIN
    g1_insta_DimDow dd ON fo.order_dow = dd.order_dow 
GROUP BY
    dd.day, fo.order_dow -- Group by order_dow to ensure correct day order if needed
ORDER BY
    total_transactions DESC;
```
**5. User Order Frequency Distribution**
```
SELECT
    fu.user_id,
    COUNT(fo.order_id) AS total_orders,
    MAX(fo.days_since_prior_order) AS max_days_between_orders,
    MIN(fo.days_since_prior_order) AS min_days_between_orders
FROM
    g1_insta_FactOrder fo
JOIN
    g1_insta_DimUsers fu ON fo.user_id = fu.user_id
GROUP BY
    fu.user_id
ORDER BY
    total_orders DESC
```
**6. Percentage of Reorders vs. First-Time Purchases**
```
SELECT
    SUM(CASE WHEN fop.reordered = 1 THEN 1 ELSE 0 END) AS total_reordered,
    SUM(CASE WHEN fop.reordered = 0 THEN 1 ELSE 0 END) AS total_first_time_purchase,
    CAST(SUM(CASE WHEN fop.reordered = 1 THEN 1 ELSE 0 END) AS REAL) * 100 / COUNT(fop.product_id) AS reorder_rate_percentage
FROM
    g1_insta_FactOrderProduct AS fop; 
```
## 📊 Sample Dashboards
![metabase dashboard](../documentations/assets/metabase-db.png)

### Key Insights
-   **High Customer Loyalty & Habitual Shopping:** The consistently high **Average Basket Size (10.11 products)**, combined with the dominance of staple items (**Banana** as the top reordered product and **Fresh Fruits** as the top aisle), indicates that customers heavily use the service for their regular, habitual grocery replenishment.
    
-   **Sunday Operations are Critical:** Transaction volume sharply peaks on **Sunday**, making this the most crucial day for operational staffing, logistics planning, and targeted promotional campaigns (e.g., weekend/pre-week specials).
    
-   **Data-Driven Inventory Focus:** Inventory management and stocking efforts should prioritize the **Fresh Fruits** and **Fresh Vegetables** aisles, as they represent the highest proportion of transaction volume.  