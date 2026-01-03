DROP TABLE IF EXISTS boxscores.league_gamelogs;

CREATE TABLE boxscores.league_gamelogs (
    -- Identifiers
    season_id          TEXT NOT NULL,
    team_id            INTEGER NOT NULL,
    team_abbreviation  TEXT,
    team_name          TEXT,
    game_id            TEXT NOT NULL,
    game_date_raw      DATE,
    matchup            TEXT,
    wl                 TEXT,

    -- Minutes
    minutes_raw        INTEGER,

    -- Shooting
    field_goals_made        INTEGER,
    field_goals_attempted   INTEGER,
    field_goals_percentage  REAL,
    three_pointers_made     INTEGER,
    three_pointers_attempted REAL,
    three_pointers_percentage REAL,
    free_throws_made        INTEGER,
    free_throws_attempted   INTEGER,
    free_throws_percentage  REAL,

    -- Rebounding
    rebounds_offensive INTEGER,
    rebounds_defensive INTEGER,
    rebounds_total     INTEGER,

    -- Other stats
    assists        INTEGER,
    steals         INTEGER,
    blocks         INTEGER,
    turnovers      INTEGER,
    fouls_personal INTEGER,
    points         INTEGER,
    plus_minus     REAL,

    -- Metadata
    video_available INTEGER,
    season          TEXT,
    season_type     TEXT,

    CONSTRAINT team_boxscores_traditional_pk
        PRIMARY KEY (game_id, team_id)
);
