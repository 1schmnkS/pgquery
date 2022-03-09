-- ********************************************************************************************************
--  filename: pg_stat_database.sql
--  version(s): 11, 12, 13, 14
--  preReqs: none 
-- ********************************************************************************************************
--
--  Results:  various useful metrics selected from pg_stat_database
--
-- ********************************************************************************************************
--
--   cache hit ratio per database (the higher the value the better)
--
-- ********************************************************************************************************

SELECT
    datname,
    100 * blks_hit / (blks_hit + blks_read) AS cache_hit_ratio
FROM
    pg_stat_database
WHERE (blks_hit + blks_read) > 0;

-- ********************************************************************************************************
--
--   cache hit ratio over all databases (the higher the value the better)
--
-- ********************************************************************************************************

SELECT
    round(100 * sum(blks_hit) / sum(blks_hit + blks_read), 3) AS cache_hit_ratio
FROM
    pg_stat_database;

-- ********************************************************************************************************
--
--   commit ratio (the higher the value the better)
--   transactions successfully commited vs rollback 
--
-- ********************************************************************************************************

SELECT
    datname,
    100 * xact_commit / (xact_commit + xact_rollback) AS commit_ratio
FROM
    pg_stat_database
WHERE (xact_commit + xact_rollback) > 0;