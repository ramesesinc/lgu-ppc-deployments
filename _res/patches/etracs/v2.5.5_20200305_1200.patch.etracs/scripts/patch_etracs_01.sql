
alter table af alter column [denomination] decimal(10,2) NOT NULL
go 

CREATE TABLE [dbo].[cashreceipt_group] ( 
   [objid] varchar(50) NOT NULL, 
   [txndate] datetime NOT NULL, 
   [controlid] varchar(50) NOT NULL, 
   [amount] decimal(16,2) NOT NULL, 
   [totalcash] decimal(16,2) NOT NULL, 
   [totalnoncash] decimal(16,2) NOT NULL, 
   [cashchange] decimal(16,2) NOT NULL,
   CONSTRAINT [pk_cashreceipt_group] PRIMARY KEY ([objid])
) 
GO 

CREATE TABLE [dbo].[cashreceipt_groupitem] ( 
   [objid] varchar(50) NOT NULL, 
   [parentid] varchar(50) NOT NULL,
   CONSTRAINT [pk_cashreceipt_groupitem] PRIMARY KEY ([objid])
) 
GO 

alter table checkpayment alter column split int not null 
go 

alter table checkpayment_deadchecks alter column split int not null 
go 

alter table collectiongroup_account alter column [sortorder] int NOT NULL
go 


alter table collectiontype add [info] text NULL
go 


alter table collectionvoucher alter column [amount] decimal(18,2) NOT NULL 
go 
alter table collectionvoucher alter column [totalcash] decimal(18,2) NOT NULL 
go 
alter table collectionvoucher alter column [totalcheck] decimal(18,2) NOT NULL 
go 
alter table collectionvoucher alter column [totalcr] decimal(18,2) NOT NULL 
go 


alter table collectionvoucher_fund alter column [amount] decimal(16,4) NOT NULL
go 
alter table collectionvoucher_fund alter column [totalcash] decimal(16,4) NOT NULL
go 
alter table collectionvoucher_fund alter column [totalcheck] decimal(16,4) NOT NULL
go 
alter table collectionvoucher_fund alter column [totalcr] decimal(16,4) NOT NULL
go 


drop index ix_state on depositvoucher
go 
alter table depositvoucher alter column state varchar(50) NOT NULL 
go 
create index ix_state on depositvoucher (state) 
go 


drop index ix_controldate on  depositvoucher
go 
alter table depositvoucher alter column [controldate] date NOT NULL
go 
create index ix_controldate on  depositvoucher (controldate)
go 

drop index ix_controlno on depositvoucher
go 
drop index uix_controlno on depositvoucher
go 
alter table depositvoucher alter column [controlno] varchar(50) NOT NULL
go 
create unique index uix_controlno on depositvoucher (controlno)
go 

alter table depositvoucher alter column [amount] decimal(16,4) NOT NULL
go 

drop index ix_dtcreated on depositvoucher
go 
alter table depositvoucher alter column [dtcreated] datetime NOT NULL
go 
create index ix_dtcreated on depositvoucher (dtcreated)
go 

drop index ix_createdby_objid on depositvoucher
go 
alter table depositvoucher alter column [createdby_objid] varchar(50) NOT NULL
go 
create index ix_createdby_objid on depositvoucher (createdby_objid)
go 

drop index ix_createdby_name on  depositvoucher 
go 
alter table depositvoucher alter column [createdby_name] varchar(255) NOT NULL
go 
create index ix_createdby_name on  depositvoucher (createdby_name)
go 


drop index ix_state on  depositvoucher_fund 
go 
alter table depositvoucher_fund alter column [state] varchar(20) NOT NULL
go 
create index ix_state on  depositvoucher_fund (state) 
go 

drop index ix_fundid on depositvoucher_fund
go 
drop index uix_parentid_fundid on depositvoucher_fund
go 
alter table depositvoucher_fund alter column [fundid] varchar(100) NOT NULL
go 
create index ix_fundid on depositvoucher_fund (fundid)
go 
create unique index uix_parentid_fundid on depositvoucher_fund (parentid, fundid, ukey)
go 

