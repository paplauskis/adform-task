INSERT INTO customer (
	first_name,
	last_name,
	email,
	details
)
SELECT
	'Name' || i,
	'Last' || i,
	'customer' || i || '@example.com',
	jsonb_build_object
	('country', 'Lithuania', 
	'city', (ARRAY['Vilnius', 'Kaunas', 'Klaipeda', 'Siauliai', 'Panevezys', 'Plunge'])[ceil(random()*6)])
FROM generate_series(1, 10000) AS s(i);

INSERT INTO category (category_name) VALUES
('Electronics'),
('Clothing'),
('Furniture'),
('Toys'),
('Books');

WITH c_count AS (
	SELECT COUNT(*) AS category_count FROM category
)
INSERT INTO product ("name", price, category_id)
SELECT
	'Product-' || i,
	ROUND((random() * 500)::numeric, 2),
	(1 + FLOOR(random() * category_count))::int
FROM generate_series(1, 8000) AS s(i), c_count;

WITH c_count AS (
	SELECT COUNT(*) AS customer_count FROM customer
)
INSERT INTO "order" (customer_id)
SELECT
    (1 + FLOOR(random() * customer_count))::int
FROM generate_series(1, 100000) AS s(i), c_count;
