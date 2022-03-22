-- ********************************************************************************************************
--  filename: checkpoint_average_write_time.sql
--  version(s): 11, 12, 13, 14
--  preReqs: none 
-- ********************************************************************************************************
--
--  Results: average checkpoint write time per checkpoint in seconds
--           (result should be less than checkpoint_timeout)
--
-- ********************************************************************************************************
--
SELECT
    (checkpoint_write_time / (checkpoints_timed + checkpoints_req)) / 1000
FROM
    pg_stat_bgwriter;
