--use master
--drop database MyPillz
-- CREATE DATABASE MyPillz
USE MyPillz
GO

DROP TABLE IF EXISTS Order_
DROP TABLE IF EXISTS Consultancy
DROP TABLE IF EXISTS Inventory
DROP TABLE IF EXISTS Drug
DROP TABLE IF EXISTS Doctor
DROP TABLE IF EXISTS Patient
DROP TABLE IF EXISTS Vendor
DROP TABLE IF EXISTS Login_
DROP TABLE IF EXISTS Forum --for discussion b/w doctors and patients

CREATE TABLE Login_ (
	username NVARCHAR(15) PRIMARY KEY,
	password NVARCHAR(30) NOT NULL,
);

CREATE TABLE Doctor (
	doctor_username NVARCHAR(15) UNIQUE NOT NULL,
	doctor_id INT PRIMARY KEY,
	doctor_name NVARCHAR(30) NOT NULL,
	doctor_gender NVARCHAR(1) NOT NULL,
	doctor_dob DATE NOT NULL,
	doctor_email NVARCHAR(30),
	
	doctor_stime TIME DEFAULT '00:00:00', doctor_etime TIME DEFAULT '00:00:00',
	doctor_rating INT NOT NULL DEFAULT 10,

	CHECK(doctor_gender = 'M' OR doctor_gender = 'F' OR doctor_gender = 'O'),
	CHECK(doctor_dob <= GETDATE()),
	CHECK(doctor_rating between 0 and 10),

	FOREIGN KEY (doctor_username) REFERENCES Login_(username) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Patient (
	patient_username NVARCHAR(15) UNIQUE NOT NULL,
	patient_id INT PRIMARY KEY,
	patient_name NVARCHAR(30) NOT NULL,
	patient_gender NVARCHAR(1) NOT NULL,
	patient_dob DATE NOT NULL,
	patient_email NVARCHAR(30),
	
	orders_discount INT NOT NULL DEFAULT 0,
	patient_premium INT NOT NULL DEFAULT 0,	--yearly pkg + free delivery of medicine
	assigned_doctor NVARCHAR(15) DEFAULT NULL,

	CHECK(patient_gender = 'M' OR patient_gender = 'F' OR patient_gender = 'O'),
	CHECK(patient_dob <= GETDATE()),
	CHECK(patient_premium between 0 and 1),

	FOREIGN KEY (patient_username) REFERENCES Login_(username) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (assigned_doctor) REFERENCES Login_(username) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Vendor (
	vendor_username NVARCHAR(15) UNIQUE NOT NULL,
	vendor_id INT PRIMARY KEY,
	vendor_name NVARCHAR(30) NOT NULL,
	vendor_gender NVARCHAR(1) NOT NULL,
	vendor_dob DATE NOT NULL,
	vendor_email NVARCHAR(30),

	vendor_rating INT NOT NULL DEFAULT 10,
	vendor_premium INT NOT NULL DEFAULT 0,	--to push visibility

	CHECK(vendor_gender = 'M' OR vendor_gender = 'F' OR vendor_gender = 'O'),
	CHECK(vendor_dob <= GETDATE()),
	CHECK(vendor_rating between 0 and 10),
	CHECK(vendor_premium between 0 and 1),

	FOREIGN KEY (vendor_username) REFERENCES Login_(username) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Drug (
	drug_type NVARCHAR(30) NOT NULL,
	drug_id INT PRIMARY KEY,
	drug_name NVARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE Inventory (
	inventory_vendor_username NVARCHAR(15) NOT NULL,
	inventory_drug_id INT NOT NULL,
	FOREIGN KEY (inventory_vendor_username) REFERENCES Login_ (username) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (inventory_drug_id) REFERENCES Drug (drug_id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (inventory_vendor_username, inventory_drug_id)
);

CREATE TABLE Forum (
	forum_username NVARCHAR(15),
	conversation NVARCHAR(200),
	time_ NVARCHAR(20),
	date_ NVARCHAR(10),

	FOREIGN KEY (forum_username) REFERENCES Login_(username) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Order_ (
	order_id INT PRIMARY KEY,
	order_vendor_username NVARCHAR(15),
	order_patient_username NVARCHAR(15),
	order_drug_id INT NOT NULL,
	order_quantity INT,
	
	order_location NVARCHAR(40) NOT NULL DEFAULT 'Store', --for area to area updation
	order_completion_status INT NOT NULL DEFAULT 0,	--handled by vendor when patient books medicine. 1 when order is delivered.
	order_rating_status INT NOT NULL DEFAULT 0,		--handled by patient when vendor delivers medicine. 1 when rating is done. enabled only after order_completion is 1
	order_rating INT DEFAULT NULL,

	order_delivery_fee INT NOT NULL DEFAULT 500, --free for premium patient (they've to pay medicine fee only)
	order_date DATE default GETDATE(),

	FOREIGN KEY (order_vendor_username) REFERENCES Login_(username),
	FOREIGN KEY (order_patient_username) REFERENCES Login_(username),
	FOREIGN KEY (order_drug_id) REFERENCES Drug(drug_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CHECK (order_quantity > 0), CHECK(order_delivery_fee >= 0),
	CHECK(order_completion_status = 0 or order_completion_status = 1),
	CHECK(order_rating_status = 0 or order_rating_status = 1),
	CHECK(order_rating >=0 and order_rating <=10),	
);

CREATE TABLE Consultancy (
	consultancy_id INT PRIMARY KEY,
	consultancy_doctor_username NVARCHAR(15),
	consultancy_patient_username NVARCHAR(15),

	consultancy_completion_status INT NOT NULL DEFAULT 0,
	consultancy_rating_status INT NOT NULL DEFAULT 0,
	consultancy_rating INT DEFAULT NULL,
	consultancy_fee INT NOT NULL DEFAULT 1000,
	consultancy_date DATE DEFAULT GETDATE(),

	FOREIGN KEY (consultancy_doctor_username) REFERENCES Login_(username),
	FOREIGN KEY (consultancy_patient_username) REFERENCES Login_(username),

	CHECK(consultancy_completion_status = 0 or consultancy_completion_status = 1),
	CHECK(consultancy_rating_status = 0 or consultancy_rating_status = 1),
	CHECK(consultancy_rating between 0 and 10), CHECK(consultancy_fee >= 0)
);