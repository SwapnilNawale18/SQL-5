--Day 17

select * from AdventureWorks2012.HumanResources.Employee;

create view vwDesignEng
as
Select BusinessEntityID,BirthDate,Gender,HireDate
from AdventureWorks2012.HumanResources.Employee
where JobTitle='Design Engineer';

-- to list the objects of my current db.
sp_help

-- Virtual table
select * from vwDesignEng;

--View does not contains data, it contains schema of itself.
sp_helptext vwDesignEng

--Adding a column to a view
alter view vwDesignEng;
as  
Select BusinessEntityID,BirthDate,Gender,HireDate,VacationHours 
from AdventureWorks2012.HumanResources.Employee  
where JobTitle='Design Engineer';         

--update vacation hours where where BusinessEntity ID is 15
UPDATE vwDesignEng
SET VacationHours = 15
WHERE BusinessEntityID = 5

create view vwEmployeeDepartment
as
select Name,d.ModifiedDate,GroupName,edh.BusinessEntityID,
edh.ShiftID
from AdventureWorks2012.HumanResources.Department d join
AdventureWorks2012.HumanResources.EmployeeDepartmentHistory edh
on d.DepartmentID=edh.DepartmentID
where BusinessEntityID=46;

select * from vwEmployeeDepartment;

-- cannot update multiple base tables using single update st.
update vwEmployeeDepartment
set GroupName='Manufcng', ShiftID=2
where BusinessEntityID=46;
--We cannot update columns of different tables using single update statement

select * from AdventureWorks2012.HumanResources.Employee
where BusinessEntityID=5;

sp_rename 'vwDesignEng', 'vwDesignEngineer';

drop view vwDesingEngineer;

create view vwEmployee
as
select JobTitle,MaritalStatus,Gender
from AdventureWorks2012.HumanResources.Employee

select * from vwEmployee
--- View doesn't contains data. View contains definition of itself.

create view vwEmployeePH
as
select * from AdventureWorks2012.HumanResources.EmployeePayHistory
order by Rate desc
--We cannot use order by clause on views

select * from vwEmployeePH;

sp_helptext vwEmployee;
--specify structure of view

--Alter View to add VacationHours
alter view vwEmployee  
as  
select JobTitle,MaritalStatus,Gender,VacationHours
from AdventureWorks2012.HumanResources.Employee;

select * from vwEmployee

--Display departmentname of employeeid=46 using subquery

create view vwDeptName
as
select Name
from AdventureWorks2012.HumanResources.Department
where DepartmentID=(select DepartmentID 
from AdventureWorks2012.HumanResources.EmployeeDepartmentHistory
where  BusinessEntityID=46 and EndDate is null)

select * from vwDeptName;


create view vwCananda
as
select StateProvinceID,StateProvinceCode,Name,TerritoryID
from AdventureWorks2012.Person.StateProvince
where CountryRegionCode ='CA';

create view vwUS
as
select StateProvinceID,StateProvinceCode,Name,TerritoryID
from AdventureWorks2012.Person.StateProvince
where CountryRegionCode ='US';

--Creating Views from multiple DBs
create view vwEmployeeBooks
as
select emp.FirstName,cw.BookName
from CrossWorld cw, 
AdventureWorks2012.Person.Person emp

select * from vwEmployeeBooks;

--Write A QUERY TODisplay the BisinessEntityIDs of employees whose JobTitle is same as NationalIDNumber is 658797903
Select * from AdventureWorks2012.HumanResources.Employee;

--Step 1.Framing inner query first: Find the designation of vikas
select JobTitle
from AdventureWorks2012.HumanResources.Employee
where NationalIDNumber=658797903;

--Step 2.Framing outer query: Display other employee as same designation
select BusinessEntityID
from AdventureWorks2012.HumanResources.Employee
where JobTitle='Research and Development Engineer';

--Step3: PUT 1st QUERY INSIDE SECOND QUERY
select BusinessEntityID
from AdventureWorks2012.HumanResources.Employee
where JobTitle=
(
select JobTitle
from AdventureWorks2012.HumanResources.Employee
where NationalIDNumber=658797903
);

