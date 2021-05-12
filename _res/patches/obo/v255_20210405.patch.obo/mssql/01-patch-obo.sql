alter table building_evaluation_finding add 
	[checklistitemid] varchar(50) NULL ,
	[values] varchar(MAX) NULL ,
	[attachmentid] varchar(50) NULL 
go 


alter table building_evaluation_type add 
	[joinstate] varchar(50) NULL 
go 

EXEC sp_rename N'[dbo].[building_permit].[zoneclassid]', N'_zoneclassid', 'COLUMN'
go 
EXEC sp_rename N'[dbo].[building_permit].[zone]', N'_zone', 'COLUMN'
go 



CREATE TABLE [dbo].[sys_file] (
[objid] varchar(50) NOT NULL ,
[title] varchar(50) NULL ,
[filetype] varchar(50) NULL ,
[dtcreated] datetime NULL ,
[createdby_objid] varchar(50) NULL ,
[createdby_name] varchar(255) NULL ,
[keywords] varchar(255) NULL ,
[description] text NULL ,
CONSTRAINT [pk_sys_file] PRIMARY KEY ([objid])
)
GO
CREATE INDEX [ix_createdby_objid] ON [dbo].[sys_file] ([createdby_objid] ASC) 
GO
CREATE INDEX [ix_dtcreated] ON [dbo].[sys_file] ([dtcreated] ASC) 
GO
CREATE INDEX [ix_keywords] ON [dbo].[sys_file] ([keywords] ASC) 
GO
CREATE INDEX [ix_title] ON [dbo].[sys_file] ([title] ASC) 
GO


CREATE TABLE [dbo].[sys_fileloc] (
[objid] varchar(50) NOT NULL ,
[url] varchar(255) NOT NULL ,
[rootdir] varchar(255) NULL ,
[defaultloc] int NOT NULL ,
[loctype] varchar(20) NULL ,
[user_name] varchar(50) NULL ,
[user_pwd] varchar(50) NULL ,
[info] text NULL ,
CONSTRAINT [pk_sys_fileloc] PRIMARY KEY ([objid])
)
GO

CREATE INDEX [ix_loctype] ON [dbo].[sys_fileloc] ([loctype] ASC) 
GO

CREATE TABLE [dbo].[sys_fileitem] (
[objid] varchar(50) NOT NULL ,
[state] varchar(50) NULL ,
[parentid] varchar(50) NULL ,
[dtcreated] datetime NULL ,
[createdby_objid] varchar(50) NULL ,
[createdby_name] varchar(255) NULL ,
[caption] varchar(155) NULL ,
[remarks] varchar(255) NULL ,
[filelocid] varchar(50) NULL ,
[filesize] int NULL ,
[thumbnail] text NULL ,
CONSTRAINT [pk_sys_fileitem] PRIMARY KEY ([objid])
)
GO

CREATE INDEX [ix_filelocid] ON [dbo].[sys_fileitem] ([filelocid] ASC) 
GO
CREATE INDEX [ix_parentid] ON [dbo].[sys_fileitem] ([parentid] ASC) 
GO
alter table sys_fileitem add CONSTRAINT [fk_sys_fileitem_parentid] 
	FOREIGN KEY ([parentid]) REFERENCES [dbo].[sys_file] ([objid]) 
go 




CREATE TABLE [dbo].[building_permit_attachment] (
[objid] varchar(50) NOT NULL ,
[appid] varchar(50) NULL ,
[parentid] varchar(50) NULL ,
[fileid] varchar(50) NULL ,
CONSTRAINT [pk_building_permit_attachment] PRIMARY KEY ([objid])
)
GO
CREATE UNIQUE INDEX [uix_building_permit_attachment_fileid] ON [dbo].[building_permit_attachment] ([fileid] ASC) 
GO
CREATE INDEX [fk_building_permit_attachment_appid] ON [dbo].[building_permit_attachment] ([appid] ASC) 
GO
alter table building_permit_attachment add CONSTRAINT [fk_building_permit_attachment_appid] 
	FOREIGN KEY ([appid]) REFERENCES [dbo].[building_permit] ([objid]) 
go 
alter table building_permit_attachment add CONSTRAINT [fk_building_permit_attachment_fileid] 
	FOREIGN KEY ([fileid]) REFERENCES [dbo].[sys_file] ([objid]) 
go 



alter table building_permit_entity alter column [name] varchar(300) not null 
go 


alter table building_permit_info add 
	[lookupkey] varchar(50) NULL ,
	[lookupvalue] varchar(255) NULL 
go 



