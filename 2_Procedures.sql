use MyPillz
------------------------------------------------------------------------------------------------------------------------------------------------------
--GENERAL

--1) login stored procedure!
go
drop procedure if exists loginUser
go
create procedure loginUser @_username nvarchar(15), @_password nvarchar(30), @success INT output
as begin
	if(exists(select* from Login_ where username = @_username and password = @_password))
	BEGIN
		DECLARE @type NVARCHAR(1)
		SET @type = (SELECT (LEFT(@_username,1)))
		IF(@type = 'd' or @type = 'D') SET @success = 1
		IF(@type = 'p' or @type = 'P') SET @success = 2
		IF(@type = 'v' or @type = 'V') SET @success = 3
	END
	else set @success = 0
end
--testing
--declare @found int
--execute loginUser 'v2', 'password', @found output
--select @found as returnvalue

--2) signup stored procedure!
go
drop procedure if exists newUser
go
CREATE PROCEDURE newUser @Type NVARCHAR(1), @Password NVARCHAR(30), @_name NVARCHAR(30), @_gender NVARCHAR(1), @_dob DATE, @_email NVARCHAR(30), @_username NVARCHAR(15) OUTPUT
AS BEGIN
	SET @_username = 'true'
	SET @Type = (SELECT LOWER(@Type))
	IF(@Type!='d' AND @Type!='p' AND @Type!='v')
		BEGIN
			PRINT 'Invalid Category!'
			SET @_username = 'fail'
			RETURN
		END
	IF(LEN(@Password) = 0)
		BEGIN 
			PRINT 'Empty Password!'
			SET @_username = 'fail'
			RETURN
		END
	IF(LEN(@_name) = 0)
		BEGIN 
			PRINT 'Empty Name!'
			SET @_username = 'fail'
			RETURN
		END
	IF(@_gender != 'M' AND @_gender != 'F' AND @_gender != 'O')
		BEGIN
			PRINT 'Invalid Gender!'
			SET @_username = 'fail'
			RETURN
		END
	IF(LEN(@_email) = 0)
		BEGIN 
			PRINT 'Empty Email!'
			SET @_username = 'fail'
			RETURN
		END
	IF(@_dob >= GETDATE())
		BEGIN 
			select @_dob
			select getdate()
			PRINT 'Invalid DOB!'
			SET @_username = 'fail'
			RETURN
		END

	DECLARE @count INT
	DECLARE @numeric NVARCHAR(5)
	DECLARE @ID NVARCHAR(15)

	SET @count = (SELECT count(*) FROM Login_)
	SET @numeric = (SELECT CAST (@count AS NVARCHAR))
	SET @ID = (SELECT CONCAT(@Type, @numeric))

	IF(@_username = 'true')
		BEGIN
		INSERT INTO Login_ VALUES (@ID, @Password)
		Print 'New Account Successfully Created!'
		SELECT* FROM Login_
		SET @_username = @ID
	END

	IF(@Type = 'd')
		BEGIN
			INSERT INTO Doctor (doctor_username, doctor_id, doctor_name, doctor_gender, doctor_dob, doctor_email)
				VALUES(@ID, (SELECT COUNT(*) FROM Doctor)+1, @_name, @_gender, @_dob, @_email)
			SELECT* FROM Doctor
		END
	ELSE IF(@Type = 'p')
		BEGIN
			INSERT INTO Patient (patient_username, patient_id, patient_name, patient_gender, patient_dob, patient_email)
				VALUES(@ID, (SELECT COUNT(*) FROM Patient)+1, @_name, @_gender, @_dob, @_email)
			SELECT* FROM Patient
		END
	ELSE
		BEGIN
			INSERT INTO Vendor (vendor_username, vendor_id, vendor_name, vendor_gender, vendor_dob, vendor_email)
				VALUES(@ID, (SELECT COUNT(*) FROM Vendor)+1, @_name, @_gender, @_dob, @_email)
			SELECT* FROM Vendor
		END
