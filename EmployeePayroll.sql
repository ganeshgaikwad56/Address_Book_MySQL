---- Create Payroll_Service Database UC-1 ----
create database Payroll_Service;
use Payroll_Service;

---- Create Table UC-2 ----
CREATE TABLE Employee_Payroll (
    Id int identity(1,1) primary key,
    Name varchar(200) not null,
    Salary float,
    StartDate date,
); 

---- Insert Values in Table UC-3 ----
insert into employee_payroll (Name, Salary, StartDate) values
('Nita', 20000.00, '2009-09-05'),
('Amruta', 70000.00, '2014-02-06'),
('Vaishnvi', 90000.00, '2011-01-04'),
('Lavanya', 10000.00, '2019-05-01'),
('Raghav', 30000.00, '2022-02-02');

---- Retrieve employee_payroll data UC-4 ----
select * from Employee_Payroll;

---- Retrieve salary of particular employee and particular date range UC-5 ----
select salary from employee_payroll where Name = 'Lavanya';
select * from employee_payroll where StartDate between cast ('2018-01-01' as date) and GETDATE();

---- Alter And Update Data UC-6 ----
ALTER TABLE Employee_Payroll ADD Gender CHAR(1);
UPDATE Employee_Payroll
SET Gender = 'M' WHERE Name = 'Raghav';
UPDATE Employee_Payroll
SET Gender = 'F' WHERE Name = 'Amruta';

----- Use Aggregate Functions and Group by Gender UC-7----
select Sum(salary) as "TotalSalary",Gender from employee_payroll group by Gender;
select Avg(salary) as "AverageSalary",Gender from employee_payroll group by Gender;
select Min(salary) as "MinimumSalary",Gender from employee_payroll group by Gender;
select Max(salary) as "MaximumSalary",Gender from employee_payroll group by Gender;
select count(salary) as "CountSalary",Gender from employee_payroll group by Gender;

------- Add column department,PhoneNumber and Address UC-8 -------
Alter table employee_payroll
add EmployeePhoneNumber BigInt,EmployeeDepartment varchar(200) not null default 'Publish',Address varchar(200) default 'Not Provided';

Update employee_payroll 
set EmployeePhoneNumber='9842905050',EmployeeDepartment='Editing',Address='Pune,Maharashtra'
where name='Nita';

Update employee_payroll 
set EmployeePhoneNumber='10987252525',Address='Mumbai,Maharashtra'
where name ='Amruta';

Update employee_payroll 
set EmployeePhoneNumber='9600054540',EmployeeDepartment='Management',Address='Chennai,TN'
where name ='Vaishnvi';

Update employee_payroll 
set EmployeePhoneNumber='8715605050',Address='Bareilly,UP'
where name ='Raghav';

------- Rename Salary to Basic Pay and Add Deduction,Taxable pay, Income Pay, Netpay UC-9 -------
Alter table employee_payroll
add Deduction float,TaxablePay float, IncomeTax float,NetPay float;
Update employee_payroll 
set Deduction=1000
where Gender='F';
Update employee_payroll 
set Deduction=2000
where Gender='M';
update employee_payroll
set NetPay=(BasicPay - Deduction)
update employee_payroll
set TaxablePay=0,IncomeTax=0
select * from employee_payroll;

---- Terissa as part of Sales and Marketing Department UC-10 ----
UPDATE Employee_Payroll
SET EmployeeDepartment = 'Sales' 
WHERE Name = 'Terisa';

INSERT INTO Employee_Payroll
(
    Name,Salary, StartDate , Gender ,EmployeeDepartment
)
VALUES
(
    'Terisa',60000.00,'2018-01-03','F','Marketing'
);
SELECT * FROM Employee_Payroll;

------- Implement the ER Diagram into Payroll Service DB UC-11 -------
--Create Table for Company
Create Table Company
(CompanyID int identity(1,1) primary key,
CompanyName varchar(100))
--Insert Values in Company
Insert into Company values ('Archana'),('Amar Chitra Katha')
Select * from Company

