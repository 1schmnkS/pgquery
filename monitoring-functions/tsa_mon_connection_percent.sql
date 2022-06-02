--
-- tsa_mon_connection_percent(threshold_pct)
--
-- returns true if number of open connections exceeds <threshold_pct>%  of max_connections
--
-- example: 
-- 
-- select tsa_mon_connection_percent(80) ; 
--
-- returns true if current number of connections exceeds 80% of 'max_connections'
-- 
CREATE OR REPLACE FUNCTION tsa_mon_connection_percent(threshold_pct INTEGER) RETURNS BOOLEAN AS
$BODY$

DECLARE  
  connection_alert boolean;

BEGIN

  select into connection_alert
  case 
    when ( 
          select count(*) from
            (select count(*) used_total from pg_stat_activity) act,
            (select setting::int max_conn from pg_settings where name=$$max_connections$$) setting 
         where ( used_total*100/max_conn ) >= threshold_pct         
    ) = 1 THEN true
    else false
  end as connection_check ;
  
  RETURN connection_alert ;

END

$BODY$
LANGUAGE plpgsql
;

   