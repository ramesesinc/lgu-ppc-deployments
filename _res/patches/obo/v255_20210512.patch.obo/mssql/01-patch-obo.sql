#MIGRATION
USE obo_puerto_new;

INSERT INTO sys_sequence 
SELECT * FROM obo_puerto.dbo.sys_sequence s 
where s.objid not in (
	select objid from sys_sequence where objid = s.objid 
)
go 
INSERT INTO sys_user 
SELECT * FROM obo_puerto.dbo.sys_user u 
where u.objid not in (
	select objid from sys_user where objid = u.objid 
)
go 
INSERT INTO sys_user_role 
SELECT * FROM obo_puerto.dbo.sys_user_role r 
where r.objid not in (
	select objid from sys_user_role where objid = r.objid 
)
go 
INSERT INTO obo_professional_info 
SELECT * FROM obo_puerto.dbo.obo_professional_info p 
where p.objid not in (
	select objid from obo_professional_info  where objid = p.objid 
)
go 
INSERT INTO obo_professional 
SELECT * FROM obo_puerto.dbo.obo_professional p 
where p.objid not in (
	select objid from obo_professional  where objid = p.objid 
) 
go 


#start migration process
INSERT INTO obo_app 
(objid,doctypeid,appno,appdate,trackingno,contact_name,contact_detail,contact_email,contact_mobileno,txnmode,
	orgcode,createdby_objid,createdby_name,dtcreated)
SELECT 
objid,'BUILDING_PERMIT',appno,appdate,trackingno,contact_name,contact_detail,contact_email,contact_mobileno,txnmode,
orgcode,createdby_objid,createdby_name,dtcreated
FROM obo_puerto.dbo.building_permit p 
where objid not in (
	select objid from obo_app where objid = p.objid 
)
go 

INSERT INTO building_permit 
(objid,apptype,txntype,amount,description,title,occupancytypeid,numunits,fixedcost,projectcost,dtproposedconstruction,
dtexpectedcompletion,totalfloorarea,height,numfloors,worktypes,location_lotno,location_blockno,location_street,location_barangay_name,
location_barangay_objid,supervisorid,location_unitno,location_bldgno,location_bldgname,location_subdivision,location_lotarea)
SELECT 
objid,apptype,txntype,amount,description,title,occupancytypeid,numunits,fixedcost,projectcost,dtproposedconstruction,
dtexpectedcompletion,totalfloorarea,height,numfloors,worktypes,location_lotno,location_blockno,location_street,location_barangay_name,
location_barangay_objid,supervisorid,location_unitno,location_bldgno,location_bldgname,location_subdivision,location_lotarea
FROM obo_puerto.dbo.building_permit p 
where objid not in (
	select objid from building_permit where objid = p.objid 
)
go 

INSERT INTO building_permit_task
(taskid,refid,parentprocessid,state,startdate,enddate,assignee_objid,assignee_name,actor_objid,actor_name,message,dtcreated,prevtaskid)
SELECT 
taskid,refid,parentprocessid,state,startdate,enddate,assignee_objid,assignee_name,actor_objid,actor_name,message,dtcreated,prevtaskid
FROM obo_puerto.dbo.building_permit_task t 
where taskid not in (
	select taskid from building_permit_task where taskid = t.taskid 
) 
go 


INSERT INTO obo_app_entity
(
objid,appid,profileid,entitytype,profileno,name,firstname,middlename,lastname,resident,address_objid,address_text,address_unitno,address_bldgno,
address_bldgname,address_street,address_subdivision,address_barangay_objid,address_barangay_name,address_citymunicipality,address_province,
tin,email,mobileno,phoneno,id_type_name,id_idno,id_placeissued,id_dtissued
)
SELECT 
objid,appid,profileid,entitytype,profileno,name,firstname,middlename,lastname,resident,address_objid,address_text,address_unitno,address_bldgno,
address_bldgname,address_street,address_subdivision,address_barangay_objid,address_barangay_name,address_citymunicipality,address_province,
tin,email,mobileno,phoneno,id_type_name,id_idno,id_placeissued,id_dtissued
FROM obo_puerto.dbo.building_permit_entity e 
where objid not in (
	select objid from obo_app_entity where objid = e.objid 
)
go 

#update applicantid and taskid
UPDATE a set 
	a.applicantid = b.applicantid 
from obo_app a, obo_puerto.dbo.building_permit b 
WHERE a.objid = b.objid
go 

