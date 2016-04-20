---------------------------------------------------------------------
--   Title: Lab 10 SQL Script                                       |
-- Purpose: Defines two stored procedures in PL/pgSQL syntax.       |
--  Author: Krisztián Köves                                         |
--    Date: 4/19/2016                                               |
---------------------------------------------------------------------

-- Function 1: "preReqsFor(courseNum) - Returns the immediate prerequisites for the
-- passed-in course number."

CREATE OR REPLACE FUNCTION preReqsFor(int, refcursor) RETURNS refcursor AS 
$$
DECLARE
    course_num int      := $1;
    resultset REFCURSOR := $2;
BEGIN
    OPEN resultset FOR
        SELECT prereqnum
        FROM courses c, prerequisites p
        WHERE c.num = p.courseNum
        AND c.num = course_num;
    RETURN resultset;
END;
$$
LANGUAGE plpgsql;

-- Test statements for function 1
SELECT preReqsFor(499, 'results');
FETCH ALL FROM results;


-- Function 2: "isPreReqFor(courseNum) - Returns the courses for which the passed-in course
-- number is an immediate pre-requisite."

CREATE OR REPLACE FUNCTION isPreReqFor(int, refcursor) RETURNS refcursor AS
$$
DECLARE
    prereq_num int      := $1;
    resultset REFCURSOR := $2;
BEGIN
    OPEN resultset FOR
        SELECT c.num
        FROM courses c, prerequisites p
        WHERE c.num = p.courseNum
        AND p.prereqnum = prereq_num;
    RETURN resultset;
END;
$$
LANGUAGE plpgsql;

-- Test statements for function 2
SELECT isPreReqFor(120, 'results');
FETCH ALL FROM results;