alter table depositvoucher_fund alter column [amount] decimal(16,4) NOT NULL
go 
alter table depositvoucher_fund alter column [amountdeposited] decimal(16,4) NOT NULL
go 

update depositvoucher_fund set totaldr = 0 where totaldr is null 
go 
alter table depositvoucher_fund alter column [totaldr] decimal(16,4) NOT NULL
go 

update depositvoucher_fund set totalcr = 0 where totalcr is null 
go 
alter table depositvoucher_fund alter column [totalcr] decimal(16,4) NOT NULL
go 


drop index ix_state on eftpayment
go 
alter table eftpayment alter column [state] varchar(50) NOT NULL
go 
create index ix_state on eftpayment (state)
go 

drop index ix_refno on eftpayment
go 
alter table eftpayment alter column [refno] varchar(50) NOT NULL
go 
create index ix_refno on eftpayment (refno) 
go 

drop index ix_refdate on eftpayment
go 
alter table eftpayment alter column [refdate] date NOT NULL
go 
create index ix_refdate on eftpayment (refdate) 
go 

alter table eftpayment alter column [amount] decimal(16,4) NOT NULL
go 

drop index ix_bankacctid on eftpayment
go 
alter table eftpayment alter column [bankacctid] varchar(50) NOT NULL
go 
create index ix_bankacctid on eftpayment (bankacctid)
go 

drop index ix_createdby_objid on eftpayment
go 
alter table eftpayment alter column [createdby_objid] varchar(50) NOT NULL
go 
create index ix_createdby_objid on eftpayment (createdby_objid)
go 

alter table eftpayment alter column [createdby_name] varchar(255) NOT NULL
go 


alter table entity alter column email varchar(255) null 
go 

drop index ix_state on entity 
go 
drop index ix_entityname_state on entity 
go 
alter table entity alter column [state] varchar(25) NOT NULL
go 
create index ix_state on entity (state) 
go 
create index ix_entityname_state on entity (entityname, state) 
go 


CREATE TABLE [dbo].[entity_mapping] ( 
   [objid] varchar(50) NOT NULL, 
   [parent_objid] varchar(50) NOT NULL, 
   [org_objid] varchar(50) NULL,
   CONSTRAINT [pk_entity_mapping] PRIMARY KEY ([objid])
) 
GO 

CREATE TABLE [dbo].[entity_photo] ( 
   [objid] nvarchar(50) NOT NULL, 
   [entityid] varchar(50) NOT NULL, 
   [dtfiled] datetime NULL, 
   [createdby_objid] varchar(50) NULL, 
   [createdby_name] varchar(160) NULL, 
   [image] nvarchar(MAX) NULL, 
   [thumbnail] nvarchar(MAX) NULL,
   CONSTRAINT [pk_entity_photo] PRIMARY KEY ([objid])
) 
GO 

CREATE TABLE [dbo].[entityidcard] ( 
   [objid] varchar(50) NOT NULL, 
   [entityid] varchar(50) NOT NULL, 
   [idtype] varchar(50) NOT NULL, 
   [idno] varchar(25) NOT NULL, 
   [expiry] varchar(50) NULL,
   CONSTRAINT [pk_entityidcard] PRIMARY KEY ([objid])
) 
GO 


drop index ix_lfname on entityindividual
go 
alter table entityindividual alter column [lastname] varchar(100) NOT NULL
go 
create index ix_lfname on entityindividual (lastname, firstname)
go 
create index ix_lastname on entityindividual (lastname)
go 

drop index ix_lfname on entityindividual
go 
drop index ix_fname on entityindividual
go 
alter table entityindividual alter column [firstname] varchar(100) NOT NULL
go 
create index ix_lfname on entityindividual (lastname, firstname)
go 
create index ix_firstname on entityindividual (firstname)
go 


drop index uix_title on fundgroup 
go 
alter table fundgroup alter column [title] varchar(100) NOT NULL
go 
create unique index uix_title on fundgroup (title) 
go 


