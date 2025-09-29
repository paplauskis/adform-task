-- order_report query takes ~1.8s, MV can be used if strictly accurate data is not required
CREATE MATERIALIZED VIEW order_report_mv AS
WITH order_totals AS (
    SELECT 
        o.id AS order_id,
        c.details->>'city' AS customer_city,
        SUM(oi.quantity * p.price) AS order_total
    FROM "order" o
    JOIN customer c ON c.id = o.customer_id
    JOIN order_item oi ON oi.order_id = o.id
    JOIN product p ON p.id = oi.product_id
    GROUP BY o.id, c.details->>'city'
)
SELECT
    customer_city,
    COUNT(order_id) AS number_of_orders,
    SUM(order_total) AS total_amount
FROM order_totals
GROUP BY customer_city
ORDER BY number_of_orders DESC;