UPDATE b1 set 
	b1.taskid = b2.taskid 
from building_permit b1, obo_puerto.dbo.building_permit b2 
WHERE b1.objid = b2.objid
go 

#insert building_permit_rpu
INSERT INTO building_permit_rpu
( 
objid,appid,tdno,tctno,pin,barangay,titleno,lotno,blockno,areasqm,classcode,ownerid,street,refid,bill_amtdue,
lotowned,taxclearanceid,truecopycertid,taxclearancefee,truecopycertfee
)
SELECT 
objid,appid,tdno,tctno,pin,barangay,titleno,lotno,blockno,areasqm,classcode,ownerid,street,refid,bill_amtdue,
lotowned,taxclearanceid,truecopycertid,0,0
FROM obo_puerto.dbo.building_permit_rpu r 
where objid not in (
	select objid from building_permit_rpu where objid = r.objid 
)
go 

#insert docs. we'll have to insert ignore first since there are documents that cannot be added because they are in conflict
INSERT INTO obo_app_doc 
(objid,appid,state,doctypeid,worktypes,remarks,amount,projectcost,equipmentcost)
SELECT 
objid,appid,state,doctypeid,worktypes,remarks,amount,projectcost,equipmentcost
FROM obo_puerto.dbo.building_permit_doc d 
where objid not in (
	select objid from obo_app_doc where objid = d.objid 
)
go 


INSERT INTO obo_app_doc_info 
(objid,appid,parentid,name,stringvalue,decimalvalue,intvalue,datevalue,booleanvalue,remarks)
SELECT 
objid,appid,parentid,name,stringvalue,decimalvalue,intvalue,datevalue,booleanvalue,remarks
FROM obo_puerto.dbo.building_permit_info p 
where objid not in (
	select objid from obo_app_doc_info where objid = p.objid 
)
go 


INSERT INTO obo_app_doc_info 
(objid,appid,parentid,name,stringvalue,decimalvalue,intvalue,datevalue,booleanvalue,remarks)
SELECT 
objid,appid,parentid,name,stringvalue,decimalvalue,intvalue,datevalue,booleanvalue,remarks
FROM obo_puerto.dbo.building_permit_info p 
where objid not in (
	select objid from obo_app_doc_info where objid = p.objid 
)
go 


INSERT INTO obo_app_fee 
(objid,appid,parentid,itemid,amount,amtpaid,remarks)
SELECT 
objid,appid,parentid,itemid,amount,amtpaid,remarks
FROM obo_puerto.dbo.building_permit_fee p 
where objid not in (
	select objid from obo_app_fee  where objid = p.objid 
)
go 


INSERT INTO obo_payment 
( objid,appid,refno,refdate,refid,reftype,amount,voided )
SELECT  
objid,appid,refno,refdate,refid,reftype,amount,voided
FROM obo_puerto.dbo.building_permit_payment p 
where objid not in (
	select objid from obo_payment  where objid = p.objid 
)
go 


INSERT INTO obo_control
(objid,state,
doctypeid,controlno,dtissued,issuedby_objid,issuedby_name,expirydate,
remarks,template,endorserid,approverid,reportheader)
SELECT 
objid,state,
doctypeid,controlno,dtissued,issuedby_objid,issuedby_name,expirydate,
remarks,template,endorserid,approverid,reportheader
FROM obo_puerto.dbo.obo_control c 
where objid not in (
	select objid from obo_control where objid = c.objid 
)
go 


#insert building permit document
INSERT INTO obo_app_doc 
(objid,appid,state,doctypeid,amount,controlid) 
select * 
from ( 
	SELECT 
	CONCAT(objid,':BUILDING_PERMIT') AS objid, objid AS appid, 0 AS state, 'BUILDING_PERMIT' AS doctypeid, 0 AS amount,controlid
	FROM obo_puerto.dbo.building_permit 
)tmp1 
where (
	select count(*) from obo_app_doc 
	where appid = tmp1.appid and doctypeid = tmp1.doctypeid 
) = 0 
go 


INSERT INTO obo_app_doc 
(objid,appid,state,doctypeid,amount)
select * 
from ( 
	SELECT 
	CONCAT(objid,':BUILDING_RPT') AS objid,objid AS appid,0 AS state, 'BUILDING_RPT' AS doctypeid, 0 AS amount
	FROM obo_puerto.dbo.building_permit
)tmp1 
where (
	select count(*) from obo_app_doc 
	where appid = tmp1.appid and doctypeid = tmp1.doctypeid 
) = 0 
go 


