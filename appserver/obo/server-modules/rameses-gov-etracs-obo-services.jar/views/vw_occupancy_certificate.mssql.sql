if object_id('dbo.vw_occupancy_certificate', 'V') IS NOT NULL 
   drop view dbo.vw_occupancy_certificate; 
go
CREATE VIEW vw_occupancy_certificate AS select 
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
op.apptype AS apptype,
op.txntype AS txntype,
op.taskid AS taskid,
op.bldgpermitid AS bldgpermitid,
op.totalmaterialcost AS totalmaterialcost,
op.totaldirectlaborcost AS totaldirectlaborcost,
op.totalequipmentcost AS totalequipmentcost,
op.totalothercost AS totalothercost,
op.occupancytypeid AS occupancytypeid,
op.actualnumunits AS actualnumunits,
op.actualtotalfloorarea AS actualtotalfloorarea,
op.actualheight AS actualheight,
op.actualnumfloors AS actualnumfloors,
op.dtactualstarted AS dtactualstarted,
op.dtactualcompleted AS dtactualcompleted,
op.inspectiondate AS inspectiondate,
op.supervisorid AS supervisorid,
op.contractor_name AS contractor_name,
op.contractor_address AS contractor_address,
op.contractor_pcab_idno AS contractor_pcab_idno,
op.contractor_pcab_dtvalid AS contractor_pcab_dtvalid,
op.contractor_tin AS contractor_tin,
op.contractor_manager_name AS contractor_manager_name,
op.contractor_manager_email AS contractor_manager_email,
op.actualfixedcost AS actualfixedcost,
op.actualprojectcost AS actualprojectcost,
op.occupancystate AS occupancystate,
op.amount AS amount,
t.state AS task_state,
t.startdate AS task_startdate,
t.enddate AS task_enddate,
t.assignee_objid AS task_assignee_objid,
t.assignee_name AS task_assignee_name,
t.actor_objid AS task_actor_objid,
t.actor_name AS task_actor_name,
(
	select sys_wf_node.title from sys_wf_node 
	where sys_wf_node.processname = 'occupancy_certificate' 
		and sys_wf_node.name = t.state
) AS task_title, 
ot.objid AS occupancytype_objid,
ot.title AS occupancytype_title,
od.objid AS occupancytype_division_objid,
od.title AS occupancytype_division_title,
og.objid AS occupancytype_group_objid,
og.title AS occupancytype_group_title,
ctl.controlno AS controlno,
ctl.expirydate AS expirydate,
ctl.dtissued AS dtissued,
ctl.issuedby_name AS issuedby_name,
ctl.approverid AS approverid,
ctl.endorserid AS endorserid,
ctl.template AS template,
ctl.reportheader AS reportheader,
bp.title AS title,
bp.location_text AS location_text 
from obo_app a 
	inner join occupancy_certificate op on a.objid = op.objid  
	inner join vw_building_permit bp on op.bldgpermitid = bp.objid  
	inner join occupancy_certificate_task t on op.taskid = t.taskid  
	inner join obo_occupancy_type ot on op.occupancytypeid = ot.objid  
	inner join obo_occupancy_type_division od on ot.divisionid = od.objid  
	inner join obo_occupancy_type_group og on od.groupid = og.objid  
	left join obo_control ctl on (ctl.appid = a.objid and ctl.doctypeid = 'OCCUPANCY_CERTIFICATE')
go 