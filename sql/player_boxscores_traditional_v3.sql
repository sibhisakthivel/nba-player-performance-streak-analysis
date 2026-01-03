DROP TABLE IF EXISTS boxscores.player_boxscores_traditional_v3;

CREATE TABLE boxscores.player_boxscores_traditional_v3 (
    -- Identifiers
    game_id_api        TEXT NOT NULL,
    team_id            INTEGER NOT NULL,
    team_city          TEXT,
    team_name          TEXT,
    team_tricode       TEXT,
    team_slug          TEXT,
    player_id          INTEGER NOT NULL,

    -- Player metadata
    first_name         TEXT,
    family_name        TEXT,
    name_initial       TEXT,
    player_slug        TEXT,
    position           TEXT,
    comment            TEXT,
    jersey_number      TEXT,

    -- Playing time
    minutes_raw        TEXT,

    -- Shooting
    field_goals_made           INTEGER,
    field_goals_attempted      INTEGER,
    field_goals_percentage     REAL,
    three_pointers_made        INTEGER,
    three_pointers_attempted   INTEGER,
    three_pointers_percentage  REAL,
    free_throws_made           INTEGER,
    free_throws_attempted      INTEGER,
    free_throws_percentage     REAL,

    -- Rebounding
    rebounds_offensive INTEGER,
    rebounds_defensive INTEGER,
    rebounds_total     INTEGER,

    -- Other stats
    assists            INTEGER,
    steals             INTEGER,
    blocks             INTEGER,
    turnovers          INTEGER,
    fouls_personal     INTEGER,
    points             INTEGER,
    plus_minus_points  REAL,   
    game_id            TEXT,

    CONSTRAINT player_boxscores_trad_v3_pk
        PRIMARY KEY (game_id_api, player_id)
);
