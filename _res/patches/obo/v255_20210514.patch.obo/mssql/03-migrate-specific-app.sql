-- ## migrate application BPAPP-202104-00002 

INSERT INTO obo_app 
(objid,doctypeid,appno,appdate,trackingno,contact_name,contact_detail,contact_email,contact_mobileno,txnmode,
	orgcode,createdby_objid,createdby_name,dtcreated)
SELECT 
objid,'BUILDING_PERMIT',appno,appdate,trackingno,contact_name,contact_detail,contact_email,contact_mobileno,txnmode,
orgcode,createdby_objid,createdby_name,dtcreated
FROM obo.dbo.building_permit p 
where objid = 'BAPP-28209981:178d7ff9f29:-7df2' 
	and objid not in (
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
FROM obo.dbo.building_permit p 
where objid = 'BAPP-28209981:178d7ff9f29:-7df2' 
	and objid not in (
		select objid from building_permit where objid = p.objid 
	)
go 

INSERT INTO building_permit_task
(taskid,refid,parentprocessid,state,startdate,enddate,assignee_objid,assignee_name,actor_objid,actor_name,message,dtcreated,prevtaskid)
SELECT 
taskid,refid,parentprocessid,state,startdate,enddate,assignee_objid,assignee_name,actor_objid,actor_name,message,dtcreated,prevtaskid
FROM obo.dbo.building_permit_task t 
where refid = 'BAPP-28209981:178d7ff9f29:-7df2' 
	and taskid not in (
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
FROM obo.dbo.building_permit_entity e 
where appid = 'BAPP-28209981:178d7ff9f29:-7df2'  
	and objid not in (
		select objid from obo_app_entity where objid = e.objid 
	)
go 

-- update applicantid and taskid
UPDATE a set 
	a.applicantid = b.applicantid 
from obo_app a, obo.dbo.building_permit b 
WHERE a.objid = b.objid 
	and a.objid = 'BAPP-28209981:178d7ff9f29:-7df2'  
go 

UPDATE b1 set 
	b1.taskid = b2.taskid 
from building_permit b1, obo.dbo.building_permit b2 
WHERE b1.objid = b2.objid 
	and b1.objid = 'BAPP-28209981:178d7ff9f29:-7df2'  
go 

-- insert building_permit_rpu
INSERT INTO building_permit_rpu
( 
objid,appid,tdno,tctno,pin,barangay,titleno,lotno,blockno,areasqm,classcode,ownerid,street,refid,bill_amtdue,
lotowned,taxclearanceid,truecopycertid,taxclearancefee,truecopycertfee
)
SELECT 
objid,appid,tdno,tctno,pin,barangay,titleno,lotno,blockno,areasqm,classcode,ownerid,street,refid,bill_amtdue,
lotowned,taxclearanceid,truecopycertid,0,0
FROM obo.dbo.building_permit_rpu r 
where appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
	and objid not in (
		select objid from building_permit_rpu where objid = r.objid 
	)
go 

INSERT INTO [dbo].[obo_doctype] ([objid], [title], [sectionid], [sortorder], [type], [template], [autocreate], [issuetype], [requirefee], [appnopattern], [controlnopattern], [subtypeof], [apptype], [system], [role], [endorserid], [approverid], [reportheader], [refdoc], [includeinemail]) 
VALUES ('BFP_FIRE_SAFETY_CLEARANCE', 'BFP ELECTRICAL CLEARANCE', 'BFP', NULL, 'CLEARANCE', 'reports/bfp/fsce', '0', '3', '1', NULL, 'FSCECNO.R4B-[YYYYmm]-[%05d]', NULL, 'building', NULL, 'BFP_RELEASER', '8f07087:1765ef572b8:-7ffc', 'USR4ac8bf36:17645fd926a:-7c04', NULL, NULL, '1');


-- insert docs. we'll have to insert ignore first since there are documents that cannot be added because they are in conflict
select objid, appid, state, doctypeid, worktypes, remarks, amount, projectcost, equipmentcost
into ztmp_obo_app_doc
from obo.dbo.building_permit_doc d 
where appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
	and objid not in (
		select objid from obo_app_doc where objid = d.objid 
	)
order by appid,doctypeid
go 

INSERT INTO obo_app_doc (
	objid, appid, state, doctypeid, worktypes, remarks, amount, projectcost, equipmentcost
)
select 
	z.objid, z.appid, z.state, z.doctypeid, z.worktypes, z.remarks, z.amount, z.projectcost, z.equipmentcost
from ( 
	select appid,doctypeid,count(*) as icount 
	from ztmp_obo_app_doc
	group by appid,doctypeid 
	having count(*) = 1
)tmp1, ztmp_obo_app_doc z 
where z.appid = tmp1.appid 
	and z.doctypeid = tmp1.doctypeid 
	and z.objid not in (
		select objid from obo_app_doc where objid = z.objid 
	) 
go 

insert into obo_app_doc (
	objid, appid, state, doctypeid, worktypes, remarks, amount, projectcost, equipmentcost
)
select 
	z.objid, z.appid, z.state, z.doctypeid, z.worktypes, z.remarks, z.amount, z.projectcost, z.equipmentcost
from ( 
	select z.objid, 
		(select count(*) from obo.dbo.building_permit_info where appid = z.appid and parentid = z.objid) as infocount, 
		(select count(*) from obo.dbo.building_permit_fee where appid = z.appid and parentid = z.objid) as feecount 
	from ( 
		select appid,doctypeid,count(*) as icount 
		from ztmp_obo_app_doc
		group by appid,doctypeid 
		having count(*) > 1 
	)tmp1, ztmp_obo_app_doc z 
	where z.appid = tmp1.appid 
		and z.doctypeid = tmp1.doctypeid 
)tmp2, ztmp_obo_app_doc z 
where z.objid = tmp2.objid 
	and (tmp2.infocount + tmp2.feecount) > 0 
	and z.objid not in (
		select objid from obo_app_doc where objid = z.objid 
	) 
go 

drop table ztmp_obo_app_doc
go 


INSERT INTO obo_app_doc_info 
(objid,appid,parentid,name,stringvalue,decimalvalue,intvalue,datevalue,booleanvalue,remarks)
SELECT 
objid,appid,parentid,name,stringvalue,decimalvalue,intvalue,datevalue,booleanvalue,remarks
FROM obo.dbo.building_permit_info p 
where appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
	and objid not in (
		select objid from obo_app_doc_info where objid = p.objid 
	)
go 


INSERT INTO obo_app_doc_info 
(objid,appid,parentid,name,stringvalue,decimalvalue,intvalue,datevalue,booleanvalue,remarks)
SELECT 
objid,appid,parentid,name,stringvalue,decimalvalue,intvalue,datevalue,booleanvalue,remarks
FROM obo.dbo.building_permit_info p 
where appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
	and objid not in (
		select objid from obo_app_doc_info where objid = p.objid 
	)
go 


INSERT INTO obo_app_fee 
(objid,appid,parentid,itemid,amount,amtpaid,remarks)
SELECT 
objid,appid,parentid,itemid,amount,amtpaid,remarks
FROM obo.dbo.building_permit_fee p 
where appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
	and objid not in (
		select objid from obo_app_fee  where objid = p.objid 
	)
go 


INSERT INTO obo_payment 
( objid,appid,refno,refdate,refid,reftype,amount,voided )
SELECT  
objid,appid,refno,refdate,refid,reftype,amount,voided
FROM obo.dbo.building_permit_payment p 
where appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
	and objid not in (
		select objid from obo_payment  where objid = p.objid 
	)
go 


INSERT INTO obo_control
(objid,state,appid,
doctypeid,controlno,dtissued,issuedby_objid,issuedby_name,expirydate,
remarks,template,endorserid,approverid,reportheader)
SELECT 
objid,state,appid,
doctypeid,controlno,dtissued,issuedby_objid,issuedby_name,expirydate,
remarks,template,endorserid,approverid,reportheader
FROM obo.dbo.obo_control c 
where appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
	and objid not in (
		select objid from obo_control where objid = c.objid 
	)
go 



-- insert building permit document
INSERT INTO obo_app_doc 
(objid,appid,state,doctypeid,amount,controlid) 
select * 
from ( 
	SELECT 
	CONCAT(objid,':BUILDING_PERMIT') AS objid, objid AS appid, 0 AS state, 'BUILDING_PERMIT' AS doctypeid, 0 AS amount,controlid
	FROM obo.dbo.building_permit 
	where objid = 'BAPP-28209981:178d7ff9f29:-7df2' 
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
	CONCAT(objid,':BUILDING_RPT') AS objid, objid AS appid, 0 AS state, 'BUILDING_RPT' AS doctypeid, 0 AS amount
	FROM obo.dbo.building_permit 
	where objid = 'BAPP-28209981:178d7ff9f29:-7df2' 
)tmp1 
where (
	select count(*) from obo_app_doc 
	where appid = tmp1.appid and doctypeid = tmp1.doctypeid 
) = 0 
go 


-- update the controlid of the obo_app_doc
UPDATE d1 set 
	d1.controlid = bd.controlid 
from obo_app_doc d1, obo.dbo.building_permit_doc bd 
WHERE d1.objid = bd.objid 
	and d1.appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
go 


-- correct the obo_control by updating the appid and doctypeid
UPDATE oc set 
	oc.appid = doc.appid, oc.docid = doc.objid 
from obo_control oc, obo_app_doc doc 
WHERE doc.controlid = oc.objid
	and doc.appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
go 


INSERT INTO obo_app_requirement 
(objid,appid,parentid,typeid,state,remarks,reviewer_objid,reviewer_name,dtreviewed)
SELECT
objid,appid,parentid,typeid,state,remarks,reviewer_objid,reviewer_name,dtreviewed
FROM obo.dbo.building_permit_requirement r 
where appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
	and objid not in (
		select objid from obo_app_requirement where objid = r.objid 
	)
go 

UPDATE r1 set 
	r1.supersederid = r2.supersederid 
from obo_app_requirement r1, obo.dbo.building_permit_requirement r2 
WHERE r1.objid = r2.objid 
	and r1.appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
go 


-- drop index uix_building_permit_transmittal_taskid on obo_app_transmittal
-- go 
-- create index ix_taskid on obo_app_transmittal (taskid) 
-- go 

INSERT INTO obo_app_transmittal 
( objid,appid,state,type,taskid,dtcreated,createdby_objid,createdby_name,approverid,endorserid,template,reportheader )
SELECT 
objid,appid,state,type,taskid,dtcreated,createdby_objid,createdby_name,approverid,endorserid,template,reportheader
FROM obo.dbo.building_permit_transmittal t 
WHERE type = 'requirement' 
	and appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
	and objid not in (
		select objid from obo_app_transmittal where objid = t.objid 
	)
go 


UPDATE r1 set 
	r1.transmittalid = r2.transmittalid 
from obo_app_requirement r1, obo.dbo.building_permit_requirement r2 
WHERE r1.objid = r2.objid 
	and r1.appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
go 


INSERT INTO obo_app_doc_checklist
(objid,	parentid,	typeid,	[values])	
SELECT 
c.objid,	
c.parentid,	
c.typeid,	
c.[values]
FROM obo.dbo.building_permit_checklist c, obo_app_doc doc 
where doc.appid = 'BAPP-28209981:178d7ff9f29:-7df2'  
	and c.parentid = doc.objid 
	and c.objid not in (
		select objid from obo_app_doc_checklist where objid = c.objid 
	)
go 

-- migrate the building evaluation,task and findings
INSERT INTO obo_app_taskitem 
(objid,appid,typeid)
select * 
from ( 
	SELECT 
		objid,appid,CONCAT('BUILDING:',typeid) AS typeid
	FROM obo.dbo.building_evaluation 
	where appid = 'BAPP-28209981:178d7ff9f29:-7df2'  
)tmp1 
where (
	select count(*) from obo_app_taskitem 
	where appid = tmp1.appid and typeid = tmp1.typeid 
) = 0 
go 


INSERT INTO obo_app_taskitem_task 
(taskid,refid,parentprocessid,state,startdate,enddate,assignee_objid,assignee_name,actor_objid,actor_name,message,dtcreated,prevtaskid)
SELECT 
t.taskid,t.refid,t.parentprocessid,t.state,t.startdate,t.enddate,t.assignee_objid,t.assignee_name,t.actor_objid,t.actor_name,t.message,t.dtcreated,t.prevtaskid
FROM obo.dbo.building_evaluation_task t 
	inner join obo.dbo.building_evaluation e on e.objid = t.refid 
where e.appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
	and t.taskid not in (
		select taskid from obo_app_taskitem_task where taskid = t.taskid 
	)
go

UPDATE t1 set 
	t1.taskid = t2.taskid 
from obo_app_taskitem t1, obo.dbo.building_evaluation t2 
WHERE t1.objid = t2.objid 
	and t1.appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
go 

-- findings 
INSERT INTO obo_app_taskitem_finding
(objid,appid,parentid,rootid,particulars,dtcreated,createdby_objid,createdby_name,state)
SELECT
objid,appid,parentid,rootid,particulars,dtcreated,createdby_objid,createdby_name,state
FROM obo.dbo.building_evaluation_finding f 
where appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
	and objid not in (
		select objid from obo_app_taskitem_finding where objid = f.objid 
	)
go 


INSERT INTO obo_app_transmittal 
( objid,appid,state,type,taskid,dtcreated,createdby_objid,createdby_name,approverid,endorserid,template,reportheader )
SELECT 
objid,appid,state,type,taskid,dtcreated,createdby_objid,createdby_name,approverid,endorserid,template,reportheader
FROM obo.dbo.building_permit_transmittal t 
WHERE appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
	and type <> 'requirement' 
	and objid not in (
		select objid from obo_app_transmittal  where objid = t.objid 
	) 
go 


UPDATE r1 set 
 	r1.transmittalid = r2.transmittalid, r1.supersederid = r2.supersederid  
from obo_app_taskitem_finding r1, obo.dbo.building_evaluation_finding r2 
WHERE r1.objid = r2.objid 
	and r1.appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
go 

UPDATE  building_permit_task 
SET state = 'trade-verification' 
WHERE state = 'verification' 
go

UPDATE obo_app_taskitem_task 
SET state = 'end' 
WHERE state IN ('obo-processing', 'releasing' )
go 

-- ADD PROFESSIONALS
INSERT INTO obo_app_professional
( objid, appid, sectionid, designprofessionalid, supervisorid, doctypeid )
select * 
from ( 
	SELECT 
		CONCAT(a.appid,':',doctypeid) AS objid, a.appid, NULL AS sectionid, 
		MAX(a.designprofessionalid) AS designprofessionalid, MAX(a.supervisorid) AS supervisorid, a.doctypeid  
	FROM (
		SELECT appid, doctypeid, designprofessionalid, NULL AS supervisorid 
		FROM obo.dbo.building_permit_doc 
		WHERE NOT( designprofessionalid IS NULL ) 
		UNION 
		SELECT appid, doctypeid, NULL AS designprofessionalid, supervisorid 
		FROM  obo.dbo.building_permit_doc 
		WHERE NOT( supervisorid IS NULL )
	) a 
	GROUP BY a.appid, a.doctypeid 
)tmp1 
where appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
	and objid not in (
		select objid from obo_app_professional where objid = tmp1.objid 
	) 
go 


UPDATE ap set 
	ap.sectionid = dt.sectionid 
from obo_app_professional ap, obo_doctype dt 
WHERE ap.doctypeid = dt.objid 
	and ap.appid = 'BAPP-28209981:178d7ff9f29:-7df2' 
go 


INSERT INTO obo_appno 
SELECT appno, objid as appid 
FROM obo_app a 
WHERE NOT(appno IS NULL) 
	and objid = 'BAPP-28209981:178d7ff9f29:-7df2' 
	and objid not in (
		select appid from obo_appno where appid = a.objid 
	) 
go 
