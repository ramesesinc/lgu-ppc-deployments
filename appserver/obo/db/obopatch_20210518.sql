ALTER TABLE `obo_app` 
ADD COLUMN `apptype` varchar(50) NULL,
ADD COLUMN `txntype` varchar(50) NULL;

UPDATE obo_app a, building_permit bp
SET a.apptype = bp.apptype, a.txntype = bp.txntype 
WHERE a.objid = bp.objid;

UPDATE obo_app a, occupancy_certificate oc
SET a.apptype = oc.apptype, a.txntype = oc.txntype 
WHERE a.objid = oc.objid;


ALTER TABLE `building_permit` 
DROP COLUMN `apptype`,
DROP COLUMN `txntype` ;

ALTER TABLE `occupancy_certificate` 
DROP COLUMN `apptype`,
DROP COLUMN `txntype` ;


if object_id('dbo.vw_obo_app', 'V') IS NOT NULL 
   drop view dbo.vw_obo_app; 
go
CREATE VIEW vw_obo_app AS select 
app.objid AS objid,
app.doctypeid AS doctypeid,
app.appno AS appno,
app.appdate AS appdate,
app.trackingno AS trackingno,
app.applicantid AS applicantid,
app.contact_name AS contact_name,
app.contact_detail AS contact_detail,
app.contact_email AS contact_email,
app.contact_mobileno AS contact_mobileno,
app.contact_phoneno AS contact_phoneno,
app.txnmode AS txnmode,
app.orgcode AS orgcode,
app.createdby_objid AS createdby_objid,
app.createdby_name AS createdby_name,
app.dtcreated AS dtcreated,
'building_permit' AS appclass,bp.title AS title,
ltrim(concat(
   (case when bp.location_unitno is null then '' else concat(' ',bp.location_unitno) end),
   (case when bp.location_bldgno is null then '' else concat(' ',bp.location_bldgno) end),
   (case when bp.location_bldgname is null then '' else concat(' ',bp.location_bldgname) end),
   (case when bp.location_lotno is null then '' else concat(' Lot.',bp.location_lotno) end),
   (case when bp.location_blockno is null then '' else concat(' Blk.',bp.location_blockno) end),
   (case when bp.location_street is null then '' else concat(' ',bp.location_street) end),
   (case when bp.location_subdivision is null then '' else concat(', ',bp.location_subdivision) end),
   (case when bp.location_barangay_name is null then '' else concat(', ',bp.location_barangay_name) end)
)) AS location_text,
be.name AS applicant_name,
be.address_text AS applicant_address_text,
be.profileid AS applicant_profileid,
bt.state AS task_state,
bt.assignee_objid AS task_assignee_objid,
'building_permit' AS processname,
'BUILDING PERMIT' AS doctitle,
'vw_building_permit' AS schemaname
from obo_app app 
   inner join building_permit bp on app.objid = bp.objid 
   inner join obo_app_entity be on app.applicantid = be.objid 
   inner join building_permit_task bt on bp.taskid = bt.taskid 
union 
select 
app.objid AS objid,
app.doctypeid AS doctypeid,
app.appno AS appno,
app.appdate AS appdate,
app.trackingno AS trackingno,
app.applicantid AS applicantid,
app.contact_name AS contact_name,
app.contact_detail AS contact_detail,
app.contact_email AS contact_email,
app.contact_mobileno AS contact_mobileno,
app.contact_phoneno AS contact_phoneno,
app.txnmode AS txnmode,
app.orgcode AS orgcode,
app.createdby_objid AS createdby_objid,
app.createdby_name AS createdby_name,
app.dtcreated AS dtcreated,
'occupancy_certificate' AS appclass,bp.title AS title,
ltrim(concat(
   (case when bp.location_unitno is null then '' else concat(' ',bp.location_unitno) end),
   (case when bp.location_bldgno is null then '' else concat(' ',bp.location_bldgno) end),
   (case when bp.location_bldgname is null then '' else concat(' ',bp.location_bldgname) end),
   (case when bp.location_lotno is null then '' else concat(' Lot.',bp.location_lotno) end),
   (case when bp.location_blockno is null then '' else concat(' Blk.',bp.location_blockno) end),
   (case when bp.location_street is null then '' else concat(' ',bp.location_street) end),
   (case when bp.location_subdivision is null then '' else concat(', ',bp.location_subdivision) end),
   (case when bp.location_barangay_name is null then '' else concat(', ',bp.location_barangay_name) end)
)) AS location_text,
be.name AS applicant_name,
be.address_text AS applicant_address_text,
be.profileid AS applicant_profileid,
bt.state AS task_state,
bt.assignee_objid AS task_assignee_objid,
'occupancy_certificate' AS processname,
'OCCUPANCY CERTIFICATE' AS doctitle,
'vw_occupancy_certificate' AS schemaname
from obo_app app 
   inner join occupancy_certificate oc on oc.objid = app.objid
   inner join building_permit bp on oc.bldgpermitid = bp.objid
   inner join obo_app_entity be on app.applicantid = be.objid
   inner join occupancy_certificate_task bt on oc.taskid = bt.taskid
