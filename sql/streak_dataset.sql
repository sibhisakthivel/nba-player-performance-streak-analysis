-- WITH base AS (
--     -- This is your dataset_construction.sql, inlined
--     WITH teams AS (
--         SELECT
--             team_id,
--             team_abbreviation,
--             game_id,
--             game_date,
--             matchup,
--             points,
--             AVG(points) OVER (
--                 PARTITION BY opponent
--                 ORDER BY game_date
--                 ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
--             ) AS opp_pts_allowed
--         FROM boxscores.league_gamelogs
--     )
--     SELECT
--         t.game_id,
--         t.game_date,
--         p.player_id,
--         p.player_name,
--         p.clean_name,
--         p.team_id,
--         p.points,
--         AVG(p.points) OVER (
--             PARTITION BY p.player_id
--             ORDER BY t.game_date
--             ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
--         ) AS season_avg_pts,
--         p.points
--             - AVG(p.points) OVER (
--                 PARTITION BY p.player_id
--                 ORDER BY t.game_date
--                 ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
--             ) AS deviation,
--         CASE
--             WHEN p.points >
--                  AVG(p.points) OVER (
--                      PARTITION BY p.player_id
--                      ORDER BY t.game_date
--                      ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
--                  )
--             THEN 1
--             ELSE 0
--         END AS over_flag
--     FROM teams t
--     JOIN boxscores.player_boxscores_traditional_v3 p
--         ON p.game_id = t.game_id
--        AND p.team_id <> t.team_id
-- ),

-- with_lag AS (
--     SELECT
--         *,
--         LAG(over_flag) OVER (
--             PARTITION BY player_id
--             ORDER BY game_date
--         ) AS prev_over_flag
--     FROM base
-- ),

-- streak_breaks AS (
--     SELECT
--         *,
--         CASE
--             WHEN prev_over_flag IS NULL THEN 1
--             WHEN over_flag != prev_over_flag THEN 1
--             ELSE 0
--         END AS streak_start
--     FROM with_lag
-- ),

-- streak_ids AS (
--     SELECT
--         *,
--         SUM(streak_start) OVER (
--             PARTITION BY player_id
--             ORDER BY game_date
--         ) AS streak_id
--     FROM streak_breaks
-- ),

-- streak_lengths AS (
--     SELECT
--         *,
--         COUNT(*) OVER (
--             PARTITION BY player_id, streak_id
--             ORDER BY game_date
--         ) AS streak_length
--     FROM streak_ids
-- ),

-- next_game AS (
--     SELECT
--         *,
--         LEAD(over_flag) OVER (
--             PARTITION BY player_id
--             ORDER BY game_date
--         ) AS next_over_flag
--     FROM streak_lengths
-- )

-- SELECT
--     player_id,
--     player_name,
--     clean_name,
--     game_date,
--     over_flag,
--     streak_id,
--     streak_length,
--     next_over_flag
-- FROM next_game
-- WHERE next_over_flag IS NOT NULL
-- ORDER BY player_id, game_date;

WITH base AS (

    -- Inline dataset_construction with opponent context
    WITH teams AS (
        SELECT
            team_id,
            team_abbreviation,
            team_name,
            opponent,
            game_id,
            game_date,
            matchup,
            points,
            AVG(points) OVER (
                PARTITION BY opponent
                ORDER BY game_date
                ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
            ) AS opp_pts_allowed
        FROM boxscores.league_gamelogs
    )

    SELECT
        t.game_id,
        t.game_date,

        -- player info
        p.player_id,
        p.player_name,
        p.clean_name,
        p.team_id,
        p.points,
        AVG(p.points) OVER (PARTITION BY player_id) AS full_season_ppg,

        -- opponent info (NEW)
        t.team_abbreviation AS opp_team_abbreviation,
        t.team_name         AS opp_team_name,
        t.opp_pts_allowed,

        -- season context
        AVG(p.points) OVER (
            PARTITION BY p.player_id
            ORDER BY t.game_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS season_avg_pts,

        p.points
            - AVG(p.points) OVER (
                PARTITION BY p.player_id
                ORDER BY t.game_date
                ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
            ) AS deviation,

        CASE
            WHEN p.points >
                 AVG(p.points) OVER (
                     PARTITION BY p.player_id
                     ORDER BY t.game_date
                     ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
                 )
            THEN 1
            ELSE 0
        END AS over_flag

    FROM teams t
    JOIN boxscores.player_boxscores_traditional_v3 p
        ON p.game_id = t.game_id
       AND p.team_id <> t.team_id
),

with_lag AS (
    SELECT
        *,
        LAG(over_flag) OVER (
            PARTITION BY player_id
            ORDER BY game_date
        ) AS prev_over_flag
    FROM base
),

streak_breaks AS (
    SELECT
        *,
        CASE
            WHEN prev_over_flag IS NULL THEN 1
            WHEN over_flag != prev_over_flag THEN 1
            ELSE 0
        END AS streak_start
    FROM with_lag
),

streak_ids AS (
    SELECT
        *,
        SUM(streak_start) OVER (
            PARTITION BY player_id
            ORDER BY game_date
        ) AS streak_id
    FROM streak_breaks
),

streak_lengths AS (
    SELECT
        *,
        COUNT(*) OVER (
            PARTITION BY player_id, streak_id
            ORDER BY game_date
        ) AS streak_length
    FROM streak_ids
),

next_game AS (
    SELECT
        *,
        LEAD(over_flag) OVER (
            PARTITION BY player_id
            ORDER BY game_date
        ) AS next_over_flag
    FROM streak_lengths
)

SELECT
    player_id,
    player_name,
    clean_name,
    game_date,
    full_season_ppg,

    opp_team_abbreviation,
    opp_team_name,
    opp_pts_allowed,

    over_flag,
    streak_id,
    streak_length,
    next_over_flag
FROM next_game
WHERE next_over_flag IS NOT NULL
ORDER BY player_id, game_date;
