--master
ALTER DATABASE hiramdw MODIFY (SERVICE_OBJECTIVE = 'DW200c');

SELECT  db.name [Database]
,	    ds.edition [Edition]
,	    ds.service_objective [Service Objective]
FROM    sys.database_service_objectives   AS ds
JOIN    sys.databases                     AS db ON ds.database_id = db.database_id
;

SELECT    *
FROM      sys.dm_operation_status
WHERE     resource_type_desc = 'Database'
AND       major_resource_id = 'hiramdw'
;


--userdb
with test as 
(
    select
    (select @@version) version_number
    ,(select count(*) from sys.dm_pdw_exec_requests where status in ('Running', 'Pending', 'CancelSubmitted') and session_id != SESSION_ID()) active_query_count
    ,(select count(*) from sys.dm_pdw_exec_sessions where is_transactional = 1) as session_transactional_count
    ,(select count(*) from sys.dm_pdw_waits where type = 'Exclusive') as pdw_waits
)
select
    case when
            version_number like 'Microsoft Azure SQL Data Warehouse%'
            and active_query_count = 0
            and session_transactional_count = 0
            and pdw_waits = 0
            then 1
    else 0
    end as CanScale
from test