CREATE TABLE [dbo].[building_permit_post_requirement] (
[objid] varchar(50) NOT NULL ,
[appid] varchar(50) NULL ,
[parentid] varchar(50) NULL ,
[typeid] varchar(50) NULL ,
[state] int NULL ,
[remarks] varchar(MAX) NULL ,
[createdby_objid] varchar(50) NULL ,
[createdby_name] varchar(255) NULL ,
[dtcreated] datetime NULL ,
CONSTRAINT [pk_building_permit_post_requirement] PRIMARY KEY ([objid]),
CONSTRAINT [building_permit_post_requirement_appid] FOREIGN KEY ([appid]) REFERENCES [dbo].[building_permit] ([objid]) ,
CONSTRAINT [building_permit_post_requirement_parentid] FOREIGN KEY ([parentid]) REFERENCES [dbo].[building_evaluation] ([objid]) ,
CONSTRAINT [building_permit_post_requirement_typeid] FOREIGN KEY ([typeid]) REFERENCES [dbo].[obo_requirement_type] ([objid]) 
)
GO
CREATE INDEX [fk_building_permit_requirement_parentid] ON [dbo].[building_permit_post_requirement]
([parentid] ASC) 
GO
CREATE INDEX [fk_req_appid] ON [dbo].[building_permit_post_requirement]
([appid] ASC) 
GO
CREATE INDEX [fk_req_typeid] ON [dbo].[building_permit_post_requirement]
([typeid] ASC) 
GO



alter table obo_checklist_master add 
	[system] int NULL ,
	[evaltypeid] varchar(50) NULL ,
	[inspectiontypeid] varchar(50) NULL 
go 

alter table obo_control add [appid] varchar(50) NULL 
go 
alter table obo_control alter column [remarks] varchar(800) NULL 
go 


alter table obo_doctype add [includeinemail] int NULL 
go 


CREATE TABLE [dbo].[obo_lookupvalue] (
[objid] varchar(50) NOT NULL ,
[listname] varchar(50) NULL ,
[key] varchar(50) NULL ,
[title] varchar(50) NULL ,
[system] int NULL ,
CONSTRAINT [pk_obo_lookupvalue] PRIMARY KEY ([objid])
)
GO

alter table obo_variable add [lookuplistname] varchar(50) NULL 
go 


alter table occupancy_inspection_finding add 
	[checklistitemid] varchar(50) NULL ,
	[values] varchar(MAX) NULL ,
	[attachmentid] varchar(50) NULL 
go 
EXEC sp_rename N'[dbo].[occupancy_inspection_finding].[attachment]', N'_attachmentid', 'COLUMN'
go 



CREATE TABLE [dbo].[occupancy_permit_attachment] (
[objid] varchar(50) NOT NULL ,
[appid] varchar(50) NULL ,
[parentid] varchar(50) NULL ,
[fileid] varchar(50) NULL ,
CONSTRAINT [pk_occupancy_permit_attachment] PRIMARY KEY ([objid]),
CONSTRAINT [occupancy_permit_attachment_appid] FOREIGN KEY ([appid]) REFERENCES [dbo].[occupancy_permit] ([objid]) ,
CONSTRAINT [occupancy_permit_attachment_fileid] FOREIGN KEY ([fileid]) REFERENCES [dbo].[sys_file] ([objid]) 
)
GO
CREATE UNIQUE INDEX [uix_occupancy_permit_attachment_fileid] ON [dbo].[occupancy_permit_attachment]
([fileid] ASC) 
GO
CREATE INDEX [occupancy_permit_attachment_appid] ON [dbo].[occupancy_permit_attachment]
([appid] ASC) 
GO


alter table sys_role add [system] int NULL 
go 


alter table sys_signature alter column [signature] image NULL 
go 



