--
--
-- tsa_mon_replication_lag('replication lag')
--
-- returns true if replication lag is bigger than 'replication lag' (specified as 'nnnbytes', 'nnnkB', 'nnnMB', 'nnnGB', etc.) 
-- 
-- example:
-- select tsa_mon_replication_lag('1MB') ;    -> returns true if current replication lag > 1MB 
--
create or replace function tsa_mon_replication_lag(replication_lag text) RETURNS BOOLEAN AS
$BODY$

DECLARE  
  replication_alert boolean;
  
BEGIN

  select into replication_alert
  case 
    when ( 
            SELECT COUNT(*) FROM pg_stat_replication
            WHERE not pg_is_in_recovery() AND 
            ( pg_wal_lsn_diff(pg_current_wal_lsn(), flush_lsn)  >= pg_size_bytes(replication_lag) or
              pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn) >= pg_size_bytes(replication_lag) )
          ) > 0 then true 
    else false 
  end as replication_check ;
  
  return replication_alert ;
  
END

$BODY$
LANGUAGE plpgsql
;
 