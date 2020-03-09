-- 
-- NOTES: 
-- source db: etracs_vehicle;
-- target db: puerto_vehicle;
--
USE puerto_vehicle
GO

DELETE FROM puerto_vehicle.dbo.vehicletype_field; 
DELETE FROM puerto_vehicle.dbo.vehicletype; 

CREATE TABLE zz_vehicletype_field (
  name varchar(50) NOT NULL,
  caption varchar(100) NULL,
  datatype varchar(50) NULL,
  category varchar(100) NULL,
  sortorder int NULL,
  required int NULL,
  textwidth int NULL,
  constraint pk_zz_vehicletype_field PRIMARY KEY (name)
) 
GO 

INSERT INTO zz_vehicletype_field (name,caption,datatype,sortorder,required,textwidth) VALUES ('bodyno', 'Body No', 'text', 3, 1, 150);
INSERT INTO zz_vehicletype_field (name,caption,datatype,sortorder,required,textwidth) VALUES ('chassisno', 'Chassis No', 'text', 8,0,150);
INSERT INTO zz_vehicletype_field (name,caption,datatype,sortorder,required,textwidth) VALUES ('color', 'Color', 'text',6,	1,150);
INSERT INTO zz_vehicletype_field (name,caption,datatype,sortorder,required,textwidth) VALUES ('crname', 'CR Name', 'text',7,1,250);
INSERT INTO zz_vehicletype_field (name,caption,datatype,sortorder,required,textwidth) VALUES ('engineno', 'Engine No','text',2,1,150);
INSERT INTO zz_vehicletype_field (name,caption,datatype,sortorder,required,textwidth) VALUES ('make', 'Make', 'text',9,0,150);
INSERT INTO zz_vehicletype_field (name,caption,datatype,sortorder,required,textwidth) VALUES ('model', 'Model', 'text',10,0,150);
INSERT INTO zz_vehicletype_field (name,caption,datatype,sortorder,required,textwidth) VALUES ('plateno', 'Plate No', 'text',1,1,150);
INSERT INTO zz_vehicletype_field (name,caption,datatype,sortorder,required,textwidth) VALUES ('sidecarcolor', 'Sidecar Color','text',4,0,150);
INSERT INTO zz_vehicletype_field (name,caption,datatype,sortorder,required,textwidth) VALUES ('sidecarno', 'Sidecar No', 'text',5,0,150);


INSERT INTO puerto_vehicle.dbo.vehicletype 
(objid,title,controlpattern,indexno,appnopattern,icon,renewalfrequency,permitnopattern,maxunitperowner)
SELECT 
objid,title,controlpattern,indexno,appnopattern,icon,renewalfrequency,permitnopattern,10
FROM etracs_vehicle.dbo.vehicletype
;

INSERT INTO puerto_vehicle.dbo.vehicletype_field
(objid,vehicletypeid,name,caption,datatype,category,sortorder,required,textwidth)
SELECT 
( v.objid +'-'+ f.name ) AS objid, v.objid as vehciletypeid, f.* 
FROM etracs_vehicle.dbo.vehicletype v, etracs_vehicle.dbo.zz_vehicletype_field f
; 


INSERT INTO puerto_vehicle.dbo.vehicle_franchise 
(objid,state,controlno,vehicletypeid,nextfranchiserenewaldate)
SELECT 
controlno,state,controlno,vehicletypeid,renewaldate 
FROM etracs_vehicle.dbo.vehicle_franchise
;

INSERT INTO puerto_vehicle.dbo.vehicle_application 
(objid,franchiseid,appno,appyear,appdate,apptype,txnmode,dtcreated,createdby_objid,createdby_name,particulars)
SELECT va.objid,vf.controlno,va.appno,va.appyear,va.appdate,va.apptype,va.txnmode,
va.dtcreated,va.createdby_objid,va.createdby_name,va.particulars
FROM etracs_vehicle.dbo.vehicle_application va
INNER JOIN etracs_vehicle.dbo.vehicle_franchise vf ON va.controlid = vf.objid
;

