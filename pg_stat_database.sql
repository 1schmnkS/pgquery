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
    datname, blks_hit , blks_read , 
    100 * blks_hit / (blks_hit + blks_read) AS cache_hit_ratio
FROM
    pg_stat_database
WHERE (blks_hit + blks_read) > 0 order by 4 asc ;

-- ********************************************************************************************************
--
--   cache hit ratio over all databases (the higher the value the better)
--
-- ********************************************************************************************************

SELECT
    sum(blks_hit) as blks_hit , sum(blks_read) as blks_read, round(100 * sum(blks_hit) / sum(blks_hit + blks_read), 3) AS cache_hit_ratio
FROM
    pg_stat_database;

-- ********************************************************************************************************
--
--   commit ratio (the higher the value the better)
--   transactions successfully commited vs rollback 
--
-- ********************************************************************************************************

SELECT
    datname, xact_commit , xact_rollback , 
    100 * xact_commit / (xact_commit + xact_rollback) AS commit_ratio
FROM
    pg_stat_database
WHERE (xact_commit + xact_rollback) > 0 order by 4 asc ;


-- ********************************************************************************************************
--
--   cache hit ratio for every user table in a given database (the higher the value the better)
--
-- ********************************************************************************************************

\c <dbname>
SELECT 
  schemaname ,
  relname ,  
  heap_blks_read ,
  heap_blks_hit , 
  100* heap_blks_hit/(heap_blks_hit + heap_blks_read) as heap_hit_ratio
  , 100* idx_blks_hit/(idx_blks_hit + idx_blks_read) as idx_hit_ratio
-- , (idx_blks_hit/(idx_blks_hit + idx_blks_read)*100) as idx_hit_ratio 
-- , (toast_blks_hit/(toast_blks_hit + toast_blks_read)*100) as toast_hit_ratio 
-- , (tidx_blks_hit /(tidx_blks_hit + tidx_blks_read)*100) as tidx_hit_ratio
FROM 
  pg_statio_user_tables
  where heap_blks_hit + heap_blks_read > 0 
  AND   idx_blks_hit + idx_blks_read > 0 
ORDER BY
  schemaname ,
  relname;