#update the controlid of the obo_app_doc
UPDATE d1 set 
	d1.controlid = bd.controlid 
from obo_app_doc d1, obo_puerto.dbo.building_permit_doc bd 
WHERE d1.objid = bd.objid
go 


#correct the obo_control by updating the appid and doctypeid
UPDATE oc set 
	oc.appid = doc.appid, oc.docid=doc.objid 
from obo_control oc, obo_app_doc doc 
WHERE doc.controlid=oc.objid
go 

#fix the current task states
UPDATE  building_permit_task 
SET state = 'trade-verification' 
WHERE state='verification'
go 


INSERT INTO obo_app_requirement 
(objid,appid,parentid,typeid,state,remarks,reviewer_objid,reviewer_name,dtreviewed)
SELECT
objid,appid,parentid,typeid,state,remarks,reviewer_objid,reviewer_name,dtreviewed
FROM obo_puerto.dbo.building_permit_requirement r 
where objid not in (
	select objid from obo_app_requirement where objid = r.objid 
)
go 

UPDATE r1 set 
	r1.supersederid = r2.supersederid 
from obo_app_requirement r1, obo_puerto.dbo.building_permit_requirement r2 
WHERE r1.objid = r2.objid
go 


drop index uix_building_permit_transmittal_taskid on obo_app_transmittal
go 
create index ix_taskid on obo_app_transmittal (taskid) 
go 

INSERT INTO obo_app_transmittal 
( objid,appid,state,type,taskid,dtcreated,createdby_objid,createdby_name,approverid,endorserid,template,reportheader )
SELECT 
objid,appid,state,type,taskid,dtcreated,createdby_objid,createdby_name,approverid,endorserid,template,reportheader
FROM obo_puerto.dbo.building_permit_transmittal t 
WHERE type = 'requirement' 
	and objid not in (
		select objid from obo_app_transmittal where objid = t.objid 
	)
go 


UPDATE r1 set 
	r1.transmittalid = r2.transmittalid 
from obo_app_requirement r1, obo_puerto.dbo.building_permit_requirement r2 
WHERE r1.objid = r2.objid
go 


INSERT INTO obo_app_doc_checklist
(objid,	parentid,	typeid,	[values])	
SELECT 
objid,	
parentid,	
typeid,	
[values]
FROM obo_puerto.dbo.building_permit_checklist c 
where objid not in (
	select objid from obo_app_doc_checklist where objid = c.objid 
)
go 




#migrate the building evaluation,task and findings
INSERT INTO obo_app_taskitem 
(objid,appid,typeid)
select * 
from ( 
	SELECT 
		objid,appid,CONCAT('BUILDING:',typeid) AS typeid
	FROM obo_puerto.dbo.building_evaluation 
)tmp1 
where (
	select count(*) from obo_app_taskitem 
	where appid = tmp1.appid and typeid = tmp1.typeid 
) = 0 
go 


INSERT INTO obo_app_taskitem_task 
(taskid,refid,parentprocessid,state,startdate,enddate,assignee_objid,assignee_name,actor_objid,actor_name,message,dtcreated,prevtaskid)
SELECT 
taskid,refid,parentprocessid,state,startdate,enddate,assignee_objid,assignee_name,actor_objid,actor_name,message,dtcreated,prevtaskid
FROM obo_puerto.dbo.building_evaluation_task t 
where taskid not in (
	select taskid from obo_app_taskitem_task where taskid = t.taskid 
)
go

UPDATE t1 set 
	t1.taskid = t2.taskid 
from obo_app_taskitem t1, obo_puerto.dbo.building_evaluation t2 
WHERE t1.objid = t2.objid
go 

#findings 
INSERT INTO obo_app_taskitem_finding
(objid,appid,parentid,rootid,particulars,dtcreated,createdby_objid,createdby_name,state)
SELECT
objid,appid,parentid,rootid,particulars,dtcreated,createdby_objid,createdby_name,state
FROM obo_puerto.dbo.building_evaluation_finding f 
where objid not in (
	select objid from obo_app_taskitem_finding where objid = f.objid 
)
go 


