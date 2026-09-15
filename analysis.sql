-- ==========================================
-- ZOMATO PRODUCT ANALYTICS
-- SQL BUSINESS ANALYSIS
-- ==========================================


-- 1. CORE PRODUCT KPIs

SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS delivered_customers,
    ROUND(SUM(order_value), 2) AS total_gmv,
    ROUND(AVG(order_value), 2) AS aov
FROM orders
WHERE LOWER(order_status) = 'delivered';


-- 2. MONTHLY PERFORMANCE

SELECT
    month,
    COUNT(DISTINCT order_id) AS delivered_orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(order_value), 2) AS gmv,
    ROUND(AVG(order_value), 2) AS aov
FROM orders
WHERE LOWER(order_status) = 'delivered'
GROUP BY month
ORDER BY month;


-- 3. CITY PERFORMANCE

SELECT
    city,
    COUNT(DISTINCT order_id) AS delivered_orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(order_value), 2) AS gmv,
    ROUND(AVG(order_value), 2) AS aov,
    ROUND(AVG(delivery_time_min), 2) AS avg_delivery_time,
    ROUND(AVG(rating), 2) AS avg_rating
FROM orders
WHERE LOWER(order_status) = 'delivered'
GROUP BY city
ORDER BY gmv DESC;


-- 4. TOP CUSTOMERS BY ORDER FREQUENCY

SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(order_value), 2) AS total_spend,
    ROUND(AVG(order_value), 2) AS avg_order_value
FROM orders
WHERE LOWER(order_status) = 'delivered'
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 20;


-- 5. TOP RESTAURANTS BY GMV

SELECT
    restaurant_id,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(order_value), 2) AS gmv,
    ROUND(AVG(order_value), 2) AS aov,
    ROUND(AVG(rating), 2) AS avg_rating
FROM orders
WHERE LOWER(order_status) = 'delivered'
GROUP BY restaurant_id
ORDER BY gmv DESC
LIMIT 10;


-- 6. HIGH-VOLUME LOW-RATED RESTAURANTS

SELECT
    restaurant_id,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(order_value), 2) AS gmv,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(delivery_time_min), 2) AS avg_delivery_time
FROM orders
WHERE LOWER(order_status) = 'delivered'
GROUP BY restaurant_id
HAVING COUNT(DISTINCT order_id) >= 40
   AND AVG(rating) < 3.8
ORDER BY orders DESC;


-- 7. CITY NON-DELIVERY RATE

SELECT
    city,
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN LOWER(order_status) != 'delivered'
            THEN 1
            ELSE 0
        END
    ) AS failed_orders,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN LOWER(order_status) != 'delivered'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS non_delivery_rate
FROM orders
GROUP BY city
ORDER BY non_delivery_rate DESC;


-- 8. PROMO VS NON-PROMO PERFORMANCE

SELECT
    promo_used,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(AVG(order_value), 2) AS aov,
    ROUND(AVG(delivery_time_min), 2) AS avg_delivery_time,
    ROUND(AVG(rating), 2) AS avg_rating
FROM orders
WHERE LOWER(order_status) = 'delivered'
GROUP BY promo_used;


-- 9. HISTORICAL CUSTOMER VALUE

SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(order_value), 2) AS total_gmv,
    ROUND(AVG(order_value), 2) AS aov
FROM orders
WHERE LOWER(order_status) = 'delivered'
GROUP BY customer_id
ORDER BY total_gmv DESC
LIMIT 20;