insert into sys_role ( name, title, system )
select name, title, system 
from ( 
   SELECT 'ADMIN' as name, 'ADMIN' as title, 1 as system
   union 
   SELECT 'APPROVER' as name, 'APPROVER' as title, 1 as system
   union 
   SELECT 'ARCHITECTURAL_EVALUATOR' as name, 'ARCHITECTURAL EVALUATOR' as title, 1 as system
   union 
   SELECT 'ASSESSOR' as name, 'ASSESSOR' as title, 1 as system
   union 
   SELECT 'BFP_APPROVER' as name, 'BFP APPROVER' as title, 1 as system
   union 
   SELECT 'BFP_EVALUATOR' as name, 'BFP EVALUATOR' as title, 1 as system
   union 
   SELECT 'BFP_INSPECTOR' as name, 'BFP INSPECTOR' as title, 1 as system
   union 
   SELECT 'BFP_RELEASER' as name, 'BFP RELEASER' as title, 1 as system
   union 
   SELECT 'BFP_REVIEWER' as name, 'BFP REVIEWER' as title, 1 as system
   union 
   SELECT 'BILLING' as name, 'OBO BILLING' as title, 1 as system
   union 
   SELECT 'CIVIL_STRUCTURAL_EVALUATOR' as name, 'CIVIL_STRUCTURAL_EVALUATOR' as title, 1 as system
   union 
   SELECT 'COORDINATOR' as name, 'OBO COORDINATOR' as title, 1 as system
   union 
   SELECT 'ELECTRICAL_EVALUATOR' as name, 'ELECTRICAL EVALUATOR' as title, 1 as system
   union 
   SELECT 'ELECTRONIC_EVALUATOR' as name, 'ELECTRONIC_EVALUATOR' as title, 1 as system
   union 
   SELECT 'LAND_USE_EVALUATOR' as name, 'LAND USE EVALUATOR' as title, 1 as system
   union 
   SELECT 'LINE_AND_GRADE_EVALUATOR' as name, 'LINE_AND_GRADE_EVALUATOR' as title, 1 as system
   union 
   SELECT 'MASTER' as name, 'MASTER' as title, 1 as system
   union 
   SELECT 'MECHANICAL_EVALUATOR' as name, 'MECHANICAL EVALUATOR' as title, 1 as system
   union 
   SELECT 'PLUMBING_EVALUATOR' as name, 'PLUMBING EVALUATOR' as title, 1 as system
   union 
   SELECT 'RECEIVER' as name, 'RECEIVER' as title, 1 as system
   union 
   SELECT 'RELEASER' as name, 'OBO RELEASER' as title, 1 as system
   union 
   SELECT 'REQUIREMENT_REVIEWER' as name, 'OBO REQUIREMENT_REVIEWER' as title, 1 as system
   union 
   SELECT 'REVIEWER' as name, 'OBO REVIEWER' as title, 1 as system
   union 
   SELECT 'RPT_APPROVER' as name, 'OBO RPT_APPROVER' as title, 1 as system
   union 
   SELECT 'RPT_INSPECTOR' as name, 'OBO RPT_INSPECTOR' as title, 1 as system
   union 
   SELECT 'RPT_REVIEWER' as name, 'OBO RPT_REVIEWER' as title, 1 as system
   union 
   SELECT 'RULE_AUTHOR' as name, 'OBO RULE_AUTHOR' as title, 1 as system
   union 
   SELECT 'SANITARY_EVALUATOR' as name, 'SANITARY EVALUATOR' as title, 1 as system
   union 
   SELECT 'SECTION_APPROVER' as name, 'OBO SECTION_APPROVER' as title, 1 as system
   union 
   SELECT 'SECTION_EVALUATOR' as name, 'SECTION EVALUATOR' as title, 1 as system
   union 
   SELECT 'SECTION_INSPECTOR' as name, 'SECTION INSPECTOR' as title, 1 as system
   union 
   SELECT 'SECTION_ISSUER' as name, 'OBO SECTION_ISSUER' as title, 1 as system
   union 
   SELECT 'SECTION_RELEASER' as name, 'OBO SECTION_RELEASER' as title, 1 as system
   union 
   SELECT 'SECTION_REVIEWER' as name, 'OBO SECTION_REVIEWER' as title, 1 as system
   union 
   SELECT 'SHARED' as name, 'OBO SHARED' as title, 1 as system
   union 
   SELECT 'SITE_EVALUATOR' as name, 'OBO SITE_EVALUATOR' as title, 1 as system
   union 
   SELECT 'SITE_INSPECTOR' as name, 'SITE INSPECTOR' as title, 1 as system
   union 
   SELECT 'SITE_REVIEWER' as name, 'OBO SITE_REVIEWER' as title, 1 as system
   union 
   SELECT 'SYSTEM' as name, 'OBO SYSTEM' as title, 1 as system
   union 
   SELECT 'WF_EDITOR' as name, 'WORKFLOW EDITOR' as title, 0 as system
   union 
   SELECT 'ZONING_APPROVER' as name, 'ZONING APPROVER' as title, 1 as system
   union 
   SELECT 'ZONING_EVALUATOR' as name, 'ZONING EVALUATOR' as title, 1 as system
   union 
   SELECT 'ZONING_RELEASER' as name, 'OBO ZONING_RELEASER' as title, 1 as system
   union 
   SELECT 'ZONING_REVIEWER' as name, 'ZONING REVIEWER' as title, 1 as system
)tmp1 
where tmp1.name not in (select name from sys_role) 
; 



