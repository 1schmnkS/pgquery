-- ********************************************************************************************************
--  filename: vacuum_doomsday_clock.sql
--  version(s): 11, 12, 13, 14
--  preReqs: none 
-- ********************************************************************************************************
--
--  Results:  
--
--  tx_between_oldest_and_current: hightest number of xid's in any database between oldest and current xid
--  percent_towards_wraparound:    if this value reaches 100 immediate vacuum has to be started manually:
--    $> vacuumdb --all --freeze --jobs=2 --echo --analyze
--  percent_towards_emergency_autovac: if this value reaches 100 autovacuum will kick in 
-- ********************************************************************************************************
WITH max_age AS (
    SELECT
        2000000000 AS max_old_xid,
        setting AS autovacuum_freeze_max_age
    FROM
        pg_catalog.pg_settings
    WHERE
        name = 'autovacuum_freeze_max_age'
),
per_database_stats AS (
    SELECT
        datname,
        m.max_old_xid::int,
        m.autovacuum_freeze_max_age::int,
        age(d.datfrozenxid) AS oldest_current_xid
FROM
    pg_catalog.pg_database d
    JOIN max_age m ON (TRUE)
    WHERE
        d.datallowconn
)
SELECT
    max(oldest_current_xid) AS oldest_current_xid,
    max(ROUND(100 * (oldest_current_xid / max_old_xid::float))) AS percent_towards_wraparound,
    max(ROUND(100 * (oldest_current_xid / autovacuum_freeze_max_age::float))) AS percent_towards_emergency_autovac
FROM
    per_database_stats;

