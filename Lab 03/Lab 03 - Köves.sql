---------------------------------------------------------------------
--   Title: Lab 3 SQL Script                                        |
-- Purpose: Makes 9 queries according to the description for Lab 3. |
--  Author: Krisztián Köves                                         |
--    Date: 2/9/2016                                                |
---------------------------------------------------------------------

-- Query 1: "List the ordno and	dollars	of all orders."
SELECT ordnum, totalUSD
FROM orders;

-- Query 2: "List the name and city of agents named Smith."
SELECT name, city
FROM agents
WHERE name = 'Smith';

-- Query 3: "List the pid, name, and priceUSD of products with quantity more than 208,00."
SELECT pid, name, priceUSD
FROM products
WHERE quantity > 208000;

-- Query 4: "List the names and cities of customers in Dallas."
SELECT name, city
FROM customers
WHERE city = 'Dallas';

-- Query 5: "List the names of agents not in New York and not in Tokyo."
SELECT name
FROM agents
WHERE city != 'New York' AND city != 'Tokyo';

-- Query 6: "List all data for products not in Dallas or Duluth that cost US$1 or more."
SELECT *
FROM products
WHERE city != 'Dallas'
  AND city != 'Duluth'
  AND priceUSD >= 1;

-- Query 7: "List all data for orders in January or March."
SELECT *
FROM orders
WHERE mon IN ('jan', 'mar');

-- Query 8: "List all data for orders in February less than US$500."
SELECT *
FROM orders
WHERE mon = 'feb'
  AND totalUSD < 500;
  
-- Query 9: "List all orders from the customer whose cid is C005."
SELECT *
FROM orders
WHERE cid = 'c005';