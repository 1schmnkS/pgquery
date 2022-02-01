-- ********************************************************************************************************
--  filename: connection_duration.sql
--  version(s): 11, 12, 13, 14
--  preReqs: none 
-- ********************************************************************************************************
--
--  Results: lists all open connections and when they were started
--
-- ********************************************************************************************************
SELECT
    datname,
    pid,
    state,
    backend_type,
    date_trunc('second', CURRENT_TIMESTAMP - backend_start) AS time_since_connection_start,
    date_trunc('second', CURRENT_TIMESTAMP - query_start) AS time_since_last_query
FROM
    pg_stat_activity
ORDER BY
    time_since_connection_start DESC;