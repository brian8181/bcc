CREATE TABLE playlist2
(
   rowid INTEGER PRIMARY KEY AUTOINCREMENT,
   playlist TEXT,
   -- triggered
   update_ts TIMESTAMP,
   insert_ts TIMESTAMP
);

CREATE TABLE playlist2_cash
(
   rowid INT PRIMARY KEY ASC,
   playlist_rowid INT,
   cash_rowid INT,
   -- triggered
   update_ts TIMESTAMP,
   insert_ts TIMESTAMP
);