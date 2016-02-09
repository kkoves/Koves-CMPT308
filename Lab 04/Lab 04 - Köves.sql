---------------------------------------------------------------------
--   Title: Lab 4 SQL Script                                        |
-- Purpose: Makes 8 queries according to the description for Lab 4. |
--  Author: Krisztián Köves                                         |
--    Date: 2/9/2016                                                |
---------------------------------------------------------------------

-- Query 1: "Get the cities of agents booking an order for a customer whose cid is 'c002'."
SELECT city
FROM agents
WHERE aid IN (SELECT aid
              FROM orders
              WHERE cid = 'c002'
             );