END
--testing
--DECLARE @_username NVARCHAR(15)
--EXECUTE newUser 'v','password', 'xyz', 'F', '2000-1-1', 'XYZ@GMAIL.COM', @_username OUTPUT
--EXECUTE newUser 'p','password', 'Naveed', 'M', '2000-1-1', 'n@GMAIL.COM', @_username OUTPUT
--SELECT @_username as ID

--3) add new message in forum (as doctor or patient only)
go
drop procedure if exists newMessage
go
create procedure newMessage @username nvarchar(15), @convo nvarchar(200)
as begin
	declare @time NVARCHAR(20), @date Date
	set @time = (SELECT LTRIM(RIGHT(CONVERT(VARCHAR(20), GETDATE(), 100), 7)))
	set @date = (select convert(date,getdate()))

	if(LEN(@convo)>0)
		insert into Forum values (@username, @convo, @time, @date)
end

--4) profileview
go
drop procedure if exists userProfile
go
create procedure userProfile @username nvarchar(15), @found int output
as begin
	set @found = 0
	if(exists(select* from Doctor where doctor_username=@username))
		set @found = 1
	else if(exists(select* from Patient where patient_username=@username))
		set @found = 2
	else if(exists(select* from Vendor where vendor_username=@username))
		set @found = 3
	if(@found = 1)
		select doctor_username as UserID, doctor_name as Name, doctor_gender as Gender, doctor_dob as DOB, doctor_email as Email, doctor_stime as StartTime, doctor_etime as Etime, doctor_rating as Rating from Doctor where doctor_username=@username
	else if(@found = 3)
		select vendor_username as UserID, vendor_name as Name, vendor_gender as Gender, vendor_dob as DOB, vendor_email as Email, vendor_premium as Premium, vendor_rating as Rating from Vendor where vendor_username=@username
	else if(@found = 2)
		select patient_username as UserID, patient_name as Name, patient_gender as Gender, patient_dob as DOB, patient_email as Email, patient_premium as Premium, assigned_doctor as AssignedDoctor from Patient where patient_username=@username
end
--testing
--declare @found int
--execute userProfile 'p1',@found output
--select @found

------------------------------------------------------------------------------------------------------------------------------------------------------
--DOCTOR

--1)pending requests for consultancy
go
drop procedure if exists pendingRequests
go
create procedure pendingRequests @username nvarchar(15), @found int output
as begin
	set @found = 0
	if(exists(select* from Consultancy where consultancy_doctor_username = @username and consultancy_completion_status=0 and consultancy_rating_status=0))
		set @found = 1
	if(@found = 1)
		select consultancy_id as ID, consultancy_patient_username as PatientID, consultancy_date as [Date] from Consultancy
		where consultancy_doctor_username = @username and consultancy_completion_status=0 and consultancy_rating_status=0
end
--testing
--declare @found int
--execute pendingRequests 'd0',@found output
--select @found

--2)confirm requests for consultancy
go
drop procedure if exists confirmRequests
go
create procedure confirmRequests @id int, @username nvarchar(15), @success int output
as begin
	set @success = 0
	if(exists(select* from Consultancy where consultancy_id=@id and consultancy_doctor_username=@username and consultancy_completion_status=0 and consultancy_rating_status=0))
		set @success = 1

	if(@success = 1)
		update Consultancy set consultancy_completion_status=1 where consultancy_id=@id and consultancy_doctor_username=@username and consultancy_completion_status=0 and consultancy_rating_status=0
end

--3)completed consultancies
go
drop procedure if exists completedConsultancies
go
create procedure completedConsultancies @username nvarchar(15), @found int output
as begin
	set @found = 0
	if(exists(select* from Consultancy where consultancy_doctor_username=@username and consultancy_completion_status=1))
		set @found = 1
	if(@found = 1)
		select consultancy_id as ID, consultancy_patient_username as PatientId, consultancy_fee as Fee, consultancy_date as [Date], consultancy_rating as Rating
		from Consultancy where consultancy_doctor_username=@username and consultancy_completion_status=1 order by consultancy_rating_status desc
end
--testing
--declare @found int
--execute completedConsultancies 'd4',@found output
--select @found

