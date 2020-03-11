DROP VIEW vw_batchgr 
go 

CREATE VIEW vw_batchgr 
AS 
select bg.objid AS objid,
bg.state AS state,
bg.ry AS ry,
bg.lgu_objid AS lgu_objid,
bg.barangay_objid AS barangay_objid,
bg.rputype AS rputype,
bg.classification_objid AS classification_objid,
bg.section AS section,
bg.memoranda AS memoranda,
bg.txntype_objid AS txntype_objid,
bg.txnno AS txnno,
bg.txndate AS txndate,
bg.effectivityyear AS effectivityyear,
bg.effectivityqtr AS effectivityqtr,
bg.originlgu_objid AS originlgu_objid,
l.name AS lgu_name,
b.name AS barangay_name,
pc.name AS classification_name,
t.objid AS taskid,
t.state AS taskstate,
t.assignee_objid AS assignee_objid 
from batchgr bg 
join sys_org l on bg.lgu_objid = l.objid
left join sys_org b on bg.barangay_objid = b.objid 
left join propertyclassification pc on bg.classification_objid = pc.objid
left join batchgr_task t on bg.objid = t.refid and isnull(t.enddate)
go 