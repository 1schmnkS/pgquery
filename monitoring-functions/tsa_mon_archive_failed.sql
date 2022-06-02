--
-- tsa_mon_archive_failed()
--
-- returns true if timestamp of last failed archive is newer than timestamp of last archive succeeded 
--
-- example: 
-- 
-- select tsa_mon_archive_failed() ; 
--
CREATE OR REPLACE FUNCTION tsa_mon_archive_failed() RETURNS BOOLEAN AS
$BODY$

DECLARE  
  archive_alert boolean;

BEGIN

  select into archive_alert
  case 
    when ( 
          select count(*) from pg_stat_archiver WHERE NOT pg_is_in_recovery() AND last_archived_time < last_failed_time
    ) = 1 THEN true
    else false
  end as archive_check ;
  
  RETURN archive_alert ;

END

$BODY$
LANGUAGE plpgsql
;

comment on function tsa_mon_archive_failed is 'returns true if timestamp of last failed archive is newer than timestamp of last archive succeeded' ;
   