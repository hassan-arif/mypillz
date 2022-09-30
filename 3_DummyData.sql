USE MyPillz
GO

--commented lines aren't ready to run yet!

delete from Login_ where 1=1
delete from Doctor where 1=1
delete from Patient where 1=1
delete from Vendor where 1=1
delete from Drug where 1=1
delete from Inventory where 1=1
delete from Order_ where 1=1
delete from Consultancy where 1=1
delete from Forum where 1=1

INSERT INTO Login_ (username,password)
VALUES
	('d0','password'),
	('p1','password'),
	('v2','password')

INSERT INTO Doctor (doctor_username, doctor_id, doctor_name, doctor_gender, doctor_dob, doctor_email)
VALUES
	('d0',1,'Mahd','M','2000-01-01','mahd@gmail.com')

INSERT INTO Patient (patient_username, patient_id, patient_name, patient_gender, patient_dob, patient_email)
VALUES
	('p1',2,'Ubaid','M','2000-01-01','ubaid@gmail.com')

INSERT INTO Vendor (vendor_username, vendor_id, vendor_name, vendor_gender, vendor_dob, vendor_email)
VALUES
	('v2',3,'Omar','M','2000-01-01','omar@gmail.com')

INSERT INTO Drug (drug_type, drug_id, drug_name)
VALUES
	('Depressant',1,'Valium'),
	('Depressant',2,'Librium'),
	('Depressant',3,'Xanax'),
	('Depressant',4,'Prozac'),
	('Depressant',5,'Thorazine'),
	('Stimulant',6,'Adderall'),
	('Stimulant',7,'Mydayis'),
	('Stimulant',8,'Adzenys'),
	('Stimulant',9,'Desoxyn'),
	('Stimulant',10,'Methedrine'),
	('Hallucinogen',11,'Mescaline'),
	('Hallucinogen',12,'Psilocybin'),
	('Hallucinogen',13,'LSD'),
	('Hallucinogen',14,'Ketamine'),
	('Hallucinogen',15,'Cannabis'),
	('Narcotic Analgesic',16,'Oxycodone'),
	('Narcotic Analgesic',17,'Fentanyl'),
	('Narcotic Analgesic',18,'Tramadol'),
	('Narcotic Analgesic',19,'Morphine'),
	('Narcotic Analgesic',20,'Codeine'),
	('Recreational',21,'Meth'),
	('Recreational',22,'Heroin'),
	('Recreational',23,'Ecstasy'),
	('Recreational',24,'Cocaine'),
	('Recreational',25,'Bath Salts'),
	('Painkiller',26,'Panadol'),
	('Painkiller',27,'Ibuprofen'),
	('Painkiller',28,'Tylenol'),
	('Painkiller',29,'Aleve'),
	('Painkiller',30,'Aspirin')

INSERT INTO Inventory (inventory_vendor_username,inventory_drug_id)
VALUES
	('v2',2),('v2',6),('v2',11),('v2',16),('v2',21),('v2',26)

INSERT INTO Order_  (order_id,order_vendor_username,order_patient_username,order_drug_id,order_quantity)
VALUES
	(1,'v2','p1',2,20),
	(2,'v2','p1',2,10),
	(3,'v2','p1',6,25)

select* from Login_
select* from Doctor
select* from Patient
select* from Vendor
select* from Drug
select* from Inventory
select* from Order_
select* from Consultancy
select* from Forum