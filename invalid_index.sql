-- ********************************************************************************************************
--  filename: invalid_index.sql
--  version(s): 11, 12, 13, 14
--  preReqs: none 
-- ********************************************************************************************************
--
--  Results:  shows all invalid indexes in a database
--            if this query returns any rows consider reindexing
--
-- ********************************************************************************************************
\c <dbname>
SELECT
    pg_class.relname
FROM
    pg_class,
    pg_index
WHERE
    pg_index.indisvalid = FALSE
    AND pg_index.indexrelid = pg_class.oid;
