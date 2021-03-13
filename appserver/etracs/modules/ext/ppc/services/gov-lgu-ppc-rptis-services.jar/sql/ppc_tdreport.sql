[findFaas]
select 
	f.objid, 
	f.tdno as td_tdno,
	f.fullpin as td_rpu_realProperty_pin,
	e.name  as td_taxpayerName,
	e.address_text as td_taxpayerAddress,
	rp.street as td_rpu_realProperty_street,
	b.name as td_rpu_realProperty_location,
	rp.cadastrallotno as td_rpu_realProperty_cadastralLotNo,
	rp.surveyno as td_rpu_realProperty_surveyNo,
	f.titleno as td_titleNo,
	rp.east as td_rpu_realProperty_eastBoundary,
	rp.west as td_rpu_realProperty_westBoundary,
	rp.north as td_rpu_realProperty_northBoundary,
	rp.south as td_rpu_realProperty_southBoundary,
	f.administrator_name as td_administratorName,
	f.administrator_name as td_administratorAddress,
	f.fullpin as td_rpu_pin,
	f.memoranda as td_remarks,
	r.totalmv as td_rpu_totalAMV,
	r.totalav as td_rpu_totalAV,
	s.approver_name as td_approvedBy,
	s.appraiser_name as td_appraisedBy,
	f.prevtdno as td_previousTdNo,
	f.effectivityyear as td_effectivityYear,
	f.effectivityyear  as td_rollYear,
	f.prevowner as td_previousOwner,
	s.recommender_name as td_recommendedBy,
	f.state as td_state_name,
	s.appraiser_title as td_appraisedByPosition,
	s.approver_title as td_approvedByPosition,
	s.recommender_title as td_recommendedByPosition,
	r.taxable as td_rpu_taxable,
	f.prevmv as td_previousMarketValue,
	f.prevpin as td_previousPin,
	f.titledate as td_titleDate,
	null as td_newDiscoveryInfo,
	f.prevav as prevLandAV,
	0 as prevImprovementAV,
	r.rputype,
	f.rpuid
from faas f
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid
	inner join barangay b on rp.barangayid = b.objid
	inner join faas_signatory s on f.objid = s.objid
	inner join entity e on f.taxpayer_objid = e.objid 
where f.objid = $P{objid}



[getAgriLands]
select 
	lspc.name as kind,
	ld.areaha as areaHec,
	sub.name as  sclass,
	ld.basevalue as baseValue,
	ld.basemarketvalue as  marketValue
from faas f
	inner join landdetail ld on f.rpuid = ld.landrpuid 
	inner join lcuvsubclass sub on ld.subclass_objid = sub.objid 
	inner join lcuvspecificclass spc on sub.specificclass_objid = spc.objid 
	inner join landspecificclass lspc on spc.landspecificclass_objid = lspc.objid 
	inner join propertyclassification pc on spc.classification_objid = pc.objid 
where f.objid = $P{objid}
and pc.name in ('AGRICULTURAL', 'MINERAL')

[getNonAgriLands]
select 
	lspc.name as kind,
	ld.areasqm as areaSqm,
	ld.basevalue as  baseValue,
	ld.actualuseadjustment as adjustment,
	ld.basemarketvalue as marketValue,
	ld.marketvalue as adjMarketValue,
	ld.unitValue
from faas f
	inner join landdetail ld on f.rpuid = ld.landrpuid 
	inner join lcuvsubclass sub on ld.subclass_objid = sub.objid 
	inner join lcuvspecificclass spc on sub.specificclass_objid = spc.objid 
	inner join landspecificclass lspc on spc.landspecificclass_objid = lspc.objid 
	inner join propertyclassification pc on spc.classification_objid = pc.objid 
where f.objid = $P{objid}
and pc.name not in ('AGRICULTURAL', 'MINERAL')


[getLandAssessmentItems]
select 
	a.rputype as kind,
	au.name as actualUse,
	0.0 as marketValue,
	a.assesslevel as assessmentLevel,
	a.assessedvalue as  assessmentValue,
	a.marketvalue as  adjMarketValue
from faas f
	inner join rpu_assessment a on f.rpuid = a.rpuid 
	inner join landassesslevel au on a.actualuse_objid = au.objid 
where f.objid = $P{objid}

union 

select 
	a.rputype as kind,
	au.name as actualUse,
	0.0 as marketValue,
	a.assesslevel as assessmentLevel,
	a.assessedvalue as  assessmentValue,
	a.marketvalue as  adjMarketValue
from faas f
	inner join rpu_assessment a on f.rpuid = a.rpuid 
	inner join planttreeassesslevel au on a.actualuse_objid = au.objid 
where f.objid = $P{objid}

[getBldgAssessmentItems]
select 
	a.rputype as kind,
	au.name as actualUse,
	0.0 as marketValue,
	a.assesslevel as assessmentLevel,
	a.assessedvalue as  assessmentValue,
	a.marketvalue as  adjMarketValue