--Create Employee Table
drop table employee_payroll
create table Employee
(EmployeeID int identity(1,1) primary key,
CompanyIdentity int,
EmployeeName varchar(200),
EmployeePhoneNumber bigInt,
EmployeeAddress varchar(200),
StartDate date,
Gender char,
Foreign key (CompanyIdentity) references Company(CompanyID)
)
--Insert Values in Employee
insert into Employee values
(1,'Nita Pansare',9842905050,'5298 Wild Indigo, Georgia,340002','2012-03-28','F'),
(2,'Amruta Deshmuk',9842905550,'Constitution Ave Fairfield, California(CA), 94533','2017-04-22','F'),
(1,'Vaishnvi',7812905050,'Bernard Shaw, Georgia,132001 ','2015-08-22','M'),
(2,'Rudra',78129050000,'Bernard Shaw, PB Marg Bareilly','2012-08-29','M')

Select * from Employee

--Create Payroll Table
create table PayrollCalculate
(BasicPay float,
Deductions float,
TaxablePay float,
IncomeTax float,
NetPay float,
EmployeeIdentity int,
Foreign key (EmployeeIdentity) references Employee(EmployeeID)
)
--Insert Values in Payroll Table
insert into PayrollCalculate(BasicPay,Deductions,IncomeTax,EmployeeIdentity) values 
(4000000,1000000,20000,1),
(4500000,200000,4000,2),
(6000000,10000,5000,3),
(9000000,399994,6784,4)

--Update Derived attribute values 
update PayrollCalculate
set TaxablePay=BasicPay-Deductions

update PayrollCalculate
set NetPay=TaxablePay-IncomeTax

select * from PayrollCalculate

--Create Department Table
create table Department
(
DepartmentId int identity(1,1) primary key,
DepartName varchar(100)
)
--Insert Values in Department Table
insert into Department values
('Marketing'),
('Sales'),
('Publishing')

select * from Department

--Create table EmployeeDepartment
create table EmployeeDepartment
(
DepartmentIdentity int ,
EmployeeIdentity int,
Foreign key (EmployeeIdentity) references Employee(EmployeeID),
Foreign key (DepartmentIdentity) references Department(DepartmentID)
)

--Insert Values in EmployeeDepartment
insert into EmployeeDepartment values
(3,1),
(2,2),
(1,3),
(3,4)

select * from EmployeeDepartment

------- UC 12: Ensure all retrieve queries done especially in UC 4, UC 5 and UC 7 are working with new table structure -------

--UC 4: Retrieve all Data
SELECT CompanyID,CompanyName,EmployeeID,EmployeeName,EmployeeAddress,EmployeePhoneNumber,StartDate,Gender,BasicPay,Deductions,TaxablePay,IncomeTax,NetPay,DepartName
FROM Company
INNER JOIN Employee ON Company.CompanyID = Employee.CompanyIdentity
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID
INNER JOIN EmployeeDepartment on Employee.EmployeeID=EmployeeDepartment.EmployeeIdentity
INNER JOIN Department on Department.DepartmentId=EmployeeDepartment.DepartmentIdentity

--UC 5: Select Query using Cast() an GetDate()
SELECT CompanyID,CompanyName,EmployeeID,EmployeeName,BasicPay,Deductions,TaxablePay,IncomeTax,NetPay
FROM Company
INNER JOIN Employee ON Company.CompanyID = Employee.CompanyIdentity and StartDate BETWEEN Cast('2012-11-12' as Date) and GetDate()
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID
--Retrieve query based on Name
SELECT CompanyID,CompanyName,EmployeeID,EmployeeName,BasicPay,Deductions,TaxablePay,IncomeTax,NetPay
FROM Company
INNER JOIN Employee ON Company.CompanyID = Employee.CompanyIdentity and Employee.EmployeeName='Saguna Ukade'
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID
--UC 7: Use Aggregate Functions and Group by Gender
select Sum(BasicPay) as "TotalSalary",Gender 
from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender;

select Avg(BasicPay) as "AverageSalary",Gender 
from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender;

select Min(BasicPay) as "MinimumSalary",Gender 
from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender;

select Max(BasicPay)  as "MaximumSalary",Gender 
from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender;

select Count(BasicPay) as "CountSalary",Gender 
from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender;