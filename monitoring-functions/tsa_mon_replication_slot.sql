--
-- tsa_mon_replication_slot()
--
-- returns true if any active pyhsical replication slot has wal_status <> 'reserved'
--
-- example: 
-- 
-- select tsa_mon_replication_slot() ; 
--
CREATE OR REPLACE FUNCTION tsa_mon_replication_slot() RETURNS BOOLEAN AS
$BODY$

DECLARE  
  slot_alert boolean;

BEGIN

  select into slot_alert
  case 
    when ( 
          SELECT COUNT(*) FROM pg_replication_slots 
          WHERE 
            NOT pg_is_in_recovery() 
            AND active AND slot_type = 'physical' 
            AND wal_status <> 'reserved'
    ) > 0 THEN true
    else false
  end as replication_check ;
  
  RETURN slot_alert ;

END

$BODY$
LANGUAGE plpgsql
;

   