from faas f
	inner join rpu_assessment a on f.rpuid = a.rpuid 
	inner join bldgassesslevel au on a.actualuse_objid = au.objid 
where f.objid = $P{objid}


[getMachAssessmentItems]
select 
	a.rputype as kind,
	au.name as actualUse,
	0.0 as marketValue,
	a.assesslevel as assessmentLevel,
	a.assessedvalue as  assessmentValue,
	a.marketvalue as  adjMarketValue
from faas f
	inner join rpu_assessment a on f.rpuid = a.rpuid 
	inner join machassesslevel au on a.actualuse_objid = au.objid 
where f.objid = $P{objid}


[getPlantAssessmentItems]
select 
	a.rputype as kind,
	au.name as actualUse,
	0.0 as marketValue,
	a.assesslevel as assessmentLevel,
	a.assessedvalue as  assessmentValue,
	a.marketvalue as  adjMarketValue
from faas f
	inner join rpu_assessment a on f.rpuid = a.rpuid 
	inner join planttreeassesslevel au on a.actualuse_objid = au.objid 
where f.objid = $P{objid}

[getMiscAssessmentItems]
select 
	a.rputype as kind,
	au.name as actualUse,
	0.0 as marketValue,
	a.assesslevel as assessmentLevel,
	a.assessedvalue as  assessmentValue,
	a.marketvalue as  adjMarketValue
from faas f
	inner join rpu_assessment a on f.rpuid = a.rpuid 
	inner join miscassesslevel au on a.actualuse_objid = au.objid 
where f.objid = $P{objid}


[getPlantTrees]
select  
	pt.name as kind,
	ld.productive as  annualProduct,
	ld.unitvalue as unitValue,
	ld.basemarketvalue as marketValue
from faas f
	inner join planttreedetail ld on f.rpuid = ld.landrpuid 
	inner join planttree pt on ld.planttree_objid = pt.objid 
where f.objid = $P{objid}


[getPlantTreesRpu]
select  
	pt.name as kind,
	ld.productive as  annualProduct,
	ld.unitvalue as unitValue,
	ld.basemarketvalue as marketValue
from faas f
	inner join planttreedetail ld on f.rpuid = ld.planttreerpuid  
	inner join planttree pt on ld.planttree_objid = pt.objid 
where f.objid = $P{objid}

[findBldgInfo]
select  
	r.totalmv as bldgItem_adjMarketValue,
	r.totalmv as  bldgItem_marketValue,   
	br.floorcount as bldgItem_noOfFloors,
	r.totalmv as bldgTotalAMV,
	r.totalbmv as bldgTotalMV
from faas f
	inner join rpu r on f.rpuid = r.objid 
	inner join bldgrpu br on f.rpuid = br.objid 
where f.objid = $P{objid}


[findFloorArea]
select  sum(bu.area) as area
from faas f
	inner join bldguse bu on f.rpuid = bu.bldgrpuid
where f.objid = $P{objid}

[findBldgDescription]
select  bk.name as description
from faas f
	inner join bldgrpu_structuraltype st on f.rpuid = st.bldgrpuid 
	inner join bldgtype bt on st.bldgtype_objid = bt.objid 
	inner join bldgkindbucc bucc on st.bldgkindbucc_objid = bucc.objid 
	inner join bldgkind bk on bucc.bldgkind_objid = bk.objid 
where f.objid = $P{objid}

[getMaterials]
select  m.name as material 
from faas f
	inner join bldgstructure bs on f.rpuid = bs.bldgrpuid 
	inner join structure st on bs.structure_objid = st.objid 
	inner join material m on bs.material_objid = m.objid 
where f.objid = $P{objid}


[getMachines]
select 
	md.depreciationvalue as depreciation,
	m.name as description,
	md.marketvalue as marketValue,
	md.operationyear as operationYear,
	md.replacementcost as  replacementCost
from faas f
	inner join machdetail md on f.rpuid = md.machrpuid 
	inner join machine m on md.machine_objid = m.objid 
where f.objid = $P{objid}

[getMiscItems]
select 
	mi.depreciatedvalue as depreciation,
	m.name as description,
	mi.marketvalue as marketValue,
	null as operationYear,
	mi.basemarketvalue as  replacementCost
from faas f
	inner join miscrpuitem mi on f.rpuid = mi.miscrpuid
	inner join miscitem m on mi.miscitem_objid = m.objid 
where f.objid = $P{objid}


[findEncumbranceInfo]
select
	fa.orno as encumbranceorno,
	fa.ordate as encumbranceordate,
	fa.memoranda as encumbrancedetail
from faas f 
	inner join rpu r on f.rpuid = r.objid 
	inner join faasannotation fa on f.objid = fa.faasid
where f.objid = $P{objid}
 and fa.state = 'APPROVED' 