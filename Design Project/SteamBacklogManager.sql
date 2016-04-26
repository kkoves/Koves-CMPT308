DROP VIEW  IF EXISTS UnfinishedGames;
DROP TABLE IF EXISTS UserGameCompletion;
DROP TABLE IF EXISTS UserAchievements;
DROP TABLE IF EXISTS Achievements;
DROP VIEW  IF EXISTS MostPlayedGames;
DROP TABLE IF EXISTS OwnedGames;
DROP TABLE IF EXISTS Games;
DROP TABLE IF EXISTS Players;

CREATE TABLE IF NOT EXISTS Players (
  steamID     BIGINT    NOT NULL UNIQUE,
  countryCode CHAR(2)   NOT NULL,
  timeCreated TIMESTAMP NOT NULL,
  personaName TEXT      NOT NULL,
  profileURL  TEXT      NOT NULL,
  avatarURL   TEXT      NOT NULL,
  
  PRIMARY KEY (steamID)
);

CREATE TABLE IF NOT EXISTS Games (
  appID       INT  NOT NULL UNIQUE,
  name        TEXT NOT NULL,
  imgIconHash TEXT,
  imgLogoHash TEXT,
  
  PRIMARY KEY (appID)
);

CREATE TABLE IF NOT EXISTS OwnedGames (
  steamID              BIGINT    NOT NULL,
  appID                INT       NOT NULL,
  minutesPlayed        INT       NOT NULL,
  minutesPlayed_2Weeks INT       NOT NULL,
  lastUpdate           TIMESTAMP NOT NULL,
  
  PRIMARY KEY(steamID, appID),
  FOREIGN KEY(steamID)
      REFERENCES Players(steamID),
  FOREIGN KEY(appID)
      REFERENCES Games(appID)
);

CREATE TABLE IF NOT EXISTS UserGameCompletion (
  steamID       BIGINT NOT NULL,
  appID         INT NOT NULL,
  userGameRank  INT NOT NULL,
  gameCompleted BOOLEAN NOT NULL,
  
  PRIMARY KEY(steamID, appID),
  FOREIGN KEY(steamID)
      REFERENCES Players(steamID),
  FOREIGN KEY(appID)
      REFERENCES Games(appID)
);

CREATE TABLE IF NOT EXISTS Achievements (
  appID        INT  NOT NULL,
  apiName      TEXT NOT NULL UNIQUE,
  displayName  TEXT NOT NULL,
  description  TEXT,
  iconHash     TEXT NOT NULL,
  iconGrayHash TEXT NOT NULL,
  
  PRIMARY KEY(appID, apiName),
  FOREIGN KEY(appID)
      REFERENCES Games(appID)
);

CREATE TABLE IF NOT EXISTS UserAchievements (
  steamID  BIGINT  NOT NULL,
  appID    INT     NOT NULL,
  apiName  TEXT    NOT NULL,
  achieved BOOLEAN NOT NULL,
  
  PRIMARY KEY(steamID, appID, apiName),
  FOREIGN KEY(steamID)
      REFERENCES Players(steamID),
  FOREIGN KEY(appID)
      REFERENCES Games(appID),
  FOREIGN KEY(apiName)
      REFERENCES Achievements(apiName)
);

-- Insert some example Steam games into the database
INSERT INTO Games(appID, name, imgIconHash, imgLogoHash)
           VALUES(220, 'Half-Life 2', 'fcfb366051782b8ebf2aa297f3b746395858cb62', 'fcfb366051782b8ebf2aa297f3b746395858cb62'),
                 (400, 'Portal', 'cfa928ab4119dd137e50d728e8fe703e4e970aff', '4184d4c0d915bd3a45210667f7b25361352acd8f'),
                 (620, 'Portal 2', '2e478fc6874d06ae5baf0d147f6f21203291aa02', 'd2a1119ddc202fab81d9b87048f495cbd6377502'),
                 (72850, 'The Elder Scrolls V: Skyrim', 'b9aca8a189abd8d6aaf09047dbb0f57582683e1c', 'c5af3cde13610fca25cd17634a96d72487d21e74'),
                 (22370, 'Fallout 3 - Game of the Year Edition', '21d7090bdea8f6685ca730850b7b55acfdb92732', 'ddccc41c513694e7a5542aa115e9e091d6495420');

-- Insert myself, sKKy, and a Valve developer, Robin Walker, into the Players database
INSERT INTO Players(steamID, countryCode, timeCreated, personaName, profileURL, avatarURL)
             VALUES(76561198055529452, 'US', to_timestamp(1324858286), 'sKKy', 'http://steamcommunity.com/id/kkoves/', 'https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/7a/7ae537b6b7b7b09e68f52e76cdb8f0727f5cb270.jpg'),
                   (76561197972495328, 'US', to_timestamp(1063407589), 'Robin', 'http://steamcommunity.com/id/robinwalker/', 'https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/f1/f1dd60a188883caf82d0cbfccfe6aba0af1732d4.jpg');

-- Insert some of my owned games into the database
INSERT INTO OwnedGames(steamID, appID, minutesPlayed, minutesPlayed_2Weeks, lastUpdate)
                VALUES(76561198055529452, 220, 1618, 0, NOW()),
                      (76561198055529452, 400, 5087, 0, NOW()),
                      (76561198055529452, 620, 6435, 0, NOW()),
                      (76561198055529452, 72850, 20413, 0, NOW()),
                      (76561198055529452, 22370, 1898, 0, NOW());
                