alter table income_summary alter column [remittanceid] varchar(50) NOT NULL 
go 
alter table income_summary alter column [liquidationid] varchar(50) NOT NULL 
go 
alter table income_summary add default ('') for remittanceid 
go 
alter table income_summary add default ('') for liquidationid 
go 


drop index ix_fundid on jev 
go 
alter table jev alter column [fundid] varchar(100) NOT NULL
go 
create index ix_fundid on jev (fundid)
go 


alter table lob alter column [state] varchar(25) NOT NULL
go 

alter table lobclassification alter column [state] varchar(25) NOT NULL
go 


DROP TABLE [dbo].[paymentorder]
GO 

CREATE TABLE [dbo].[paymentorder] (
[objid] varchar(50) NOT NULL ,
[txndate] datetime NULL ,
[payer_objid] varchar(50) NULL ,
[payer_name] varchar(MAX) NULL ,
[paidby] varchar(MAX) NULL ,
[paidbyaddress] varchar(150) NULL ,
[particulars] varchar(MAX) NULL ,
[amount] decimal(16,2) NULL ,
[txntype] varchar(50) NULL ,
[expirydate] date NULL ,
[refid] varchar(50) NULL ,
[refno] varchar(50) NULL ,
[info] varchar(MAX) NULL ,
[txntypename] varchar(255) NULL ,
[locationid] varchar(50) NULL ,
[origin] varchar(50) NULL ,
[issuedby_objid] varchar(50) NULL ,
[issuedby_name] varchar(150) NULL ,
[org_objid] varchar(50) NULL ,
[org_name] varchar(255) NULL ,
[items] text NULL ,
[collectiontypeid] varchar(50) NULL ,
[queueid] varchar(50) NULL ,
CONSTRAINT [pk_paymentorder] PRIMARY KEY ([objid])
)
GO
CREATE INDEX [ix_collectiontypeid] ON [dbo].[paymentorder]
([collectiontypeid] ASC) 
GO
CREATE INDEX [ix_locationid] ON [dbo].[paymentorder]
([locationid] ASC) 
GO
CREATE INDEX [ix_issuedby_objid] ON [dbo].[paymentorder]
([issuedby_objid] ASC) 
GO
CREATE INDEX [ix_issuedby_name] ON [dbo].[paymentorder]
([issuedby_name] ASC) 
GO
CREATE INDEX [ix_org_objid] ON [dbo].[paymentorder]
([org_objid] ASC) 
GO
CREATE INDEX [ix_org_name] ON [dbo].[paymentorder]
([org_name] ASC) 
GO



drop index ix_liquidationid on remittance
go
alter table remittance drop constraint fk_remittance_liquidationid 
go 
alter table remittance drop column liquidationid
go 




drop table sync_data_pending 
go 
drop table sync_data_forprocess
go 
drop table sync_data
go 

CREATE TABLE [dbo].[sync_data] (
[objid] varchar(50) NOT NULL ,
[parentid] varchar(50) NOT NULL ,
[refid] varchar(50) NOT NULL ,
[reftype] varchar(50) NOT NULL ,
[action] varchar(50) NOT NULL ,
[orgid] varchar(50) NULL ,
[remote_orgid] varchar(50) NULL ,
[remote_orgcode] varchar(20) NULL ,
[remote_orgclass] varchar(20) NULL ,
[dtfiled] datetime NOT NULL ,
[idx] int NOT NULL ,
[sender_objid] varchar(50) NULL ,
[sender_name] varchar(150) NULL ,
[refno] varchar(50) NULL ,
CONSTRAINT [pk_sync_data] PRIMARY KEY ([objid])
)
GO
CREATE INDEX [ix_sync_data_refid] ON [dbo].[sync_data]
([refid] ASC) 
GO
CREATE INDEX [ix_sync_data_reftype] ON [dbo].[sync_data]
([reftype] ASC) 
GO
CREATE INDEX [ix_sync_data_orgid] ON [dbo].[sync_data]
([orgid] ASC) 
GO
CREATE INDEX [ix_sync_data_dtfiled] ON [dbo].[sync_data]
([dtfiled] ASC) 
GO


