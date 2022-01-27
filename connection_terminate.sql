-- ********************************************************************************************************
--  filename: connection_terminate.sql
--  version(s): 11, 12, 13, 14
--  preReqs: none 
-- ********************************************************************************************************
--
--  Results: terminate connections based on various criteria (state, database name, when the state changed
--
-- ********************************************************************************************************
SELECT
    pg_terminate_backend(pid)
FROM
    pg_stat_activity
WHERE
    datname = '<database name>'
    AND pid <> pg_backend_pid()
    AND state = 'idle in transaction (aborted)'
    AND state_change < CURRENT_TIMESTAMP - INTERVAL '5' MINUTE;