-- Insert some of Robin Walker's owned games into the database
INSERT INTO OwnedGames(steamID, appID, minutesPlayed, minutesPlayed_2Weeks, lastUpdate)
                VALUES(76561197972495328, 220, 200, 0, NOW()),
                      (76561197972495328, 400, 428, 0, NOW()),
                      (76561197972495328, 620, 889, 0, NOW()),
                      (76561197972495328, 72850, 2448, 0, NOW());

-- Insert my game completion and rankings into the database
INSERT INTO UserGameCompletion(steamID, appID, userGameRank, gameCompleted)
                        VALUES(76561198055529452, 72850, 1, TRUE),
                              (76561198055529452, 220, 2, TRUE),
                              (76561198055529452, 620, 3, TRUE),
                              (76561198055529452, 400, 4, TRUE),
                              (76561198055529452, 22370, 5, FALSE);
                              
-- Insert Robin Walker's game completion and rankings into the database
INSERT INTO UserGameCompletion(steamID, appID, userGameRank, gameCompleted)
                        VALUES(76561197972495328, 220, 1, FALSE),
                              (76561197972495328, 400, 2, TRUE),
                              (76561197972495328, 620, 3, TRUE),
                              (76561197972495328, 72850, 4, TRUE);

-- Insert some game achievements into the database                             
INSERT INTO Achievements(appID, apiName, displayName, description, iconHash, iconGrayHash)
                  VALUES(220, 'HL2_GET_CROWBAR', 'Trusty Hardware', 'Get the crowbar.', 'http://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/220/hl2_get_crowbar.jpg', 'http://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/220/hl2_get_crowbar_bw.jpg'),
                        (400, 'PORTAL_GET_PORTALGUNS', 'Lab Rat', 'Acquire the fully powered Aperture Science Handheld Portal Device.', 'http://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/400/portal_getportalguns.jpg', 'http://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/400/portal_getportalguns_bw.jpg'),
                        (620, 'ACH.WAKE_UP', 'You Monster', 'Reunite with GLaDOS', 'http://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/620/WAKE_UP.jpg', 'http://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/620/WAKE_UP_BW.jpg'),
                        (72850, 'NEW_ACHIEVEMENT_8_0', 'Dragonslayer', 'Complete "Dragonslayer"', 'http://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/72850/7668bd7787758bde9211ed8d8c347f50da7f230d.jpg', 'http://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/72850/d788735a4da6aacb0c201ac489c82361802e3f12.jpg');

-- Insert some of my achievement completion status data into the database
INSERT INTO UserAchievements(steamID, appID, apiName, achieved)
                      VALUES(76561198055529452, 220, 'HL2_GET_CROWBAR', TRUE),
                            (76561198055529452, 400, 'PORTAL_GET_PORTALGUNS', TRUE),
                            (76561198055529452, 620, 'ACH.WAKE_UP', TRUE),
                            (76561198055529452, 72850, 'NEW_ACHIEVEMENT_8_0', FALSE);

-- Insert some of Robin Walker's achievement completion status data into the database
INSERT INTO UserAchievements(steamID, appID, apiName, achieved)
                      VALUES(76561197972495328, 220, 'HL2_GET_CROWBAR', TRUE),
                            (76561197972495328, 400, 'PORTAL_GET_PORTALGUNS', TRUE),
                            (76561197972495328, 620, 'ACH.WAKE_UP', TRUE),
                            (76561197972495328, 72850, 'NEW_ACHIEVEMENT_8_0', FALSE);
             
-- Show test data from each table, make sure everything worked
SELECT *
FROM Players;

SELECT *
FROM Games;

SELECT *
FROM OwnedGames;

SELECT *
FROM UserGameCompletion
ORDER BY steamID DESC,
         userGameRank ASC;

SELECT *
FROM Achievements;

SELECT *
FROM UserAchievements
ORDER BY steamID DESC,
         achieved ASC;

-- Create view of games ordered by number of people who play them
CREATE OR REPLACE VIEW MostPlayedGames AS
  SELECT DISTINCT o.appID, g.name, t.playerCount
  FROM (SELECT o.appID, COUNT(o.appID) AS playerCount
        FROM Players p,
             OwnedGames o
        WHERE o.steamID = p.steamID
        GROUP BY o.appID
       ) t,
       OwnedGames o,
       Games g
   WHERE t.appID = g.appID
     AND t.appID = o.appID
   ORDER BY playerCount DESC;

-- Test MostPlayedGames view
SELECT *
FROM MostPlayedGames;

-- Create view on number of unfinished games for each user
CREATE OR REPLACE VIEW UnfinishedGames AS
  SELECT steamID, COUNT(*) AS unfinishedGamesCount
  FROM UserGameCompletion
  WHERE gameCompleted = FALSE
  GROUP BY steamID;

-- Test UnfinishedGames view
SELECT *
FROM UnfinishedGames;

-- Create function to show a user's unfinished games
CREATE OR REPLACE FUNCTION userUnfinishedGames(bigint, refcursor) RETURNS refcursor AS 
$$
DECLARE
    userSteamID bigint    := $1;
    resultset   REFCURSOR := $2;
BEGIN
    OPEN resultset FOR
        SELECT *
        FROM UserGameCompletion
        WHERE steamID = userSteamID
          AND gameCompleted = FALSE;
    RETURN resultset;
END;
$$
LANGUAGE plpgsql;

-- Test userUnfinishedGames() procedure
SELECT userUnfinishedGames(76561198055529452, 'results');
FETCH ALL FROM results;

-- Define user roles and permissions
CREATE ROLE webapp_admin;
GRANT ALL ON ALL TABLES
IN SCHEMA PUBLIC
TO admin;

CREATE ROLE webapp_user;
GRANT SELECT, INSERT, UPDATE
ON ALL TABLES
IN SCHEMA PUBLIC
TO webapp_user;