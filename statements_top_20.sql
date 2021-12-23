-- ********************************************************************************************************
--  filename: statements_top_20.sql
--  version(s): 12, 13, 14
--  preReqs: extension pg_stat_statements 
-- ********************************************************************************************************
--
--  Results:  find the top 20 statements in pg_stat_statements; focus on statements with the most executions
--
-- ********************************************************************************************************

SELECT
    db.datname AS db,
    substr(query, 1, 40),
    round(total_exec_time::numeric, 2) AS total_exec_time,
    calls,
    round(mean_exec_time::numeric, 2) AS mean_exec_time,
    round((100 * total_exec_time / sum(total_exec_time::numeric) OVER ())::numeric, 2) AS percentage_overall,
    wal_bytes
FROM
    pg_stat_statements
    JOIN pg_database db ON db.oid = dbid
ORDER BY
    total_exec_time DESC
LIMIT 20;