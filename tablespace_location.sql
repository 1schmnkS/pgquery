-- ********************************************************************************************************
--  filename: tablespace_location.sql
--  version(s): 11, 12, 13, 14
--  preReqs: none 
-- ********************************************************************************************************
--
--  Results:  lists all tablespaces and their location in the server's filesystem
--
-- ********************************************************************************************************

SELECT
    CASE WHEN pg_tablespace_location(oid) = ''
        AND spcname = 'pg_default' THEN
        current_setting('data_directory') || '/base/'
    WHEN pg_tablespace_location(oid) = ''
        AND spcname = 'pg_global' THEN
        current_setting('data_directory') || '/global/'
    ELSE
        pg_tablespace_location(oid)
    END AS location,
    spcname AS tblspc_name
FROM
    pg_tablespace;