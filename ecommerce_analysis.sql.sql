-- ============================================================
--   E-COMMERCE SALES ANALYSIS
--   Dataset : Olist Brazilian E-commerce (100,000+ Orders)
--   Tool    : SQLite - DB Browser
--   Author  : Pradhipa S
-- ============================================================


-- ============================================================
--   STEP 1 : VERIFY DATABASE
-- ============================================================

-- Check all tables loaded correctly
SELECT name FROM sqlite_master WHERE type='table';

-- Check row counts
SELECT COUNT(*) AS orders    FROM olist_orders_dataset;
SELECT COUNT(*) AS customers FROM olist_customers_dataset;
SELECT COUNT(*) AS items     FROM olist_order_items_dataset;
SELECT COUNT(*) AS payments  FROM olist_order_payments_dataset;
SELECT COUNT(*) AS reviews   FROM olist_order_reviews_dataset;
SELECT COUNT(*) AS products  FROM olist_products_dataset;
SELECT COUNT(*) AS sellers   FROM olist_sellers_dataset;
SELECT COUNT(*) AS category  FROM product_category_name_translation;


-- ============================================================
--   STEP 2 : EXPLORE DATA
-- ============================================================

-- Preview each table
SELECT * FROM olist_orders_dataset        LIMIT 5;
SELECT * FROM olist_customers_dataset     LIMIT 5;
SELECT * FROM olist_order_items_dataset   LIMIT 5;
SELECT * FROM olist_order_payments_dataset LIMIT 5;
SELECT * FROM olist_order_reviews_dataset  LIMIT 5;
SELECT * FROM olist_products_dataset       LIMIT 5;
SELECT * FROM olist_sellers_dataset        LIMIT 5;
SELECT * FROM product_category_name_translation LIMIT 5;


-- ============================================================
--   STEP 3 : ANALYSIS QUERIES
-- ============================================================


-- Q1: Total Revenue
SELECT
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM olist_order_payments_dataset;


-- Q2: Monthly Revenue Trend
SELECT
    strftime('%Y-%m', order_purchase_timestamp) AS month,
    ROUND(SUM(payment_value), 2)                AS monthly_revenue
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p
    ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;


-- Q3: Top 10 States by Revenue
SELECT
    c.customer_state                AS state,
    ROUND(SUM(p.payment_value), 2)  AS revenue,
    COUNT(DISTINCT o.order_id)      AS total_orders
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
JOIN olist_order_payments_dataset p
    ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC
LIMIT 10;


-- Q4: Top 10 Product Categories by Revenue
SELECT
    t.product_category_name_english AS category,
    ROUND(SUM(i.price), 2)          AS revenue,
    COUNT(DISTINCT i.order_id)      AS total_orders
FROM olist_order_items_dataset i
JOIN olist_products_dataset pr
    ON i.product_id = pr.product_id
JOIN product_category_name_translation t
    ON pr.product_category_name = t.product_category_name
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;


-- Q5: Order Status Breakdown
SELECT
    order_status,
    COUNT(*)  AS total_orders,
    ROUND(COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM olist_orders_dataset), 2) AS percentage
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;


-- Q6: Average Order Value by Payment Type
SELECT
    payment_type,
    COUNT(*)                      AS total_orders,
    ROUND(AVG(payment_value), 2)  AS avg_order_value,
    ROUND(SUM(payment_value), 2)  AS total_revenue
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY total_revenue DESC;


-- Q7: Top 10 Sellers by Revenue
SELECT
    i.seller_id,
    s.seller_city,
    s.seller_state,
    ROUND(SUM(i.price), 2)      AS revenue,
    COUNT(DISTINCT i.order_id)  AS total_orders
FROM olist_order_items_dataset i
JOIN olist_sellers_dataset s
    ON i.seller_id = s.seller_id
GROUP BY i.seller_id
ORDER BY revenue DESC
LIMIT 10;


-- Q8: Average Review Score by Category
SELECT
    t.product_category_name_english AS category,
    ROUND(AVG(r.review_score), 2)   AS avg_review_score,
    COUNT(*)                        AS total_reviews
FROM olist_order_reviews_dataset r
JOIN olist_orders_dataset o
    ON r.order_id = o.order_id
JOIN olist_order_items_dataset i
    ON o.order_id = i.order_id
JOIN olist_products_dataset p
    ON i.product_id = p.product_id
JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY category
HAVING total_reviews > 100
ORDER BY avg_review_score DESC
LIMIT 10;


-- Q9: Average Delivery Days by State
SELECT
    c.customer_state,
    ROUND(AVG(
        julianday(o.order_delivered_customer_date) -
        julianday(o.order_purchase_timestamp)
    ), 1)        AS avg_delivery_days,
    COUNT(*)     AS total_orders
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days ASC
LIMIT 10;


-- Q10: Customer Repeat Purchase Rate
SELECT
    total_orders,
    COUNT(*)  AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM (
    SELECT
        customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o
        ON c.customer_id = o.customer_id
    GROUP BY customer_unique_id
) customer_orders
GROUP BY total_orders
ORDER BY total_orders;

