-- ********************************************************************************************************
--  filename: connection_stats.sql
--  version(s): 11, 12, 13, 14
--  preReqs: none 
-- ********************************************************************************************************
--
--  Results:  
--    total:               number of connections (active + idle + idle in transaction)
--    active:              number of currently active connections
--    idle:                number of connections in state 'idle'
--    idle_in_tx:          number of connections in state 'idle in transaction'
--    max_idle_in_tx_time: number of seconds spent by the longest connection in state 'idle in transaction'        
--    idle_in_tx_aborted:  number of connections in state 'idle in transaction (aborted)'
--    max_idle_in_tx_aborted_time: number of seconds spent by the longest connection in state 'idle in transaction (aborted)'        
--    max_qry_time:        number of seconds spent by the longest query of any active connection         
--    max_blk_qry_time:    highest number of seconds a query has been blocked by a lock        
--    max_conn:            maximum number of connections allowed
--
-- ********************************************************************************************************
SELECT    
    total,
    ((total - idle) - idle_in_tx - idle_in_tx_aborted) AS active,
    idle,
    idle_in_tx,
    
    (
        SELECT
            coalesce(extract(epoch FROM (max(now() - state_change))), 0)
        FROM
            pg_catalog.pg_stat_activity
        WHERE
            state = 'idle in transaction') AS max_idle_in_tx_time,    
    idle_in_tx_aborted,
    (
        SELECT
            coalesce(extract(epoch FROM (max(now() - state_change))), 0)
        FROM
            pg_catalog.pg_stat_activity
        WHERE
            state = 'idle in transaction (aborted)') AS max_idle_in_tx_aborted_time,    
    (
        SELECT
            coalesce(extract(epoch FROM (max(now() - query_start))), 0)
        FROM
            pg_catalog.pg_stat_activity
        WHERE
            backend_type = 'client backend'
            AND state <> 'idle') AS max_qry_time,
    (
        SELECT
            coalesce(extract(epoch FROM (max(now() - query_start))), 0)
        FROM
            pg_catalog.pg_stat_activity
        WHERE
            backend_type = 'client backend'
            AND wait_event_type = 'Lock') AS max_blk_qry_time,
    max_conn
FROM (
    SELECT
        count(*) AS total,
        coalesce(sum(
                CASE WHEN state = 'idle' THEN
                    1
                ELSE
                    0
                END), 0) AS idle,
        coalesce(sum(
                CASE WHEN state = 'idle in transaction' THEN
                    1
                ELSE
                    0
                END), 0) AS idle_in_tx,
        coalesce(sum(
                CASE WHEN state = 'idle in transaction (aborted)' THEN
                    1
                ELSE
                    0
                END), 0) AS idle_in_tx_aborted
    FROM
        pg_catalog.pg_stat_activity) pgstat
    JOIN (
        SELECT
            setting::float AS max_conn
        FROM
            pg_settings
        WHERE
            name = 'max_connections') pgparm ON (TRUE);