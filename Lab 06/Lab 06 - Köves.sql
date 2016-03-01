---------------------------------------------------------------------
--   Title: Lab 6 SQL Script                                        |
-- Purpose: Makes 6 queries based on the description for Lab 6, and |
--          answers a question about outer joins.
--  Author: Krisztián Köves                                         |
--    Date: 3/1/2016                                                |
---------------------------------------------------------------------

-- Query 1: "Display the name and city of customers who live in any city that makes the
-- most different kinds of products. (There are two cities that make the most different
-- products. Return the name and city of customers from either one of those.)"

SELECT name, city
FROM customers
WHERE city IN (SELECT city
               FROM products
               GROUP BY city
               ORDER BY COUNT(city) DESC
               LIMIT 1
              );

-- Query 2: "Display the names of products whose priceUSD is strictly above the average priceUSD,
-- in reverse-alphabetical order."

SELECT name
FROM products
WHERE priceUSD > (SELECT AVG(priceUSD) AS avgPriceUSD
                  FROM products
                 );

-- Query 3: "Display the customer name, pid ordered, and the total for all orders, sorted by total
-- from high to low."

SELECT customers.name, orders.pid, orders.totalUSD
FROM orders, customers
WHERE orders.cid = customers.cid
ORDER BY totalUSD DESC;

-- Query 4: "Display all customer names (in alphabetical order) and their total ordered, and
-- nothing more. Use coalesce to avoid showing NULLs."

SELECT customers.name, COALESCE(totalUSD, 0.00)
FROM orders
RIGHT OUTER JOIN customers
              ON orders.cid = customers.cid
ORDER BY customers.name ASC;

-- Query 5: "Display the names of all customers who bought products from agents based in Tokyo
-- along with the names of the products they ordered, and the names of the agents who sold
-- it to them."

SELECT customers.name AS customerName, products.name as productName, agents.name AS agentName
FROM orders
INNER JOIN customers
        ON orders.cid = customers.cid
INNER JOIN agents
        ON orders.aid = agents.aid
INNER JOIN products
        ON orders.pid = products.pid
WHERE agents.city = 'Tokyo';

-- Query 6: "Write a query to check the accuracy of the dollars column in the Orders table. This
-- means calculating Orders.totalUSD from data in other tables and comparing those values to the
-- values in Orders.totalUSD. Display all rows in Orders where Orders.totalUSD is incorrect, if any."

SELECT ordnum,
       orders.pid,
       orders.qty,
       products.priceUSD,
       customers.cid,
       customers.discount,
       TRUNC( (orders.qty * products.priceUSD * ((100 - customers.discount)/100) ), 2) AS calculatedTotal,
       orders.totalUSD
FROM orders
INNER JOIN customers
        ON orders.cid = customers.cid
INNER JOIN products
        ON orders.pid = products.pid
WHERE (orders.qty * products.priceUSD * ((100 - customers.discount)/100)) != orders.totalUSD;

-- Question 7: "What’s the difference between a LEFT OUTER JOIN and a RIGHT OUTER JOIN? Give
-- example queries in SQL to demonstrate. (Feel free to use the CAP2 database to make your
-- points here.)"

-- My Answer: 
-- "A left outer join will take results from the left table (in the example below,
-- orders) and display rows matching from the right table. The query below will
-- give us a "clean" join between the orders and customers tables, with no nulls.

     SELECT *
     FROM orders
     LEFT OUTER JOIN customers
                  ON orders.cid = customers.cid
                  
-- "A right outer join, on the other hand, will take results from the right table
-- and display rows that match from the left table. Using the same example as above,
-- but with a right outer join, results in nulls where we have a customer, Weyland,
-- who has never placed an order."

     SELECT *
     FROM orders
     RIGHT OUTER JOIN customers
                   ON orders.cid = customers.cid