go 

if object_id('dbo.vw_building_permit', 'V') IS NOT NULL 
   drop view dbo.vw_building_permit; 
go
CREATE VIEW vw_building_permit AS select 
a.objid AS objid,
a.doctypeid AS doctypeid,
a.appno AS appno,
a.appdate AS appdate,
a.trackingno AS trackingno,
a.applicantid AS applicantid,
a.contact_name AS contact_name,
a.contact_detail AS contact_detail,
a.contact_email AS contact_email,
a.contact_mobileno AS contact_mobileno,
a.contact_phoneno AS contact_phoneno,
a.txnmode AS txnmode,
a.orgcode AS orgcode,
a.createdby_objid AS createdby_objid,
a.createdby_name AS createdby_name,
a.dtcreated AS dtcreated,
a.apptype AS apptype,
a.txntype AS txntype,
bp.taskid AS taskid,
bp.amount AS amount,
bp.description AS description,
bp.title AS title,
bp.occupancytypeid AS occupancytypeid,
bp.numunits AS numunits,
bp.fixedcost AS fixedcost,
bp.projectcost AS projectcost,
bp.dtproposedconstruction AS dtproposedconstruction,
bp.dtexpectedcompletion AS dtexpectedcompletion,
bp.totalfloorarea AS totalfloorarea,
bp.height AS height,
bp.numfloors AS numfloors,
bp.worktypes AS worktypes,
bp.location_lotno AS location_lotno,
bp.location_blockno AS location_blockno,
bp.location_street AS location_street,
bp.location_barangay_name AS location_barangay_name,
bp.location_barangay_objid AS location_barangay_objid,
bp.supervisorid AS supervisorid,
bp.location_unitno AS location_unitno,
bp.location_bldgno AS location_bldgno,
bp.location_bldgname AS location_bldgname,
bp.location_subdivision AS location_subdivision,
bp.location_lotarea AS location_lotarea,
ae.name AS applicant_name,
bt.objid AS occupancytype_objid,
bt.title AS occupancytype_title,
od.objid AS occupancytype_division_objid,
od.title AS occupancytype_division_title,
og.objid AS occupancytype_group_objid,
og.title AS occupancytype_group_title,
ltrim(concat(
   (case when bp.location_unitno is null then '' else concat(' ',bp.location_unitno) end),
   (case when bp.location_bldgno is null then '' else concat(' ',bp.location_bldgno) end),
   (case when bp.location_bldgname is null then '' else concat(' ',bp.location_bldgname) end),
   (case when bp.location_lotno is null then '' else concat(' Lot.',bp.location_lotno) end),
   (case when bp.location_blockno is null then '' else concat(' Blk.',bp.location_blockno) end),
   (case when bp.location_street is null then '' else concat(' ',bp.location_street) end),
   (case when bp.location_subdivision is null then '' else concat(', ',bp.location_subdivision) end),
   (case when bp.location_barangay_name is null then '' else concat(', ',bp.location_barangay_name) end)
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
pmt.objid AS controlid,
pmt.controlno AS controlno,
pmt.expirydate AS expirydate,
pmt.dtissued AS dtissued,
pmt.issuedby_name AS issuedby_name,
pmt.approverid AS approverid,
pmt.endorserid AS endorserid,
pmt.template AS template,
pmt.reportheader AS reportheader 
from obo_app a 
   inner join building_permit bp on a.objid = bp.objid
   inner join building_permit_task t on bp.taskid = t.taskid 
   inner join obo_app_entity ae on a.applicantid = ae.objid
   inner join sys_wf_node sn on (sn.processname = 'building_permit' and sn.name = t.state) 
   inner join obo_occupancy_type bt on bp.occupancytypeid = bt.objid 
   inner join obo_occupancy_type_division od on bt.divisionid = od.objid 
   inner join obo_occupancy_type_group og on od.groupid = og.objid
   left join obo_control pmt on (pmt.appid = a.objid and pmt.doctypeid = 'BUILDING_PERMIT')
go 

if object_id('dbo.vw_occupancy_certificate', 'V') IS NOT NULL 
   drop view dbo.vw_occupancy_certificate; 
go
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
   (SELECT title FROM sys_wf_node WHERE processname = 'occupancy_certificate' AND name=t.state) AS task_title,
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
INNER JOIN obo_occupancy_type ot ON op.occupancytypeid = ot.objid 
INNER JOIN obo_occupancy_type_division od ON ot.divisionid = od.objid 
INNER JOIN obo_occupancy_type_group og ON od.groupid = og.objid 
LEFT JOIN obo_control ctl ON ctl.appid=a.objid AND ctl.doctypeid = 'OCCUPANCY_CERTIFICATE' 
go 


