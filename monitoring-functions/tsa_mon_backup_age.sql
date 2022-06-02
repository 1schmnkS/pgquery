--
--
-- tsa_mon_backup_age(seconds)
--
-- returns true if last backup (full, diff or incremental) is older than <seconds> 
-- 
-- example:
-- select tsa_mon_backup_age(86400) ;    -> returns true if last backup (full, diff or incremental) is older than 24 hours
--
-- requires: tsa_mon_pgbackrest_info() 
--
create or replace function tsa_mon_backup_age(seconds integer) RETURNS BOOLEAN AS
$BODY$

DECLARE  
  backup_alert boolean;
  
BEGIN

  select into backup_alert
  case 
    when ( with stanza as
               (          
                  select data->'backup'->(jsonb_array_length(data->'backup') - 1) as last_backup
                  from jsonb_array_elements(tsa_mon_pgbackrest_info()) as data
                )
           select count(*) from stanza where extract(epoch from (now() - to_timestamp((last_backup->'timestamp'->>'stop')::numeric)))::int > seconds
          ) = 1 then true 
    else false 
  end as backup_check ;
  
  return backup_alert ;
  
END

$BODY$
LANGUAGE plpgsql
;

comment on function tsa_mon_backup_age is 'returns true if last backup (full, diff or incremental) is older than <seconds>' ;