INSERT INTO obo_app_transmittal 
( objid,appid,state,type,taskid,dtcreated,createdby_objid,createdby_name,approverid,endorserid,template,reportheader )
SELECT 
objid,appid,state,type,taskid,dtcreated,createdby_objid,createdby_name,approverid,endorserid,template,reportheader
FROM obo_puerto.dbo.building_permit_transmittal t 
WHERE type <> 'requirement' 
	and objid not in (
		select objid from obo_app_transmittal  where objid = t.objid 
	) 
go 


UPDATE r1 set 
 	r1.transmittalid = r2.transmittalid, r1.supersederid = r2.supersederid  
from obo_app_taskitem_finding r1, obo_puerto.dbo.building_evaluation_finding r2 
WHERE r1.objid = r2.objid
go 


#correct entries
#fix the current task states
UPDATE  building_permit_task 
SET state = 'trade-verification' WHERE state='verification'
go


UPDATE obo_app_taskitem_task 
SET state = 'end' WHERE state IN ('obo-processing', 'releasing' )
go 

#ADD PROFESSIONALS
INSERT INTO obo_app_professional
( objid, appid, sectionid, designprofessionalid, supervisorid, doctypeid )
select * 
from ( 
	SELECT 
		CONCAT(a.appid,':',doctypeid) AS objid, a.appid, NULL AS sectionid, 
		MAX(a.designprofessionalid) AS designprofessionalid, MAX(a.supervisorid) AS supervisorid, a.doctypeid  
	FROM (
		SELECT appid, doctypeid, designprofessionalid, NULL AS supervisorid 
		FROM obo_puerto.dbo.building_permit_doc 
		WHERE NOT( designprofessionalid IS NULL ) 
		UNION 
		SELECT appid, doctypeid, NULL AS designprofessionalid, supervisorid 
		FROM  obo_puerto.dbo.building_permit_doc 
		WHERE NOT( supervisorid IS NULL )
	) a 
	GROUP BY a.appid, a.doctypeid 
)tmp1 
where objid not in (
	select objid from obo_app_professional where objid = tmp1.objid 
) 
go 


#FIND THE sectionid per professional
UPDATE ap set 
	ap.sectionid = dt.sectionid 
from obo_app_professional ap, obo_doctype dt 
WHERE ap.doctypeid = dt.objid 
go 


## update views
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
bp.apptype AS apptype,
bp.taskid AS taskid,
bp.txntype AS txntype,
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



if object_id('dbo.vw_obo_app_doc', 'V') IS NOT NULL 
   drop view dbo.vw_obo_app_doc; 
go
CREATE VIEW vw_obo_app_doc AS select 
a.objid AS objid,
a.appid AS appid,
a.state AS state,
a.doctypeid AS doctypeid,
a.worktypes AS worktypes,
a.remarks AS remarks,
a.amount AS amount,
a.controlid AS controlid,
a.projectcost AS projectcost,
a.equipmentcost AS equipmentcost,
os.org_objid AS org_objid,
ba.task_state AS task_state,
ba.task_assignee_objid AS task_assignee_objid,
iss.controlno AS controlno,
iss.dtissued AS dtissued,
iss.expirydate AS expirydate,
iss.issuedby_name AS issuedby_name,
iss.issuedby_objid AS issuedby_objid,
iss.template AS template,
iss.endorserid AS endorserid,
iss.approverid AS approverid,
od.sectionid AS sectionid 
from obo_app_doc a 
	inner join vw_obo_app ba on a.appid = ba.objid
	inner join obo_doctype od on a.doctypeid = od.objid
	left join obo_section os on od.sectionid = os.objid
	left join obo_control iss on a.controlid = iss.objid
go 



if object_id('dbo.vw_obo_app_doc_info', 'V') IS NOT NULL 
   drop view dbo.vw_obo_app_doc_info; 
go
CREATE VIEW vw_obo_app_doc_info AS select 
ai.objid AS objid,
ai.appid AS appid,
ai.parentid AS parentid,
ai.name AS name,
ai.stringvalue AS stringvalue,
ai.decimalvalue AS decimalvalue,
ai.intvalue AS intvalue,
ai.datevalue AS datevalue,
ai.booleanvalue AS booleanvalue,
ai.remarks AS remarks,
ai.lookupkey AS lookupkey,
ai.lookupvalue AS lookupvalue,
ov.datatype AS datatype,
ov.doctypeid AS doctypeid,
ov.unit AS unit,
ov.caption AS caption,
ov.category AS category,
ov.sortorder AS sortorder,
ov.lookuplistname AS lookuplistname,
ov.arrayvalues AS arrayvalues,
ov.multiselect AS multiselect 
from obo_app_doc_info ai 
	inner join obo_variable ov on ov.objid = ai.name
