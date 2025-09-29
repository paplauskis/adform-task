-- function that generates random ints from 1 to 100
CREATE OR REPLACE FUNCTION random_products_count(order_id INTEGER DEFAULT 1) 
RETURNS INTEGER AS $$ 
BEGIN
    PERFORM setseed((order_id * random())::float8 / 2147483647);
    RETURN (1 + FLOOR(random() * 100))::int; 
END; 
$$ LANGUAGE plpgsql VOLATILE;