USE puerto_obo2;

ALTER TABLE obo_app_fee ADD dynamic int 
go
UPDATE obo_app_fee SET dynamic = 0
go

ALTER TABLE obo_app ADD 
   timestart datetime null, 
   assessed int null
go 

UPDATE obo_doctype SET requirefee = 1 WHERE requirefee = 2
go 


if object_id('dbo.vw_obo_app', 'V') IS NOT NULL 
   DROP VIEW vw_obo_app; 
GO

CREATE VIEW vw_obo_app AS 
SELECT 
   app.*, 
   'building_permit' AS appclass,    
   bp.title AS title,
   
   LTRIM(CONCAT(
      (CASE WHEN bp.location_unitno IS NULL THEN '' ELSE CONCAT(' ', bp.location_unitno) END),
      (CASE WHEN bp.location_bldgno IS NULL THEN '' ELSE CONCAT(' ', bp.location_bldgno) END),
      (CASE WHEN bp.location_bldgname IS NULL THEN '' ELSE CONCAT(' ', bp.location_bldgname) END),
      (CASE WHEN bp.location_lotno IS NULL THEN '' ELSE CONCAT( ' Lot.', bp.location_lotno) END),
      (CASE WHEN bp.location_blockno IS NULL THEN '' ELSE CONCAT(' Blk.', bp.location_blockno) END),
      (CASE WHEN bp.location_street IS NULL THEN '' ELSE CONCAT(' ', bp.location_street) END),
      (CASE WHEN bp.location_subdivision IS NULL THEN '' ELSE CONCAT(', ', bp.location_subdivision) END),      
      (CASE WHEN bp.location_barangay_name IS NULL THEN '' ELSE CONCAT(', ', bp.location_barangay_name ) END)
   )) AS location_text,


   be.name AS applicant_name,
   be.address_text AS applicant_address_text,
   be.profileid AS applicant_profileid,

   bt.state AS task_state, 
   bt.assignee_objid AS task_assignee_objid,
   'building_permit' AS processname,
   'BUILDING PERMIT' AS doctitle,
   'vw_building_permit' AS schemaname

FROM obo_app app
INNER JOIN building_permit bp ON app.objid = bp.objid
INNER JOIN obo_app_entity be ON app.applicantid = be.objid 
INNER JOIN building_permit_task bt ON bp.taskid = bt.taskid 

UNION 

SELECT 
   app.*, 
   'occupancy_certificate' AS appclass,    
   bp.title AS title,
   LTRIM(CONCAT(
      (CASE WHEN bp.location_unitno IS NULL THEN '' ELSE CONCAT(' ', bp.location_unitno) END),
      (CASE WHEN bp.location_bldgno IS NULL THEN '' ELSE CONCAT(' ', bp.location_bldgno) END),
      (CASE WHEN bp.location_bldgname IS NULL THEN '' ELSE CONCAT(' ', bp.location_bldgname) END),
      (CASE WHEN bp.location_lotno IS NULL THEN '' ELSE CONCAT( ' Lot.', bp.location_lotno) END),
      (CASE WHEN bp.location_blockno IS NULL THEN '' ELSE CONCAT(' Blk.', bp.location_blockno) END),
      (CASE WHEN bp.location_street IS NULL THEN '' ELSE CONCAT(' ', bp.location_street) END),
      (CASE WHEN bp.location_subdivision IS NULL THEN '' ELSE CONCAT(', ', bp.location_subdivision) END),      
      (CASE WHEN bp.location_barangay_name IS NULL THEN '' ELSE CONCAT(', ', bp.location_barangay_name ) END)
   )) AS location_text,

   be.name AS applicant_name,
   be.address_text AS applicant_address_text,
   be.profileid AS applicant_profileid,

   bt.state AS task_state, 
   bt.assignee_objid AS task_assignee_objid,
   'occupancy_certificate' AS processname,
   'OCCUPANCY CERTIFICATE' AS doctitle,
   'vw_occupancy_certificate' AS schemaname
   
FROM obo_app app
INNER JOIN occupancy_certificate oc ON oc.objid = app.objid 
INNER JOIN building_permit bp ON oc.bldgpermitid = bp.objid
INNER JOIN obo_app_entity be ON app.applicantid = be.objid 
INNER JOIN occupancy_certificate_task bt ON oc.taskid = bt.taskid 
go 


if object_id('dbo.vw_building_permit', 'V') IS NOT NULL 
   DROP VIEW vw_building_permit; 
GO