insert into sys_role ( name, title, system ) 
select name, title, system  
from ( 
 SELECT 'ADMIN' as name, 'ADMIN' as title, 1 as system
 union 
 SELECT 'APPROVER' as name, 'APPROVER' as title, 1 as system
 union 
 SELECT 'ARCHITECTURAL_EVALUATOR' as name, 'ARCHITECTURAL EVALUATOR' as title, 1 as system
 union 
 SELECT 'ASSESSOR' as name, 'ASSESSOR' as title, 1 as system
 union 
 SELECT 'BFP_APPROVER' as name, 'BFP APPROVER' as title, 1 as system
 union 
 SELECT 'BFP_EVALUATOR' as name, 'BFP EVALUATOR' as title, 1 as system
 union 
 SELECT 'BFP_INSPECTOR' as name, 'BFP INSPECTOR' as title, 1 as system
 union 
 SELECT 'BFP_RELEASER' as name, 'BFP RELEASER' as title, 1 as system
 union 
 SELECT 'BFP_REVIEWER' as name, 'BFP REVIEWER' as title, 1 as system
 union 
 SELECT 'BILLING' as name, 'OBO BILLING' as title, 1 as system
 union 
 SELECT 'CIVIL_STRUCTURAL_EVALUATOR' as name, 'CIVIL_STRUCTURAL_EVALUATOR' as title, 1 as system
 union 
 SELECT 'COORDINATOR' as name, 'OBO COORDINATOR' as title, 1 as system
 union 
 SELECT 'EDITOR' as name, 'OBO EDITOR' as title, 0 as system
 union 
 SELECT 'ELECTRICAL_EVALUATOR' as name, 'ELECTRICAL EVALUATOR' as title, 1 as system
 union 
 SELECT 'ELECTRONIC_EVALUATOR' as name, 'ELECTRONIC_EVALUATOR' as title, 1 as system
 union 
 SELECT 'LAND_USE_EVALUATOR' as name, 'LAND USE EVALUATOR' as title, 1 as system
 union 
 SELECT 'LINE_AND_GRADE_EVALUATOR' as name, 'LINE_AND_GRADE_EVALUATOR' as title, 1 as system
 union 
 SELECT 'MASTER' as name, 'MASTER' as title, 1 as system
 union 
 SELECT 'MECHANICAL_EVALUATOR' as name, 'MECHANICAL EVALUATOR' as title, 1 as system
 union 
 SELECT 'PLUMBING_EVALUATOR' as name, 'PLUMBING EVALUATOR' as title, 1 as system
 union 
 SELECT 'RECEIVER' as name, 'RECEIVER' as title, 1 as system
 union 
 SELECT 'RELEASER' as name, 'OBO RELEASER' as title, 1 as system
 union 
 SELECT 'REQUIREMENT_REVIEWER' as name, 'OBO REQUIREMENT_REVIEWER' as title, 1 as system
 union 
 SELECT 'REVIEWER' as name, 'OBO REVIEWER' as title, 1 as system
 union 
 SELECT 'RPT_APPROVER' as name, 'OBO RPT_APPROVER' as title, 1 as system
 union 
 SELECT 'RPT_INSPECTOR' as name, 'OBO RPT_INSPECTOR' as title, 1 as system
 union 
 SELECT 'RPT_REVIEWER' as name, 'OBO RPT_REVIEWER' as title, 1 as system
 union 
 SELECT 'RULE_AUTHOR' as name, 'OBO RULE_AUTHOR' as title, 1 as system
 union 
 SELECT 'SANITARY_EVALUATOR' as name, 'SANITARY EVALUATOR' as title, 1 as system
 union 
 SELECT 'SECTION_APPROVER' as name, 'OBO SECTION_APPROVER' as title, 1 as system
 union 
 SELECT 'SECTION_EVALUATOR' as name, 'SECTION EVALUATOR' as title, 1 as system
 union 
 SELECT 'SECTION_INSPECTOR' as name, 'SECTION INSPECTOR' as title, 1 as system
 union 
 SELECT 'SECTION_ISSUER' as name, 'OBO SECTION_ISSUER' as title, 1 as system
 union 
 SELECT 'SECTION_RELEASER' as name, 'OBO SECTION_RELEASER' as title, 1 as system
 union 
 SELECT 'SECTION_REVIEWER' as name, 'OBO SECTION_REVIEWER' as title, 1 as system
 union 
 SELECT 'SHARED' as name, 'OBO SHARED' as title, 1 as system
 union 
 SELECT 'SITE_EVALUATOR' as name, 'OBO SITE_EVALUATOR' as title, 1 as system
 union 
 SELECT 'SITE_INSPECTOR' as name, 'SITE INSPECTOR' as title, 1 as system
 union 
 SELECT 'SITE_REVIEWER' as name, 'OBO SITE_REVIEWER' as title, 1 as system
 union 
 SELECT 'SUPERVISOR' as name, 'OBO SUPERVISOR' as title, 0 as system
 union 
 SELECT 'SYSTEM' as name, 'OBO SYSTEM' as title, 1 as system
 union 
 SELECT 'WF_EDITOR' as name, 'WORKFLOW EDITOR' as title, 0 as system
 union 
 SELECT 'ZONING_APPROVER' as name, 'ZONING APPROVER' as title, 1 as system
 union 
 SELECT 'ZONING_EVALUATOR' as name, 'ZONING EVALUATOR' as title, 1 as system
 union 
 SELECT 'ZONING_RELEASER' as name, 'OBO ZONING_RELEASER' as title, 1 as system
 union 
 SELECT 'ZONING_REVIEWER' as name, 'ZONING REVIEWER' as title, 1 as system
)tmp1 
where tmp1.name not in (select name from sys_role)
;




--
-- VIEWS
--

IF OBJECT_ID('vw_building_permit', 'V') IS NOT NULL 
   DROP VIEW vw_building_permit;