-- ============================================================
--   E-COMMERCE SALES ANALYSIS
--   Dataset : Olist Brazilian E-commerce (100,000+ Orders)
--   Tool    : SQLite - DB Browser
--   Author  : Pradhipa S
-- ============================================================


-- ============================================================
--   STEP 1 : VERIFY DATABASE
-- ============================================================

-- Check all tables loaded correctly
SELECT name FROM sqlite_master WHERE type='table';

-- Check row counts
SELECT COUNT(*) AS orders    FROM olist_orders_dataset;
SELECT COUNT(*) AS customers FROM olist_customers_dataset;
SELECT COUNT(*) AS items     FROM olist_order_items_dataset;
SELECT COUNT(*) AS payments  FROM olist_order_payments_dataset;
SELECT COUNT(*) AS reviews   FROM olist_order_reviews_dataset;
SELECT COUNT(*) AS products  FROM olist_products_dataset;
SELECT COUNT(*) AS sellers   FROM olist_sellers_dataset;
SELECT COUNT(*) AS category  FROM product_category_name_translation;


-- ============================================================
--   STEP 2 : EXPLORE DATA
-- ============================================================

-- Preview each table
SELECT * FROM olist_orders_dataset        LIMIT 5;
SELECT * FROM olist_customers_dataset     LIMIT 5;
SELECT * FROM olist_order_items_dataset   LIMIT 5;
SELECT * FROM olist_order_payments_dataset LIMIT 5;
SELECT * FROM olist_order_reviews_dataset  LIMIT 5;
SELECT * FROM olist_products_dataset       LIMIT 5;
SELECT * FROM olist_sellers_dataset        LIMIT 5;
SELECT * FROM product_category_name_translation LIMIT 5;


-- ============================================================
--   STEP 3 : ANALYSIS QUERIES
-- ============================================================


-- Q1: Total Revenue
SELECT
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM olist_order_payments_dataset;


-- Q2: Monthly Revenue Trend
SELECT
    strftime('%Y-%m', order_purchase_timestamp) AS month,
    ROUND(SUM(payment_value), 2)                AS monthly_revenue
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p
    ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;


-- Q3: Top 10 States by Revenue
SELECT
    c.customer_state                AS state,
    ROUND(SUM(p.payment_value), 2)  AS revenue,
    COUNT(DISTINCT o.order_id)      AS total_orders
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
JOIN olist_order_payments_dataset p
    ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC
LIMIT 10;


-- Q4: Top 10 Product Categories by Revenue
SELECT
    t.product_category_name_english AS category,
    ROUND(SUM(i.price), 2)          AS revenue,
    COUNT(DISTINCT i.order_id)      AS total_orders
FROM olist_order_items_dataset i
JOIN olist_products_dataset pr
    ON i.product_id = pr.product_id
JOIN product_category_name_translation t
    ON pr.product_category_name = t.product_category_name
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;


-- Q5: Order Status Breakdown
SELECT
    order_status,
    COUNT(*)  AS total_orders,
    ROUND(COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM olist_orders_dataset), 2) AS percentage
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;


-- Q6: Average Order Value by Payment Type
SELECT
    payment_type,
    COUNT(*)                      AS total_orders,
    ROUND(AVG(payment_value), 2)  AS avg_order_value,
    ROUND(SUM(payment_value), 2)  AS total_revenue
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY total_revenue DESC;


-- Q7: Top 10 Sellers by Revenue
SELECT
    i.seller_id,
    s.seller_city,
    s.seller_state,
    ROUND(SUM(i.price), 2)      AS revenue,
    COUNT(DISTINCT i.order_id)  AS total_orders
FROM olist_order_items_dataset i
JOIN olist_sellers_dataset s
    ON i.seller_id = s.seller_id
GROUP BY i.seller_id
ORDER BY revenue DESC
LIMIT 10;


-- Q8: Average Review Score by Category
SELECT
    t.product_category_name_english AS category,
    ROUND(AVG(r.review_score), 2)   AS avg_review_score,
    COUNT(*)                        AS total_reviews
FROM olist_order_reviews_dataset r
JOIN olist_orders_dataset o
    ON r.order_id = o.order_id
JOIN olist_order_items_dataset i
    ON o.order_id = i.order_id
JOIN olist_products_dataset p
    ON i.product_id = p.product_id
JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY category
HAVING total_reviews > 100
ORDER BY avg_review_score DESC
LIMIT 10;


-- Q9: Average Delivery Days by State
SELECT
    c.customer_state,
    ROUND(AVG(
        julianday(o.order_delivered_customer_date) -
        julianday(o.order_purchase_timestamp)
    ), 1)        AS avg_delivery_days,
    COUNT(*)     AS total_orders
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days ASC
LIMIT 10;


-- Q10: Customer Repeat Purchase Rate
SELECT
    total_orders,
    COUNT(*)  AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM (
    SELECT
        customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o
        ON c.customer_id = o.customer_id
    GROUP BY customer_unique_id
) customer_orders
GROUP BY total_orders
ORDER BY total_orders;

-- ============================================================
--   END OF ANALYSIS
-- ============================================================