------------------------------------------------------------------------------------------------------------------------------------------------------
--PATIENT

--1) show vendor id by drug id
go
drop procedure if exists showVendorByDrugID
go
create procedure showVendorByDrugID @drugid INT, @found INT output
as begin
	set @found = 0
	if(exists(select inventory_vendor_username As VendorID from Inventory where inventory_drug_id=@drugid))
		set @found = 1
	select inventory_vendor_username As VendorID, vendor_rating as Rating from Inventory join Vendor on inventory_vendor_username=vendor_username where inventory_drug_id=@drugid order by vendor_premium desc
end
--testing
--declare @found int
--execute showVendorByDrugID 'v2',2,@found output
--select @found

--2) order medicine by vendor username and drug id
go
drop procedure if exists orderDrug
go
create procedure orderDrug @patient_username NVARCHAR(15), @vendor_username NVARCHAR(15), @drug_id INT, @quantity INT, @success INT output
as begin
	declare @fee int
	set @fee = (select patient_premium from Patient where patient_username = @patient_username)
	if(@fee = 1)
		set @fee = 0
	else
		set @fee = 500
	
	set @success = 0
	
	if(exists(select* from Inventory where inventory_drug_id = @drug_id and inventory_vendor_username = @vendor_username))
		set @success = 1
	if(@success = 1 and @quantity <=0)
		set @success = 0

	if(@success = 1)
	begin
		set @success = ((select coalesce(max(order_id),0) from Order_)+1)
		insert into Order_ (order_id,order_vendor_username,order_patient_username,order_drug_id,order_quantity,order_delivery_fee)
		values (@success,@vendor_username,@patient_username,@drug_id,@quantity,@fee)
	end
end
--testing
--declare @found int
--execute orderDrug 'p1','v2',2,10,@found output
--select @found
--select* from Order_
--delete from Order_ where 1=1

--3) inprogress orders
go
drop procedure if exists inProgressOrder
go
create procedure inProgressOrder @patient_username NVARCHAR(15), @success INT output
as begin
	set @success = 0
	if(exists(select* from Order_ where order_patient_username = @patient_username and order_completion_status = 0 and order_rating_status = 0))
		set @success = 1
	if(@success = 1)
		select order_id as ID, order_drug_id as Medicine, order_quantity as Quantity, order_vendor_username as Vendor, order_location as CurrentLocation, order_delivery_fee as DeliveryFee, order_date as OrderDate
		from Order_ where order_patient_username = @patient_username and order_completion_status = 0 and order_rating_status = 0
end
--testing
--declare @found int
--execute inProgressOrder 'p1',@found output
--select @found

--4) show completed and unrated orders table for current user
go
drop procedure if exists unratedOrder
go
create procedure unratedOrder @username NVARCHAR(15), @found INT output
as begin
	set @found = 0
	if(exists(select* from Order_ where order_completion_status = 1 and order_rating_status = 0 and order_patient_username = @username))
		set @found = 1
	if(@found = 1)
		select order_id as ID, order_drug_id as Medicine, order_quantity as Quantity, order_vendor_username as Vendor, order_location as CurrentLocation, order_delivery_fee as DeliveryFee, order_date as OrderDate
		from Order_ where order_patient_username = @username and order_completion_status = 1 and order_rating_status = 0
end
--testing
--declare @found int
--execute unratedOrder 'p1',@found output
--select @found

--5) rate vendor when order is completed
go
drop procedure if exists rateVendor
go
create procedure rateVendor @orderId int, @rate int, @success int output
as begin
	set @success = 0
	if(exists(select* from Order_ where order_id = @orderId and order_completion_status = 1 and order_rating_status = 0))
		set @success = 1
	if(@success = 1)
	begin
		update Order_ set order_rating_status = 1, order_rating = @rate where order_id = @orderId and order_completion_status = 1 and order_rating_status = 0
		
		declare @count int, @username nvarchar(15)
		set @username = (select order_vendor_username from Order_ where order_id = @orderId)
		set @count = (select count(*) from Order_ where order_vendor_username = @username and order_rating_status = 1)
		set @count = @count - 1
		update Vendor set vendor_rating = (vendor_rating * @count) where vendor_username = @username
		set @count = @count + 1
		update Vendor set vendor_rating = (vendor_rating + @rate) where vendor_username = @username
		update Vendor set vendor_rating = (vendor_rating / @count) where vendor_username = @username
	end
