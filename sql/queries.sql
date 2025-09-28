-- parameterized query that gets all products in an order
PREPARE get_order_items(int) AS
SELECT 
	p.name AS product_name,
	c.category_name AS category,
    oi.quantity AS product_quantity,
    p.price AS single_product_price,
    (oi.quantity * p.price) AS product_total
FROM order_item oi
JOIN product p ON p.id = oi.product_id
JOIN category c ON c.id = p.category_id
WHERE oi.order_id = $1;

-- parameterized query that gets total price of order
PREPARE get_order_total_amount(int) AS
SELECT 
    SUM(oi.quantity * p.price) AS total_order_amount
FROM order_item oi
JOIN product p ON p.id = oi.product_id
WHERE oi.order_id = $1;

-- queries can be executed like this
EXECUTE get_order_items(10);
EXECUTE get_order_total_amount(10);