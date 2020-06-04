DROP TABLE batchgr_item
go 

DROP TABLE batchgr_task
go 

DROP TABLE batchgr
go 

CREATE TABLE batchgr (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  ry int NOT NULL,
  lgu_objid varchar(50) NOT NULL,
  barangay_objid varchar(50) NOT NULL,
  rputype varchar(15) DEFAULT NULL,
  classification_objid varchar(50) DEFAULT NULL,
  section varchar(10) DEFAULT NULL,
  memoranda varchar(100) DEFAULT NULL,
  txntype_objid varchar(50) DEFAULT NULL,
  txnno varchar(25) DEFAULT NULL,
  txndate datetime DEFAULT NULL,
  effectivityyear int DEFAULT NULL,
  effectivityqtr int DEFAULT NULL,
  originlgu_objid varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 


 create index ix_barangay_objid on batchgr(barangay_objid)
 go
 create index ix_state on batchgr(state)
 go
 create index fk_lgu_objid on batchgr(lgu_objid)
 go
 create index ix_ry on batchgr(ry)
 go
 create index ix_txnno on batchgr(txnno)
 go
 create index ix_classificationid on batchgr(classification_objid)
 go
 create index ix_section on batchgr(section)
 go


  alter table batchgr add CONSTRAINT fk_batchgr_barangayid FOREIGN KEY (barangay_objid) REFERENCES sys_org (objid)
  go 
  alter table batchgr add CONSTRAINT fk_batchgr_classificationid FOREIGN KEY (classification_objid) REFERENCES propertyclassification (objid)
  go 
  alter table batchgr add CONSTRAINT fk_batchgr_lguid FOREIGN KEY (lgu_objid) REFERENCES sys_org (objid)
  go 




  CREATE TABLE batchgr_item (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  state varchar(50) NOT NULL,
  rputype varchar(15) NOT NULL,
  tdno varchar(50) NOT NULL,
  fullpin varchar(50) NOT NULL,
  pin varchar(50) NOT NULL,
  suffix int NOT NULL,
  newfaasid varchar(50) DEFAULT NULL,
  error text,
  subsuffix int DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 

create index fk_batchgr_item_batchgr on batchgr_item (parent_objid)
go 
create index fk_batchgr_item_newfaasid on batchgr_item (newfaasid)
go 
create index fk_batchgr_item_tdno on batchgr_item (tdno)
go 
create index fk_batchgr_item_pin on batchgr_item (pin)
go 
  
alter table batchgr_item add CONSTRAINT fk_batchgr_item_batchgr FOREIGN KEY (parent_objid) REFERENCES batchgr (objid)
go
alter table batchgr_item add CONSTRAINT fk_batchgr_item_faas FOREIGN KEY (objid) REFERENCES faas (objid)
go
alter table batchgr_item add CONSTRAINT fk_batchgr_item_newfaasid FOREIGN KEY (newfaasid) REFERENCES faas (objid)
go
alter table batchgr_item add CONSTRAINT fk_batchgr_item_objid FOREIGN KEY (objid) REFERENCES faas (objid)
go


CREATE TABLE batchgr_task (
  objid varchar(50) NOT NULL,
  refid varchar(50) DEFAULT NULL,
  parentprocessid varchar(50) DEFAULT NULL,
  state varchar(50) DEFAULT NULL,
  startdate datetime DEFAULT NULL,
  enddate datetime DEFAULT NULL,
  assignee_objid varchar(50) DEFAULT NULL,
  assignee_name varchar(100) DEFAULT NULL,
  assignee_title varchar(80) DEFAULT NULL,
  actor_objid varchar(50) DEFAULT NULL,
  actor_name varchar(100) DEFAULT NULL,
  actor_title varchar(80) DEFAULT NULL,
  message varchar(255) DEFAULT NULL,
  signature text,
  returnedby varchar(100) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 

create index ix_assignee_objid on batchgr_task(assignee_objid)
go 
create index ix_refid on batchgr_task(refid)
go 

alter table batchgr_task add CONSTRAINT fk_batchgr_task_batchgr FOREIGN KEY (refid) REFERENCES batchgr (objid)
go 