CREATE TABLE [dbo].[sync_data_forprocess] (
[objid] varchar(50) NOT NULL ,
CONSTRAINT [pk_sync_data_forprocess] PRIMARY KEY ([objid]) ,
CONSTRAINT [fk_sync_data_forprocess_sync_data] FOREIGN KEY ([objid]) REFERENCES [dbo].[sync_data] ([objid]) 
)
GO

CREATE TABLE [dbo].[sync_data_pending] (
[objid] varchar(50) NOT NULL ,
[error] text NULL ,
[expirydate] datetime NULL ,
CONSTRAINT [pk_sync_data_pending] PRIMARY KEY ([objid]),
CONSTRAINT [fk_sync_data_pending_sync_data] FOREIGN KEY ([objid]) REFERENCES [dbo].[sync_data] ([objid]) 
)
GO
CREATE INDEX [ix_expirydate] ON [dbo].[sync_data_pending]
([expirydate] ASC) 
GO



alter table sys_rule alter column [state] varchar(25) not null 
go 

drop index rulegroup on sys_rule 
go 
alter table sys_rule alter column [rulegroup] varchar(50) not NULL
go 
create index ix_rulegroup on sys_rule (rulegroup) 
go 

alter table sys_rule alter column [title] varchar(250) not NULL
go 
alter table sys_rule alter column [salience] int not NULL 
go 
alter table sys_rule add DEFAULT ('0') for [salience]
go 
alter table sys_rule add DEFAULT ('1') for [noloop]
go 


drop index parentid on sys_rule_actiondef_param
go 
alter table sys_rule_actiondef_param alter column [parentid] varchar(50) NOT NULL
go 
create index ix_parentid on sys_rule_actiondef_param (parentid) 
go 


drop index ix_parentid on sys_rule_condition_constraint
go 
alter table sys_rule_condition_constraint alter column [parentid] varchar(50) NOT NULL
go 
create index ix_parentid on sys_rule_condition_constraint (parentid) 
go 


drop index ix_parentid on sys_rule_fact_field
go 
alter table sys_rule_fact_field alter column [parentid] varchar(50) NOT NULL
go 
create index ix_parentid on sys_rule_fact_field (parentid) 
go 


CREATE INDEX [ix_allocid] ON [af_control] ([allocid])
GO

CREATE INDEX [ix_state] ON [af_control] ([state])
GO

CREATE UNIQUE INDEX [uix_af_control] ON [af_control] ([afid],[startseries],[prefix],[suffix],[ukey])
GO

CREATE INDEX [ix_respcenter_objid] ON [afrequest] ([respcenter_objid])
GO

CREATE INDEX [ix_org_name] ON [afrequest] ([org_name])
GO

CREATE INDEX [ix_respcenter_objid] ON [aftxn] ([respcenter_objid])
GO

CREATE INDEX [ix_issueto_name] ON [aftxn] ([issueto_name])
GO

CREATE INDEX [ix_txndate] ON [cashreceipt_group] ([txndate])
GO

CREATE INDEX [ix_controlid] ON [cashreceipt_group] ([controlid])
GO

CREATE INDEX [ix_parentid] ON [cashreceipt_groupitem] ([parentid])
GO



if object_id('dbo.ztmp_fix_cashreceiptvoid', 'U') IS NOT NULL 
	drop table dbo.ztmp_fix_cashreceiptvoid; 
go 
select t1.*, 
	(select top 1 objid from cashreceipt_void where receiptid = t1.receiptid order by txndate) as objid  
into ztmp_fix_cashreceiptvoid 
from ( 
	select receiptid, count(*) as icount 
	from cashreceipt_void 
	group by receiptid 
	having count(*) > 1
)t1 
go 
delete from cashreceipt_void where objid in ( 
	select v.objid 
	from cashreceipt_void v, ztmp_fix_cashreceiptvoid z 
	where v.receiptid = z.receiptid  
		and v.objid <> z.objid 
)
go 
drop table ztmp_fix_cashreceiptvoid
go 

