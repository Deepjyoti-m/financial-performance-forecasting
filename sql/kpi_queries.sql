-- ============================================
-- Financial Performance KPI Queries
-- Dataset: Superstore Financial Data
-- Author: Deepjyoti
-- ============================================


-- ============================================
-- 1. MONTHLY REVENUE
-- ============================================
SELECT
    year_month,
    SUM(revenue) AS total_revenue
FROM financial_cleaned
GROUP BY year_month
ORDER BY year_month;


-- ============================================
-- 2. REVENUE BY PRODUCT CATEGORY
-- ============================================
SELECT
    year_month,
    product,
    SUM(revenue) AS total_revenue
FROM financial_cleaned
GROUP BY year_month, product
ORDER BY year_month, total_revenue DESC;


-- ============================================
-- 3. REVENUE BY REGION
-- ============================================
SELECT
    region,
    SUM(revenue)        AS total_revenue,
    SUM(profit)         AS total_profit,
    ROUND(SUM(profit) / SUM(revenue) * 100, 2) AS gross_margin_pct
FROM financial_cleaned
GROUP BY region
ORDER BY total_revenue DESC;


-- ============================================
-- 4. GROSS MARGIN BY PRODUCT
-- ============================================
SELECT
    product,
    SUM(revenue)        AS total_revenue,
    SUM(cost)           AS total_cost,
    SUM(profit)         AS total_profit,
    ROUND(SUM(profit) / SUM(revenue) * 100, 2) AS gross_margin_pct
FROM financial_cleaned
GROUP BY product
ORDER BY gross_margin_pct DESC;


-- ============================================
-- 5. MONTH OVER MONTH (MoM) REVENUE GROWTH
-- ============================================
WITH monthly_revenue AS (
    SELECT
        year_month,
        SUM(revenue) AS total_revenue
    FROM financial_cleaned
    GROUP BY year_month
)
SELECT
    year_month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY year_month) AS prev_month_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY year_month))
        / LAG(total_revenue) OVER (ORDER BY year_month) * 100, 2
    ) AS mom_growth_pct
FROM monthly_revenue
ORDER BY year_month;


-- ============================================
-- 6. YEAR OVER YEAR (YoY) REVENUE GROWTH
-- ============================================
WITH yearly_revenue AS (
    SELECT
        SUBSTR(year_month, 1, 4) AS year,
        SUM(revenue) AS total_revenue
    FROM financial_cleaned
    GROUP BY year
)
SELECT
    year,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY year) AS prev_year_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY year))
        / LAG(total_revenue) OVER (ORDER BY year) * 100, 2
    ) AS yoy_growth_pct
FROM yearly_revenue
ORDER BY year;


-- ============================================
-- 7. TOP 5 MOST PROFITABLE MONTHS
-- ============================================
SELECT
    year_month,
    SUM(revenue) AS total_revenue,
    SUM(profit)  AS total_profit,
    ROUND(SUM(profit) / SUM(revenue) * 100, 2) AS gross_margin_pct
FROM financial_cleaned
GROUP BY year_month
ORDER BY total_profit DESC
LIMIT 5;


-- ============================================
-- 8. OVERALL FINANCIAL SUMMARY
-- ============================================
SELECT
    COUNT(DISTINCT year_month)  AS total_months,
    ROUND(SUM(revenue), 2)      AS total_revenue,
    ROUND(SUM(cost), 2)         AS total_cost,
    ROUND(SUM(profit), 2)       AS total_profit,
    ROUND(SUM(profit) / SUM(revenue) * 100, 2) AS overall_margin_pct
FROM financial_cleaned;
```

---

## Commit message to use:
```
Add SQL KPI queries for financial performance analysis
