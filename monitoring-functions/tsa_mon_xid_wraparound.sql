--
-- tsa_mon_xid_wraparound(xid_difference)
--
-- returns true if the difference between the oldest transaction and the newest transaction is > <xid_difference>
--
-- example: 
-- 
-- select tsa_mon_xid_wraparound(1900000000) ; 
--
-- xid_difference 1000000000 -> true -> warning
-- xid_difference 1900000000 -> true -> critical 
--
CREATE OR REPLACE FUNCTION tsa_mon_xid_wraparound(xid_difference integer) RETURNS BOOLEAN AS
$BODY$

DECLARE  
  xid_alert boolean;

BEGIN

  select into xid_alert
  case 
    when ( 
          SELECT COUNT(*) FROM
            (
              SELECT  oldest_xid::text::int as first_xid
                    , regexp_replace(next_xid, '^[0-9]+:', '')::int-1 as last_xid
              FROM pg_control_checkpoint()
            ) as xid_range
          WHERE NOT pg_is_in_recovery() and (last_xid-first_xid) > xid_difference
    ) = 1 THEN true
    else false
  end as xid_check ;
  
  RETURN xid_alert ;

END

$BODY$
LANGUAGE plpgsql
;

   