go 




if object_id('dbo.vw_obo_app_taskitem', 'V') IS NOT NULL 
   drop view dbo.vw_obo_app_taskitem; 
go
CREATE VIEW vw_obo_app_taskitem AS select 
a.objid AS objid,
a.appid AS appid,
a.typeid AS typeid,
a.taskid AS taskid,
os.objid AS sectionid,
os.org_objid AS org_objid,
et.title AS type_title,
et.sortindex AS type_sortindex,
et.joinstate AS type_joinstate,
app.task_state AS app_task_state,
t.state AS task_state,
t.dtcreated AS task_dtcreated,
t.startdate AS task_startdate,
t.enddate AS task_enddate,
t.assignee_objid AS task_assignee_objid,
t.assignee_name AS task_assignee_name,
t.actor_objid AS task_actor_objid,
t.actor_name AS task_actor_name,
sn.title AS task_title,
sn.tracktime AS task_tracktime 
from obo_app_taskitem a 
	inner join obo_app_taskitem_task t on a.taskid = t.taskid
	inner join obo_taskitem_type et on a.typeid = et.objid
	inner join sys_wf_node sn on (sn.processname = 'obo_app_taskitem' and sn.name = t.state) 
	inner join vw_obo_app app on a.appid = app.objid
	left join obo_section os on et.sectionid = os.objid
go 



if object_id('dbo.vw_obo_doctype', 'V') IS NOT NULL 
   drop view dbo.vw_obo_doctype; 
go
CREATE VIEW vw_obo_doctype AS select 
od.objid AS objid,
od.title AS title,
od.sectionid AS sectionid,
od.sortorder AS sortorder,
od.type AS type,
od.template AS template,
od.autocreate AS autocreate,
od.issuetype AS issuetype,
od.requirefee AS requirefee,
od.appnopattern AS appnopattern,
od.controlnopattern AS controlnopattern,
od.subtypeof AS subtypeof,
od.apptype AS apptype,
od.system AS system,
od.role AS role,
od.endorserid AS endorserid,
od.approverid AS approverid,
od.reportheader AS reportheader,
od.refdoc AS refdoc,
od.includeinemail AS includeinemail,
os.org_objid AS org_objid,
os.org_name AS org_name 
from obo_doctype od 
	left join obo_section os on od.sectionid = os.objid
go 



if object_id('dbo.vw_obo_occupancy_type', 'V') IS NOT NULL 
   drop view dbo.vw_obo_occupancy_type; 
go
CREATE VIEW vw_obo_occupancy_type AS select 
ot.objid AS objid,
ot.divisionid AS divisionid,
ot.title AS title,
od.objid AS division_objid,
od.title AS division_title,
og.objid AS group_objid,
og.title AS group_title 
from obo_occupancy_type ot 
	inner join obo_occupancy_type_division od on ot.divisionid = od.objid 
	inner join obo_occupancy_type_group og on od.groupid = og.objid 
go 




if object_id('dbo.vw_obo_payment', 'V') IS NOT NULL 
   drop view dbo.vw_obo_payment; 
go
CREATE VIEW vw_obo_payment AS select 
bf.objid AS objid,
bf.appid AS appid,
bf.parentid AS parentid,
bf.itemid AS itemid,
bf.amount AS amount,
bf.amtpaid AS amtpaid,
bf.remarks AS remarks,
oi.objid AS item_objid,
oi.title AS item_title,
oi.sortorder AS item_sortorder,
pt.reftype AS payment_type,
pt.refno AS payment_refno,
pt.refid AS payment_refid,
pt.refdate AS payment_refdate 
from obo_app_fee bf 
	inner join obo_itemaccount oi on bf.itemid = oi.objid
	left join obo_payment pt on bf.appid = pt.appid
where (pt.voided is null or pt.voided = 0)
go 



if object_id('dbo.vw_obo_professional', 'V') IS NOT NULL 
   drop view dbo.vw_obo_professional; 
