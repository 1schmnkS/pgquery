--
-- tsa_mon_pgbackrest_info 
-- 
-- provides informations about pgbackrest backups 
-- 
-- see sample queries below 
-- 

create or replace function tsa_mon_pgbackrest_info()
    returns jsonb AS 
$BODY$

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
end 

$BODY$ 
language plpgsql;

comment on function tsa_mon_pgbackrest_info is 'provides informations about pgbackrest backups' ; 