-- ********************************************************************************************************
--  filename: clone_database.sql
--  version(s): 11, 12, 13, 14
--  preReqs: none 
-- ********************************************************************************************************
--
-- Results: clone a database test (incl. data)
--
-- ********************************************************************************************************

CREATE DATABASE test_clone TEMPLATE test;

-- ********************************************************************************************************
--
-- from the shell with terminating all current connections to the database: 
--
-- ********************************************************************************************************
$> psql -qc "select pg_terminate_backend(pid) from pg_stat_activity where datname = 'test'" && createdb -T sbtest sbtest_clone &
