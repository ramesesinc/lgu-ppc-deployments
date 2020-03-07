-- 
-- notes :
-- source db: vehicle_puerto_old;
-- target db: puerto_vehicle;
--
USE puerto_vehicle;

SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM vehicle_account;
DELETE FROM vehicle_application;
DELETE FROM vehicle_application_fee;
DELETE FROM vehicle_application_info;
DELETE FROM vehicle_application_task;
DELETE FROM vehicle_driver;
DELETE FROM vehicle_driver_franchise;
DELETE FROM vehicle_extensiondate;
DELETE FROM vehicle_franchise;
DELETE FROM vehicle_itemaccount;
DELETE FROM vehicle_payment;
DELETE FROM vehicle_payment_item;
DELETE FROM vehicle_permit;
DELETE FROM vehicle_unit;
DELETE FROM vehicle_unit_info;
DELETE FROM vehicle_variable;
DELETE FROM vehicletype_field;
DELETE FROM vehicletype;
SET FOREIGN_KEY_CHECKS = 1;


USE vehicle_puerto_old;

DELETE FROM puerto_vehicle.vehicletype_field; 
DELETE FROM puerto_vehicle.vehicletype; 

CREATE TABLE `zz_vehicletype_field` (
  `name` varchar(50) NOT NULL,
  `caption` varchar(100) DEFAULT NULL,
  `datatype` varchar(50) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  `required` smallint(255) DEFAULT NULL,
  `textwidth` int(11) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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


INSERT INTO puerto_vehicle.vehicletype 
(objid,title,controlpattern,indexno,appnopattern,icon,renewalfrequency,permitnopattern,maxunitperowner)
SELECT 
objid,title,controlpattern,indexno,appnopattern,icon,renewalfrequency,permitnopattern,10
FROM vehicletype;

INSERT INTO puerto_vehicle.vehicletype_field
(objid,vehicletypeid,name,caption,datatype,category,sortorder,required,textwidth)
SELECT 
CONCAT( v.objid, '-', f.name ) AS objid,
v.objid as vehciletypeid, f.* 
FROM vehicletype v, zz_vehicletype_field f; 


INSERT INTO puerto_vehicle.vehicle_franchise 
(objid,state,controlno,vehicletypeid,nextfranchiserenewaldate)
SELECT 
controlno,state,controlno,vehicletypeid,renewaldate 
FROM vehicle_franchise;

INSERT INTO puerto_vehicle.vehicle_application 
(objid,franchiseid,appno,appyear,appdate,apptype,txnmode,dtcreated,createdby_objid,createdby_name,particulars)
SELECT va.objid,vf.controlno,va.appno,va.appyear,va.appdate,va.apptype,va.txnmode,
va.dtcreated,va.createdby_objid,va.createdby_name,va.particulars
FROM vehicle_application va
INNER JOIN vehicle_franchise vf ON va.controlid = vf.objid

INSERT INTO puerto_vehicle.vehicle_account
(objid,franchiseid,owner_objid,owner_name,owner_address_objid,owner_address_text)
SELECT va.objid,vf.controlno, va.owner_objid,va.owner_name,va.owner_address_objid,va.owner_address_text
FROM vehicle_application va
INNER JOIN vehicle_franchise vf ON va.controlid = vf.objid;

UPDATE puerto_vehicle.vehicle_application SET acctid = objid;

INSERT INTO puerto_vehicle.vehicle_application_task 
(taskid,refid,parentprocessid,state,startdate,enddate,assignee_objid,assignee_name,actor_objid,actor_name,message,dtcreated,prevtaskid)
SELECT taskid,refid,parentprocessid,state,startdate,enddate,assignee_objid,assignee_name,actor_objid,actor_name,message,dtcreated,prevtaskid
FROM vehicle_application_task 
WHERE refid IN (SELECT objid FROM puerto_vehicle.vehicle_application);



UPDATE puerto_vehicle.vehicle_application nva, vehicle_application ova 
SET nva.taskid = ova.taskid 
WHERE nva.objid = ova.objid;

UPDATE puerto_vehicle.vehicle_franchise vf,puerto_vehicle.vehicle_application va
SET vf.acctid = va.acctid, vf.appid = va.objid  
WHERE vf.objid = va.franchiseid;



DELETE FROM  puerto_vehicle.vehicle_itemaccount;
INSERT INTO puerto_vehicle.vehicle_itemaccount
(objid,title,item_objid,item_code,item_title)
SELECT DISTINCT item_objid, item_title, item_objid, item_code, item_title
FROM vehicle_application_fee;

INSERT INTO puerto_vehicle.vehicle_application_fee (objid,appid,year,itemid,amount,amtpaid)
SELECT objid,parentid,year,item_objid,amount,amtpaid FROM vehicle_application_fee;

UPDATE puerto_vehicle.vehicle_application_fee vf, puerto_vehicle.vehicle_application va 
SET vf.year = va.appyear 
WHERE vf.appid = va.objid;

INSERT INTO  puerto_vehicle.vehicle_unit (objid,franchiseid)
SELECT vu.objid,va.controlid 
FROM vehicle_application_unit vu
INNER JOIN vehicle_application va ON vu.appid = va.objid 
WHERE va.controlid IN (SELECT objid FROM puerto_vehicle.vehicle_franchise);

UPDATE puerto_vehicle.vehicle_application nva, vehicle_application_unit va 
SET nva.unitid = va.objid 
WHERE va.appid = nva.objid;

INSERT INTO  puerto_vehicle.vehicle_unit (objid,franchiseid)
SELECT vu.objid, vf.controlno  
FROM vehicle_application_unit vu
INNER JOIN vehicle_application va ON vu.appid = va.objid 
INNER JOIN vehicle_franchise vf ON va.controlid = vf.objid 

UPDATE puerto_vehicle.vehicle_application nva, vehicle_application_unit vau, vehicle_application va 
SET nva.unitid = vau.objid 
WHERE vau.appid = va.objid 
AND va.objid = nva.objid;

UPDATE puerto_vehicle.vehicle_franchise nvf, vehicle_application_unit vau, vehicle_application va, vehicle_franchise vf  
SET nvf.unitid = vau.objid 
WHERE vau.appid = va.objid 
AND va.controlid = vf.objid 
AND vf.controlno = nvf.objid;


INSERT INTO puerto_vehicle.vehicle_permit
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
FROM vehicle_permit vp
INNER JOIN vehicle_application va ON vp.appid = va.objid
INNER JOIN vehicle_franchise vf ON va.controlid = vf.objid;

UPDATE puerto_vehicle.vehicle_franchise nvf, vehicle_permit vp, vehicle_application va, vehicle_franchise vf  
SET nvf.permitid = vp.objid 
WHERE nvf.objid = vf.controlno 
AND vf.objid = va.controlid 
AND va.objid = vp.appid;

UPDATE puerto_vehicle_new.vehicle_permit vp, puerto_vehicle_new.vehicle_application va 
SET vp.expirydate = CONCAT( va.appyear, '-', 12 , '-', 31 )
WHERE va.objid = vp.appid;


DELETE FROM puerto_vehicle.vehicle_variable;
INSERT INTO puerto_vehicle.vehicle_variable (objid,state,name,caption,description,datatype,category,sortorder,system,arrayvalues)
SELECT  objid,state,name,caption,description,datatype,category,sortorder,system,arrayvalues FROM vehicle_variable;

INSERT INTO puerto_vehicle.vehicle_application_info
(objid,appid,name,stringvalue,decimalvalue,intvalue,datevalue,booleanvalue,lov_objid,lookup_objid,lookup_title,objvalue,sortorder)
SELECT 
objid,parentid,name,stringvalue,decimalvalue,intvalue,datevalue,booleanvalue,lov_objid,lookup_objid,lookup_title,objvalue,sortorder
FROM vehicle_application_info WHERE parentid IN (SELECT objid FROM puerto_vehicle.vehicle_application);

INSERT INTO puerto_vehicle.vehicle_payment
(objid,appid,txndate,refid,reftype,refno,refdate,amount,voided,txnmode,remarks)
SELECT objid,appid,txndate,refid,reftype,refno,refdate,amount,voided,txnmode,remarks 
FROM vehicle_payment WHERE appid IN (SELECT objid FROM puerto_vehicle.vehicle_application);

INSERT INTO puerto_vehicle.vehicle_payment_item (objid,parentid,amount,surcharge,interest,discount,refid,remarks)
SELECT objid,parentid,amount,surcharge,interest,discount,refid,remarks FROM vehicle_payment_item
WHERE parentid IN (SELECT objid FROM puerto_vehicle.vehicle_payment) 
AND refid IN ( SELECT objid FROM puerto_vehicle.vehicle_application_fee );


INSERT INTO puerto_vehicle.vehicle_unit_info (objid,unitid,fieldid,stringvalue)
SELECT CONCAT( a.unitid, '-', a.fieldid) AS objid, a.*
FROM
(SELECT vu.objid AS unitid, CONCAT(va.vehicletypeid,'-plateno') AS fieldid, vu.plateno AS stringvalue 
FROM vehicle_application_unit vu
INNER JOIN vehicle_application va ON vu.appid = va.objid 
WHERE vu.objid IN (SELECT objid FROM puerto_vehicle.vehicle_unit)) a;

INSERT INTO puerto_vehicle.vehicle_unit_info (objid,unitid,fieldid,stringvalue)
SELECT CONCAT( a.unitid, '-', a.fieldid) AS objid, a.*
FROM
(SELECT vu.objid AS unitid, CONCAT(va.vehicletypeid,'-sidecarno') AS fieldid, vu.sidecarno AS stringvalue 
FROM vehicle_application_unit vu
INNER JOIN vehicle_application va ON vu.appid = va.objid 
WHERE vu.objid IN (SELECT objid FROM puerto_vehicle.vehicle_unit)) a;


INSERT INTO puerto_vehicle.vehicle_unit_info (objid,unitid,fieldid,stringvalue)
SELECT CONCAT( a.unitid, '-', a.fieldid) AS objid, a.*
FROM
(SELECT vu.objid AS unitid, CONCAT(va.vehicletypeid,'-sidecarcolor') AS fieldid, vu.sidecarcolor AS stringvalue 
FROM vehicle_application_unit vu
INNER JOIN vehicle_application va ON vu.appid = va.objid 
WHERE vu.objid IN (SELECT objid FROM puerto_vehicle.vehicle_unit)) a;


INSERT INTO puerto_vehicle.vehicle_unit_info (objid,unitid,fieldid,stringvalue)
SELECT CONCAT( a.unitid, '-', a.fieldid) AS objid, a.*
FROM
(SELECT vu.objid AS unitid, CONCAT(va.vehicletypeid,'-make') AS fieldid, vu.make AS stringvalue 
FROM vehicle_application_unit vu
INNER JOIN vehicle_application va ON vu.appid = va.objid 
WHERE vu.objid IN (SELECT objid FROM puerto_vehicle.vehicle_unit)) a;


INSERT INTO puerto_vehicle.vehicle_unit_info (objid,unitid,fieldid,stringvalue)
SELECT CONCAT( a.unitid, '-', a.fieldid) AS objid, a.*
FROM
(SELECT vu.objid AS unitid, CONCAT(va.vehicletypeid,'-bodyno') AS fieldid, vu.bodyno AS stringvalue 
FROM vehicle_application_unit vu
INNER JOIN vehicle_application va ON vu.appid = va.objid 
WHERE vu.objid IN (SELECT objid FROM puerto_vehicle.vehicle_unit)) a;


INSERT INTO puerto_vehicle.vehicle_unit_info (objid,unitid,fieldid,stringvalue)
SELECT CONCAT( a.unitid, '-', a.fieldid) AS objid, a.*
FROM
(SELECT vu.objid AS unitid, CONCAT(va.vehicletypeid,'-chassisno') AS fieldid, vu.chassisno AS stringvalue 
FROM vehicle_application_unit vu
INNER JOIN vehicle_application va ON vu.appid = va.objid 
WHERE vu.objid IN (SELECT objid FROM puerto_vehicle.vehicle_unit)) a;

INSERT INTO puerto_vehicle.vehicle_unit_info (objid,unitid,fieldid,stringvalue)
SELECT CONCAT( a.unitid, '-', a.fieldid) AS objid, a.*
FROM
(SELECT vu.objid AS unitid, CONCAT(va.vehicletypeid,'-color') AS fieldid, vu.color AS stringvalue 
FROM vehicle_application_unit vu
INNER JOIN vehicle_application va ON vu.appid = va.objid 
WHERE vu.objid IN (SELECT objid FROM puerto_vehicle.vehicle_unit)) a;


INSERT INTO puerto_vehicle.vehicle_unit_info (objid,unitid,fieldid,stringvalue)
SELECT CONCAT( a.unitid, '-', a.fieldid) AS objid, a.*
FROM
(SELECT vu.objid AS unitid, CONCAT(va.vehicletypeid,'-crname') AS fieldid, vu.crname AS stringvalue 
FROM vehicle_application_unit vu
INNER JOIN vehicle_application va ON vu.appid = va.objid 
WHERE vu.objid IN (SELECT objid FROM puerto_vehicle.vehicle_unit)) a;


INSERT INTO puerto_vehicle.vehicle_unit_info (objid,unitid,fieldid,stringvalue)
SELECT CONCAT( a.unitid, '-', a.fieldid) AS objid, a.*
FROM
(SELECT vu.objid AS unitid, CONCAT(va.vehicletypeid,'-engineno') AS fieldid, vu.engineno AS stringvalue 
FROM vehicle_application_unit vu
INNER JOIN vehicle_application va ON vu.appid = va.objid 
WHERE vu.objid IN (SELECT objid FROM puerto_vehicle.vehicle_unit)) a;


DROP TABLE zz_vehicletype_field;












