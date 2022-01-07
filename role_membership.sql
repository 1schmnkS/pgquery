-- ********************************************************************************************************
--  filename: role_membership.sql
--  version(s): 11, 12, 13, 14
--  preReqs: none 
-- ********************************************************************************************************
--
--  Results:  list of roles where role-name is a member of 
--
-- ********************************************************************************************************
SELECT
    st.oid AS security_principal_id,
    st.rolname AS security_principal_name,
    mp.roleid AS mapped_role_id,
    rms.rolname AS mapped_role_name
FROM
    pg_roles st
    INNER JOIN pg_auth_members mp ON st.oid = mp.member
    INNER JOIN pg_roles rms ON mp.roleid = rms.oid
WHERE
    st.rolname = '<role-name>'
ORDER BY
    security_principal_id,
    mapped_role_name;