-- ********************************************************************************************************
--  filename: indexes_not_used.sql
--  version(s): 11, 12, 13, 14
--  preReqs: none 
-- ********************************************************************************************************
--
--  Results:  shows all indexes in current database that has not been used since last pg_stat_reset()
--
-- ********************************************************************************************************
SELECT
    s.schemaname,
    s.relname AS tablename,
    s.indexrelname AS indexname,
    pg_relation_size(s.indexrelid) AS index_size
FROM
    pg_catalog.pg_stat_user_indexes s
    JOIN pg_catalog.pg_index i ON s.indexrelid = i.indexrelid
WHERE
    s.idx_scan = 0                                                     -- has never been scanned
    AND 0 <> ALL (i.indkey)                                            -- no index column is an expression
    AND NOT i.indisunique                                              -- is not a UNIQUE index
    AND NOT EXISTS                                                     -- does not enforce a constraint
    (
        SELECT
            1
        FROM
            pg_catalog.pg_constraint c
        WHERE
            c.conindid = s.indexrelid)
ORDER BY
    pg_relation_size(s.indexrelid) DESC;