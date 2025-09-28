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
