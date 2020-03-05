

/* 255-03016 */

/*================================================================
*
* LANDTAX SHARE POSTING
*
================================================================*/
alter table rptpayment_share add iscommon int
go 

alter table rptpayment_share add year int
go 

update rptpayment_share set iscommon = 0 where iscommon is null 
go 




CREATE TABLE cashreceipt_rpt_share_forposting (
  objid varchar(50) NOT NULL,
  receiptid varchar(50) NOT NULL,
  rptledgerid varchar(50) NOT NULL,
  txndate datetime,
  error int NOT NULL,
  msg text,
  PRIMARY KEY (objid)
) 
go 


create UNIQUE index ux_receiptid_rptledgerid on cashreceipt_rpt_share_forposting (receiptid,rptledgerid)
go 
create index fk_cashreceipt_rpt_share_forposing_rptledger on cashreceipt_rpt_share_forposting (rptledgerid)
go 
create index fk_cashreceipt_rpt_share_forposing_cashreceipt on cashreceipt_rpt_share_forposting (receiptid)
go 

alter table cashreceipt_rpt_share_forposting add CONSTRAINT fk_cashreceipt_rpt_share_forposing_rptledger 
FOREIGN KEY (rptledgerid) REFERENCES rptledger (objid)
go 
alter table cashreceipt_rpt_share_forposting add CONSTRAINT fk_cashreceipt_rpt_share_forposing_cashreceipt 
FOREIGN KEY (receiptid) REFERENCES cashreceipt (objid)
go 




/*==================================================
**
** BLDG DATE CONSTRUCTED SUPPORT 
**
===================================================*/

alter table bldgrpu add dtconstructed date
go 



delete from sys_wf_transition where processname = 'batchgr'
go
delete from sys_wf_node where processname = 'batchgr'
go

INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('start', 'batchgr', 'Start', 'start', '1', NULL, 'RPT', 'START', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-receiver', 'batchgr', 'For Review and Verification', 'state', '2', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('receiver', 'batchgr', 'Review and Verification', 'state', '5', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-examiner', 'batchgr', 'For Examination', 'state', '10', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('examiner', 'batchgr', 'Examination', 'state', '15', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-taxmapper', 'batchgr', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-provtaxmapper', 'batchgr', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('taxmapper', 'batchgr', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('provtaxmapper', 'batchgr', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-taxmapping-approval', 'batchgr', 'For Taxmapping Approval', 'state', '30', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('taxmapper_chief', 'batchgr', 'Taxmapping Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-appraiser', 'batchgr', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-provappraiser', 'batchgr', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('appraiser', 'batchgr', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('provappraiser', 'batchgr', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-appraisal-chief', 'batchgr', 'For Appraisal Approval', 'state', '50', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('appraiser_chief', 'batchgr', 'Appraisal Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-recommender', 'batchgr', 'For Recommending Approval', 'state', '70', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('recommender', 'batchgr', 'Recommending Approval', 'state', '75', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('forprovsubmission', 'batchgr', 'For Province Submission', 'state', '80', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('forprovapproval', 'batchgr', 'For Province Approval', 'state', '81', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('forapproval', 'batchgr', 'Provincial Assessor Approval', 'state', '85', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-approver', 'batchgr', 'For Provincial Assessor Approval', 'state', '90', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('approver', 'batchgr', 'Provincial Assessor Approval', 'state', '95', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('provapprover', 'batchgr', 'Approved By Province', 'state', '96', NULL, 'RPT', 'APPROVER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('end', 'batchgr', 'End', 'end', '1000', NULL, 'RPT', NULL, NULL, NULL, NULL)
go 

INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('start', 'batchgr', '', 'assign-receiver', '1', NULL, NULL, NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-receiver', 'batchgr', '', 'receiver', '2', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('receiver', 'batchgr', 'submit', 'assign-provtaxmapper', '5', NULL, '[caption:''Submit For Taxmapping'', confirm:''Submit?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-examiner', 'batchgr', '', 'examiner', '10', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('examiner', 'batchgr', 'returnreceiver', 'receiver', '15', NULL, '[caption:''Return to Receiver'', confirm:''Return to receiver?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('examiner', 'batchgr', 'submit', 'assign-provtaxmapper', '16', NULL, '[caption:''Submit for Approval'', confirm:''Submit?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-provtaxmapper', 'batchgr', '', 'provtaxmapper', '20', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provtaxmapper', 'batchgr', 'returnexaminer', 'examiner', '25', NULL, '[caption:''Return to Examiner'', confirm:''Return to examiner?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provtaxmapper', 'batchgr', 'submit', 'assign-provappraiser', '26', NULL, '[caption:''Submit for Approval'', confirm:''Submit?'', messagehandler:''rptmessage:sign'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-provappraiser', 'batchgr', '', 'provappraiser', '40', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provappraiser', 'batchgr', 'returntaxmapper', 'provtaxmapper', '45', NULL, '[caption:''Return to Taxmapper'', confirm:''Return to taxmapper?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provappraiser', 'batchgr', 'returnexaminer', 'examiner', '46', NULL, '[caption:''Return to Examiner'', confirm:''Return to examiner?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provappraiser', 'batchgr', 'submit', 'assign-approver', '47', NULL, '[caption:''Submit for Approval'', confirm:''Submit?'', messagehandler:''rptmessage:sign'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-approver', 'batchgr', '', 'approver', '70', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('approver', 'batchgr', 'approve', 'provapprover', '90', NULL, '[caption:''Approve'', confirm:''Approve record?'', messagehandler:''rptmessage:sign'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provapprover', 'batchgr', 'backforprovapproval', 'approver', '95', NULL, '[caption:''Cancel Posting'', confirm:''Cancel posting record?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provapprover', 'batchgr', 'completed', 'end', '100', NULL, '[caption:''Approved'', visible:false]', NULL, NULL, NULL)
go




/* 255-03018 */

/*==================================================
**
** ONLINE BATCH GR 
**
===================================================*/
select * into zz_tmp_batchgr  from batchgr
go

select * into zz_tmp_batchgr_item  from batchgr_item
go


if exists(select * from sysobjects where id = object_id('vw_batchgr')) 
begin 
  drop view vw_batchgr
end 
go 


if exists(select * from sysobjects where id = object_id('batchgr_log')) 
begin 
  drop table batchgr_log
end 
go 

if exists(select * from sysobjects where id = object_id('batchgr_error')) 
begin 
  drop table batchgr_error
end 
go 

if exists(select * from sysobjects where id = object_id('batchgr_forprocess')) 
begin 
  drop table batchgr_forprocess
end 
go 

if exists(select * from sysobjects where id = object_id('batchgr_task')) 
begin 
  drop table batchgr_task
end 
go 


if exists(select * from sysobjects where id = object_id('batchgr_item')) 
begin 
  drop table batchgr_item
end 
go 


if exists(select * from sysobjects where id = object_id('batchgr')) 
begin 
  drop table batchgr
end 
go 





create table batchgr (
  objid varchar(50) not null,
  state varchar(50) not null,
  ry int not null,
  txntype_objid varchar(5) not null,
  txnno varchar(25) not null,
  txndate datetime not null,
  effectivityyear int not null,
  effectivityqtr int not null,
  memoranda varchar(255) not null,
  originlguid varchar(50) not null,
  lguid varchar(50) not null,
  barangayid varchar(50) not null,
  rputype varchar(15) default null,
  classificationid varchar(50) default null,
  section varchar(10) default null,
  primary key (objid)
)
go 

create index ix_state on batchgr(state)
go
create index ix_ry on batchgr(ry)
go
create index ix_txnno on batchgr(txnno)
go
create index ix_lguid on batchgr(lguid)
go
create index ix_barangayid on batchgr(barangayid)
go
create index ix_classificationid on batchgr(classificationid)
go
create index ix_section on batchgr(section)
go

alter table batchgr 
add constraint fk_batchgr_lguid foreign key(lguid) 
references sys_org(objid)
go

alter table batchgr 
add constraint fk_batchgr_barangayid foreign key(barangayid) 
references sys_org(objid)
go

alter table batchgr 
add constraint fk_batchgr_classificationid foreign key(classificationid) 
references propertyclassification(objid)
go


create table batchgr_item (
  objid varchar(50) not null,
  parent_objid varchar(50) not null,
  state varchar(50) not null,
  rputype varchar(15) not null,
  tdno varchar(50) not null,
  fullpin varchar(50) not null,
  pin varchar(50) not null,
  suffix int not null,
  subsuffix int null,
  newfaasid varchar(50) default null,
  error text,
  primary key (objid)
) 
go

create index ix_parent_objid on batchgr_item(parent_objid)
go
create index ix_tdno on batchgr_item(tdno)
go
create index ix_pin on batchgr_item(pin)
go
create index ix_newfaasid on batchgr_item(newfaasid)
go

alter table batchgr_item 
add constraint fk_batchgr_item_batchgr foreign key(parent_objid) 
references batchgr(objid)
go

alter table batchgr_item 
add constraint fk_batchgr_item_faas foreign key(newfaasid) 
references faas(objid)
go

create table batchgr_task (
  objid varchar(50) not null,
  refid varchar(50) default null,
  parentprocessid varchar(50) default null,
  state varchar(50) default null,
  startdate datetime default null,
  enddate datetime default null,
  assignee_objid varchar(50) default null,
  assignee_name varchar(100) default null,
  assignee_title varchar(80) default null,
  actor_objid varchar(50) default null,
  actor_name varchar(100) default null,
  actor_title varchar(80) default null,
  message varchar(255) default null,
  signature text,
  returnedby varchar(100) default null,
  primary key (objid)
)
go 

create index ix_assignee_objid on batchgr_task(assignee_objid)
go
create index ix_refid on batchgr_task(refid)
go

alter table batchgr_task 
add constraint fk_batchgr_task_batchgr foreign key(refid) 
references batchgr(objid)
go


create view vw_batchgr 
as 
select 
  bg.*,
  l.name as lgu_name,
  b.name as barangay_name,
  pc.name as classification_name,
  t.objid AS taskid,
  t.state AS taskstate,
  t.assignee_objid 
from batchgr bg
inner join sys_org l on bg.lguid = l.objid 
left join sys_org b on bg.barangayid = b.objid
left join propertyclassification pc on bg.classificationid = pc.objid 
left join batchgr_task t on bg.objid = t.refid  and t.enddate is null 
go








/*===========================================
*
*  ENTITY MAPPING (PROVINCE)
*
============================================*/
if exists(select * from sysobjects where id = object_id('entity_mapping')) 
begin 
  drop table entity_mapping
end 
go 

CREATE TABLE entity_mapping (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  org_objid varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go

if exists(select * from sysobjects where id = object_id('vw_entity_mapping')) 
begin 
  drop view vw_entity_mapping
end 
go 

create view vw_entity_mapping
as 
select 
  r.*,
  e.entityno,
  e.name, 
  e.address_text as address_text,
  a.province as address_province,
  a.municipality as address_municipality
from entity_mapping r 
inner join entity e on r.objid = e.objid 
left join entity_address a on e.address_objid = a.objid
left join sys_org b on a.barangay_objid = b.objid 
left join sys_org m on b.parent_objid = m.objid 
go



/*===========================================
*
*  CERTIFICATION UPDATES
*
============================================*/
if exists(select * from sysobjects where id = object_id('vw_rptcertification_item')) 
begin 
  drop view vw_rptcertification_item
end 
go 

create view vw_rptcertification_item
as 
SELECT 
  rci.rptcertificationid,
  f.objid as faasid,
  f.fullpin, 
  f.tdno,
  e.objid as taxpayerid,
  e.name as taxpayer_name, 
  f.owner_name, 
  f.administrator_name,
  f.titleno,  
  f.rpuid, 
  pc.code AS classcode, 
  pc.name AS classname,
  so.name AS lguname,
  b.name AS barangay, 
  r.rputype, 
  r.suffix,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalav,
  r.totalmv, 
  rp.street,
  rp.blockno,
  rp.cadastrallotno,
  rp.surveyno,
  r.taxable,
  f.effectivityyear,
  f.effectivityqtr
FROM rptcertificationitem rci 
  INNER JOIN faas f ON rci.refid = f.objid 
  INNER JOIN rpu r ON f.rpuid = r.objid 
  INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
  INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
  INNER JOIN barangay b ON rp.barangayid = b.objid 
  INNER JOIN sys_org so on f.lguid = so.objid 
  INNER JOIN entity e on f.taxpayer_objid = e.objid 
go




/*===========================================
*
*  SUBDIVISION ASSISTANCE
*
============================================*/
if exists(select * from sysobjects where id = object_id('subdivision_assist_item')) 
begin 
  drop view subdivision_assist_item
end 
go 

if exists(select * from sysobjects where id = object_id('subdivision_assist')) 
begin 
  drop view subdivision_assist
end 
go 




CREATE TABLE subdivision_assist (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  taskstate varchar(50) NOT NULL,
  assignee_objid varchar(50) NOT NULL,
  PRIMARY KEY (objid)
)
go

alter table subdivision_assist 
add constraint fk_subdivision_assist_subdivision foreign key(parent_objid)
references subdivision(objid)
go

alter table subdivision_assist 
add constraint fk_subdivision_assist_user foreign key(assignee_objid)
references sys_user(objid)
go

create index ix_parent_objid on subdivision_assist(parent_objid)
go

create index ix_assignee_objid on subdivision_assist(assignee_objid)
go

create unique index ux_parent_assignee on subdivision_assist(parent_objid, taskstate, assignee_objid)
go


CREATE TABLE subdivision_assist_item (
  objid varchar(50) NOT NULL,
  subdivision_objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  pintype varchar(10) NOT NULL,
  section varchar(5) NOT NULL,
  startparcel int NOT NULL,
  endparcel int NOT NULL,
  parcelcount int NOT NULL,
  parcelcreated int NULL,
  PRIMARY KEY (objid)
)
go

alter table subdivision_assist_item 
add constraint fk_subdivision_assist_item_subdivision foreign key(subdivision_objid)
references subdivision(objid)
go

alter table subdivision_assist_item 
add constraint fk_subdivision_assist_item_subdivision_assist foreign key(parent_objid)
references subdivision_assist(objid)
go

create index ix_subdivision_objid on subdivision_assist_item(subdivision_objid)
go

create index ix_parent_objid on subdivision_assist_item(parent_objid)
go





/*==================================================
**
** REALTY TAX CREDIT
**
===================================================*/

if exists(select * from sysobjects where id = object_id('rpttaxcredit')) 
begin 
  drop view rpttaxcredit
end 
go 


CREATE TABLE rpttaxcredit (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  type varchar(25) NOT NULL,
  txnno varchar(25) DEFAULT NULL,
  txndate datetime DEFAULT NULL,
  reftype varchar(25) DEFAULT NULL,
  refid varchar(50) DEFAULT NULL,
  refno varchar(25) NOT NULL,
  refdate date NOT NULL,
  amount decimal(16,2) NOT NULL,
  amtapplied decimal(16,2) NOT NULL,
  rptledger_objid varchar(50) NOT NULL,
  srcledger_objid varchar(50) DEFAULT NULL,
  remarks varchar(255) DEFAULT NULL,
  approvedby_objid varchar(50) DEFAULT NULL,
  approvedby_name varchar(150) DEFAULT NULL,
  approvedby_title varchar(75) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go


create index ix_state on rpttaxcredit(state)
go

create index ix_type on rpttaxcredit(type)
go

create unique index ux_txnno on rpttaxcredit(txnno)
go

create index ix_reftype on rpttaxcredit(reftype)
go

create index ix_refid on rpttaxcredit(refid)
go

create index ix_refno on rpttaxcredit(refno)
go

create index ix_rptledger_objid on rpttaxcredit(rptledger_objid)
go

create index ix_srcledger_objid on rpttaxcredit(srcledger_objid)
go

alter table rpttaxcredit
add constraint fk_rpttaxcredit_rptledger foreign key (rptledger_objid)
references rptledger (objid)
go

alter table rpttaxcredit
add constraint fk_rpttaxcredit_srcledger foreign key (srcledger_objid)
references rptledger (objid)
go

alter table rpttaxcredit
add constraint fk_rpttaxcredit_sys_user foreign key (approvedby_objid)
references sys_user(objid)
go







/*==================================================
**
** MACHINE SMV
**
===================================================*/

CREATE TABLE machine_smv (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  machine_objid varchar(50) NOT NULL,
  expr varchar(255) NOT NULL,
  previd varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go

create index ix_parent_objid on machine_smv(parent_objid)
go
create index ix_machine_objid on machine_smv(machine_objid)
go
create index ix_previd on machine_smv(previd)
go
create unique index ux_parent_machine on machine_smv(parent_objid, machine_objid)
go



alter table machine_smv
add constraint fk_machinesmv_machrysetting foreign key (parent_objid)
references machrysetting (objid)
go

alter table machine_smv
add constraint fk_machinesmv_machine foreign key (machine_objid)
references machine(objid)
go


alter table machine_smv
add constraint fk_machinesmv_machinesmv foreign key (previd)
references machine_smv(objid)
go


create view vw_machine_smv 
as 
select 
  ms.*, 
  m.code,
  m.name
from machine_smv ms 
inner join machine m on ms.machine_objid = m.objid 
go


alter table machdetail add smvid varchar(50)
go 
alter table machdetail add params text
go

update machdetail set params = '[]' where params is null
go

create index ix_smvid on machdetail(smvid)
go


alter table machdetail 
add constraint fk_machdetail_machine_smv foreign key(smvid)
references machine_smv(objid)
go 





/*==================================================
**
** SUBDIVISION AFFECTED RPUS TXNTYPE (DP)
**
===================================================*/

INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('faas_affected_rpu_txntype_dp', '0', 'Set affected improvements FAAS txntype to DP e.g. SD and CS', 'checkbox', 'ASSESSOR')
go









