-- ********************************************************************************************************
--  filename: data_turnaround.sql
--  version(s): 11, 12, 13, 14
--  preReqs: none 
-- ********************************************************************************************************
--
--  Results:
--
--  bytes/mbytes/gbytes the pg wal has progressed since lsn '0/0' (installation time)
--  if collected over time gives an indication how many insert/update/delete activity is handled
--
-- ********************************************************************************************************
SELECT
     a.total_bytes,
    (a.total_bytes / 1024 / 1024)::bigint AS mbytes,
    (a.total_bytes / 1024 ^ 3)::bigint AS gbytes
FROM
    pg_wal_lsn_diff (pg_current_wal_lsn (), '0/0') a (total_bytes);