INSERT INTO puerto_vehicle.dbo.vehicle_account
(objid,franchiseid,owner_objid,owner_name,owner_address_objid,owner_address_text)
SELECT va.objid,vf.controlno, va.owner_objid,va.owner_name,va.owner_address_objid,va.owner_address_text
FROM etracs_vehicle.dbo.vehicle_application va
INNER JOIN etracs_vehicle.dbo.vehicle_franchise vf ON va.controlid = vf.objid
;

UPDATE puerto_vehicle.dbo.vehicle_application SET acctid = objid
;

INSERT INTO puerto_vehicle.dbo.vehicle_application_task 
(taskid,refid,parentprocessid,state,startdate,enddate,assignee_objid,assignee_name,actor_objid,actor_name,message,dtcreated,prevtaskid)
SELECT taskid,refid,parentprocessid,state,startdate,enddate,assignee_objid,assignee_name,actor_objid,actor_name,message,dtcreated,prevtaskid
FROM etracs_vehicle.dbo.vehicle_application_task 
WHERE refid IN (SELECT objid FROM puerto_vehicle.dbo.vehicle_application)
;


UPDATE nva SET 
	nva.taskid = ova.taskid 
FROM puerto_vehicle.dbo.vehicle_application nva, etracs_vehicle.dbo.vehicle_application ova 
WHERE nva.objid = ova.objid
;

UPDATE vf SET 
	vf.acctid = va.acctid, vf.appid = va.objid  
FROM puerto_vehicle.dbo.vehicle_franchise vf, puerto_vehicle.dbo.vehicle_application va
WHERE vf.objid = va.franchiseid
;


DELETE FROM  puerto_vehicle.dbo.vehicle_itemaccount
;

INSERT INTO puerto_vehicle.dbo.vehicle_itemaccount
(objid,title,item_objid,item_code,item_title)
SELECT DISTINCT item_objid, item_title, item_objid, item_code, item_title
FROM etracs_vehicle.dbo.vehicle_application_fee
;

INSERT INTO puerto_vehicle.dbo.vehicle_application_fee (objid,appid,year,itemid,amount,amtpaid)
SELECT objid,parentid,year,item_objid,amount,amtpaid 
FROM etracs_vehicle.dbo.vehicle_application_fee
;

UPDATE vf SET 
	vf.year = va.appyear 
FROM puerto_vehicle.dbo.vehicle_application_fee vf, puerto_vehicle.dbo.vehicle_application va 
WHERE vf.appid = va.objid
;

INSERT INTO  puerto_vehicle.dbo.vehicle_unit (objid,franchiseid)
SELECT vu.objid, vf.controlno  
FROM etracs_vehicle.dbo.vehicle_application_unit vu
INNER JOIN etracs_vehicle.dbo.vehicle_application va ON vu.appid = va.objid 
INNER JOIN etracs_vehicle.dbo.vehicle_franchise vf ON va.controlid = vf.objid 
;

UPDATE nva SET 
	nva.unitid = vau.objid 
FROM puerto_vehicle.dbo.vehicle_application nva, 
	etracs_vehicle.dbo.vehicle_application_unit vau, 
	etracs_vehicle.dbo.vehicle_application va 
WHERE vau.appid = va.objid 
AND va.objid = nva.objid
;

UPDATE nvf SET 
	nvf.unitid = vau.objid 
FROM puerto_vehicle.dbo.vehicle_franchise nvf, 
	etracs_vehicle.dbo.vehicle_application_unit vau, 
	etracs_vehicle.dbo.vehicle_application va, 
	etracs_vehicle.dbo.vehicle_franchise vf  
WHERE vau.appid = va.objid 
AND va.controlid = vf.objid 
AND vf.controlno = nvf.objid
;


INSERT INTO puerto_vehicle.dbo.vehicle_permit
(objid,state,appid,permitno,permittype,dtissued,issuedby_objid,issuedby_name,txnmode,expirydate)
SELECT
vp.objid,
vp.state,
vp.appid,
vp.permitno,
vp.permittype,
vp.dtissued,
vp.issuedby_objid,
vp.issuedby_name,
va.txnmode,
vp.expirydate
FROM etracs_vehicle.dbo.vehicle_permit vp
INNER JOIN etracs_vehicle.dbo.vehicle_application va ON vp.appid = va.objid
INNER JOIN etracs_vehicle.dbo.vehicle_franchise vf ON va.controlid = vf.objid
;

UPDATE nvf SET 
	nvf.permitid = vp.objid 