end
--testing
--declare @success int
--execute rateVendor 1,5,@success output
--select @success
--select* from Order_
--select* from Vendor
--update Vendor set vendor_rating = 10
--update Order_ set order_rating_status = 0, order_rating = NULL where order_id = 1

--6) show all completed + rated orders list
go
drop procedure if exists previousOrders
go
create procedure previousOrders @username nvarchar(15), @found int output
as begin
	set @found = 0
	if(exists(select* from Order_ where order_patient_username = @username and order_completion_status=1 and order_rating_status=1))
		set @found = 1
	if(@found = 1)
		select order_id as ID, order_drug_id as Medicine, order_quantity as Quantity, order_vendor_username as Vendor, order_rating as Rating, order_delivery_fee as DeliveryFee, order_date as OrderDate
		from Order_ where order_patient_username = @username and order_completion_status = 1 and order_rating_status = 1
end
--testing
--declare @found int
--execute previousOrders 'p1', @found output
--select @found

--7) book appointment for patient
go
drop procedure if exists bookAppointment
go
create procedure bookAppointment @patient_username nvarchar(15), @doctor_username nvarchar(15), @success int output
as begin
	set @success = 0

	if(exists(select* from Doctor where doctor_username = @doctor_username))
		set @success = 1

	declare @count int, @id int
	set @count = (select orders_discount from Patient where patient_username=@patient_username)
	set @count = @count + 1
	set @id = ((select coalesce(max(consultancy_id),0) from Consultancy)+1)

	if(@count<5 and @success = 1)
	begin
		update Patient set orders_discount = @count where patient_username=@patient_username
		insert into Consultancy (consultancy_id,consultancy_doctor_username,consultancy_patient_username,consultancy_fee)
		values (@id,@doctor_username,@patient_username,1000)
	end
	else if(@success = 1)
	begin
		update Patient set orders_discount = 0 where patient_username=@patient_username
		insert into Consultancy (consultancy_id,consultancy_doctor_username,consultancy_patient_username,consultancy_fee)
		values (@id,@doctor_username,@patient_username,0)
	end
end
--testing
--declare @success int
--execute bookAppointment 'p1','d0',@success output
--select @success
--select* from Consultancy
--delete from Consultancy where 1=1

--8) booked appointments for patient
go
drop procedure if exists bookedAppointment
go
create procedure bookedAppointment @patient_username nvarchar(15), @found int output
as begin
	set @found = 0
	if(exists(select* from Consultancy where consultancy_patient_username = @patient_username and consultancy_completion_status = 0 and consultancy_rating_status = 0))
		set @found = 1
	if(@found = 1)
		select consultancy_id as ID, consultancy_doctor_username as DoctorID, consultancy_fee as Fee, consultancy_date as [Date] from Consultancy
		where consultancy_patient_username = @patient_username and consultancy_completion_status = 0 and consultancy_rating_status = 0
end
--testing
--declare @found int
--execute bookedAppointment 'p1', @found output
--select @found

--9)show list of unrated doctors after they've finished consultation
go
drop procedure if exists unratedDoctor
go
create procedure unratedDoctor @username NVARCHAR(15), @found INT output
as begin
	set @found = 0
	if(exists(select* from Consultancy where consultancy_completion_status = 1 and consultancy_rating_status = 0 and consultancy_patient_username = @username))
		set @found = 1
	if(@found = 1)
		select consultancy_id as ID, consultancy_doctor_username as DoctorId, consultancy_date as Date, consultancy_fee as Fee
		from Consultancy where consultancy_completion_status = 1 and consultancy_rating_status = 0 and consultancy_patient_username = @username
end
--testing
--declare @found int
--execute unratedDoctor 'p1',@found output
--select @found

--10)rate doctors after their consultation
go
drop procedure if exists rateDoctor
go
create procedure rateDoctor @consultancyId int, @rate int, @success int output
as begin
	set @success = 0
	if(exists(select* from Consultancy where consultancy_id = @consultancyId and consultancy_completion_status = 1 and consultancy_rating_status = 0))
		set @success = 1
	if(@success = 1)
	begin
		update Consultancy set consultancy_rating_status = 1, consultancy_rating = @rate where consultancy_id = @consultancyId and consultancy_completion_status = 1 and consultancy_rating_status = 0
		
		declare @count int, @username nvarchar(15)
		set @username = (select consultancy_doctor_username from Consultancy where consultancy_id = @consultancyId)
		set @count = (select count(*) from Consultancy where consultancy_doctor_username = @username and consultancy_rating_status = 1)
		set @count = @count - 1
		update Doctor set doctor_rating = (doctor_rating * @count) where doctor_username = @username
		set @count = @count + 1
		update Doctor set doctor_rating = (doctor_rating + @rate) where doctor_username = @username
		update Doctor set doctor_rating = (doctor_rating / @count) where doctor_username = @username
	end
end
--testing
--select* from Doctor
--select* from Consultancy
--declare @success int
--execute rateDoctor 1,8,@success output
--select @success
--update Doctor set doctor_rating=10 where doctor_username='d4'
--update Consultancy set consultancy_rating_status=0, consultancy_rating=NULL where consultancy_id=1

--11) show all completed + rated consultation list
go
drop procedure if exists previousConsultations
go
create procedure previousConsultations @username nvarchar(15), @found int output
as begin
	set @found = 0
	if(exists(select* from Consultancy where consultancy_patient_username = @username and consultancy_completion_status=1 and consultancy_rating_status=1))
		set @found = 1
	if(@found = 1)
		select consultancy_id as ID, consultancy_doctor_username as DoctorID, consultancy_fee as Fee, consultancy_date as [Date], consultancy_rating as Rating
		from Consultancy where consultancy_patient_username = @username and consultancy_completion_status=1 and consultancy_rating_status=1
end
--testing
--declare @found int
--execute previousConsultations 'p1', @found output
--select @found

------------------------------------------------------------------------------------------------------------------------------------------------------
--VENDOR

--1) show my offering medicines stored procedure!
go
drop procedure if exists showVendorDrug
go
create procedure showVendorDrug @username NVARCHAR(15), @found INT output
as begin
	set @found = 0
	if(exists(select drug_type as TYPE, drug_id AS ID, drug_name AS NAME from Drug join Inventory on drug_id = inventory_drug_id where inventory_vendor_username = @username))
		set @found = 1
	select drug_type as TYPE, drug_id AS ID, drug_name AS NAME from Drug join Inventory on drug_id = inventory_drug_id where inventory_vendor_username = @username
end
--testing
--declare @found int
--execute showVendorDrug 'v2', @found output
--select @found

--2) drop my offering medicine stored procedure!
go
drop procedure if exists dropVendorDrug
go
create procedure dropVendorDrug @username NVARCHAR(15), @drug_type NVARCHAR(30), @drug_id INT, @drug_name NVARCHAR(30), @found INT output
as begin
	set @found = 0
	if(exists(select* from Inventory where inventory_drug_id = @drug_id and inventory_vendor_username = @username))
	begin
		if(exists(select* from Drug where drug_id = @drug_id and drug_name = @drug_name and drug_type = @drug_type))
		begin
			set @found = 1
			delete from Inventory where inventory_drug_id = @drug_id and inventory_vendor_username = @username	
		end
	end
end
--testing
--declare @found1 int
--execute dropVendorDrug 'v2','depressant',1,'Valium',@found1 output
--select @found1