GO 
CREATE VIEW vw_building_permit AS select 
a.objid AS objid,  
a.appno AS appno,  
a.orgcode AS orgcode,  
a.trackingno AS trackingno,  
a.apptype AS apptype,  
a.appdate AS appdate,  
a.taskid AS taskid,  
a.contact_name AS contact_name,  
a.contact_detail AS contact_detail,  
a.contact_email AS contact_email,  
a.contact_mobileno AS contact_mobileno,  
a.txnmode AS txnmode,  
a.txntype AS txntype,  
a.controlid AS controlid,  
a.amount AS amount,  
a.applicantid AS applicantid,  
a.description AS description,  
a.title AS title,  
a.occupancytypeid AS occupancytypeid,  
a.numunits AS numunits,  
a.fixedcost AS fixedcost,  
a.projectcost AS projectcost,  
a.dtproposedconstruction AS dtproposedconstruction,  
a.dtexpectedcompletion AS dtexpectedcompletion,  
a.totalfloorarea AS totalfloorarea,  
a.height AS height,  
a.numfloors AS numfloors,  
a.worktypes AS worktypes,  
a._zoneclassid AS _zoneclassid,  
a._zone AS _zone,  
a.location_lotno AS location_lotno,  
a.location_blockno AS location_blockno,  
a.location_street AS location_street,  
a.location_barangay_name AS location_barangay_name,  
a.location_barangay_objid AS location_barangay_objid,  
a.supervisorid AS supervisorid,  
a.location_unitno AS location_unitno,  
a.location_bldgno AS location_bldgno,  
a.location_bldgname AS location_bldgname,  
a.location_subdivision AS location_subdivision,  
a.createdby_objid AS createdby_objid,  
a.createdby_name AS createdby_name,  
a.dtcreated AS dtcreated,  
a.location_lotarea AS location_lotarea,  
ae.name AS applicant_name,  
bt.objid AS occupancytype_objid,  
bt.title AS occupancytype_title,  
od.objid AS occupancytype_division_objid,  
od.title AS occupancytype_division_title,  
og.objid AS occupancytype_group_objid,  
og.title AS occupancytype_group_title, 
rtrim(ltrim(
   (case when a.location_unitno is null then '' else (' '+ a.location_unitno) end) + 
   (case when a.location_bldgno is null then '' else (' '+ a.location_bldgno) end) + 
   (case when a.location_bldgname is null then '' else (' '+ a.location_bldgname) end) + 
   (case when a.location_lotno is null then '' else (' Lot.'+ a.location_lotno) end) + 
   (case when a.location_blockno is null then '' else (' Blk.' + a.location_blockno) end) + 
   (case when a.location_street is null then '' else (' '+ a.location_street) end) + 
   (case when a.location_subdivision is null then '' else (', '+ a.location_subdivision) end) + 
   (case when a.location_barangay_name is null then '' else (', '+ a.location_barangay_name) end)
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
pmt.controlno AS controlno,  
pmt.expirydate AS expirydate,  
pmt.dtissued AS dtissued,  
pmt.issuedby_name AS issuedby_name,  
pmt.approverid AS approverid,  
pmt.endorserid AS endorserid,  
pmt.template AS template,  
pmt.reportheader AS reportheader  
 from building_permit a 
   join building_permit_entity ae on a.applicantid = ae.objid 
   join building_permit_task t on a.taskid = t.taskid 
   join sys_wf_node sn on (sn.processname = 'building_permit' and sn.name = t.state) 
   join obo_occupancy_type bt on a.occupancytypeid = bt.objid 
   join obo_occupancy_type_division od on bt.divisionid = od.objid 
   join obo_occupancy_type_group og on od.groupid = og.objid 
   left join obo_control pmt on (pmt.appid = a.objid and pmt.doctypeid = 'BUILDING_PERMIT')
go 


IF OBJECT_ID('vw_building_evaluation', 'V') IS NOT NULL 
   DROP VIEW vw_building_evaluation;
GO 
CREATE VIEW vw_building_evaluation AS select 
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
from building_evaluation a 
   join building_evaluation_task t on a.taskid = t.taskid 
   join building_evaluation_type et on a.typeid = et.objid 
   left join obo_section os on et.sectionid = os.objid 
   join sys_wf_node sn on (sn.processname = 'building_evaluation' and sn.name = t.state) 
   join vw_building_permit app on a.appid = app.objid 
go 


IF OBJECT_ID('vw_building_evaluation_consolidated', 'V') IS NOT NULL 
   DROP VIEW vw_building_evaluation_consolidated;
GO 
CREATE VIEW vw_building_evaluation_consolidated AS select 
be.objid AS objid, 
be.appid AS appid, 
be.typeid AS typeid, 
bt.title AS type_title, 
bt.sortindex AS sortindex, 
btk.state AS state, 
btk.assignee_objid AS assignee_objid, 
os.org_objid AS org_objid, 
(case when betr.role is null then wn.role else betr.role end) AS role 
from building_evaluation be 
   join building_evaluation_task btk on be.taskid = btk.taskid 
   join building_evaluation_type bt on be.typeid = bt.objid 
   join sys_wf_node wn on (wn.processname = 'building_evaluation' and wn.name = btk.state) 
   left join building_evaluation_type_role betr on (betr.typeid = bt.objid and betr.state = btk.state) 
   left join obo_section os on bt.sectionid = os.objid
GO 


IF OBJECT_ID('vw_building_permit_doc', 'V') IS NOT NULL 
   DROP VIEW vw_building_permit_doc;
GO 
CREATE VIEW vw_building_permit_doc AS select 
a.objid AS objid,
a.appid AS appid,
a.state AS state,
a.doctypeid AS doctypeid,
a.designprofessionalid AS designprofessionalid,
a.supervisorid AS supervisorid,
a.worktypes AS worktypes,
a.contractorname AS contractorname,
a.remarks AS remarks,
a.amount AS amount,
a.controlid AS controlid,
a.occupancytypeid AS occupancytypeid,
a.projectcost AS projectcost,
a.equipmentcost AS equipmentcost,
os.org_objid AS org_objid,
bt.state AS appstate,
bt.assignee_objid AS appuserid,
iss.controlno AS controlno,
iss.dtissued AS dtissued,
iss.expirydate AS expirydate,
iss.issuedby_name AS issuedby_name,
iss.issuedby_objid AS issuedby_objid,
iss.template AS template,
iss.endorserid AS endorserid,
iss.approverid AS approverid,
od.sectionid AS sectionid 
from building_permit_doc a 
   join obo_doctype od on a.doctypeid = od.objid 
   left join obo_section os on od.sectionid = os.objid 
   left join obo_control iss on a.controlid = iss.objid 
   join building_permit ba on a.appid = ba.objid 
   left join building_permit_task bt on ba.taskid = bt.taskid
GO 

IF OBJECT_ID('vw_building_permit_fee', 'V') IS NOT NULL 
   DROP VIEW vw_building_permit_fee;
GO 
CREATE VIEW vw_building_permit_fee AS select 
a.objid AS objid,
a.appid AS appid,
a.parentid AS parentid,
a.itemid AS itemid,
a.amount AS amount,
a.amtpaid AS amtpaid,
a.remarks AS remarks,
sd.doctypeid AS doctypeid 
from building_permit_fee a 
   left join building_permit_doc sd on a.parentid = sd.objid
GO 

IF OBJECT_ID('vw_building_permit_fee_payment', 'V') IS NOT NULL 
   DROP VIEW vw_building_permit_fee_payment;
GO 
CREATE VIEW vw_building_permit_fee_payment AS select 
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
from building_permit_fee bf 
   join obo_itemaccount oi on bf.itemid = oi.objid 
   left join building_permit_payment pt on bf.appid = pt.appid 
where (pt.voided IS NULL or pt.voided = 0)
GO

IF OBJECT_ID('vw_building_permit_info', 'V') IS NOT NULL 
   DROP VIEW vw_building_permit_info;
GO 
CREATE VIEW vw_building_permit_info AS select 
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
ov.arrayvalues AS arrayvalues 
from building_permit_info ai 
   join obo_variable ov on ov.objid = ai.name
GO 

IF OBJECT_ID('vw_building_permit_online', 'V') IS NOT NULL 
   DROP VIEW vw_building_permit_online;
GO 
CREATE VIEW vw_building_permit_online AS select 
a.objid AS objid,
a.appno AS appno,
a.orgcode AS orgcode,
a.trackingno AS trackingno,
a.apptype AS apptype,
a.appdate AS appdate,
a.taskid AS taskid,
a.contact_name AS contact_name,
a.contact_detail AS contact_detail,
a.contact_email AS contact_email,
a.contact_mobileno AS contact_mobileno,
a.txnmode AS txnmode,
a.txntype AS txntype,
a.controlid AS controlid,
a.amount AS amount,
a.applicantid AS applicantid,
a.description AS description,
a.title AS title,
a.occupancytypeid AS occupancytypeid,
a.numunits AS numunits,
a.fixedcost AS fixedcost,
a.projectcost AS projectcost,
a.dtproposedconstruction AS dtproposedconstruction,
a.dtexpectedcompletion AS dtexpectedcompletion,
a.totalfloorarea AS totalfloorarea,
a.height AS height,
a.numfloors AS numfloors,
a.worktypes AS worktypes,
a._zoneclassid AS _zoneclassid,
a._zone AS _zone,
a.location_lotno AS location_lotno,
a.location_blockno AS location_blockno,
a.location_street AS location_street,
a.location_barangay_name AS location_barangay_name,
a.location_barangay_objid AS location_barangay_objid,
a.supervisorid AS supervisorid,
a.location_unitno AS location_unitno,
a.location_bldgno AS location_bldgno,
a.location_bldgname AS location_bldgname,
a.location_subdivision AS location_subdivision,
a.createdby_objid AS createdby_objid,
a.createdby_name AS createdby_name,
a.dtcreated AS dtcreated,
a.location_lotarea AS location_lotarea,
bt.objid AS occupancytype_objid,
bt.title AS occupancytype_title,
od.objid AS occupancytype_division_objid,
od.title AS occupancytype_division_title,
og.objid AS occupancytype_group_objid,
og.title AS occupancytype_group_title,
e.name AS applicant_name,
e.address_text AS applicant_address_text,
t.state AS task_state 
from building_permit a 
   join obo_occupancy_type bt on a.occupancytypeid = bt.objid 
   join obo_occupancy_type_division od on bt.divisionid = od.objid 
   join obo_occupancy_type_group og on od.groupid = og.objid 
   join building_permit_entity e on a.applicantid = e.objid 
   left join building_permit_task t on a.taskid = t.taskid 
where a.taskid IS NULL 
GO 

IF OBJECT_ID('vw_obo_doctype', 'V') IS NOT NULL 
   DROP VIEW vw_obo_doctype;
GO 
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
GO 

IF OBJECT_ID('vw_obo_doctype_itemaccount', 'V') IS NOT NULL 
   DROP VIEW vw_obo_doctype_itemaccount;
GO 
CREATE VIEW vw_obo_doctype_itemaccount AS select 
a.objid AS objid,
a.title AS title,
e.typeid AS typeid 
from obo_itemaccount a 
   join obo_doctype_itemaccount e on a.objid = e.itemid
GO 

IF OBJECT_ID('vw_obo_occupancy_type', 'V') IS NOT NULL 
   DROP VIEW vw_obo_occupancy_type;
GO 
CREATE VIEW vw_obo_occupancy_type AS select 
ot.objid AS objid,
ot.divisionid AS divisionid,
ot.title AS title,
od.objid AS division_objid,
od.title AS division_title,
og.objid AS group_objid,
og.title AS group_title 
from obo_occupancy_type ot 
   join obo_occupancy_type_division od on ot.divisionid = od.objid 
   join obo_occupancy_type_group og on od.groupid = og.objid
GO 

IF OBJECT_ID('vw_obo_professional', 'V') IS NOT NULL 
   DROP VIEW vw_obo_professional;
GO 
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
(pi.lastname +', '+ pi.firstname +' '+ substring(pi.middlename,0,1) +'.') AS name,
id.caption AS id_type_caption,
id.title AS id_type_title 
from obo_professional p 
   join obo_professional_info pi on p.infoid = pi.objid 
   left join idtype id on pi.id_type_name = id.name
go 

IF OBJECT_ID('vw_obo_professional_info', 'V') IS NOT NULL 
   DROP VIEW vw_obo_professional_info;
GO 
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
(pi.lastname +', '+ pi.firstname +' '+ substring(pi.middlename,0,1) +'.') AS name,
id.caption AS id_type_caption,
id.title AS id_type_title 
from obo_professional_info pi 
   left join idtype id on pi.id_type_name = id.name
go 

IF OBJECT_ID('vw_obo_professional_info_lookup', 'V') IS NOT NULL 
   DROP VIEW vw_obo_professional_info_lookup;
GO 
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
(pi.lastname +', '+ pi.firstname +' '+ substring(pi.middlename,0,1) +'.') AS name,
id.caption AS id_type_caption,
id.title AS id_type_title 
from obo_professional_info pi 
   join obo_professional p on p.infoid = pi.objid 
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
(pi.lastname +', '+ pi.firstname +' '+ substring(pi.middlename,0,1) +'.') AS name,
id.caption AS id_type_caption,
id.title AS id_type_title 
from obo_professional_info pi 
   left join idtype id on pi.id_type_name = id.name 
where pi.prc_idno not in (select prcno from obo_professional)
go 


IF OBJECT_ID('vw_occupancy_permit', 'V') IS NOT NULL 
   DROP VIEW vw_occupancy_permit;
GO 
CREATE VIEW vw_occupancy_permit AS select 
op.objid AS objid,
op.appno AS appno,
op.apptype AS apptype,
op.txntype AS txntype,
op.orgcode AS orgcode,
op.trackingno AS trackingno,
op.contact_name AS contact_name,
op.contact_detail AS contact_detail,
op.contact_email AS contact_email,
op.contact_mobileno AS contact_mobileno,
op.appdate AS appdate,
op.taskid AS taskid,
op.bldgpermitid AS bldgpermitid,
op.applicantid AS applicantid,
op.txnmode AS txnmode,
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
op.controlid AS controlid,
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
(select title from sys_wf_node where processname = 'occupancy_permit' and name = t.state) AS task_title,
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
from occupancy_permit op 
   join vw_building_permit bp on op.bldgpermitid = bp.objid 
   join occupancy_permit_task t on op.taskid = t.taskid 
   join obo_occupancy_type ot on op.occupancytypeid = ot.objid 
   join obo_occupancy_type_division od on ot.divisionid = od.objid 
   join obo_occupancy_type_group og on od.groupid = og.objid 
   left join obo_control ctl on op.controlid = ctl.objid
go 


IF OBJECT_ID('vw_occupancy_inspection', 'V') IS NOT NULL 
   DROP VIEW vw_occupancy_inspection;
GO 
CREATE VIEW vw_occupancy_inspection AS select 
a.objid AS objid,
a.appid AS appid,
a.typeid AS typeid,
a.taskid AS taskid,
a.uploaded AS uploaded,
app.bldgpermitid AS bldgpermitid,
et.title AS type_title,
et.sortindex AS type_sortindex,
app.task_state AS app_task_state,
t.state AS task_state,
t.dtcreated AS task_dtcreated,
t.startdate AS task_startdate,
t.enddate AS task_enddate,
t.assignee_objid AS task_assignee_objid,
t.assignee_name AS task_assignee_name,
t.actor_objid AS task_actor_objid,
t.actor_name AS task_actor_name,
(select title from sys_wf_node where processname = 'occupancy_inspection' and name = t.state) AS task_title,
DATEDIFF(SECOND, t.dtcreated, ISNULL(t.enddate, GETDATE())) AS task_timediff,
os.objid AS sectionid,
os.org_objid AS org_objid 
from occupancy_inspection a 
   join occupancy_inspection_task t on a.taskid = t.taskid 
   join occupancy_inspection_type et on a.typeid = et.objid 
   join vw_occupancy_permit app on a.appid = app.objid 
   left join obo_section os on et.sectionid = os.objid
go 


IF OBJECT_ID('vw_occupancy_permit_doc', 'V') IS NOT NULL 
   DROP VIEW vw_occupancy_permit_doc;
GO 
CREATE VIEW vw_occupancy_permit_doc AS select 
a.objid AS objid,
a.appid AS appid,
a.state AS state,
a.doctypeid AS doctypeid,
a.remarks AS remarks,
a.amount AS amount,
a.controlid AS controlid,
os.org_objid AS org_objid,
bt.state AS appstate,
bt.assignee_objid AS appuserid,
iss.controlno AS controlno,
iss.dtissued AS dtissued,
iss.expirydate AS expirydate,
iss.issuedby_name AS issuedby_name,
iss.issuedby_objid AS issuedby_objid,
iss.remarks AS issue_remarks,
iss.template AS template,
od.sectionid AS sectionid 
from occupancy_permit_doc a 
   join obo_doctype od on a.doctypeid = od.objid
   left join obo_control iss on a.controlid = iss.objid 
   join occupancy_permit ba on a.appid = ba.objid 
   join occupancy_permit_task bt on ba.taskid = bt.taskid 
   left join obo_section os on od.sectionid = os.objid
go 

IF OBJECT_ID('vw_occupancy_permit_fee', 'V') IS NOT NULL 
   DROP VIEW vw_occupancy_permit_fee;
GO 
CREATE VIEW vw_occupancy_permit_fee AS select 
a.objid AS objid,
a.appid AS appid,
a.parentid AS parentid,
a.itemid AS itemid,
a.amount AS amount,
a.amtpaid AS amtpaid,
a.remarks AS remarks,
sd.doctypeid AS doctypeid 
from occupancy_permit_fee a 
   left join occupancy_permit_doc sd on a.parentid = sd.objid
go

IF OBJECT_ID('vw_occupancy_permit_info', 'V') IS NOT NULL 
   DROP VIEW vw_occupancy_permit_info;
GO 
CREATE VIEW vw_occupancy_permit_info AS select 
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
ov.datatype AS datatype,
ov.doctypeid AS doctypeid,
ov.unit AS unit,
ov.caption AS caption,
ov.category AS category,
ov.sortorder AS sortorder 
from occupancy_permit_info ai 
   join obo_variable ov on ov.objid = ai.name
go 

IF OBJECT_ID('vw_occupancy_rpu', 'V') IS NOT NULL 
   DROP VIEW vw_occupancy_rpu;
GO 
CREATE VIEW vw_occupancy_rpu AS select 
orpt.objid AS objid,
orpt.state AS state,
orpt.dtcreated AS dtcreated,
orpt.appid AS appid,
orpt.faasid AS faasid,
orpt.tdno AS tdno,
orpt.txnmode AS txnmode,
app.apptype AS apptype,
app.bldgpermitid AS bldgpermitid,
app.applicantid AS applicantid,
app.actualprojectcost AS actualprojectcost,
app.occupancytypeid AS occupancytypeid,
app.actualnumunits AS actualnumunits,
app.actualnumfloors AS actualnumfloors,
app.actualtotalfloorarea AS actualtotalfloorarea,
app.actualheight AS actualheight,
app.dtactualstarted AS dtactualstarted,
app.dtactualcompleted AS dtactualcompleted,
app.inspectiondate AS inspectiondate,
bp.objid AS bldgappid,
bp.controlno AS bldgpermitno,
bp.dtissued AS bldgpermitdtissued,
bp.title AS title,
bp.location_text AS location_text,
op.objid AS occpermitid,
op.controlno AS occpermitno,
op.dtissued AS occpermitdtissued 
from occupancy_rpu orpt 
   join vw_occupancy_permit app on orpt.appid = app.objid 
   join vw_building_permit bp on app.bldgpermitid = bp.objid 
   left join obo_control op on app.controlid = op.objid
go 
