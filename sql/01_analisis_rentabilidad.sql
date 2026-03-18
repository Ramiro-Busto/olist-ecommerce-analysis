USE olist_ecommerce;
GO

-- Resumen general del negocio
SELECT
    COUNT(DISTINCT order_id)            AS total_orders,
    COUNT(DISTINCT customer_unique_id)  AS total_customers,
    COUNT(DISTINCT seller_id)           AS total_sellers,
    COUNT(DISTINCT product_category_name_english) AS total_categories,
    ROUND(SUM(total_revenue), 2)        AS total_revenue,
    ROUND(AVG(total_revenue), 2)        AS avg_order_revenue,
    ROUND(AVG(review_score), 2)         AS avg_review_score,
    ROUND(AVG(delivery_time_days), 1)   AS avg_delivery_days
FROM olist_main;


-- Rentabilidad por categoría
SELECT
    product_category_name_english                       AS category,
    COUNT(DISTINCT order_id)                            AS total_orders,
    ROUND(SUM(price), 2)                                AS total_price,
    ROUND(SUM(freight_value), 2)                        AS total_freight,
    ROUND(SUM(total_revenue), 2)                        AS total_revenue,
    ROUND(AVG(price), 2)                                AS avg_price,
    ROUND(AVG(freight_value), 2)                        AS avg_freight,
    ROUND(AVG(freight_value) / AVG(price) * 100, 2)    AS freight_to_price_pct,
    ROUND(AVG(review_score), 2)                         AS avg_review_score,
    ROUND(AVG(delivery_time_days), 1)                   AS avg_delivery_days
FROM olist_main
GROUP BY product_category_name_english
ORDER BY total_revenue DESC;


-- Impacto de demoras en review score
SELECT
    CASE
        WHEN delay_days <= -10 THEN 'Very Early (10+ days early)'
        WHEN delay_days <= 0   THEN 'On Time / Early'
        WHEN delay_days <= 7   THEN 'Slightly Late (1-7 days)'
        WHEN delay_days <= 14  THEN 'Late (8-14 days)'
        ELSE                        'Very Late (15+ days)'
    END AS delivery_status,
    COUNT(*)                    AS total_orders,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    ROUND(AVG(delivery_time_days), 1) AS avg_delivery_days
FROM olist_main
WHERE review_score IS NOT NULL
GROUP BY
    CASE
        WHEN delay_days <= -10 THEN 'Very Early (10+ days early)'
        WHEN delay_days <= 0   THEN 'On Time / Early'
        WHEN delay_days <= 7   THEN 'Slightly Late (1-7 days)'
        WHEN delay_days <= 14  THEN 'Late (8-14 days)'
        ELSE                        'Very Late (15+ days)'
    END
ORDER BY avg_review_score DESC;


-- Performance por estado
SELECT
    customer_state                          AS state,
    COUNT(DISTINCT order_id)                AS total_orders,
    ROUND(SUM(total_revenue), 2)            AS total_revenue,
    ROUND(AVG(total_revenue), 2)            AS avg_order_value,
    ROUND(AVG(review_score), 2)             AS avg_review_score,
    ROUND(AVG(delivery_time_days), 1)       AS avg_delivery_days,
    SUM(CASE WHEN is_late = 1 THEN 1 
        ELSE 0 END)                         AS late_orders,
    ROUND(SUM(CASE WHEN is_late = 1 THEN 1 
        ELSE 0 END) * 100.0 / COUNT(*), 2)  AS late_pct
FROM olist_main
GROUP BY customer_state
ORDER BY total_revenue DESC;


-- Performance de sellers
SELECT
    seller_id,
    seller_state,
    COUNT(DISTINCT order_id)                AS total_orders,
    ROUND(SUM(total_revenue), 2)            AS total_revenue,
    ROUND(AVG(review_score), 2)             AS avg_review_score,
    ROUND(AVG(delivery_time_days), 1)       AS avg_delivery_days,
    ROUND(SUM(CASE WHEN is_late = 1 THEN 1
        ELSE 0 END) * 100.0 / COUNT(*), 2)  AS late_pct
FROM olist_main
GROUP BY seller_id, seller_state
HAVING COUNT(DISTINCT order_id) >= 50
ORDER BY avg_review_score ASC;


-- Revenue mensual (tendencia temporal)
SELECT
    FORMAT(order_purchase_timestamp, 'yyyy-MM') AS year_month,
    COUNT(DISTINCT order_id)                     AS total_orders,
    ROUND(SUM(total_revenue), 2)                 AS total_revenue,
    ROUND(AVG(review_score), 2)                  AS avg_review_score
FROM olist_main
GROUP BY FORMAT(order_purchase_timestamp, 'yyyy-MM')
ORDER BY year_month;


-- Análisis de métodos de pago
SELECT
    payment_type,
    COUNT(DISTINCT order_id)                AS total_orders,
    ROUND(SUM(total_payment), 2)            AS total_revenue,
    ROUND(AVG(total_payment), 2)            AS avg_order_value,
    ROUND(AVG(payment_installments), 1)     AS avg_installments,
    ROUND(AVG(review_score), 2)             AS avg_review_score,
    ROUND(AVG(delivery_time_days), 1)       AS avg_delivery_days
FROM olist_main
GROUP BY payment_type
ORDER BY total_revenue DESC;


-- Top 10 sellers por revenue
SELECT TOP 10
    seller_id,
    seller_state,
    COUNT(DISTINCT order_id)        AS total_orders,
    ROUND(SUM(total_revenue), 2)    AS total_revenue,
    ROUND(AVG(review_score), 2)     AS avg_review_score,
    ROUND(AVG(delivery_time_days),1)AS avg_delivery_days,
    ROUND(SUM(CASE WHEN is_late = 1 
        THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 2)              AS late_pct
FROM olist_main
GROUP BY seller_id, seller_state
ORDER BY total_revenue DESC;