-- ********************************************************************************************************
--  filename: connection_ssl.sql
--  version(s): 11, 12, 13, 14
--  preReqs: none 
-- ********************************************************************************************************
--
--  Results:  show connections not using ssl 
--
-- ********************************************************************************************************
SELECT
    datname,
    usename,
    ssl,
    client_addr
FROM
    pg_stat_ssl
    JOIN pg_stat_activity ON pg_stat_ssl.pid = pg_stat_activity.pid
WHERE
    NOT ssl
ORDER BY
    datname,
    usename;
