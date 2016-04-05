---------------------------------------------------------------------
--   Title: Lab 8 SQL Script                                        |
-- Purpose: SQL script for database example in Lab 8,               |
--          as well as one example query.                           |
--  Author: Krisztián Köves                                         |
--    Date: 4/4/2016                                                |
---------------------------------------------------------------------

DROP TABLE IF EXISTS MovieDirectors;
DROP TABLE IF EXISTS MovieActors;
DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS Actors;
DROP TABLE IF EXISTS Directors;
DROP TABLE IF EXISTS People;

CREATE TABLE People (
    pid        SERIAL NOT NULL,
    name       TEXT   NOT NULL,
    address    TEXT   NOT NULL,
    birthDate  DATE   NOT NULL,
    spouseName TEXT,
    PRIMARY KEY(pid)
);

CREATE TABLE Actors (
    pid                    INTEGER UNIQUE NOT NULL REFERENCES People(pid),
    hairColor              TEXT    NOT NULL,
    eyeColor               TEXT    NOT NULL,
    heightInches           INTEGER NOT NULL,
    weightLbs              INTEGER NOT NULL,
    favoriteColor          TEXT,
    actorsGuildAnniversary DATE,
    PRIMARY KEY(pid)
);

CREATE TABLE Directors (
    pid                       INTEGER UNIQUE NOT NULL REFERENCES People(pid),
    filmSchool                TEXT,
    favoriteLensMaker         TEXT,
    directorsGuildAnniversary DATE,
    PRIMARY KEY(pid)
);

CREATE TABLE Movies (
    mid              SERIAL  UNIQUE NOT NULL,
    mpaaNumber       INTEGER UNIQUE,
    filmTitle        TEXT    NOT NULL,
    releaseDate      DATE    NOT NULL,
    domesticSalesUSD DECIMAL NOT NULL,
    foreignSalesUSD  DECIMAL NOT NULL,
    discSalesUSD     DECIMAL NOT NULL,
    PRIMARY KEY(mid)
);

CREATE TABLE MovieActors (
    pid INTEGER NOT NULL REFERENCES Actors(pid),
    mid INTEGER NOT NULL REFERENCES Movies(mid),
    PRIMARY KEY(pid, mid)
);

CREATE TABLE MovieDirectors (
    pid INTEGER NOT NULL REFERENCES Directors(pid),
    mid INTEGER NOT NULL REFERENCES Movies(mid),
    PRIMARY KEY(pid, mid)
);

-- Inserting test data into the new tables

-- Insert Sean Connery
INSERT INTO People(name, address, birthDate, spouseName)
            VALUES('Sean Connery', '123 N. Bond Road, San Francisco, CA', '08/25/1930', 'Micheline Roquebrune');
            
INSERT INTO Actors(pid, hairColor, eyeColor, heightInches, weightLbs)
            VALUES(1, 'Brown', 'Brown', 74, 165);

-- Insert directors test data
INSERT INTO People(name, address, birthDate, spouseName)
            VALUES('Terence Young', '232 W. California Road, Hollywood, CA', '06-20-1915', NULL),
                  ('Guy Hamilton', '113 W. California Road, Hollywood, CA', '09-16-1922', NULL);

INSERT INTO Directors(pid, favoriteLensMaker)
               VALUES(2, 'Kodak'),
                     (3, 'Nikon');

-- Insert movies test data
INSERT INTO Movies(filmTitle, releaseDate, domesticSalesUSD, foreignSalesUSD, discSalesUSD)
            VALUES('Dr. No', '05-08-1963', '10000000', '11000000', '15000000'),
                  ('Goldfinger', '01-09-1965', '22000000', '15000000', '30000000'),
                  ('Thunderball', '12-22-1965', '11000000', '11000000','13000000');

-- Insert movie actors test data
INSERT INTO MovieActors(pid, mid)
                 VALUES(1, 1),
                       (1, 2),
                       (1, 3);

-- Insert movie directors test data
INSERT INTO MovieDirectors(pid, mid)
                    VALUES(2, 1),
                          (3, 2),
                          (2, 3);

-- Checking test data
SELECT * FROM People;
SELECT * FROM Actors;
SELECT * FROM Directors;
SELECT * FROM Movies;
SELECT * FROM MovieActors;

SELECT * 
FROM People, Directors
WHERE People.pid = Directors.pid;

SELECT *
FROM People, Actors
WHERE People.pid = Actors.pid;


-- #4: Write a query to show all the directors with whom actor “Sean Connery” has worked.
SELECT People.pid,
       People.name,
       People.address,
       People.birthDate,
       People.spouseName,
       Directors.filmSchool,
       Directors.favoriteLensMaker,
       Directors.directorsGuildAnniversary
FROM People, Directors
WHERE Directors.pid IN(SELECT DISTINCT Directors.pid --People.name
                       FROM Directors, MovieDirectors
                       WHERE mid IN(SELECT Movies.mid
                                    FROM Movies, MovieActors
                                    WHERE pid IN(SELECT pid
                                                 FROM People
                                                 WHERE name = 'Sean Connery'
                                                )
                                      AND Movies.mid = MovieActors.mid
                                   )
                       AND Directors.pid = MovieDirectors.pid
                      )
AND People.pid = Directors.pid;