USE puerto_obo2
go 

CREATE TABLE occupancy_rpu_item  (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NULL,
  faasid varchar(50) NULL,
  truecopycertid varchar(50) NULL,
  truecopycertfee decimal(16, 2) NULL,
  constraint pk_occupancy_rpu_item PRIMARY KEY (objid)
)
go 

ALTER TABLE occupancy_rpu_item 
ADD CONSTRAINT fk_occupancy_rpu_item_parentid 
FOREIGN KEY (parentid) REFERENCES occupancy_rpu (objid)
go 

ALTER TABLE occupancy_rpu ADD truecopycertfee decimal(16, 2)
go 

ALTER TABLE occupancy_rpu_item ADD tdno varchar(50) NULL
go 

ALTER TABLE occupancy_rpu_item ADD pin varchar(50) NULL
go 
