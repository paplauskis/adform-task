-- order_report query takes 3.5s, MV can be used if strictly accurate data is not required
CREATE MATERIALIZED VIEW order_report_mv AS
SELECT 
    c.details->>'city' AS customer_city,
    COUNT(DISTINCT o.id) AS number_of_orders,
    SUM(p.price * oi.quantity) AS total_amount
FROM customer c
JOIN "order" o ON o.customer_id = c.id 
JOIN order_item oi ON oi.order_id = o.id
JOIN product p ON p.id = oi.product_id
GROUP BY c.details->>'city'
ORDER BY number_of_orders DESC;