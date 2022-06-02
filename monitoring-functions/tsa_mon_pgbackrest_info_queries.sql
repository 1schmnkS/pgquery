--
-- sample queries how to use tsa_mon_pgbackrest_info() : 
--
-- get last backup timestamp and last wal archived: 
-- 
with stanza as
(
    select data->'name' as name,
           data->'backup'->(
               jsonb_array_length(data->'backup') - 1) as last_backup,
           data->'archive'->(
               jsonb_array_length(data->'archive') - 1) as current_archive
      from jsonb_array_elements(pgbackrest_info()) as data
)
select name,
       to_timestamp(
           (last_backup->'timestamp'->>'stop')::numeric) as last_successful_backup,
       current_archive->>'max' as last_archived_wal
  from stanza;

--
-- query backup age with seconds since last backup
-- 86400 = 24h 
--  
with stanza as
(
    select data->'name' as name,
           data->'backup'->(
               jsonb_array_length(data->'backup') - 1) as last_backup           
      from jsonb_array_elements(pgbackrest_info()) as data
)
select name,
       to_timestamp((last_backup->'timestamp'->>'stop')::numeric) as last_successful_backup,
       extract(epoch from (now() - to_timestamp((last_backup->'timestamp'->>'stop')::numeric)))::int as seconds_since_backup       
  from stanza where extract(epoch from (now() - to_timestamp((last_backup->'timestamp'->>'stop')::numeric)))::int > 86400;