--3) add new medicine stored procedure!
go
drop procedure if exists newVendorDrug
go
CREATE PROCEDURE newVendorDrug @type NVARCHAR(30), @id INT, @name NVARCHAR(30), @username NVARCHAR(15), @success INT OUTPUT
AS BEGIN
	--valid (exists in database but not selling, doesn't exist and database before)
	--invalid (already selling, atleast 1 box is empty, @id is same but other elements aren't same)
	
	SET @success = 0
	if(LEN(@type) = 0 or LEN(@name) = 0)
		set @success = 2
	else if(exists(select* from Drug where drug_id = @id and (drug_type!=@type or drug_name!=@name)))
		set @success = 2
	else if(exists(select* from Drug where drug_id != @id and (drug_type=@type and drug_name=@name)))
		set @success = 2
	else if(exists(select* from Inventory where inventory_drug_id=@id and inventory_vendor_username=@username))
		set @success = 1

	IF(@success = 0)
	begin
		if(not exists(select* from Drug where drug_id = @id))
		begin
			insert into Drug values(@type,@id,@name)
		end
		insert into Inventory values(@username,@id)
	end
end
--testing
--DECLARE @success INT
--EXECUTE newVendorDrug 'Painkiller', 31, 'Naproxen', 'v2', @success output
--SELECT @success
--SELECT* FROM Drug

--4) vendor's current inprogress orders
go
drop procedure if exists vendorInProgressOrders
go
create procedure vendorInProgressOrders @username NVARCHAR(15), @found INT output
as begin
	set @found = 0
	if(exists(select* from Order_ where order_vendor_username = @username and order_completion_status = 0 and order_rating_status = 0))
		set @found = 1
	if(@found = 1)
		select order_id as ID, order_drug_id as Medicine, order_quantity as Quantity, order_patient_username as Patient, order_location as CurrentLocation, order_date as OrderDate, datediff(day,GETDATE(),order_date) as DayCount
		from Order_ where order_vendor_username = @username and order_completion_status = 0 and order_rating_status = 0
end
--testing
--declare @found int
--execute vendorInProgressOrders 'v2',@found output
--select @found

--5) update location of inprogress order
go
drop procedure if exists updateLocation
go
create procedure updateLocation @id INT, @location NVARCHAR(40), @success INT output
as begin
	set @success = 0
	if(exists(select* from Order_ where order_id = @id and order_completion_status = 0))
		set @success = 1
	if(LEN(@location)=0)
		set @success = 0
	if(@success = 1)
		update Order_ set order_location = @location where order_id = @id
end
--testing
--declare @success int
--execute updateLocation 1,'Warehouse',@success output
--select @success
--select* from Order_
--update Order_ set order_location = 'Store' where order_id = 1

--6) mark completion of inprogress order
go
drop procedure if exists markCompletion
go
create procedure markCompletion @id INT, @success INT output
as begin
	set @success = 0
	if(exists(select * from Order_ where order_id = @id and order_completion_status = 0))
		set @success = 1
	if(@success = 1)
		update Order_ set order_completion_status = 1, order_location = 'Destination' where order_id = @id
end
--testing
--declare @success int
--execute markCompletion 1,@success output
--select @success
--select* from Order_
--update Order_ set order_completion_status=0,order_location='Store' where order_id = 1

--7) show all completed orders (rated or unrated by patients both)
go
drop procedure if exists vendorCompletedOrders
go
create procedure vendorCompletedOrders @username nvarchar(15), @found int output
as begin
	set @found = 0
	if(exists(select* from Order_ where order_completion_status = 1 and order_vendor_username = @username))
		set @found = 1
	if(@found = 1)
		select order_id as ID, order_drug_id as Medicine, order_quantity as Quantity, order_date as OrderDate, order_patient_username as Patient, order_rating as PatientRating
		from Order_ where order_vendor_username = @username and order_completion_status = 1	
end
--testing
--declare @found int
--execute vendorCompletedOrders 'v2',@found output
--select @found

------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT* FROM Login_
SELECT* FROM Doctor
SELECT* FROM Patient
SELECT* FROM Vendor
SELECT* FROM Inventory
SELECT* FROM Drug
SELECT* FROM Order_
SELECT* FROM Consultancy
SELECT* FROM Forum

------------------------------------------------------------------------------------------------------------------------------------------------------