CREATE VIEW vw_building_permit AS 
SELECT 
   a.*,

   bp.taskid,
   bp.amount,
   bp.description,
   bp.title,
   bp.occupancytypeid,
   bp.numunits,
   bp.fixedcost,
   bp.projectcost,
   bp.dtproposedconstruction,
   bp.dtexpectedcompletion,
   bp.totalfloorarea,
   bp.height,
   bp.numfloors,
   bp.worktypes,
   bp.location_lotno,
   bp.location_blockno,
   bp.location_street,
   bp.location_barangay_name,
   bp.location_barangay_objid,
   bp.supervisorid,
   bp.location_unitno,
   bp.location_bldgno,
   bp.location_bldgname,
   bp.location_subdivision,
   bp.location_lotarea,

   ae.name AS applicant_name,

   bt.objid AS occupancytype_objid,
   bt.title AS occupancytype_title,   
   od.objid AS occupancytype_division_objid,
   od.title AS occupancytype_division_title,   
   og.objid AS occupancytype_group_objid,
   og.title AS occupancytype_group_title,   

   LTRIM(CONCAT(
      (CASE WHEN bp.location_unitno IS NULL THEN '' ELSE CONCAT(' ', bp.location_unitno) END),
      (CASE WHEN bp.location_bldgno IS NULL THEN '' ELSE CONCAT(' ', bp.location_bldgno) END),
      (CASE WHEN bp.location_bldgname IS NULL THEN '' ELSE CONCAT(' ', bp.location_bldgname) END),
      (CASE WHEN bp.location_lotno IS NULL THEN '' ELSE CONCAT( ' Lot.', bp.location_lotno) END),
      (CASE WHEN bp.location_blockno IS NULL THEN '' ELSE CONCAT(' Blk.', bp.location_blockno) END),
      (CASE WHEN bp.location_street IS NULL THEN '' ELSE CONCAT(' ', bp.location_street) END),
      (CASE WHEN bp.location_subdivision IS NULL THEN '' ELSE CONCAT(', ', bp.location_subdivision) END),      
      (CASE WHEN bp.location_barangay_name IS NULL THEN '' ELSE CONCAT(', ', bp.location_barangay_name ) END)
   )) AS location_text,

   t.state AS task_state,
   t.dtcreated AS task_dtcreated,
   t.startdate AS task_startdate,
   t.enddate AS task_enddate,
   t.assignee_objid AS task_assignee_objid,
   t.assignee_name AS task_assignee_name,
   t.actor_objid AS task_actor_objid,
   t.actor_name AS task_actor_name,
   sn.title AS task_title,
   sn.tracktime AS task_tracktime,
   sn.properties AS task_properties,
   pmt.objid AS controlid,
   pmt.controlno,
   pmt.expirydate,
   pmt.dtissued,
   pmt.issuedby_name,
   pmt.approverid,
   pmt.endorserid,
   pmt.template,
   pmt.reportheader 

FROM obo_app a 
INNER JOIN building_permit bp ON a.objid = bp.objid 
INNER JOIN building_permit_task t ON bp.taskid = t.taskid 
INNER JOIN obo_app_entity ae ON a.applicantid = ae.objid
INNER JOIN sys_wf_node sn ON sn.processname = 'building_permit' AND sn.name = t.state 
INNER JOIN obo_occupancy_type bt ON bp.occupancytypeid = bt.objid 
INNER JOIN obo_occupancy_type_division od ON bt.divisionid = od.objid 
INNER JOIN obo_occupancy_type_group og ON od.groupid = og.objid 
LEFT JOIN obo_control pmt ON pmt.appid=a.objid AND pmt.doctypeid = 'BUILDING_PERMIT';



if object_id('dbo.vw_occupancy_certificate', 'V') IS NOT NULL 
   DROP VIEW vw_occupancy_certificate; 
GO

