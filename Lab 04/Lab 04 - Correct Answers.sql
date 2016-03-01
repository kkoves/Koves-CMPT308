----------------------------------------------------------------
-- Title:   Lab 4 Correct Answers                              |
-- Purpose: Noting correct answers for queries I did wrong in  |
--          Lab 4, or better answers for the ones I did right. |
-- Author:  Krisztián Köves                                    |
-- Date:    2/23/2016                                          |
----------------------------------------------------------------

-- Query 3: "Get the ids and names of customers who did not place an order through agent a01."

SELECT cid, name
FROM customers
WHERE cid NOT IN (SELECT cid
                  FROM orders
                  WHERE aid = 'a01'
                 );

-- Query 4: "Get the ids of customers who ordered both product p01 and p07."

SELECT cid
FROM orders
WHERE pid = 'p01'
  INTERSECT
SELECT cid
FROM orders
WHERE pid = 'p07';


-- Query 5: "Get the ids of products not ordered by any customers who placed
--           any order through agent a07 in pid order from highest to lowest."

SELECT pid
FROM products
WHERE pid NOT IN (SELECT pid
                  FROM orders
                  WHERE aid = 'a07'
                 )
ORDER BY pid DESC;
