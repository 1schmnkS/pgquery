-- ********************************************************************************************************
--  filename: replication_lag.sql
--  version(s): 11, 12, 13, 14
--  preReqs: none 
-- ********************************************************************************************************
--
--  Results: shows how long the secondary is behind the primary node 
--
-- ********************************************************************************************************
--
-- on the secondary:
--
SELECT
    CASE WHEN pg_last_wal_receive_lsn () = pg_last_wal_replay_lsn () THEN
        0
    ELSE
        EXTRACT(EPOCH FROM now() - pg_last_xact_replay_timestamp())
    END AS log_delay
WHERE
    pg_is_in_recovery();

-- ********************************************************************************************************
--
--  Results: shows how many GB all replication slots are lagging behind 
--
-- ********************************************************************************************************
--
-- on the primary:
--
SELECT
    redo_lsn,
    slot_name,
    restart_lsn,
    round((redo_lsn - restart_lsn) / cast(1024^3 as decimal) , 2) AS GB_behind
FROM
    pg_control_checkpoint(),
    pg_replication_slots;