CREATE VIEW vw_occupancy_certificate AS 
SELECT 
   a.*,
   op.taskid,
   op.bldgpermitid,
   op.totalmaterialcost,
   op.totaldirectlaborcost,
   op.totalequipmentcost,
   op.totalothercost,
   op.occupancytypeid,
   op.actualnumunits,
   op.actualtotalfloorarea,
   op.actualheight,
   op.actualnumfloors,
   op.dtactualstarted,
   op.dtactualcompleted,
   op.inspectiondate,
   op.supervisorid,
   op.contractor_name,
   op.contractor_address,
   op.contractor_pcab_idno,
   op.contractor_pcab_dtvalid,
   op.contractor_tin,
   op.contractor_manager_name,
   op.contractor_manager_email,
   op.actualfixedcost,
   op.actualprojectcost,
   op.occupancystate,
   op.amount,

   t.state AS task_state,
   t.startdate AS task_startdate,
   t.enddate AS task_enddate,
   t.assignee_objid AS task_assignee_objid,
   t.assignee_name AS task_assignee_name,
   t.actor_objid AS task_actor_objid,
   t.actor_name AS task_actor_name,
   sn.title AS task_title,
   sn.tracktime AS task_tracktime,
   sn.properties AS task_properties,
   ot.objid AS occupancytype_objid,
   ot.title AS occupancytype_title,   
   od.objid AS occupancytype_division_objid,
   od.title AS occupancytype_division_title,   
   og.objid AS occupancytype_group_objid,
   og.title AS occupancytype_group_title,
   ctl.controlno,
   ctl.expirydate,
   ctl.dtissued,
   ctl.issuedby_name,
   ctl.approverid,
   ctl.endorserid,
   ctl.template,
   ctl.reportheader,

   bp.title,
   bp.location_text,
   op.actualfixedcost AS fixedcost,
   op.actualprojectcost AS projectcost  

FROM obo_app a
INNER JOIN occupancy_certificate op ON  a.objid = op.objid 
INNER JOIN vw_building_permit bp ON op.bldgpermitid = bp.objid
INNER JOIN occupancy_certificate_task t ON op.taskid = t.taskid
INNER JOIN sys_wf_node sn ON (sn.processname = 'occupancy_certificate' AND sn.name = t.state)
INNER JOIN obo_occupancy_type ot ON op.occupancytypeid = ot.objid 
INNER JOIN obo_occupancy_type_division od ON ot.divisionid = od.objid 
INNER JOIN obo_occupancy_type_group og ON od.groupid = og.objid 
LEFT JOIN obo_control ctl ON ctl.appid=a.objid AND ctl.doctypeid = 'OCCUPANCY_CERTIFICATE' 
go 


insert into sys_wf_node (
   name, processname, title, nodetype, idx, 
   salience, domain, role, ui, properties, tracktime 
) 
SELECT 
   'assessment-approval' as name, n.processname, n.title, n.nodetype, n.idx, 
   n.salience, n.domain, n.role, n.ui, n.properties, n.tracktime 
FROM sys_wf_node n 
WHERE n.processname IN ('building_permit', 'occupancy_certificate' ) 
   AND n.name = 'approval'
;

update t set 
   t.parentid = 'assessment-approval' 
FROM sys_wf_node n 
   inner join sys_wf_transition t on (t.processname = n.processname and t.parentid = n.name) 
WHERE n.processname IN ('building_permit', 'occupancy_certificate' ) 
   AND n.name = 'approval'
;

delete from sys_wf_node where 
   processname IN ('building_permit', 'occupancy_certificate' ) 
   and name = 'approval' 
; 

update t set 
   t.[to] = 'assessment-approval'
from sys_wf_transition t 
WHERE t.processname IN ('building_permit', 'occupancy_certificate' ) 
   AND t.[to] = 'approval'
;


update bt set 
   bt.state = 'assessment-approval' 
from building_permit_task  bt 
where bt.state = 'approval'
;


insert into sys_wf_node (
   name, processname, title, nodetype, idx, 
   salience, domain, role, ui, properties, tracktime 
) 
select 
   'inspection-approval' as name, n.processname, n.title, n.nodetype, n.idx, 
   n.salience, n.domain, n.role, n.ui, n.properties, n.tracktime 
from sys_wf_node n 
where n.processname IN ('occupancy_certificate' ) 
   and n.name = 'verification'
;

update st set 
   st.parentid = 'inspection-approval'
from sys_wf_transition st
where st.processname IN ('occupancy_certificate' ) 
   AND st.parentid = 'verification'
;

delete from sys_wf_node where 
   processname IN ('occupancy_certificate' ) 
  and name = 'verification'
; 

UPDATE st SET 
   st.[to] = 'inspection-approval'
FROM sys_wf_transition st
WHERE st.processname IN ('occupancy_certificate' ) 
   AND st.[to] = 'verification'
;

UPDATE sn SET 
   sn.title = 'Inspection Approval', sn.role = 'APPROVER'
FROM sys_wf_node sn
WHERE sn.processname IN ('occupancy_certificate' ) 
   AND sn.name = 'inspection-approval'
;
