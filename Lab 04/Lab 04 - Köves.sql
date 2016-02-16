---------------------------------------------------------------------
--   Title: Lab 4 SQL Script                                        |
-- Purpose: Makes 7 queries according to the description for Lab 4, |
--          and answers a question about check constraints.         |
--  Author: Krisztián Köves                                         |
--    Date: 2/16/2016                                               |
---------------------------------------------------------------------

-- Query 1: "Get the cities of agents booking an order for a customer whose cid is 'c002.'"
SELECT city
FROM agents
WHERE aid IN (SELECT aid
              FROM orders
              WHERE cid = 'c002'
             );

-- Query 2: "Get the ids of products ordered through any agent who takes at least one
--           order from a customer in Dallas, sorted by pid from highest to lowest."
SELECT DISTINCT pid
FROM orders
WHERE aid IN (SELECT aid
              FROM orders, customers
              WHERE customers.city = 'Dallas'
             )
ORDER BY pid DESC;

-- Query 3: "Get the ids and names of customers who did not place an order through agent a01."
SELECT cid, name
FROM customers
WHERE cid IN (SELECT cid
              FROM orders
                  EXCEPT
              SELECT cid
              FROM orders
              WHERE aid = 'a01'
             );

-- Query 4: "Get the ids of customers who ordered both product p01 and p07."
SELECT cid
FROM orders
WHERE pid = 'p01'
    UNION
SELECT cid
FROM orders
WHERE pid = 'p07';

-- Query 5: "Get the ids of products not ordered by any customers who placed
--           any order through agent a07 in pid order from highest to lowest."
SELECT DISTINCT pid
FROM orders
WHERE cid NOT IN (SELECT cid
                  FROM orders
                  WHERE aid = 'a01'
                 )
    UNION
SELECT products.pid
FROM orders, products
WHERE products.pid NOT IN (SELECT pid
                           FROM orders
                          )
ORDER BY pid DESC;

-- Query 6: "Get the name, discounts, and city for all customers
--           who place orders through agents in London or New York."
SELECT DISTINCT name, discount, city
FROM customers
WHERE cid IN (SELECT cid
              FROM orders
              WHERE aid IN (SELECT aid
                            FROM agents
                            WHERE city = 'London'
                               OR city = 'New York'
                           )
             );

-- Query 7: "Get all customers who have the same discount as that
--           of any customers in Dallas or London."
SELECT *
FROM customers
WHERE discount IN (SELECT discount
                   FROM customers
                   WHERE city = 'Dallas'
                      OR city = 'London'
                  );

-- Question 8: "Tell me about check constraints: What are they? What are they good for? What’s the
--              advantage of putting that sort of thing inside the database? Make up some examples
--              of good uses of check constraints and some examples of bad uses of check constraints.
--              Explain the differences in your examples and argue your case."

-- My Answer: "Check constraints are used to specify restrictions on database values besides the
--             usual 'NOT NULL,' 'PRIMARY KEY,' and data type constraints. For example, we could
--             write a check constraint to make sure the value for a certain column does not fall
--             outside a certain set of values, such as the following column definition example:
--             
--                 class_time TEXT CHECK(class_time = 'Morning'
--                                    OR class_time = 'Afternoon'
--                                    OR class_time = 'Evening')
--             
--            "The previous example is a good example of a check constraint, since it is specific
--             and will keep the values in that column of the database consistent. A bad example
--             of a check constraint would be one that would not keep the column values (and thus,
--             the database as a whole) consistent, such as the following:
--             
--                 class_time TEXT CHECK(class_time = 'Morning'
--                                    OR class_time = 'Day'
--                                    OR class_time = 'Afternoon'
--                                    OR class_time = 'Evening' OR class_time = 'Night')
--           
--            "The above is a bad example of a check constraint, since it has values that could mean
--             almost the same thing - morning and afternoon are both in the daytime, and evening and
--             night are similar words - making  the values in that column inconsistent, thereby
--             confusing users of this hypothetical class registration system."