-- 
-- postgreSQL collation support
-- 
# postgres and collations 

pg relies on the collations available on os-level: 

[postgres@tsapgtstc01n02 ~]$ localectl list-locales | grep -i DE
de_AT
de_AT.iso88591
de_AT.iso885915@euro
de_AT.utf8
de_AT@euro
de_BE
de_BE.iso88591
de_BE.iso885915@euro
de_BE.utf8
de_BE@euro
de_CH
de_CH.iso88591
de_CH.utf8
de_DE
de_DE.iso88591
de_DE.iso885915@euro
de_DE.utf8
de_DE@euro
de_LU
de_LU.iso88591
de_LU.iso885915@euro
de_LU.utf8
de_LU@euro
deutsch
fy_DE
fy_DE.utf8
gez_ER.utf8@abegede
gez_ER@abegede
gez_ET.utf8@abegede
gez_ET@abegede
hsb_DE
hsb_DE.iso88592
hsb_DE.utf8
ks_IN.utf8@devanagari
ks_IN@devanagari
nds_DE
nds_DE.utf8
sd_IN.utf8@devanagari
sd_IN@devanagari

## creating a new database 

[postgres@tsapgtstc01n02 ~]$ psql
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

