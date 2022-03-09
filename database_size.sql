-- ********************************************************************************************************
--  filename: database_size.sql
--  version(s): 11, 12, 13, 14
--  preReqs: none 
-- ********************************************************************************************************
--
--  Results:  select sizing informations on various detail levels
--
-- ********************************************************************************************************
--
-- total size of all databases
--
SELECT
    sum(pg_database_size(datname) / 1024 / 1024) AS total_MB
FROM
    pg_database
WHERE
    NOT datistemplate ;

--
-- size by database
--
SELECT
    oid,
    datname,
    pg_database_size(datname) / 1024 / 1024 AS size_MB
FROM
    pg_database
ORDER BY
    datname;

--
-- object sizes on database level:
--
--
-- grouped by schema and object type (table, index, etc.)
--
\c <dbname>
SELECT
    pg_size_pretty(sum(pg_relation_size(pg_class.oid))::bigint),
    nspname,
    CASE pg_class.relkind
    WHEN 'r' THEN
        'table'
    WHEN 'i' THEN
        'index'
    WHEN 'S' THEN
        'sequence'
    WHEN 'v' THEN
        'view'
    WHEN 't' THEN
        'toast'
    ELSE
        pg_class.relkind::text
    END
FROM
    pg_class
    LEFT OUTER JOIN pg_namespace ON (pg_namespace.oid = pg_class.relnamespace)
GROUP BY
    pg_class.relkind,
    nspname
ORDER BY
    sum(pg_relation_size(pg_class.oid)) DESC;

--
-- detail query for all objects:
--
\c <dbname>
SELECT
    pg_size_pretty(pg_relation_size(pg_class.oid)),
    pg_class.relname,
    pg_namespace.nspname,
    CASE pg_class.relkind
    WHEN 'r' THEN
        'table'
    WHEN 'i' THEN
        'index'
    WHEN 'S' THEN
        'sequence'
    WHEN 'v' THEN
        'view'
    WHEN 't' THEN
        'toast'
    ELSE
        pg_class.relkind::text
    END
FROM
    pg_class
    LEFT OUTER JOIN pg_namespace ON (pg_namespace.oid = pg_class.relnamespace)
ORDER BY
    pg_relation_size(pg_class.oid) DESC;
    
--
-- detail query II: 
--
SELECT
    *,
    pg_size_pretty(total_bytes) AS total,
    pg_size_pretty(index_bytes) AS index,
    pg_size_pretty(toast_bytes) AS toast,
    pg_size_pretty(table_bytes) AS table
FROM (
    SELECT
        *,
        total_bytes - index_bytes - coalesce(toast_bytes, 0) AS table_bytes
    FROM (
        SELECT
            c.oid,
            nspname AS table_schema,
            relname AS table_name,
            c.reltuples AS row_estimate,
            pg_total_relation_size(c.oid) AS total_bytes,
            pg_indexes_size(c.oid) AS index_bytes,
            pg_total_relation_size(reltoastrelid) AS toast_bytes
        FROM
            pg_class c
        LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE
        relkind = 'r'
        -- AND relname = 'order'
         ) a) a;