go
CREATE VIEW vw_obo_professional AS select 
pi.objid AS objid, 
pi.firstname AS firstname, 
pi.middlename AS middlename, 
pi.lastname AS lastname, 
pi.resident AS resident, 
pi.address_objid AS address_objid, 
pi.address_text AS address_text, 
pi.address_unitno AS address_unitno, 
pi.address_bldgno AS address_bldgno, 
pi.address_bldgname AS address_bldgname, 
pi.address_street AS address_street, 
pi.address_subdivision AS address_subdivision, 
pi.address_barangay_objid AS address_barangay_objid, 
pi.address_barangay_name AS address_barangay_name, 
pi.address_citymunicipality AS address_citymunicipality, 
pi.address_province AS address_province, 
pi.tin AS tin, 
pi.email AS email, 
pi.mobileno AS mobileno, 
pi.phoneno AS phoneno, 
pi.id_idno AS id_idno, 
pi.id_type_name AS id_type_name, 
pi.id_dtissued AS id_dtissued, 
pi.id_placeissued AS id_placeissued, 
pi.profession AS profession, 
pi.prc_idno AS prc_idno, 
pi.prc_dtissued AS prc_dtissued, 
pi.prc_dtvalid AS prc_dtvalid, 
pi.prc_placeissued AS prc_placeissued, 
pi.ptr_refno AS ptr_refno, 
pi.ptr_dtissued AS ptr_dtissued, 
pi.ptr_placeissued AS ptr_placeissued, 
pi.profid AS profid, 
pi.system AS system, 
concat(pi.lastname,', ',pi.firstname,' ',substring(pi.middlename,0,1),'.') AS name,
id.caption AS id_type_caption, 
id.title AS id_type_title  
from obo_professional p 
	inner join obo_professional_info pi on p.infoid = pi.objid  
	left join idtype id on pi.id_type_name = id.name 
go 



if object_id('dbo.vw_obo_professional_info', 'V') IS NOT NULL 
   drop view dbo.vw_obo_professional_info; 
go
CREATE VIEW vw_obo_professional_info AS select 
pi.objid AS objid,
pi.firstname AS firstname,
pi.middlename AS middlename,
pi.lastname AS lastname,
pi.resident AS resident,
pi.address_objid AS address_objid,
pi.address_text AS address_text,
pi.address_unitno AS address_unitno,
pi.address_bldgno AS address_bldgno,
pi.address_bldgname AS address_bldgname,
pi.address_street AS address_street,
pi.address_subdivision AS address_subdivision,
pi.address_barangay_objid AS address_barangay_objid,
pi.address_barangay_name AS address_barangay_name,
pi.address_citymunicipality AS address_citymunicipality,
pi.address_province AS address_province,
pi.tin AS tin,
pi.email AS email,
pi.mobileno AS mobileno,
pi.phoneno AS phoneno,
pi.id_idno AS id_idno,
pi.id_type_name AS id_type_name,
pi.id_dtissued AS id_dtissued,
pi.id_placeissued AS id_placeissued,
pi.profession AS profession,
pi.prc_idno AS prc_idno,
pi.prc_dtissued AS prc_dtissued,
pi.prc_dtvalid AS prc_dtvalid,
pi.prc_placeissued AS prc_placeissued,
pi.ptr_refno AS ptr_refno,
pi.ptr_dtissued AS ptr_dtissued,
pi.ptr_placeissued AS ptr_placeissued,
pi.profid AS profid,
pi.system AS system,
concat(pi.lastname,', ',pi.firstname,' ',substring(pi.middlename,0,1),'.') AS name,
id.caption AS id_type_caption,
id.title AS id_type_title
 from obo_professional_info pi 
 	left join idtype id on pi.id_type_name = id.name
 go 



if object_id('dbo.vw_obo_professional_info_lookup', 'V') IS NOT NULL 
   drop view dbo.vw_obo_professional_info_lookup; 
