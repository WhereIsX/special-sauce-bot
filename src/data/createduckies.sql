CREATE TABLE IF NOT EXISTS duckies ( 
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   username TEXT UNIQUE NOT NULL,
   points INTEGER DEFAULT 0,
   water_consent INTEGER DEFAULT 0,
   at_me_consent INTEGER DEFAULT 0
   
);

INSERT OR IGNORE INTO duckies (username) VALUES ("where_is_x");
INSERT OR IGNORE INTO duckies (username) VALUES ("mr_null");
INSERT OR IGNORE INTO duckies (username, water_consent) VALUES ("mr_consent", 1);