--dsiplay employeeid, loginid whose vacationhours is > than avg vh
--Subquery
select BusinessEntityID, LoginID, VacationHours
from AdventureWorks2012.HumanResources.Employee where
VacationHours>(select AVG(VacationHours)
from AdventureWorks2012.HumanResources.Employee)
order by VacationHours;

--display the departmenthistory of employeeid = 46;
select BusinessEntityID,d.DepartmentID,ShiftID
from AdventureWorks2012.HumanResources.Department d
inner join AdventureWorks2012.HumanResources.EmployeeDepartmentHistory dh
on d.DepartmentID=dh.DepartmentID
where BusinessEntityID=46
order by DepartmentID;

--Display deptname of empid 46
--Using Subquery
select Name
from AdventureWorks2012.HumanResources.Department
where DepartmentID=(select DepartmentID
from AdventureWorks2012.HumanResources.EmployeeDepartmentHistory 
where BusinessEntityID=46);

--Using Joins
select Name
from AdventureWorks2012.HumanResources.Department d
join AdventureWorks2012.HumanResources.EmployeeDepartmentHistory dh
on d.DepartmentID=dh.DepartmentID
where BusinessEntityID=46

--list the employeeid of city bothell
--Using Joins
select BusinessEntityID, ea.AddressID
from AdventureWorks2012.Person.BusinessEntityAddress ea 
inner join AdventureWorks2012.Person.Address a
on ea.AddressID=a.AddressID
where City='Bothell'

--Using subquery
select BusinessEntityID
from AdventureWorks2012.Person.BusinessEntityAddress 
where AddressID in(select AddressID
from AdventureWorks2012.Person.Address 
where City='Bothell')

use AdventureWorks2012;
CREATE VIEW [Sales].[vwSalesPerson]   
AS   
SELECT   
    s.[BusinessEntityID] ,p.[Title],p.[FirstName],p.[MiddleName]  
    ,p.[LastName]  
    ,p.[Suffix]  
    ,e.[JobTitle]  
    ,pp.[PhoneNumber]  
 ,pnt.[Name] AS [PhoneNumberType]  
    ,ea.[EmailAddress]  
    ,p.[EmailPromotion]  
    ,a.[AddressLine1]  
    ,a.[AddressLine2]  
    ,a.[City]  
    ,[StateProvinceName] = sp.[Name]  
    ,a.[PostalCode]  
    ,[CountryRegionName] = cr.[Name]  
    ,[TerritoryName] = st.[Name]  
    ,[TerritoryGroup] = st.[Group]  
    ,s.[SalesQuota]  
    ,s.[SalesYTD]  
    ,s.[SalesLastYear]  
FROM [Sales].[SalesPerson] s  
    INNER JOIN [HumanResources].[Employee] e   
    ON e.[BusinessEntityID] = s.[BusinessEntityID]  
 INNER JOIN [Person].[Person] p  
 ON p.[BusinessEntityID] = s.[BusinessEntityID]  
    INNER JOIN [Person].[BusinessEntityAddress] bea   
    ON bea.[BusinessEntityID] = s.[BusinessEntityID]   
    INNER JOIN [Person].[Address] a   
    ON a.[AddressID] = bea.[AddressID]  
    INNER JOIN [Person].[StateProvince] sp   
    ON sp.[StateProvinceID] = a.[StateProvinceID]  
    INNER JOIN [Person].[CountryRegion] cr   
    ON cr.[CountryRegionCode] = sp.[CountryRegionCode]  
    LEFT OUTER JOIN [Sales].[SalesTerritory] st   
    ON st.[TerritoryID] = s.[TerritoryID]  
 LEFT OUTER JOIN [Person].[EmailAddress] ea  
 ON ea.[BusinessEntityID] = p.[BusinessEntityID]  
 LEFT OUTER JOIN [Person].[PersonPhone] pp  
 ON pp.[BusinessEntityID] = p.[BusinessEntityID]  
 LEFT OUTER JOIN [Person].[PhoneNumberType] pnt  
 ON pnt.[PhoneNumberTypeID] = pp.[PhoneNumberTypeID];  