CREATE UNIQUE INDEX [uix_receiptid] ON [cashreceipt_void] ([receiptid])
GO




CREATE INDEX [ix_state] ON [checkpayment_deadchecks] ([state])
GO

CREATE INDEX [ix_subcollector_name] ON [checkpayment_deadchecks] ([subcollector_name])
GO

CREATE UNIQUE INDEX [uix_name] ON [collectiontype] ([name])
go 

CREATE INDEX [ix_state] ON [depositslip] ([state])
go 

CREATE INDEX [ix_state] ON [draftremittance] ([state])
GO

CREATE INDEX [ix_receiptno] ON [eftpayment] ([receiptno])
GO


alter table entity add ukey varchar(50) not null default ''
go 
update entity set ukey = NEWID()
go 
CREATE UNIQUE INDEX [uix_entityno] ON [entity] ([entityno],[ukey])
GO


CREATE INDEX [FK_entitymember_entity] ON [entitymember] ([entityid])
GO

CREATE INDEX [ix_member_objid] ON [entitymember] ([member_objid])
GO


CREATE INDEX [ix_ifundid] ON [income_summary] ([fundid])
GO

CREATE INDEX [ix_generic] ON [itemaccount] ([generic])
GO

CREATE INDEX [ix_fund_objid] ON [itemaccount] ([fund_objid])
GO

CREATE INDEX [ix_liquidatingofficer_name] ON [remittance] ([liquidatingofficer_name])
GO

CREATE INDEX [ix_ruleset] ON [sys_rule] ([ruleset])
GO

CREATE INDEX [parentid] ON [sys_rule_condition] ([parentid])
GO

CREATE INDEX [fact_objid] ON [sys_rule_condition] ([fact_objid])
GO

CREATE INDEX [ix_ruleset] ON [sys_rulegroup] ([ruleset])
GO

CREATE UNIQUE INDEX [uix_ruleset_name] ON [sys_rulegroup] ([ruleset],[name])
GO

CREATE INDEX [ix_ruleset] ON [sys_ruleset_actiondef] ([ruleset])
GO

CREATE INDEX [ix_actiondef] ON [sys_ruleset_actiondef] ([actiondef])
GO

CREATE UNIQUE INDEX [uix_ruleset_actiondef] ON [sys_ruleset_actiondef] ([ruleset],[actiondef])
GO

CREATE INDEX [ix_ruleset] ON [sys_ruleset_fact] ([ruleset])
GO

CREATE INDEX [ix_rulefact] ON [sys_ruleset_fact] ([rulefact])
GO

CREATE UNIQUE INDEX [uix_ruleset_rulefact] ON [sys_ruleset_fact] ([ruleset],[rulefact])
GO

ALTER TABLE [af_control] ADD CONSTRAINT [fk_af_control_fund_objid] 
	FOREIGN KEY ([fund_objid]) REFERENCES [fund] ([objid])
GO

ALTER TABLE [af_control_detail] ADD CONSTRAINT [fk_af_control_detail_aftxnitemid] 
	FOREIGN KEY ([aftxnitemid]) REFERENCES [aftxnitem] ([objid])
GO

ALTER TABLE [afrequestitem] ADD CONSTRAINT [fk_afrequestitem_parentid] 
	FOREIGN KEY ([parentid]) REFERENCES [afrequest] ([objid])
GO

ALTER TABLE [batchcapture_collection_entry_item] ADD CONSTRAINT [fk_batchcapture_collection_entry_fund_objid] 
	FOREIGN KEY ([fund_objid]) REFERENCES [fund] ([objid])
GO

ALTER TABLE [batchcapture_collection_entry_item] ADD CONSTRAINT [fk_batchcapture_collection_entry_item_item_objid] 
	FOREIGN KEY ([item_objid]) REFERENCES [itemaccount] ([objid])
GO


ALTER TABLE [cashreceipt_groupitem] ADD CONSTRAINT [fk_cashreceipt_groupitem_parentid] 
	FOREIGN KEY ([parentid]) REFERENCES [cashreceipt_group] ([objid])