go
CREATE VIEW vw_obo_professional_info_lookup AS select 
pi.objid AS objid, 
pi.firstname AS firstname, 
pi.middlename AS middlename, 
pi.lastname AS lastname, 
pi.resident AS resident, 
pi.address_objid AS address_objid, 
pi.address_text AS address_text, 
pi.address_unitno AS address_unitno, 
pi.address_bldgno AS address_bldgno, 
pi.address_bldgname AS address_bldgname, 
pi.address_street AS address_street, 
pi.address_subdivision AS address_subdivision, 
pi.address_barangay_objid AS address_barangay_objid, 
pi.address_barangay_name AS address_barangay_name, 
pi.address_citymunicipality AS address_citymunicipality, 
pi.address_province AS address_province, 
pi.tin AS tin, 
pi.email AS email, 
pi.mobileno AS mobileno, 
pi.phoneno AS phoneno, 
pi.id_idno AS id_idno, 
pi.id_type_name AS id_type_name, 
pi.id_dtissued AS id_dtissued, 
pi.id_placeissued AS id_placeissued, 
pi.profession AS profession, 
pi.prc_idno AS prc_idno, 
pi.prc_dtissued AS prc_dtissued, 
pi.prc_dtvalid AS prc_dtvalid, 
pi.prc_placeissued AS prc_placeissued, 
pi.ptr_refno AS ptr_refno, 
pi.ptr_dtissued AS ptr_dtissued, 
pi.ptr_placeissued AS ptr_placeissued, 
pi.profid AS profid, 
pi.system AS system, 
concat(pi.lastname,', ',pi.firstname,' ',substring(pi.middlename,0,1),'.') AS name,
id.caption AS id_type_caption, 
id.title AS id_type_title  
from obo_professional_info pi 
	inner join obo_professional p on p.infoid = pi.objid 
	left join idtype id on pi.id_type_name = id.name 
union all 
select 
pi.objid AS objid, 
pi.firstname AS firstname, 
pi.middlename AS middlename, 
pi.lastname AS lastname, 
pi.resident AS resident, 
pi.address_objid AS address_objid, 
pi.address_text AS address_text, 
pi.address_unitno AS address_unitno, 
pi.address_bldgno AS address_bldgno, 
pi.address_bldgname AS address_bldgname, 
pi.address_street AS address_street, 
pi.address_subdivision AS address_subdivision, 
pi.address_barangay_objid AS address_barangay_objid, 
pi.address_barangay_name AS address_barangay_name, 
pi.address_citymunicipality AS address_citymunicipality, 
pi.address_province AS address_province, 
pi.tin AS tin, 
pi.email AS email, 
pi.mobileno AS mobileno, 
pi.phoneno AS phoneno, 
pi.id_idno AS id_idno, 
pi.id_type_name AS id_type_name, 
pi.id_dtissued AS id_dtissued, 
pi.id_placeissued AS id_placeissued, 
pi.profession AS profession, 
pi.prc_idno AS prc_idno, 
pi.prc_dtissued AS prc_dtissued, 
pi.prc_dtvalid AS prc_dtvalid, 
pi.prc_placeissued AS prc_placeissued, 
pi.ptr_refno AS ptr_refno, 
pi.ptr_dtissued AS ptr_dtissued, 
pi.ptr_placeissued AS ptr_placeissued, 
pi.profid AS profid, 
pi.system AS system, 
concat(pi.lastname,', ',pi.firstname,' ',substring(pi.middlename,0,1),'.') AS name,
id.caption AS id_type_caption, 
id.title AS id_type_title  
from obo_professional_info pi 
	left join idtype id on pi.id_type_name = id.name 
where pi.prc_idno not in (select obo_professional.prcno from obo_professional)
go 



if object_id('dbo.vw_obo_taskitem_consolidated', 'V') IS NOT NULL 
   drop view dbo.vw_obo_taskitem_consolidated; 
go
CREATE VIEW vw_obo_taskitem_consolidated AS select 
be.objid AS objid,
be.appid AS appid,
be.typeid AS typeid,
bt.title AS type_title,
bt.sortindex AS sortindex,
betr.role AS role,
os.org_objid AS org_objid 
from obo_app_taskitem be 
	inner join obo_taskitem_type bt on be.typeid = bt.objid  
	left join obo_section os on bt.sectionid = os.objid  
	inner join obo_taskitem_type_role betr on betr.typeid = bt.objid  
union all 
select 
be.objid AS objid,
be.appid AS appid,
be.typeid AS typeid,
bt.title AS type_title,
bt.sortindex AS sortindex,
wn.role AS role,
os.org_objid AS org_objid 
from obo_app_taskitem be 
	inner join obo_taskitem_type bt on be.typeid = bt.objid  
	inner join sys_wf_node wn on (wn.processname = 'obo_app_taskitem' and wn.tracktime = 1) 
	left join obo_section os on bt.sectionid = os.objid  
where wn.name not in (
	select obo_taskitem_type_role.state from obo_taskitem_type_role 
	where obo_taskitem_type_role.typeid = be.typeid 
)
go 



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

