-- ********************************************************************************************************
--  filename: collation_support.sql
--  version(s): 11, 12, 13, 14
--  preReqs: none 
-- ********************************************************************************************************
--
--  Results:  a short overview on how to use collations (linux)
--
-- ********************************************************************************************************

# os layer: 

pg relies on the collations available on os-level: 

~~~ 

$> localectl list-locales | grep -i DE
de_AT
de_AT.iso88591
de_AT.iso885915@euro
de_AT.utf8
de_AT@euro
de_BE

... 

nds_DE.utf8
sd_IN.utf8@devanagari
sd_IN@devanagari

~~~

# creating a new database with a specific collation 

~~~

$> psql
psql (12.5)
Type "help" for help.

--
-- new database with other collation must be created with template=template0: 
--

postgres=# create database colltest with LC_COLLATE = "de_AT.utf8" LC_CTYPE = "de_AT.utf8" template=template0 ;

CREATE DATABASE
postgres=# \l
                                    List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |     Access privileges
-----------+----------+----------+-------------+-------------+---------------------------
 colltest  | postgres | UTF8     | de_AT.utf8  | de_AT.utf8  |
 
~~~