GO

ALTER TABLE [cashreceipt_groupitem] ADD CONSTRAINT [fk_cashreceipt_groupitem_objid] 
	FOREIGN KEY ([objid]) REFERENCES [cashreceipt] ([objid])
GO


ALTER TABLE [cashreceiptpayment_noncash] ADD CONSTRAINT [fk_cashreceiptpayment_noncash_fund_objid] 
	FOREIGN KEY ([fund_objid]) REFERENCES [fund] ([objid])
GO

ALTER TABLE [cashreceiptpayment_noncash] ADD CONSTRAINT [fk_cashreceiptpayment_noncash_receiptid] 
	FOREIGN KEY ([receiptid]) REFERENCES [cashreceipt] ([objid])
GO

ALTER TABLE [checkpayment] ADD CONSTRAINT [fk_checkpayment_depositvoucherid] 
	FOREIGN KEY ([depositvoucherid]) REFERENCES [depositvoucher] ([objid])
GO

ALTER TABLE [checkpayment] ADD CONSTRAINT [fk_checkpayment_bankid] 
	FOREIGN KEY ([bankid]) REFERENCES [bank] ([objid])
GO

ALTER TABLE [checkpayment] ADD CONSTRAINT [fk_checkpayment_fundid] 
	FOREIGN KEY ([fundid]) REFERENCES [fund] ([objid])
GO


ALTER TABLE [checkpayment_deadchecks] ADD CONSTRAINT [fk_checkpayment_deadchecks_depositvoucherid] 
	FOREIGN KEY ([depositvoucherid]) REFERENCES [depositvoucher] ([objid])
GO

ALTER TABLE [checkpayment_deadchecks] ADD CONSTRAINT [fk_checkpayment_deadchecks_bankid] 
	FOREIGN KEY ([bankid]) REFERENCES [bank] ([objid])
GO

ALTER TABLE [checkpayment_deadchecks] ADD CONSTRAINT [fk_checkpayment_deadchecks_fundid] 
	FOREIGN KEY ([fundid]) REFERENCES [fund] ([objid])
GO


ALTER TABLE [collectionvoucher_fund] ADD CONSTRAINT [fk_collectionvoucher_fund_depositvoucherid] 
	FOREIGN KEY ([depositvoucherid]) REFERENCES [depositvoucher] ([objid])
GO

ALTER TABLE [depositslip] ADD CONSTRAINT [fk_depositslip_bankacctid] 
	FOREIGN KEY ([bankacctid]) REFERENCES [bankaccount] ([objid])
go 

ALTER TABLE [fund] ADD CONSTRAINT [fk_fund_groupid] 
	FOREIGN KEY ([groupid]) REFERENCES [fundgroup] ([objid])
GO

ALTER TABLE [interfund_transfer_ledger] ADD CONSTRAINT [fk_interfund_transfer_ledger_itemacctid] 
	FOREIGN KEY ([itemacctid]) REFERENCES [itemaccount] ([objid])
GO

ALTER TABLE [itemaccount] ADD CONSTRAINT [fk_itemaccount_parentid] 
	FOREIGN KEY ([parentid]) REFERENCES [itemaccount] ([objid])
GO

ALTER TABLE [jev] ADD CONSTRAINT [fk_jev_fundid] 
	FOREIGN KEY ([fundid]) REFERENCES [fund] ([objid])
GO

ALTER TABLE [lob_lobattribute] ADD CONSTRAINT [fk_lob_lobattribute_lobattributeid] 
	FOREIGN KEY ([lobattributeid]) REFERENCES [lobattribute] ([objid])
GO

ALTER TABLE [lob_lobattribute] ADD CONSTRAINT [fk_lob_lobattribute_lobid] 
	FOREIGN KEY ([lobid]) REFERENCES [lob] ([objid])
GO

ALTER TABLE [remittance_fund] ADD CONSTRAINT [fk_remittance_fund_remittanceid] 
	FOREIGN KEY ([remittanceid]) REFERENCES [remittance] ([objid])
GO
