if object_id('dbo.ztmp_sys_rule', 'U') IS NOT NULL 
   drop table dbo.ztmp_sys_rule; 
go
select * 
into ztmp_sys_rule 
from sys_rule 
where name in (
	'ACTIVATE_OCCUPANCY_RPU',
	'POST_RPT_PAYMENT',
	'ACTIVATE_OCCUPANCY_RPU',
	'VALIDATE_BEFORE_INSPECTION',
	'VALIDATE_UNCOMPLETED_TASKITEMS',
	'CHECK_HAS_FINDINGS',
	'CHECK_HAS_REQUIREMENTS_REVISION',
	'ACCEPT_APPLICATION',
	'REQUIREMENT_REVISION',
	'REACTIVATE_TASKITEMS',
	'ACTIVATE_TASKITEMS',
	'TASKITEM_CHECK_HAS_FINDINGS',
	'SEND_PAYMENT_ORDER',
	'VALIDATE_ASSESSMENT',
	'VALIDATE_BUILDING_RPT_DOCS',
	'TASKITEM_BEFORE_APPROVAL',
	'ISSUE_DOCS_AFTER_PAYMENT',
	'EVALUATION_REVISION',
	'SEND_BUILDING_PERMIT_DOCS',
	'VALIDATE_DOCS_BEFORE_RELEASE',
	'INSPECTION_REVISION',
	'TASKITEMS_JOINSTATE'
	) 
go 
delete from sys_rule_deployed where objid in (
	select objid from ztmp_sys_rule 
)
go 
update aa set 
	aa.state = 'DRAFT' 
from sys_rule aa, ztmp_sys_rule bb 
where aa.objid = bb.objid 
go 
drop table ztmp_sys_rule
go 



if object_id('dbo.ztmp_sys_rule', 'U') IS NOT NULL 
   drop table dbo.ztmp_sys_rule; 
go
select * 
into ztmp_sys_rule 
from sys_rule 
where name in (
		'ADD_RPU_FACTS',
		'RPT_ENTRY_FEE',
		'COMPUTE_FSIC',
		'COMPUTE_BFP_SALES_TAX',
		'ADD_BFP_SALES_TAX',
		'FINAL_ELECTRICAL_INSPECTION_FEE'
	) 
go 
delete from sys_rule_deployed where objid in (
	select objid from ztmp_sys_rule 
)
go 
update aa set 
	aa.state = 'DRAFT' 
from sys_rule aa, ztmp_sys_rule bb 
where aa.objid = bb.objid 
go 
drop table ztmp_sys_rule
go 
