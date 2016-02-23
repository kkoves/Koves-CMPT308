---------------------------------------------------------------------
--   Title: Lab 5 SQL Script                                        |
-- Purpose: Makes 7 queries based on the description for Lab 5.     |
--  Author: Krisztián Köves                                         |
--    Date: 2/22/2016                                               |
---------------------------------------------------------------------

-- Query 1: "Show the cities of agents booking an order for a customer 
--           whose id is 'c002'. Use joins; no subqueries."

SELECT city
FROM orders
INNER JOIN agents ON orders.aid = agents.aid
WHERE orders.cid = 'c002';

-- Query 2: "Show the ids of products ordered through any agent who makes at least one order for
--           a customer in Dallas, sorted by pid from highest to lowest. Use joins; no subqueries."

SELECT DISTINCT pid
FROM orders
INNER JOIN customers
        ON orders.cid = customers.cid
INNER JOIN agents
        ON orders.aid = agents.aid
WHERE customers.city = 'Dallas'
ORDER BY pid DESC;

-- Query 3: "Show the names of customers who have never placed an order. Use a subquery."

SELECT name
FROM customers
WHERE cid NOT IN (SELECT cid
                  FROM orders
                 );

-- Query 4: "Show the names of customers who have never placed an order. Use an outer join."

SELECT name
FROM orders
RIGHT OUTER JOIN customers
              ON orders.cid = customers.cid
WHERE ordnum IS NULL;

-- Query 5: "Show the names of customers who placed at least one order through 
--           an agent in their own city, along with those agent(s') names."

SELECT DISTINCT customers.name
FROM orders
INNER JOIN customers
        ON orders.cid = customers.cid
INNER JOIN agents
        ON orders.aid = agents.aid
WHERE customers.city = agents.city;

-- Query 6: "Show the names of customers and agents living in the same city, along with the name
--           of the shared city, regardless of whether or not the customer has ever placed an order
--           with that agent."

SELECT customers.name, agents.name
FROM agents
RIGHT OUTER JOIN customers
              ON agents.city = customers.city
WHERE customers.city = agents.city;

-- Query 7: "Show the name and city of customers who live in the city that makes the fewest
--           different kinds of products. (Hint: Use count and group by on the Products table.)"

SELECT name, city
FROM customers
WHERE city IN (SELECT city
               FROM products
               GROUP BY city
               ORDER BY COUNT(city) ASC
               LIMIT 1
              );