FROM puerto_vehicle.dbo.vehicle_franchise nvf, 
	etracs_vehicle.dbo.vehicle_permit vp, 
	etracs_vehicle.dbo.vehicle_application va, 
	etracs_vehicle.dbo.vehicle_franchise vf  
WHERE nvf.objid = vf.controlno 
AND vf.objid = va.controlid 
AND va.objid = vp.appid
;

UPDATE vp SET 
	vp.expirydate = (convert(char(4), va.appyear) +'-12-31')
FROM puerto_vehicle_new.vehicle_permit vp, puerto_vehicle_new.vehicle_application va 
WHERE va.objid = vp.appid
;


DELETE FROM puerto_vehicle.dbo.vehicle_variable
;

INSERT INTO puerto_vehicle.dbo.vehicle_variable (objid,state,name,caption,description,datatype,category,sortorder,system,arrayvalues)
SELECT  objid,state,name,caption,description,datatype,category,sortorder,system,arrayvalues 
FROM etracs_vehicle.dbo.vehicle_variable
;

INSERT INTO puerto_vehicle.dbo.vehicle_application_info
(objid,appid,name,stringvalue,decimalvalue,intvalue,datevalue,booleanvalue,lov_objid,lookup_objid,lookup_title,objvalue,sortorder)
SELECT 
objid,parentid,name,stringvalue,decimalvalue,intvalue,datevalue,booleanvalue,lov_objid,lookup_objid,lookup_title,objvalue,sortorder
FROM etracs_vehicle.dbo.vehicle_application_info 
WHERE parentid IN (SELECT objid FROM puerto_vehicle.dbo.vehicle_application)
;

INSERT INTO puerto_vehicle.dbo.vehicle_payment
(objid,appid,txndate,refid,reftype,refno,refdate,amount,voided,txnmode,remarks)
SELECT objid,appid,txndate,refid,reftype,refno,refdate,amount,voided,txnmode,remarks 
FROM etracs_vehicle.dbo.vehicle_payment 
WHERE appid IN (SELECT objid FROM puerto_vehicle.dbo.vehicle_application)
;

INSERT INTO puerto_vehicle.dbo.vehicle_payment_item (objid,parentid,amount,surcharge,interest,discount,refid,remarks)
SELECT objid,parentid,amount,surcharge,interest,discount,refid,remarks 
FROM etracs_vehicle.dbo.vehicle_payment_item
WHERE parentid IN (SELECT objid FROM puerto_vehicle.dbo.vehicle_payment) 
AND refid IN ( SELECT objid FROM puerto_vehicle.dbo.vehicle_application_fee )
;


INSERT INTO puerto_vehicle.dbo.vehicle_unit_info (objid,unitid,fieldid,stringvalue)
SELECT ( a.unitid +'-'+ a.fieldid) AS objid, a.*
FROM
(SELECT vu.objid AS unitid, (va.vehicletypeid +'-plateno') AS fieldid, vu.plateno AS stringvalue 
FROM etracs_vehicle.dbo.vehicle_application_unit vu
INNER JOIN etracs_vehicle.dbo.vehicle_application va ON vu.appid = va.objid 
WHERE vu.objid IN (SELECT objid FROM puerto_vehicle.dbo.vehicle_unit)) a
;

INSERT INTO puerto_vehicle.dbo.vehicle_unit_info (objid,unitid,fieldid,stringvalue)
SELECT ( a.unitid +'-'+ a.fieldid) AS objid, a.*
FROM
(SELECT vu.objid AS unitid, (va.vehicletypeid +'-sidecarno') AS fieldid, vu.sidecarno AS stringvalue 
FROM etracs_vehicle.dbo.vehicle_application_unit vu
INNER JOIN etracs_vehicle.dbo.vehicle_application va ON vu.appid = va.objid 
WHERE vu.objid IN (SELECT objid FROM puerto_vehicle.dbo.vehicle_unit)) a
;


