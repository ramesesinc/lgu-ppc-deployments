UPDATE building_permit SET taskid = NULL,applicantid=NULL;
UPDATE building_evaluation_finding SET supersederid = NULL,transmittalid=NULL;
UPDATE building_permit_requirement SET transmittalid=NULL;
UPDATE building_evaluation SET taskid = NULL;
DELETE FROM building_permit_fee;
DELETE FROM building_permit_info;
DELETE FROM building_permit_rpu;
DELETE FROM building_permit_transmittal;
DELETE FROM building_permit_entity;
DELETE FROM building_evaluation_finding;
DELETE FROM building_permit_payment;
DELETE FROM building_permit_attachment;
DELETE FROM building_permit_checklist;
DELETE FROM building_permit_doc;
DELETE FROM building_permit_requirement;
DELETE FROM building_permit_post_requirement;
DELETE FROM building_permit_task;
DELETE FROM building_evaluation_task;
DELETE FROM building_evaluation;
DELETE FROM building_permit;