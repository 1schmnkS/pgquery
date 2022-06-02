--
-- tsa_mon_pgbackrest_info 
-- 
-- provide informations about pgbackrest backups 
-- 
-- see sample queries below 
-- 

create or replace function tsa_mon_pgbackrest_info()
    returns jsonb AS $$
declare
    data jsonb;
begin
    -- Create a temp table to hold the JSON data
    create temp table temp_pgbackrest_data (data jsonb);

    -- Copy data into the table directly from the pgBackRest info command
    copy temp_pgbackrest_data (data)
        from program
            'pgbackrest --output=json info' (format text);

    select temp_pgbackrest_data.data
      into data
      from temp_pgbackrest_data;

    drop table temp_pgbackrest_data;

    return data;
end $$ language plpgsql;

--
-- sample query: 
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
-- seconds since last backup
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


with stanza as
(
    select data->'name' as name,
           data->'backup'->(
               jsonb_array_length(data->'backup') - 1) as last_backup           
      from jsonb_array_elements(pgbackrest_info()) as data
)
select count(*) from stanza where extract(epoch from (now() - to_timestamp((last_backup->'timestamp'->>'stop')::numeric)))::int > 86400;