INSERT INTO puerto_vehicle.dbo.vehicle_unit_info (objid,unitid,fieldid,stringvalue)
SELECT ( a.unitid +'-'+ a.fieldid) AS objid, a.*
FROM
(SELECT vu.objid AS unitid, (va.vehicletypeid +'-sidecarcolor') AS fieldid, vu.sidecarcolor AS stringvalue 
FROM etracs_vehicle.dbo.vehicle_application_unit vu
INNER JOIN etracs_vehicle.dbo.vehicle_application va ON vu.appid = va.objid 
WHERE vu.objid IN (SELECT objid FROM puerto_vehicle.dbo.vehicle_unit)) a
;


INSERT INTO puerto_vehicle.dbo.vehicle_unit_info (objid,unitid,fieldid,stringvalue)
SELECT ( a.unitid +'-'+ a.fieldid) AS objid, a.*
FROM
(SELECT vu.objid AS unitid, (va.vehicletypeid +'-make') AS fieldid, vu.make AS stringvalue 
FROM etracs_vehicle.dbo.vehicle_application_unit vu
INNER JOIN etracs_vehicle.dbo.vehicle_application va ON vu.appid = va.objid 
WHERE vu.objid IN (SELECT objid FROM puerto_vehicle.dbo.vehicle_unit)) a
;


INSERT INTO puerto_vehicle.dbo.vehicle_unit_info (objid,unitid,fieldid,stringvalue)
SELECT ( a.unitid +'-'+ a.fieldid) AS objid, a.*
FROM
(SELECT vu.objid AS unitid, (va.vehicletypeid +'-bodyno') AS fieldid, vu.bodyno AS stringvalue 
FROM etracs_vehicle.dbo.vehicle_application_unit vu
INNER JOIN etracs_vehicle.dbo.vehicle_application va ON vu.appid = va.objid 
WHERE vu.objid IN (SELECT objid FROM puerto_vehicle.dbo.vehicle_unit)) a
;


INSERT INTO puerto_vehicle.dbo.vehicle_unit_info (objid,unitid,fieldid,stringvalue)
SELECT ( a.unitid +'-'+ a.fieldid) AS objid, a.*
FROM
(SELECT vu.objid AS unitid, (va.vehicletypeid +'-chassisno') AS fieldid, vu.chassisno AS stringvalue 
FROM etracs_vehicle.dbo.vehicle_application_unit vu
INNER JOIN etracs_vehicle.dbo.vehicle_application va ON vu.appid = va.objid 
WHERE vu.objid IN (SELECT objid FROM puerto_vehicle.dbo.vehicle_unit)) a
;

INSERT INTO puerto_vehicle.dbo.vehicle_unit_info (objid,unitid,fieldid,stringvalue)
SELECT ( a.unitid +'-'+ a.fieldid) AS objid, a.*
FROM
(SELECT vu.objid AS unitid, (va.vehicletypeid +'-color') AS fieldid, vu.color AS stringvalue 
FROM etracs_vehicle.dbo.vehicle_application_unit vu
INNER JOIN etracs_vehicle.dbo.vehicle_application va ON vu.appid = va.objid 
WHERE vu.objid IN (SELECT objid FROM puerto_vehicle.dbo.vehicle_unit)) a
;


INSERT INTO puerto_vehicle.dbo.vehicle_unit_info (objid,unitid,fieldid,stringvalue)
SELECT ( a.unitid +'-'+ a.fieldid) AS objid, a.*
FROM
(SELECT vu.objid AS unitid, (va.vehicletypeid +'-crname') AS fieldid, vu.crname AS stringvalue 
FROM etracs_vehicle.dbo.vehicle_application_unit vu
INNER JOIN etracs_vehicle.dbo.vehicle_application va ON vu.appid = va.objid 
WHERE vu.objid IN (SELECT objid FROM puerto_vehicle.dbo.vehicle_unit)) a
;


INSERT INTO puerto_vehicle.dbo.vehicle_unit_info (objid,unitid,fieldid,stringvalue)
SELECT ( a.unitid +'-'+ a.fieldid) AS objid, a.*
FROM
(SELECT vu.objid AS unitid, (va.vehicletypeid +'-engineno') AS fieldid, vu.engineno AS stringvalue 
FROM etracs_vehicle.dbo.vehicle_application_unit vu
INNER JOIN etracs_vehicle.dbo.vehicle_application va ON vu.appid = va.objid 
WHERE vu.objid IN (SELECT objid FROM puerto_vehicle.dbo.vehicle_unit)) a
;


DROP TABLE zz_vehicletype_field
;
