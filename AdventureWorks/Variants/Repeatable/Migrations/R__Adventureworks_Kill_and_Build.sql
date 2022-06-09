/*============================================================================
  File:     instawdb.sql

  Summary:  Creates the AdventureWorks sample database. Run this on
  any version of SQL Server (2008R2 or later) to get AdventureWorks for your
  current version.  

  Date:     October 26, 2017
  Updated:  October 26, 2017

------------------------------------------------------------------------------
  This file is part of the Microsoft SQL Server Code Samples.

  Copyright (C) Microsoft Corporation.  All rights reserved.

  This source code is intended only as a supplement to Microsoft
  Development Tools and/or on-line documentation.  See these other
  materials for detailed information regarding Microsoft code samples.

  All data in this database is ficticious.
  
  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
  KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE.
============================================================================*/

/*
 * HOW TO RUN THIS SCRIPT:
 *
 * 1. Enable full-text search on your SQL Server instance. 
 *
 * 2. Open the script inside SQL Server Management Studio and enable SQLCMD mode. 
 *    This option is in the Query menu.
 *
 * 3. Copy this script and the install files to C:\Samples\AdventureWorks, or
 *    set the following environment variable to your own data path.
 */
 -- :setvar SqlSamplesSourceDataPath "C:\Samples\AdventureWorks\"

/*
 * 4. Append the SQL Server version number to database name if you want to
 *    differentiate it from other installs of AdventureWorks.
 */

--:setvar DatabaseName "AdventureWorks"

/* Execute the script
 */

IF 'D:\Database\AdventureWorksData\' IS NULL OR 'D:\Database\AdventureWorksData\' = ''
BEGIN
	RAISERROR(N'The variable SqlSamplesSourceDataPath must be defined.', 16, 127) WITH NOWAIT
	RETURN
END;


SET NOCOUNT OFF;
GO

PRINT CONVERT(varchar(1000), @@VERSION);
GO

PRINT '';
PRINT 'Started - ' + CONVERT(varchar, GETDATE(), 121);
GO



-- ****************************************
-- start of cleanup
-- ****************************************


SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Dropping extended properties'
GO
IF EXISTS (SELECT 1 FROM fn_listextendedproperty(N'Database_Info', NULL, NULL, NULL, NULL, NULL, NULL))
EXEC sp_dropextendedproperty N'Database_Info', NULL, NULL, NULL, NULL, NULL, NULL
GO
IF EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', NULL, NULL, NULL, NULL, NULL, NULL))
EXEC sp_dropextendedproperty N'MS_Description', NULL, NULL, NULL, NULL, NULL, NULL
GO
PRINT N'Dropping foreign keys from [HumanResources].[EmployeeDepartmentHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[HumanResources].[FK_EmployeeDepartmentHistory_Department_DepartmentID]','F') AND parent_object_id = OBJECT_ID(N'[HumanResources].[EmployeeDepartmentHistory]', 'U'))
ALTER TABLE [HumanResources].[EmployeeDepartmentHistory] DROP CONSTRAINT [FK_EmployeeDepartmentHistory_Department_DepartmentID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[HumanResources].[FK_EmployeeDepartmentHistory_Employee_BusinessEntityID]','F') AND parent_object_id = OBJECT_ID(N'[HumanResources].[EmployeeDepartmentHistory]', 'U'))
ALTER TABLE [HumanResources].[EmployeeDepartmentHistory] DROP CONSTRAINT [FK_EmployeeDepartmentHistory_Employee_BusinessEntityID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[HumanResources].[FK_EmployeeDepartmentHistory_Shift_ShiftID]','F') AND parent_object_id = OBJECT_ID(N'[HumanResources].[EmployeeDepartmentHistory]', 'U'))
ALTER TABLE [HumanResources].[EmployeeDepartmentHistory] DROP CONSTRAINT [FK_EmployeeDepartmentHistory_Shift_ShiftID]
GO
PRINT N'Dropping foreign keys from [HumanResources].[EmployeePayHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[HumanResources].[FK_EmployeePayHistory_Employee_BusinessEntityID]','F') AND parent_object_id = OBJECT_ID(N'[HumanResources].[EmployeePayHistory]', 'U'))
ALTER TABLE [HumanResources].[EmployeePayHistory] DROP CONSTRAINT [FK_EmployeePayHistory_Employee_BusinessEntityID]
GO
PRINT N'Dropping foreign keys from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[HumanResources].[FK_Employee_Person_BusinessEntityID]','F') AND parent_object_id = OBJECT_ID(N'[HumanResources].[Employee]', 'U'))
ALTER TABLE [HumanResources].[Employee] DROP CONSTRAINT [FK_Employee_Person_BusinessEntityID]
GO
PRINT N'Dropping foreign keys from [HumanResources].[JobCandidate]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[HumanResources].[FK_JobCandidate_Employee_BusinessEntityID]','F') AND parent_object_id = OBJECT_ID(N'[HumanResources].[JobCandidate]', 'U'))
ALTER TABLE [HumanResources].[JobCandidate] DROP CONSTRAINT [FK_JobCandidate_Employee_BusinessEntityID]
GO
PRINT N'Dropping foreign keys from [Person].[Address]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Person].[FK_Address_StateProvince_StateProvinceID]','F') AND parent_object_id = OBJECT_ID(N'[Person].[Address]', 'U'))
ALTER TABLE [Person].[Address] DROP CONSTRAINT [FK_Address_StateProvince_StateProvinceID]
GO
PRINT N'Dropping foreign keys from [Person].[BusinessEntityAddress]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Person].[FK_BusinessEntityAddress_Address_AddressID]','F') AND parent_object_id = OBJECT_ID(N'[Person].[BusinessEntityAddress]', 'U'))
ALTER TABLE [Person].[BusinessEntityAddress] DROP CONSTRAINT [FK_BusinessEntityAddress_Address_AddressID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Person].[FK_BusinessEntityAddress_AddressType_AddressTypeID]','F') AND parent_object_id = OBJECT_ID(N'[Person].[BusinessEntityAddress]', 'U'))
ALTER TABLE [Person].[BusinessEntityAddress] DROP CONSTRAINT [FK_BusinessEntityAddress_AddressType_AddressTypeID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Person].[FK_BusinessEntityAddress_BusinessEntity_BusinessEntityID]','F') AND parent_object_id = OBJECT_ID(N'[Person].[BusinessEntityAddress]', 'U'))
ALTER TABLE [Person].[BusinessEntityAddress] DROP CONSTRAINT [FK_BusinessEntityAddress_BusinessEntity_BusinessEntityID]
GO
PRINT N'Dropping foreign keys from [Person].[BusinessEntityContact]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Person].[FK_BusinessEntityContact_BusinessEntity_BusinessEntityID]','F') AND parent_object_id = OBJECT_ID(N'[Person].[BusinessEntityContact]', 'U'))
ALTER TABLE [Person].[BusinessEntityContact] DROP CONSTRAINT [FK_BusinessEntityContact_BusinessEntity_BusinessEntityID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Person].[FK_BusinessEntityContact_ContactType_ContactTypeID]','F') AND parent_object_id = OBJECT_ID(N'[Person].[BusinessEntityContact]', 'U'))
ALTER TABLE [Person].[BusinessEntityContact] DROP CONSTRAINT [FK_BusinessEntityContact_ContactType_ContactTypeID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Person].[FK_BusinessEntityContact_Person_PersonID]','F') AND parent_object_id = OBJECT_ID(N'[Person].[BusinessEntityContact]', 'U'))
ALTER TABLE [Person].[BusinessEntityContact] DROP CONSTRAINT [FK_BusinessEntityContact_Person_PersonID]
GO
PRINT N'Dropping foreign keys from [Person].[EmailAddress]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Person].[FK_EmailAddress_Person_BusinessEntityID]','F') AND parent_object_id = OBJECT_ID(N'[Person].[EmailAddress]', 'U'))
ALTER TABLE [Person].[EmailAddress] DROP CONSTRAINT [FK_EmailAddress_Person_BusinessEntityID]
GO
PRINT N'Dropping foreign keys from [Person].[Password]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Person].[FK_Password_Person_BusinessEntityID]','F') AND parent_object_id = OBJECT_ID(N'[Person].[Password]', 'U'))
ALTER TABLE [Person].[Password] DROP CONSTRAINT [FK_Password_Person_BusinessEntityID]
GO
PRINT N'Dropping foreign keys from [Person].[PersonPhone]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Person].[FK_PersonPhone_Person_BusinessEntityID]','F') AND parent_object_id = OBJECT_ID(N'[Person].[PersonPhone]', 'U'))
ALTER TABLE [Person].[PersonPhone] DROP CONSTRAINT [FK_PersonPhone_Person_BusinessEntityID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Person].[FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID]','F') AND parent_object_id = OBJECT_ID(N'[Person].[PersonPhone]', 'U'))
ALTER TABLE [Person].[PersonPhone] DROP CONSTRAINT [FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID]
GO
PRINT N'Dropping foreign keys from [Person].[Person]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Person].[FK_Person_BusinessEntity_BusinessEntityID]','F') AND parent_object_id = OBJECT_ID(N'[Person].[Person]', 'U'))
ALTER TABLE [Person].[Person] DROP CONSTRAINT [FK_Person_BusinessEntity_BusinessEntityID]
GO
PRINT N'Dropping foreign keys from [Person].[StateProvince]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Person].[FK_StateProvince_CountryRegion_CountryRegionCode]','F') AND parent_object_id = OBJECT_ID(N'[Person].[StateProvince]', 'U'))
ALTER TABLE [Person].[StateProvince] DROP CONSTRAINT [FK_StateProvince_CountryRegion_CountryRegionCode]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Person].[FK_StateProvince_SalesTerritory_TerritoryID]','F') AND parent_object_id = OBJECT_ID(N'[Person].[StateProvince]', 'U'))
ALTER TABLE [Person].[StateProvince] DROP CONSTRAINT [FK_StateProvince_SalesTerritory_TerritoryID]
GO
PRINT N'Dropping foreign keys from [Production].[BillOfMaterials]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_BillOfMaterials_Product_ComponentID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[BillOfMaterials]', 'U'))
ALTER TABLE [Production].[BillOfMaterials] DROP CONSTRAINT [FK_BillOfMaterials_Product_ComponentID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_BillOfMaterials_Product_ProductAssemblyID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[BillOfMaterials]', 'U'))
ALTER TABLE [Production].[BillOfMaterials] DROP CONSTRAINT [FK_BillOfMaterials_Product_ProductAssemblyID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_BillOfMaterials_UnitMeasure_UnitMeasureCode]','F') AND parent_object_id = OBJECT_ID(N'[Production].[BillOfMaterials]', 'U'))
ALTER TABLE [Production].[BillOfMaterials] DROP CONSTRAINT [FK_BillOfMaterials_UnitMeasure_UnitMeasureCode]
GO
PRINT N'Dropping foreign keys from [Production].[Document]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_Document_Employee_Owner]','F') AND parent_object_id = OBJECT_ID(N'[Production].[Document]', 'U'))
ALTER TABLE [Production].[Document] DROP CONSTRAINT [FK_Document_Employee_Owner]
GO
PRINT N'Dropping foreign keys from [Production].[ProductCostHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_ProductCostHistory_Product_ProductID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[ProductCostHistory]', 'U'))
ALTER TABLE [Production].[ProductCostHistory] DROP CONSTRAINT [FK_ProductCostHistory_Product_ProductID]
GO
PRINT N'Dropping foreign keys from [Production].[ProductDocument]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_ProductDocument_Document_DocumentNode]','F') AND parent_object_id = OBJECT_ID(N'[Production].[ProductDocument]', 'U'))
ALTER TABLE [Production].[ProductDocument] DROP CONSTRAINT [FK_ProductDocument_Document_DocumentNode]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_ProductDocument_Product_ProductID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[ProductDocument]', 'U'))
ALTER TABLE [Production].[ProductDocument] DROP CONSTRAINT [FK_ProductDocument_Product_ProductID]
GO
PRINT N'Dropping foreign keys from [Production].[ProductInventory]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_ProductInventory_Location_LocationID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[ProductInventory]', 'U'))
ALTER TABLE [Production].[ProductInventory] DROP CONSTRAINT [FK_ProductInventory_Location_LocationID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_ProductInventory_Product_ProductID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[ProductInventory]', 'U'))
ALTER TABLE [Production].[ProductInventory] DROP CONSTRAINT [FK_ProductInventory_Product_ProductID]
GO
PRINT N'Dropping foreign keys from [Production].[ProductListPriceHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_ProductListPriceHistory_Product_ProductID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[ProductListPriceHistory]', 'U'))
ALTER TABLE [Production].[ProductListPriceHistory] DROP CONSTRAINT [FK_ProductListPriceHistory_Product_ProductID]
GO
PRINT N'Dropping foreign keys from [Production].[ProductModelIllustration]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_ProductModelIllustration_Illustration_IllustrationID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[ProductModelIllustration]', 'U'))
ALTER TABLE [Production].[ProductModelIllustration] DROP CONSTRAINT [FK_ProductModelIllustration_Illustration_IllustrationID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_ProductModelIllustration_ProductModel_ProductModelID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[ProductModelIllustration]', 'U'))
ALTER TABLE [Production].[ProductModelIllustration] DROP CONSTRAINT [FK_ProductModelIllustration_ProductModel_ProductModelID]
GO
PRINT N'Dropping foreign keys from [Production].[ProductModelProductDescriptionCulture]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_ProductModelProductDescriptionCulture_Culture_CultureID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[ProductModelProductDescriptionCulture]', 'U'))
ALTER TABLE [Production].[ProductModelProductDescriptionCulture] DROP CONSTRAINT [FK_ProductModelProductDescriptionCulture_Culture_CultureID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[ProductModelProductDescriptionCulture]', 'U'))
ALTER TABLE [Production].[ProductModelProductDescriptionCulture] DROP CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[ProductModelProductDescriptionCulture]', 'U'))
ALTER TABLE [Production].[ProductModelProductDescriptionCulture] DROP CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID]
GO
PRINT N'Dropping foreign keys from [Production].[ProductProductPhoto]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_ProductProductPhoto_Product_ProductID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[ProductProductPhoto]', 'U'))
ALTER TABLE [Production].[ProductProductPhoto] DROP CONSTRAINT [FK_ProductProductPhoto_Product_ProductID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_ProductProductPhoto_ProductPhoto_ProductPhotoID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[ProductProductPhoto]', 'U'))
ALTER TABLE [Production].[ProductProductPhoto] DROP CONSTRAINT [FK_ProductProductPhoto_ProductPhoto_ProductPhotoID]
GO
PRINT N'Dropping foreign keys from [Production].[ProductReview]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_ProductReview_Product_ProductID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[ProductReview]', 'U'))
ALTER TABLE [Production].[ProductReview] DROP CONSTRAINT [FK_ProductReview_Product_ProductID]
GO
PRINT N'Dropping foreign keys from [Production].[ProductSubcategory]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_ProductSubcategory_ProductCategory_ProductCategoryID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[ProductSubcategory]', 'U'))
ALTER TABLE [Production].[ProductSubcategory] DROP CONSTRAINT [FK_ProductSubcategory_ProductCategory_ProductCategoryID]
GO
PRINT N'Dropping foreign keys from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_Product_ProductModel_ProductModelID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[Product]', 'U'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [FK_Product_ProductModel_ProductModelID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_Product_ProductSubcategory_ProductSubcategoryID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[Product]', 'U'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [FK_Product_ProductSubcategory_ProductSubcategoryID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_Product_UnitMeasure_SizeUnitMeasureCode]','F') AND parent_object_id = OBJECT_ID(N'[Production].[Product]', 'U'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [FK_Product_UnitMeasure_SizeUnitMeasureCode]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_Product_UnitMeasure_WeightUnitMeasureCode]','F') AND parent_object_id = OBJECT_ID(N'[Production].[Product]', 'U'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [FK_Product_UnitMeasure_WeightUnitMeasureCode]
GO
PRINT N'Dropping foreign keys from [Production].[TransactionHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_TransactionHistory_Product_ProductID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[TransactionHistory]', 'U'))
ALTER TABLE [Production].[TransactionHistory] DROP CONSTRAINT [FK_TransactionHistory_Product_ProductID]
GO
PRINT N'Dropping foreign keys from [Production].[WorkOrderRouting]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_WorkOrderRouting_Location_LocationID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[WorkOrderRouting]', 'U'))
ALTER TABLE [Production].[WorkOrderRouting] DROP CONSTRAINT [FK_WorkOrderRouting_Location_LocationID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_WorkOrderRouting_WorkOrder_WorkOrderID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[WorkOrderRouting]', 'U'))
ALTER TABLE [Production].[WorkOrderRouting] DROP CONSTRAINT [FK_WorkOrderRouting_WorkOrder_WorkOrderID]
GO
PRINT N'Dropping foreign keys from [Production].[WorkOrder]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_WorkOrder_Product_ProductID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[WorkOrder]', 'U'))
ALTER TABLE [Production].[WorkOrder] DROP CONSTRAINT [FK_WorkOrder_Product_ProductID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Production].[FK_WorkOrder_ScrapReason_ScrapReasonID]','F') AND parent_object_id = OBJECT_ID(N'[Production].[WorkOrder]', 'U'))
ALTER TABLE [Production].[WorkOrder] DROP CONSTRAINT [FK_WorkOrder_ScrapReason_ScrapReasonID]
GO
PRINT N'Dropping foreign keys from [Purchasing].[ProductVendor]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Purchasing].[FK_ProductVendor_Product_ProductID]','F') AND parent_object_id = OBJECT_ID(N'[Purchasing].[ProductVendor]', 'U'))
ALTER TABLE [Purchasing].[ProductVendor] DROP CONSTRAINT [FK_ProductVendor_Product_ProductID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Purchasing].[FK_ProductVendor_UnitMeasure_UnitMeasureCode]','F') AND parent_object_id = OBJECT_ID(N'[Purchasing].[ProductVendor]', 'U'))
ALTER TABLE [Purchasing].[ProductVendor] DROP CONSTRAINT [FK_ProductVendor_UnitMeasure_UnitMeasureCode]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Purchasing].[FK_ProductVendor_Vendor_BusinessEntityID]','F') AND parent_object_id = OBJECT_ID(N'[Purchasing].[ProductVendor]', 'U'))
ALTER TABLE [Purchasing].[ProductVendor] DROP CONSTRAINT [FK_ProductVendor_Vendor_BusinessEntityID]
GO
PRINT N'Dropping foreign keys from [Purchasing].[PurchaseOrderDetail]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Purchasing].[FK_PurchaseOrderDetail_Product_ProductID]','F') AND parent_object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderDetail]', 'U'))
ALTER TABLE [Purchasing].[PurchaseOrderDetail] DROP CONSTRAINT [FK_PurchaseOrderDetail_Product_ProductID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Purchasing].[FK_PurchaseOrderDetail_PurchaseOrderHeader_PurchaseOrderID]','F') AND parent_object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderDetail]', 'U'))
ALTER TABLE [Purchasing].[PurchaseOrderDetail] DROP CONSTRAINT [FK_PurchaseOrderDetail_PurchaseOrderHeader_PurchaseOrderID]
GO
PRINT N'Dropping foreign keys from [Purchasing].[PurchaseOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Purchasing].[FK_PurchaseOrderHeader_Employee_EmployeeID]','F') AND parent_object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]', 'U'))
ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [FK_PurchaseOrderHeader_Employee_EmployeeID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Purchasing].[FK_PurchaseOrderHeader_ShipMethod_ShipMethodID]','F') AND parent_object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]', 'U'))
ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [FK_PurchaseOrderHeader_ShipMethod_ShipMethodID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Purchasing].[FK_PurchaseOrderHeader_Vendor_VendorID]','F') AND parent_object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]', 'U'))
ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [FK_PurchaseOrderHeader_Vendor_VendorID]
GO
PRINT N'Dropping foreign keys from [Purchasing].[Vendor]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Purchasing].[FK_Vendor_BusinessEntity_BusinessEntityID]','F') AND parent_object_id = OBJECT_ID(N'[Purchasing].[Vendor]', 'U'))
ALTER TABLE [Purchasing].[Vendor] DROP CONSTRAINT [FK_Vendor_BusinessEntity_BusinessEntityID]
GO
PRINT N'Dropping foreign keys from [Sales].[CountryRegionCurrency]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_CountryRegionCurrency_CountryRegion_CountryRegionCode]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[CountryRegionCurrency]', 'U'))
ALTER TABLE [Sales].[CountryRegionCurrency] DROP CONSTRAINT [FK_CountryRegionCurrency_CountryRegion_CountryRegionCode]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_CountryRegionCurrency_Currency_CurrencyCode]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[CountryRegionCurrency]', 'U'))
ALTER TABLE [Sales].[CountryRegionCurrency] DROP CONSTRAINT [FK_CountryRegionCurrency_Currency_CurrencyCode]
GO
PRINT N'Dropping foreign keys from [Sales].[CurrencyRate]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_CurrencyRate_Currency_FromCurrencyCode]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[CurrencyRate]', 'U'))
ALTER TABLE [Sales].[CurrencyRate] DROP CONSTRAINT [FK_CurrencyRate_Currency_FromCurrencyCode]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_CurrencyRate_Currency_ToCurrencyCode]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[CurrencyRate]', 'U'))
ALTER TABLE [Sales].[CurrencyRate] DROP CONSTRAINT [FK_CurrencyRate_Currency_ToCurrencyCode]
GO
PRINT N'Dropping foreign keys from [Sales].[Customer]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_Customer_Person_PersonID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[Customer]', 'U'))
ALTER TABLE [Sales].[Customer] DROP CONSTRAINT [FK_Customer_Person_PersonID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_Customer_SalesTerritory_TerritoryID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[Customer]', 'U'))
ALTER TABLE [Sales].[Customer] DROP CONSTRAINT [FK_Customer_SalesTerritory_TerritoryID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_Customer_Store_StoreID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[Customer]', 'U'))
ALTER TABLE [Sales].[Customer] DROP CONSTRAINT [FK_Customer_Store_StoreID]
GO
PRINT N'Dropping foreign keys from [Sales].[PersonCreditCard]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_PersonCreditCard_CreditCard_CreditCardID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[PersonCreditCard]', 'U'))
ALTER TABLE [Sales].[PersonCreditCard] DROP CONSTRAINT [FK_PersonCreditCard_CreditCard_CreditCardID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_PersonCreditCard_Person_BusinessEntityID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[PersonCreditCard]', 'U'))
ALTER TABLE [Sales].[PersonCreditCard] DROP CONSTRAINT [FK_PersonCreditCard_Person_BusinessEntityID]
GO
PRINT N'Dropping foreign keys from [Sales].[SalesOrderDetail]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderDetail]', 'U'))
ALTER TABLE [Sales].[SalesOrderDetail] DROP CONSTRAINT [FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderDetail]', 'U'))
ALTER TABLE [Sales].[SalesOrderDetail] DROP CONSTRAINT [FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID]
GO
PRINT N'Dropping foreign keys from [Sales].[SalesOrderHeaderSalesReason]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesOrderHeaderSalesReason_SalesOrderHeader_SalesOrderID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderHeaderSalesReason]', 'U'))
ALTER TABLE [Sales].[SalesOrderHeaderSalesReason] DROP CONSTRAINT [FK_SalesOrderHeaderSalesReason_SalesOrderHeader_SalesOrderID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesOrderHeaderSalesReason_SalesReason_SalesReasonID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderHeaderSalesReason]', 'U'))
ALTER TABLE [Sales].[SalesOrderHeaderSalesReason] DROP CONSTRAINT [FK_SalesOrderHeaderSalesReason_SalesReason_SalesReasonID]
GO
PRINT N'Dropping foreign keys from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesOrderHeader_Address_BillToAddressID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [FK_SalesOrderHeader_Address_BillToAddressID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesOrderHeader_Address_ShipToAddressID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [FK_SalesOrderHeader_Address_ShipToAddressID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesOrderHeader_CreditCard_CreditCardID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [FK_SalesOrderHeader_CreditCard_CreditCardID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesOrderHeader_CurrencyRate_CurrencyRateID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [FK_SalesOrderHeader_CurrencyRate_CurrencyRateID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesOrderHeader_Customer_CustomerID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [FK_SalesOrderHeader_Customer_CustomerID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesOrderHeader_SalesPerson_SalesPersonID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [FK_SalesOrderHeader_SalesPerson_SalesPersonID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesOrderHeader_SalesTerritory_TerritoryID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [FK_SalesOrderHeader_SalesTerritory_TerritoryID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesOrderHeader_ShipMethod_ShipMethodID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [FK_SalesOrderHeader_ShipMethod_ShipMethodID]
GO
PRINT N'Dropping foreign keys from [Sales].[SalesPersonQuotaHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesPersonQuotaHistory_SalesPerson_BusinessEntityID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesPersonQuotaHistory]', 'U'))
ALTER TABLE [Sales].[SalesPersonQuotaHistory] DROP CONSTRAINT [FK_SalesPersonQuotaHistory_SalesPerson_BusinessEntityID]
GO
PRINT N'Dropping foreign keys from [Sales].[SalesPerson]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesPerson_Employee_BusinessEntityID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesPerson]', 'U'))
ALTER TABLE [Sales].[SalesPerson] DROP CONSTRAINT [FK_SalesPerson_Employee_BusinessEntityID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesPerson_SalesTerritory_TerritoryID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesPerson]', 'U'))
ALTER TABLE [Sales].[SalesPerson] DROP CONSTRAINT [FK_SalesPerson_SalesTerritory_TerritoryID]
GO
PRINT N'Dropping foreign keys from [Sales].[SalesTaxRate]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesTaxRate_StateProvince_StateProvinceID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesTaxRate]', 'U'))
ALTER TABLE [Sales].[SalesTaxRate] DROP CONSTRAINT [FK_SalesTaxRate_StateProvince_StateProvinceID]
GO
PRINT N'Dropping foreign keys from [Sales].[SalesTerritoryHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesTerritoryHistory_SalesPerson_BusinessEntityID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesTerritoryHistory]', 'U'))
ALTER TABLE [Sales].[SalesTerritoryHistory] DROP CONSTRAINT [FK_SalesTerritoryHistory_SalesPerson_BusinessEntityID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesTerritoryHistory_SalesTerritory_TerritoryID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesTerritoryHistory]', 'U'))
ALTER TABLE [Sales].[SalesTerritoryHistory] DROP CONSTRAINT [FK_SalesTerritoryHistory_SalesTerritory_TerritoryID]
GO
PRINT N'Dropping foreign keys from [Sales].[SalesTerritory]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SalesTerritory_CountryRegion_CountryRegionCode]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesTerritory]', 'U'))
ALTER TABLE [Sales].[SalesTerritory] DROP CONSTRAINT [FK_SalesTerritory_CountryRegion_CountryRegionCode]
GO
PRINT N'Dropping foreign keys from [Sales].[ShoppingCartItem]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_ShoppingCartItem_Product_ProductID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[ShoppingCartItem]', 'U'))
ALTER TABLE [Sales].[ShoppingCartItem] DROP CONSTRAINT [FK_ShoppingCartItem_Product_ProductID]
GO
PRINT N'Dropping foreign keys from [Sales].[SpecialOfferProduct]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SpecialOfferProduct_Product_ProductID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SpecialOfferProduct]', 'U'))
ALTER TABLE [Sales].[SpecialOfferProduct] DROP CONSTRAINT [FK_SpecialOfferProduct_Product_ProductID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_SpecialOfferProduct_SpecialOffer_SpecialOfferID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[SpecialOfferProduct]', 'U'))
ALTER TABLE [Sales].[SpecialOfferProduct] DROP CONSTRAINT [FK_SpecialOfferProduct_SpecialOffer_SpecialOfferID]
GO
PRINT N'Dropping foreign keys from [Sales].[Store]'
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_Store_BusinessEntity_BusinessEntityID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[Store]', 'U'))
ALTER TABLE [Sales].[Store] DROP CONSTRAINT [FK_Store_BusinessEntity_BusinessEntityID]
GO
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Sales].[FK_Store_SalesPerson_SalesPersonID]','F') AND parent_object_id = OBJECT_ID(N'[Sales].[Store]', 'U'))
ALTER TABLE [Sales].[Store] DROP CONSTRAINT [FK_Store_SalesPerson_SalesPersonID]
GO
PRINT N'Dropping XML index [XMLPATH_Person_Demographics] from [Person].[Person]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'XMLPATH_Person_Demographics' AND object_id = OBJECT_ID(N'[Person].[Person]'))
DROP INDEX [XMLPATH_Person_Demographics] ON [Person].[Person]
GO
PRINT N'Dropping XML index [XMLPROPERTY_Person_Demographics] from [Person].[Person]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'XMLPROPERTY_Person_Demographics' AND object_id = OBJECT_ID(N'[Person].[Person]'))
DROP INDEX [XMLPROPERTY_Person_Demographics] ON [Person].[Person]
GO
PRINT N'Dropping XML index [XMLVALUE_Person_Demographics] from [Person].[Person]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'XMLVALUE_Person_Demographics' AND object_id = OBJECT_ID(N'[Person].[Person]'))
DROP INDEX [XMLVALUE_Person_Demographics] ON [Person].[Person]
GO
PRINT N'Dropping XML index [PXML_Person_AddContact] from [Person].[Person]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'PXML_Person_AddContact' AND object_id = OBJECT_ID(N'[Person].[Person]'))
DROP INDEX [PXML_Person_AddContact] ON [Person].[Person]
GO
PRINT N'Dropping XML index [PXML_Person_Demographics] from [Person].[Person]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'PXML_Person_Demographics' AND object_id = OBJECT_ID(N'[Person].[Person]'))
DROP INDEX [PXML_Person_Demographics] ON [Person].[Person]
GO
PRINT N'Dropping XML index [PXML_ProductModel_CatalogDescription] from [Production].[ProductModel]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'PXML_ProductModel_CatalogDescription' AND object_id = OBJECT_ID(N'[Production].[ProductModel]'))
DROP INDEX [PXML_ProductModel_CatalogDescription] ON [Production].[ProductModel]
GO
PRINT N'Dropping XML index [PXML_ProductModel_Instructions] from [Production].[ProductModel]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'PXML_ProductModel_Instructions' AND object_id = OBJECT_ID(N'[Production].[ProductModel]'))
DROP INDEX [PXML_ProductModel_Instructions] ON [Production].[ProductModel]
GO
PRINT N'Dropping XML index [PXML_Store_Demographics] from [Sales].[Store]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'PXML_Store_Demographics' AND object_id = OBJECT_ID(N'[Sales].[Store]'))
DROP INDEX [PXML_Store_Demographics] ON [Sales].[Store]
GO
PRINT N'Dropping constraints from [HumanResources].[EmployeeDepartmentHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[HumanResources].[CK_EmployeeDepartmentHistory_EndDate]', 'C') AND parent_object_id = OBJECT_ID(N'[HumanResources].[EmployeeDepartmentHistory]', 'U'))
ALTER TABLE [HumanResources].[EmployeeDepartmentHistory] DROP CONSTRAINT [CK_EmployeeDepartmentHistory_EndDate]
GO
PRINT N'Dropping constraints from [HumanResources].[EmployeePayHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[HumanResources].[CK_EmployeePayHistory_Rate]', 'C') AND parent_object_id = OBJECT_ID(N'[HumanResources].[EmployeePayHistory]', 'U'))
ALTER TABLE [HumanResources].[EmployeePayHistory] DROP CONSTRAINT [CK_EmployeePayHistory_Rate]
GO
PRINT N'Dropping constraints from [HumanResources].[EmployeePayHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[HumanResources].[CK_EmployeePayHistory_PayFrequency]', 'C') AND parent_object_id = OBJECT_ID(N'[HumanResources].[EmployeePayHistory]', 'U'))
ALTER TABLE [HumanResources].[EmployeePayHistory] DROP CONSTRAINT [CK_EmployeePayHistory_PayFrequency]
GO
PRINT N'Dropping constraints from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[HumanResources].[CK_Employee_BirthDate]', 'C') AND parent_object_id = OBJECT_ID(N'[HumanResources].[Employee]', 'U'))
ALTER TABLE [HumanResources].[Employee] DROP CONSTRAINT [CK_Employee_BirthDate]
GO
PRINT N'Dropping constraints from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[HumanResources].[CK_Employee_MaritalStatus]', 'C') AND parent_object_id = OBJECT_ID(N'[HumanResources].[Employee]', 'U'))
ALTER TABLE [HumanResources].[Employee] DROP CONSTRAINT [CK_Employee_MaritalStatus]
GO
PRINT N'Dropping constraints from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[HumanResources].[CK_Employee_Gender]', 'C') AND parent_object_id = OBJECT_ID(N'[HumanResources].[Employee]', 'U'))
ALTER TABLE [HumanResources].[Employee] DROP CONSTRAINT [CK_Employee_Gender]
GO
PRINT N'Dropping constraints from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[HumanResources].[CK_Employee_HireDate]', 'C') AND parent_object_id = OBJECT_ID(N'[HumanResources].[Employee]', 'U'))
ALTER TABLE [HumanResources].[Employee] DROP CONSTRAINT [CK_Employee_HireDate]
GO
PRINT N'Dropping constraints from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[HumanResources].[CK_Employee_VacationHours]', 'C') AND parent_object_id = OBJECT_ID(N'[HumanResources].[Employee]', 'U'))
ALTER TABLE [HumanResources].[Employee] DROP CONSTRAINT [CK_Employee_VacationHours]
GO
PRINT N'Dropping constraints from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[HumanResources].[CK_Employee_SickLeaveHours]', 'C') AND parent_object_id = OBJECT_ID(N'[HumanResources].[Employee]', 'U'))
ALTER TABLE [HumanResources].[Employee] DROP CONSTRAINT [CK_Employee_SickLeaveHours]
GO
PRINT N'Dropping constraints from [Person].[Person]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Person].[CK_Person_PersonType]', 'C') AND parent_object_id = OBJECT_ID(N'[Person].[Person]', 'U'))
ALTER TABLE [Person].[Person] DROP CONSTRAINT [CK_Person_PersonType]
GO
PRINT N'Dropping constraints from [Person].[Person]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Person].[CK_Person_EmailPromotion]', 'C') AND parent_object_id = OBJECT_ID(N'[Person].[Person]', 'U'))
ALTER TABLE [Person].[Person] DROP CONSTRAINT [CK_Person_EmailPromotion]
GO
PRINT N'Dropping constraints from [Production].[BillOfMaterials]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_BillOfMaterials_PerAssemblyQty]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[BillOfMaterials]', 'U'))
ALTER TABLE [Production].[BillOfMaterials] DROP CONSTRAINT [CK_BillOfMaterials_PerAssemblyQty]
GO
PRINT N'Dropping constraints from [Production].[BillOfMaterials]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_BillOfMaterials_BOMLevel]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[BillOfMaterials]', 'U'))
ALTER TABLE [Production].[BillOfMaterials] DROP CONSTRAINT [CK_BillOfMaterials_BOMLevel]
GO
PRINT N'Dropping constraints from [Production].[BillOfMaterials]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_BillOfMaterials_EndDate]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[BillOfMaterials]', 'U'))
ALTER TABLE [Production].[BillOfMaterials] DROP CONSTRAINT [CK_BillOfMaterials_EndDate]
GO
PRINT N'Dropping constraints from [Production].[BillOfMaterials]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_BillOfMaterials_ProductAssemblyID]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[BillOfMaterials]', 'U'))
ALTER TABLE [Production].[BillOfMaterials] DROP CONSTRAINT [CK_BillOfMaterials_ProductAssemblyID]
GO
PRINT N'Dropping constraints from [Production].[Document]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_Document_Status]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[Document]', 'U'))
ALTER TABLE [Production].[Document] DROP CONSTRAINT [CK_Document_Status]
GO
PRINT N'Dropping constraints from [Production].[Location]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_Location_CostRate]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[Location]', 'U'))
ALTER TABLE [Production].[Location] DROP CONSTRAINT [CK_Location_CostRate]
GO
PRINT N'Dropping constraints from [Production].[Location]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_Location_Availability]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[Location]', 'U'))
ALTER TABLE [Production].[Location] DROP CONSTRAINT [CK_Location_Availability]
GO
PRINT N'Dropping constraints from [Production].[ProductCostHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_ProductCostHistory_StandardCost]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[ProductCostHistory]', 'U'))
ALTER TABLE [Production].[ProductCostHistory] DROP CONSTRAINT [CK_ProductCostHistory_StandardCost]
GO
PRINT N'Dropping constraints from [Production].[ProductCostHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_ProductCostHistory_EndDate]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[ProductCostHistory]', 'U'))
ALTER TABLE [Production].[ProductCostHistory] DROP CONSTRAINT [CK_ProductCostHistory_EndDate]
GO
PRINT N'Dropping constraints from [Production].[ProductInventory]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_ProductInventory_Shelf]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[ProductInventory]', 'U'))
ALTER TABLE [Production].[ProductInventory] DROP CONSTRAINT [CK_ProductInventory_Shelf]
GO
PRINT N'Dropping constraints from [Production].[ProductInventory]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_ProductInventory_Bin]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[ProductInventory]', 'U'))
ALTER TABLE [Production].[ProductInventory] DROP CONSTRAINT [CK_ProductInventory_Bin]
GO
PRINT N'Dropping constraints from [Production].[ProductListPriceHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_ProductListPriceHistory_ListPrice]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[ProductListPriceHistory]', 'U'))
ALTER TABLE [Production].[ProductListPriceHistory] DROP CONSTRAINT [CK_ProductListPriceHistory_ListPrice]
GO
PRINT N'Dropping constraints from [Production].[ProductListPriceHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_ProductListPriceHistory_EndDate]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[ProductListPriceHistory]', 'U'))
ALTER TABLE [Production].[ProductListPriceHistory] DROP CONSTRAINT [CK_ProductListPriceHistory_EndDate]
GO
PRINT N'Dropping constraints from [Production].[ProductReview]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_ProductReview_Rating]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[ProductReview]', 'U'))
ALTER TABLE [Production].[ProductReview] DROP CONSTRAINT [CK_ProductReview_Rating]
GO
PRINT N'Dropping constraints from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_Product_SafetyStockLevel]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[Product]', 'U'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [CK_Product_SafetyStockLevel]
GO
PRINT N'Dropping constraints from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_Product_ReorderPoint]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[Product]', 'U'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [CK_Product_ReorderPoint]
GO
PRINT N'Dropping constraints from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_Product_StandardCost]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[Product]', 'U'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [CK_Product_StandardCost]
GO
PRINT N'Dropping constraints from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_Product_ListPrice]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[Product]', 'U'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [CK_Product_ListPrice]
GO
PRINT N'Dropping constraints from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_Product_Weight]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[Product]', 'U'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [CK_Product_Weight]
GO
PRINT N'Dropping constraints from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_Product_DaysToManufacture]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[Product]', 'U'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [CK_Product_DaysToManufacture]
GO
PRINT N'Dropping constraints from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_Product_ProductLine]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[Product]', 'U'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [CK_Product_ProductLine]
GO
PRINT N'Dropping constraints from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_Product_Class]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[Product]', 'U'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [CK_Product_Class]
GO
PRINT N'Dropping constraints from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_Product_Style]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[Product]', 'U'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [CK_Product_Style]
GO
PRINT N'Dropping constraints from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_Product_SellEndDate]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[Product]', 'U'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [CK_Product_SellEndDate]
GO
PRINT N'Dropping constraints from [Production].[TransactionHistoryArchive]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_TransactionHistoryArchive_TransactionType]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[TransactionHistoryArchive]', 'U'))
ALTER TABLE [Production].[TransactionHistoryArchive] DROP CONSTRAINT [CK_TransactionHistoryArchive_TransactionType]
GO
PRINT N'Dropping constraints from [Production].[TransactionHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_TransactionHistory_TransactionType]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[TransactionHistory]', 'U'))
ALTER TABLE [Production].[TransactionHistory] DROP CONSTRAINT [CK_TransactionHistory_TransactionType]
GO
PRINT N'Dropping constraints from [Production].[WorkOrderRouting]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_WorkOrderRouting_ActualResourceHrs]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[WorkOrderRouting]', 'U'))
ALTER TABLE [Production].[WorkOrderRouting] DROP CONSTRAINT [CK_WorkOrderRouting_ActualResourceHrs]
GO
PRINT N'Dropping constraints from [Production].[WorkOrderRouting]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_WorkOrderRouting_PlannedCost]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[WorkOrderRouting]', 'U'))
ALTER TABLE [Production].[WorkOrderRouting] DROP CONSTRAINT [CK_WorkOrderRouting_PlannedCost]
GO
PRINT N'Dropping constraints from [Production].[WorkOrderRouting]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_WorkOrderRouting_ActualCost]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[WorkOrderRouting]', 'U'))
ALTER TABLE [Production].[WorkOrderRouting] DROP CONSTRAINT [CK_WorkOrderRouting_ActualCost]
GO
PRINT N'Dropping constraints from [Production].[WorkOrderRouting]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_WorkOrderRouting_ActualEndDate]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[WorkOrderRouting]', 'U'))
ALTER TABLE [Production].[WorkOrderRouting] DROP CONSTRAINT [CK_WorkOrderRouting_ActualEndDate]
GO
PRINT N'Dropping constraints from [Production].[WorkOrderRouting]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_WorkOrderRouting_ScheduledEndDate]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[WorkOrderRouting]', 'U'))
ALTER TABLE [Production].[WorkOrderRouting] DROP CONSTRAINT [CK_WorkOrderRouting_ScheduledEndDate]
GO
PRINT N'Dropping constraints from [Production].[WorkOrder]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_WorkOrder_OrderQty]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[WorkOrder]', 'U'))
ALTER TABLE [Production].[WorkOrder] DROP CONSTRAINT [CK_WorkOrder_OrderQty]
GO
PRINT N'Dropping constraints from [Production].[WorkOrder]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_WorkOrder_ScrappedQty]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[WorkOrder]', 'U'))
ALTER TABLE [Production].[WorkOrder] DROP CONSTRAINT [CK_WorkOrder_ScrappedQty]
GO
PRINT N'Dropping constraints from [Production].[WorkOrder]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Production].[CK_WorkOrder_EndDate]', 'C') AND parent_object_id = OBJECT_ID(N'[Production].[WorkOrder]', 'U'))
ALTER TABLE [Production].[WorkOrder] DROP CONSTRAINT [CK_WorkOrder_EndDate]
GO
PRINT N'Dropping constraints from [Purchasing].[ProductVendor]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Purchasing].[CK_ProductVendor_AverageLeadTime]', 'C') AND parent_object_id = OBJECT_ID(N'[Purchasing].[ProductVendor]', 'U'))
ALTER TABLE [Purchasing].[ProductVendor] DROP CONSTRAINT [CK_ProductVendor_AverageLeadTime]
GO
PRINT N'Dropping constraints from [Purchasing].[ProductVendor]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Purchasing].[CK_ProductVendor_StandardPrice]', 'C') AND parent_object_id = OBJECT_ID(N'[Purchasing].[ProductVendor]', 'U'))
ALTER TABLE [Purchasing].[ProductVendor] DROP CONSTRAINT [CK_ProductVendor_StandardPrice]
GO
PRINT N'Dropping constraints from [Purchasing].[ProductVendor]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Purchasing].[CK_ProductVendor_LastReceiptCost]', 'C') AND parent_object_id = OBJECT_ID(N'[Purchasing].[ProductVendor]', 'U'))
ALTER TABLE [Purchasing].[ProductVendor] DROP CONSTRAINT [CK_ProductVendor_LastReceiptCost]
GO
PRINT N'Dropping constraints from [Purchasing].[ProductVendor]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Purchasing].[CK_ProductVendor_MinOrderQty]', 'C') AND parent_object_id = OBJECT_ID(N'[Purchasing].[ProductVendor]', 'U'))
ALTER TABLE [Purchasing].[ProductVendor] DROP CONSTRAINT [CK_ProductVendor_MinOrderQty]
GO
PRINT N'Dropping constraints from [Purchasing].[ProductVendor]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Purchasing].[CK_ProductVendor_MaxOrderQty]', 'C') AND parent_object_id = OBJECT_ID(N'[Purchasing].[ProductVendor]', 'U'))
ALTER TABLE [Purchasing].[ProductVendor] DROP CONSTRAINT [CK_ProductVendor_MaxOrderQty]
GO
PRINT N'Dropping constraints from [Purchasing].[ProductVendor]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Purchasing].[CK_ProductVendor_OnOrderQty]', 'C') AND parent_object_id = OBJECT_ID(N'[Purchasing].[ProductVendor]', 'U'))
ALTER TABLE [Purchasing].[ProductVendor] DROP CONSTRAINT [CK_ProductVendor_OnOrderQty]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderDetail]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Purchasing].[CK_PurchaseOrderDetail_OrderQty]', 'C') AND parent_object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderDetail]', 'U'))
ALTER TABLE [Purchasing].[PurchaseOrderDetail] DROP CONSTRAINT [CK_PurchaseOrderDetail_OrderQty]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderDetail]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Purchasing].[CK_PurchaseOrderDetail_UnitPrice]', 'C') AND parent_object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderDetail]', 'U'))
ALTER TABLE [Purchasing].[PurchaseOrderDetail] DROP CONSTRAINT [CK_PurchaseOrderDetail_UnitPrice]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderDetail]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Purchasing].[CK_PurchaseOrderDetail_ReceivedQty]', 'C') AND parent_object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderDetail]', 'U'))
ALTER TABLE [Purchasing].[PurchaseOrderDetail] DROP CONSTRAINT [CK_PurchaseOrderDetail_ReceivedQty]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderDetail]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Purchasing].[CK_PurchaseOrderDetail_RejectedQty]', 'C') AND parent_object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderDetail]', 'U'))
ALTER TABLE [Purchasing].[PurchaseOrderDetail] DROP CONSTRAINT [CK_PurchaseOrderDetail_RejectedQty]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Purchasing].[CK_PurchaseOrderHeader_Status]', 'C') AND parent_object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]', 'U'))
ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [CK_PurchaseOrderHeader_Status]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Purchasing].[CK_PurchaseOrderHeader_SubTotal]', 'C') AND parent_object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]', 'U'))
ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [CK_PurchaseOrderHeader_SubTotal]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Purchasing].[CK_PurchaseOrderHeader_TaxAmt]', 'C') AND parent_object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]', 'U'))
ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [CK_PurchaseOrderHeader_TaxAmt]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Purchasing].[CK_PurchaseOrderHeader_Freight]', 'C') AND parent_object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]', 'U'))
ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [CK_PurchaseOrderHeader_Freight]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Purchasing].[CK_PurchaseOrderHeader_ShipDate]', 'C') AND parent_object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]', 'U'))
ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [CK_PurchaseOrderHeader_ShipDate]
GO
PRINT N'Dropping constraints from [Purchasing].[ShipMethod]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Purchasing].[CK_ShipMethod_ShipBase]', 'C') AND parent_object_id = OBJECT_ID(N'[Purchasing].[ShipMethod]', 'U'))
ALTER TABLE [Purchasing].[ShipMethod] DROP CONSTRAINT [CK_ShipMethod_ShipBase]
GO
PRINT N'Dropping constraints from [Purchasing].[ShipMethod]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Purchasing].[CK_ShipMethod_ShipRate]', 'C') AND parent_object_id = OBJECT_ID(N'[Purchasing].[ShipMethod]', 'U'))
ALTER TABLE [Purchasing].[ShipMethod] DROP CONSTRAINT [CK_ShipMethod_ShipRate]
GO
PRINT N'Dropping constraints from [Purchasing].[Vendor]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Purchasing].[CK_Vendor_CreditRating]', 'C') AND parent_object_id = OBJECT_ID(N'[Purchasing].[Vendor]', 'U'))
ALTER TABLE [Purchasing].[Vendor] DROP CONSTRAINT [CK_Vendor_CreditRating]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderDetail]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesOrderDetail_OrderQty]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderDetail]', 'U'))
ALTER TABLE [Sales].[SalesOrderDetail] DROP CONSTRAINT [CK_SalesOrderDetail_OrderQty]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderDetail]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesOrderDetail_UnitPrice]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderDetail]', 'U'))
ALTER TABLE [Sales].[SalesOrderDetail] DROP CONSTRAINT [CK_SalesOrderDetail_UnitPrice]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderDetail]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesOrderDetail_UnitPriceDiscount]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderDetail]', 'U'))
ALTER TABLE [Sales].[SalesOrderDetail] DROP CONSTRAINT [CK_SalesOrderDetail_UnitPriceDiscount]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesOrderHeader_Status]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [CK_SalesOrderHeader_Status]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesOrderHeader_SubTotal]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [CK_SalesOrderHeader_SubTotal]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesOrderHeader_TaxAmt]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [CK_SalesOrderHeader_TaxAmt]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesOrderHeader_Freight]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [CK_SalesOrderHeader_Freight]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesOrderHeader_DueDate]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [CK_SalesOrderHeader_DueDate]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesOrderHeader_ShipDate]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [CK_SalesOrderHeader_ShipDate]
GO
PRINT N'Dropping constraints from [Sales].[SalesPersonQuotaHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesPersonQuotaHistory_SalesQuota]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesPersonQuotaHistory]', 'U'))
ALTER TABLE [Sales].[SalesPersonQuotaHistory] DROP CONSTRAINT [CK_SalesPersonQuotaHistory_SalesQuota]
GO
PRINT N'Dropping constraints from [Sales].[SalesPerson]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesPerson_SalesQuota]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesPerson]', 'U'))
ALTER TABLE [Sales].[SalesPerson] DROP CONSTRAINT [CK_SalesPerson_SalesQuota]
GO
PRINT N'Dropping constraints from [Sales].[SalesPerson]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesPerson_Bonus]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesPerson]', 'U'))
ALTER TABLE [Sales].[SalesPerson] DROP CONSTRAINT [CK_SalesPerson_Bonus]
GO
PRINT N'Dropping constraints from [Sales].[SalesPerson]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesPerson_CommissionPct]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesPerson]', 'U'))
ALTER TABLE [Sales].[SalesPerson] DROP CONSTRAINT [CK_SalesPerson_CommissionPct]
GO
PRINT N'Dropping constraints from [Sales].[SalesPerson]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesPerson_SalesYTD]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesPerson]', 'U'))
ALTER TABLE [Sales].[SalesPerson] DROP CONSTRAINT [CK_SalesPerson_SalesYTD]
GO
PRINT N'Dropping constraints from [Sales].[SalesPerson]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesPerson_SalesLastYear]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesPerson]', 'U'))
ALTER TABLE [Sales].[SalesPerson] DROP CONSTRAINT [CK_SalesPerson_SalesLastYear]
GO
PRINT N'Dropping constraints from [Sales].[SalesTaxRate]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesTaxRate_TaxType]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesTaxRate]', 'U'))
ALTER TABLE [Sales].[SalesTaxRate] DROP CONSTRAINT [CK_SalesTaxRate_TaxType]
GO
PRINT N'Dropping constraints from [Sales].[SalesTerritoryHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesTerritoryHistory_EndDate]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesTerritoryHistory]', 'U'))
ALTER TABLE [Sales].[SalesTerritoryHistory] DROP CONSTRAINT [CK_SalesTerritoryHistory_EndDate]
GO
PRINT N'Dropping constraints from [Sales].[SalesTerritory]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesTerritory_SalesYTD]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesTerritory]', 'U'))
ALTER TABLE [Sales].[SalesTerritory] DROP CONSTRAINT [CK_SalesTerritory_SalesYTD]
GO
PRINT N'Dropping constraints from [Sales].[SalesTerritory]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesTerritory_SalesLastYear]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesTerritory]', 'U'))
ALTER TABLE [Sales].[SalesTerritory] DROP CONSTRAINT [CK_SalesTerritory_SalesLastYear]
GO
PRINT N'Dropping constraints from [Sales].[SalesTerritory]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesTerritory_CostYTD]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesTerritory]', 'U'))
ALTER TABLE [Sales].[SalesTerritory] DROP CONSTRAINT [CK_SalesTerritory_CostYTD]
GO
PRINT N'Dropping constraints from [Sales].[SalesTerritory]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SalesTerritory_CostLastYear]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesTerritory]', 'U'))
ALTER TABLE [Sales].[SalesTerritory] DROP CONSTRAINT [CK_SalesTerritory_CostLastYear]
GO
PRINT N'Dropping constraints from [Sales].[ShoppingCartItem]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_ShoppingCartItem_Quantity]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[ShoppingCartItem]', 'U'))
ALTER TABLE [Sales].[ShoppingCartItem] DROP CONSTRAINT [CK_ShoppingCartItem_Quantity]
GO
PRINT N'Dropping constraints from [Sales].[SpecialOffer]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SpecialOffer_DiscountPct]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SpecialOffer]', 'U'))
ALTER TABLE [Sales].[SpecialOffer] DROP CONSTRAINT [CK_SpecialOffer_DiscountPct]
GO
PRINT N'Dropping constraints from [Sales].[SpecialOffer]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SpecialOffer_MinQty]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SpecialOffer]', 'U'))
ALTER TABLE [Sales].[SpecialOffer] DROP CONSTRAINT [CK_SpecialOffer_MinQty]
GO
PRINT N'Dropping constraints from [Sales].[SpecialOffer]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SpecialOffer_MaxQty]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SpecialOffer]', 'U'))
ALTER TABLE [Sales].[SpecialOffer] DROP CONSTRAINT [CK_SpecialOffer_MaxQty]
GO
PRINT N'Dropping constraints from [Sales].[SpecialOffer]'
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Sales].[CK_SpecialOffer_EndDate]', 'C') AND parent_object_id = OBJECT_ID(N'[Sales].[SpecialOffer]', 'U'))
ALTER TABLE [Sales].[SpecialOffer] DROP CONSTRAINT [CK_SpecialOffer_EndDate]
GO
PRINT N'Dropping constraints from [HumanResources].[Department]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[HumanResources].[PK_Department_DepartmentID]', 'PK') AND parent_object_id = OBJECT_ID(N'[HumanResources].[Department]', 'U'))
ALTER TABLE [HumanResources].[Department] DROP CONSTRAINT [PK_Department_DepartmentID]
GO
PRINT N'Dropping constraints from [HumanResources].[EmployeeDepartmentHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[HumanResources].[PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_DepartmentID]', 'PK') AND parent_object_id = OBJECT_ID(N'[HumanResources].[EmployeeDepartmentHistory]', 'U'))
ALTER TABLE [HumanResources].[EmployeeDepartmentHistory] DROP CONSTRAINT [PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_DepartmentID]
GO
PRINT N'Dropping constraints from [HumanResources].[EmployeePayHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[HumanResources].[PK_EmployeePayHistory_BusinessEntityID_RateChangeDate]', 'PK') AND parent_object_id = OBJECT_ID(N'[HumanResources].[EmployeePayHistory]', 'U'))
ALTER TABLE [HumanResources].[EmployeePayHistory] DROP CONSTRAINT [PK_EmployeePayHistory_BusinessEntityID_RateChangeDate]
GO
PRINT N'Dropping constraints from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[HumanResources].[PK_Employee_BusinessEntityID]', 'PK') AND parent_object_id = OBJECT_ID(N'[HumanResources].[Employee]', 'U'))
ALTER TABLE [HumanResources].[Employee] DROP CONSTRAINT [PK_Employee_BusinessEntityID]
GO
PRINT N'Dropping constraints from [HumanResources].[JobCandidate]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[HumanResources].[PK_JobCandidate_JobCandidateID]', 'PK') AND parent_object_id = OBJECT_ID(N'[HumanResources].[JobCandidate]', 'U'))
ALTER TABLE [HumanResources].[JobCandidate] DROP CONSTRAINT [PK_JobCandidate_JobCandidateID]
GO
PRINT N'Dropping constraints from [HumanResources].[Shift]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[HumanResources].[PK_Shift_ShiftID]', 'PK') AND parent_object_id = OBJECT_ID(N'[HumanResources].[Shift]', 'U'))
ALTER TABLE [HumanResources].[Shift] DROP CONSTRAINT [PK_Shift_ShiftID]
GO
PRINT N'Dropping constraints from [Person].[AddressType]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Person].[PK_AddressType_AddressTypeID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Person].[AddressType]', 'U'))
ALTER TABLE [Person].[AddressType] DROP CONSTRAINT [PK_AddressType_AddressTypeID]
GO
PRINT N'Dropping constraints from [Person].[Address]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Person].[PK_Address_AddressID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Person].[Address]', 'U'))
ALTER TABLE [Person].[Address] DROP CONSTRAINT [PK_Address_AddressID]
GO
PRINT N'Dropping constraints from [Person].[BusinessEntityAddress]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Person].[PK_BusinessEntityAddress_BusinessEntityID_AddressID_AddressTypeID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Person].[BusinessEntityAddress]', 'U'))
ALTER TABLE [Person].[BusinessEntityAddress] DROP CONSTRAINT [PK_BusinessEntityAddress_BusinessEntityID_AddressID_AddressTypeID]
GO
PRINT N'Dropping constraints from [Person].[BusinessEntityContact]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Person].[PK_BusinessEntityContact_BusinessEntityID_PersonID_ContactTypeID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Person].[BusinessEntityContact]', 'U'))
ALTER TABLE [Person].[BusinessEntityContact] DROP CONSTRAINT [PK_BusinessEntityContact_BusinessEntityID_PersonID_ContactTypeID]
GO
PRINT N'Dropping constraints from [Person].[BusinessEntity]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Person].[PK_BusinessEntity_BusinessEntityID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Person].[BusinessEntity]', 'U'))
ALTER TABLE [Person].[BusinessEntity] DROP CONSTRAINT [PK_BusinessEntity_BusinessEntityID]
GO
PRINT N'Dropping constraints from [Person].[ContactType]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Person].[PK_ContactType_ContactTypeID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Person].[ContactType]', 'U'))
ALTER TABLE [Person].[ContactType] DROP CONSTRAINT [PK_ContactType_ContactTypeID]
GO
PRINT N'Dropping constraints from [Person].[CountryRegion]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Person].[PK_CountryRegion_CountryRegionCode]', 'PK') AND parent_object_id = OBJECT_ID(N'[Person].[CountryRegion]', 'U'))
ALTER TABLE [Person].[CountryRegion] DROP CONSTRAINT [PK_CountryRegion_CountryRegionCode]
GO
PRINT N'Dropping constraints from [Person].[EmailAddress]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Person].[PK_EmailAddress_BusinessEntityID_EmailAddressID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Person].[EmailAddress]', 'U'))
ALTER TABLE [Person].[EmailAddress] DROP CONSTRAINT [PK_EmailAddress_BusinessEntityID_EmailAddressID]
GO
PRINT N'Dropping constraints from [Person].[Password]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Person].[PK_Password_BusinessEntityID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Person].[Password]', 'U'))
ALTER TABLE [Person].[Password] DROP CONSTRAINT [PK_Password_BusinessEntityID]
GO
PRINT N'Dropping constraints from [Person].[PersonPhone]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Person].[PK_PersonPhone_BusinessEntityID_PhoneNumber_PhoneNumberTypeID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Person].[PersonPhone]', 'U'))
ALTER TABLE [Person].[PersonPhone] DROP CONSTRAINT [PK_PersonPhone_BusinessEntityID_PhoneNumber_PhoneNumberTypeID]
GO
PRINT N'Dropping constraints from [Person].[Person]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Person].[PK_Person_BusinessEntityID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Person].[Person]', 'U'))
ALTER TABLE [Person].[Person] DROP CONSTRAINT [PK_Person_BusinessEntityID]
GO
PRINT N'Dropping constraints from [Person].[PhoneNumberType]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Person].[PK_PhoneNumberType_PhoneNumberTypeID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Person].[PhoneNumberType]', 'U'))
ALTER TABLE [Person].[PhoneNumberType] DROP CONSTRAINT [PK_PhoneNumberType_PhoneNumberTypeID]
GO
PRINT N'Dropping constraints from [Person].[StateProvince]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Person].[PK_StateProvince_StateProvinceID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Person].[StateProvince]', 'U'))
ALTER TABLE [Person].[StateProvince] DROP CONSTRAINT [PK_StateProvince_StateProvinceID]
GO
PRINT N'Dropping constraints from [Production].[BillOfMaterials]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_BillOfMaterials_BillOfMaterialsID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[BillOfMaterials]', 'U'))
ALTER TABLE [Production].[BillOfMaterials] DROP CONSTRAINT [PK_BillOfMaterials_BillOfMaterialsID]
GO
PRINT N'Dropping constraints from [Production].[Culture]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_Culture_CultureID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[Culture]', 'U'))
ALTER TABLE [Production].[Culture] DROP CONSTRAINT [PK_Culture_CultureID]
GO
PRINT N'Dropping constraints from [Production].[Document]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_Document_DocumentNode]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[Document]', 'U'))
ALTER TABLE [Production].[Document] DROP CONSTRAINT [PK_Document_DocumentNode]
GO
PRINT N'Dropping constraints from [Production].[Document]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[UQ__Document__F73921F776296166]', 'UQ') AND parent_object_id = OBJECT_ID(N'[Production].[Document]', 'U'))
ALTER TABLE [Production].[Document] DROP CONSTRAINT [UQ__Document__F73921F776296166]
GO
PRINT N'Dropping constraints from [Production].[Illustration]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_Illustration_IllustrationID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[Illustration]', 'U'))
ALTER TABLE [Production].[Illustration] DROP CONSTRAINT [PK_Illustration_IllustrationID]
GO
PRINT N'Dropping constraints from [Production].[Location]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_Location_LocationID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[Location]', 'U'))
ALTER TABLE [Production].[Location] DROP CONSTRAINT [PK_Location_LocationID]
GO
PRINT N'Dropping constraints from [Production].[ProductCategory]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_ProductCategory_ProductCategoryID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[ProductCategory]', 'U'))
ALTER TABLE [Production].[ProductCategory] DROP CONSTRAINT [PK_ProductCategory_ProductCategoryID]
GO
PRINT N'Dropping constraints from [Production].[ProductCostHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_ProductCostHistory_ProductID_StartDate]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[ProductCostHistory]', 'U'))
ALTER TABLE [Production].[ProductCostHistory] DROP CONSTRAINT [PK_ProductCostHistory_ProductID_StartDate]
GO
PRINT N'Dropping constraints from [Production].[ProductDescription]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_ProductDescription_ProductDescriptionID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[ProductDescription]', 'U'))
ALTER TABLE [Production].[ProductDescription] DROP CONSTRAINT [PK_ProductDescription_ProductDescriptionID]
GO
PRINT N'Dropping constraints from [Production].[ProductDocument]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_ProductDocument_ProductID_DocumentNode]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[ProductDocument]', 'U'))
ALTER TABLE [Production].[ProductDocument] DROP CONSTRAINT [PK_ProductDocument_ProductID_DocumentNode]
GO
PRINT N'Dropping constraints from [Production].[ProductInventory]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_ProductInventory_ProductID_LocationID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[ProductInventory]', 'U'))
ALTER TABLE [Production].[ProductInventory] DROP CONSTRAINT [PK_ProductInventory_ProductID_LocationID]
GO
PRINT N'Dropping constraints from [Production].[ProductListPriceHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_ProductListPriceHistory_ProductID_StartDate]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[ProductListPriceHistory]', 'U'))
ALTER TABLE [Production].[ProductListPriceHistory] DROP CONSTRAINT [PK_ProductListPriceHistory_ProductID_StartDate]
GO
PRINT N'Dropping constraints from [Production].[ProductModelIllustration]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_ProductModelIllustration_ProductModelID_IllustrationID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[ProductModelIllustration]', 'U'))
ALTER TABLE [Production].[ProductModelIllustration] DROP CONSTRAINT [PK_ProductModelIllustration_ProductModelID_IllustrationID]
GO
PRINT N'Dropping constraints from [Production].[ProductModelProductDescriptionCulture]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_ProductModelProductDescriptionCulture_ProductModelID_ProductDescriptionID_CultureID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[ProductModelProductDescriptionCulture]', 'U'))
ALTER TABLE [Production].[ProductModelProductDescriptionCulture] DROP CONSTRAINT [PK_ProductModelProductDescriptionCulture_ProductModelID_ProductDescriptionID_CultureID]
GO
PRINT N'Dropping constraints from [Production].[ProductModel]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_ProductModel_ProductModelID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[ProductModel]', 'U'))
ALTER TABLE [Production].[ProductModel] DROP CONSTRAINT [PK_ProductModel_ProductModelID]
GO
PRINT N'Dropping constraints from [Production].[ProductPhoto]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_ProductPhoto_ProductPhotoID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[ProductPhoto]', 'U'))
ALTER TABLE [Production].[ProductPhoto] DROP CONSTRAINT [PK_ProductPhoto_ProductPhotoID]
GO
PRINT N'Dropping constraints from [Production].[ProductProductPhoto]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_ProductProductPhoto_ProductID_ProductPhotoID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[ProductProductPhoto]', 'U'))
ALTER TABLE [Production].[ProductProductPhoto] DROP CONSTRAINT [PK_ProductProductPhoto_ProductID_ProductPhotoID]
GO
PRINT N'Dropping constraints from [Production].[ProductReview]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_ProductReview_ProductReviewID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[ProductReview]', 'U'))
ALTER TABLE [Production].[ProductReview] DROP CONSTRAINT [PK_ProductReview_ProductReviewID]
GO
PRINT N'Dropping constraints from [Production].[ProductSubcategory]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_ProductSubcategory_ProductSubcategoryID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[ProductSubcategory]', 'U'))
ALTER TABLE [Production].[ProductSubcategory] DROP CONSTRAINT [PK_ProductSubcategory_ProductSubcategoryID]
GO
PRINT N'Dropping constraints from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_Product_ProductID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[Product]', 'U'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [PK_Product_ProductID]
GO
PRINT N'Dropping constraints from [Production].[ScrapReason]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_ScrapReason_ScrapReasonID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[ScrapReason]', 'U'))
ALTER TABLE [Production].[ScrapReason] DROP CONSTRAINT [PK_ScrapReason_ScrapReasonID]
GO
PRINT N'Dropping constraints from [Production].[TransactionHistoryArchive]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_TransactionHistoryArchive_TransactionID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[TransactionHistoryArchive]', 'U'))
ALTER TABLE [Production].[TransactionHistoryArchive] DROP CONSTRAINT [PK_TransactionHistoryArchive_TransactionID]
GO
PRINT N'Dropping constraints from [Production].[TransactionHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_TransactionHistory_TransactionID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[TransactionHistory]', 'U'))
ALTER TABLE [Production].[TransactionHistory] DROP CONSTRAINT [PK_TransactionHistory_TransactionID]
GO
PRINT N'Dropping constraints from [Production].[UnitMeasure]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_UnitMeasure_UnitMeasureCode]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[UnitMeasure]', 'U'))
ALTER TABLE [Production].[UnitMeasure] DROP CONSTRAINT [PK_UnitMeasure_UnitMeasureCode]
GO
PRINT N'Dropping constraints from [Production].[WorkOrderRouting]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_WorkOrderRouting_WorkOrderID_ProductID_OperationSequence]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[WorkOrderRouting]', 'U'))
ALTER TABLE [Production].[WorkOrderRouting] DROP CONSTRAINT [PK_WorkOrderRouting_WorkOrderID_ProductID_OperationSequence]
GO
PRINT N'Dropping constraints from [Production].[WorkOrder]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Production].[PK_WorkOrder_WorkOrderID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Production].[WorkOrder]', 'U'))
ALTER TABLE [Production].[WorkOrder] DROP CONSTRAINT [PK_WorkOrder_WorkOrderID]
GO
PRINT N'Dropping constraints from [Purchasing].[ProductVendor]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Purchasing].[PK_ProductVendor_ProductID_BusinessEntityID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Purchasing].[ProductVendor]', 'U'))
ALTER TABLE [Purchasing].[ProductVendor] DROP CONSTRAINT [PK_ProductVendor_ProductID_BusinessEntityID]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderDetail]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Purchasing].[PK_PurchaseOrderDetail_PurchaseOrderID_PurchaseOrderDetailID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderDetail]', 'U'))
ALTER TABLE [Purchasing].[PurchaseOrderDetail] DROP CONSTRAINT [PK_PurchaseOrderDetail_PurchaseOrderID_PurchaseOrderDetailID]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Purchasing].[PK_PurchaseOrderHeader_PurchaseOrderID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]', 'U'))
ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [PK_PurchaseOrderHeader_PurchaseOrderID]
GO
PRINT N'Dropping constraints from [Purchasing].[ShipMethod]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Purchasing].[PK_ShipMethod_ShipMethodID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Purchasing].[ShipMethod]', 'U'))
ALTER TABLE [Purchasing].[ShipMethod] DROP CONSTRAINT [PK_ShipMethod_ShipMethodID]
GO
PRINT N'Dropping constraints from [Purchasing].[Vendor]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Purchasing].[PK_Vendor_BusinessEntityID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Purchasing].[Vendor]', 'U'))
ALTER TABLE [Purchasing].[Vendor] DROP CONSTRAINT [PK_Vendor_BusinessEntityID]
GO
PRINT N'Dropping constraints from [Sales].[CountryRegionCurrency]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_CountryRegionCurrency_CountryRegionCode_CurrencyCode]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[CountryRegionCurrency]', 'U'))
ALTER TABLE [Sales].[CountryRegionCurrency] DROP CONSTRAINT [PK_CountryRegionCurrency_CountryRegionCode_CurrencyCode]
GO
PRINT N'Dropping constraints from [Sales].[CreditCard]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_CreditCard_CreditCardID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[CreditCard]', 'U'))
ALTER TABLE [Sales].[CreditCard] DROP CONSTRAINT [PK_CreditCard_CreditCardID]
GO
PRINT N'Dropping constraints from [Sales].[CurrencyRate]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_CurrencyRate_CurrencyRateID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[CurrencyRate]', 'U'))
ALTER TABLE [Sales].[CurrencyRate] DROP CONSTRAINT [PK_CurrencyRate_CurrencyRateID]
GO
PRINT N'Dropping constraints from [Sales].[Currency]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_Currency_CurrencyCode]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[Currency]', 'U'))
ALTER TABLE [Sales].[Currency] DROP CONSTRAINT [PK_Currency_CurrencyCode]
GO
PRINT N'Dropping constraints from [Sales].[Customer]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_Customer_CustomerID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[Customer]', 'U'))
ALTER TABLE [Sales].[Customer] DROP CONSTRAINT [PK_Customer_CustomerID]
GO
PRINT N'Dropping constraints from [Sales].[PersonCreditCard]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_PersonCreditCard_BusinessEntityID_CreditCardID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[PersonCreditCard]', 'U'))
ALTER TABLE [Sales].[PersonCreditCard] DROP CONSTRAINT [PK_PersonCreditCard_BusinessEntityID_CreditCardID]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderDetail]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderDetail]', 'U'))
ALTER TABLE [Sales].[SalesOrderDetail] DROP CONSTRAINT [PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderHeaderSalesReason]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_SalesOrderHeaderSalesReason_SalesOrderID_SalesReasonID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderHeaderSalesReason]', 'U'))
ALTER TABLE [Sales].[SalesOrderHeaderSalesReason] DROP CONSTRAINT [PK_SalesOrderHeaderSalesReason_SalesOrderID_SalesReasonID]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_SalesOrderHeader_SalesOrderID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [PK_SalesOrderHeader_SalesOrderID]
GO
PRINT N'Dropping constraints from [Sales].[SalesPersonQuotaHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_SalesPersonQuotaHistory_BusinessEntityID_QuotaDate]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesPersonQuotaHistory]', 'U'))
ALTER TABLE [Sales].[SalesPersonQuotaHistory] DROP CONSTRAINT [PK_SalesPersonQuotaHistory_BusinessEntityID_QuotaDate]
GO
PRINT N'Dropping constraints from [Sales].[SalesPerson]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_SalesPerson_BusinessEntityID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesPerson]', 'U'))
ALTER TABLE [Sales].[SalesPerson] DROP CONSTRAINT [PK_SalesPerson_BusinessEntityID]
GO
PRINT N'Dropping constraints from [Sales].[SalesReason]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_SalesReason_SalesReasonID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesReason]', 'U'))
ALTER TABLE [Sales].[SalesReason] DROP CONSTRAINT [PK_SalesReason_SalesReasonID]
GO
PRINT N'Dropping constraints from [Sales].[SalesTaxRate]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_SalesTaxRate_SalesTaxRateID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesTaxRate]', 'U'))
ALTER TABLE [Sales].[SalesTaxRate] DROP CONSTRAINT [PK_SalesTaxRate_SalesTaxRateID]
GO
PRINT N'Dropping constraints from [Sales].[SalesTerritoryHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_SalesTerritoryHistory_BusinessEntityID_StartDate_TerritoryID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesTerritoryHistory]', 'U'))
ALTER TABLE [Sales].[SalesTerritoryHistory] DROP CONSTRAINT [PK_SalesTerritoryHistory_BusinessEntityID_StartDate_TerritoryID]
GO
PRINT N'Dropping constraints from [Sales].[SalesTerritory]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_SalesTerritory_TerritoryID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[SalesTerritory]', 'U'))
ALTER TABLE [Sales].[SalesTerritory] DROP CONSTRAINT [PK_SalesTerritory_TerritoryID]
GO
PRINT N'Dropping constraints from [Sales].[ShoppingCartItem]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_ShoppingCartItem_ShoppingCartItemID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[ShoppingCartItem]', 'U'))
ALTER TABLE [Sales].[ShoppingCartItem] DROP CONSTRAINT [PK_ShoppingCartItem_ShoppingCartItemID]
GO
PRINT N'Dropping constraints from [Sales].[SpecialOfferProduct]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_SpecialOfferProduct_SpecialOfferID_ProductID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[SpecialOfferProduct]', 'U'))
ALTER TABLE [Sales].[SpecialOfferProduct] DROP CONSTRAINT [PK_SpecialOfferProduct_SpecialOfferID_ProductID]
GO
PRINT N'Dropping constraints from [Sales].[SpecialOffer]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_SpecialOffer_SpecialOfferID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[SpecialOffer]', 'U'))
ALTER TABLE [Sales].[SpecialOffer] DROP CONSTRAINT [PK_SpecialOffer_SpecialOfferID]
GO
PRINT N'Dropping constraints from [Sales].[Store]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[PK_Store_BusinessEntityID]', 'PK') AND parent_object_id = OBJECT_ID(N'[Sales].[Store]', 'U'))
ALTER TABLE [Sales].[Store] DROP CONSTRAINT [PK_Store_BusinessEntityID]
GO
PRINT N'Dropping constraints from [dbo].[AWBuildVersion]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PK_AWBuildVersion_SystemInformationID]', 'PK') AND parent_object_id = OBJECT_ID(N'[dbo].[AWBuildVersion]', 'U'))
ALTER TABLE [dbo].[AWBuildVersion] DROP CONSTRAINT [PK_AWBuildVersion_SystemInformationID]
GO
PRINT N'Dropping constraints from [dbo].[DatabaseLog]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PK_DatabaseLog_DatabaseLogID]', 'PK') AND parent_object_id = OBJECT_ID(N'[dbo].[DatabaseLog]', 'U'))
ALTER TABLE [dbo].[DatabaseLog] DROP CONSTRAINT [PK_DatabaseLog_DatabaseLogID]
GO
PRINT N'Dropping constraints from [dbo].[ErrorLog]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PK_ErrorLog_ErrorLogID]', 'PK') AND parent_object_id = OBJECT_ID(N'[dbo].[ErrorLog]', 'U'))
ALTER TABLE [dbo].[ErrorLog] DROP CONSTRAINT [PK_ErrorLog_ErrorLogID]
GO
PRINT N'Dropping constraints from [HumanResources].[Department]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[HumanResources].[Department]', 'U') AND default_object_id = OBJECT_ID(N'[HumanResources].[DF_Department_ModifiedDate]', 'D'))
ALTER TABLE [HumanResources].[Department] DROP CONSTRAINT [DF_Department_ModifiedDate]
GO
PRINT N'Dropping constraints from [HumanResources].[EmployeeDepartmentHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[HumanResources].[EmployeeDepartmentHistory]', 'U') AND default_object_id = OBJECT_ID(N'[HumanResources].[DF_EmployeeDepartmentHistory_ModifiedDate]', 'D'))
ALTER TABLE [HumanResources].[EmployeeDepartmentHistory] DROP CONSTRAINT [DF_EmployeeDepartmentHistory_ModifiedDate]
GO
PRINT N'Dropping constraints from [HumanResources].[EmployeePayHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[HumanResources].[EmployeePayHistory]', 'U') AND default_object_id = OBJECT_ID(N'[HumanResources].[DF_EmployeePayHistory_ModifiedDate]', 'D'))
ALTER TABLE [HumanResources].[EmployeePayHistory] DROP CONSTRAINT [DF_EmployeePayHistory_ModifiedDate]
GO
PRINT N'Dropping constraints from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'SalariedFlag' AND object_id = OBJECT_ID(N'[HumanResources].[Employee]', 'U') AND default_object_id = OBJECT_ID(N'[HumanResources].[DF_Employee_SalariedFlag]', 'D'))
ALTER TABLE [HumanResources].[Employee] DROP CONSTRAINT [DF_Employee_SalariedFlag]
GO
PRINT N'Dropping constraints from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'VacationHours' AND object_id = OBJECT_ID(N'[HumanResources].[Employee]', 'U') AND default_object_id = OBJECT_ID(N'[HumanResources].[DF_Employee_VacationHours]', 'D'))
ALTER TABLE [HumanResources].[Employee] DROP CONSTRAINT [DF_Employee_VacationHours]
GO
PRINT N'Dropping constraints from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'SickLeaveHours' AND object_id = OBJECT_ID(N'[HumanResources].[Employee]', 'U') AND default_object_id = OBJECT_ID(N'[HumanResources].[DF_Employee_SickLeaveHours]', 'D'))
ALTER TABLE [HumanResources].[Employee] DROP CONSTRAINT [DF_Employee_SickLeaveHours]
GO
PRINT N'Dropping constraints from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'CurrentFlag' AND object_id = OBJECT_ID(N'[HumanResources].[Employee]', 'U') AND default_object_id = OBJECT_ID(N'[HumanResources].[DF_Employee_CurrentFlag]', 'D'))
ALTER TABLE [HumanResources].[Employee] DROP CONSTRAINT [DF_Employee_CurrentFlag]
GO
PRINT N'Dropping constraints from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[HumanResources].[Employee]', 'U') AND default_object_id = OBJECT_ID(N'[HumanResources].[DF_Employee_rowguid]', 'D'))
ALTER TABLE [HumanResources].[Employee] DROP CONSTRAINT [DF_Employee_rowguid]
GO
PRINT N'Dropping constraints from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[HumanResources].[Employee]', 'U') AND default_object_id = OBJECT_ID(N'[HumanResources].[DF_Employee_ModifiedDate]', 'D'))
ALTER TABLE [HumanResources].[Employee] DROP CONSTRAINT [DF_Employee_ModifiedDate]
GO
PRINT N'Dropping constraints from [HumanResources].[JobCandidate]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[HumanResources].[JobCandidate]', 'U') AND default_object_id = OBJECT_ID(N'[HumanResources].[DF_JobCandidate_ModifiedDate]', 'D'))
ALTER TABLE [HumanResources].[JobCandidate] DROP CONSTRAINT [DF_JobCandidate_ModifiedDate]
GO
PRINT N'Dropping constraints from [HumanResources].[Shift]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[HumanResources].[Shift]', 'U') AND default_object_id = OBJECT_ID(N'[HumanResources].[DF_Shift_ModifiedDate]', 'D'))
ALTER TABLE [HumanResources].[Shift] DROP CONSTRAINT [DF_Shift_ModifiedDate]
GO
PRINT N'Dropping constraints from [Person].[AddressType]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Person].[AddressType]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_AddressType_rowguid]', 'D'))
ALTER TABLE [Person].[AddressType] DROP CONSTRAINT [DF_AddressType_rowguid]
GO
PRINT N'Dropping constraints from [Person].[AddressType]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Person].[AddressType]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_AddressType_ModifiedDate]', 'D'))
ALTER TABLE [Person].[AddressType] DROP CONSTRAINT [DF_AddressType_ModifiedDate]
GO
PRINT N'Dropping constraints from [Person].[Address]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Person].[Address]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_Address_rowguid]', 'D'))
ALTER TABLE [Person].[Address] DROP CONSTRAINT [DF_Address_rowguid]
GO
PRINT N'Dropping constraints from [Person].[Address]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Person].[Address]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_Address_ModifiedDate]', 'D'))
ALTER TABLE [Person].[Address] DROP CONSTRAINT [DF_Address_ModifiedDate]
GO
PRINT N'Dropping constraints from [Person].[BusinessEntityAddress]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Person].[BusinessEntityAddress]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_BusinessEntityAddress_rowguid]', 'D'))
ALTER TABLE [Person].[BusinessEntityAddress] DROP CONSTRAINT [DF_BusinessEntityAddress_rowguid]
GO
PRINT N'Dropping constraints from [Person].[BusinessEntityAddress]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Person].[BusinessEntityAddress]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_BusinessEntityAddress_ModifiedDate]', 'D'))
ALTER TABLE [Person].[BusinessEntityAddress] DROP CONSTRAINT [DF_BusinessEntityAddress_ModifiedDate]
GO
PRINT N'Dropping constraints from [Person].[BusinessEntityContact]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Person].[BusinessEntityContact]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_BusinessEntityContact_rowguid]', 'D'))
ALTER TABLE [Person].[BusinessEntityContact] DROP CONSTRAINT [DF_BusinessEntityContact_rowguid]
GO
PRINT N'Dropping constraints from [Person].[BusinessEntityContact]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Person].[BusinessEntityContact]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_BusinessEntityContact_ModifiedDate]', 'D'))
ALTER TABLE [Person].[BusinessEntityContact] DROP CONSTRAINT [DF_BusinessEntityContact_ModifiedDate]
GO
PRINT N'Dropping constraints from [Person].[BusinessEntity]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Person].[BusinessEntity]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_BusinessEntity_rowguid]', 'D'))
ALTER TABLE [Person].[BusinessEntity] DROP CONSTRAINT [DF_BusinessEntity_rowguid]
GO
PRINT N'Dropping constraints from [Person].[BusinessEntity]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Person].[BusinessEntity]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_BusinessEntity_ModifiedDate]', 'D'))
ALTER TABLE [Person].[BusinessEntity] DROP CONSTRAINT [DF_BusinessEntity_ModifiedDate]
GO
PRINT N'Dropping constraints from [Person].[ContactType]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Person].[ContactType]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_ContactType_ModifiedDate]', 'D'))
ALTER TABLE [Person].[ContactType] DROP CONSTRAINT [DF_ContactType_ModifiedDate]
GO
PRINT N'Dropping constraints from [Person].[CountryRegion]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Person].[CountryRegion]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_CountryRegion_ModifiedDate]', 'D'))
ALTER TABLE [Person].[CountryRegion] DROP CONSTRAINT [DF_CountryRegion_ModifiedDate]
GO
PRINT N'Dropping constraints from [Person].[EmailAddress]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Person].[EmailAddress]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_EmailAddress_rowguid]', 'D'))
ALTER TABLE [Person].[EmailAddress] DROP CONSTRAINT [DF_EmailAddress_rowguid]
GO
PRINT N'Dropping constraints from [Person].[EmailAddress]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Person].[EmailAddress]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_EmailAddress_ModifiedDate]', 'D'))
ALTER TABLE [Person].[EmailAddress] DROP CONSTRAINT [DF_EmailAddress_ModifiedDate]
GO
PRINT N'Dropping constraints from [Person].[Password]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Person].[Password]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_Password_rowguid]', 'D'))
ALTER TABLE [Person].[Password] DROP CONSTRAINT [DF_Password_rowguid]
GO
PRINT N'Dropping constraints from [Person].[Password]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Person].[Password]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_Password_ModifiedDate]', 'D'))
ALTER TABLE [Person].[Password] DROP CONSTRAINT [DF_Password_ModifiedDate]
GO
PRINT N'Dropping constraints from [Person].[PersonPhone]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Person].[PersonPhone]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_PersonPhone_ModifiedDate]', 'D'))
ALTER TABLE [Person].[PersonPhone] DROP CONSTRAINT [DF_PersonPhone_ModifiedDate]
GO
PRINT N'Dropping constraints from [Person].[Person]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'NameStyle' AND object_id = OBJECT_ID(N'[Person].[Person]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_Person_NameStyle]', 'D'))
ALTER TABLE [Person].[Person] DROP CONSTRAINT [DF_Person_NameStyle]
GO
PRINT N'Dropping constraints from [Person].[Person]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'EmailPromotion' AND object_id = OBJECT_ID(N'[Person].[Person]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_Person_EmailPromotion]', 'D'))
ALTER TABLE [Person].[Person] DROP CONSTRAINT [DF_Person_EmailPromotion]
GO
PRINT N'Dropping constraints from [Person].[Person]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Person].[Person]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_Person_rowguid]', 'D'))
ALTER TABLE [Person].[Person] DROP CONSTRAINT [DF_Person_rowguid]
GO
PRINT N'Dropping constraints from [Person].[Person]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Person].[Person]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_Person_ModifiedDate]', 'D'))
ALTER TABLE [Person].[Person] DROP CONSTRAINT [DF_Person_ModifiedDate]
GO
PRINT N'Dropping constraints from [Person].[PhoneNumberType]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Person].[PhoneNumberType]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_PhoneNumberType_ModifiedDate]', 'D'))
ALTER TABLE [Person].[PhoneNumberType] DROP CONSTRAINT [DF_PhoneNumberType_ModifiedDate]
GO
PRINT N'Dropping constraints from [Person].[StateProvince]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'IsOnlyStateProvinceFlag' AND object_id = OBJECT_ID(N'[Person].[StateProvince]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_StateProvince_IsOnlyStateProvinceFlag]', 'D'))
ALTER TABLE [Person].[StateProvince] DROP CONSTRAINT [DF_StateProvince_IsOnlyStateProvinceFlag]
GO
PRINT N'Dropping constraints from [Person].[StateProvince]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Person].[StateProvince]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_StateProvince_rowguid]', 'D'))
ALTER TABLE [Person].[StateProvince] DROP CONSTRAINT [DF_StateProvince_rowguid]
GO
PRINT N'Dropping constraints from [Person].[StateProvince]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Person].[StateProvince]', 'U') AND default_object_id = OBJECT_ID(N'[Person].[DF_StateProvince_ModifiedDate]', 'D'))
ALTER TABLE [Person].[StateProvince] DROP CONSTRAINT [DF_StateProvince_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[BillOfMaterials]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'StartDate' AND object_id = OBJECT_ID(N'[Production].[BillOfMaterials]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_BillOfMaterials_StartDate]', 'D'))
ALTER TABLE [Production].[BillOfMaterials] DROP CONSTRAINT [DF_BillOfMaterials_StartDate]
GO
PRINT N'Dropping constraints from [Production].[BillOfMaterials]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'PerAssemblyQty' AND object_id = OBJECT_ID(N'[Production].[BillOfMaterials]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_BillOfMaterials_PerAssemblyQty]', 'D'))
ALTER TABLE [Production].[BillOfMaterials] DROP CONSTRAINT [DF_BillOfMaterials_PerAssemblyQty]
GO
PRINT N'Dropping constraints from [Production].[BillOfMaterials]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[BillOfMaterials]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_BillOfMaterials_ModifiedDate]', 'D'))
ALTER TABLE [Production].[BillOfMaterials] DROP CONSTRAINT [DF_BillOfMaterials_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[Culture]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[Culture]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_Culture_ModifiedDate]', 'D'))
ALTER TABLE [Production].[Culture] DROP CONSTRAINT [DF_Culture_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[Document]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'FolderFlag' AND object_id = OBJECT_ID(N'[Production].[Document]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_Document_FolderFlag]', 'D'))
ALTER TABLE [Production].[Document] DROP CONSTRAINT [DF_Document_FolderFlag]
GO
PRINT N'Dropping constraints from [Production].[Document]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ChangeNumber' AND object_id = OBJECT_ID(N'[Production].[Document]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_Document_ChangeNumber]', 'D'))
ALTER TABLE [Production].[Document] DROP CONSTRAINT [DF_Document_ChangeNumber]
GO
PRINT N'Dropping constraints from [Production].[Document]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Production].[Document]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_Document_rowguid]', 'D'))
ALTER TABLE [Production].[Document] DROP CONSTRAINT [DF_Document_rowguid]
GO
PRINT N'Dropping constraints from [Production].[Document]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[Document]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_Document_ModifiedDate]', 'D'))
ALTER TABLE [Production].[Document] DROP CONSTRAINT [DF_Document_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[Illustration]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[Illustration]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_Illustration_ModifiedDate]', 'D'))
ALTER TABLE [Production].[Illustration] DROP CONSTRAINT [DF_Illustration_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[Location]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'CostRate' AND object_id = OBJECT_ID(N'[Production].[Location]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_Location_CostRate]', 'D'))
ALTER TABLE [Production].[Location] DROP CONSTRAINT [DF_Location_CostRate]
GO
PRINT N'Dropping constraints from [Production].[Location]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'Availability' AND object_id = OBJECT_ID(N'[Production].[Location]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_Location_Availability]', 'D'))
ALTER TABLE [Production].[Location] DROP CONSTRAINT [DF_Location_Availability]
GO
PRINT N'Dropping constraints from [Production].[Location]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[Location]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_Location_ModifiedDate]', 'D'))
ALTER TABLE [Production].[Location] DROP CONSTRAINT [DF_Location_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[ProductCategory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Production].[ProductCategory]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductCategory_rowguid]', 'D'))
ALTER TABLE [Production].[ProductCategory] DROP CONSTRAINT [DF_ProductCategory_rowguid]
GO
PRINT N'Dropping constraints from [Production].[ProductCategory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[ProductCategory]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductCategory_ModifiedDate]', 'D'))
ALTER TABLE [Production].[ProductCategory] DROP CONSTRAINT [DF_ProductCategory_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[ProductCostHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[ProductCostHistory]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductCostHistory_ModifiedDate]', 'D'))
ALTER TABLE [Production].[ProductCostHistory] DROP CONSTRAINT [DF_ProductCostHistory_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[ProductDescription]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Production].[ProductDescription]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductDescription_rowguid]', 'D'))
ALTER TABLE [Production].[ProductDescription] DROP CONSTRAINT [DF_ProductDescription_rowguid]
GO
PRINT N'Dropping constraints from [Production].[ProductDescription]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[ProductDescription]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductDescription_ModifiedDate]', 'D'))
ALTER TABLE [Production].[ProductDescription] DROP CONSTRAINT [DF_ProductDescription_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[ProductDocument]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[ProductDocument]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductDocument_ModifiedDate]', 'D'))
ALTER TABLE [Production].[ProductDocument] DROP CONSTRAINT [DF_ProductDocument_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[ProductInventory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'Quantity' AND object_id = OBJECT_ID(N'[Production].[ProductInventory]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductInventory_Quantity]', 'D'))
ALTER TABLE [Production].[ProductInventory] DROP CONSTRAINT [DF_ProductInventory_Quantity]
GO
PRINT N'Dropping constraints from [Production].[ProductInventory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Production].[ProductInventory]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductInventory_rowguid]', 'D'))
ALTER TABLE [Production].[ProductInventory] DROP CONSTRAINT [DF_ProductInventory_rowguid]
GO
PRINT N'Dropping constraints from [Production].[ProductInventory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[ProductInventory]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductInventory_ModifiedDate]', 'D'))
ALTER TABLE [Production].[ProductInventory] DROP CONSTRAINT [DF_ProductInventory_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[ProductListPriceHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[ProductListPriceHistory]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductListPriceHistory_ModifiedDate]', 'D'))
ALTER TABLE [Production].[ProductListPriceHistory] DROP CONSTRAINT [DF_ProductListPriceHistory_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[ProductModelIllustration]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[ProductModelIllustration]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductModelIllustration_ModifiedDate]', 'D'))
ALTER TABLE [Production].[ProductModelIllustration] DROP CONSTRAINT [DF_ProductModelIllustration_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[ProductModelProductDescriptionCulture]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[ProductModelProductDescriptionCulture]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductModelProductDescriptionCulture_ModifiedDate]', 'D'))
ALTER TABLE [Production].[ProductModelProductDescriptionCulture] DROP CONSTRAINT [DF_ProductModelProductDescriptionCulture_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[ProductModel]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Production].[ProductModel]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductModel_rowguid]', 'D'))
ALTER TABLE [Production].[ProductModel] DROP CONSTRAINT [DF_ProductModel_rowguid]
GO
PRINT N'Dropping constraints from [Production].[ProductModel]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[ProductModel]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductModel_ModifiedDate]', 'D'))
ALTER TABLE [Production].[ProductModel] DROP CONSTRAINT [DF_ProductModel_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[ProductPhoto]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[ProductPhoto]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductPhoto_ModifiedDate]', 'D'))
ALTER TABLE [Production].[ProductPhoto] DROP CONSTRAINT [DF_ProductPhoto_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[ProductProductPhoto]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'Primary' AND object_id = OBJECT_ID(N'[Production].[ProductProductPhoto]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductProductPhoto_Primary]', 'D'))
ALTER TABLE [Production].[ProductProductPhoto] DROP CONSTRAINT [DF_ProductProductPhoto_Primary]
GO
PRINT N'Dropping constraints from [Production].[ProductProductPhoto]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[ProductProductPhoto]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductProductPhoto_ModifiedDate]', 'D'))
ALTER TABLE [Production].[ProductProductPhoto] DROP CONSTRAINT [DF_ProductProductPhoto_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[ProductReview]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ReviewDate' AND object_id = OBJECT_ID(N'[Production].[ProductReview]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductReview_ReviewDate]', 'D'))
ALTER TABLE [Production].[ProductReview] DROP CONSTRAINT [DF_ProductReview_ReviewDate]
GO
PRINT N'Dropping constraints from [Production].[ProductReview]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[ProductReview]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductReview_ModifiedDate]', 'D'))
ALTER TABLE [Production].[ProductReview] DROP CONSTRAINT [DF_ProductReview_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[ProductSubcategory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Production].[ProductSubcategory]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductSubcategory_rowguid]', 'D'))
ALTER TABLE [Production].[ProductSubcategory] DROP CONSTRAINT [DF_ProductSubcategory_rowguid]
GO
PRINT N'Dropping constraints from [Production].[ProductSubcategory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[ProductSubcategory]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ProductSubcategory_ModifiedDate]', 'D'))
ALTER TABLE [Production].[ProductSubcategory] DROP CONSTRAINT [DF_ProductSubcategory_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'MakeFlag' AND object_id = OBJECT_ID(N'[Production].[Product]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_Product_MakeFlag]', 'D'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [DF_Product_MakeFlag]
GO
PRINT N'Dropping constraints from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'FinishedGoodsFlag' AND object_id = OBJECT_ID(N'[Production].[Product]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_Product_FinishedGoodsFlag]', 'D'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [DF_Product_FinishedGoodsFlag]
GO
PRINT N'Dropping constraints from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Production].[Product]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_Product_rowguid]', 'D'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [DF_Product_rowguid]
GO
PRINT N'Dropping constraints from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[Product]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_Product_ModifiedDate]', 'D'))
ALTER TABLE [Production].[Product] DROP CONSTRAINT [DF_Product_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[ScrapReason]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[ScrapReason]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_ScrapReason_ModifiedDate]', 'D'))
ALTER TABLE [Production].[ScrapReason] DROP CONSTRAINT [DF_ScrapReason_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[TransactionHistoryArchive]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ReferenceOrderLineID' AND object_id = OBJECT_ID(N'[Production].[TransactionHistoryArchive]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_TransactionHistoryArchive_ReferenceOrderLineID]', 'D'))
ALTER TABLE [Production].[TransactionHistoryArchive] DROP CONSTRAINT [DF_TransactionHistoryArchive_ReferenceOrderLineID]
GO
PRINT N'Dropping constraints from [Production].[TransactionHistoryArchive]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'TransactionDate' AND object_id = OBJECT_ID(N'[Production].[TransactionHistoryArchive]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_TransactionHistoryArchive_TransactionDate]', 'D'))
ALTER TABLE [Production].[TransactionHistoryArchive] DROP CONSTRAINT [DF_TransactionHistoryArchive_TransactionDate]
GO
PRINT N'Dropping constraints from [Production].[TransactionHistoryArchive]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[TransactionHistoryArchive]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_TransactionHistoryArchive_ModifiedDate]', 'D'))
ALTER TABLE [Production].[TransactionHistoryArchive] DROP CONSTRAINT [DF_TransactionHistoryArchive_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[TransactionHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ReferenceOrderLineID' AND object_id = OBJECT_ID(N'[Production].[TransactionHistory]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_TransactionHistory_ReferenceOrderLineID]', 'D'))
ALTER TABLE [Production].[TransactionHistory] DROP CONSTRAINT [DF_TransactionHistory_ReferenceOrderLineID]
GO
PRINT N'Dropping constraints from [Production].[TransactionHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'TransactionDate' AND object_id = OBJECT_ID(N'[Production].[TransactionHistory]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_TransactionHistory_TransactionDate]', 'D'))
ALTER TABLE [Production].[TransactionHistory] DROP CONSTRAINT [DF_TransactionHistory_TransactionDate]
GO
PRINT N'Dropping constraints from [Production].[TransactionHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[TransactionHistory]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_TransactionHistory_ModifiedDate]', 'D'))
ALTER TABLE [Production].[TransactionHistory] DROP CONSTRAINT [DF_TransactionHistory_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[UnitMeasure]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[UnitMeasure]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_UnitMeasure_ModifiedDate]', 'D'))
ALTER TABLE [Production].[UnitMeasure] DROP CONSTRAINT [DF_UnitMeasure_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[WorkOrderRouting]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[WorkOrderRouting]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_WorkOrderRouting_ModifiedDate]', 'D'))
ALTER TABLE [Production].[WorkOrderRouting] DROP CONSTRAINT [DF_WorkOrderRouting_ModifiedDate]
GO
PRINT N'Dropping constraints from [Production].[WorkOrder]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Production].[WorkOrder]', 'U') AND default_object_id = OBJECT_ID(N'[Production].[DF_WorkOrder_ModifiedDate]', 'D'))
ALTER TABLE [Production].[WorkOrder] DROP CONSTRAINT [DF_WorkOrder_ModifiedDate]
GO
PRINT N'Dropping constraints from [Purchasing].[ProductVendor]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Purchasing].[ProductVendor]', 'U') AND default_object_id = OBJECT_ID(N'[Purchasing].[DF_ProductVendor_ModifiedDate]', 'D'))
ALTER TABLE [Purchasing].[ProductVendor] DROP CONSTRAINT [DF_ProductVendor_ModifiedDate]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderDetail]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderDetail]', 'U') AND default_object_id = OBJECT_ID(N'[Purchasing].[DF_PurchaseOrderDetail_ModifiedDate]', 'D'))
ALTER TABLE [Purchasing].[PurchaseOrderDetail] DROP CONSTRAINT [DF_PurchaseOrderDetail_ModifiedDate]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'RevisionNumber' AND object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]', 'U') AND default_object_id = OBJECT_ID(N'[Purchasing].[DF_PurchaseOrderHeader_RevisionNumber]', 'D'))
ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [DF_PurchaseOrderHeader_RevisionNumber]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'Status' AND object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]', 'U') AND default_object_id = OBJECT_ID(N'[Purchasing].[DF_PurchaseOrderHeader_Status]', 'D'))
ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [DF_PurchaseOrderHeader_Status]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'OrderDate' AND object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]', 'U') AND default_object_id = OBJECT_ID(N'[Purchasing].[DF_PurchaseOrderHeader_OrderDate]', 'D'))
ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [DF_PurchaseOrderHeader_OrderDate]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'SubTotal' AND object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]', 'U') AND default_object_id = OBJECT_ID(N'[Purchasing].[DF_PurchaseOrderHeader_SubTotal]', 'D'))
ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [DF_PurchaseOrderHeader_SubTotal]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'TaxAmt' AND object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]', 'U') AND default_object_id = OBJECT_ID(N'[Purchasing].[DF_PurchaseOrderHeader_TaxAmt]', 'D'))
ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [DF_PurchaseOrderHeader_TaxAmt]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'Freight' AND object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]', 'U') AND default_object_id = OBJECT_ID(N'[Purchasing].[DF_PurchaseOrderHeader_Freight]', 'D'))
ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [DF_PurchaseOrderHeader_Freight]
GO
PRINT N'Dropping constraints from [Purchasing].[PurchaseOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]', 'U') AND default_object_id = OBJECT_ID(N'[Purchasing].[DF_PurchaseOrderHeader_ModifiedDate]', 'D'))
ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [DF_PurchaseOrderHeader_ModifiedDate]
GO
PRINT N'Dropping constraints from [Purchasing].[ShipMethod]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ShipBase' AND object_id = OBJECT_ID(N'[Purchasing].[ShipMethod]', 'U') AND default_object_id = OBJECT_ID(N'[Purchasing].[DF_ShipMethod_ShipBase]', 'D'))
ALTER TABLE [Purchasing].[ShipMethod] DROP CONSTRAINT [DF_ShipMethod_ShipBase]
GO
PRINT N'Dropping constraints from [Purchasing].[ShipMethod]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ShipRate' AND object_id = OBJECT_ID(N'[Purchasing].[ShipMethod]', 'U') AND default_object_id = OBJECT_ID(N'[Purchasing].[DF_ShipMethod_ShipRate]', 'D'))
ALTER TABLE [Purchasing].[ShipMethod] DROP CONSTRAINT [DF_ShipMethod_ShipRate]
GO
PRINT N'Dropping constraints from [Purchasing].[ShipMethod]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Purchasing].[ShipMethod]', 'U') AND default_object_id = OBJECT_ID(N'[Purchasing].[DF_ShipMethod_rowguid]', 'D'))
ALTER TABLE [Purchasing].[ShipMethod] DROP CONSTRAINT [DF_ShipMethod_rowguid]
GO
PRINT N'Dropping constraints from [Purchasing].[ShipMethod]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Purchasing].[ShipMethod]', 'U') AND default_object_id = OBJECT_ID(N'[Purchasing].[DF_ShipMethod_ModifiedDate]', 'D'))
ALTER TABLE [Purchasing].[ShipMethod] DROP CONSTRAINT [DF_ShipMethod_ModifiedDate]
GO
PRINT N'Dropping constraints from [Purchasing].[Vendor]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'PreferredVendorStatus' AND object_id = OBJECT_ID(N'[Purchasing].[Vendor]', 'U') AND default_object_id = OBJECT_ID(N'[Purchasing].[DF_Vendor_PreferredVendorStatus]', 'D'))
ALTER TABLE [Purchasing].[Vendor] DROP CONSTRAINT [DF_Vendor_PreferredVendorStatus]
GO
PRINT N'Dropping constraints from [Purchasing].[Vendor]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ActiveFlag' AND object_id = OBJECT_ID(N'[Purchasing].[Vendor]', 'U') AND default_object_id = OBJECT_ID(N'[Purchasing].[DF_Vendor_ActiveFlag]', 'D'))
ALTER TABLE [Purchasing].[Vendor] DROP CONSTRAINT [DF_Vendor_ActiveFlag]
GO
PRINT N'Dropping constraints from [Purchasing].[Vendor]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Purchasing].[Vendor]', 'U') AND default_object_id = OBJECT_ID(N'[Purchasing].[DF_Vendor_ModifiedDate]', 'D'))
ALTER TABLE [Purchasing].[Vendor] DROP CONSTRAINT [DF_Vendor_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[CountryRegionCurrency]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[CountryRegionCurrency]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_CountryRegionCurrency_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[CountryRegionCurrency] DROP CONSTRAINT [DF_CountryRegionCurrency_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[CreditCard]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[CreditCard]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_CreditCard_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[CreditCard] DROP CONSTRAINT [DF_CreditCard_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[CurrencyRate]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[CurrencyRate]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_CurrencyRate_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[CurrencyRate] DROP CONSTRAINT [DF_CurrencyRate_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[Currency]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[Currency]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_Currency_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[Currency] DROP CONSTRAINT [DF_Currency_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[Customer]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Sales].[Customer]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_Customer_rowguid]', 'D'))
ALTER TABLE [Sales].[Customer] DROP CONSTRAINT [DF_Customer_rowguid]
GO
PRINT N'Dropping constraints from [Sales].[Customer]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[Customer]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_Customer_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[Customer] DROP CONSTRAINT [DF_Customer_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[PersonCreditCard]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[PersonCreditCard]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_PersonCreditCard_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[PersonCreditCard] DROP CONSTRAINT [DF_PersonCreditCard_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderDetail]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'UnitPriceDiscount' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderDetail]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesOrderDetail_UnitPriceDiscount]', 'D'))
ALTER TABLE [Sales].[SalesOrderDetail] DROP CONSTRAINT [DF_SalesOrderDetail_UnitPriceDiscount]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderDetail]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderDetail]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesOrderDetail_rowguid]', 'D'))
ALTER TABLE [Sales].[SalesOrderDetail] DROP CONSTRAINT [DF_SalesOrderDetail_rowguid]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderDetail]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderDetail]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesOrderDetail_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[SalesOrderDetail] DROP CONSTRAINT [DF_SalesOrderDetail_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderHeaderSalesReason]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderHeaderSalesReason]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesOrderHeaderSalesReason_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[SalesOrderHeaderSalesReason] DROP CONSTRAINT [DF_SalesOrderHeaderSalesReason_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'RevisionNumber' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesOrderHeader_RevisionNumber]', 'D'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [DF_SalesOrderHeader_RevisionNumber]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'OrderDate' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesOrderHeader_OrderDate]', 'D'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [DF_SalesOrderHeader_OrderDate]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'Status' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesOrderHeader_Status]', 'D'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [DF_SalesOrderHeader_Status]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'OnlineOrderFlag' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesOrderHeader_OnlineOrderFlag]', 'D'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [DF_SalesOrderHeader_OnlineOrderFlag]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'SubTotal' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesOrderHeader_SubTotal]', 'D'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [DF_SalesOrderHeader_SubTotal]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'TaxAmt' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesOrderHeader_TaxAmt]', 'D'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [DF_SalesOrderHeader_TaxAmt]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'Freight' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesOrderHeader_Freight]', 'D'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [DF_SalesOrderHeader_Freight]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesOrderHeader_rowguid]', 'D'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [DF_SalesOrderHeader_rowguid]
GO
PRINT N'Dropping constraints from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesOrderHeader_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [DF_SalesOrderHeader_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[SalesPersonQuotaHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Sales].[SalesPersonQuotaHistory]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesPersonQuotaHistory_rowguid]', 'D'))
ALTER TABLE [Sales].[SalesPersonQuotaHistory] DROP CONSTRAINT [DF_SalesPersonQuotaHistory_rowguid]
GO
PRINT N'Dropping constraints from [Sales].[SalesPersonQuotaHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[SalesPersonQuotaHistory]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesPersonQuotaHistory_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[SalesPersonQuotaHistory] DROP CONSTRAINT [DF_SalesPersonQuotaHistory_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[SalesPerson]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'Bonus' AND object_id = OBJECT_ID(N'[Sales].[SalesPerson]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesPerson_Bonus]', 'D'))
ALTER TABLE [Sales].[SalesPerson] DROP CONSTRAINT [DF_SalesPerson_Bonus]
GO
PRINT N'Dropping constraints from [Sales].[SalesPerson]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'CommissionPct' AND object_id = OBJECT_ID(N'[Sales].[SalesPerson]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesPerson_CommissionPct]', 'D'))
ALTER TABLE [Sales].[SalesPerson] DROP CONSTRAINT [DF_SalesPerson_CommissionPct]
GO
PRINT N'Dropping constraints from [Sales].[SalesPerson]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'SalesYTD' AND object_id = OBJECT_ID(N'[Sales].[SalesPerson]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesPerson_SalesYTD]', 'D'))
ALTER TABLE [Sales].[SalesPerson] DROP CONSTRAINT [DF_SalesPerson_SalesYTD]
GO
PRINT N'Dropping constraints from [Sales].[SalesPerson]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'SalesLastYear' AND object_id = OBJECT_ID(N'[Sales].[SalesPerson]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesPerson_SalesLastYear]', 'D'))
ALTER TABLE [Sales].[SalesPerson] DROP CONSTRAINT [DF_SalesPerson_SalesLastYear]
GO
PRINT N'Dropping constraints from [Sales].[SalesPerson]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Sales].[SalesPerson]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesPerson_rowguid]', 'D'))
ALTER TABLE [Sales].[SalesPerson] DROP CONSTRAINT [DF_SalesPerson_rowguid]
GO
PRINT N'Dropping constraints from [Sales].[SalesPerson]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[SalesPerson]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesPerson_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[SalesPerson] DROP CONSTRAINT [DF_SalesPerson_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[SalesReason]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[SalesReason]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesReason_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[SalesReason] DROP CONSTRAINT [DF_SalesReason_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[SalesTaxRate]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'TaxRate' AND object_id = OBJECT_ID(N'[Sales].[SalesTaxRate]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesTaxRate_TaxRate]', 'D'))
ALTER TABLE [Sales].[SalesTaxRate] DROP CONSTRAINT [DF_SalesTaxRate_TaxRate]
GO
PRINT N'Dropping constraints from [Sales].[SalesTaxRate]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Sales].[SalesTaxRate]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesTaxRate_rowguid]', 'D'))
ALTER TABLE [Sales].[SalesTaxRate] DROP CONSTRAINT [DF_SalesTaxRate_rowguid]
GO
PRINT N'Dropping constraints from [Sales].[SalesTaxRate]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[SalesTaxRate]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesTaxRate_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[SalesTaxRate] DROP CONSTRAINT [DF_SalesTaxRate_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[SalesTerritoryHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Sales].[SalesTerritoryHistory]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesTerritoryHistory_rowguid]', 'D'))
ALTER TABLE [Sales].[SalesTerritoryHistory] DROP CONSTRAINT [DF_SalesTerritoryHistory_rowguid]
GO
PRINT N'Dropping constraints from [Sales].[SalesTerritoryHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[SalesTerritoryHistory]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesTerritoryHistory_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[SalesTerritoryHistory] DROP CONSTRAINT [DF_SalesTerritoryHistory_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[SalesTerritory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'SalesYTD' AND object_id = OBJECT_ID(N'[Sales].[SalesTerritory]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesTerritory_SalesYTD]', 'D'))
ALTER TABLE [Sales].[SalesTerritory] DROP CONSTRAINT [DF_SalesTerritory_SalesYTD]
GO
PRINT N'Dropping constraints from [Sales].[SalesTerritory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'SalesLastYear' AND object_id = OBJECT_ID(N'[Sales].[SalesTerritory]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesTerritory_SalesLastYear]', 'D'))
ALTER TABLE [Sales].[SalesTerritory] DROP CONSTRAINT [DF_SalesTerritory_SalesLastYear]
GO
PRINT N'Dropping constraints from [Sales].[SalesTerritory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'CostYTD' AND object_id = OBJECT_ID(N'[Sales].[SalesTerritory]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesTerritory_CostYTD]', 'D'))
ALTER TABLE [Sales].[SalesTerritory] DROP CONSTRAINT [DF_SalesTerritory_CostYTD]
GO
PRINT N'Dropping constraints from [Sales].[SalesTerritory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'CostLastYear' AND object_id = OBJECT_ID(N'[Sales].[SalesTerritory]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesTerritory_CostLastYear]', 'D'))
ALTER TABLE [Sales].[SalesTerritory] DROP CONSTRAINT [DF_SalesTerritory_CostLastYear]
GO
PRINT N'Dropping constraints from [Sales].[SalesTerritory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Sales].[SalesTerritory]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesTerritory_rowguid]', 'D'))
ALTER TABLE [Sales].[SalesTerritory] DROP CONSTRAINT [DF_SalesTerritory_rowguid]
GO
PRINT N'Dropping constraints from [Sales].[SalesTerritory]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[SalesTerritory]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SalesTerritory_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[SalesTerritory] DROP CONSTRAINT [DF_SalesTerritory_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[ShoppingCartItem]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'Quantity' AND object_id = OBJECT_ID(N'[Sales].[ShoppingCartItem]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_ShoppingCartItem_Quantity]', 'D'))
ALTER TABLE [Sales].[ShoppingCartItem] DROP CONSTRAINT [DF_ShoppingCartItem_Quantity]
GO
PRINT N'Dropping constraints from [Sales].[ShoppingCartItem]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'DateCreated' AND object_id = OBJECT_ID(N'[Sales].[ShoppingCartItem]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_ShoppingCartItem_DateCreated]', 'D'))
ALTER TABLE [Sales].[ShoppingCartItem] DROP CONSTRAINT [DF_ShoppingCartItem_DateCreated]
GO
PRINT N'Dropping constraints from [Sales].[ShoppingCartItem]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[ShoppingCartItem]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_ShoppingCartItem_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[ShoppingCartItem] DROP CONSTRAINT [DF_ShoppingCartItem_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[SpecialOfferProduct]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Sales].[SpecialOfferProduct]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SpecialOfferProduct_rowguid]', 'D'))
ALTER TABLE [Sales].[SpecialOfferProduct] DROP CONSTRAINT [DF_SpecialOfferProduct_rowguid]
GO
PRINT N'Dropping constraints from [Sales].[SpecialOfferProduct]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[SpecialOfferProduct]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SpecialOfferProduct_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[SpecialOfferProduct] DROP CONSTRAINT [DF_SpecialOfferProduct_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[SpecialOffer]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'DiscountPct' AND object_id = OBJECT_ID(N'[Sales].[SpecialOffer]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SpecialOffer_DiscountPct]', 'D'))
ALTER TABLE [Sales].[SpecialOffer] DROP CONSTRAINT [DF_SpecialOffer_DiscountPct]
GO
PRINT N'Dropping constraints from [Sales].[SpecialOffer]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'MinQty' AND object_id = OBJECT_ID(N'[Sales].[SpecialOffer]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SpecialOffer_MinQty]', 'D'))
ALTER TABLE [Sales].[SpecialOffer] DROP CONSTRAINT [DF_SpecialOffer_MinQty]
GO
PRINT N'Dropping constraints from [Sales].[SpecialOffer]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Sales].[SpecialOffer]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SpecialOffer_rowguid]', 'D'))
ALTER TABLE [Sales].[SpecialOffer] DROP CONSTRAINT [DF_SpecialOffer_rowguid]
GO
PRINT N'Dropping constraints from [Sales].[SpecialOffer]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[SpecialOffer]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_SpecialOffer_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[SpecialOffer] DROP CONSTRAINT [DF_SpecialOffer_ModifiedDate]
GO
PRINT N'Dropping constraints from [Sales].[Store]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'rowguid' AND object_id = OBJECT_ID(N'[Sales].[Store]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_Store_rowguid]', 'D'))
ALTER TABLE [Sales].[Store] DROP CONSTRAINT [DF_Store_rowguid]
GO
PRINT N'Dropping constraints from [Sales].[Store]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[Sales].[Store]', 'U') AND default_object_id = OBJECT_ID(N'[Sales].[DF_Store_ModifiedDate]', 'D'))
ALTER TABLE [Sales].[Store] DROP CONSTRAINT [DF_Store_ModifiedDate]
GO
PRINT N'Dropping constraints from [dbo].[AWBuildVersion]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ModifiedDate' AND object_id = OBJECT_ID(N'[dbo].[AWBuildVersion]', 'U') AND default_object_id = OBJECT_ID(N'[dbo].[DF_AWBuildVersion_ModifiedDate]', 'D'))
ALTER TABLE [dbo].[AWBuildVersion] DROP CONSTRAINT [DF_AWBuildVersion_ModifiedDate]
GO
PRINT N'Dropping constraints from [dbo].[ErrorLog]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'ErrorTime' AND object_id = OBJECT_ID(N'[dbo].[ErrorLog]', 'U') AND default_object_id = OBJECT_ID(N'[dbo].[DF_ErrorLog_ErrorTime]', 'D'))
ALTER TABLE [dbo].[ErrorLog] DROP CONSTRAINT [DF_ErrorLog_ErrorTime]
GO
PRINT N'Dropping index [AK_Department_Name] from [HumanResources].[Department]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Department_Name' AND object_id = OBJECT_ID(N'[HumanResources].[Department]'))
DROP INDEX [AK_Department_Name] ON [HumanResources].[Department]
GO
PRINT N'Dropping index [IX_EmployeeDepartmentHistory_DepartmentID] from [HumanResources].[EmployeeDepartmentHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_EmployeeDepartmentHistory_DepartmentID' AND object_id = OBJECT_ID(N'[HumanResources].[EmployeeDepartmentHistory]'))
DROP INDEX [IX_EmployeeDepartmentHistory_DepartmentID] ON [HumanResources].[EmployeeDepartmentHistory]
GO
PRINT N'Dropping index [IX_EmployeeDepartmentHistory_ShiftID] from [HumanResources].[EmployeeDepartmentHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_EmployeeDepartmentHistory_ShiftID' AND object_id = OBJECT_ID(N'[HumanResources].[EmployeeDepartmentHistory]'))
DROP INDEX [IX_EmployeeDepartmentHistory_ShiftID] ON [HumanResources].[EmployeeDepartmentHistory]
GO
PRINT N'Dropping index [AK_Employee_NationalIDNumber] from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Employee_NationalIDNumber' AND object_id = OBJECT_ID(N'[HumanResources].[Employee]'))
DROP INDEX [AK_Employee_NationalIDNumber] ON [HumanResources].[Employee]
GO
PRINT N'Dropping index [AK_Employee_LoginID] from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Employee_LoginID' AND object_id = OBJECT_ID(N'[HumanResources].[Employee]'))
DROP INDEX [AK_Employee_LoginID] ON [HumanResources].[Employee]
GO
PRINT N'Dropping index [IX_Employee_OrganizationLevel_OrganizationNode] from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Employee_OrganizationLevel_OrganizationNode' AND object_id = OBJECT_ID(N'[HumanResources].[Employee]'))
DROP INDEX [IX_Employee_OrganizationLevel_OrganizationNode] ON [HumanResources].[Employee]
GO
PRINT N'Dropping index [IX_Employee_OrganizationNode] from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Employee_OrganizationNode' AND object_id = OBJECT_ID(N'[HumanResources].[Employee]'))
DROP INDEX [IX_Employee_OrganizationNode] ON [HumanResources].[Employee]
GO
PRINT N'Dropping index [AK_Employee_rowguid] from [HumanResources].[Employee]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Employee_rowguid' AND object_id = OBJECT_ID(N'[HumanResources].[Employee]'))
DROP INDEX [AK_Employee_rowguid] ON [HumanResources].[Employee]
GO
PRINT N'Dropping index [IX_JobCandidate_BusinessEntityID] from [HumanResources].[JobCandidate]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_JobCandidate_BusinessEntityID' AND object_id = OBJECT_ID(N'[HumanResources].[JobCandidate]'))
DROP INDEX [IX_JobCandidate_BusinessEntityID] ON [HumanResources].[JobCandidate]
GO
PRINT N'Dropping index [AK_Shift_Name] from [HumanResources].[Shift]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Shift_Name' AND object_id = OBJECT_ID(N'[HumanResources].[Shift]'))
DROP INDEX [AK_Shift_Name] ON [HumanResources].[Shift]
GO
PRINT N'Dropping index [AK_Shift_StartTime_EndTime] from [HumanResources].[Shift]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Shift_StartTime_EndTime' AND object_id = OBJECT_ID(N'[HumanResources].[Shift]'))
DROP INDEX [AK_Shift_StartTime_EndTime] ON [HumanResources].[Shift]
GO
PRINT N'Dropping index [AK_AddressType_Name] from [Person].[AddressType]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_AddressType_Name' AND object_id = OBJECT_ID(N'[Person].[AddressType]'))
DROP INDEX [AK_AddressType_Name] ON [Person].[AddressType]
GO
PRINT N'Dropping index [AK_AddressType_rowguid] from [Person].[AddressType]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_AddressType_rowguid' AND object_id = OBJECT_ID(N'[Person].[AddressType]'))
DROP INDEX [AK_AddressType_rowguid] ON [Person].[AddressType]
GO
PRINT N'Dropping index [IX_Address_AddressLine1_AddressLine2_City_StateProvinceID_PostalCode] from [Person].[Address]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Address_AddressLine1_AddressLine2_City_StateProvinceID_PostalCode' AND object_id = OBJECT_ID(N'[Person].[Address]'))
DROP INDEX [IX_Address_AddressLine1_AddressLine2_City_StateProvinceID_PostalCode] ON [Person].[Address]
GO
PRINT N'Dropping index [IX_Address_StateProvinceID] from [Person].[Address]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Address_StateProvinceID' AND object_id = OBJECT_ID(N'[Person].[Address]'))
DROP INDEX [IX_Address_StateProvinceID] ON [Person].[Address]
GO
PRINT N'Dropping index [AK_Address_rowguid] from [Person].[Address]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Address_rowguid' AND object_id = OBJECT_ID(N'[Person].[Address]'))
DROP INDEX [AK_Address_rowguid] ON [Person].[Address]
GO
PRINT N'Dropping index [IX_BusinessEntityAddress_AddressID] from [Person].[BusinessEntityAddress]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_BusinessEntityAddress_AddressID' AND object_id = OBJECT_ID(N'[Person].[BusinessEntityAddress]'))
DROP INDEX [IX_BusinessEntityAddress_AddressID] ON [Person].[BusinessEntityAddress]
GO
PRINT N'Dropping index [IX_BusinessEntityAddress_AddressTypeID] from [Person].[BusinessEntityAddress]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_BusinessEntityAddress_AddressTypeID' AND object_id = OBJECT_ID(N'[Person].[BusinessEntityAddress]'))
DROP INDEX [IX_BusinessEntityAddress_AddressTypeID] ON [Person].[BusinessEntityAddress]
GO
PRINT N'Dropping index [AK_BusinessEntityAddress_rowguid] from [Person].[BusinessEntityAddress]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_BusinessEntityAddress_rowguid' AND object_id = OBJECT_ID(N'[Person].[BusinessEntityAddress]'))
DROP INDEX [AK_BusinessEntityAddress_rowguid] ON [Person].[BusinessEntityAddress]
GO
PRINT N'Dropping index [IX_BusinessEntityContact_PersonID] from [Person].[BusinessEntityContact]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_BusinessEntityContact_PersonID' AND object_id = OBJECT_ID(N'[Person].[BusinessEntityContact]'))
DROP INDEX [IX_BusinessEntityContact_PersonID] ON [Person].[BusinessEntityContact]
GO
PRINT N'Dropping index [IX_BusinessEntityContact_ContactTypeID] from [Person].[BusinessEntityContact]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_BusinessEntityContact_ContactTypeID' AND object_id = OBJECT_ID(N'[Person].[BusinessEntityContact]'))
DROP INDEX [IX_BusinessEntityContact_ContactTypeID] ON [Person].[BusinessEntityContact]
GO
PRINT N'Dropping index [AK_BusinessEntityContact_rowguid] from [Person].[BusinessEntityContact]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_BusinessEntityContact_rowguid' AND object_id = OBJECT_ID(N'[Person].[BusinessEntityContact]'))
DROP INDEX [AK_BusinessEntityContact_rowguid] ON [Person].[BusinessEntityContact]
GO
PRINT N'Dropping index [AK_BusinessEntity_rowguid] from [Person].[BusinessEntity]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_BusinessEntity_rowguid' AND object_id = OBJECT_ID(N'[Person].[BusinessEntity]'))
DROP INDEX [AK_BusinessEntity_rowguid] ON [Person].[BusinessEntity]
GO
PRINT N'Dropping index [AK_ContactType_Name] from [Person].[ContactType]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_ContactType_Name' AND object_id = OBJECT_ID(N'[Person].[ContactType]'))
DROP INDEX [AK_ContactType_Name] ON [Person].[ContactType]
GO
PRINT N'Dropping index [AK_CountryRegion_Name] from [Person].[CountryRegion]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_CountryRegion_Name' AND object_id = OBJECT_ID(N'[Person].[CountryRegion]'))
DROP INDEX [AK_CountryRegion_Name] ON [Person].[CountryRegion]
GO
PRINT N'Dropping index [IX_EmailAddress_EmailAddress] from [Person].[EmailAddress]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_EmailAddress_EmailAddress' AND object_id = OBJECT_ID(N'[Person].[EmailAddress]'))
DROP INDEX [IX_EmailAddress_EmailAddress] ON [Person].[EmailAddress]
GO
PRINT N'Dropping index [IX_PersonPhone_PhoneNumber] from [Person].[PersonPhone]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_PersonPhone_PhoneNumber' AND object_id = OBJECT_ID(N'[Person].[PersonPhone]'))
DROP INDEX [IX_PersonPhone_PhoneNumber] ON [Person].[PersonPhone]
GO
PRINT N'Dropping index [IX_Person_LastName_FirstName_MiddleName] from [Person].[Person]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Person_LastName_FirstName_MiddleName' AND object_id = OBJECT_ID(N'[Person].[Person]'))
DROP INDEX [IX_Person_LastName_FirstName_MiddleName] ON [Person].[Person]
GO
PRINT N'Dropping index [AK_Person_rowguid] from [Person].[Person]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Person_rowguid' AND object_id = OBJECT_ID(N'[Person].[Person]'))
DROP INDEX [AK_Person_rowguid] ON [Person].[Person]
GO
PRINT N'Dropping index [AK_StateProvince_StateProvinceCode_CountryRegionCode] from [Person].[StateProvince]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_StateProvince_StateProvinceCode_CountryRegionCode' AND object_id = OBJECT_ID(N'[Person].[StateProvince]'))
DROP INDEX [AK_StateProvince_StateProvinceCode_CountryRegionCode] ON [Person].[StateProvince]
GO
PRINT N'Dropping index [AK_StateProvince_Name] from [Person].[StateProvince]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_StateProvince_Name' AND object_id = OBJECT_ID(N'[Person].[StateProvince]'))
DROP INDEX [AK_StateProvince_Name] ON [Person].[StateProvince]
GO
PRINT N'Dropping index [AK_StateProvince_rowguid] from [Person].[StateProvince]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_StateProvince_rowguid' AND object_id = OBJECT_ID(N'[Person].[StateProvince]'))
DROP INDEX [AK_StateProvince_rowguid] ON [Person].[StateProvince]
GO
PRINT N'Dropping index [IX_BillOfMaterials_UnitMeasureCode] from [Production].[BillOfMaterials]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_BillOfMaterials_UnitMeasureCode' AND object_id = OBJECT_ID(N'[Production].[BillOfMaterials]'))
DROP INDEX [IX_BillOfMaterials_UnitMeasureCode] ON [Production].[BillOfMaterials]
GO
PRINT N'Dropping index [AK_Culture_Name] from [Production].[Culture]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Culture_Name' AND object_id = OBJECT_ID(N'[Production].[Culture]'))
DROP INDEX [AK_Culture_Name] ON [Production].[Culture]
GO
PRINT N'Dropping index [AK_Document_DocumentLevel_DocumentNode] from [Production].[Document]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Document_DocumentLevel_DocumentNode' AND object_id = OBJECT_ID(N'[Production].[Document]'))
DROP INDEX [AK_Document_DocumentLevel_DocumentNode] ON [Production].[Document]
GO
PRINT N'Dropping index [IX_Document_FileName_Revision] from [Production].[Document]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Document_FileName_Revision' AND object_id = OBJECT_ID(N'[Production].[Document]'))
DROP INDEX [IX_Document_FileName_Revision] ON [Production].[Document]
GO
PRINT N'Dropping index [AK_Document_rowguid] from [Production].[Document]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Document_rowguid' AND object_id = OBJECT_ID(N'[Production].[Document]'))
DROP INDEX [AK_Document_rowguid] ON [Production].[Document]
GO
PRINT N'Dropping index [AK_Location_Name] from [Production].[Location]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Location_Name' AND object_id = OBJECT_ID(N'[Production].[Location]'))
DROP INDEX [AK_Location_Name] ON [Production].[Location]
GO
PRINT N'Dropping index [AK_ProductCategory_Name] from [Production].[ProductCategory]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_ProductCategory_Name' AND object_id = OBJECT_ID(N'[Production].[ProductCategory]'))
DROP INDEX [AK_ProductCategory_Name] ON [Production].[ProductCategory]
GO
PRINT N'Dropping index [AK_ProductCategory_rowguid] from [Production].[ProductCategory]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_ProductCategory_rowguid' AND object_id = OBJECT_ID(N'[Production].[ProductCategory]'))
DROP INDEX [AK_ProductCategory_rowguid] ON [Production].[ProductCategory]
GO
PRINT N'Dropping index [AK_ProductDescription_rowguid] from [Production].[ProductDescription]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_ProductDescription_rowguid' AND object_id = OBJECT_ID(N'[Production].[ProductDescription]'))
DROP INDEX [AK_ProductDescription_rowguid] ON [Production].[ProductDescription]
GO
PRINT N'Dropping index [AK_ProductModel_Name] from [Production].[ProductModel]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_ProductModel_Name' AND object_id = OBJECT_ID(N'[Production].[ProductModel]'))
DROP INDEX [AK_ProductModel_Name] ON [Production].[ProductModel]
GO
PRINT N'Dropping index [AK_ProductModel_rowguid] from [Production].[ProductModel]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_ProductModel_rowguid' AND object_id = OBJECT_ID(N'[Production].[ProductModel]'))
DROP INDEX [AK_ProductModel_rowguid] ON [Production].[ProductModel]
GO
PRINT N'Dropping index [IX_ProductReview_ProductID_Name] from [Production].[ProductReview]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_ProductReview_ProductID_Name' AND object_id = OBJECT_ID(N'[Production].[ProductReview]'))
DROP INDEX [IX_ProductReview_ProductID_Name] ON [Production].[ProductReview]
GO
PRINT N'Dropping index [AK_ProductSubcategory_Name] from [Production].[ProductSubcategory]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_ProductSubcategory_Name' AND object_id = OBJECT_ID(N'[Production].[ProductSubcategory]'))
DROP INDEX [AK_ProductSubcategory_Name] ON [Production].[ProductSubcategory]
GO
PRINT N'Dropping index [AK_ProductSubcategory_rowguid] from [Production].[ProductSubcategory]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_ProductSubcategory_rowguid' AND object_id = OBJECT_ID(N'[Production].[ProductSubcategory]'))
DROP INDEX [AK_ProductSubcategory_rowguid] ON [Production].[ProductSubcategory]
GO
PRINT N'Dropping index [AK_Product_Name] from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Product_Name' AND object_id = OBJECT_ID(N'[Production].[Product]'))
DROP INDEX [AK_Product_Name] ON [Production].[Product]
GO
PRINT N'Dropping index [AK_Product_ProductNumber] from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Product_ProductNumber' AND object_id = OBJECT_ID(N'[Production].[Product]'))
DROP INDEX [AK_Product_ProductNumber] ON [Production].[Product]
GO
PRINT N'Dropping index [AK_Product_rowguid] from [Production].[Product]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Product_rowguid' AND object_id = OBJECT_ID(N'[Production].[Product]'))
DROP INDEX [AK_Product_rowguid] ON [Production].[Product]
GO
PRINT N'Dropping index [AK_ScrapReason_Name] from [Production].[ScrapReason]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_ScrapReason_Name' AND object_id = OBJECT_ID(N'[Production].[ScrapReason]'))
DROP INDEX [AK_ScrapReason_Name] ON [Production].[ScrapReason]
GO
PRINT N'Dropping index [IX_TransactionHistoryArchive_ProductID] from [Production].[TransactionHistoryArchive]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_TransactionHistoryArchive_ProductID' AND object_id = OBJECT_ID(N'[Production].[TransactionHistoryArchive]'))
DROP INDEX [IX_TransactionHistoryArchive_ProductID] ON [Production].[TransactionHistoryArchive]
GO
PRINT N'Dropping index [IX_TransactionHistoryArchive_ReferenceOrderID_ReferenceOrderLineID] from [Production].[TransactionHistoryArchive]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_TransactionHistoryArchive_ReferenceOrderID_ReferenceOrderLineID' AND object_id = OBJECT_ID(N'[Production].[TransactionHistoryArchive]'))
DROP INDEX [IX_TransactionHistoryArchive_ReferenceOrderID_ReferenceOrderLineID] ON [Production].[TransactionHistoryArchive]
GO
PRINT N'Dropping index [IX_TransactionHistory_ProductID] from [Production].[TransactionHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_TransactionHistory_ProductID' AND object_id = OBJECT_ID(N'[Production].[TransactionHistory]'))
DROP INDEX [IX_TransactionHistory_ProductID] ON [Production].[TransactionHistory]
GO
PRINT N'Dropping index [IX_TransactionHistory_ReferenceOrderID_ReferenceOrderLineID] from [Production].[TransactionHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_TransactionHistory_ReferenceOrderID_ReferenceOrderLineID' AND object_id = OBJECT_ID(N'[Production].[TransactionHistory]'))
DROP INDEX [IX_TransactionHistory_ReferenceOrderID_ReferenceOrderLineID] ON [Production].[TransactionHistory]
GO
PRINT N'Dropping index [AK_UnitMeasure_Name] from [Production].[UnitMeasure]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_UnitMeasure_Name' AND object_id = OBJECT_ID(N'[Production].[UnitMeasure]'))
DROP INDEX [AK_UnitMeasure_Name] ON [Production].[UnitMeasure]
GO
PRINT N'Dropping index [IX_WorkOrderRouting_ProductID] from [Production].[WorkOrderRouting]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_WorkOrderRouting_ProductID' AND object_id = OBJECT_ID(N'[Production].[WorkOrderRouting]'))
DROP INDEX [IX_WorkOrderRouting_ProductID] ON [Production].[WorkOrderRouting]
GO
PRINT N'Dropping index [IX_WorkOrder_ProductID] from [Production].[WorkOrder]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_WorkOrder_ProductID' AND object_id = OBJECT_ID(N'[Production].[WorkOrder]'))
DROP INDEX [IX_WorkOrder_ProductID] ON [Production].[WorkOrder]
GO
PRINT N'Dropping index [IX_WorkOrder_ScrapReasonID] from [Production].[WorkOrder]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_WorkOrder_ScrapReasonID' AND object_id = OBJECT_ID(N'[Production].[WorkOrder]'))
DROP INDEX [IX_WorkOrder_ScrapReasonID] ON [Production].[WorkOrder]
GO
PRINT N'Dropping index [IX_ProductVendor_BusinessEntityID] from [Purchasing].[ProductVendor]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_ProductVendor_BusinessEntityID' AND object_id = OBJECT_ID(N'[Purchasing].[ProductVendor]'))
DROP INDEX [IX_ProductVendor_BusinessEntityID] ON [Purchasing].[ProductVendor]
GO
PRINT N'Dropping index [IX_ProductVendor_UnitMeasureCode] from [Purchasing].[ProductVendor]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_ProductVendor_UnitMeasureCode' AND object_id = OBJECT_ID(N'[Purchasing].[ProductVendor]'))
DROP INDEX [IX_ProductVendor_UnitMeasureCode] ON [Purchasing].[ProductVendor]
GO
PRINT N'Dropping index [IX_PurchaseOrderDetail_ProductID] from [Purchasing].[PurchaseOrderDetail]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_PurchaseOrderDetail_ProductID' AND object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderDetail]'))
DROP INDEX [IX_PurchaseOrderDetail_ProductID] ON [Purchasing].[PurchaseOrderDetail]
GO
PRINT N'Dropping index [IX_PurchaseOrderHeader_EmployeeID] from [Purchasing].[PurchaseOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_PurchaseOrderHeader_EmployeeID' AND object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]'))
DROP INDEX [IX_PurchaseOrderHeader_EmployeeID] ON [Purchasing].[PurchaseOrderHeader]
GO
PRINT N'Dropping index [IX_PurchaseOrderHeader_VendorID] from [Purchasing].[PurchaseOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_PurchaseOrderHeader_VendorID' AND object_id = OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]'))
DROP INDEX [IX_PurchaseOrderHeader_VendorID] ON [Purchasing].[PurchaseOrderHeader]
GO
PRINT N'Dropping index [AK_ShipMethod_Name] from [Purchasing].[ShipMethod]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_ShipMethod_Name' AND object_id = OBJECT_ID(N'[Purchasing].[ShipMethod]'))
DROP INDEX [AK_ShipMethod_Name] ON [Purchasing].[ShipMethod]
GO
PRINT N'Dropping index [AK_ShipMethod_rowguid] from [Purchasing].[ShipMethod]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_ShipMethod_rowguid' AND object_id = OBJECT_ID(N'[Purchasing].[ShipMethod]'))
DROP INDEX [AK_ShipMethod_rowguid] ON [Purchasing].[ShipMethod]
GO
PRINT N'Dropping index [AK_Vendor_AccountNumber] from [Purchasing].[Vendor]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Vendor_AccountNumber' AND object_id = OBJECT_ID(N'[Purchasing].[Vendor]'))
DROP INDEX [AK_Vendor_AccountNumber] ON [Purchasing].[Vendor]
GO
PRINT N'Dropping index [IX_CountryRegionCurrency_CurrencyCode] from [Sales].[CountryRegionCurrency]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_CountryRegionCurrency_CurrencyCode' AND object_id = OBJECT_ID(N'[Sales].[CountryRegionCurrency]'))
DROP INDEX [IX_CountryRegionCurrency_CurrencyCode] ON [Sales].[CountryRegionCurrency]
GO
PRINT N'Dropping index [AK_CreditCard_CardNumber] from [Sales].[CreditCard]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_CreditCard_CardNumber' AND object_id = OBJECT_ID(N'[Sales].[CreditCard]'))
DROP INDEX [AK_CreditCard_CardNumber] ON [Sales].[CreditCard]
GO
PRINT N'Dropping index [AK_CurrencyRate_CurrencyRateDate_FromCurrencyCode_ToCurrencyCode] from [Sales].[CurrencyRate]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_CurrencyRate_CurrencyRateDate_FromCurrencyCode_ToCurrencyCode' AND object_id = OBJECT_ID(N'[Sales].[CurrencyRate]'))
DROP INDEX [AK_CurrencyRate_CurrencyRateDate_FromCurrencyCode_ToCurrencyCode] ON [Sales].[CurrencyRate]
GO
PRINT N'Dropping index [AK_Currency_Name] from [Sales].[Currency]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Currency_Name' AND object_id = OBJECT_ID(N'[Sales].[Currency]'))
DROP INDEX [AK_Currency_Name] ON [Sales].[Currency]
GO
PRINT N'Dropping index [IX_Customer_TerritoryID] from [Sales].[Customer]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Customer_TerritoryID' AND object_id = OBJECT_ID(N'[Sales].[Customer]'))
DROP INDEX [IX_Customer_TerritoryID] ON [Sales].[Customer]
GO
PRINT N'Dropping index [AK_Customer_AccountNumber] from [Sales].[Customer]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Customer_AccountNumber' AND object_id = OBJECT_ID(N'[Sales].[Customer]'))
DROP INDEX [AK_Customer_AccountNumber] ON [Sales].[Customer]
GO
PRINT N'Dropping index [AK_Customer_rowguid] from [Sales].[Customer]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Customer_rowguid' AND object_id = OBJECT_ID(N'[Sales].[Customer]'))
DROP INDEX [AK_Customer_rowguid] ON [Sales].[Customer]
GO
PRINT N'Dropping index [IX_SalesOrderDetail_ProductID] from [Sales].[SalesOrderDetail]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_SalesOrderDetail_ProductID' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderDetail]'))
DROP INDEX [IX_SalesOrderDetail_ProductID] ON [Sales].[SalesOrderDetail]
GO
PRINT N'Dropping index [AK_SalesOrderDetail_rowguid] from [Sales].[SalesOrderDetail]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_SalesOrderDetail_rowguid' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderDetail]'))
DROP INDEX [AK_SalesOrderDetail_rowguid] ON [Sales].[SalesOrderDetail]
GO
PRINT N'Dropping index [AK_SalesOrderHeader_SalesOrderNumber] from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_SalesOrderHeader_SalesOrderNumber' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]'))
DROP INDEX [AK_SalesOrderHeader_SalesOrderNumber] ON [Sales].[SalesOrderHeader]
GO
PRINT N'Dropping index [IX_SalesOrderHeader_CustomerID] from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_SalesOrderHeader_CustomerID' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]'))
DROP INDEX [IX_SalesOrderHeader_CustomerID] ON [Sales].[SalesOrderHeader]
GO
PRINT N'Dropping index [IX_SalesOrderHeader_SalesPersonID] from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_SalesOrderHeader_SalesPersonID' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]'))
DROP INDEX [IX_SalesOrderHeader_SalesPersonID] ON [Sales].[SalesOrderHeader]
GO
PRINT N'Dropping index [AK_SalesOrderHeader_rowguid] from [Sales].[SalesOrderHeader]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_SalesOrderHeader_rowguid' AND object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]'))
DROP INDEX [AK_SalesOrderHeader_rowguid] ON [Sales].[SalesOrderHeader]
GO
PRINT N'Dropping index [AK_SalesPersonQuotaHistory_rowguid] from [Sales].[SalesPersonQuotaHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_SalesPersonQuotaHistory_rowguid' AND object_id = OBJECT_ID(N'[Sales].[SalesPersonQuotaHistory]'))
DROP INDEX [AK_SalesPersonQuotaHistory_rowguid] ON [Sales].[SalesPersonQuotaHistory]
GO
PRINT N'Dropping index [AK_SalesPerson_rowguid] from [Sales].[SalesPerson]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_SalesPerson_rowguid' AND object_id = OBJECT_ID(N'[Sales].[SalesPerson]'))
DROP INDEX [AK_SalesPerson_rowguid] ON [Sales].[SalesPerson]
GO
PRINT N'Dropping index [AK_SalesTaxRate_StateProvinceID_TaxType] from [Sales].[SalesTaxRate]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_SalesTaxRate_StateProvinceID_TaxType' AND object_id = OBJECT_ID(N'[Sales].[SalesTaxRate]'))
DROP INDEX [AK_SalesTaxRate_StateProvinceID_TaxType] ON [Sales].[SalesTaxRate]
GO
PRINT N'Dropping index [AK_SalesTaxRate_rowguid] from [Sales].[SalesTaxRate]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_SalesTaxRate_rowguid' AND object_id = OBJECT_ID(N'[Sales].[SalesTaxRate]'))
DROP INDEX [AK_SalesTaxRate_rowguid] ON [Sales].[SalesTaxRate]
GO
PRINT N'Dropping index [AK_SalesTerritoryHistory_rowguid] from [Sales].[SalesTerritoryHistory]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_SalesTerritoryHistory_rowguid' AND object_id = OBJECT_ID(N'[Sales].[SalesTerritoryHistory]'))
DROP INDEX [AK_SalesTerritoryHistory_rowguid] ON [Sales].[SalesTerritoryHistory]
GO
PRINT N'Dropping index [AK_SalesTerritory_Name] from [Sales].[SalesTerritory]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_SalesTerritory_Name' AND object_id = OBJECT_ID(N'[Sales].[SalesTerritory]'))
DROP INDEX [AK_SalesTerritory_Name] ON [Sales].[SalesTerritory]
GO
PRINT N'Dropping index [AK_SalesTerritory_rowguid] from [Sales].[SalesTerritory]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_SalesTerritory_rowguid' AND object_id = OBJECT_ID(N'[Sales].[SalesTerritory]'))
DROP INDEX [AK_SalesTerritory_rowguid] ON [Sales].[SalesTerritory]
GO
PRINT N'Dropping index [IX_ShoppingCartItem_ShoppingCartID_ProductID] from [Sales].[ShoppingCartItem]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_ShoppingCartItem_ShoppingCartID_ProductID' AND object_id = OBJECT_ID(N'[Sales].[ShoppingCartItem]'))
DROP INDEX [IX_ShoppingCartItem_ShoppingCartID_ProductID] ON [Sales].[ShoppingCartItem]
GO
PRINT N'Dropping index [IX_SpecialOfferProduct_ProductID] from [Sales].[SpecialOfferProduct]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_SpecialOfferProduct_ProductID' AND object_id = OBJECT_ID(N'[Sales].[SpecialOfferProduct]'))
DROP INDEX [IX_SpecialOfferProduct_ProductID] ON [Sales].[SpecialOfferProduct]
GO
PRINT N'Dropping index [AK_SpecialOfferProduct_rowguid] from [Sales].[SpecialOfferProduct]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_SpecialOfferProduct_rowguid' AND object_id = OBJECT_ID(N'[Sales].[SpecialOfferProduct]'))
DROP INDEX [AK_SpecialOfferProduct_rowguid] ON [Sales].[SpecialOfferProduct]
GO
PRINT N'Dropping index [AK_SpecialOffer_rowguid] from [Sales].[SpecialOffer]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_SpecialOffer_rowguid' AND object_id = OBJECT_ID(N'[Sales].[SpecialOffer]'))
DROP INDEX [AK_SpecialOffer_rowguid] ON [Sales].[SpecialOffer]
GO
PRINT N'Dropping index [IX_Store_SalesPersonID] from [Sales].[Store]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Store_SalesPersonID' AND object_id = OBJECT_ID(N'[Sales].[Store]'))
DROP INDEX [IX_Store_SalesPersonID] ON [Sales].[Store]
GO
PRINT N'Dropping index [AK_Store_rowguid] from [Sales].[Store]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_Store_rowguid' AND object_id = OBJECT_ID(N'[Sales].[Store]'))
DROP INDEX [AK_Store_rowguid] ON [Sales].[Store]
GO
PRINT N'Dropping index [AK_BillOfMaterials_ProductAssemblyID_ComponentID_StartDate] from [Production].[BillOfMaterials]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'AK_BillOfMaterials_ProductAssemblyID_ComponentID_StartDate' AND object_id = OBJECT_ID(N'[Production].[BillOfMaterials]'))
DROP INDEX [AK_BillOfMaterials_ProductAssemblyID_ComponentID_StartDate] ON [Production].[BillOfMaterials]
GO
PRINT N'Dropping trigger [HumanResources].[dEmployee] from [HumanResources].[Employee]'
GO
IF OBJECT_ID(N'[HumanResources].[dEmployee]', 'TR') IS NOT NULL
DROP TRIGGER [HumanResources].[dEmployee]
GO
PRINT N'Dropping trigger [Person].[iuPerson] from [Person].[Person]'
GO
IF OBJECT_ID(N'[Person].[iuPerson]', 'TR') IS NOT NULL
DROP TRIGGER [Person].[iuPerson]
GO
PRINT N'Dropping trigger [Production].[iWorkOrder] from [Production].[WorkOrder]'
GO
IF OBJECT_ID(N'[Production].[iWorkOrder]', 'TR') IS NOT NULL
DROP TRIGGER [Production].[iWorkOrder]
GO
PRINT N'Dropping trigger [Production].[uWorkOrder] from [Production].[WorkOrder]'
GO
IF OBJECT_ID(N'[Production].[uWorkOrder]', 'TR') IS NOT NULL
DROP TRIGGER [Production].[uWorkOrder]
GO
PRINT N'Dropping trigger [Purchasing].[iPurchaseOrderDetail] from [Purchasing].[PurchaseOrderDetail]'
GO
IF OBJECT_ID(N'[Purchasing].[iPurchaseOrderDetail]', 'TR') IS NOT NULL
DROP TRIGGER [Purchasing].[iPurchaseOrderDetail]
GO
PRINT N'Dropping trigger [Purchasing].[uPurchaseOrderDetail] from [Purchasing].[PurchaseOrderDetail]'
GO
IF OBJECT_ID(N'[Purchasing].[uPurchaseOrderDetail]', 'TR') IS NOT NULL
DROP TRIGGER [Purchasing].[uPurchaseOrderDetail]
GO
PRINT N'Dropping trigger [Purchasing].[uPurchaseOrderHeader] from [Purchasing].[PurchaseOrderHeader]'
GO
IF OBJECT_ID(N'[Purchasing].[uPurchaseOrderHeader]', 'TR') IS NOT NULL
DROP TRIGGER [Purchasing].[uPurchaseOrderHeader]
GO
PRINT N'Dropping trigger [Purchasing].[dVendor] from [Purchasing].[Vendor]'
GO
IF OBJECT_ID(N'[Purchasing].[dVendor]', 'TR') IS NOT NULL
DROP TRIGGER [Purchasing].[dVendor]
GO
PRINT N'Dropping trigger [Sales].[iduSalesOrderDetail] from [Sales].[SalesOrderDetail]'
GO
IF OBJECT_ID(N'[Sales].[iduSalesOrderDetail]', 'TR') IS NOT NULL
DROP TRIGGER [Sales].[iduSalesOrderDetail]
GO
PRINT N'Dropping trigger [Sales].[uSalesOrderHeader] from [Sales].[SalesOrderHeader]'
GO
IF OBJECT_ID(N'[Sales].[uSalesOrderHeader]', 'TR') IS NOT NULL
DROP TRIGGER [Sales].[uSalesOrderHeader]
GO
PRINT N'Dropping computed columns'
GO
IF COL_LENGTH(N'[Sales].[Customer]', N'AccountNumber') IS NOT NULL
ALTER TABLE [Sales].[Customer] DROP COLUMN [AccountNumber]
GO
PRINT N'Dropping DDL triggers'
GO
IF EXISTS (SELECT 1 FROM sys.triggers WHERE name = N'ddlDatabaseTriggerLog' AND parent_class = 0)
DROP TRIGGER [ddlDatabaseTriggerLog] ON DATABASE
GO
PRINT N'Dropping [dbo].[DatabaseLog]'
GO
IF OBJECT_ID(N'[dbo].[DatabaseLog]', 'U') IS NOT NULL
DROP TABLE [dbo].[DatabaseLog]
GO
PRINT N'Dropping [dbo].[AWBuildVersion]'
GO
IF OBJECT_ID(N'[dbo].[AWBuildVersion]', 'U') IS NOT NULL
DROP TABLE [dbo].[AWBuildVersion]
GO
PRINT N'Dropping [dbo].[ufnGetSalesOrderStatusText]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufnGetSalesOrderStatusText]') AND (type = 'IF' OR type = 'FN' OR type = 'TF' OR type = 'FT' OR type = 'FS'))
DROP FUNCTION [dbo].[ufnGetSalesOrderStatusText]
GO
PRINT N'Dropping [dbo].[ufnGetPurchaseOrderStatusText]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufnGetPurchaseOrderStatusText]') AND (type = 'IF' OR type = 'FN' OR type = 'TF' OR type = 'FT' OR type = 'FS'))
DROP FUNCTION [dbo].[ufnGetPurchaseOrderStatusText]
GO
PRINT N'Dropping [dbo].[ufnGetDocumentStatusText]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufnGetDocumentStatusText]') AND (type = 'IF' OR type = 'FN' OR type = 'TF' OR type = 'FT' OR type = 'FS'))
DROP FUNCTION [dbo].[ufnGetDocumentStatusText]
GO
PRINT N'Dropping [Sales].[vPersonDemographics]'
GO
IF OBJECT_ID(N'[Sales].[vPersonDemographics]', 'V') IS NOT NULL
DROP VIEW [Sales].[vPersonDemographics]
GO
PRINT N'Dropping [Sales].[vIndividualCustomer]'
GO
IF OBJECT_ID(N'[Sales].[vIndividualCustomer]', 'V') IS NOT NULL
DROP VIEW [Sales].[vIndividualCustomer]
GO
PRINT N'Dropping [HumanResources].[vEmployeeDepartmentHistory]'
GO
IF OBJECT_ID(N'[HumanResources].[vEmployeeDepartmentHistory]', 'V') IS NOT NULL
DROP VIEW [HumanResources].[vEmployeeDepartmentHistory]
GO
PRINT N'Dropping [HumanResources].[vEmployeeDepartment]'
GO
IF OBJECT_ID(N'[HumanResources].[vEmployeeDepartment]', 'V') IS NOT NULL
DROP VIEW [HumanResources].[vEmployeeDepartment]
GO
PRINT N'Dropping [HumanResources].[vEmployee]'
GO
IF OBJECT_ID(N'[HumanResources].[vEmployee]', 'V') IS NOT NULL
DROP VIEW [HumanResources].[vEmployee]
GO
PRINT N'Dropping [Person].[vAdditionalContactInfo]'
GO
IF OBJECT_ID(N'[Person].[vAdditionalContactInfo]', 'V') IS NOT NULL
DROP VIEW [Person].[vAdditionalContactInfo]
GO
PRINT N'Dropping [Production].[TransactionHistoryArchive]'
GO
IF OBJECT_ID(N'[Production].[TransactionHistoryArchive]', 'U') IS NOT NULL
DROP TABLE [Production].[TransactionHistoryArchive]
GO
PRINT N'Dropping [HumanResources].[uspUpdateEmployeePersonalInfo]'
GO
IF OBJECT_ID(N'[HumanResources].[uspUpdateEmployeePersonalInfo]', 'P') IS NOT NULL
DROP PROCEDURE [HumanResources].[uspUpdateEmployeePersonalInfo]
GO
PRINT N'Dropping [HumanResources].[uspUpdateEmployeeLogin]'
GO
IF OBJECT_ID(N'[HumanResources].[uspUpdateEmployeeLogin]', 'P') IS NOT NULL
DROP PROCEDURE [HumanResources].[uspUpdateEmployeeLogin]
GO
PRINT N'Dropping [HumanResources].[uspUpdateEmployeeHireInfo]'
GO
IF OBJECT_ID(N'[HumanResources].[uspUpdateEmployeeHireInfo]', 'P') IS NOT NULL
DROP PROCEDURE [HumanResources].[uspUpdateEmployeeHireInfo]
GO
PRINT N'Dropping [dbo].[uspGetWhereUsedProductID]'
GO
IF OBJECT_ID(N'[dbo].[uspGetWhereUsedProductID]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[uspGetWhereUsedProductID]
GO
PRINT N'Dropping [dbo].[uspGetManagerEmployees]'
GO
IF OBJECT_ID(N'[dbo].[uspGetManagerEmployees]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[uspGetManagerEmployees]
GO
PRINT N'Dropping [dbo].[uspGetEmployeeManagers]'
GO
IF OBJECT_ID(N'[dbo].[uspGetEmployeeManagers]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[uspGetEmployeeManagers]
GO
PRINT N'Dropping [dbo].[uspGetBillOfMaterials]'
GO
IF OBJECT_ID(N'[dbo].[uspGetBillOfMaterials]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[uspGetBillOfMaterials]
GO
PRINT N'Dropping [dbo].[ufnGetStock]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufnGetStock]') AND (type = 'IF' OR type = 'FN' OR type = 'TF' OR type = 'FT' OR type = 'FS'))
DROP FUNCTION [dbo].[ufnGetStock]
GO
PRINT N'Dropping [dbo].[ufnGetProductStandardCost]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufnGetProductStandardCost]') AND (type = 'IF' OR type = 'FN' OR type = 'TF' OR type = 'FT' OR type = 'FS'))
DROP FUNCTION [dbo].[ufnGetProductStandardCost]
GO
PRINT N'Dropping [dbo].[ufnGetProductListPrice]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufnGetProductListPrice]') AND (type = 'IF' OR type = 'FN' OR type = 'TF' OR type = 'FT' OR type = 'FS'))
DROP FUNCTION [dbo].[ufnGetProductListPrice]
GO
PRINT N'Dropping [dbo].[ufnGetProductDealerPrice]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufnGetProductDealerPrice]') AND (type = 'IF' OR type = 'FN' OR type = 'TF' OR type = 'FT' OR type = 'FS'))
DROP FUNCTION [dbo].[ufnGetProductDealerPrice]
GO
PRINT N'Dropping [dbo].[ufnGetContactInformation]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufnGetContactInformation]') AND (type = 'IF' OR type = 'FN' OR type = 'TF' OR type = 'FT' OR type = 'FS'))
DROP FUNCTION [dbo].[ufnGetContactInformation]
GO
PRINT N'Dropping [Purchasing].[vVendorWithAddresses]'
GO
IF OBJECT_ID(N'[Purchasing].[vVendorWithAddresses]', 'V') IS NOT NULL
DROP VIEW [Purchasing].[vVendorWithAddresses]
GO
PRINT N'Dropping [Purchasing].[vVendorWithContacts]'
GO
IF OBJECT_ID(N'[Purchasing].[vVendorWithContacts]', 'V') IS NOT NULL
DROP VIEW [Purchasing].[vVendorWithContacts]
GO
PRINT N'Dropping [Sales].[vStoreWithAddresses]'
GO
IF OBJECT_ID(N'[Sales].[vStoreWithAddresses]', 'V') IS NOT NULL
DROP VIEW [Sales].[vStoreWithAddresses]
GO
PRINT N'Dropping [Sales].[vStoreWithContacts]'
GO
IF OBJECT_ID(N'[Sales].[vStoreWithContacts]', 'V') IS NOT NULL
DROP VIEW [Sales].[vStoreWithContacts]
GO
PRINT N'Dropping [Sales].[vStoreWithDemographics]'
GO
IF OBJECT_ID(N'[Sales].[vStoreWithDemographics]', 'V') IS NOT NULL
DROP VIEW [Sales].[vStoreWithDemographics]
GO
PRINT N'Dropping [Person].[vStateProvinceCountryRegion]'
GO
IF OBJECT_ID(N'[Person].[vStateProvinceCountryRegion]', 'V') IS NOT NULL
DROP VIEW [Person].[vStateProvinceCountryRegion]
GO
PRINT N'Dropping [Sales].[vSalesPersonSalesByFiscalYears]'
GO
IF OBJECT_ID(N'[Sales].[vSalesPersonSalesByFiscalYears]', 'V') IS NOT NULL
DROP VIEW [Sales].[vSalesPersonSalesByFiscalYears]
GO
PRINT N'Dropping [Sales].[vSalesPerson]'
GO
IF OBJECT_ID(N'[Sales].[vSalesPerson]', 'V') IS NOT NULL
DROP VIEW [Sales].[vSalesPerson]
GO
PRINT N'Dropping [Production].[vProductModelInstructions]'
GO
IF OBJECT_ID(N'[Production].[vProductModelInstructions]', 'V') IS NOT NULL
DROP VIEW [Production].[vProductModelInstructions]
GO
PRINT N'Dropping [Production].[vProductModelCatalogDescription]'
GO
IF OBJECT_ID(N'[Production].[vProductModelCatalogDescription]', 'V') IS NOT NULL
DROP VIEW [Production].[vProductModelCatalogDescription]
GO
PRINT N'Dropping [Production].[vProductAndDescription]'
GO
IF OBJECT_ID(N'[Production].[vProductAndDescription]', 'V') IS NOT NULL
DROP VIEW [Production].[vProductAndDescription]
GO
PRINT N'Dropping [HumanResources].[vJobCandidateEducation]'
GO
IF OBJECT_ID(N'[HumanResources].[vJobCandidateEducation]', 'V') IS NOT NULL
DROP VIEW [HumanResources].[vJobCandidateEducation]
GO
PRINT N'Dropping [HumanResources].[vJobCandidateEmployment]'
GO
IF OBJECT_ID(N'[HumanResources].[vJobCandidateEmployment]', 'V') IS NOT NULL
DROP VIEW [HumanResources].[vJobCandidateEmployment]
GO
PRINT N'Dropping [HumanResources].[vJobCandidate]'
GO
IF OBJECT_ID(N'[HumanResources].[vJobCandidate]', 'V') IS NOT NULL
DROP VIEW [HumanResources].[vJobCandidate]
GO
PRINT N'Dropping [Production].[WorkOrderRouting]'
GO
IF OBJECT_ID(N'[Production].[WorkOrderRouting]', 'U') IS NOT NULL
DROP TABLE [Production].[WorkOrderRouting]
GO
PRINT N'Dropping [Production].[ScrapReason]'
GO
IF OBJECT_ID(N'[Production].[ScrapReason]', 'U') IS NOT NULL
DROP TABLE [Production].[ScrapReason]
GO
PRINT N'Dropping [Sales].[SpecialOffer]'
GO
IF OBJECT_ID(N'[Sales].[SpecialOffer]', 'U') IS NOT NULL
DROP TABLE [Sales].[SpecialOffer]
GO
PRINT N'Dropping [Sales].[ShoppingCartItem]'
GO
IF OBJECT_ID(N'[Sales].[ShoppingCartItem]', 'U') IS NOT NULL
DROP TABLE [Sales].[ShoppingCartItem]
GO
PRINT N'Dropping [Sales].[SalesTerritoryHistory]'
GO
IF OBJECT_ID(N'[Sales].[SalesTerritoryHistory]', 'U') IS NOT NULL
DROP TABLE [Sales].[SalesTerritoryHistory]
GO
PRINT N'Dropping [Sales].[SalesTaxRate]'
GO
IF OBJECT_ID(N'[Sales].[SalesTaxRate]', 'U') IS NOT NULL
DROP TABLE [Sales].[SalesTaxRate]
GO
PRINT N'Dropping [Sales].[SalesPersonQuotaHistory]'
GO
IF OBJECT_ID(N'[Sales].[SalesPersonQuotaHistory]', 'U') IS NOT NULL
DROP TABLE [Sales].[SalesPersonQuotaHistory]
GO
PRINT N'Dropping [Sales].[SalesReason]'
GO
IF OBJECT_ID(N'[Sales].[SalesReason]', 'U') IS NOT NULL
DROP TABLE [Sales].[SalesReason]
GO
PRINT N'Dropping [Sales].[SalesOrderHeaderSalesReason]'
GO
IF OBJECT_ID(N'[Sales].[SalesOrderHeaderSalesReason]', 'U') IS NOT NULL
DROP TABLE [Sales].[SalesOrderHeaderSalesReason]
GO
PRINT N'Dropping [Sales].[SpecialOfferProduct]'
GO
IF OBJECT_ID(N'[Sales].[SpecialOfferProduct]', 'U') IS NOT NULL
DROP TABLE [Sales].[SpecialOfferProduct]
GO
PRINT N'Dropping [Purchasing].[ShipMethod]'
GO
IF OBJECT_ID(N'[Purchasing].[ShipMethod]', 'U') IS NOT NULL
DROP TABLE [Purchasing].[ShipMethod]
GO
PRINT N'Dropping [Purchasing].[ProductVendor]'
GO
IF OBJECT_ID(N'[Purchasing].[ProductVendor]', 'U') IS NOT NULL
DROP TABLE [Purchasing].[ProductVendor]
GO
PRINT N'Dropping [Production].[ProductCategory]'
GO
IF OBJECT_ID(N'[Production].[ProductCategory]', 'U') IS NOT NULL
DROP TABLE [Production].[ProductCategory]
GO
PRINT N'Dropping [Production].[ProductReview]'
GO
IF OBJECT_ID(N'[Production].[ProductReview]', 'U') IS NOT NULL
DROP TABLE [Production].[ProductReview]
GO
PRINT N'Dropping [Production].[ProductPhoto]'
GO
IF OBJECT_ID(N'[Production].[ProductPhoto]', 'U') IS NOT NULL
DROP TABLE [Production].[ProductPhoto]
GO
PRINT N'Dropping [Production].[ProductProductPhoto]'
GO
IF OBJECT_ID(N'[Production].[ProductProductPhoto]', 'U') IS NOT NULL
DROP TABLE [Production].[ProductProductPhoto]
GO
PRINT N'Dropping [Production].[ProductDescription]'
GO
IF OBJECT_ID(N'[Production].[ProductDescription]', 'U') IS NOT NULL
DROP TABLE [Production].[ProductDescription]
GO
PRINT N'Dropping [Production].[ProductModelProductDescriptionCulture]'
GO
IF OBJECT_ID(N'[Production].[ProductModelProductDescriptionCulture]', 'U') IS NOT NULL
DROP TABLE [Production].[ProductModelProductDescriptionCulture]
GO
PRINT N'Dropping [Production].[Culture]'
GO
IF OBJECT_ID(N'[Production].[Culture]', 'U') IS NOT NULL
DROP TABLE [Production].[Culture]
GO
PRINT N'Dropping [Production].[ProductModelIllustration]'
GO
IF OBJECT_ID(N'[Production].[ProductModelIllustration]', 'U') IS NOT NULL
DROP TABLE [Production].[ProductModelIllustration]
GO
PRINT N'Dropping [Production].[Illustration]'
GO
IF OBJECT_ID(N'[Production].[Illustration]', 'U') IS NOT NULL
DROP TABLE [Production].[Illustration]
GO
PRINT N'Dropping [Production].[ProductListPriceHistory]'
GO
IF OBJECT_ID(N'[Production].[ProductListPriceHistory]', 'U') IS NOT NULL
DROP TABLE [Production].[ProductListPriceHistory]
GO
PRINT N'Dropping [Production].[ProductInventory]'
GO
IF OBJECT_ID(N'[Production].[ProductInventory]', 'U') IS NOT NULL
DROP TABLE [Production].[ProductInventory]
GO
PRINT N'Dropping [Production].[Location]'
GO
IF OBJECT_ID(N'[Production].[Location]', 'U') IS NOT NULL
DROP TABLE [Production].[Location]
GO
PRINT N'Dropping [Production].[ProductDocument]'
GO
IF OBJECT_ID(N'[Production].[ProductDocument]', 'U') IS NOT NULL
DROP TABLE [Production].[ProductDocument]
GO
PRINT N'Dropping [Production].[ProductCostHistory]'
GO
IF OBJECT_ID(N'[Production].[ProductCostHistory]', 'U') IS NOT NULL
DROP TABLE [Production].[ProductCostHistory]
GO
PRINT N'Dropping [Production].[ProductSubcategory]'
GO
IF OBJECT_ID(N'[Production].[ProductSubcategory]', 'U') IS NOT NULL
DROP TABLE [Production].[ProductSubcategory]
GO
PRINT N'Dropping [Production].[ProductModel]'
GO
IF OBJECT_ID(N'[Production].[ProductModel]', 'U') IS NOT NULL
DROP TABLE [Production].[ProductModel]
GO
PRINT N'Dropping [Person].[PhoneNumberType]'
GO
IF OBJECT_ID(N'[Person].[PhoneNumberType]', 'U') IS NOT NULL
DROP TABLE [Person].[PhoneNumberType]
GO
PRINT N'Dropping [Person].[PersonPhone]'
GO
IF OBJECT_ID(N'[Person].[PersonPhone]', 'U') IS NOT NULL
DROP TABLE [Person].[PersonPhone]
GO
PRINT N'Dropping [Sales].[PersonCreditCard]'
GO
IF OBJECT_ID(N'[Sales].[PersonCreditCard]', 'U') IS NOT NULL
DROP TABLE [Sales].[PersonCreditCard]
GO
PRINT N'Dropping [Sales].[CreditCard]'
GO
IF OBJECT_ID(N'[Sales].[CreditCard]', 'U') IS NOT NULL
DROP TABLE [Sales].[CreditCard]
GO
PRINT N'Dropping [Person].[Password]'
GO
IF OBJECT_ID(N'[Person].[Password]', 'U') IS NOT NULL
DROP TABLE [Person].[Password]
GO
PRINT N'Dropping [HumanResources].[JobCandidate]'
GO
IF OBJECT_ID(N'[HumanResources].[JobCandidate]', 'U') IS NOT NULL
DROP TABLE [HumanResources].[JobCandidate]
GO
PRINT N'Dropping [HumanResources].[EmployeePayHistory]'
GO
IF OBJECT_ID(N'[HumanResources].[EmployeePayHistory]', 'U') IS NOT NULL
DROP TABLE [HumanResources].[EmployeePayHistory]
GO
PRINT N'Dropping [HumanResources].[Shift]'
GO
IF OBJECT_ID(N'[HumanResources].[Shift]', 'U') IS NOT NULL
DROP TABLE [HumanResources].[Shift]
GO
PRINT N'Dropping [HumanResources].[EmployeeDepartmentHistory]'
GO
IF OBJECT_ID(N'[HumanResources].[EmployeeDepartmentHistory]', 'U') IS NOT NULL
DROP TABLE [HumanResources].[EmployeeDepartmentHistory]
GO
PRINT N'Dropping [HumanResources].[Department]'
GO
IF OBJECT_ID(N'[HumanResources].[Department]', 'U') IS NOT NULL
DROP TABLE [HumanResources].[Department]
GO
PRINT N'Dropping [Person].[EmailAddress]'
GO
IF OBJECT_ID(N'[Person].[EmailAddress]', 'U') IS NOT NULL
DROP TABLE [Person].[EmailAddress]
GO
PRINT N'Dropping [Production].[Document]'
GO
IF OBJECT_ID(N'[Production].[Document]', 'U') IS NOT NULL
DROP TABLE [Production].[Document]
GO
PRINT N'Dropping [Sales].[Store]'
GO
IF OBJECT_ID(N'[Sales].[Store]', 'U') IS NOT NULL
DROP TABLE [Sales].[Store]
GO
PRINT N'Dropping [Sales].[CurrencyRate]'
GO
IF OBJECT_ID(N'[Sales].[CurrencyRate]', 'U') IS NOT NULL
DROP TABLE [Sales].[CurrencyRate]
GO
PRINT N'Dropping [Sales].[Currency]'
GO
IF OBJECT_ID(N'[Sales].[Currency]', 'U') IS NOT NULL
DROP TABLE [Sales].[Currency]
GO
PRINT N'Dropping [Sales].[CountryRegionCurrency]'
GO
IF OBJECT_ID(N'[Sales].[CountryRegionCurrency]', 'U') IS NOT NULL
DROP TABLE [Sales].[CountryRegionCurrency]
GO
PRINT N'Dropping [Person].[CountryRegion]'
GO
IF OBJECT_ID(N'[Person].[CountryRegion]', 'U') IS NOT NULL
DROP TABLE [Person].[CountryRegion]
GO
PRINT N'Dropping [Person].[ContactType]'
GO
IF OBJECT_ID(N'[Person].[ContactType]', 'U') IS NOT NULL
DROP TABLE [Person].[ContactType]
GO
PRINT N'Dropping [Person].[BusinessEntityContact]'
GO
IF OBJECT_ID(N'[Person].[BusinessEntityContact]', 'U') IS NOT NULL
DROP TABLE [Person].[BusinessEntityContact]
GO
PRINT N'Dropping [Person].[BusinessEntity]'
GO
IF OBJECT_ID(N'[Person].[BusinessEntity]', 'U') IS NOT NULL
DROP TABLE [Person].[BusinessEntity]
GO
PRINT N'Dropping [Person].[AddressType]'
GO
IF OBJECT_ID(N'[Person].[AddressType]', 'U') IS NOT NULL
DROP TABLE [Person].[AddressType]
GO
PRINT N'Dropping [Person].[BusinessEntityAddress]'
GO
IF OBJECT_ID(N'[Person].[BusinessEntityAddress]', 'U') IS NOT NULL
DROP TABLE [Person].[BusinessEntityAddress]
GO
PRINT N'Dropping [Production].[UnitMeasure]'
GO
IF OBJECT_ID(N'[Production].[UnitMeasure]', 'U') IS NOT NULL
DROP TABLE [Production].[UnitMeasure]
GO
PRINT N'Dropping [Production].[BillOfMaterials]'
GO
IF OBJECT_ID(N'[Production].[BillOfMaterials]', 'U') IS NOT NULL
DROP TABLE [Production].[BillOfMaterials]
GO
PRINT N'Dropping [Production].[Product]'
GO
IF OBJECT_ID(N'[Production].[Product]', 'U') IS NOT NULL
DROP TABLE [Production].[Product]
GO
PRINT N'Dropping [Person].[Address]'
GO
IF OBJECT_ID(N'[Person].[Address]', 'U') IS NOT NULL
DROP TABLE [Person].[Address]
GO
PRINT N'Dropping [Person].[StateProvince]'
GO
IF OBJECT_ID(N'[Person].[StateProvince]', 'U') IS NOT NULL
DROP TABLE [Person].[StateProvince]
GO
PRINT N'Dropping [Production].[WorkOrder]'
GO
IF OBJECT_ID(N'[Production].[WorkOrder]', 'U') IS NOT NULL
DROP TABLE [Production].[WorkOrder]
GO
PRINT N'Dropping [Purchasing].[Vendor]'
GO
IF OBJECT_ID(N'[Purchasing].[Vendor]', 'U') IS NOT NULL
DROP TABLE [Purchasing].[Vendor]
GO
PRINT N'Dropping [Sales].[SalesPerson]'
GO
IF OBJECT_ID(N'[Sales].[SalesPerson]', 'U') IS NOT NULL
DROP TABLE [Sales].[SalesPerson]
GO
PRINT N'Dropping [Sales].[SalesTerritory]'
GO
IF OBJECT_ID(N'[Sales].[SalesTerritory]', 'U') IS NOT NULL
DROP TABLE [Sales].[SalesTerritory]
GO
PRINT N'Dropping [dbo].[ufnGetAccountingEndDate]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufnGetAccountingEndDate]') AND (type = 'IF' OR type = 'FN' OR type = 'TF' OR type = 'FT' OR type = 'FS'))
DROP FUNCTION [dbo].[ufnGetAccountingEndDate]
GO
PRINT N'Dropping [dbo].[ufnGetAccountingStartDate]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufnGetAccountingStartDate]') AND (type = 'IF' OR type = 'FN' OR type = 'TF' OR type = 'FT' OR type = 'FS'))
DROP FUNCTION [dbo].[ufnGetAccountingStartDate]
GO
PRINT N'Dropping [Sales].[Customer]'
GO
IF OBJECT_ID(N'[Sales].[Customer]', 'U') IS NOT NULL
DROP TABLE [Sales].[Customer]
GO
PRINT N'Dropping [dbo].[ufnLeadingZeros]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufnLeadingZeros]') AND (type = 'IF' OR type = 'FN' OR type = 'TF' OR type = 'FT' OR type = 'FS'))
DROP FUNCTION [dbo].[ufnLeadingZeros]
GO
PRINT N'Dropping [Sales].[SalesOrderHeader]'
GO
IF OBJECT_ID(N'[Sales].[SalesOrderHeader]', 'U') IS NOT NULL
DROP TABLE [Sales].[SalesOrderHeader]
GO
PRINT N'Dropping [Sales].[SalesOrderDetail]'
GO
IF OBJECT_ID(N'[Sales].[SalesOrderDetail]', 'U') IS NOT NULL
DROP TABLE [Sales].[SalesOrderDetail]
GO
PRINT N'Dropping [Purchasing].[PurchaseOrderHeader]'
GO
IF OBJECT_ID(N'[Purchasing].[PurchaseOrderHeader]', 'U') IS NOT NULL
DROP TABLE [Purchasing].[PurchaseOrderHeader]
GO
PRINT N'Dropping [Production].[TransactionHistory]'
GO
IF OBJECT_ID(N'[Production].[TransactionHistory]', 'U') IS NOT NULL
DROP TABLE [Production].[TransactionHistory]
GO
PRINT N'Dropping [dbo].[uspLogError]'
GO
IF OBJECT_ID(N'[dbo].[uspLogError]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[uspLogError]
GO
PRINT N'Dropping [dbo].[ErrorLog]'
GO
IF OBJECT_ID(N'[dbo].[ErrorLog]', 'U') IS NOT NULL
DROP TABLE [dbo].[ErrorLog]
GO
PRINT N'Dropping [dbo].[uspPrintError]'
GO
IF OBJECT_ID(N'[dbo].[uspPrintError]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[uspPrintError]
GO
PRINT N'Dropping [Purchasing].[PurchaseOrderDetail]'
GO
IF OBJECT_ID(N'[Purchasing].[PurchaseOrderDetail]', 'U') IS NOT NULL
DROP TABLE [Purchasing].[PurchaseOrderDetail]
GO
PRINT N'Dropping [Person].[Person]'
GO
IF OBJECT_ID(N'[Person].[Person]', 'U') IS NOT NULL
DROP TABLE [Person].[Person]
GO
PRINT N'Dropping [HumanResources].[Employee]'
GO
IF OBJECT_ID(N'[HumanResources].[Employee]', 'U') IS NOT NULL
DROP TABLE [HumanResources].[Employee]
GO
PRINT N'Dropping types'
GO
IF TYPE_ID(N'[dbo].[Flag]') IS NOT NULL
DROP TYPE [dbo].[Flag]
GO
IF TYPE_ID(N'[dbo].[AccountNumber]') IS NOT NULL
DROP TYPE [dbo].[AccountNumber]
GO
IF TYPE_ID(N'[dbo].[NameStyle]') IS NOT NULL
DROP TYPE [dbo].[NameStyle]
GO
IF TYPE_ID(N'[dbo].[Name]') IS NOT NULL
DROP TYPE [dbo].[Name]
GO
IF TYPE_ID(N'[dbo].[OrderNumber]') IS NOT NULL
DROP TYPE [dbo].[OrderNumber]
GO
IF TYPE_ID(N'[dbo].[Phone]') IS NOT NULL
DROP TYPE [dbo].[Phone]
GO
PRINT N'Dropping XML schema collections'
GO
IF EXISTS (SELECT 1 FROM sys.xml_schema_collections WHERE name = N'HRResumeSchemaCollection' AND schema_id = SCHEMA_ID(N'HumanResources'))
DROP XML SCHEMA COLLECTION [HumanResources].[HRResumeSchemaCollection]
GO
IF EXISTS (SELECT 1 FROM sys.xml_schema_collections WHERE name = N'AdditionalContactInfoSchemaCollection' AND schema_id = SCHEMA_ID(N'Person'))
DROP XML SCHEMA COLLECTION [Person].[AdditionalContactInfoSchemaCollection]
GO
IF EXISTS (SELECT 1 FROM sys.xml_schema_collections WHERE name = N'IndividualSurveySchemaCollection' AND schema_id = SCHEMA_ID(N'Person'))
DROP XML SCHEMA COLLECTION [Person].[IndividualSurveySchemaCollection]
GO
IF EXISTS (SELECT 1 FROM sys.xml_schema_collections WHERE name = N'ManuInstructionsSchemaCollection' AND schema_id = SCHEMA_ID(N'Production'))
DROP XML SCHEMA COLLECTION [Production].[ManuInstructionsSchemaCollection]
GO
IF EXISTS (SELECT 1 FROM sys.xml_schema_collections WHERE name = N'ProductDescriptionSchemaCollection' AND schema_id = SCHEMA_ID(N'Production'))
DROP XML SCHEMA COLLECTION [Production].[ProductDescriptionSchemaCollection]
GO
IF EXISTS (SELECT 1 FROM sys.xml_schema_collections WHERE name = N'StoreSurveySchemaCollection' AND schema_id = SCHEMA_ID(N'Sales'))
DROP XML SCHEMA COLLECTION [Sales].[StoreSurveySchemaCollection]
GO
-- ****************************************
-- End of cleanup
-- ****************************************


-- ****************************************
-- Create DDL Trigger for Database
-- ****************************************
PRINT '';
PRINT '*** Creating DDL Trigger for Database';
GO

SET QUOTED_IDENTIFIER ON;
GO

-- Create table to store database object creation messages
-- *** WARNING:  THIS TABLE IS INTENTIONALLY A HEAP - DO NOT ADD A PRIMARY KEY ***
CREATE TABLE [dbo].[DatabaseLog](
    [DatabaseLogID] [int] IDENTITY (1, 1) NOT NULL,
    [PostTime] [datetime] NOT NULL, 
    [DatabaseUser] [sysname] NOT NULL, 
    [Event] [sysname] NOT NULL, 
    [Schema] [sysname] NULL, 
    [Object] [sysname] NULL, 
    [TSQL] [nvarchar](max) NOT NULL, 
    [XmlEvent] [xml] NOT NULL
) ON [PRIMARY];
GO

CREATE TRIGGER [ddlDatabaseTriggerLog] ON DATABASE 
FOR DDL_DATABASE_LEVEL_EVENTS AS 
BEGIN
    SET NOCOUNT ON;

    DECLARE @data XML;
    DECLARE @schema sysname;
    DECLARE @object sysname;
    DECLARE @eventType sysname;

    SET @data = EVENTDATA();
    SET @eventType = @data.value('(/EVENT_INSTANCE/EventType)[1]', 'sysname');
    SET @schema = @data.value('(/EVENT_INSTANCE/SchemaName)[1]', 'sysname');
    SET @object = @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname') 

    IF @object IS NOT NULL
        PRINT '  ' + @eventType + ' - ' + @schema + '.' + @object;
    ELSE
        PRINT '  ' + @eventType + ' - ' + @schema;

    IF @eventType IS NULL
        PRINT CONVERT(nvarchar(max), @data);

    INSERT [dbo].[DatabaseLog] 
        (
        [PostTime], 
        [DatabaseUser], 
        [Event], 
        [Schema], 
        [Object], 
        [TSQL], 
        [XmlEvent]
        ) 
    VALUES 
        (
        GETDATE(), 
        CONVERT(sysname, CURRENT_USER), 
        @eventType, 
        CONVERT(sysname, @schema), 
        CONVERT(sysname, @object), 
        @data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(max)'), 
        @data
        );
END;
GO


-- ****************************************
-- Create Error Log objects
-- ****************************************
PRINT '';
PRINT '*** Creating Error Log objects';
GO

-- Create table to store error information
CREATE TABLE [dbo].[ErrorLog](
    [ErrorLogID] [int] IDENTITY (1, 1) NOT NULL,
    [ErrorTime] [datetime] NOT NULL CONSTRAINT [DF_ErrorLog_ErrorTime] DEFAULT (GETDATE()),
    [UserName] [sysname] NOT NULL, 
    [ErrorNumber] [int] NOT NULL, 
    [ErrorSeverity] [int] NULL, 
    [ErrorState] [int] NULL, 
    [ErrorProcedure] [nvarchar](126) NULL, 
    [ErrorLine] [int] NULL, 
    [ErrorMessage] [nvarchar](4000) NOT NULL
) ON [PRIMARY];
GO

ALTER TABLE [dbo].[ErrorLog] WITH CHECK ADD 
    CONSTRAINT [PK_ErrorLog_ErrorLogID] PRIMARY KEY CLUSTERED 
    (
        [ErrorLogID]
    )  ON [PRIMARY];
GO

-- uspPrintError prints error information about the error that caused 
-- execution to jump to the CATCH block of a TRY...CATCH construct. 
-- Should be executed from within the scope of a CATCH block otherwise 
-- it will return without printing any error information.
CREATE PROCEDURE [dbo].[uspPrintError] 
AS
BEGIN
    SET NOCOUNT ON;

    -- Print error information. 
    PRINT 'Error ' + CONVERT(varchar(50), ERROR_NUMBER()) +
          ', Severity ' + CONVERT(varchar(5), ERROR_SEVERITY()) +
          ', State ' + CONVERT(varchar(5), ERROR_STATE()) + 
          ', Procedure ' + ISNULL(ERROR_PROCEDURE(), '-') + 
          ', Line ' + CONVERT(varchar(5), ERROR_LINE());
    PRINT ERROR_MESSAGE();
END;
GO

-- uspLogError logs error information in the ErrorLog table about the 
-- error that caused execution to jump to the CATCH block of a 
-- TRY...CATCH construct. This should be executed from within the scope 
-- of a CATCH block otherwise it will return without inserting error 
-- information. 
CREATE PROCEDURE [dbo].[uspLogError] 
    @ErrorLogID [int] = 0 OUTPUT -- contains the ErrorLogID of the row inserted
AS                               -- by uspLogError in the ErrorLog table
BEGIN
    SET NOCOUNT ON;

    -- Output parameter value of 0 indicates that error 
    -- information was not logged
    SET @ErrorLogID = 0;

    BEGIN TRY
        -- Return if there is no error information to log
        IF ERROR_NUMBER() IS NULL
            RETURN;

        -- Return if inside an uncommittable transaction.
        -- Data insertion/modification is not allowed when 
        -- a transaction is in an uncommittable state.
        IF XACT_STATE() = -1
        BEGIN
            PRINT 'Cannot log error since the current transaction is in an uncommittable state. ' 
                + 'Rollback the transaction before executing uspLogError in order to successfully log error information.';
            RETURN;
        END

        INSERT [dbo].[ErrorLog] 
            (
            [UserName], 
            [ErrorNumber], 
            [ErrorSeverity], 
            [ErrorState], 
            [ErrorProcedure], 
            [ErrorLine], 
            [ErrorMessage]
            ) 
        VALUES 
            (
            CONVERT(sysname, CURRENT_USER), 
            ERROR_NUMBER(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            ERROR_MESSAGE()
            );

        -- Pass back the ErrorLogID of the row inserted
        SET @ErrorLogID = @@IDENTITY;
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred in stored procedure uspLogError: ';
        EXECUTE [dbo].[uspPrintError];
        RETURN -1;
    END CATCH
END;
GO


-- ****************************************
-- Create Data Types
-- ****************************************
PRINT '';
PRINT '*** Creating Data Types';
GO

CREATE TYPE [AccountNumber] FROM nvarchar(15) NULL;
CREATE TYPE [Flag] FROM bit NOT NULL;
CREATE TYPE [NameStyle] FROM bit NOT NULL;
CREATE TYPE [Name] FROM nvarchar(50) NULL;
CREATE TYPE [OrderNumber] FROM nvarchar(25) NULL;
CREATE TYPE [Phone] FROM nvarchar(25) NULL;
GO


-- ******************************************************
-- Add pre-table database functions.
-- ******************************************************
PRINT '';
PRINT '*** Creating Pre-Table Database Functions';
GO

CREATE FUNCTION [dbo].[ufnLeadingZeros](
    @Value int
) 
RETURNS varchar(8) 
WITH SCHEMABINDING 
AS 
BEGIN
    DECLARE @ReturnValue varchar(8);

    SET @ReturnValue = CONVERT(varchar(8), @Value);
    SET @ReturnValue = REPLICATE('0', 8 - DATALENGTH(@ReturnValue)) + @ReturnValue;

    RETURN (@ReturnValue);
END;
GO


-- ******************************************************
-- Create database schemas
-- ******************************************************
PRINT '';
PRINT '*** Creating Database Schemas';
GO
/*
CREATE SCHEMA [HumanResources] AUTHORIZATION [dbo];
GO

CREATE SCHEMA [Person] AUTHORIZATION [dbo];
GO

CREATE SCHEMA [Production] AUTHORIZATION [dbo];
GO

CREATE SCHEMA [Purchasing] AUTHORIZATION [dbo];
GO

CREATE SCHEMA [Sales] AUTHORIZATION [dbo];
GO
*/

-- ****************************************
-- Create XML schemas
-- ****************************************
PRINT '';
PRINT '*** Creating XML Schemas';
GO

-- Create AdditionalContactInfo schema
PRINT '';
PRINT 'Create AdditionalContactInfo schema';
GO

CREATE XML SCHEMA COLLECTION [Person].[AdditionalContactInfoSchemaCollection] AS 
'<?xml version="1.0" encoding="UTF-8"?>
<xsd:schema targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo" 
    xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo" 
    elementFormDefault="qualified"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" >
    <!-- the following imports are not needed. They simply provide readability -->

    <xsd:import 
        namespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord" />

    <xsd:import 
        namespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes" />

    <xsd:element name="AdditionalContactInfo" >
        <xsd:complexType mixed="true" >
            <xsd:sequence>
                <xsd:any processContents="strict" 
                    namespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord 
                        http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"
                        minOccurs="0" maxOccurs="unbounded" />
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
</xsd:schema>';
GO

ALTER XML SCHEMA COLLECTION [Person].[AdditionalContactInfoSchemaCollection] ADD 
'<?xml version="1.0" encoding="UTF-8"?>
<xsd:schema targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord"
    elementFormDefault="qualified"
    xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" >

    <xsd:element name="ContactRecord" >
        <xsd:complexType mixed="true" >
            <xsd:choice minOccurs="0" maxOccurs="unbounded" >
                <xsd:any processContents="strict"  
                    namespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes" />
            </xsd:choice>
            <xsd:attribute name="date" type="xsd:date" />
        </xsd:complexType>
    </xsd:element>
</xsd:schema>';
GO

ALTER XML SCHEMA COLLECTION [Person].[AdditionalContactInfoSchemaCollection] ADD 
'<?xml version="1.0" encoding="UTF-8"?>
<xsd:schema targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"
    xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes" 
    elementFormDefault="qualified"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" >

    <xsd:complexType name="specialInstructionsType" mixed="true">
        <xsd:sequence>
            <xsd:any processContents="strict" 
                namespace = "##targetNamespace"
                minOccurs="0" maxOccurs="unbounded" />
        </xsd:sequence>
    </xsd:complexType>

    <xsd:complexType name="phoneNumberType">
        <xsd:sequence>
            <xsd:element name="number" >
                <xsd:simpleType>
                    <xsd:restriction base="xsd:string">
                        <xsd:pattern value="[0-9\(\)\-]*"/>
                    </xsd:restriction>
                </xsd:simpleType>
            </xsd:element>
            <xsd:element name="SpecialInstructions" minOccurs="0" type="specialInstructionsType" />
        </xsd:sequence>
    </xsd:complexType>

    <xsd:complexType name="eMailType">
        <xsd:sequence>
            <xsd:element name="eMailAddress" type="xsd:string" />
            <xsd:element name="SpecialInstructions" minOccurs="0" type="specialInstructionsType" />
        </xsd:sequence>
    </xsd:complexType>

    <xsd:complexType name="addressType">
        <xsd:sequence>
            <xsd:element name="Street" type="xsd:string" minOccurs="1" maxOccurs="2" />
            <xsd:element name="City" type="xsd:string" minOccurs="1" maxOccurs="1" />
            <xsd:element name="StateProvince" type="xsd:string" minOccurs="1" maxOccurs="1" />
            <xsd:element name="PostalCode" type="xsd:string" minOccurs="0" maxOccurs="1" />
            <xsd:element name="CountryRegion" type="xsd:string" minOccurs="1" maxOccurs="1" />
            <xsd:element name="SpecialInstructions" type="specialInstructionsType" minOccurs="0"/>
        </xsd:sequence>
    </xsd:complexType>

    <xsd:element name="telephoneNumber"            type="phoneNumberType" />
    <xsd:element name="mobile"                     type="phoneNumberType" />
    <xsd:element name="pager"                      type="phoneNumberType" />
    <xsd:element name="facsimileTelephoneNumber"   type="phoneNumberType" />
    <xsd:element name="telexNumber"                type="phoneNumberType" />
    <xsd:element name="internationaliSDNNumber"    type="phoneNumberType" />
    <xsd:element name="eMail"                      type="eMailType" />
    <xsd:element name="homePostalAddress"          type="addressType" />
    <xsd:element name="physicalDeliveryOfficeName" type="addressType" />
    <xsd:element name="registeredAddress"          type="addressType" /> 
</xsd:schema>';
GO

-- Create Individual survey schema.
PRINT '';
PRINT 'Create Individual survey schema';
GO

CREATE XML SCHEMA COLLECTION [Person].[IndividualSurveySchemaCollection] AS 
'<?xml version="1.0" encoding="UTF-8"?>
<xsd:schema targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey" 
    xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"
    elementFormDefault="qualified"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" >

    <xsd:simpleType name="SalaryType">
        <xsd:restriction base="xsd:string">
            <xsd:enumeration value="0-25000" />
            <xsd:enumeration value="25001-50000" />
            <xsd:enumeration value="50001-75000" />
            <xsd:enumeration value="75001-100000" />
            <xsd:enumeration value="greater than 100000" />
        </xsd:restriction>
    </xsd:simpleType>

    <xsd:simpleType name="MileRangeType">
        <xsd:restriction base="xsd:string">
            <xsd:enumeration value="0-1 Miles" />
            <xsd:enumeration value="1-2 Miles" />
            <xsd:enumeration value="2-5 Miles" />
            <xsd:enumeration value="5-10 Miles" />
            <xsd:enumeration value="10+ Miles" />
        </xsd:restriction>
    </xsd:simpleType>

    <xsd:element name="IndividualSurvey">
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element name="TotalPurchaseYTD" type="xsd:decimal" minOccurs="0" maxOccurs="1" />
                <xsd:element name="DateFirstPurchase" type="xsd:date" minOccurs="0" maxOccurs="1" />
                <xsd:element name="BirthDate" type="xsd:date" minOccurs="0" maxOccurs="1" />
                <xsd:element name="MaritalStatus" type="xsd:string" minOccurs="0" maxOccurs="1" />
                <xsd:element name="YearlyIncome" type="SalaryType" minOccurs="0" maxOccurs="1" />
                <xsd:element name="Gender" type="xsd:string" minOccurs="0" maxOccurs="1" />
                <xsd:element name="TotalChildren" type="xsd:int" minOccurs="0" maxOccurs="1" />
                <xsd:element name="NumberChildrenAtHome" type="xsd:int" minOccurs="0" maxOccurs="1" />
                <xsd:element name="Education" type="xsd:string" minOccurs="0" maxOccurs="1" />
                <xsd:element name="Occupation" type="xsd:string" minOccurs="0" maxOccurs="1" />
                <xsd:element name="HomeOwnerFlag" type="xsd:string" minOccurs="0" maxOccurs="1" />
                <xsd:element name="NumberCarsOwned" type="xsd:int" minOccurs="0" maxOccurs="1" />
                <xsd:element name="Hobby" type="xsd:string" minOccurs="0" maxOccurs="unbounded" />
                <xsd:element name="CommuteDistance" type="MileRangeType" minOccurs="0" maxOccurs="1" />
                <xsd:element name="Comments" type="xsd:string" minOccurs="0" maxOccurs="1" />
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
</xsd:schema>';
GO

-- Create resume schema.
PRINT '';
PRINT 'Create Resume schema';
GO

CREATE XML SCHEMA COLLECTION [HumanResources].[HRResumeSchemaCollection] AS 
'<?xml version="1.0" encoding="UTF-8"?>
<xsd:schema targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume" 
    xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume" 
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
    elementFormDefault="qualified" >

    <xsd:element name="Resume" type="ResumeType"/>
    <xsd:element name="Address" type="AddressType"/>
    <xsd:element name="Education" type="EducationType"/>
    <xsd:element name="Employment" type="EmploymentType"/>
    <xsd:element name="Location" type="LocationType"/>
    <xsd:element name="Name" type="NameType"/>
    <xsd:element name="Telephone" type="TelephoneType"/>

    <xsd:complexType name="ResumeType">
        <xsd:sequence>
            <xsd:element ref="Name"/>
            <xsd:element name="Skills" type="xsd:string" minOccurs="0"/>
            <xsd:element ref="Employment" maxOccurs="unbounded"/>
            <xsd:element ref="Education" maxOccurs="unbounded"/>
            <xsd:element ref="Address" maxOccurs="unbounded"/>
            <xsd:element ref="Telephone" minOccurs="0"/>
            <xsd:element name="EMail" type="xsd:string" minOccurs="0"/>
            <xsd:element name="WebSite" type="xsd:string" minOccurs="0"/>
        </xsd:sequence>
    </xsd:complexType>

    <xsd:complexType name="AddressType">
        <xsd:sequence>
            <xsd:element name="Addr.Type" type="xsd:string">
                <xsd:annotation>
                    <xsd:documentation>Home|Work|Permanent</xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsd:element name="Addr.OrgName" type="xsd:string" minOccurs="0"/>
            <xsd:element name="Addr.Street" type="xsd:string" maxOccurs="unbounded"/>
            <xsd:element name="Addr.Location">
                <xsd:complexType>
                    <xsd:sequence>
                        <xsd:element ref="Location"/>
                    </xsd:sequence>
                </xsd:complexType>
            </xsd:element>
            <xsd:element name="Addr.PostalCode" type="xsd:string"/>
            <xsd:element name="Addr.Telephone" minOccurs="0">
                <xsd:complexType>
                    <xsd:sequence>
                        <xsd:element ref="Telephone" maxOccurs="unbounded"/>
                    </xsd:sequence>
                </xsd:complexType>
            </xsd:element>
        </xsd:sequence>
    </xsd:complexType>

    <xsd:complexType name="EducationType">
        <xsd:sequence>
            <xsd:element name="Edu.Level" type="xsd:string">
                <xsd:annotation>
                    <xsd:documentation>High School|Associate|Bachelor|Master|Doctorate</xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsd:element name="Edu.StartDate" type="xsd:date"/>
            <xsd:element name="Edu.EndDate" type="xsd:date"/>
            <xsd:element name="Edu.Degree" type="xsd:string" minOccurs="0"/>
            <xsd:element name="Edu.Major" type="xsd:string" minOccurs="0"/>
            <xsd:element name="Edu.Minor" type="xsd:string" minOccurs="0"/>
            <xsd:element name="Edu.GPA" type="xsd:string" minOccurs="0"/>
            <xsd:element name="Edu.GPAAlternate" type="xsd:decimal" minOccurs="0">
                <xsd:annotation>
                    <xsd:documentation>In case the institution does not follow a GPA system</xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsd:element name="Edu.GPAScale" type="xsd:decimal" minOccurs="0"/>
            <xsd:element name="Edu.School" type="xsd:string" minOccurs="0"/>
            <xsd:element name="Edu.Location" minOccurs="0">
                <xsd:complexType>
                    <xsd:sequence>
                        <xsd:element ref="Location"/>
                    </xsd:sequence>
                </xsd:complexType>
            </xsd:element>
        </xsd:sequence>
    </xsd:complexType>

    <xsd:complexType name="EmploymentType">
        <xsd:sequence>
            <xsd:element name="Emp.StartDate" type="xsd:date" minOccurs="0"/>
            <xsd:element name="Emp.EndDate" type="xsd:date" minOccurs="0"/>
            <xsd:element name="Emp.OrgName" type="xsd:string"/>
            <xsd:element name="Emp.JobTitle" type="xsd:string"/>
            <xsd:element name="Emp.Responsibility" type="xsd:string"/>
            <xsd:element name="Emp.FunctionCategory" type="xsd:string" minOccurs="0"/>
            <xsd:element name="Emp.IndustryCategory" type="xsd:string" minOccurs="0"/>
            <xsd:element name="Emp.Location" minOccurs="0">
                <xsd:complexType>
                    <xsd:sequence>
                        <xsd:element ref="Location"/>
                    </xsd:sequence>
                </xsd:complexType>
            </xsd:element>
        </xsd:sequence>
    </xsd:complexType>

    <xsd:complexType name="LocationType">
        <xsd:sequence>
            <xsd:element name="Loc.CountryRegion" type="xsd:string">
                <xsd:annotation>
                    <xsd:documentation>ISO 3166 Country Code</xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsd:element name="Loc.State" type="xsd:string" minOccurs="0"/>
            <xsd:element name="Loc.City" type="xsd:string" minOccurs="0"/>
        </xsd:sequence>
    </xsd:complexType>

    <xsd:complexType name="NameType">
        <xsd:sequence>
            <xsd:element name="Name.Prefix" type="xsd:string" minOccurs="0"/>
            <xsd:element name="Name.First" type="xsd:string"/>
            <xsd:element name="Name.Middle" type="xsd:string" minOccurs="0"/>
            <xsd:element name="Name.Last" type="xsd:string"/>
            <xsd:element name="Name.Suffix" type="xsd:string" minOccurs="0"/>
        </xsd:sequence>
    </xsd:complexType>

    <xsd:complexType name="TelephoneType">
        <xsd:sequence>
            <xsd:element name="Tel.Type" minOccurs="0">
                <xsd:annotation>
                    <xsd:documentation>Voice|Fax|Pager</xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsd:element name="Tel.IntlCode" type="xsd:int" minOccurs="0"/>
            <xsd:element name="Tel.AreaCode" type="xsd:int" minOccurs="0"/>
            <xsd:element name="Tel.Number" type="xsd:string"/>
            <xsd:element name="Tel.Extension" type="xsd:int" minOccurs="0"/>
        </xsd:sequence>
    </xsd:complexType>
</xsd:schema>';
GO

-- Create Product catalog description schema.
PRINT '';
PRINT 'Create Product catalog description schema';
GO

CREATE XML SCHEMA COLLECTION [Production].[ProductDescriptionSchemaCollection] AS 
'<xsd:schema targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain"
    xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain" 
    elementFormDefault="qualified" 
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" >
  
    <xsd:element name="Warranty"  >
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element name="WarrantyPeriod" type="xsd:string"  />
                <xsd:element name="Description" type="xsd:string"  />
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>

    <xsd:element name="Maintenance"  >
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element name="NoOfYears" type="xsd:string"  />
                <xsd:element name="Description" type="xsd:string"  />
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
</xsd:schema>';

ALTER XML SCHEMA COLLECTION [Production].[ProductDescriptionSchemaCollection] ADD 
'<?xml version="1.0" encoding="UTF-8"?>
<xs:schema targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription" 
    xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription" 
    elementFormDefault="qualified" 
    xmlns:mstns="http://tempuri.org/XMLSchema.xsd" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain" >

    <xs:import 
        namespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain" />

    <xs:element name="ProductDescription" type="ProductDescription" />
        <xs:complexType name="ProductDescription">
            <xs:annotation>
                <xs:documentation>Product description has a summary blurb, if its manufactured elsewhere it 
                includes a link to the manufacturers site for this component.
                Then it has optional zero or more sequences of features, pictures, categories
                and technical specifications.
                </xs:documentation>
            </xs:annotation>
            <xs:sequence>
                <xs:element name="Summary" type="Summary" minOccurs="0" />
                <xs:element name="Manufacturer" type="Manufacturer" minOccurs="0" />
                <xs:element name="Features" type="Features" minOccurs="0" maxOccurs="unbounded" />
                <xs:element name="Picture" type="Picture" minOccurs="0" maxOccurs="unbounded" />
                <xs:element name="Category" type="Category" minOccurs="0" maxOccurs="unbounded" />
                <xs:element name="Specifications" type="Specifications" minOccurs="0" maxOccurs="unbounded" />
            </xs:sequence>
            <xs:attribute name="ProductModelID" type="xs:string" />
            <xs:attribute name="ProductModelName" type="xs:string" />
        </xs:complexType>
  
        <xs:complexType name="Summary" mixed="true" >
            <xs:sequence>
                <xs:any processContents="skip" namespace="http://www.w3.org/1999/xhtml" minOccurs="0" maxOccurs="unbounded" />
            </xs:sequence>
        </xs:complexType>
        
        <xs:complexType name="Manufacturer">
            <xs:sequence>
                <xs:element name="Name" type="xs:string" minOccurs="0" />
                <xs:element name="CopyrightURL" type="xs:string" minOccurs="0" />
                <xs:element name="Copyright" type="xs:string" minOccurs="0" />
                <xs:element name="ProductURL" type="xs:string" minOccurs="0" />
            </xs:sequence>
        </xs:complexType>
  
        <xs:complexType name="Picture">
            <xs:annotation>
                <xs:documentation>Pictures of the component, some standard sizes are "Large" for zoom in, "Small" for a normal web page and "Thumbnail" for product listing pages.</xs:documentation>
            </xs:annotation>
            <xs:sequence>
                <xs:element name="Name" type="xs:string" minOccurs="0" />
                <xs:element name="Angle" type="xs:string" minOccurs="0" />
                <xs:element name="Size" type="xs:string" minOccurs="0" />
                <xs:element name="ProductPhotoID" type="xs:integer" minOccurs="0" />
            </xs:sequence>
        </xs:complexType>

        <xs:annotation>
            <xs:documentation>Features of the component that are more "sales" oriented.</xs:documentation>
        </xs:annotation>

        <xs:complexType name="Features" mixed="true"  >
            <xs:sequence>
                <xs:element ref="wm:Warranty"  />
                <xs:element ref="wm:Maintenance"  />
                <xs:any processContents="skip"  namespace="##other" minOccurs="0" maxOccurs="unbounded" />
            </xs:sequence>
        </xs:complexType>

        <xs:complexType name="Specifications" mixed="true">
            <xs:annotation>
                <xs:documentation>A single technical aspect of the component.</xs:documentation>
            </xs:annotation>
            <xs:sequence>
                <xs:any processContents="skip" minOccurs="0" maxOccurs="unbounded" />
            </xs:sequence>
        </xs:complexType>

        <xs:complexType name="Category">
            <xs:annotation>
                <xs:documentation>A single categorization element that designates a classification taxonomy and a code within that classification type.  Optional description for default display if needed.</xs:documentation>
            </xs:annotation>
            <xs:sequence>
                <xs:element ref="Taxonomy" />
                <xs:element ref="Code" />
                <xs:element ref="Description" minOccurs="0" />
            </xs:sequence>
        </xs:complexType>

    <xs:element name="Taxonomy" type="xs:string" />
    <xs:element name="Code" type="xs:string" />
    <xs:element name="Description" type="xs:string" />
</xs:schema>';
GO

-- Create Manufacturing instructions schema.
PRINT '';
PRINT 'Create Manufacturing instructions schema';
GO

CREATE XML SCHEMA COLLECTION [Production].[ManuInstructionsSchemaCollection] AS 
'<?xml version="1.0" encoding="UTF-8"?>
<xsd:schema targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions" 
    xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions" 
    elementFormDefault="qualified" attributeFormDefault="unqualified"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" >

    <xsd:annotation>
        <xsd:documentation>
            SetupHour   is the time it takes to set up the machine.
            MachineHour is the time the machine is busy manufcturing
            LaborHour   is the labor hours in the manu process
            LotSize     is the minimum quanity manufactured. For example,
                    no. of frames cut from the sheet metal
        </xsd:documentation>
    </xsd:annotation>

    <xsd:complexType name="StepType" mixed="true" >
        <xsd:choice  minOccurs="0" maxOccurs="unbounded" > 
            <xsd:element name="tool" type="xsd:string" />
            <xsd:element name="material" type="xsd:string" />
            <xsd:element name="blueprint" type="xsd:string" />
            <xsd:element name="specs" type="xsd:string" />
            <xsd:element name="diag" type="xsd:string" />
        </xsd:choice> 
    </xsd:complexType>

    <xsd:element  name="root">
        <xsd:complexType mixed="true">
            <xsd:sequence>
                <xsd:element name="Location" minOccurs="1" maxOccurs="unbounded">
                    <xsd:complexType mixed="true">
                        <xsd:sequence>
                            <xsd:element name="step" type="StepType" minOccurs="1" maxOccurs="unbounded" />
                        </xsd:sequence>
                        <xsd:attribute name="LocationID" type="xsd:integer" use="required"/>
                        <xsd:attribute name="SetupHours" type="xsd:decimal" use="optional"/>
                        <xsd:attribute name="MachineHours" type="xsd:decimal" use="optional"/>
                        <xsd:attribute name="LaborHours" type="xsd:decimal" use="optional"/>
                        <xsd:attribute name="LotSize" type="xsd:decimal" use="optional"/>
                    </xsd:complexType>
                </xsd:element>
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
</xsd:schema>';
GO

-- Create Store survey schema.
PRINT '';
PRINT 'Create Store survey schema';
GO

CREATE XML SCHEMA COLLECTION [Sales].[StoreSurveySchemaCollection] AS 
'<?xml version="1.0" encoding="UTF-8"?>
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey" 
    xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey" 
    elementFormDefault="qualified" attributeFormDefault="unqualified">

    <!-- BM=Bicycle manu BS=bicyle store OS=online store SGS=sporting goods store D=Discount Store -->
    <xsd:simpleType name="BusinessType">
        <xsd:restriction base="xsd:string">
            <xsd:enumeration value="BM" />
            <xsd:enumeration value="BS" />
            <xsd:enumeration value="D" />
            <xsd:enumeration value="OS" />
            <xsd:enumeration value="SGS" />
        </xsd:restriction>
    </xsd:simpleType>

    <!-- BMX=BMX Racing -->
    <xsd:simpleType name="SpecialtyType">
        <xsd:restriction base="xsd:string">
            <xsd:enumeration value="Family" />
            <xsd:enumeration value="Kids" />
            <xsd:enumeration value="BMX" />
            <xsd:enumeration value="Touring" />
            <xsd:enumeration value="Road" />
            <xsd:enumeration value="Mountain" />
            <xsd:enumeration value="All" />
        </xsd:restriction>
    </xsd:simpleType>

    <!-- AW=AdventureWorks only 2= AdvWorks+1 other brand other brand -->
    <xsd:simpleType name="BrandType">
        <xsd:restriction base="xsd:string">
            <xsd:enumeration value="AW" />
            <xsd:enumeration value="2" />
            <xsd:enumeration value="3" />
            <xsd:enumeration value="4+" />
        </xsd:restriction>
    </xsd:simpleType>

    <xsd:simpleType name="InternetType">
        <xsd:restriction base="xsd:string">
            <xsd:enumeration value="56kb" />
            <xsd:enumeration value="ISDN" />
            <xsd:enumeration value="DSL" />
            <xsd:enumeration value="T1" />
            <xsd:enumeration value="T2" />
            <xsd:enumeration value="T3" />
        </xsd:restriction>
    </xsd:simpleType>

    <xsd:element name="StoreSurvey">
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element name="ContactName" type="xsd:string" minOccurs="0" maxOccurs="1" />
                <xsd:element name="JobTitle" type="xsd:string" minOccurs="0" maxOccurs="1" />
                <xsd:element name="AnnualSales" type="xsd:decimal" minOccurs="0" maxOccurs="1" />
                <xsd:element name="AnnualRevenue" type="xsd:decimal" minOccurs="0" maxOccurs="1" />
                <xsd:element name="BankName" type="xsd:string" minOccurs="0" maxOccurs="1" />
                <xsd:element name="BusinessType" type="BusinessType" minOccurs="0" maxOccurs="1" />
                <xsd:element name="YearOpened" type="xsd:gYear" minOccurs="0" maxOccurs="1" />
                <xsd:element name="Specialty" type="SpecialtyType" minOccurs="0" maxOccurs="1" />
                <xsd:element name="SquareFeet" type="xsd:float" minOccurs="0" maxOccurs="1" />
                <xsd:element name="Brands" type="BrandType" minOccurs="0" maxOccurs="1" />
                <xsd:element name="Internet" type="InternetType" minOccurs="0" maxOccurs="1" />
                <xsd:element name="NumberEmployees" type="xsd:int" minOccurs="0" maxOccurs="1" />
                <xsd:element name="Comments" type="xsd:string" minOccurs="0" maxOccurs="1" />
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
</xsd:schema>';
GO


-- ******************************************************
-- Create tables
-- ******************************************************
PRINT '';
PRINT '*** Creating Tables';
GO

CREATE TABLE [Person].[Address](
    [AddressID] [int] IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AddressLine1] [nvarchar](60) NOT NULL, 
    [AddressLine2] [nvarchar](60) NULL, 
    [City] [nvarchar](30) NOT NULL, 
    [StateProvinceID] [int] NOT NULL,
    [PostalCode] [nvarchar](15) NOT NULL, 
	[SpatialLocation] [geography] NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_Address_rowguid] DEFAULT (NEWID()),
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Address_ModifiedDate] DEFAULT (GETDATE())
) ON [PRIMARY];
GO

CREATE TABLE [Person].[AddressType](
    [AddressTypeID] [int] IDENTITY (1, 1) NOT NULL,
    [Name] [Name] NOT NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_AddressType_rowguid] DEFAULT (NEWID()),
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_AddressType_ModifiedDate] DEFAULT (GETDATE())
) ON [PRIMARY];
GO

CREATE TABLE [dbo].[AWBuildVersion](
    [SystemInformationID] [tinyint] IDENTITY (1, 1) NOT NULL,
    [Database Version] [nvarchar](25) NOT NULL, 
    [VersionDate] [datetime] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_AWBuildVersion_ModifiedDate] DEFAULT (GETDATE())
) ON [PRIMARY];
GO

CREATE TABLE [Production].[BillOfMaterials](
    [BillOfMaterialsID] [int] IDENTITY (1, 1) NOT NULL,
    [ProductAssemblyID] [int] NULL,
    [ComponentID] [int] NOT NULL,
    [StartDate] [datetime] NOT NULL CONSTRAINT [DF_BillOfMaterials_StartDate] DEFAULT (GETDATE()),
    [EndDate] [datetime] NULL,
    [UnitMeasureCode] [nchar](3) NOT NULL, 
    [BOMLevel] [smallint] NOT NULL,
    [PerAssemblyQty] [decimal](8, 2) NOT NULL CONSTRAINT [DF_BillOfMaterials_PerAssemblyQty] DEFAULT (1.00),
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_BillOfMaterials_ModifiedDate] DEFAULT (GETDATE()),
    CONSTRAINT [CK_BillOfMaterials_EndDate] CHECK (([EndDate] > [StartDate]) OR ([EndDate] IS NULL)),
    CONSTRAINT [CK_BillOfMaterials_ProductAssemblyID] CHECK ([ProductAssemblyID] <> [ComponentID]),
    CONSTRAINT [CK_BillOfMaterials_BOMLevel] CHECK ((([ProductAssemblyID] IS NULL) 
        AND ([BOMLevel] = 0) AND ([PerAssemblyQty] = 1.00)) 
        OR (([ProductAssemblyID] IS NOT NULL) AND ([BOMLevel] >= 1))), 
    CONSTRAINT [CK_BillOfMaterials_PerAssemblyQty] CHECK ([PerAssemblyQty] >= 1.00) 
) ON [PRIMARY];
GO

CREATE TABLE [Person].[BusinessEntity](
	[BusinessEntityID] [int] IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_BusinessEntity_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_BusinessEntity_ModifiedDate] DEFAULT (GETDATE())	
) ON [PRIMARY];
GO

CREATE TABLE [Person].[BusinessEntityAddress](
	[BusinessEntityID] [int] NOT NULL,
    [AddressID] [int] NOT NULL,
    [AddressTypeID] [int] NOT NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_BusinessEntityAddress_rowguid] DEFAULT (NEWID()),
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_BusinessEntityAddress_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];

CREATE TABLE [Person].[BusinessEntityContact](
	[BusinessEntityID] [int] NOT NULL,
    [PersonID] [int] NOT NULL,
    [ContactTypeID] [int] NOT NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_BusinessEntityContact_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_BusinessEntityContact_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Person].[ContactType](
    [ContactTypeID] [int] IDENTITY (1, 1) NOT NULL,
    [Name] [Name] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ContactType_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[CountryRegionCurrency](
    [CountryRegionCode] [nvarchar](3) NOT NULL, 
    [CurrencyCode] [nchar](3) NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_CountryRegionCurrency_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Person].[CountryRegion](
    [CountryRegionCode] [nvarchar](3) NOT NULL, 
    [Name] [Name] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_CountryRegion_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[CreditCard](
    [CreditCardID] [int] IDENTITY (1, 1) NOT NULL,
    [CardType] [nvarchar](50) NOT NULL,
    [CardNumber] [nvarchar](25) NOT NULL,
    [ExpMonth] [tinyint] NOT NULL,
    [ExpYear] [smallint] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_CreditCard_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Production].[Culture](
    [CultureID] [nchar](6) NOT NULL,
    [Name] [Name] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Culture_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[Currency](
    [CurrencyCode] [nchar](3) NOT NULL, 
    [Name] [Name] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Currency_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[CurrencyRate](
    [CurrencyRateID] [int] IDENTITY (1, 1) NOT NULL,
    [CurrencyRateDate] [datetime] NOT NULL,    
    [FromCurrencyCode] [nchar](3) NOT NULL, 
    [ToCurrencyCode] [nchar](3) NOT NULL, 
    [AverageRate] [money] NOT NULL,
    [EndOfDayRate] [money] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_CurrencyRate_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[Customer](
	[CustomerID] [int] IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
	-- A customer may either be a person, a store, or a person who works for a store
	[PersonID] [int] NULL, -- If this customer represents a person, this is non-null
    [StoreID] [int] NULL,  -- If the customer is a store, or is associated with a store then this is non-null.
    [TerritoryID] [int] NULL,
    [AccountNumber] AS ISNULL('AW' + [dbo].[ufnLeadingZeros](CustomerID), ''),
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_Customer_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Customer_ModifiedDate] DEFAULT (GETDATE())
) ON [PRIMARY];
GO

CREATE TABLE [HumanResources].[Department](
    [DepartmentID] [smallint] IDENTITY (1, 1) NOT NULL,
    [Name] [Name] NOT NULL,
    [GroupName] [Name] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Department_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Production].[Document](
    [DocumentNode] [hierarchyid] NOT NULL,
	[DocumentLevel] AS DocumentNode.GetLevel(),
    [Title] [nvarchar](50) NOT NULL, 
	[Owner] [int] NOT NULL,
	[FolderFlag] [bit] NOT NULL CONSTRAINT [DF_Document_FolderFlag] DEFAULT (0),
    [FileName] [nvarchar](400) NOT NULL, 
    [FileExtension] nvarchar(8) NOT NULL,
    [Revision] [nchar](5) NOT NULL, 
    [ChangeNumber] [int] NOT NULL CONSTRAINT [DF_Document_ChangeNumber] DEFAULT (0),
    [Status] [tinyint] NOT NULL,
    [DocumentSummary] [nvarchar](max) NULL,
    [Document] [varbinary](max)  NULL,  
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL UNIQUE CONSTRAINT [DF_Document_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Document_ModifiedDate] DEFAULT (GETDATE()),
    CONSTRAINT [CK_Document_Status] CHECK ([Status] BETWEEN 1 AND 3)
) ON [PRIMARY];
GO

CREATE TABLE [Person].[EmailAddress](
	[BusinessEntityID] [int] NOT NULL,
	[EmailAddressID] [int] IDENTITY (1, 1) NOT NULL,
    [EmailAddress] [nvarchar](50) NULL, 
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_EmailAddress_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_EmailAddress_ModifiedDate] DEFAULT (GETDATE())
) ON [PRIMARY];
GO
CREATE TABLE [HumanResources].[Employee](
    [BusinessEntityID] [int] NOT NULL,
    [NationalIDNumber] [nvarchar](15) NOT NULL, 
    [LoginID] [nvarchar](256) NOT NULL,     
    [OrganizationNode] [hierarchyid] NULL,
	[OrganizationLevel] AS OrganizationNode.GetLevel(),
    [JobTitle] [nvarchar](50) NOT NULL, 
    [BirthDate] [date] NOT NULL,
    [MaritalStatus] [nchar](1) NOT NULL, 
    [Gender] [nchar](1) NOT NULL, 
    [HireDate] [date] NOT NULL,
    [SalariedFlag] [Flag] NOT NULL CONSTRAINT [DF_Employee_SalariedFlag] DEFAULT (1),
    [VacationHours] [smallint] NOT NULL CONSTRAINT [DF_Employee_VacationHours] DEFAULT (0),
    [SickLeaveHours] [smallint] NOT NULL CONSTRAINT [DF_Employee_SickLeaveHours] DEFAULT (0),
    [CurrentFlag] [Flag] NOT NULL CONSTRAINT [DF_Employee_CurrentFlag] DEFAULT (1),
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_Employee_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Employee_ModifiedDate] DEFAULT (GETDATE()),
    CONSTRAINT [CK_Employee_BirthDate] CHECK ([BirthDate] BETWEEN '1930-01-01' AND DATEADD(YEAR, -18, GETDATE())),
    CONSTRAINT [CK_Employee_MaritalStatus] CHECK (UPPER([MaritalStatus]) IN ('M', 'S')), -- Married or Single
    CONSTRAINT [CK_Employee_HireDate] CHECK ([HireDate] BETWEEN '1996-07-01' AND DATEADD(DAY, 1, GETDATE())),
    CONSTRAINT [CK_Employee_Gender] CHECK (UPPER([Gender]) IN ('M', 'F')), -- Male or Female
    CONSTRAINT [CK_Employee_VacationHours] CHECK ([VacationHours] BETWEEN -40 AND 240), 
    CONSTRAINT [CK_Employee_SickLeaveHours] CHECK ([SickLeaveHours] BETWEEN 0 AND 120) 
) ON [PRIMARY];
GO

CREATE TABLE [HumanResources].[EmployeeDepartmentHistory](
    [BusinessEntityID] [int] NOT NULL,
    [DepartmentID] [smallint] NOT NULL,
    [ShiftID] [tinyint] NOT NULL,
    [StartDate] [date] NOT NULL,
    [EndDate] [date] NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_EmployeeDepartmentHistory_ModifiedDate] DEFAULT (GETDATE()), 
    CONSTRAINT [CK_EmployeeDepartmentHistory_EndDate] CHECK (([EndDate] >= [StartDate]) OR ([EndDate] IS NULL)),
) ON [PRIMARY];
GO

CREATE TABLE [HumanResources].[EmployeePayHistory](
    [BusinessEntityID] [int] NOT NULL,
    [RateChangeDate] [datetime] NOT NULL,
    [Rate] [money] NOT NULL,
    [PayFrequency] [tinyint] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_EmployeePayHistory_ModifiedDate] DEFAULT (GETDATE()),
    CONSTRAINT [CK_EmployeePayHistory_PayFrequency] CHECK ([PayFrequency] IN (1, 2)), -- 1 = monthly salary, 2 = biweekly salary
    CONSTRAINT [CK_EmployeePayHistory_Rate] CHECK ([Rate] BETWEEN 6.50 AND 200.00) 
) ON [PRIMARY];
GO

CREATE TABLE [Production].[Illustration](
    [IllustrationID] [int] IDENTITY (1, 1) NOT NULL,
    [Diagram] [XML] NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Illustration_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [HumanResources].[JobCandidate](
    [JobCandidateID] [int] IDENTITY (1, 1) NOT NULL,
    [BusinessEntityID] [int] NULL,
    [Resume] [XML]([HumanResources].[HRResumeSchemaCollection]) NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_JobCandidate_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Production].[Location](
    [LocationID] [smallint] IDENTITY (1, 1) NOT NULL,
    [Name] [Name] NOT NULL,
    [CostRate] [smallmoney] NOT NULL CONSTRAINT [DF_Location_CostRate] DEFAULT (0.00),
    [Availability] [decimal](8, 2) NOT NULL CONSTRAINT [DF_Location_Availability] DEFAULT (0.00), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Location_ModifiedDate] DEFAULT (GETDATE()), 
    CONSTRAINT [CK_Location_CostRate] CHECK ([CostRate] >= 0.00), 
    CONSTRAINT [CK_Location_Availability] CHECK ([Availability] >= 0.00) 
) ON [PRIMARY];
GO

CREATE TABLE [Person].[Password](
	[BusinessEntityID] [int] NOT NULL,
    [PasswordHash] [varchar](128) NOT NULL, 
    [PasswordSalt] [varchar](10) NOT NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_Password_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Password_ModifiedDate] DEFAULT (GETDATE())

) ON [PRIMARY];
GO

CREATE TABLE [Person].[Person](
    [BusinessEntityID] [int] NOT NULL,
	[PersonType] [nchar](2) NOT NULL,
    [NameStyle] [NameStyle] NOT NULL CONSTRAINT [DF_Person_NameStyle] DEFAULT (0),
    [Title] [nvarchar](8) NULL, 
    [FirstName] [Name] NOT NULL,
    [MiddleName] [Name] NULL,
    [LastName] [Name] NOT NULL,
    [Suffix] [nvarchar](10) NULL, 
    [EmailPromotion] [int] NOT NULL CONSTRAINT [DF_Person_EmailPromotion] DEFAULT (0), 
    [AdditionalContactInfo] [XML]([Person].[AdditionalContactInfoSchemaCollection]) NULL,
    [Demographics] [XML]([Person].[IndividualSurveySchemaCollection]) NULL, 
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_Person_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Person_ModifiedDate] DEFAULT (GETDATE()), 
    CONSTRAINT [CK_Person_EmailPromotion] CHECK ([EmailPromotion] BETWEEN 0 AND 2),
    CONSTRAINT [CK_Person_PersonType] CHECK ([PersonType] IS NULL OR UPPER([PersonType]) IN ('SC', 'VC', 'IN', 'EM', 'SP', 'GC'))
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[PersonCreditCard](
    [BusinessEntityID] [int] NOT NULL,
    [CreditCardID] [int] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_PersonCreditCard_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Person].[PersonPhone](
    [BusinessEntityID] [int] NOT NULL,
	[PhoneNumber] [Phone] NOT NULL,
	[PhoneNumberTypeID] [int] NOT NULL,
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_PersonPhone_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Person].[PhoneNumberType](
	[PhoneNumberTypeID] [int] IDENTITY (1, 1) NOT NULL,
	[Name] [Name] NOT NULL,
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_PhoneNumberType_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Production].[Product](
    [ProductID] [int] IDENTITY (1, 1) NOT NULL,
    [Name] [Name] NOT NULL,
    [ProductNumber] [nvarchar](25) NOT NULL, 
    [MakeFlag] [Flag] NOT NULL CONSTRAINT [DF_Product_MakeFlag] DEFAULT (1),
    [FinishedGoodsFlag] [Flag] NOT NULL CONSTRAINT [DF_Product_FinishedGoodsFlag] DEFAULT (1),
    [Color] [nvarchar](15) NULL, 
    [SafetyStockLevel] [smallint] NOT NULL,
    [ReorderPoint] [smallint] NOT NULL,
    [StandardCost] [money] NOT NULL,
    [ListPrice] [money] NOT NULL,
    [Size] [nvarchar](5) NULL, 
    [SizeUnitMeasureCode] [nchar](3) NULL, 
    [WeightUnitMeasureCode] [nchar](3) NULL, 
    [Weight] [decimal](8, 2) NULL,
    [DaysToManufacture] [int] NOT NULL,
    [ProductLine] [nchar](2) NULL, 
    [Class] [nchar](2) NULL, 
    [Style] [nchar](2) NULL, 
    [ProductSubcategoryID] [int] NULL,
    [ProductModelID] [int] NULL,
    [SellStartDate] [datetime] NOT NULL,
    [SellEndDate] [datetime] NULL,
    [DiscontinuedDate] [datetime] NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_Product_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Product_ModifiedDate] DEFAULT (GETDATE()),
    CONSTRAINT [CK_Product_SafetyStockLevel] CHECK ([SafetyStockLevel] > 0),
    CONSTRAINT [CK_Product_ReorderPoint] CHECK ([ReorderPoint] > 0),
    CONSTRAINT [CK_Product_StandardCost] CHECK ([StandardCost] >= 0.00),
    CONSTRAINT [CK_Product_ListPrice] CHECK ([ListPrice] >= 0.00),
    CONSTRAINT [CK_Product_Weight] CHECK ([Weight] > 0.00),
    CONSTRAINT [CK_Product_DaysToManufacture] CHECK ([DaysToManufacture] >= 0),
    CONSTRAINT [CK_Product_ProductLine] CHECK (UPPER([ProductLine]) IN ('S', 'T', 'M', 'R') OR [ProductLine] IS NULL),
    CONSTRAINT [CK_Product_Class] CHECK (UPPER([Class]) IN ('L', 'M', 'H') OR [Class] IS NULL),
    CONSTRAINT [CK_Product_Style] CHECK (UPPER([Style]) IN ('W', 'M', 'U') OR [Style] IS NULL), 
    CONSTRAINT [CK_Product_SellEndDate] CHECK (([SellEndDate] >= [SellStartDate]) OR ([SellEndDate] IS NULL)),
) ON [PRIMARY];
GO

CREATE TABLE [Production].[ProductCategory](
    [ProductCategoryID] [int] IDENTITY (1, 1) NOT NULL,
    [Name] [Name] NOT NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_ProductCategory_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductCategory_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Production].[ProductCostHistory](
    [ProductID] [int] NOT NULL,
    [StartDate] [datetime] NOT NULL,
    [EndDate] [datetime] NULL,
    [StandardCost] [money] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductCostHistory_ModifiedDate] DEFAULT (GETDATE()),
    CONSTRAINT [CK_ProductCostHistory_EndDate] CHECK (([EndDate] >= [StartDate]) OR ([EndDate] IS NULL)),
    CONSTRAINT [CK_ProductCostHistory_StandardCost] CHECK ([StandardCost] >= 0.00)
) ON [PRIMARY];
GO

CREATE TABLE [Production].[ProductDescription](
    [ProductDescriptionID] [int] IDENTITY (1, 1) NOT NULL,
    [Description] [nvarchar](400) NOT NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_ProductDescription_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductDescription_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Production].[ProductDocument](
    [ProductID] [int] NOT NULL,
    [DocumentNode] [hierarchyid] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductDocument_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Production].[ProductInventory](
    [ProductID] [int] NOT NULL,
    [LocationID] [smallint] NOT NULL,
    [Shelf] [nvarchar](10) NOT NULL, 
    [Bin] [tinyint] NOT NULL,
    [Quantity] [smallint] NOT NULL CONSTRAINT [DF_ProductInventory_Quantity] DEFAULT (0),
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_ProductInventory_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductInventory_ModifiedDate] DEFAULT (GETDATE()),
    CONSTRAINT [CK_ProductInventory_Shelf] CHECK (([Shelf] LIKE '[A-Za-z]') OR ([Shelf] = 'N/A')),
    CONSTRAINT [CK_ProductInventory_Bin] CHECK ([Bin] BETWEEN 0 AND 100)
) ON [PRIMARY];
GO

CREATE TABLE [Production].[ProductListPriceHistory](
    [ProductID] [int] NOT NULL,
    [StartDate] [datetime] NOT NULL,
    [EndDate] [datetime] NULL,
    [ListPrice] [money] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductListPriceHistory_ModifiedDate] DEFAULT (GETDATE()), 
    CONSTRAINT [CK_ProductListPriceHistory_EndDate] CHECK (([EndDate] >= [StartDate]) OR ([EndDate] IS NULL)),
    CONSTRAINT [CK_ProductListPriceHistory_ListPrice] CHECK ([ListPrice] > 0.00)
) ON [PRIMARY];
GO

CREATE TABLE [Production].[ProductModel](
    [ProductModelID] [int] IDENTITY (1, 1) NOT NULL,
    [Name] [Name] NOT NULL,
    [CatalogDescription] [XML]([Production].[ProductDescriptionSchemaCollection]) NULL,
    [Instructions] [XML]([Production].[ManuInstructionsSchemaCollection]) NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_ProductModel_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductModel_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Production].[ProductModelIllustration](
    [ProductModelID] [int] NOT NULL,
    [IllustrationID] [int] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductModelIllustration_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Production].[ProductModelProductDescriptionCulture](
    [ProductModelID] [int] NOT NULL,
    [ProductDescriptionID] [int] NOT NULL,
    [CultureID] [nchar](6) NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductModelProductDescriptionCulture_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Production].[ProductPhoto](
    [ProductPhotoID] [int] IDENTITY (1, 1) NOT NULL,
    [ThumbNailPhoto] [varbinary](max) NULL,
    [ThumbnailPhotoFileName] [nvarchar](50) NULL,
    [LargePhoto] [varbinary](max) NULL,
    [LargePhotoFileName] [nvarchar](50) NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductPhoto_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Production].[ProductProductPhoto](
    [ProductID] [int] NOT NULL,
    [ProductPhotoID] [int] NOT NULL,
    [Primary] [Flag] NOT NULL CONSTRAINT [DF_ProductProductPhoto_Primary] DEFAULT (0),
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductProductPhoto_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Production].[ProductReview](
    [ProductReviewID] [int] IDENTITY (1, 1) NOT NULL,
    [ProductID] [int] NOT NULL,
    [ReviewerName] [Name] NOT NULL,
    [ReviewDate] [datetime] NOT NULL CONSTRAINT [DF_ProductReview_ReviewDate] DEFAULT (GETDATE()),
    [EmailAddress] [nvarchar](50) NOT NULL,
    [Rating] [int] NOT NULL,
    [Comments] [nvarchar](3850), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductReview_ModifiedDate] DEFAULT (GETDATE()), 
    CONSTRAINT [CK_ProductReview_Rating] CHECK ([Rating] BETWEEN 1 AND 5), 
) ON [PRIMARY];
GO

CREATE TABLE [Production].[ProductSubcategory](
    [ProductSubcategoryID] [int] IDENTITY (1, 1) NOT NULL,
    [ProductCategoryID] [int] NOT NULL,
    [Name] [Name] NOT NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_ProductSubcategory_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductSubcategory_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Purchasing].[ProductVendor](
    [ProductID] [int] NOT NULL,
    [BusinessEntityID] [int] NOT NULL,
    [AverageLeadTime] [int] NOT NULL,
    [StandardPrice] [money] NOT NULL,
    [LastReceiptCost] [money] NULL,
    [LastReceiptDate] [datetime] NULL,
    [MinOrderQty] [int] NOT NULL,
    [MaxOrderQty] [int] NOT NULL,
    [OnOrderQty] [int] NULL,
    [UnitMeasureCode] [nchar](3) NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductVendor_ModifiedDate] DEFAULT (GETDATE()), 
    CONSTRAINT [CK_ProductVendor_AverageLeadTime] CHECK ([AverageLeadTime] >= 1),
    CONSTRAINT [CK_ProductVendor_StandardPrice] CHECK ([StandardPrice] > 0.00),
    CONSTRAINT [CK_ProductVendor_LastReceiptCost] CHECK ([LastReceiptCost] > 0.00),
    CONSTRAINT [CK_ProductVendor_MinOrderQty] CHECK ([MinOrderQty] >= 1),
    CONSTRAINT [CK_ProductVendor_MaxOrderQty] CHECK ([MaxOrderQty] >= 1),
    CONSTRAINT [CK_ProductVendor_OnOrderQty] CHECK ([OnOrderQty] >= 0)
) ON [PRIMARY];
GO

CREATE TABLE [Purchasing].[PurchaseOrderDetail](
    [PurchaseOrderID] [int] NOT NULL,
    [PurchaseOrderDetailID] [int] IDENTITY (1, 1) NOT NULL,
    [DueDate] [datetime] NOT NULL,
    [OrderQty] [smallint] NOT NULL,
    [ProductID] [int] NOT NULL,
    [UnitPrice] [money] NOT NULL,
    [LineTotal] AS ISNULL([OrderQty] * [UnitPrice], 0.00), 
    [ReceivedQty] [decimal](8, 2) NOT NULL,
    [RejectedQty] [decimal](8, 2) NOT NULL,
    [StockedQty] AS ISNULL([ReceivedQty] - [RejectedQty], 0.00),
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_PurchaseOrderDetail_ModifiedDate] DEFAULT (GETDATE()), 
    CONSTRAINT [CK_PurchaseOrderDetail_OrderQty] CHECK ([OrderQty] > 0), 
    CONSTRAINT [CK_PurchaseOrderDetail_UnitPrice] CHECK ([UnitPrice] >= 0.00), 
    CONSTRAINT [CK_PurchaseOrderDetail_ReceivedQty] CHECK ([ReceivedQty] >= 0.00), 
    CONSTRAINT [CK_PurchaseOrderDetail_RejectedQty] CHECK ([RejectedQty] >= 0.00) 
) ON [PRIMARY];
GO

CREATE TABLE [Purchasing].[PurchaseOrderHeader](
    [PurchaseOrderID] [int] IDENTITY (1, 1) NOT NULL, 
    [RevisionNumber] [tinyint] NOT NULL CONSTRAINT [DF_PurchaseOrderHeader_RevisionNumber] DEFAULT (0), 
    [Status] [tinyint] NOT NULL CONSTRAINT [DF_PurchaseOrderHeader_Status] DEFAULT (1), 
    [EmployeeID] [int] NOT NULL, 
    [VendorID] [int] NOT NULL, 
    [ShipMethodID] [int] NOT NULL, 
    [OrderDate] [datetime] NOT NULL CONSTRAINT [DF_PurchaseOrderHeader_OrderDate] DEFAULT (GETDATE()), 
    [ShipDate] [datetime] NULL, 
    [SubTotal] [money] NOT NULL CONSTRAINT [DF_PurchaseOrderHeader_SubTotal] DEFAULT (0.00), 
    [TaxAmt] [money] NOT NULL CONSTRAINT [DF_PurchaseOrderHeader_TaxAmt] DEFAULT (0.00), 
    [Freight] [money] NOT NULL CONSTRAINT [DF_PurchaseOrderHeader_Freight] DEFAULT (0.00), 
    [TotalDue] AS ISNULL([SubTotal] + [TaxAmt] + [Freight], 0) PERSISTED NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_PurchaseOrderHeader_ModifiedDate] DEFAULT (GETDATE()), 
    CONSTRAINT [CK_PurchaseOrderHeader_Status] CHECK ([Status] BETWEEN 1 AND 4), -- 1 = Pending; 2 = Approved; 3 = Rejected; 4 = Complete 
    CONSTRAINT [CK_PurchaseOrderHeader_ShipDate] CHECK (([ShipDate] >= [OrderDate]) OR ([ShipDate] IS NULL)), 
    CONSTRAINT [CK_PurchaseOrderHeader_SubTotal] CHECK ([SubTotal] >= 0.00), 
    CONSTRAINT [CK_PurchaseOrderHeader_TaxAmt] CHECK ([TaxAmt] >= 0.00), 
    CONSTRAINT [CK_PurchaseOrderHeader_Freight] CHECK ([Freight] >= 0.00) 
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[SalesOrderDetail](
    [SalesOrderID] [int] NOT NULL,
    [SalesOrderDetailID] [int] IDENTITY (1, 1) NOT NULL,
    [CarrierTrackingNumber] [nvarchar](25) NULL, 
    [OrderQty] [smallint] NOT NULL,
    [ProductID] [int] NOT NULL,
    [SpecialOfferID] [int] NOT NULL,
    [UnitPrice] [money] NOT NULL,
    [UnitPriceDiscount] [money] NOT NULL CONSTRAINT [DF_SalesOrderDetail_UnitPriceDiscount] DEFAULT (0.0),
    [LineTotal] AS ISNULL([UnitPrice] * (1.0 - [UnitPriceDiscount]) * [OrderQty], 0.0),
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_SalesOrderDetail_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_SalesOrderDetail_ModifiedDate] DEFAULT (GETDATE()), 
    CONSTRAINT [CK_SalesOrderDetail_OrderQty] CHECK ([OrderQty] > 0), 
    CONSTRAINT [CK_SalesOrderDetail_UnitPrice] CHECK ([UnitPrice] >= 0.00), 
    CONSTRAINT [CK_SalesOrderDetail_UnitPriceDiscount] CHECK ([UnitPriceDiscount] >= 0.00) 
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[SalesOrderHeader](
    [SalesOrderID] [int] IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RevisionNumber] [tinyint] NOT NULL CONSTRAINT [DF_SalesOrderHeader_RevisionNumber] DEFAULT (0),
    [OrderDate] [datetime] NOT NULL CONSTRAINT [DF_SalesOrderHeader_OrderDate] DEFAULT (GETDATE()),
    [DueDate] [datetime] NOT NULL,
    [ShipDate] [datetime] NULL,
    [Status] [tinyint] NOT NULL CONSTRAINT [DF_SalesOrderHeader_Status] DEFAULT (1),
    [OnlineOrderFlag] [Flag] NOT NULL CONSTRAINT [DF_SalesOrderHeader_OnlineOrderFlag] DEFAULT (1),
    [SalesOrderNumber] AS ISNULL(N'SO' + CONVERT(nvarchar(23), [SalesOrderID]), N'*** ERROR ***'), 
    [PurchaseOrderNumber] [OrderNumber] NULL,
    [AccountNumber] [AccountNumber] NULL,
    [CustomerID] [int] NOT NULL,
    [SalesPersonID] [int] NULL,
    [TerritoryID] [int] NULL,
    [BillToAddressID] [int] NOT NULL,
    [ShipToAddressID] [int] NOT NULL,
    [ShipMethodID] [int] NOT NULL,
    [CreditCardID] [int] NULL,
    [CreditCardApprovalCode] [varchar](15) NULL,    
    [CurrencyRateID] [int] NULL,
    [SubTotal] [money] NOT NULL CONSTRAINT [DF_SalesOrderHeader_SubTotal] DEFAULT (0.00),
    [TaxAmt] [money] NOT NULL CONSTRAINT [DF_SalesOrderHeader_TaxAmt] DEFAULT (0.00),
    [Freight] [money] NOT NULL CONSTRAINT [DF_SalesOrderHeader_Freight] DEFAULT (0.00),
    [TotalDue] AS ISNULL([SubTotal] + [TaxAmt] + [Freight], 0),
    [Comment] [nvarchar](128) NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_SalesOrderHeader_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_SalesOrderHeader_ModifiedDate] DEFAULT (GETDATE()),
    CONSTRAINT [CK_SalesOrderHeader_Status] CHECK ([Status] BETWEEN 0 AND 8), 
    CONSTRAINT [CK_SalesOrderHeader_DueDate] CHECK ([DueDate] >= [OrderDate]), 
    CONSTRAINT [CK_SalesOrderHeader_ShipDate] CHECK (([ShipDate] >= [OrderDate]) OR ([ShipDate] IS NULL)), 
    CONSTRAINT [CK_SalesOrderHeader_SubTotal] CHECK ([SubTotal] >= 0.00), 
    CONSTRAINT [CK_SalesOrderHeader_TaxAmt] CHECK ([TaxAmt] >= 0.00), 
    CONSTRAINT [CK_SalesOrderHeader_Freight] CHECK ([Freight] >= 0.00) 
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[SalesOrderHeaderSalesReason](
    [SalesOrderID] [int] NOT NULL,
    [SalesReasonID] [int] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_SalesOrderHeaderSalesReason_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[SalesPerson](
    [BusinessEntityID] [int] NOT NULL,
    [TerritoryID] [int] NULL,
    [SalesQuota] [money] NULL,
    [Bonus] [money] NOT NULL CONSTRAINT [DF_SalesPerson_Bonus] DEFAULT (0.00),
    [CommissionPct] [smallmoney] NOT NULL CONSTRAINT [DF_SalesPerson_CommissionPct] DEFAULT (0.00),
    [SalesYTD] [money] NOT NULL CONSTRAINT [DF_SalesPerson_SalesYTD] DEFAULT (0.00),
    [SalesLastYear] [money] NOT NULL CONSTRAINT [DF_SalesPerson_SalesLastYear] DEFAULT (0.00),
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_SalesPerson_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_SalesPerson_ModifiedDate] DEFAULT (GETDATE()), 
    CONSTRAINT [CK_SalesPerson_SalesQuota] CHECK ([SalesQuota] > 0.00), 
    CONSTRAINT [CK_SalesPerson_Bonus] CHECK ([Bonus] >= 0.00), 
    CONSTRAINT [CK_SalesPerson_CommissionPct] CHECK ([CommissionPct] >= 0.00), 
    CONSTRAINT [CK_SalesPerson_SalesYTD] CHECK ([SalesYTD] >= 0.00), 
    CONSTRAINT [CK_SalesPerson_SalesLastYear] CHECK ([SalesLastYear] >= 0.00) 
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[SalesPersonQuotaHistory](
    [BusinessEntityID] [int] NOT NULL,
    [QuotaDate] [datetime] NOT NULL,
    [SalesQuota] [money] NOT NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_SalesPersonQuotaHistory_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_SalesPersonQuotaHistory_ModifiedDate] DEFAULT (GETDATE()), 
    CONSTRAINT [CK_SalesPersonQuotaHistory_SalesQuota] CHECK ([SalesQuota] > 0.00) 
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[SalesReason](
    [SalesReasonID] [int] IDENTITY (1, 1) NOT NULL,
    [Name] [Name] NOT NULL,
    [ReasonType] [Name] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_SalesReason_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[SalesTaxRate](
    [SalesTaxRateID] [int] IDENTITY (1, 1) NOT NULL,
    [StateProvinceID] [int] NOT NULL,
    [TaxType] [tinyint] NOT NULL,
    [TaxRate] [smallmoney] NOT NULL CONSTRAINT [DF_SalesTaxRate_TaxRate] DEFAULT (0.00),
    [Name] [Name] NOT NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_SalesTaxRate_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_SalesTaxRate_ModifiedDate] DEFAULT (GETDATE()),
    CONSTRAINT [CK_SalesTaxRate_TaxType] CHECK ([TaxType] BETWEEN 1 AND 3)
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[SalesTerritory](
    [TerritoryID] [int] IDENTITY (1, 1) NOT NULL,
    [Name] [Name] NOT NULL,
    [CountryRegionCode] [nvarchar](3) NOT NULL, 
    [Group] [nvarchar](50) NOT NULL,
    [SalesYTD] [money] NOT NULL CONSTRAINT [DF_SalesTerritory_SalesYTD] DEFAULT (0.00),
    [SalesLastYear] [money] NOT NULL CONSTRAINT [DF_SalesTerritory_SalesLastYear] DEFAULT (0.00),
    [CostYTD] [money] NOT NULL CONSTRAINT [DF_SalesTerritory_CostYTD] DEFAULT (0.00),
    [CostLastYear] [money] NOT NULL CONSTRAINT [DF_SalesTerritory_CostLastYear] DEFAULT (0.00),
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_SalesTerritory_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_SalesTerritory_ModifiedDate] DEFAULT (GETDATE()), 
    CONSTRAINT [CK_SalesTerritory_SalesYTD] CHECK ([SalesYTD] >= 0.00), 
    CONSTRAINT [CK_SalesTerritory_SalesLastYear] CHECK ([SalesLastYear] >= 0.00), 
    CONSTRAINT [CK_SalesTerritory_CostYTD] CHECK ([CostYTD] >= 0.00), 
    CONSTRAINT [CK_SalesTerritory_CostLastYear] CHECK ([CostLastYear] >= 0.00) 
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[SalesTerritoryHistory](
    [BusinessEntityID] [int] NOT NULL,  -- A sales person
    [TerritoryID] [int] NOT NULL,
    [StartDate] [datetime] NOT NULL,
    [EndDate] [datetime] NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_SalesTerritoryHistory_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_SalesTerritoryHistory_ModifiedDate] DEFAULT (GETDATE()), 
    CONSTRAINT [CK_SalesTerritoryHistory_EndDate] CHECK (([EndDate] >= [StartDate]) OR ([EndDate] IS NULL))
) ON [PRIMARY];
GO

CREATE TABLE [Production].[ScrapReason](
    [ScrapReasonID] [smallint] IDENTITY (1, 1) NOT NULL,
    [Name] [Name] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ScrapReason_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [HumanResources].[Shift](
    [ShiftID] [tinyint] IDENTITY (1, 1) NOT NULL,
    [Name] [Name] NOT NULL,
    [StartTime] [time] NOT NULL,
    [EndTime] [time] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Shift_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Purchasing].[ShipMethod](
    [ShipMethodID] [int] IDENTITY (1, 1) NOT NULL,
    [Name] [Name] NOT NULL,
    [ShipBase] [money] NOT NULL CONSTRAINT [DF_ShipMethod_ShipBase] DEFAULT (0.00),
    [ShipRate] [money] NOT NULL CONSTRAINT [DF_ShipMethod_ShipRate] DEFAULT (0.00),
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_ShipMethod_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ShipMethod_ModifiedDate] DEFAULT (GETDATE()), 
    CONSTRAINT [CK_ShipMethod_ShipBase] CHECK ([ShipBase] > 0.00), 
    CONSTRAINT [CK_ShipMethod_ShipRate] CHECK ([ShipRate] > 0.00), 
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[ShoppingCartItem](
    [ShoppingCartItemID] [int] IDENTITY (1, 1) NOT NULL,
    [ShoppingCartID] [nvarchar](50) NOT NULL,
    [Quantity] [int] NOT NULL CONSTRAINT [DF_ShoppingCartItem_Quantity] DEFAULT (1),
    [ProductID] [int] NOT NULL,
    [DateCreated] [datetime] NOT NULL CONSTRAINT [DF_ShoppingCartItem_DateCreated] DEFAULT (GETDATE()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ShoppingCartItem_ModifiedDate] DEFAULT (GETDATE()), 
    CONSTRAINT [CK_ShoppingCartItem_Quantity] CHECK ([Quantity] >= 1) 
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[SpecialOffer](
    [SpecialOfferID] [int] IDENTITY (1, 1) NOT NULL,
    [Description] [nvarchar](255) NOT NULL,
    [DiscountPct] [smallmoney] NOT NULL CONSTRAINT [DF_SpecialOffer_DiscountPct] DEFAULT (0.00),
    [Type] [nvarchar](50) NOT NULL,
    [Category] [nvarchar](50) NOT NULL,
    [StartDate] [datetime] NOT NULL,
    [EndDate] [datetime] NOT NULL,
    [MinQty] [int] NOT NULL CONSTRAINT [DF_SpecialOffer_MinQty] DEFAULT (0), 
    [MaxQty] [int] NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_SpecialOffer_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_SpecialOffer_ModifiedDate] DEFAULT (GETDATE()), 
    CONSTRAINT [CK_SpecialOffer_EndDate] CHECK ([EndDate] >= [StartDate]), 
    CONSTRAINT [CK_SpecialOffer_DiscountPct] CHECK ([DiscountPct] >= 0.00), 
    CONSTRAINT [CK_SpecialOffer_MinQty] CHECK ([MinQty] >= 0), 
    CONSTRAINT [CK_SpecialOffer_MaxQty]  CHECK ([MaxQty] >= 0)
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[SpecialOfferProduct](
    [SpecialOfferID] [int] NOT NULL,
    [ProductID] [int] NOT NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_SpecialOfferProduct_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_SpecialOfferProduct_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Person].[StateProvince](
    [StateProvinceID] [int] IDENTITY (1, 1) NOT NULL,
    [StateProvinceCode] [nchar](3) NOT NULL, 
    [CountryRegionCode] [nvarchar](3) NOT NULL, 
    [IsOnlyStateProvinceFlag] [Flag] NOT NULL CONSTRAINT [DF_StateProvince_IsOnlyStateProvinceFlag] DEFAULT (1),
    [Name] [Name] NOT NULL,
    [TerritoryID] [int] NOT NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_StateProvince_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_StateProvince_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Sales].[Store](
    [BusinessEntityID] [int] NOT NULL,
    [Name] [Name] NOT NULL,
    [SalesPersonID] [int] NULL,
    [Demographics] [XML]([Sales].[StoreSurveySchemaCollection]) NULL,
    [rowguid] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_Store_rowguid] DEFAULT (NEWID()), 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Store_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Production].[TransactionHistory](
    [TransactionID] [int] IDENTITY (100000, 1) NOT NULL,
    [ProductID] [int] NOT NULL,
    [ReferenceOrderID] [int] NOT NULL,
    [ReferenceOrderLineID] [int] NOT NULL CONSTRAINT [DF_TransactionHistory_ReferenceOrderLineID] DEFAULT (0),
    [TransactionDate] [datetime] NOT NULL CONSTRAINT [DF_TransactionHistory_TransactionDate] DEFAULT (GETDATE()),
    [TransactionType] [nchar](1) NOT NULL, 
    [Quantity] [int] NOT NULL,
    [ActualCost] [money] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_TransactionHistory_ModifiedDate] DEFAULT (GETDATE()),
    CONSTRAINT [CK_TransactionHistory_TransactionType] CHECK (UPPER([TransactionType]) IN ('W', 'S', 'P'))
) ON [PRIMARY];
GO

CREATE TABLE [Production].[TransactionHistoryArchive](
    [TransactionID] [int] NOT NULL,
    [ProductID] [int] NOT NULL,
    [ReferenceOrderID] [int] NOT NULL,
    [ReferenceOrderLineID] [int] NOT NULL CONSTRAINT [DF_TransactionHistoryArchive_ReferenceOrderLineID] DEFAULT (0),
    [TransactionDate] [datetime] NOT NULL CONSTRAINT [DF_TransactionHistoryArchive_TransactionDate] DEFAULT (GETDATE()),
    [TransactionType] [nchar](1) NOT NULL, 
    [Quantity] [int] NOT NULL,
    [ActualCost] [money] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_TransactionHistoryArchive_ModifiedDate] DEFAULT (GETDATE()),
    CONSTRAINT [CK_TransactionHistoryArchive_TransactionType] CHECK (UPPER([TransactionType]) IN ('W', 'S', 'P'))
) ON [PRIMARY];
GO

CREATE TABLE [Production].[UnitMeasure](
    [UnitMeasureCode] [nchar](3) NOT NULL, 
    [Name] [Name] NOT NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_UnitMeasure_ModifiedDate] DEFAULT (GETDATE()) 
) ON [PRIMARY];
GO

CREATE TABLE [Purchasing].[Vendor](
    [BusinessEntityID] [int] NOT NULL,
    [AccountNumber] [AccountNumber] NOT NULL,
    [Name] [Name] NOT NULL,
    [CreditRating] [tinyint] NOT NULL,
    [PreferredVendorStatus] [Flag] NOT NULL CONSTRAINT [DF_Vendor_PreferredVendorStatus] DEFAULT (1), 
    [ActiveFlag] [Flag] NOT NULL CONSTRAINT [DF_Vendor_ActiveFlag] DEFAULT (1),
    [PurchasingWebServiceURL] [nvarchar](1024) NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Vendor_ModifiedDate] DEFAULT (GETDATE()),
    CONSTRAINT [CK_Vendor_CreditRating] CHECK ([CreditRating] BETWEEN 1 AND 5)
) ON [PRIMARY];
GO

CREATE TABLE [Production].[WorkOrder](
    [WorkOrderID] [int] IDENTITY (1, 1) NOT NULL,
    [ProductID] [int] NOT NULL,
    [OrderQty] [int] NOT NULL,
    [StockedQty] AS ISNULL([OrderQty] - [ScrappedQty], 0),
    [ScrappedQty] [smallint] NOT NULL,
    [StartDate] [datetime] NOT NULL,
    [EndDate] [datetime] NULL,
    [DueDate] [datetime] NOT NULL,
    [ScrapReasonID] [smallint] NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_WorkOrder_ModifiedDate] DEFAULT (GETDATE()), 
    CONSTRAINT [CK_WorkOrder_OrderQty] CHECK ([OrderQty] > 0), 
    CONSTRAINT [CK_WorkOrder_ScrappedQty] CHECK ([ScrappedQty] >= 0), 
    CONSTRAINT [CK_WorkOrder_EndDate] CHECK (([EndDate] >= [StartDate]) OR ([EndDate] IS NULL))
) ON [PRIMARY];
GO

CREATE TABLE [Production].[WorkOrderRouting](
    [WorkOrderID] [int] NOT NULL,
    [ProductID] [int] NOT NULL,
    [OperationSequence] [smallint] NOT NULL,
    [LocationID] [smallint] NOT NULL,
    [ScheduledStartDate] [datetime] NOT NULL,
    [ScheduledEndDate] [datetime] NOT NULL,
    [ActualStartDate] [datetime] NULL,
    [ActualEndDate] [datetime] NULL,
    [ActualResourceHrs] [decimal](9, 4) NULL,
    [PlannedCost] [money] NOT NULL,
    [ActualCost] [money] NULL, 
    [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_WorkOrderRouting_ModifiedDate] DEFAULT (GETDATE()), 
    CONSTRAINT [CK_WorkOrderRouting_ScheduledEndDate] CHECK ([ScheduledEndDate] >= [ScheduledStartDate]), 
    CONSTRAINT [CK_WorkOrderRouting_ActualEndDate] CHECK (([ActualEndDate] >= [ActualStartDate]) 
        OR ([ActualEndDate] IS NULL) OR ([ActualStartDate] IS NULL)), 
    CONSTRAINT [CK_WorkOrderRouting_ActualResourceHrs] CHECK ([ActualResourceHrs] >= 0.0000), 
    CONSTRAINT [CK_WorkOrderRouting_PlannedCost] CHECK ([PlannedCost] > 0.00), 
    CONSTRAINT [CK_WorkOrderRouting_ActualCost] CHECK ([ActualCost] > 0.00) 
) ON [PRIMARY];
GO

-- ******************************************************
-- Load data
-- ******************************************************
PRINT '';
PRINT '*** Loading Data';
GO
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"
PRINT 'Loading [Person].[Address]';

BULK INSERT [Person].[Address] FROM 'D:\Database\AdventureWorksData\Address.csv'
WITH (


    FIELDTERMINATOR= '\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);


PRINT 'Loading [Person].[AddressType]';

BULK INSERT [Person].[AddressType] FROM 'D:\Database\AdventureWorksData\AddressType.csv'
WITH (


    FIELDTERMINATOR= '\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [dbo].[AWBuildVersion]';



INSERT INTO [dbo].[AWBuildVersion] 
VALUES
( CONVERT(nvarchar(25), SERVERPROPERTY('ProductVersion')), CONVERT(datetime, SERVERPROPERTY('ResourceLastUpdateDateTime')), CONVERT(datetime, GETDATE()) );


PRINT 'Loading [Production].[BillOfMaterials]';

BULK INSERT [Production].[BillOfMaterials] FROM 'D:\Database\AdventureWorksData\BillOfMaterials.csv'
WITH (


    FIELDTERMINATOR= '\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);


PRINT 'Loading [Person].[BusinessEntity]';

BULK INSERT [Person].[BusinessEntity] FROM 'D:\Database\AdventureWorksData\BusinessEntity.csv'
WITH (


    FIELDTERMINATOR='+|',
    ROWTERMINATOR='&|\n',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Person].[BusinessEntityAddress]';

BULK INSERT [Person].[BusinessEntityAddress] FROM 'D:\Database\AdventureWorksData\BusinessEntityAddress.csv'
WITH (


    FIELDTERMINATOR='+|',
    ROWTERMINATOR='&|\n',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Person].[BusinessEntityContact]';

BULK INSERT [Person].[BusinessEntityContact] FROM 'D:\Database\AdventureWorksData\BusinessEntityContact.csv'
WITH (


    FIELDTERMINATOR='+|',
    ROWTERMINATOR='&|\n',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Person].[ContactType]';

BULK INSERT [Person].[ContactType] FROM 'D:\Database\AdventureWorksData\ContactType.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Person].[CountryRegion]';

BULK INSERT [Person].[CountryRegion] FROM 'D:\Database\AdventureWorksData\CountryRegion.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Sales].[CountryRegionCurrency]';

BULK INSERT [Sales].[CountryRegionCurrency] FROM 'D:\Database\AdventureWorksData\CountryRegionCurrency.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Sales].[CreditCard]';

BULK INSERT [Sales].[CreditCard] FROM 'D:\Database\AdventureWorksData\CreditCard.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Production].[Culture]';

BULK INSERT [Production].[Culture] FROM 'D:\Database\AdventureWorksData\Culture.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Sales].[Currency]';

BULK INSERT [Sales].[Currency] FROM 'D:\Database\AdventureWorksData\Currency.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Sales].[CurrencyRate]';

BULK INSERT [Sales].[CurrencyRate] FROM 'D:\Database\AdventureWorksData\CurrencyRate.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);


PRINT 'Loading [Sales].[Customer]';

BULK INSERT [Sales].[Customer] FROM 'D:\Database\AdventureWorksData\Customer.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);



PRINT 'Loading [HumanResources].[Department]';

BULK INSERT [HumanResources].[Department] FROM 'D:\Database\AdventureWorksData\Department.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

 
PRINT 'Loading [Production].[Document]';

BULK INSERT [Production].[Document] FROM 'D:\Database\AdventureWorksData\Document.csv'
WITH (


    FIELDTERMINATOR='+|',
    ROWTERMINATOR='&|\n',
    KEEPIDENTITY,
    TABLOCK   
);


PRINT 'Loading [Person].[EmailAddress]';

BULK INSERT [Person].[EmailAddress] FROM 'D:\Database\AdventureWorksData\EmailAddress.csv'
WITH (


    FIELDTERMINATOR='+|',
    ROWTERMINATOR='&|\n',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [HumanResources].[Employee]';

BULK INSERT [HumanResources].[Employee] FROM 'D:\Database\AdventureWorksData\Employee.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [HumanResources].[EmployeeDepartmentHistory]';

BULK INSERT [HumanResources].[EmployeeDepartmentHistory] FROM 'D:\Database\AdventureWorksData\EmployeeDepartmentHistory.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [HumanResources].[EmployeePayHistory]';

BULK INSERT [HumanResources].[EmployeePayHistory] FROM 'D:\Database\AdventureWorksData\EmployeePayHistory.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);


PRINT 'Loading [Production].[Illustration]';

BULK INSERT [Production].[Illustration] FROM 'D:\Database\AdventureWorksData\Illustration.csv'
WITH (


    FIELDTERMINATOR='+|',
    ROWTERMINATOR='&|\n',
    KEEPIDENTITY,
    TABLOCK
);


PRINT 'Loading [HumanResources].[JobCandidate]';

BULK INSERT [HumanResources].[JobCandidate] FROM 'D:\Database\AdventureWorksData\JobCandidate.csv'
WITH (


    FIELDTERMINATOR='+|',
    ROWTERMINATOR='&|\n',
    KEEPIDENTITY,
    TABLOCK
);



PRINT 'Loading [Production].[Location]';

BULK INSERT [Production].[Location] FROM 'D:\Database\AdventureWorksData\Location.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);


PRINT 'Loading [Person].[Password]';

BULK INSERT [Person].[Password] FROM 'D:\Database\AdventureWorksData\Password.csv'
WITH (


    FIELDTERMINATOR='+|',
    ROWTERMINATOR='&|\n',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Person].[Person]';

BULK INSERT [Person].[Person] FROM 'D:\Database\AdventureWorksData\Person.csv'
WITH (


    FIELDTERMINATOR='+|',
    ROWTERMINATOR='&|\n',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Sales].[PersonCreditCard]';

BULK INSERT [Sales].[PersonCreditCard] FROM 'D:\Database\AdventureWorksData\PersonCreditCard.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Person].[PersonPhone]';

BULK INSERT [Person].[PersonPhone] FROM 'D:\Database\AdventureWorksData\PersonPhone.csv'
WITH (


    FIELDTERMINATOR='+|',
    ROWTERMINATOR='&|\n',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Person].[PhoneNumberType]';

BULK INSERT [Person].[PhoneNumberType] FROM 'D:\Database\AdventureWorksData\PhoneNumberType.csv'
WITH (


    FIELDTERMINATOR='+|',
    ROWTERMINATOR='&|\n',
    KEEPIDENTITY,
    TABLOCK
);


PRINT 'Loading [Production].[Product]';

BULK INSERT [Production].[Product] FROM 'D:\Database\AdventureWorksData\Product.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Production].[ProductCategory]';

BULK INSERT [Production].[ProductCategory] FROM 'D:\Database\AdventureWorksData\ProductCategory.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Production].[ProductCostHistory]';

BULK INSERT [Production].[ProductCostHistory] FROM 'D:\Database\AdventureWorksData\ProductCostHistory.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Production].[ProductDescription]';

BULK INSERT [Production].[ProductDescription] FROM 'D:\Database\AdventureWorksData\ProductDescription.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Production].[ProductDocument]';

BULK INSERT [Production].[ProductDocument] FROM 'D:\Database\AdventureWorksData\ProductDocument.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK   
);

PRINT 'Loading [Production].[ProductInventory]';

BULK INSERT [Production].[ProductInventory] FROM 'D:\Database\AdventureWorksData\ProductInventory.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Production].[ProductListPriceHistory]';

BULK INSERT [Production].[ProductListPriceHistory] FROM 'D:\Database\AdventureWorksData\ProductListPriceHistory.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Production].[ProductModel]';

BULK INSERT [Production].[ProductModel] FROM 'D:\Database\AdventureWorksData\ProductModel.csv'
WITH (



    FIELDTERMINATOR='+|',
    ROWTERMINATOR='&|\n',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Production].[ProductModelIllustration]';

BULK INSERT [Production].[ProductModelIllustration] FROM 'D:\Database\AdventureWorksData\ProductModelIllustration.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Production].[ProductModelProductDescriptionCulture]';

BULK INSERT [Production].[ProductModelProductDescriptionCulture] FROM 'D:\Database\AdventureWorksData\ProductModelProductDescriptionCulture.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Production].[ProductPhoto]';

BULK INSERT [Production].[ProductPhoto] FROM 'D:\Database\AdventureWorksData\ProductPhoto.csv'
WITH (



    FIELDTERMINATOR='+|',
    ROWTERMINATOR='&|\n',
    KEEPIDENTITY,
    TABLOCK   
);

PRINT 'Loading [Production].[ProductProductPhoto]';

BULK INSERT [Production].[ProductProductPhoto] FROM 'D:\Database\AdventureWorksData\ProductProductPhoto.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Production].[ProductReview]';

BULK INSERT [Production].[ProductReview] FROM 'D:\Database\AdventureWorksData\ProductReview.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Production].[ProductSubcategory]';

BULK INSERT [Production].[ProductSubcategory] FROM 'D:\Database\AdventureWorksData\ProductSubcategory.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);


PRINT 'Loading [Purchasing].[ProductVendor]';

BULK INSERT [Purchasing].[ProductVendor] FROM 'D:\Database\AdventureWorksData\ProductVendor.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);


PRINT 'Loading [Purchasing].[PurchaseOrderDetail]';

BULK INSERT [Purchasing].[PurchaseOrderDetail] FROM 'D:\Database\AdventureWorksData\PurchaseOrderDetail.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Purchasing].[PurchaseOrderHeader]';

BULK INSERT [Purchasing].[PurchaseOrderHeader] FROM 'D:\Database\AdventureWorksData\PurchaseOrderHeader.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Sales].[SalesOrderDetail]';

BULK INSERT [Sales].[SalesOrderDetail] FROM 'D:\Database\AdventureWorksData\SalesOrderDetail.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Sales].[SalesOrderHeader]';

BULK INSERT [Sales].[SalesOrderHeader] FROM 'D:\Database\AdventureWorksData\SalesOrderHeader.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);


PRINT 'Loading [Sales].[SalesOrderHeaderSalesReason]';

BULK INSERT [Sales].[SalesOrderHeaderSalesReason] FROM 'D:\Database\AdventureWorksData\SalesOrderHeaderSalesReason.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);


PRINT 'Loading [Sales].[SalesPerson]';

BULK INSERT [Sales].[SalesPerson] FROM 'D:\Database\AdventureWorksData\SalesPerson.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);


PRINT 'Loading [Sales].[SalesPersonQuotaHistory]';

BULK INSERT [Sales].[SalesPersonQuotaHistory] FROM 'D:\Database\AdventureWorksData\SalesPersonQuotaHistory.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);


PRINT 'Loading [Sales].[SalesReason]';

BULK INSERT [Sales].[SalesReason] FROM 'D:\Database\AdventureWorksData\SalesReason.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Sales].[SalesTaxRate]';

BULK INSERT [Sales].[SalesTaxRate] FROM 'D:\Database\AdventureWorksData\SalesTaxRate.csv'
WITH (


    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Sales].[SalesTerritory]';

BULK INSERT [Sales].[SalesTerritory] FROM 'D:\Database\AdventureWorksData\SalesTerritory.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Sales].[SalesTerritoryHistory]';

BULK INSERT [Sales].[SalesTerritoryHistory] FROM 'D:\Database\AdventureWorksData\SalesTerritoryHistory.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);


PRINT 'Loading [Production].[ScrapReason]';

BULK INSERT [Production].[ScrapReason] FROM 'D:\Database\AdventureWorksData\ScrapReason.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [HumanResources].[Shift]';

BULK INSERT [HumanResources].[Shift] FROM 'D:\Database\AdventureWorksData\Shift.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Purchasing].[ShipMethod]';

BULK INSERT [Purchasing].[ShipMethod] FROM 'D:\Database\AdventureWorksData\ShipMethod.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Sales].[ShoppingCartItem]';

BULK INSERT [Sales].[ShoppingCartItem] FROM 'D:\Database\AdventureWorksData\ShoppingCartItem.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Sales].[SpecialOffer]';

BULK INSERT [Sales].[SpecialOffer] FROM 'D:\Database\AdventureWorksData\SpecialOffer.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Sales].[SpecialOfferProduct]';

BULK INSERT [Sales].[SpecialOfferProduct] FROM 'D:\Database\AdventureWorksData\SpecialOfferProduct.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Person].[StateProvince]';

BULK INSERT [Person].[StateProvince] FROM 'D:\Database\AdventureWorksData\StateProvince.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Sales].[Store]';

BULK INSERT [Sales].[Store] FROM 'D:\Database\AdventureWorksData\Store.csv'
WITH (



    FIELDTERMINATOR='+|',
    ROWTERMINATOR='&|\n',
    KEEPIDENTITY,
    TABLOCK
);


PRINT 'Loading [Production].[TransactionHistory]';

BULK INSERT [Production].[TransactionHistory] FROM 'D:\Database\AdventureWorksData\TransactionHistory.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

PRINT 'Loading [Production].[TransactionHistoryArchive]';

BULK INSERT [Production].[TransactionHistoryArchive] FROM 'D:\Database\AdventureWorksData\TransactionHistoryArchive.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Production].[UnitMeasure]';

BULK INSERT [Production].[UnitMeasure] FROM 'D:\Database\AdventureWorksData\UnitMeasure.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Purchasing].[Vendor]';

BULK INSERT [Purchasing].[Vendor] FROM 'D:\Database\AdventureWorksData\Vendor.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Production].[WorkOrder]';

BULK INSERT [Production].[WorkOrder] FROM 'D:\Database\AdventureWorksData\WorkOrder.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

PRINT 'Loading [Production].[WorkOrderRouting]';

BULK INSERT [Production].[WorkOrderRouting] FROM 'D:\Database\AdventureWorksData\WorkOrderRouting.csv'
WITH (



    FIELDTERMINATOR='\t',
    ROWTERMINATOR = '0x0a',
    KEEPIDENTITY,
    TABLOCK
);

GO

PRINT 'enable constraints'
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"

-- ******************************************************
-- Add Primary Keys
-- ******************************************************
PRINT '';
PRINT '*** Adding Primary Keys';
GO

SET QUOTED_IDENTIFIER ON;

ALTER TABLE [Person].[Address] WITH CHECK ADD 
    CONSTRAINT [PK_Address_AddressID] PRIMARY KEY CLUSTERED 
    (
        [AddressID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Person].[AddressType] WITH CHECK ADD 
    CONSTRAINT [PK_AddressType_AddressTypeID] PRIMARY KEY CLUSTERED 
    (
        [AddressTypeID]
    )  ON [PRIMARY];
GO

ALTER TABLE [dbo].[AWBuildVersion] WITH CHECK ADD 
    CONSTRAINT [PK_AWBuildVersion_SystemInformationID] PRIMARY KEY CLUSTERED 
    (
        [SystemInformationID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[BillOfMaterials] WITH CHECK ADD 
    CONSTRAINT [PK_BillOfMaterials_BillOfMaterialsID] PRIMARY KEY NONCLUSTERED
    (
        [BillOfMaterialsID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Person].[BusinessEntity] WITH CHECK ADD 
    CONSTRAINT [PK_BusinessEntity_BusinessEntityID] PRIMARY KEY CLUSTERED 
    (
        [BusinessEntityID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Person].[BusinessEntityAddress] WITH CHECK ADD 
    CONSTRAINT [PK_BusinessEntityAddress_BusinessEntityID_AddressID_AddressTypeID] PRIMARY KEY CLUSTERED 
    (
        [BusinessEntityID],
		[AddressID],
		[AddressTypeID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Person].[BusinessEntityContact] WITH CHECK ADD 
    CONSTRAINT [PK_BusinessEntityContact_BusinessEntityID_PersonID_ContactTypeID] PRIMARY KEY CLUSTERED 
    (
        [BusinessEntityID],
		[PersonID],
		[ContactTypeID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Person].[ContactType] WITH CHECK ADD 
    CONSTRAINT [PK_ContactType_ContactTypeID] PRIMARY KEY CLUSTERED 
    (
        [ContactTypeID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Sales].[CountryRegionCurrency] WITH CHECK ADD 
    CONSTRAINT [PK_CountryRegionCurrency_CountryRegionCode_CurrencyCode] PRIMARY KEY CLUSTERED 
    (
        [CountryRegionCode],
        [CurrencyCode]
    )  ON [PRIMARY];
GO

ALTER TABLE [Person].[CountryRegion] WITH CHECK ADD 
    CONSTRAINT [PK_CountryRegion_CountryRegionCode] PRIMARY KEY CLUSTERED 
    (
        [CountryRegionCode]
    )  ON [PRIMARY];
GO

ALTER TABLE [Sales].[CreditCard] WITH CHECK ADD 
    CONSTRAINT [PK_CreditCard_CreditCardID] PRIMARY KEY CLUSTERED 
    (
        [CreditCardID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[Culture] WITH CHECK ADD 
    CONSTRAINT [PK_Culture_CultureID] PRIMARY KEY CLUSTERED 
    (
        [CultureID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Sales].[Currency] WITH CHECK ADD 
    CONSTRAINT [PK_Currency_CurrencyCode] PRIMARY KEY CLUSTERED 
    (
        [CurrencyCode]
    )  ON [PRIMARY];
GO

ALTER TABLE [Sales].[CurrencyRate] WITH CHECK ADD 
    CONSTRAINT [PK_CurrencyRate_CurrencyRateID] PRIMARY KEY CLUSTERED 
    (
        [CurrencyRateID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Sales].[Customer] WITH CHECK ADD 
    CONSTRAINT [PK_Customer_CustomerID] PRIMARY KEY CLUSTERED 
    (
        [CustomerID]
    )  ON [PRIMARY];
GO

ALTER TABLE [dbo].[DatabaseLog] WITH CHECK ADD 
    CONSTRAINT [PK_DatabaseLog_DatabaseLogID] PRIMARY KEY NONCLUSTERED 
    (
        [DatabaseLogID]
    )  ON [PRIMARY];
GO

ALTER TABLE [HumanResources].[Department] WITH CHECK ADD 
    CONSTRAINT [PK_Department_DepartmentID] PRIMARY KEY CLUSTERED 
    (
        [DepartmentID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[Document] WITH CHECK ADD 
    CONSTRAINT [PK_Document_DocumentNode] PRIMARY KEY CLUSTERED 
    (
        [DocumentNode]
    )  ON [PRIMARY];
GO

ALTER TABLE [Person].[EmailAddress] WITH CHECK ADD 
    CONSTRAINT [PK_EmailAddress_BusinessEntityID_EmailAddressID] PRIMARY KEY CLUSTERED 
    (
        [BusinessEntityID],
		[EmailAddressID]
    )  ON [PRIMARY];
GO

ALTER TABLE [HumanResources].[Employee] WITH CHECK ADD 
    CONSTRAINT [PK_Employee_BusinessEntityID] PRIMARY KEY CLUSTERED 
    (
        [BusinessEntityID]
    )  ON [PRIMARY];
GO

ALTER TABLE [HumanResources].[EmployeeDepartmentHistory] WITH CHECK ADD 
    CONSTRAINT [PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_DepartmentID] PRIMARY KEY CLUSTERED 
    (
        [BusinessEntityID],
        [StartDate],
        [DepartmentID],
        [ShiftID]
    )  ON [PRIMARY];
GO

ALTER TABLE [HumanResources].[EmployeePayHistory] WITH CHECK ADD 
    CONSTRAINT [PK_EmployeePayHistory_BusinessEntityID_RateChangeDate] PRIMARY KEY CLUSTERED 
    (
        [BusinessEntityID],
        [RateChangeDate]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[Illustration] WITH CHECK ADD 
    CONSTRAINT [PK_Illustration_IllustrationID] PRIMARY KEY CLUSTERED 
    (
        [IllustrationID]
    )  ON [PRIMARY];
GO


ALTER TABLE [HumanResources].[JobCandidate] WITH CHECK ADD 
    CONSTRAINT [PK_JobCandidate_JobCandidateID] PRIMARY KEY CLUSTERED 
    (
        [JobCandidateID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[Location] WITH CHECK ADD 
    CONSTRAINT [PK_Location_LocationID] PRIMARY KEY CLUSTERED 
    (
        [LocationID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Person].[Password] WITH CHECK ADD 
    CONSTRAINT [PK_Password_BusinessEntityID] PRIMARY KEY CLUSTERED 
    (
        [BusinessEntityID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Person].[Person] WITH CHECK ADD 
    CONSTRAINT [PK_Person_BusinessEntityID] PRIMARY KEY CLUSTERED 
    (
        [BusinessEntityID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Sales].[PersonCreditCard] WITH CHECK ADD 
    CONSTRAINT [PK_PersonCreditCard_BusinessEntityID_CreditCardID] PRIMARY KEY CLUSTERED 
    (
        [BusinessEntityID],
        [CreditCardID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Person].[PersonPhone] WITH CHECK ADD 
    CONSTRAINT [PK_PersonPhone_BusinessEntityID_PhoneNumber_PhoneNumberTypeID] PRIMARY KEY CLUSTERED 
    (
        [BusinessEntityID],
        [PhoneNumber],
        [PhoneNumberTypeID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Person].[PhoneNumberType] WITH CHECK ADD 
    CONSTRAINT [PK_PhoneNumberType_PhoneNumberTypeID] PRIMARY KEY CLUSTERED 
    (
        [PhoneNumberTypeID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[Product] WITH CHECK ADD 
    CONSTRAINT [PK_Product_ProductID] PRIMARY KEY CLUSTERED 
    (
        [ProductID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[ProductCategory] WITH CHECK ADD 
    CONSTRAINT [PK_ProductCategory_ProductCategoryID] PRIMARY KEY CLUSTERED 
    (
        [ProductCategoryID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[ProductCostHistory] WITH CHECK ADD 
    CONSTRAINT [PK_ProductCostHistory_ProductID_StartDate] PRIMARY KEY CLUSTERED 
    (
        [ProductID],
        [StartDate]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[ProductDescription] WITH CHECK ADD 
    CONSTRAINT [PK_ProductDescription_ProductDescriptionID] PRIMARY KEY CLUSTERED 
    (
        [ProductDescriptionID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[ProductDocument] WITH CHECK ADD 
    CONSTRAINT [PK_ProductDocument_ProductID_DocumentNode] PRIMARY KEY CLUSTERED 
    (
        [ProductID],
        [DocumentNode]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[ProductInventory] WITH CHECK ADD 
    CONSTRAINT [PK_ProductInventory_ProductID_LocationID] PRIMARY KEY CLUSTERED 
    (
    [ProductID],
    [LocationID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[ProductListPriceHistory] WITH CHECK ADD 
    CONSTRAINT [PK_ProductListPriceHistory_ProductID_StartDate] PRIMARY KEY CLUSTERED 
    (
        [ProductID],
        [StartDate]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[ProductModel] WITH CHECK ADD 
    CONSTRAINT [PK_ProductModel_ProductModelID] PRIMARY KEY CLUSTERED 
    (
        [ProductModelID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[ProductModelIllustration] WITH CHECK ADD 
    CONSTRAINT [PK_ProductModelIllustration_ProductModelID_IllustrationID] PRIMARY KEY CLUSTERED 
    (
        [ProductModelID],
        [IllustrationID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[ProductModelProductDescriptionCulture] WITH CHECK ADD 
    CONSTRAINT [PK_ProductModelProductDescriptionCulture_ProductModelID_ProductDescriptionID_CultureID] PRIMARY KEY CLUSTERED 
    (
        [ProductModelID],
        [ProductDescriptionID],
        [CultureID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[ProductPhoto] WITH CHECK ADD 
    CONSTRAINT [PK_ProductPhoto_ProductPhotoID] PRIMARY KEY CLUSTERED 
    (
        [ProductPhotoID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[ProductProductPhoto] WITH CHECK ADD 
    CONSTRAINT [PK_ProductProductPhoto_ProductID_ProductPhotoID] PRIMARY KEY NONCLUSTERED 
    (
        [ProductID],
        [ProductPhotoID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[ProductReview] WITH CHECK ADD 
    CONSTRAINT [PK_ProductReview_ProductReviewID] PRIMARY KEY CLUSTERED 
    (
        [ProductReviewID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[ProductSubcategory] WITH CHECK ADD 
    CONSTRAINT [PK_ProductSubcategory_ProductSubcategoryID] PRIMARY KEY CLUSTERED 
    (
        [ProductSubcategoryID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Purchasing].[ProductVendor] WITH CHECK ADD 
    CONSTRAINT [PK_ProductVendor_ProductID_BusinessEntityID] PRIMARY KEY CLUSTERED 
    (
        [ProductID],
        [BusinessEntityID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Purchasing].[PurchaseOrderDetail] WITH CHECK ADD 
    CONSTRAINT [PK_PurchaseOrderDetail_PurchaseOrderID_PurchaseOrderDetailID] PRIMARY KEY CLUSTERED 
    (
        [PurchaseOrderID],
        [PurchaseOrderDetailID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Purchasing].[PurchaseOrderHeader] WITH CHECK ADD 
    CONSTRAINT [PK_PurchaseOrderHeader_PurchaseOrderID] PRIMARY KEY CLUSTERED 
    (
        [PurchaseOrderID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Sales].[SalesOrderDetail] WITH CHECK ADD 
    CONSTRAINT [PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID] PRIMARY KEY CLUSTERED 
    (
        [SalesOrderID],
        [SalesOrderDetailID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Sales].[SalesOrderHeader] WITH CHECK ADD 
    CONSTRAINT [PK_SalesOrderHeader_SalesOrderID] PRIMARY KEY CLUSTERED 
    (
        [SalesOrderID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Sales].[SalesOrderHeaderSalesReason] WITH CHECK ADD 
    CONSTRAINT [PK_SalesOrderHeaderSalesReason_SalesOrderID_SalesReasonID] PRIMARY KEY CLUSTERED 
    (
        [SalesOrderID],
        [SalesReasonID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Sales].[SalesPerson] WITH CHECK ADD 
    CONSTRAINT [PK_SalesPerson_BusinessEntityID] PRIMARY KEY CLUSTERED 
    (
        [BusinessEntityID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Sales].[SalesPersonQuotaHistory] WITH CHECK ADD 
    CONSTRAINT [PK_SalesPersonQuotaHistory_BusinessEntityID_QuotaDate] PRIMARY KEY CLUSTERED 
    (
        [BusinessEntityID],
        [QuotaDate] --,
        -- [ProductCategoryID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Sales].[SalesReason] WITH CHECK ADD 
    CONSTRAINT [PK_SalesReason_SalesReasonID] PRIMARY KEY CLUSTERED 
    (
        [SalesReasonID]
    )  ON [PRIMARY];
GO
 
ALTER TABLE [Sales].[SalesTaxRate] WITH CHECK ADD 
    CONSTRAINT [PK_SalesTaxRate_SalesTaxRateID] PRIMARY KEY CLUSTERED 
    (
        [SalesTaxRateID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Sales].[SalesTerritory] WITH CHECK ADD 
    CONSTRAINT [PK_SalesTerritory_TerritoryID] PRIMARY KEY CLUSTERED 
    (
        [TerritoryID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Sales].[SalesTerritoryHistory] WITH CHECK ADD 
    CONSTRAINT [PK_SalesTerritoryHistory_BusinessEntityID_StartDate_TerritoryID] PRIMARY KEY CLUSTERED 
    (
        [BusinessEntityID],  --Sales person
        [StartDate],
        [TerritoryID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[ScrapReason] WITH CHECK ADD 
    CONSTRAINT [PK_ScrapReason_ScrapReasonID] PRIMARY KEY CLUSTERED 
    (
        [ScrapReasonID]
    )  ON [PRIMARY];
GO

ALTER TABLE [HumanResources].[Shift] WITH CHECK ADD 
    CONSTRAINT [PK_Shift_ShiftID] PRIMARY KEY CLUSTERED 
    (
        [ShiftID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Purchasing].[ShipMethod] WITH CHECK ADD 
    CONSTRAINT [PK_ShipMethod_ShipMethodID] PRIMARY KEY CLUSTERED 
    (
        [ShipMethodID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Sales].[ShoppingCartItem] WITH CHECK ADD 
    CONSTRAINT [PK_ShoppingCartItem_ShoppingCartItemID] PRIMARY KEY CLUSTERED 
    (
        [ShoppingCartItemID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Sales].[SpecialOffer] WITH CHECK ADD 
    CONSTRAINT [PK_SpecialOffer_SpecialOfferID] PRIMARY KEY CLUSTERED 
    (
        [SpecialOfferID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Sales].[SpecialOfferProduct] WITH CHECK ADD 
    CONSTRAINT [PK_SpecialOfferProduct_SpecialOfferID_ProductID] PRIMARY KEY CLUSTERED 
    (
        [SpecialOfferID],
        [ProductID]
    )  ON [PRIMARY];
GO
GO

ALTER TABLE [Person].[StateProvince] WITH CHECK ADD 
    CONSTRAINT [PK_StateProvince_StateProvinceID] PRIMARY KEY CLUSTERED 
    (
        [StateProvinceID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Sales].[Store] WITH CHECK ADD 
    CONSTRAINT [PK_Store_BusinessEntityID] PRIMARY KEY CLUSTERED 
    (
        [BusinessEntityID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[TransactionHistory] WITH CHECK ADD 
    CONSTRAINT [PK_TransactionHistory_TransactionID] PRIMARY KEY CLUSTERED 
    (
        [TransactionID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[TransactionHistoryArchive] WITH CHECK ADD 
    CONSTRAINT [PK_TransactionHistoryArchive_TransactionID] PRIMARY KEY CLUSTERED 
    (
        [TransactionID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[UnitMeasure] WITH CHECK ADD 
    CONSTRAINT [PK_UnitMeasure_UnitMeasureCode] PRIMARY KEY CLUSTERED 
    (
        [UnitMeasureCode]
    )  ON [PRIMARY];
GO

ALTER TABLE [Purchasing].[Vendor] WITH CHECK ADD 
    CONSTRAINT [PK_Vendor_BusinessEntityID] PRIMARY KEY CLUSTERED 
    (
        [BusinessEntityID]
    )  ON [PRIMARY];
GO


ALTER TABLE [Production].[WorkOrder] WITH CHECK ADD 
    CONSTRAINT [PK_WorkOrder_WorkOrderID] PRIMARY KEY CLUSTERED 
    (
        [WorkOrderID]
    )  ON [PRIMARY];
GO

ALTER TABLE [Production].[WorkOrderRouting] WITH CHECK ADD 
    CONSTRAINT [PK_WorkOrderRouting_WorkOrderID_ProductID_OperationSequence] PRIMARY KEY CLUSTERED 
    (
        [WorkOrderID],
        [ProductID],
        [OperationSequence]
    )  ON [PRIMARY];
GO


-- ******************************************************
-- Add Indexes
-- ******************************************************
PRINT '';
PRINT '*** Adding Indexes';
GO

CREATE UNIQUE INDEX [AK_Address_rowguid] ON [Person].[Address]([rowguid]) ON [PRIMARY];
CREATE UNIQUE INDEX [IX_Address_AddressLine1_AddressLine2_City_StateProvinceID_PostalCode] ON [Person].[Address] ([AddressLine1], [AddressLine2], [City], [StateProvinceID], [PostalCode]) ON [PRIMARY];
CREATE INDEX [IX_Address_StateProvinceID] ON [Person].[Address]([StateProvinceID]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_AddressType_rowguid] ON [Person].[AddressType]([rowguid]) ON [PRIMARY];
CREATE UNIQUE INDEX [AK_AddressType_Name] ON [Person].[AddressType]([Name]) ON [PRIMARY];
GO

CREATE INDEX [IX_BillOfMaterials_UnitMeasureCode] ON [Production].[BillOfMaterials]([UnitMeasureCode]) ON [PRIMARY];
CREATE UNIQUE CLUSTERED INDEX [AK_BillOfMaterials_ProductAssemblyID_ComponentID_StartDate] ON [Production].[BillOfMaterials]([ProductAssemblyID], [ComponentID], [StartDate]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_BusinessEntity_rowguid] ON [Person].[BusinessEntity]([rowguid]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_BusinessEntityAddress_rowguid] ON [Person].[BusinessEntityAddress]([rowguid]) ON [PRIMARY];
CREATE INDEX [IX_BusinessEntityAddress_AddressID] ON [Person].[BusinessEntityAddress]([AddressID]) ON [PRIMARY];
CREATE INDEX [IX_BusinessEntityAddress_AddressTypeID] ON [Person].[BusinessEntityAddress]([AddressTypeID]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_BusinessEntityContact_rowguid] ON [Person].[BusinessEntityContact]([rowguid]) ON [PRIMARY];
CREATE INDEX [IX_BusinessEntityContact_PersonID] ON [Person].[BusinessEntityContact]([PersonID]) ON [PRIMARY];
CREATE INDEX [IX_BusinessEntityContact_ContactTypeID] ON [Person].[BusinessEntityContact]([ContactTypeID]) ON [PRIMARY];
GO


CREATE UNIQUE INDEX [AK_ContactType_Name] ON [Person].[ContactType]([Name]) ON [PRIMARY];
GO

CREATE INDEX [IX_CountryRegionCurrency_CurrencyCode] ON [Sales].[CountryRegionCurrency]([CurrencyCode]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_CountryRegion_Name] ON [Person].[CountryRegion]([Name]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_CreditCard_CardNumber] ON [Sales].[CreditCard]([CardNumber]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_Culture_Name] ON [Production].[Culture]([Name]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_Currency_Name] ON [Sales].[Currency]([Name]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_CurrencyRate_CurrencyRateDate_FromCurrencyCode_ToCurrencyCode] ON [Sales].[CurrencyRate]([CurrencyRateDate], [FromCurrencyCode], [ToCurrencyCode]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_Customer_rowguid] ON [Sales].[Customer]([rowguid]) ON [PRIMARY];
CREATE UNIQUE INDEX [AK_Customer_AccountNumber] ON [Sales].[Customer]([AccountNumber]) ON [PRIMARY];
CREATE INDEX [IX_Customer_TerritoryID] ON [Sales].[Customer]([TerritoryID]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_Department_Name] ON [HumanResources].[Department]([Name]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_Document_DocumentLevel_DocumentNode] ON [Production].[Document] ([DocumentLevel], [DocumentNode]);
CREATE UNIQUE INDEX [AK_Document_rowguid] ON [Production].[Document]([rowguid]) ON [PRIMARY];
CREATE INDEX [IX_Document_FileName_Revision] ON [Production].[Document]([FileName], [Revision]) ON [PRIMARY];
GO

CREATE INDEX [IX_EmailAddress_EmailAddress] ON [Person].[EmailAddress]([EmailAddress]) ON [PRIMARY];
GO

CREATE INDEX [IX_Employee_OrganizationNode] ON [HumanResources].[Employee] ([OrganizationNode]);
CREATE INDEX [IX_Employee_OrganizationLevel_OrganizationNode] ON [HumanResources].[Employee] ([OrganizationLevel], [OrganizationNode]);
CREATE UNIQUE INDEX [AK_Employee_LoginID] ON [HumanResources].[Employee]([LoginID]) ON [PRIMARY];
CREATE UNIQUE INDEX [AK_Employee_NationalIDNumber] ON [HumanResources].[Employee]([NationalIDNumber]) ON [PRIMARY];
CREATE UNIQUE INDEX [AK_Employee_rowguid] ON [HumanResources].[Employee]([rowguid]) ON [PRIMARY];
GO

CREATE INDEX [IX_EmployeeDepartmentHistory_DepartmentID] ON [HumanResources].[EmployeeDepartmentHistory]([DepartmentID]) ON [PRIMARY];
CREATE INDEX [IX_EmployeeDepartmentHistory_ShiftID] ON [HumanResources].[EmployeeDepartmentHistory]([ShiftID]) ON [PRIMARY];
GO

CREATE INDEX [IX_JobCandidate_BusinessEntityID] ON [HumanResources].[JobCandidate]([BusinessEntityID]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_Location_Name] ON [Production].[Location]([Name]) ON [PRIMARY];
GO

CREATE INDEX [IX_Person_LastName_FirstName_MiddleName] ON [Person].[Person] ([LastName], [FirstName], [MiddleName]) ON [PRIMARY];
CREATE UNIQUE INDEX [AK_Person_rowguid] ON [Person].[Person]([rowguid]) ON [PRIMARY];

CREATE INDEX [IX_PersonPhone_PhoneNumber] on [Person].[PersonPhone] ([PhoneNumber]) ON [PRIMARY];

CREATE UNIQUE INDEX [AK_Product_ProductNumber] ON [Production].[Product]([ProductNumber]) ON [PRIMARY];
CREATE UNIQUE INDEX [AK_Product_Name] ON [Production].[Product]([Name]) ON [PRIMARY];
CREATE UNIQUE INDEX [AK_Product_rowguid] ON [Production].[Product]([rowguid]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_ProductCategory_Name] ON [Production].[ProductCategory]([Name]) ON [PRIMARY];
CREATE UNIQUE INDEX [AK_ProductCategory_rowguid] ON [Production].[ProductCategory]([rowguid]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_ProductDescription_rowguid] ON [Production].[ProductDescription]([rowguid]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_ProductModel_Name] ON [Production].[ProductModel]([Name]) ON [PRIMARY];
CREATE UNIQUE INDEX [AK_ProductModel_rowguid] ON [Production].[ProductModel]([rowguid]) ON [PRIMARY];
GO

CREATE NONCLUSTERED INDEX [IX_ProductReview_ProductID_Name] ON [Production].[ProductReview]([ProductID], [ReviewerName]) INCLUDE ([Comments]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_ProductSubcategory_Name] ON [Production].[ProductSubcategory]([Name]) ON [PRIMARY];
CREATE UNIQUE INDEX [AK_ProductSubcategory_rowguid] ON [Production].[ProductSubcategory]([rowguid]) ON [PRIMARY];
GO

CREATE INDEX [IX_ProductVendor_UnitMeasureCode] ON [Purchasing].[ProductVendor]([UnitMeasureCode]) ON [PRIMARY];
CREATE INDEX [IX_ProductVendor_BusinessEntityID] ON [Purchasing].[ProductVendor]([BusinessEntityID]) ON [PRIMARY];
GO

CREATE INDEX [IX_PurchaseOrderDetail_ProductID] ON [Purchasing].[PurchaseOrderDetail]([ProductID]) ON [PRIMARY];
GO

CREATE INDEX [IX_PurchaseOrderHeader_VendorID] ON [Purchasing].[PurchaseOrderHeader]([VendorID]) ON [PRIMARY];
CREATE INDEX [IX_PurchaseOrderHeader_EmployeeID] ON [Purchasing].[PurchaseOrderHeader]([EmployeeID]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_SalesOrderDetail_rowguid] ON [Sales].[SalesOrderDetail]([rowguid]) ON [PRIMARY];
CREATE INDEX [IX_SalesOrderDetail_ProductID] ON [Sales].[SalesOrderDetail]([ProductID]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_SalesOrderHeader_rowguid] ON [Sales].[SalesOrderHeader]([rowguid]) ON [PRIMARY];
CREATE UNIQUE INDEX [AK_SalesOrderHeader_SalesOrderNumber] ON [Sales].[SalesOrderHeader]([SalesOrderNumber]) ON [PRIMARY];
CREATE INDEX [IX_SalesOrderHeader_CustomerID] ON [Sales].[SalesOrderHeader]([CustomerID]) ON [PRIMARY];
CREATE INDEX [IX_SalesOrderHeader_SalesPersonID] ON [Sales].[SalesOrderHeader]([SalesPersonID]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_SalesPerson_rowguid] ON [Sales].[SalesPerson]([rowguid]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_SalesPersonQuotaHistory_rowguid] ON [Sales].[SalesPersonQuotaHistory]([rowguid]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_SalesTaxRate_StateProvinceID_TaxType] ON [Sales].[SalesTaxRate]([StateProvinceID], [TaxType]) ON [PRIMARY];
CREATE UNIQUE INDEX [AK_SalesTaxRate_rowguid] ON [Sales].[SalesTaxRate]([rowguid]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_SalesTerritory_Name] ON [Sales].[SalesTerritory]([Name]) ON [PRIMARY];
CREATE UNIQUE INDEX [AK_SalesTerritory_rowguid] ON [Sales].[SalesTerritory]([rowguid]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_SalesTerritoryHistory_rowguid] ON [Sales].[SalesTerritoryHistory]([rowguid]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_ScrapReason_Name] ON [Production].[ScrapReason]([Name]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_Shift_Name] ON [HumanResources].[Shift]([Name]) ON [PRIMARY];
CREATE UNIQUE INDEX [AK_Shift_StartTime_EndTime] ON [HumanResources].[Shift]([StartTime], [EndTime]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_ShipMethod_Name] ON [Purchasing].[ShipMethod]([Name]) ON [PRIMARY];
CREATE UNIQUE INDEX [AK_ShipMethod_rowguid] ON [Purchasing].[ShipMethod]([rowguid]) ON [PRIMARY];
GO

CREATE INDEX [IX_ShoppingCartItem_ShoppingCartID_ProductID] ON [Sales].[ShoppingCartItem]([ShoppingCartID], [ProductID]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_SpecialOffer_rowguid] ON [Sales].[SpecialOffer]([rowguid]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_SpecialOfferProduct_rowguid] ON [Sales].[SpecialOfferProduct]([rowguid]) ON [PRIMARY];
CREATE INDEX [IX_SpecialOfferProduct_ProductID] ON [Sales].[SpecialOfferProduct]([ProductID]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_StateProvince_Name] ON [Person].[StateProvince]([Name]) ON [PRIMARY];
CREATE UNIQUE INDEX [AK_StateProvince_StateProvinceCode_CountryRegionCode] ON [Person].[StateProvince]([StateProvinceCode], [CountryRegionCode]) ON [PRIMARY];
CREATE UNIQUE INDEX [AK_StateProvince_rowguid] ON [Person].[StateProvince]([rowguid]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_Store_rowguid] ON [Sales].[Store]([rowguid]) ON [PRIMARY];
CREATE INDEX [IX_Store_SalesPersonID] ON [Sales].[Store]([SalesPersonID]) ON [PRIMARY];
GO

CREATE INDEX [IX_TransactionHistory_ProductID] ON [Production].[TransactionHistory]([ProductID]) ON [PRIMARY];
CREATE INDEX [IX_TransactionHistory_ReferenceOrderID_ReferenceOrderLineID] ON [Production].[TransactionHistory]([ReferenceOrderID], [ReferenceOrderLineID]) ON [PRIMARY];
GO

CREATE INDEX [IX_TransactionHistoryArchive_ProductID] ON [Production].[TransactionHistoryArchive]([ProductID]) ON [PRIMARY];
CREATE INDEX [IX_TransactionHistoryArchive_ReferenceOrderID_ReferenceOrderLineID] ON [Production].[TransactionHistoryArchive]([ReferenceOrderID], [ReferenceOrderLineID]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_UnitMeasure_Name] ON [Production].[UnitMeasure]([Name]) ON [PRIMARY];
GO

CREATE UNIQUE INDEX [AK_Vendor_AccountNumber] ON [Purchasing].[Vendor]([AccountNumber]) ON [PRIMARY];
GO

CREATE INDEX [IX_WorkOrder_ScrapReasonID] ON [Production].[WorkOrder]([ScrapReasonID]) ON [PRIMARY];
CREATE INDEX [IX_WorkOrder_ProductID] ON [Production].[WorkOrder]([ProductID]) ON [PRIMARY];
GO

CREATE INDEX [IX_WorkOrderRouting_ProductID] ON [Production].[WorkOrderRouting]([ProductID]) ON [PRIMARY];
GO

-- ****************************************
-- Create XML index for each XML column
-- ****************************************
PRINT '';
PRINT '*** Creating XML index for each XML column';
GO

SET ARITHABORT ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
SET ANSI_WARNINGS ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;





CREATE PRIMARY XML INDEX [PXML_Person_AddContact] ON [Person].[Person]([AdditionalContactInfo]);
GO

CREATE PRIMARY XML INDEX [PXML_Person_Demographics] ON [Person].[Person]([Demographics]);
GO

CREATE XML INDEX [XMLPATH_Person_Demographics] ON [Person].[Person]([Demographics]) 
USING XML INDEX [PXML_Person_Demographics] FOR PATH;
GO

CREATE XML INDEX [XMLPROPERTY_Person_Demographics] ON [Person].[Person]([Demographics]) 
USING XML INDEX [PXML_Person_Demographics] FOR PROPERTY;
GO

CREATE XML INDEX [XMLVALUE_Person_Demographics] ON [Person].[Person]([Demographics]) 
USING XML INDEX [PXML_Person_Demographics] FOR VALUE;
GO

CREATE PRIMARY XML INDEX [PXML_Store_Demographics] ON [Sales].[Store]([Demographics]);
GO

CREATE PRIMARY XML INDEX [PXML_ProductModel_CatalogDescription] ON [Production].[ProductModel]([CatalogDescription]);
GO

CREATE PRIMARY XML INDEX [PXML_ProductModel_Instructions] ON [Production].[ProductModel]([Instructions]);
GO



-- ****************************************
-- Create Foreign key constraints
-- ****************************************
PRINT '';
PRINT '*** Creating Foreign Key Constraints';
GO

ALTER TABLE [Person].[Address] ADD 
    CONSTRAINT [FK_Address_StateProvince_StateProvinceID] FOREIGN KEY 
    (
        [StateProvinceID]
    ) REFERENCES [Person].[StateProvince](
        [StateProvinceID]
    );
GO

ALTER TABLE [Production].[BillOfMaterials] ADD 
    CONSTRAINT [FK_BillOfMaterials_Product_ProductAssemblyID] FOREIGN KEY 
    (
        [ProductAssemblyID]
    ) REFERENCES [Production].[Product](
        [ProductID]
    ),
    CONSTRAINT [FK_BillOfMaterials_Product_ComponentID] FOREIGN KEY 
    (
        [ComponentID]
    ) REFERENCES [Production].[Product](
        [ProductID]
    ),
    CONSTRAINT [FK_BillOfMaterials_UnitMeasure_UnitMeasureCode] FOREIGN KEY 
    (
        [UnitMeasureCode]
    ) REFERENCES [Production].[UnitMeasure](
        [UnitMeasureCode]
    );
GO

ALTER TABLE [Person].[BusinessEntityAddress] ADD 
    CONSTRAINT [FK_BusinessEntityAddress_Address_AddressID] FOREIGN KEY 
    (
        [AddressID]
    ) REFERENCES [Person].[Address](
        [AddressID]
    ),
    CONSTRAINT [FK_BusinessEntityAddress_AddressType_AddressTypeID] FOREIGN KEY 
    (
        [AddressTypeID]
    ) REFERENCES [Person].[AddressType](
        [AddressTypeID]
    ),
    CONSTRAINT [FK_BusinessEntityAddress_BusinessEntity_BusinessEntityID] FOREIGN KEY 
    (
        [BusinessEntityID]
    ) REFERENCES [Person].[BusinessEntity](
        [BusinessEntityID]
    );
GO

ALTER TABLE [Person].[BusinessEntityContact] ADD
    CONSTRAINT [FK_BusinessEntityContact_Person_PersonID] FOREIGN KEY 
    (
        [PersonID]
    ) REFERENCES [Person].[Person](
        [BusinessEntityID]
    ),
    CONSTRAINT [FK_BusinessEntityContact_ContactType_ContactTypeID] FOREIGN KEY 
    (
        [ContactTypeID]
    ) REFERENCES [Person].[ContactType](
        [ContactTypeID]
    ),
    CONSTRAINT [FK_BusinessEntityContact_BusinessEntity_BusinessEntityID] FOREIGN KEY 
    (
        [BusinessEntityID]
    ) REFERENCES [Person].[BusinessEntity](
        [BusinessEntityID]
    );
GO

ALTER TABLE [Sales].[CountryRegionCurrency] ADD 
    CONSTRAINT [FK_CountryRegionCurrency_CountryRegion_CountryRegionCode] FOREIGN KEY 
    (
        [CountryRegionCode]
    ) REFERENCES [Person].[CountryRegion](
        [CountryRegionCode]
    ),
    CONSTRAINT [FK_CountryRegionCurrency_Currency_CurrencyCode] FOREIGN KEY 
    (
        [CurrencyCode]
    ) REFERENCES [Sales].[Currency](
        [CurrencyCode]
    );
GO

ALTER TABLE [Sales].[CurrencyRate] ADD 
    CONSTRAINT [FK_CurrencyRate_Currency_FromCurrencyCode] FOREIGN KEY 
    (
        [FromCurrencyCode]
    ) REFERENCES [Sales].[Currency](
        [CurrencyCode]
    ),
    CONSTRAINT [FK_CurrencyRate_Currency_ToCurrencyCode] FOREIGN KEY 
    (
        [ToCurrencyCode]
    ) REFERENCES [Sales].[Currency](
        [CurrencyCode]
    );
GO

ALTER TABLE [Sales].[Customer] ADD 
    CONSTRAINT [FK_Customer_Person_PersonID] FOREIGN KEY 
    (
        [PersonID]
    ) REFERENCES [Person].[Person](
        [BusinessEntityID]
    ),
    CONSTRAINT [FK_Customer_Store_StoreID] FOREIGN KEY 
    (
        [StoreID]
    ) REFERENCES [Sales].[Store](
        [BusinessEntityID]
    ),
    CONSTRAINT [FK_Customer_SalesTerritory_TerritoryID] FOREIGN KEY 
    (
        [TerritoryID]
    ) REFERENCES [Sales].[SalesTerritory](
        [TerritoryID]
    );
GO

ALTER TABLE [Production].[Document] ADD
	CONSTRAINT [FK_Document_Employee_Owner] FOREIGN KEY
	(
		[Owner]
	) REFERENCES [HumanResources].[Employee](
		[BusinessEntityID]
	);
GO

ALTER TABLE [Person].[EmailAddress] ADD 
    CONSTRAINT [FK_EmailAddress_Person_BusinessEntityID] FOREIGN KEY 
    (
        [BusinessEntityID]
    ) REFERENCES [Person].[Person](
        [BusinessEntityID]
    );
GO

ALTER TABLE [HumanResources].[Employee] ADD 
    CONSTRAINT [FK_Employee_Person_BusinessEntityID] FOREIGN KEY 
    (
        [BusinessEntityID]
    ) REFERENCES [Person].[Person](
        [BusinessEntityID]
    );
GO

ALTER TABLE [HumanResources].[EmployeeDepartmentHistory] ADD 
    CONSTRAINT [FK_EmployeeDepartmentHistory_Department_DepartmentID] FOREIGN KEY 
    (
        [DepartmentID]
    ) REFERENCES [HumanResources].[Department](
        [DepartmentID]
    ),
    CONSTRAINT [FK_EmployeeDepartmentHistory_Employee_BusinessEntityID] FOREIGN KEY 
    (
        [BusinessEntityID]
    ) REFERENCES [HumanResources].[Employee](
        [BusinessEntityID]
    ),
    CONSTRAINT [FK_EmployeeDepartmentHistory_Shift_ShiftID] FOREIGN KEY 
    (
        [ShiftID]
    ) REFERENCES [HumanResources].[Shift](
        [ShiftID]
    );
GO

ALTER TABLE [HumanResources].[EmployeePayHistory] ADD 
    CONSTRAINT [FK_EmployeePayHistory_Employee_BusinessEntityID] FOREIGN KEY 
    (
        [BusinessEntityID]
    ) REFERENCES [HumanResources].[Employee](
        [BusinessEntityID]
    );
GO

ALTER TABLE [HumanResources].[JobCandidate] ADD 
    CONSTRAINT [FK_JobCandidate_Employee_BusinessEntityID] FOREIGN KEY 
    (
        [BusinessEntityID]
    ) REFERENCES [HumanResources].[Employee](
        [BusinessEntityID]
    );
GO

ALTER TABLE [Person].[Password] ADD 
    CONSTRAINT [FK_Password_Person_BusinessEntityID] FOREIGN KEY 
    (
        [BusinessEntityID]
    ) REFERENCES [Person].[Person](
        [BusinessEntityID]
    );
GO

ALTER TABLE [Person].[Person] ADD 
    CONSTRAINT [FK_Person_BusinessEntity_BusinessEntityID] FOREIGN KEY 
    (
        [BusinessEntityID]
    ) REFERENCES [Person].[BusinessEntity](
        [BusinessEntityID]
    );
GO

ALTER TABLE [Sales].[PersonCreditCard] ADD 
    CONSTRAINT [FK_PersonCreditCard_Person_BusinessEntityID] FOREIGN KEY 
    (
        [BusinessEntityID]
    ) REFERENCES [Person].[Person](
        [BusinessEntityID]
    ),
    CONSTRAINT [FK_PersonCreditCard_CreditCard_CreditCardID] FOREIGN KEY 
    (
        [CreditCardID]
    ) REFERENCES [Sales].[CreditCard](
        [CreditCardID]
    );
GO

ALTER TABLE [Person].[PersonPhone] ADD 
    CONSTRAINT [FK_PersonPhone_Person_BusinessEntityID] FOREIGN KEY 
    (
        [BusinessEntityID]
    ) REFERENCES [Person].[Person](
        [BusinessEntityID]
    ),
 CONSTRAINT [FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID] FOREIGN KEY 
    (
        [PhoneNumberTypeID]
    ) REFERENCES [Person].[PhoneNumberType](
        [PhoneNumberTypeID]
    );
GO

ALTER TABLE [Production].[Product] ADD 
    CONSTRAINT [FK_Product_UnitMeasure_SizeUnitMeasureCode] FOREIGN KEY 
    (
        [SizeUnitMeasureCode]
    ) REFERENCES [Production].[UnitMeasure](
        [UnitMeasureCode]
    ),
    CONSTRAINT [FK_Product_UnitMeasure_WeightUnitMeasureCode] FOREIGN KEY 
    (
        [WeightUnitMeasureCode]
    ) REFERENCES [Production].[UnitMeasure](
        [UnitMeasureCode]
    ),
    CONSTRAINT [FK_Product_ProductModel_ProductModelID] FOREIGN KEY 
    (
        [ProductModelID]
    ) REFERENCES [Production].[ProductModel](
        [ProductModelID]
    ),
    CONSTRAINT [FK_Product_ProductSubcategory_ProductSubcategoryID] FOREIGN KEY 
    (
        [ProductSubcategoryID]
    ) REFERENCES [Production].[ProductSubcategory](
        [ProductSubcategoryID]
    );
GO

ALTER TABLE [Production].[ProductCostHistory] ADD 
    CONSTRAINT [FK_ProductCostHistory_Product_ProductID] FOREIGN KEY 
    (
        [ProductID]
    ) REFERENCES [Production].[Product](
        [ProductID]
    );
GO

ALTER TABLE [Production].[ProductDocument] ADD 
    CONSTRAINT [FK_ProductDocument_Product_ProductID] FOREIGN KEY 
    (
        [ProductID]
    ) REFERENCES [Production].[Product](
        [ProductID]
    ),
    CONSTRAINT [FK_ProductDocument_Document_DocumentNode] FOREIGN KEY 
    (
        [DocumentNode]
    ) REFERENCES [Production].[Document](
        [DocumentNode]
    );
GO

ALTER TABLE [Production].[ProductInventory] ADD 
    CONSTRAINT [FK_ProductInventory_Location_LocationID] FOREIGN KEY 
    (
        [LocationID]
    ) REFERENCES [Production].[Location](
        [LocationID]
    ),
    CONSTRAINT [FK_ProductInventory_Product_ProductID] FOREIGN KEY 
    (
        [ProductID]
    ) REFERENCES [Production].[Product](
        [ProductID]
    );
GO

ALTER TABLE [Production].[ProductListPriceHistory] ADD 
    CONSTRAINT [FK_ProductListPriceHistory_Product_ProductID] FOREIGN KEY 
    (
        [ProductID]
    ) REFERENCES [Production].[Product](
        [ProductID]
    );
GO

ALTER TABLE [Production].[ProductModelIllustration] ADD 
    CONSTRAINT [FK_ProductModelIllustration_ProductModel_ProductModelID] FOREIGN KEY 
    (
        [ProductModelID]
    ) REFERENCES [Production].[ProductModel](
        [ProductModelID]
    ),
    CONSTRAINT [FK_ProductModelIllustration_Illustration_IllustrationID] FOREIGN KEY 
    (
        [IllustrationID]
    ) REFERENCES [Production].[Illustration](
        [IllustrationID]
    );
GO

ALTER TABLE [Production].[ProductModelProductDescriptionCulture] ADD 
    CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID] FOREIGN KEY 
    (
        [ProductDescriptionID]
    ) REFERENCES [Production].[ProductDescription](
        [ProductDescriptionID]
    ),
    CONSTRAINT [FK_ProductModelProductDescriptionCulture_Culture_CultureID] FOREIGN KEY 
    (
        [CultureID]
    ) REFERENCES [Production].[Culture]
    (
        [CultureID]
    ),
    CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID] FOREIGN KEY 
    (
        [ProductModelID]
    ) REFERENCES [Production].[ProductModel](
        [ProductModelID]
    );
GO

ALTER TABLE [Production].[ProductProductPhoto] ADD
    CONSTRAINT [FK_ProductProductPhoto_Product_ProductID] FOREIGN KEY 
    (
        [ProductID]
    ) REFERENCES [Production].[Product](
        [ProductID]
    ),
    CONSTRAINT [FK_ProductProductPhoto_ProductPhoto_ProductPhotoID] FOREIGN KEY 
    (
        [ProductPhotoID]
    ) REFERENCES [Production].[ProductPhoto](
        [ProductPhotoID]
    );
GO

ALTER TABLE [Production].[ProductReview] ADD 
    CONSTRAINT [FK_ProductReview_Product_ProductID] FOREIGN KEY 
    (
        [ProductID]
    ) REFERENCES [Production].[Product](
        [ProductID]
    );
GO

ALTER TABLE [Production].[ProductSubcategory] ADD 
    CONSTRAINT [FK_ProductSubcategory_ProductCategory_ProductCategoryID] FOREIGN KEY 
    (
        [ProductCategoryID]
    ) REFERENCES [Production].[ProductCategory](
        [ProductCategoryID]
    );
GO

ALTER TABLE [Purchasing].[ProductVendor] ADD 
    CONSTRAINT [FK_ProductVendor_Product_ProductID] FOREIGN KEY 
    (
        [ProductID]
    ) REFERENCES [Production].[Product](
        [ProductID]
    ),
    CONSTRAINT [FK_ProductVendor_UnitMeasure_UnitMeasureCode] FOREIGN KEY 
    (
        [UnitMeasureCode]
    ) REFERENCES [Production].[UnitMeasure](
        [UnitMeasureCode]
    ),
    CONSTRAINT [FK_ProductVendor_Vendor_BusinessEntityID] FOREIGN KEY 
    (
        [BusinessEntityID]
    ) REFERENCES [Purchasing].[Vendor](
        [BusinessEntityID]
    );
GO

ALTER TABLE [Purchasing].[PurchaseOrderDetail] ADD 
    CONSTRAINT [FK_PurchaseOrderDetail_Product_ProductID] FOREIGN KEY 
    (
        [ProductID]
    ) REFERENCES [Production].[Product](
        [ProductID]
    ),
    CONSTRAINT [FK_PurchaseOrderDetail_PurchaseOrderHeader_PurchaseOrderID] FOREIGN KEY 
    (
        [PurchaseOrderID]
    ) REFERENCES [Purchasing].[PurchaseOrderHeader](
        [PurchaseOrderID]
    );
GO

ALTER TABLE [Purchasing].[PurchaseOrderHeader] ADD 
    CONSTRAINT [FK_PurchaseOrderHeader_Employee_EmployeeID] FOREIGN KEY 
    (
        [EmployeeID]
    ) REFERENCES [HumanResources].[Employee](
        [BusinessEntityID]
    ),
    CONSTRAINT [FK_PurchaseOrderHeader_Vendor_VendorID] FOREIGN KEY 
    (
        [VendorID]
    ) REFERENCES [Purchasing].[Vendor](
        [BusinessEntityID]
    ),
    CONSTRAINT [FK_PurchaseOrderHeader_ShipMethod_ShipMethodID] FOREIGN KEY 
    (
        [ShipMethodID]
    ) REFERENCES [Purchasing].[ShipMethod](
        [ShipMethodID]
    );
GO

ALTER TABLE [Sales].[SalesOrderDetail] ADD 
    CONSTRAINT [FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID] FOREIGN KEY 
    (
        [SalesOrderID]
    ) REFERENCES [Sales].[SalesOrderHeader](
        [SalesOrderID]
    ) ON DELETE CASCADE,
    CONSTRAINT [FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID] FOREIGN KEY 
    (
        [SpecialOfferID],
        [ProductID]
    ) REFERENCES [Sales].[SpecialOfferProduct](
        [SpecialOfferID],
        [ProductID]
    );
GO

ALTER TABLE [Sales].[SalesOrderHeader] ADD 
    CONSTRAINT [FK_SalesOrderHeader_Address_BillToAddressID] FOREIGN KEY 
    (
        [BillToAddressID]
    ) REFERENCES [Person].[Address](
        [AddressID]
    ),
    CONSTRAINT [FK_SalesOrderHeader_Address_ShipToAddressID] FOREIGN KEY 
    (
        [ShipToAddressID]
    ) REFERENCES [Person].[Address](
        [AddressID]
    ),
    CONSTRAINT [FK_SalesOrderHeader_CreditCard_CreditCardID] FOREIGN KEY 
    (
        [CreditCardID]
    ) REFERENCES [Sales].[CreditCard](
        [CreditCardID]
    ),
    CONSTRAINT [FK_SalesOrderHeader_CurrencyRate_CurrencyRateID] FOREIGN KEY 
    (
        [CurrencyRateID]
    ) REFERENCES [Sales].[CurrencyRate](
        [CurrencyRateID]
    ),
    CONSTRAINT [FK_SalesOrderHeader_Customer_CustomerID] FOREIGN KEY 
    (
        [CustomerID]
    ) REFERENCES [Sales].[Customer](
        [CustomerID]
    ),
    CONSTRAINT [FK_SalesOrderHeader_SalesPerson_SalesPersonID] FOREIGN KEY 
    (
        [SalesPersonID]
    ) REFERENCES [Sales].[SalesPerson](
        [BusinessEntityID]
    ),
    CONSTRAINT [FK_SalesOrderHeader_ShipMethod_ShipMethodID] FOREIGN KEY 
    (
        [ShipMethodID]
    ) REFERENCES [Purchasing].[ShipMethod](
        [ShipMethodID]
    ),
    CONSTRAINT [FK_SalesOrderHeader_SalesTerritory_TerritoryID] FOREIGN KEY 
    (
        [TerritoryID]
    ) REFERENCES [Sales].[SalesTerritory](
        [TerritoryID]
    );
GO

ALTER TABLE [Sales].[SalesOrderHeaderSalesReason] ADD 
    CONSTRAINT [FK_SalesOrderHeaderSalesReason_SalesReason_SalesReasonID] FOREIGN KEY 
    (
        [SalesReasonID]
    ) REFERENCES [Sales].[SalesReason](
        [SalesReasonID]
    ),
    CONSTRAINT [FK_SalesOrderHeaderSalesReason_SalesOrderHeader_SalesOrderID] FOREIGN KEY 
    (
        [SalesOrderID]
    ) REFERENCES [Sales].[SalesOrderHeader](
        [SalesOrderID]
    ) ON DELETE CASCADE;
GO

ALTER TABLE [Sales].[SalesPerson] ADD 
    CONSTRAINT [FK_SalesPerson_Employee_BusinessEntityID] FOREIGN KEY 
    (
        [BusinessEntityID]
    ) REFERENCES [HumanResources].[Employee](
        [BusinessEntityID]
    ),
    CONSTRAINT [FK_SalesPerson_SalesTerritory_TerritoryID] FOREIGN KEY 
    (
        [TerritoryID]
    ) REFERENCES [Sales].[SalesTerritory](
        [TerritoryID]
    );
GO

ALTER TABLE [Sales].[SalesPersonQuotaHistory] ADD 
    CONSTRAINT [FK_SalesPersonQuotaHistory_SalesPerson_BusinessEntityID] FOREIGN KEY 
    (
        [BusinessEntityID]
    ) REFERENCES [Sales].[SalesPerson](
        [BusinessEntityID]
    );
GO

ALTER TABLE [Sales].[SalesTaxRate] ADD 
    CONSTRAINT [FK_SalesTaxRate_StateProvince_StateProvinceID] FOREIGN KEY 
    (
        [StateProvinceID]
    ) REFERENCES [Person].[StateProvince](
        [StateProvinceID]
    );
GO

ALTER TABLE [Sales].[SalesTerritory] ADD
	CONSTRAINT [FK_SalesTerritory_CountryRegion_CountryRegionCode] FOREIGN KEY
	(
		[CountryRegionCode]
	) REFERENCES [Person].[CountryRegion] (
		[CountryRegionCode]
    );
GO

ALTER TABLE [Sales].[SalesTerritoryHistory] ADD 
    CONSTRAINT [FK_SalesTerritoryHistory_SalesPerson_BusinessEntityID] FOREIGN KEY 
    (
        [BusinessEntityID]
    ) REFERENCES [Sales].[SalesPerson](
        [BusinessEntityID]
    ),
    CONSTRAINT [FK_SalesTerritoryHistory_SalesTerritory_TerritoryID] FOREIGN KEY 
    (
        [TerritoryID]
    ) REFERENCES [Sales].[SalesTerritory](
        [TerritoryID]
    );
GO

ALTER TABLE [Sales].[ShoppingCartItem] ADD 
    CONSTRAINT [FK_ShoppingCartItem_Product_ProductID] FOREIGN KEY 
    (
        [ProductID]
    ) REFERENCES [Production].[Product](
        [ProductID]
    );
GO

ALTER TABLE [Sales].[SpecialOfferProduct] ADD 
    CONSTRAINT [FK_SpecialOfferProduct_Product_ProductID] FOREIGN KEY 
    (
        [ProductID]
    ) REFERENCES [Production].[Product](
        [ProductID]
    ),
    CONSTRAINT [FK_SpecialOfferProduct_SpecialOffer_SpecialOfferID] FOREIGN KEY 
    (
        [SpecialOfferID]
    ) REFERENCES [Sales].[SpecialOffer](
        [SpecialOfferID]
    );
GO

ALTER TABLE [Person].[StateProvince] ADD 
    CONSTRAINT [FK_StateProvince_CountryRegion_CountryRegionCode] FOREIGN KEY 
    (
        [CountryRegionCode]
    ) REFERENCES [Person].[CountryRegion](
        [CountryRegionCode]
    ), 
    CONSTRAINT [FK_StateProvince_SalesTerritory_TerritoryID] FOREIGN KEY 
    (
        [TerritoryID]
    ) REFERENCES [Sales].[SalesTerritory](
        [TerritoryID]
    );
GO

ALTER TABLE [Sales].[Store] ADD 
	CONSTRAINT [FK_Store_BusinessEntity_BusinessEntityID] FOREIGN KEY
	(
		[BusinessEntityID]
	) REFERENCES [Person].[BusinessEntity](
		[BusinessEntityID]
	),
    CONSTRAINT [FK_Store_SalesPerson_SalesPersonID] FOREIGN KEY 
    (
        [SalesPersonID]
    ) REFERENCES [Sales].[SalesPerson](
        [BusinessEntityID]
    );
GO



ALTER TABLE [Production].[TransactionHistory] ADD 
    CONSTRAINT [FK_TransactionHistory_Product_ProductID] FOREIGN KEY 
    (
        [ProductID]
    ) REFERENCES [Production].[Product](
        [ProductID]
    );
GO

ALTER TABLE [Purchasing].[Vendor] ADD 
	CONSTRAINT [FK_Vendor_BusinessEntity_BusinessEntityID] FOREIGN KEY
	(
		[BusinessEntityID]
	) REFERENCES [Person].[BusinessEntity](
		[BusinessEntityID]
	);
GO

ALTER TABLE [Production].[WorkOrder] ADD 
    CONSTRAINT [FK_WorkOrder_Product_ProductID] FOREIGN KEY 
    (
        [ProductID]
    ) REFERENCES [Production].[Product](
        [ProductID]
    ),
    CONSTRAINT [FK_WorkOrder_ScrapReason_ScrapReasonID] FOREIGN KEY 
    (
        [ScrapReasonID]
    ) REFERENCES [Production].[ScrapReason](
        [ScrapReasonID]
    );
GO

ALTER TABLE [Production].[WorkOrderRouting] ADD 
    CONSTRAINT [FK_WorkOrderRouting_Location_LocationID] FOREIGN KEY 
    (
        [LocationID]
    ) REFERENCES [Production].[Location](
        [LocationID]
    ),
    CONSTRAINT [FK_WorkOrderRouting_WorkOrder_WorkOrderID] FOREIGN KEY 
    (
        [WorkOrderID]
    ) REFERENCES [Production].[WorkOrder](
        [WorkOrderID]
    );
GO


-- ******************************************************
-- Add table triggers.
-- ******************************************************
PRINT '';
PRINT '*** Creating Table Triggers';
GO

CREATE TRIGGER [HumanResources].[dEmployee] ON [HumanResources].[Employee] 
INSTEAD OF DELETE NOT FOR REPLICATION AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN
        RAISERROR
            (N'Employees cannot be deleted. They can only be marked as not current.', -- Message
            10, -- Severity.
            1); -- State.

        -- Rollback any active or uncommittable transactions
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
    END;
END;
GO

CREATE TRIGGER [Person].[iuPerson] ON [Person].[Person] 
AFTER INSERT, UPDATE NOT FOR REPLICATION AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    IF UPDATE([BusinessEntityID]) OR UPDATE([Demographics]) 
    BEGIN
        UPDATE [Person].[Person] 
        SET [Person].[Person].[Demographics] = N'<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"> 
            <TotalPurchaseYTD>0.00</TotalPurchaseYTD> 
            </IndividualSurvey>' 
        FROM inserted 
        WHERE [Person].[Person].[BusinessEntityID] = inserted.[BusinessEntityID] 
            AND inserted.[Demographics] IS NULL;
        
        UPDATE [Person].[Person] 
        SET [Demographics].modify(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
            insert <TotalPurchaseYTD>0.00</TotalPurchaseYTD> 
            as first 
            into (/IndividualSurvey)[1]') 
        FROM inserted 
        WHERE [Person].[Person].[BusinessEntityID] = inserted.[BusinessEntityID] 
            AND inserted.[Demographics] IS NOT NULL 
            AND inserted.[Demographics].exist(N'declare default element namespace 
                "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
                /IndividualSurvey/TotalPurchaseYTD') <> 1;
    END;
END;
GO

CREATE TRIGGER [Purchasing].[iPurchaseOrderDetail] ON [Purchasing].[PurchaseOrderDetail] 
AFTER INSERT AS
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO [Production].[TransactionHistory]
            ([ProductID]
            ,[ReferenceOrderID]
            ,[ReferenceOrderLineID]
            ,[TransactionType]
            ,[TransactionDate]
            ,[Quantity]
            ,[ActualCost])
        SELECT 
            inserted.[ProductID]
            ,inserted.[PurchaseOrderID]
            ,inserted.[PurchaseOrderDetailID]
            ,'P'
            ,GETDATE()
            ,inserted.[OrderQty]
            ,inserted.[UnitPrice]
        FROM inserted 
            INNER JOIN [Purchasing].[PurchaseOrderHeader] 
            ON inserted.[PurchaseOrderID] = [Purchasing].[PurchaseOrderHeader].[PurchaseOrderID];

        -- Update SubTotal in PurchaseOrderHeader record. Note that this causes the 
        -- PurchaseOrderHeader trigger to fire which will update the RevisionNumber.
        UPDATE [Purchasing].[PurchaseOrderHeader]
        SET [Purchasing].[PurchaseOrderHeader].[SubTotal] = 
            (SELECT SUM([Purchasing].[PurchaseOrderDetail].[LineTotal])
                FROM [Purchasing].[PurchaseOrderDetail]
                WHERE [Purchasing].[PurchaseOrderHeader].[PurchaseOrderID] = [Purchasing].[PurchaseOrderDetail].[PurchaseOrderID])
        WHERE [Purchasing].[PurchaseOrderHeader].[PurchaseOrderID] IN (SELECT inserted.[PurchaseOrderID] FROM inserted);
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspPrintError];

        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO

CREATE TRIGGER [Purchasing].[uPurchaseOrderDetail] ON [Purchasing].[PurchaseOrderDetail] 
AFTER UPDATE AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
        IF UPDATE([ProductID]) OR UPDATE([OrderQty]) OR UPDATE([UnitPrice])
        -- Insert record into TransactionHistory 
        BEGIN
            INSERT INTO [Production].[TransactionHistory]
                ([ProductID]
                ,[ReferenceOrderID]
                ,[ReferenceOrderLineID]
                ,[TransactionType]
                ,[TransactionDate]
                ,[Quantity]
                ,[ActualCost])
            SELECT 
                inserted.[ProductID]
                ,inserted.[PurchaseOrderID]
                ,inserted.[PurchaseOrderDetailID]
                ,'P'
                ,GETDATE()
                ,inserted.[OrderQty]
                ,inserted.[UnitPrice]
            FROM inserted 
                INNER JOIN [Purchasing].[PurchaseOrderDetail] 
                ON inserted.[PurchaseOrderID] = [Purchasing].[PurchaseOrderDetail].[PurchaseOrderID];

            -- Update SubTotal in PurchaseOrderHeader record. Note that this causes the 
            -- PurchaseOrderHeader trigger to fire which will update the RevisionNumber.
            UPDATE [Purchasing].[PurchaseOrderHeader]
            SET [Purchasing].[PurchaseOrderHeader].[SubTotal] = 
                (SELECT SUM([Purchasing].[PurchaseOrderDetail].[LineTotal])
                    FROM [Purchasing].[PurchaseOrderDetail]
                    WHERE [Purchasing].[PurchaseOrderHeader].[PurchaseOrderID] 
                        = [Purchasing].[PurchaseOrderDetail].[PurchaseOrderID])
            WHERE [Purchasing].[PurchaseOrderHeader].[PurchaseOrderID] 
                IN (SELECT inserted.[PurchaseOrderID] FROM inserted);

            UPDATE [Purchasing].[PurchaseOrderDetail]
            SET [Purchasing].[PurchaseOrderDetail].[ModifiedDate] = GETDATE()
            FROM inserted
            WHERE inserted.[PurchaseOrderID] = [Purchasing].[PurchaseOrderDetail].[PurchaseOrderID]
                AND inserted.[PurchaseOrderDetailID] = [Purchasing].[PurchaseOrderDetail].[PurchaseOrderDetailID];
        END;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspPrintError];

        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO

CREATE TRIGGER [Purchasing].[uPurchaseOrderHeader] ON [Purchasing].[PurchaseOrderHeader] 
AFTER UPDATE AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
        -- Update RevisionNumber for modification of any field EXCEPT the Status.
        IF NOT UPDATE([Status])
        BEGIN
            UPDATE [Purchasing].[PurchaseOrderHeader]
            SET [Purchasing].[PurchaseOrderHeader].[RevisionNumber] = 
                [Purchasing].[PurchaseOrderHeader].[RevisionNumber] + 1
            WHERE [Purchasing].[PurchaseOrderHeader].[PurchaseOrderID] IN 
                (SELECT inserted.[PurchaseOrderID] FROM inserted);
        END;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspPrintError];

        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO

CREATE TRIGGER [Sales].[iduSalesOrderDetail] ON [Sales].[SalesOrderDetail] 
AFTER INSERT, DELETE, UPDATE AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
        -- If inserting or updating these columns
        IF UPDATE([ProductID]) OR UPDATE([OrderQty]) OR UPDATE([UnitPrice]) OR UPDATE([UnitPriceDiscount]) 
        -- Insert record into TransactionHistory
        BEGIN
            INSERT INTO [Production].[TransactionHistory]
                ([ProductID]
                ,[ReferenceOrderID]
                ,[ReferenceOrderLineID]
                ,[TransactionType]
                ,[TransactionDate]
                ,[Quantity]
                ,[ActualCost])
            SELECT 
                inserted.[ProductID]
                ,inserted.[SalesOrderID]
                ,inserted.[SalesOrderDetailID]
                ,'S'
                ,GETDATE()
                ,inserted.[OrderQty]
                ,inserted.[UnitPrice]
            FROM inserted 
                INNER JOIN [Sales].[SalesOrderHeader] 
                ON inserted.[SalesOrderID] = [Sales].[SalesOrderHeader].[SalesOrderID];

            UPDATE [Person].[Person] 
            SET [Demographics].modify('declare default element namespace 
                "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
                replace value of (/IndividualSurvey/TotalPurchaseYTD)[1] 
                with data(/IndividualSurvey/TotalPurchaseYTD)[1] + sql:column ("inserted.LineTotal")') 
            FROM inserted 
                INNER JOIN [Sales].[SalesOrderHeader] AS SOH
                ON inserted.[SalesOrderID] = SOH.[SalesOrderID] 
                INNER JOIN [Sales].[Customer] AS C
                ON SOH.[CustomerID] = C.[CustomerID]
            WHERE C.[PersonID] = [Person].[Person].[BusinessEntityID];
        END;

        -- Update SubTotal in SalesOrderHeader record. Note that this causes the 
        -- SalesOrderHeader trigger to fire which will update the RevisionNumber.
        UPDATE [Sales].[SalesOrderHeader]
        SET [Sales].[SalesOrderHeader].[SubTotal] = 
            (SELECT SUM([Sales].[SalesOrderDetail].[LineTotal])
                FROM [Sales].[SalesOrderDetail]
                WHERE [Sales].[SalesOrderHeader].[SalesOrderID] = [Sales].[SalesOrderDetail].[SalesOrderID])
        WHERE [Sales].[SalesOrderHeader].[SalesOrderID] IN (SELECT inserted.[SalesOrderID] FROM inserted);

        UPDATE [Person].[Person] 
        SET [Demographics].modify('declare default element namespace 
            "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
            replace value of (/IndividualSurvey/TotalPurchaseYTD)[1] 
            with data(/IndividualSurvey/TotalPurchaseYTD)[1] - sql:column("deleted.LineTotal")') 
        FROM deleted 
            INNER JOIN [Sales].[SalesOrderHeader] 
            ON deleted.[SalesOrderID] = [Sales].[SalesOrderHeader].[SalesOrderID] 
            INNER JOIN [Sales].[Customer]
            ON [Sales].[Customer].[CustomerID] = [Sales].[SalesOrderHeader].[CustomerID]
        WHERE [Sales].[Customer].[PersonID] = [Person].[Person].[BusinessEntityID];
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspPrintError];

        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO

CREATE TRIGGER [Sales].[uSalesOrderHeader] ON [Sales].[SalesOrderHeader] 
AFTER UPDATE NOT FOR REPLICATION AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
        -- Update RevisionNumber for modification of any field EXCEPT the Status.
        IF NOT UPDATE([Status])
        BEGIN
            UPDATE [Sales].[SalesOrderHeader]
            SET [Sales].[SalesOrderHeader].[RevisionNumber] = 
                [Sales].[SalesOrderHeader].[RevisionNumber] + 1
            WHERE [Sales].[SalesOrderHeader].[SalesOrderID] IN 
                (SELECT inserted.[SalesOrderID] FROM inserted);
        END;

        -- Update the SalesPerson SalesYTD when SubTotal is updated
        IF UPDATE([SubTotal])
        BEGIN
            DECLARE @StartDate datetime,
                    @EndDate datetime

            SET @StartDate = [dbo].[ufnGetAccountingStartDate]();
            SET @EndDate = [dbo].[ufnGetAccountingEndDate]();

            UPDATE [Sales].[SalesPerson]
            SET [Sales].[SalesPerson].[SalesYTD] = 
                (SELECT SUM([Sales].[SalesOrderHeader].[SubTotal])
                FROM [Sales].[SalesOrderHeader] 
                WHERE [Sales].[SalesPerson].[BusinessEntityID] = [Sales].[SalesOrderHeader].[SalesPersonID]
                    AND ([Sales].[SalesOrderHeader].[Status] = 5) -- Shipped
                    AND [Sales].[SalesOrderHeader].[OrderDate] BETWEEN @StartDate AND @EndDate)
            WHERE [Sales].[SalesPerson].[BusinessEntityID] 
                IN (SELECT DISTINCT inserted.[SalesPersonID] FROM inserted 
                    WHERE inserted.[OrderDate] BETWEEN @StartDate AND @EndDate);

            -- Update the SalesTerritory SalesYTD when SubTotal is updated
            UPDATE [Sales].[SalesTerritory]
            SET [Sales].[SalesTerritory].[SalesYTD] = 
                (SELECT SUM([Sales].[SalesOrderHeader].[SubTotal])
                FROM [Sales].[SalesOrderHeader] 
                WHERE [Sales].[SalesTerritory].[TerritoryID] = [Sales].[SalesOrderHeader].[TerritoryID]
                    AND ([Sales].[SalesOrderHeader].[Status] = 5) -- Shipped
                    AND [Sales].[SalesOrderHeader].[OrderDate] BETWEEN @StartDate AND @EndDate)
            WHERE [Sales].[SalesTerritory].[TerritoryID] 
                IN (SELECT DISTINCT inserted.[TerritoryID] FROM inserted 
                    WHERE inserted.[OrderDate] BETWEEN @StartDate AND @EndDate);
        END;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspPrintError];

        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO

CREATE TRIGGER [Purchasing].[dVendor] ON [Purchasing].[Vendor] 
INSTEAD OF DELETE NOT FOR REPLICATION AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @DeleteCount int;

        SELECT @DeleteCount = COUNT(*) FROM deleted;
        IF @DeleteCount > 0 
        BEGIN
            RAISERROR
                (N'Vendors cannot be deleted. They can only be marked as not active.', -- Message
                10, -- Severity.
                1); -- State.

        -- Rollback any active or uncommittable transactions
            IF @@TRANCOUNT > 0
            BEGIN
                ROLLBACK TRANSACTION;
            END
        END;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspPrintError];

        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO

CREATE TRIGGER [Production].[iWorkOrder] ON [Production].[WorkOrder] 
AFTER INSERT AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO [Production].[TransactionHistory](
            [ProductID]
            ,[ReferenceOrderID]
            ,[TransactionType]
            ,[TransactionDate]
            ,[Quantity]
            ,[ActualCost])
        SELECT 
            inserted.[ProductID]
            ,inserted.[WorkOrderID]
            ,'W'
            ,GETDATE()
            ,inserted.[OrderQty]
            ,0
        FROM inserted;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspPrintError];

        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO

CREATE TRIGGER [Production].[uWorkOrder] ON [Production].[WorkOrder] 
AFTER UPDATE AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
        IF UPDATE([ProductID]) OR UPDATE([OrderQty])
        BEGIN
            INSERT INTO [Production].[TransactionHistory](
                [ProductID]
                ,[ReferenceOrderID]
                ,[TransactionType]
                ,[TransactionDate]
                ,[Quantity])
            SELECT 
                inserted.[ProductID]
                ,inserted.[WorkOrderID]
                ,'W'
                ,GETDATE()
                ,inserted.[OrderQty]
            FROM inserted;
        END;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspPrintError];

        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO


-- ******************************************************
-- Add database views.
-- ******************************************************
PRINT '';
PRINT '*** Creating Table Views';
GO

CREATE VIEW [Person].[vAdditionalContactInfo] 
AS 
SELECT 
    [BusinessEntityID] 
    ,[FirstName]
    ,[MiddleName]
    ,[LastName]
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:telephoneNumber)[1]/act:number', 'nvarchar(50)') AS [TelephoneNumber] 
    ,LTRIM(RTRIM([ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:telephoneNumber/act:SpecialInstructions/text())[1]', 'nvarchar(max)'))) AS [TelephoneSpecialInstructions] 
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes";
        (act:homePostalAddress/act:Street)[1]', 'nvarchar(50)') AS [Street] 
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:homePostalAddress/act:City)[1]', 'nvarchar(50)') AS [City] 
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:homePostalAddress/act:StateProvince)[1]', 'nvarchar(50)') AS [StateProvince] 
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:homePostalAddress/act:PostalCode)[1]', 'nvarchar(50)') AS [PostalCode] 
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:homePostalAddress/act:CountryRegion)[1]', 'nvarchar(50)') AS [CountryRegion] 
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:homePostalAddress/act:SpecialInstructions/text())[1]', 'nvarchar(max)') AS [HomeAddressSpecialInstructions] 
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:eMail/act:eMailAddress)[1]', 'nvarchar(128)') AS [EMailAddress] 
    ,LTRIM(RTRIM([ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:eMail/act:SpecialInstructions/text())[1]', 'nvarchar(max)'))) AS [EMailSpecialInstructions] 
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:eMail/act:SpecialInstructions/act:telephoneNumber/act:number)[1]', 'nvarchar(50)') AS [EMailTelephoneNumber] 
    ,[rowguid] 
    ,[ModifiedDate]
FROM [Person].[Person]
OUTER APPLY [AdditionalContactInfo].nodes(
    'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
    /ci:AdditionalContactInfo') AS ContactInfo(ref) 
WHERE [AdditionalContactInfo] IS NOT NULL;
GO

CREATE VIEW [HumanResources].[vEmployee] 
AS 
SELECT 
    e.[BusinessEntityID]
    ,p.[Title]
    ,p.[FirstName]
    ,p.[MiddleName]
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
    ,sp.[Name] AS [StateProvinceName] 
    ,a.[PostalCode]
    ,cr.[Name] AS [CountryRegionName] 
    ,p.[AdditionalContactInfo]
FROM [HumanResources].[Employee] e
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = e.[BusinessEntityID]
    INNER JOIN [Person].[BusinessEntityAddress] bea 
    ON bea.[BusinessEntityID] = e.[BusinessEntityID] 
    INNER JOIN [Person].[Address] a 
    ON a.[AddressID] = bea.[AddressID]
    INNER JOIN [Person].[StateProvince] sp 
    ON sp.[StateProvinceID] = a.[StateProvinceID]
    INNER JOIN [Person].[CountryRegion] cr 
    ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
    LEFT OUTER JOIN [Person].[PersonPhone] pp
    ON pp.BusinessEntityID = p.[BusinessEntityID]
    LEFT OUTER JOIN [Person].[PhoneNumberType] pnt
    ON pp.[PhoneNumberTypeID] = pnt.[PhoneNumberTypeID]
    LEFT OUTER JOIN [Person].[EmailAddress] ea
    ON p.[BusinessEntityID] = ea.[BusinessEntityID];
GO

CREATE VIEW [HumanResources].[vEmployeeDepartment] 
AS 
SELECT 
    e.[BusinessEntityID] 
    ,p.[Title] 
    ,p.[FirstName] 
    ,p.[MiddleName] 
    ,p.[LastName] 
    ,p.[Suffix] 
    ,e.[JobTitle]
    ,d.[Name] AS [Department] 
    ,d.[GroupName] 
    ,edh.[StartDate] 
FROM [HumanResources].[Employee] e
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = e.[BusinessEntityID]
    INNER JOIN [HumanResources].[EmployeeDepartmentHistory] edh 
    ON e.[BusinessEntityID] = edh.[BusinessEntityID] 
    INNER JOIN [HumanResources].[Department] d 
    ON edh.[DepartmentID] = d.[DepartmentID] 
WHERE edh.EndDate IS NULL
GO

CREATE VIEW [HumanResources].[vEmployeeDepartmentHistory] 
AS 
SELECT 
    e.[BusinessEntityID] 
    ,p.[Title] 
    ,p.[FirstName] 
    ,p.[MiddleName] 
    ,p.[LastName] 
    ,p.[Suffix] 
    ,s.[Name] AS [Shift]
    ,d.[Name] AS [Department] 
    ,d.[GroupName] 
    ,edh.[StartDate] 
    ,edh.[EndDate]
FROM [HumanResources].[Employee] e
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = e.[BusinessEntityID]
    INNER JOIN [HumanResources].[EmployeeDepartmentHistory] edh 
    ON e.[BusinessEntityID] = edh.[BusinessEntityID] 
    INNER JOIN [HumanResources].[Department] d 
    ON edh.[DepartmentID] = d.[DepartmentID] 
    INNER JOIN [HumanResources].[Shift] s
    ON s.[ShiftID] = edh.[ShiftID];
GO

CREATE VIEW [Sales].[vIndividualCustomer] 
AS 
SELECT 
    p.[BusinessEntityID]
    ,p.[Title]
    ,p.[FirstName]
    ,p.[MiddleName]
    ,p.[LastName]
    ,p.[Suffix]
    ,pp.[PhoneNumber]
	,pnt.[Name] AS [PhoneNumberType]
    ,ea.[EmailAddress]
    ,p.[EmailPromotion]
    ,at.[Name] AS [AddressType]
    ,a.[AddressLine1]
    ,a.[AddressLine2]
    ,a.[City]
    ,[StateProvinceName] = sp.[Name]
    ,a.[PostalCode]
    ,[CountryRegionName] = cr.[Name]
    ,p.[Demographics]
FROM [Person].[Person] p
    INNER JOIN [Person].[BusinessEntityAddress] bea 
    ON bea.[BusinessEntityID] = p.[BusinessEntityID] 
    INNER JOIN [Person].[Address] a 
    ON a.[AddressID] = bea.[AddressID]
    INNER JOIN [Person].[StateProvince] sp 
    ON sp.[StateProvinceID] = a.[StateProvinceID]
    INNER JOIN [Person].[CountryRegion] cr 
    ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
    INNER JOIN [Person].[AddressType] at 
    ON at.[AddressTypeID] = bea.[AddressTypeID]
	INNER JOIN [Sales].[Customer] c
	ON c.[PersonID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[EmailAddress] ea
	ON ea.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PersonPhone] pp
	ON pp.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PhoneNumberType] pnt
	ON pnt.[PhoneNumberTypeID] = pp.[PhoneNumberTypeID]
WHERE c.StoreID IS NULL;
GO

CREATE VIEW [Sales].[vPersonDemographics] 
AS 
SELECT 
    p.[BusinessEntityID] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        TotalPurchaseYTD[1]', 'money') AS [TotalPurchaseYTD] 
    ,CONVERT(datetime, REPLACE([IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        DateFirstPurchase[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [DateFirstPurchase] 
    ,CONVERT(datetime, REPLACE([IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        BirthDate[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [BirthDate] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        MaritalStatus[1]', 'nvarchar(1)') AS [MaritalStatus] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        YearlyIncome[1]', 'nvarchar(30)') AS [YearlyIncome] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        Gender[1]', 'nvarchar(1)') AS [Gender] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        TotalChildren[1]', 'integer') AS [TotalChildren] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        NumberChildrenAtHome[1]', 'integer') AS [NumberChildrenAtHome] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        Education[1]', 'nvarchar(30)') AS [Education] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        Occupation[1]', 'nvarchar(30)') AS [Occupation] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        HomeOwnerFlag[1]', 'bit') AS [HomeOwnerFlag] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        NumberCarsOwned[1]', 'integer') AS [NumberCarsOwned] 
FROM [Person].[Person] p 
CROSS APPLY p.[Demographics].nodes(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
    /IndividualSurvey') AS [IndividualSurvey](ref) 
WHERE [Demographics] IS NOT NULL;
GO

CREATE VIEW [HumanResources].[vJobCandidate] 
AS 
SELECT 
    jc.[JobCandidateID] 
    ,jc.[BusinessEntityID] 
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (/Resume/Name/Name.Prefix)[1]', 'nvarchar(30)') AS [Name.Prefix] 
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (/Resume/Name/Name.First)[1]', 'nvarchar(30)') AS [Name.First] 
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (/Resume/Name/Name.Middle)[1]', 'nvarchar(30)') AS [Name.Middle] 
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (/Resume/Name/Name.Last)[1]', 'nvarchar(30)') AS [Name.Last] 
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (/Resume/Name/Name.Suffix)[1]', 'nvarchar(30)') AS [Name.Suffix] 
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (/Resume/Skills)[1]', 'nvarchar(max)') AS [Skills] 
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Address/Addr.Type)[1]', 'nvarchar(30)') AS [Addr.Type]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Address/Addr.Location/Location/Loc.CountryRegion)[1]', 'nvarchar(100)') AS [Addr.Loc.CountryRegion]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Address/Addr.Location/Location/Loc.State)[1]', 'nvarchar(100)') AS [Addr.Loc.State]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Address/Addr.Location/Location/Loc.City)[1]', 'nvarchar(100)') AS [Addr.Loc.City]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Address/Addr.PostalCode)[1]', 'nvarchar(20)') AS [Addr.PostalCode]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (/Resume/EMail)[1]', 'nvarchar(max)') AS [EMail] 
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (/Resume/WebSite)[1]', 'nvarchar(max)') AS [WebSite] 
    ,jc.[ModifiedDate] 
FROM [HumanResources].[JobCandidate] jc 
CROSS APPLY jc.[Resume].nodes(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
    /Resume') AS Resume(ref);
GO

CREATE VIEW [HumanResources].[vJobCandidateEmployment] 
AS 
SELECT 
    jc.[JobCandidateID] 
    ,CONVERT(datetime, REPLACE([Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.StartDate)[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [Emp.StartDate] 
    ,CONVERT(datetime, REPLACE([Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.EndDate)[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [Emp.EndDate] 
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.OrgName)[1]', 'nvarchar(100)') AS [Emp.OrgName]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.JobTitle)[1]', 'nvarchar(100)') AS [Emp.JobTitle]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.Responsibility)[1]', 'nvarchar(max)') AS [Emp.Responsibility]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.FunctionCategory)[1]', 'nvarchar(max)') AS [Emp.FunctionCategory]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.IndustryCategory)[1]', 'nvarchar(max)') AS [Emp.IndustryCategory]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.Location/Location/Loc.CountryRegion)[1]', 'nvarchar(max)') AS [Emp.Loc.CountryRegion]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.Location/Location/Loc.State)[1]', 'nvarchar(max)') AS [Emp.Loc.State]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.Location/Location/Loc.City)[1]', 'nvarchar(max)') AS [Emp.Loc.City]
FROM [HumanResources].[JobCandidate] jc 
CROSS APPLY jc.[Resume].nodes(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
    /Resume/Employment') AS Employment(ref);
GO

CREATE VIEW [HumanResources].[vJobCandidateEducation] 
AS 
SELECT 
    jc.[JobCandidateID] 
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.Level)[1]', 'nvarchar(max)') AS [Edu.Level]
    ,CONVERT(datetime, REPLACE([Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.StartDate)[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [Edu.StartDate] 
    ,CONVERT(datetime, REPLACE([Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.EndDate)[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [Edu.EndDate] 
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.Degree)[1]', 'nvarchar(50)') AS [Edu.Degree]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.Major)[1]', 'nvarchar(50)') AS [Edu.Major]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.Minor)[1]', 'nvarchar(50)') AS [Edu.Minor]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.GPA)[1]', 'nvarchar(5)') AS [Edu.GPA]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.GPAScale)[1]', 'nvarchar(5)') AS [Edu.GPAScale]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.School)[1]', 'nvarchar(100)') AS [Edu.School]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.Location/Location/Loc.CountryRegion)[1]', 'nvarchar(100)') AS [Edu.Loc.CountryRegion]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.Location/Location/Loc.State)[1]', 'nvarchar(100)') AS [Edu.Loc.State]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.Location/Location/Loc.City)[1]', 'nvarchar(100)') AS [Edu.Loc.City]
FROM [HumanResources].[JobCandidate] jc 
CROSS APPLY jc.[Resume].nodes(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
    /Resume/Education') AS [Education](ref);
GO

CREATE VIEW [Production].[vProductAndDescription] 
WITH SCHEMABINDING 
AS 
-- View (indexed or standard) to display products and product descriptions by language.
SELECT 
    p.[ProductID] 
    ,p.[Name] 
    ,pm.[Name] AS [ProductModel] 
    ,pmx.[CultureID] 
    ,pd.[Description] 
FROM [Production].[Product] p 
    INNER JOIN [Production].[ProductModel] pm 
    ON p.[ProductModelID] = pm.[ProductModelID] 
    INNER JOIN [Production].[ProductModelProductDescriptionCulture] pmx 
    ON pm.[ProductModelID] = pmx.[ProductModelID] 
    INNER JOIN [Production].[ProductDescription] pd 
    ON pmx.[ProductDescriptionID] = pd.[ProductDescriptionID];
GO

-- Index the vProductAndDescription view
CREATE UNIQUE CLUSTERED INDEX [IX_vProductAndDescription] ON [Production].[vProductAndDescription]([CultureID], [ProductID]);
GO

CREATE VIEW [Production].[vProductModelCatalogDescription] 
AS 
SELECT 
    [ProductModelID] 
    ,[Name] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace html="http://www.w3.org/1999/xhtml"; 
        (/p1:ProductDescription/p1:Summary/html:p)[1]', 'nvarchar(max)') AS [Summary] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Manufacturer/p1:Name)[1]', 'nvarchar(max)') AS [Manufacturer] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Manufacturer/p1:Copyright)[1]', 'nvarchar(30)') AS [Copyright] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Manufacturer/p1:ProductURL)[1]', 'nvarchar(256)') AS [ProductURL] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain"; 
        (/p1:ProductDescription/p1:Features/wm:Warranty/wm:WarrantyPeriod)[1]', 'nvarchar(256)') AS [WarrantyPeriod] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain"; 
        (/p1:ProductDescription/p1:Features/wm:Warranty/wm:Description)[1]', 'nvarchar(256)') AS [WarrantyDescription] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain"; 
        (/p1:ProductDescription/p1:Features/wm:Maintenance/wm:NoOfYears)[1]', 'nvarchar(256)') AS [NoOfYears] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain"; 
        (/p1:ProductDescription/p1:Features/wm:Maintenance/wm:Description)[1]', 'nvarchar(256)') AS [MaintenanceDescription] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures"; 
        (/p1:ProductDescription/p1:Features/wf:wheel)[1]', 'nvarchar(256)') AS [Wheel] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures"; 
        (/p1:ProductDescription/p1:Features/wf:saddle)[1]', 'nvarchar(256)') AS [Saddle] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures"; 
        (/p1:ProductDescription/p1:Features/wf:pedal)[1]', 'nvarchar(256)') AS [Pedal] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures"; 
        (/p1:ProductDescription/p1:Features/wf:BikeFrame)[1]', 'nvarchar(max)') AS [BikeFrame] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures"; 
        (/p1:ProductDescription/p1:Features/wf:crankset)[1]', 'nvarchar(256)') AS [Crankset] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Picture/p1:Angle)[1]', 'nvarchar(256)') AS [PictureAngle] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Picture/p1:Size)[1]', 'nvarchar(256)') AS [PictureSize] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Picture/p1:ProductPhotoID)[1]', 'nvarchar(256)') AS [ProductPhotoID] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Specifications/Material)[1]', 'nvarchar(256)') AS [Material] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Specifications/Color)[1]', 'nvarchar(256)') AS [Color] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Specifications/ProductLine)[1]', 'nvarchar(256)') AS [ProductLine] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Specifications/Style)[1]', 'nvarchar(256)') AS [Style] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Specifications/RiderExperience)[1]', 'nvarchar(1024)') AS [RiderExperience] 
    ,[rowguid] 
    ,[ModifiedDate]
FROM [Production].[ProductModel] 
WHERE [CatalogDescription] IS NOT NULL;
GO

CREATE VIEW [Production].[vProductModelInstructions] 
AS 
SELECT 
    [ProductModelID] 
    ,[Name] 
    ,[Instructions].value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions"; 
        (/root/text())[1]', 'nvarchar(max)') AS [Instructions] 
    ,[MfgInstructions].ref.value('@LocationID[1]', 'int') AS [LocationID] 
    ,[MfgInstructions].ref.value('@SetupHours[1]', 'decimal(9, 4)') AS [SetupHours] 
    ,[MfgInstructions].ref.value('@MachineHours[1]', 'decimal(9, 4)') AS [MachineHours] 
    ,[MfgInstructions].ref.value('@LaborHours[1]', 'decimal(9, 4)') AS [LaborHours] 
    ,[MfgInstructions].ref.value('@LotSize[1]', 'int') AS [LotSize] 
    ,[Steps].ref.value('string(.)[1]', 'nvarchar(1024)') AS [Step] 
    ,[rowguid] 
    ,[ModifiedDate]
FROM [Production].[ProductModel] 
CROSS APPLY [Instructions].nodes(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions"; 
    /root/Location') MfgInstructions(ref)
CROSS APPLY [MfgInstructions].ref.nodes('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions"; 
    step') Steps(ref);
GO

CREATE VIEW [Sales].[vSalesPerson] 
AS 
SELECT 
    s.[BusinessEntityID]
    ,p.[Title]
    ,p.[FirstName]
    ,p.[MiddleName]
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
GO

CREATE VIEW [Sales].[vSalesPersonSalesByFiscalYears] 
AS 
SELECT 
    pvt.[SalesPersonID]
    ,pvt.[FullName]
    ,pvt.[JobTitle]
    ,pvt.[SalesTerritory]
    ,pvt.[2002]
    ,pvt.[2003]
    ,pvt.[2004] 
FROM (SELECT 
        soh.[SalesPersonID]
        ,p.[FirstName] + ' ' + COALESCE(p.[MiddleName], '') + ' ' + p.[LastName] AS [FullName]
        ,e.[JobTitle]
        ,st.[Name] AS [SalesTerritory]
        ,soh.[SubTotal]
        ,YEAR(DATEADD(m, 6, soh.[OrderDate])) AS [FiscalYear] 
    FROM [Sales].[SalesPerson] sp 
        INNER JOIN [Sales].[SalesOrderHeader] soh 
        ON sp.[BusinessEntityID] = soh.[SalesPersonID]
        INNER JOIN [Sales].[SalesTerritory] st 
        ON sp.[TerritoryID] = st.[TerritoryID] 
        INNER JOIN [HumanResources].[Employee] e 
        ON soh.[SalesPersonID] = e.[BusinessEntityID] 
		INNER JOIN [Person].[Person] p
		ON p.[BusinessEntityID] = sp.[BusinessEntityID]
	 ) AS soh 
PIVOT 
(
    SUM([SubTotal]) 
    FOR [FiscalYear] 
    IN ([2002], [2003], [2004])
) AS pvt;
GO

CREATE VIEW [Person].[vStateProvinceCountryRegion] 
WITH SCHEMABINDING 
AS 
SELECT 
    sp.[StateProvinceID] 
    ,sp.[StateProvinceCode] 
    ,sp.[IsOnlyStateProvinceFlag] 
    ,sp.[Name] AS [StateProvinceName] 
    ,sp.[TerritoryID] 
    ,cr.[CountryRegionCode] 
    ,cr.[Name] AS [CountryRegionName]
FROM [Person].[StateProvince] sp 
    INNER JOIN [Person].[CountryRegion] cr 
    ON sp.[CountryRegionCode] = cr.[CountryRegionCode];
GO

-- Index the vStateProvinceCountryRegion view
CREATE UNIQUE CLUSTERED INDEX [IX_vStateProvinceCountryRegion] ON [Person].[vStateProvinceCountryRegion]([StateProvinceID], [CountryRegionCode]);
GO

CREATE VIEW [Sales].[vStoreWithDemographics] AS 
SELECT 
    s.[BusinessEntityID] 
    ,s.[Name] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/AnnualSales)[1]', 'money') AS [AnnualSales] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/AnnualRevenue)[1]', 'money') AS [AnnualRevenue] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/BankName)[1]', 'nvarchar(50)') AS [BankName] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/BusinessType)[1]', 'nvarchar(5)') AS [BusinessType] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/YearOpened)[1]', 'integer') AS [YearOpened] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/Specialty)[1]', 'nvarchar(50)') AS [Specialty] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/SquareFeet)[1]', 'integer') AS [SquareFeet] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/Brands)[1]', 'nvarchar(30)') AS [Brands] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/Internet)[1]', 'nvarchar(30)') AS [Internet] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/NumberEmployees)[1]', 'integer') AS [NumberEmployees] 
FROM [Sales].[Store] s;
GO

CREATE VIEW [Sales].[vStoreWithContacts] AS 
SELECT 
    s.[BusinessEntityID] 
    ,s.[Name] 
    ,ct.[Name] AS [ContactType] 
    ,p.[Title] 
    ,p.[FirstName] 
    ,p.[MiddleName] 
    ,p.[LastName] 
    ,p.[Suffix] 
    ,pp.[PhoneNumber] 
	,pnt.[Name] AS [PhoneNumberType]
    ,ea.[EmailAddress] 
    ,p.[EmailPromotion] 
FROM [Sales].[Store] s
    INNER JOIN [Person].[BusinessEntityContact] bec 
    ON bec.[BusinessEntityID] = s.[BusinessEntityID]
	INNER JOIN [Person].[ContactType] ct
	ON ct.[ContactTypeID] = bec.[ContactTypeID]
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = bec.[PersonID]
	LEFT OUTER JOIN [Person].[EmailAddress] ea
	ON ea.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PersonPhone] pp
	ON pp.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PhoneNumberType] pnt
	ON pnt.[PhoneNumberTypeID] = pp.[PhoneNumberTypeID];
GO

CREATE VIEW [Sales].[vStoreWithAddresses] AS 
SELECT 
    s.[BusinessEntityID] 
    ,s.[Name] 
    ,at.[Name] AS [AddressType]
    ,a.[AddressLine1] 
    ,a.[AddressLine2] 
    ,a.[City] 
    ,sp.[Name] AS [StateProvinceName] 
    ,a.[PostalCode] 
    ,cr.[Name] AS [CountryRegionName] 
FROM [Sales].[Store] s
    INNER JOIN [Person].[BusinessEntityAddress] bea 
    ON bea.[BusinessEntityID] = s.[BusinessEntityID] 
    INNER JOIN [Person].[Address] a 
    ON a.[AddressID] = bea.[AddressID]
    INNER JOIN [Person].[StateProvince] sp 
    ON sp.[StateProvinceID] = a.[StateProvinceID]
    INNER JOIN [Person].[CountryRegion] cr 
    ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
    INNER JOIN [Person].[AddressType] at 
    ON at.[AddressTypeID] = bea.[AddressTypeID];
GO

CREATE VIEW [Purchasing].[vVendorWithContacts] AS 
SELECT 
    v.[BusinessEntityID]
    ,v.[Name]
    ,ct.[Name] AS [ContactType] 
    ,p.[Title] 
    ,p.[FirstName] 
    ,p.[MiddleName] 
    ,p.[LastName] 
    ,p.[Suffix] 
    ,pp.[PhoneNumber] 
	,pnt.[Name] AS [PhoneNumberType]
    ,ea.[EmailAddress] 
    ,p.[EmailPromotion] 
FROM [Purchasing].[Vendor] v
    INNER JOIN [Person].[BusinessEntityContact] bec 
    ON bec.[BusinessEntityID] = v.[BusinessEntityID]
	INNER JOIN [Person].ContactType ct
	ON ct.[ContactTypeID] = bec.[ContactTypeID]
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = bec.[PersonID]
	LEFT OUTER JOIN [Person].[EmailAddress] ea
	ON ea.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PersonPhone] pp
	ON pp.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PhoneNumberType] pnt
	ON pnt.[PhoneNumberTypeID] = pp.[PhoneNumberTypeID];
GO

CREATE VIEW [Purchasing].[vVendorWithAddresses] AS 
SELECT 
    v.[BusinessEntityID]
    ,v.[Name]
    ,at.[Name] AS [AddressType]
    ,a.[AddressLine1] 
    ,a.[AddressLine2] 
    ,a.[City] 
    ,sp.[Name] AS [StateProvinceName] 
    ,a.[PostalCode] 
    ,cr.[Name] AS [CountryRegionName] 
FROM [Purchasing].[Vendor] v
    INNER JOIN [Person].[BusinessEntityAddress] bea 
    ON bea.[BusinessEntityID] = v.[BusinessEntityID] 
    INNER JOIN [Person].[Address] a 
    ON a.[AddressID] = bea.[AddressID]
    INNER JOIN [Person].[StateProvince] sp 
    ON sp.[StateProvinceID] = a.[StateProvinceID]
    INNER JOIN [Person].[CountryRegion] cr 
    ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
    INNER JOIN [Person].[AddressType] at 
    ON at.[AddressTypeID] = bea.[AddressTypeID];
GO

-- ******************************************************
-- Add database functions.
-- ******************************************************
PRINT '';
PRINT '*** Creating Database Functions';
GO

CREATE FUNCTION [dbo].[ufnGetAccountingStartDate]()
RETURNS [datetime] 
AS 
BEGIN
    RETURN CONVERT(datetime, '20030701', 112);
END;
GO

CREATE FUNCTION [dbo].[ufnGetAccountingEndDate]()
RETURNS [datetime] 
AS 
BEGIN
    RETURN DATEADD(millisecond, -2, CONVERT(datetime, '20040701', 112));
END;
GO

CREATE FUNCTION [dbo].[ufnGetContactInformation](@PersonID int)
RETURNS @retContactInformation TABLE 
(
    -- Columns returned by the function
    [PersonID] int NOT NULL, 
    [FirstName] [nvarchar](50) NULL, 
    [LastName] [nvarchar](50) NULL, 
	[JobTitle] [nvarchar](50) NULL,
    [BusinessEntityType] [nvarchar](50) NULL
)
AS 
-- Returns the first name, last name, job title and business entity type for the specified contact.
-- Since a contact can serve multiple roles, more than one row may be returned.
BEGIN
	IF @PersonID IS NOT NULL 
		BEGIN
		IF EXISTS(SELECT * FROM [HumanResources].[Employee] e 
					WHERE e.[BusinessEntityID] = @PersonID) 
			INSERT INTO @retContactInformation
				SELECT @PersonID, p.FirstName, p.LastName, e.[JobTitle], 'Employee'
				FROM [HumanResources].[Employee] AS e
					INNER JOIN [Person].[Person] p
					ON p.[BusinessEntityID] = e.[BusinessEntityID]
				WHERE e.[BusinessEntityID] = @PersonID;

		IF EXISTS(SELECT * FROM [Purchasing].[Vendor] AS v
					INNER JOIN [Person].[BusinessEntityContact] bec 
					ON bec.[BusinessEntityID] = v.[BusinessEntityID]
					WHERE bec.[PersonID] = @PersonID)
			INSERT INTO @retContactInformation
				SELECT @PersonID, p.FirstName, p.LastName, ct.[Name], 'Vendor Contact' 
				FROM [Purchasing].[Vendor] AS v
					INNER JOIN [Person].[BusinessEntityContact] bec 
					ON bec.[BusinessEntityID] = v.[BusinessEntityID]
					INNER JOIN [Person].ContactType ct
					ON ct.[ContactTypeID] = bec.[ContactTypeID]
					INNER JOIN [Person].[Person] p
					ON p.[BusinessEntityID] = bec.[PersonID]
				WHERE bec.[PersonID] = @PersonID;
		
		IF EXISTS(SELECT * FROM [Sales].[Store] AS s
					INNER JOIN [Person].[BusinessEntityContact] bec 
					ON bec.[BusinessEntityID] = s.[BusinessEntityID]
					WHERE bec.[PersonID] = @PersonID)
			INSERT INTO @retContactInformation
				SELECT @PersonID, p.FirstName, p.LastName, ct.[Name], 'Store Contact' 
				FROM [Sales].[Store] AS s
					INNER JOIN [Person].[BusinessEntityContact] bec 
					ON bec.[BusinessEntityID] = s.[BusinessEntityID]
					INNER JOIN [Person].ContactType ct
					ON ct.[ContactTypeID] = bec.[ContactTypeID]
					INNER JOIN [Person].[Person] p
					ON p.[BusinessEntityID] = bec.[PersonID]
				WHERE bec.[PersonID] = @PersonID;

		IF EXISTS(SELECT * FROM [Person].[Person] AS p
					INNER JOIN [Sales].[Customer] AS c
					ON c.[PersonID] = p.[BusinessEntityID]
					WHERE p.[BusinessEntityID] = @PersonID AND c.[StoreID] IS NULL) 
			INSERT INTO @retContactInformation
				SELECT @PersonID, p.FirstName, p.LastName, NULL, 'Consumer' 
				FROM [Person].[Person] AS p
					INNER JOIN [Sales].[Customer] AS c
					ON c.[PersonID] = p.[BusinessEntityID]
					WHERE p.[BusinessEntityID] = @PersonID AND c.[StoreID] IS NULL; 
		END

	RETURN;
END;
GO



CREATE FUNCTION [dbo].[ufnGetProductDealerPrice](@ProductID [int], @OrderDate [datetime])
RETURNS [money] 
AS 
-- Returns the dealer price for the product on a specific date.
BEGIN
    DECLARE @DealerPrice money;
    DECLARE @DealerDiscount money;

    SET @DealerDiscount = 0.60  -- 60% of list price

    SELECT @DealerPrice = plph.[ListPrice] * @DealerDiscount 
    FROM [Production].[Product] p 
        INNER JOIN [Production].[ProductListPriceHistory] plph 
        ON p.[ProductID] = plph.[ProductID] 
            AND p.[ProductID] = @ProductID 
            AND @OrderDate BETWEEN plph.[StartDate] AND COALESCE(plph.[EndDate], CONVERT(datetime, '99991231', 112)); -- Make sure we get all the prices!

    RETURN @DealerPrice;
END;
GO

CREATE FUNCTION [dbo].[ufnGetProductListPrice](@ProductID [int], @OrderDate [datetime])
RETURNS [money] 
AS 
BEGIN
    DECLARE @ListPrice money;

    SELECT @ListPrice = plph.[ListPrice] 
    FROM [Production].[Product] p 
        INNER JOIN [Production].[ProductListPriceHistory] plph 
        ON p.[ProductID] = plph.[ProductID] 
            AND p.[ProductID] = @ProductID 
            AND @OrderDate BETWEEN plph.[StartDate] AND COALESCE(plph.[EndDate], CONVERT(datetime, '99991231', 112)); -- Make sure we get all the prices!

    RETURN @ListPrice;
END;
GO

CREATE FUNCTION [dbo].[ufnGetProductStandardCost](@ProductID [int], @OrderDate [datetime])
RETURNS [money] 
AS 
-- Returns the standard cost for the product on a specific date.
BEGIN
    DECLARE @StandardCost money;

    SELECT @StandardCost = pch.[StandardCost] 
    FROM [Production].[Product] p 
        INNER JOIN [Production].[ProductCostHistory] pch 
        ON p.[ProductID] = pch.[ProductID] 
            AND p.[ProductID] = @ProductID 
            AND @OrderDate BETWEEN pch.[StartDate] AND COALESCE(pch.[EndDate], CONVERT(datetime, '99991231', 112)); -- Make sure we get all the prices!

    RETURN @StandardCost;
END;
GO

CREATE FUNCTION [dbo].[ufnGetStock](@ProductID [int])
RETURNS [int] 
AS 
-- Returns the stock level for the product. This function is used internally only
BEGIN
    DECLARE @ret int;
    
    SELECT @ret = SUM(p.[Quantity]) 
    FROM [Production].[ProductInventory] p 
    WHERE p.[ProductID] = @ProductID 
        AND p.[LocationID] = '6'; -- Only look at inventory in the misc storage
    
    IF (@ret IS NULL) 
        SET @ret = 0
    
    RETURN @ret
END;
GO

CREATE FUNCTION [dbo].[ufnGetDocumentStatusText](@Status [tinyint])
RETURNS [nvarchar](16) 
AS 
-- Returns the sales order status text representation for the status value.
BEGIN
    DECLARE @ret [nvarchar](16);

    SET @ret = 
        CASE @Status
            WHEN 1 THEN N'Pending approval'
            WHEN 2 THEN N'Approved'
            WHEN 3 THEN N'Obsolete'
            ELSE N'** Invalid **'
        END;
    
    RETURN @ret
END;
GO

CREATE FUNCTION [dbo].[ufnGetPurchaseOrderStatusText](@Status [tinyint])
RETURNS [nvarchar](15) 
AS 
-- Returns the sales order status text representation for the status value.
BEGIN
    DECLARE @ret [nvarchar](15);

    SET @ret = 
        CASE @Status
            WHEN 1 THEN 'Pending'
            WHEN 2 THEN 'Approved'
            WHEN 3 THEN 'Rejected'
            WHEN 4 THEN 'Complete'
            ELSE '** Invalid **'
        END;
    
    RETURN @ret
END;
GO

CREATE FUNCTION [dbo].[ufnGetSalesOrderStatusText](@Status [tinyint])
RETURNS [nvarchar](15) 
AS 
-- Returns the sales order status text representation for the status value.
BEGIN
    DECLARE @ret [nvarchar](15);

    SET @ret = 
        CASE @Status
            WHEN 1 THEN 'In process'
            WHEN 2 THEN 'Approved'
            WHEN 3 THEN 'Backordered'
            WHEN 4 THEN 'Rejected'
            WHEN 5 THEN 'Shipped'
            WHEN 6 THEN 'Cancelled'
            ELSE '** Invalid **'
        END;
    
    RETURN @ret
END;
GO


-- ******************************************************
-- Create stored procedures
-- ******************************************************
PRINT '';
PRINT '*** Creating Stored Procedures';
GO

CREATE PROCEDURE [dbo].[uspGetBillOfMaterials]
    @StartProductID [int],
    @CheckDate [datetime]
AS
BEGIN
    SET NOCOUNT ON;

    -- Use recursive query to generate a multi-level Bill of Material (i.e. all level 1 
    -- components of a level 0 assembly, all level 2 components of a level 1 assembly)
    -- The CheckDate eliminates any components that are no longer used in the product on this date.
    WITH [BOM_cte]([ProductAssemblyID], [ComponentID], [ComponentDesc], [PerAssemblyQty], [StandardCost], [ListPrice], [BOMLevel], [RecursionLevel]) -- CTE name and columns
    AS (
        SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], 0 -- Get the initial list of components for the bike assembly
        FROM [Production].[BillOfMaterials] b
            INNER JOIN [Production].[Product] p 
            ON b.[ComponentID] = p.[ProductID] 
        WHERE b.[ProductAssemblyID] = @StartProductID 
            AND @CheckDate >= b.[StartDate] 
            AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)
        UNION ALL
        SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], [RecursionLevel] + 1 -- Join recursive member to anchor
        FROM [BOM_cte] cte
            INNER JOIN [Production].[BillOfMaterials] b 
            ON b.[ProductAssemblyID] = cte.[ComponentID]
            INNER JOIN [Production].[Product] p 
            ON b.[ComponentID] = p.[ProductID] 
        WHERE @CheckDate >= b.[StartDate] 
            AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)
        )
    -- Outer select from the CTE
    SELECT b.[ProductAssemblyID], b.[ComponentID], b.[ComponentDesc], SUM(b.[PerAssemblyQty]) AS [TotalQuantity] , b.[StandardCost], b.[ListPrice], b.[BOMLevel], b.[RecursionLevel]
    FROM [BOM_cte] b
    GROUP BY b.[ComponentID], b.[ComponentDesc], b.[ProductAssemblyID], b.[BOMLevel], b.[RecursionLevel], b.[StandardCost], b.[ListPrice]
    ORDER BY b.[BOMLevel], b.[ProductAssemblyID], b.[ComponentID]
    OPTION (MAXRECURSION 25) 
END;
GO

CREATE PROCEDURE [dbo].[uspGetEmployeeManagers]
    @BusinessEntityID [int]
AS
BEGIN
    SET NOCOUNT ON;

    -- Use recursive query to list out all Employees required for a particular Manager
    WITH [EMP_cte]([BusinessEntityID], [OrganizationNode], [FirstName], [LastName], [JobTitle], [RecursionLevel]) -- CTE name and columns
    AS (
        SELECT e.[BusinessEntityID], e.[OrganizationNode], p.[FirstName], p.[LastName], e.[JobTitle], 0 -- Get the initial Employee
        FROM [HumanResources].[Employee] e 
			INNER JOIN [Person].[Person] as p
			ON p.[BusinessEntityID] = e.[BusinessEntityID]
        WHERE e.[BusinessEntityID] = @BusinessEntityID
        UNION ALL
        SELECT e.[BusinessEntityID], e.[OrganizationNode], p.[FirstName], p.[LastName], e.[JobTitle], [RecursionLevel] + 1 -- Join recursive member to anchor
        FROM [HumanResources].[Employee] e 
            INNER JOIN [EMP_cte]
            ON e.[OrganizationNode] = [EMP_cte].[OrganizationNode].GetAncestor(1)
            INNER JOIN [Person].[Person] p 
            ON p.[BusinessEntityID] = e.[BusinessEntityID]
    )
    -- Join back to Employee to return the manager name 
    SELECT [EMP_cte].[RecursionLevel], [EMP_cte].[BusinessEntityID], [EMP_cte].[FirstName], [EMP_cte].[LastName], 
        [EMP_cte].[OrganizationNode].ToString() AS [OrganizationNode], p.[FirstName] AS 'ManagerFirstName', p.[LastName] AS 'ManagerLastName'  -- Outer select from the CTE
    FROM [EMP_cte] 
        INNER JOIN [HumanResources].[Employee] e 
        ON [EMP_cte].[OrganizationNode].GetAncestor(1) = e.[OrganizationNode]
        INNER JOIN [Person].[Person] p 
        ON p.[BusinessEntityID] = e.[BusinessEntityID]
    ORDER BY [RecursionLevel], [EMP_cte].[OrganizationNode].ToString()
    OPTION (MAXRECURSION 25) 
END;
GO

CREATE PROCEDURE [dbo].[uspGetManagerEmployees]
    @BusinessEntityID [int]
AS
BEGIN
    SET NOCOUNT ON;

    -- Use recursive query to list out all Employees required for a particular Manager
    WITH [EMP_cte]([BusinessEntityID], [OrganizationNode], [FirstName], [LastName], [RecursionLevel]) -- CTE name and columns
    AS (
        SELECT e.[BusinessEntityID], e.[OrganizationNode], p.[FirstName], p.[LastName], 0 -- Get the initial list of Employees for Manager n
        FROM [HumanResources].[Employee] e 
			INNER JOIN [Person].[Person] p 
			ON p.[BusinessEntityID] = e.[BusinessEntityID]
        WHERE e.[BusinessEntityID] = @BusinessEntityID
        UNION ALL
        SELECT e.[BusinessEntityID], e.[OrganizationNode], p.[FirstName], p.[LastName], [RecursionLevel] + 1 -- Join recursive member to anchor
        FROM [HumanResources].[Employee] e 
            INNER JOIN [EMP_cte]
            ON e.[OrganizationNode].GetAncestor(1) = [EMP_cte].[OrganizationNode]
			INNER JOIN [Person].[Person] p 
			ON p.[BusinessEntityID] = e.[BusinessEntityID]
        )
    -- Join back to Employee to return the manager name 
    SELECT [EMP_cte].[RecursionLevel], [EMP_cte].[OrganizationNode].ToString() as [OrganizationNode], p.[FirstName] AS 'ManagerFirstName', p.[LastName] AS 'ManagerLastName',
        [EMP_cte].[BusinessEntityID], [EMP_cte].[FirstName], [EMP_cte].[LastName] -- Outer select from the CTE
    FROM [EMP_cte] 
        INNER JOIN [HumanResources].[Employee] e 
        ON [EMP_cte].[OrganizationNode].GetAncestor(1) = e.[OrganizationNode]
			INNER JOIN [Person].[Person] p 
			ON p.[BusinessEntityID] = e.[BusinessEntityID]
    ORDER BY [RecursionLevel], [EMP_cte].[OrganizationNode].ToString()
    OPTION (MAXRECURSION 25) 
END;
GO

CREATE PROCEDURE [dbo].[uspGetWhereUsedProductID]
    @StartProductID [int],
    @CheckDate [datetime]
AS
BEGIN
    SET NOCOUNT ON;

    --Use recursive query to generate a multi-level Bill of Material (i.e. all level 1 components of a level 0 assembly, all level 2 components of a level 1 assembly)
    WITH [BOM_cte]([ProductAssemblyID], [ComponentID], [ComponentDesc], [PerAssemblyQty], [StandardCost], [ListPrice], [BOMLevel], [RecursionLevel]) -- CTE name and columns
    AS (
        SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], 0 -- Get the initial list of components for the bike assembly
        FROM [Production].[BillOfMaterials] b
            INNER JOIN [Production].[Product] p 
            ON b.[ProductAssemblyID] = p.[ProductID] 
        WHERE b.[ComponentID] = @StartProductID 
            AND @CheckDate >= b.[StartDate] 
            AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)
        UNION ALL
        SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], [RecursionLevel] + 1 -- Join recursive member to anchor
        FROM [BOM_cte] cte
            INNER JOIN [Production].[BillOfMaterials] b 
            ON cte.[ProductAssemblyID] = b.[ComponentID]
            INNER JOIN [Production].[Product] p 
            ON b.[ProductAssemblyID] = p.[ProductID] 
        WHERE @CheckDate >= b.[StartDate] 
            AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)
        )
    -- Outer select from the CTE
    SELECT b.[ProductAssemblyID], b.[ComponentID], b.[ComponentDesc], SUM(b.[PerAssemblyQty]) AS [TotalQuantity] , b.[StandardCost], b.[ListPrice], b.[BOMLevel], b.[RecursionLevel]
    FROM [BOM_cte] b
    GROUP BY b.[ComponentID], b.[ComponentDesc], b.[ProductAssemblyID], b.[BOMLevel], b.[RecursionLevel], b.[StandardCost], b.[ListPrice]
    ORDER BY b.[BOMLevel], b.[ProductAssemblyID], b.[ComponentID]
    OPTION (MAXRECURSION 25) 
END;
GO

CREATE PROCEDURE [HumanResources].[uspUpdateEmployeeHireInfo]
    @BusinessEntityID [int], 
    @JobTitle [nvarchar](50), 
    @HireDate [datetime], 
    @RateChangeDate [datetime], 
    @Rate [money], 
    @PayFrequency [tinyint], 
    @CurrentFlag [dbo].[Flag] 
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [HumanResources].[Employee] 
        SET [JobTitle] = @JobTitle 
            ,[HireDate] = @HireDate 
            ,[CurrentFlag] = @CurrentFlag 
        WHERE [BusinessEntityID] = @BusinessEntityID;

        INSERT INTO [HumanResources].[EmployeePayHistory] 
            ([BusinessEntityID]
            ,[RateChangeDate]
            ,[Rate]
            ,[PayFrequency]) 
        VALUES (@BusinessEntityID, @RateChangeDate, @Rate, @PayFrequency);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO

CREATE PROCEDURE [HumanResources].[uspUpdateEmployeeLogin]
    @BusinessEntityID [int], 
    @OrganizationNode [hierarchyid],
    @LoginID [nvarchar](256),
    @JobTitle [nvarchar](50),
    @HireDate [datetime],
    @CurrentFlag [dbo].[Flag]
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        UPDATE [HumanResources].[Employee] 
        SET [OrganizationNode] = @OrganizationNode 
            ,[LoginID] = @LoginID 
            ,[JobTitle] = @JobTitle 
            ,[HireDate] = @HireDate 
            ,[CurrentFlag] = @CurrentFlag 
        WHERE [BusinessEntityID] = @BusinessEntityID;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO

CREATE PROCEDURE [HumanResources].[uspUpdateEmployeePersonalInfo]
    @BusinessEntityID [int], 
    @NationalIDNumber [nvarchar](15), 
    @BirthDate [datetime], 
    @MaritalStatus [nchar](1), 
    @Gender [nchar](1)
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        UPDATE [HumanResources].[Employee] 
        SET [NationalIDNumber] = @NationalIDNumber 
            ,[BirthDate] = @BirthDate 
            ,[MaritalStatus] = @MaritalStatus 
            ,[Gender] = @Gender 
        WHERE [BusinessEntityID] = @BusinessEntityID;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO

--A stored procedure which demonstrates integrated full text search



-- ******************************************************
-- Add Extended Properties
-- ******************************************************
PRINT '';
PRINT '*** Creating Extended Properties';
GO

SET NOCOUNT ON;
GO

PRINT '    Database';
GO

-- Database
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'AdventureWorks 2016 Sample OLTP Database', NULL, NULL, NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Database trigger to audit all of the DDL changes made to the AdventureWorks 2016 database.', N'TRIGGER', [ddlDatabaseTriggerLog], NULL, NULL, NULL, NULL;
GO

PRINT '    Files and Filegroups';
GO

-- Files and Filegroups
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary filegroup for the AdventureWorks 2016 sample database.', N'FILEGROUP', [PRIMARY];
GO

PRINT '    Schemas';
GO

-- Schemas
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Contains objects related to employees and departments.', N'SCHEMA', [HumanResources], NULL, NULL, NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Contains objects related to products, inventory, and manufacturing.', N'SCHEMA', [Production], NULL, NULL, NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Contains objects related to vendors and purchase orders.', N'SCHEMA', [Purchasing], NULL, NULL, NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Contains objects related to customers, sales orders, and sales territories.', N'SCHEMA', [Sales], NULL, NULL, NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Contains objects related to names and addresses of customers, vendors, and employees', N'SCHEMA', [Person], NULL, NULL, NULL, NULL;
GO

PRINT '    Tables and Columns';
GO

-- Tables and Columns
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Street address information for customers, employees, and vendors.', N'SCHEMA', [Person], N'TABLE', [Address], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for Address records.', N'SCHEMA', [Person], N'TABLE', [Address], N'COLUMN', [AddressID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'First street address line.', N'SCHEMA', [Person], N'TABLE', [Address], N'COLUMN', [AddressLine1];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Second street address line.', N'SCHEMA', [Person], N'TABLE', [Address], N'COLUMN', [AddressLine2];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Name of the city.', N'SCHEMA', [Person], N'TABLE', [Address], N'COLUMN', [City];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique identification number for the state or province. Foreign key to StateProvince table.', N'SCHEMA', [Person], N'TABLE', [Address], N'COLUMN', [StateProvinceID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Postal code for the street address.', N'SCHEMA', [Person], N'TABLE', [Address], N'COLUMN', [PostalCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Latitude and longitude of this address.', N'SCHEMA', [Person], N'TABLE', [Address], N'COLUMN', [SpatialLocation];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Person], N'TABLE', [Address], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Person], N'TABLE', [Address], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Types of addresses stored in the Address table. ', N'SCHEMA', [Person], N'TABLE', [AddressType], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for AddressType records.', N'SCHEMA', [Person], N'TABLE', [AddressType], N'COLUMN', [AddressTypeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Address type description. For example, Billing, Home, or Shipping.', N'SCHEMA', [Person], N'TABLE', [AddressType], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Person], N'TABLE', [AddressType], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Person], N'TABLE', [AddressType], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Current version number of the AdventureWorks 2016 sample database. ', N'SCHEMA', [dbo], N'TABLE', [AWBuildVersion], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for AWBuildVersion records.', N'SCHEMA', [dbo], N'TABLE', [AWBuildVersion], N'COLUMN', [SystemInformationID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Version number of the database in 9.yy.mm.dd.00 format.', N'SCHEMA', [dbo], N'TABLE', [AWBuildVersion], N'COLUMN', [Database Version];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [dbo], N'TABLE', [AWBuildVersion], N'COLUMN', [VersionDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [dbo], N'TABLE', [AWBuildVersion], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Items required to make bicycles and bicycle subassemblies. It identifies the heirarchical relationship between a parent product and its components.', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for BillOfMaterials records.', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'COLUMN', [BillOfMaterialsID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Parent product identification number. Foreign key to Product.ProductID.', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'COLUMN', [ProductAssemblyID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Component identification number. Foreign key to Product.ProductID.', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'COLUMN', [ComponentID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date the component started being used in the assembly item.', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'COLUMN', [StartDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date the component stopped being used in the assembly item.', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'COLUMN', [EndDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Standard code identifying the unit of measure for the quantity.', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'COLUMN', [UnitMeasureCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Indicates the depth the component is from its parent (AssemblyID).', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'COLUMN', [BOMLevel];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Quantity of the component needed to create the assembly.', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'COLUMN', [PerAssemblyQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Source of the ID that connects vendors, customers, and employees with address and contact information.', N'SCHEMA', [Person], N'TABLE', [BusinessEntity], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for all customers, vendors, and employees.', N'SCHEMA', [Person], N'TABLE', [BusinessEntity], N'COLUMN', [BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Person], N'TABLE', [BusinessEntity], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Person], N'TABLE', [BusinessEntity], N'COLUMN', [ModifiedDate];

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Cross-reference table mapping customers, vendors, and employees to their addresses.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityAddress], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Foreign key to BusinessEntity.BusinessEntityID.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityAddress], N'COLUMN', [BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Foreign key to Address.AddressID.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityAddress], N'COLUMN', [AddressID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Foreign key to AddressType.AddressTypeID.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityAddress], N'COLUMN', [AddressTypeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityAddress], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityAddress], N'COLUMN', [ModifiedDate];

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Cross-reference table mapping stores, vendors, and employees to people', N'SCHEMA', [Person], N'TABLE', [BusinessEntityContact], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Foreign key to BusinessEntity.BusinessEntityID.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityContact], N'COLUMN', [BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Foreign key to Person.BusinessEntityID.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityContact], N'COLUMN', [PersonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key.  Foreign key to ContactType.ContactTypeID.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityContact], N'COLUMN', [ContactTypeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityContact], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityContact], N'COLUMN', [ModifiedDate];


EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Lookup table containing the types of business entity contacts.', N'SCHEMA', [Person], N'TABLE', [ContactType], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for ContactType records.', N'SCHEMA', [Person], N'TABLE', [ContactType], N'COLUMN', [ContactTypeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Contact type description.', N'SCHEMA', [Person], N'TABLE', [ContactType], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Person], N'TABLE', [ContactType], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Cross-reference table mapping ISO currency codes to a country or region.', N'SCHEMA', [Sales], N'TABLE', [CountryRegionCurrency], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ISO code for countries and regions. Foreign key to CountryRegion.CountryRegionCode.', N'SCHEMA', [Sales], N'TABLE', [CountryRegionCurrency], N'COLUMN', [CountryRegionCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ISO standard currency code. Foreign key to Currency.CurrencyCode.', N'SCHEMA', [Sales], N'TABLE', [CountryRegionCurrency], N'COLUMN', [CurrencyCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [CountryRegionCurrency], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Lookup table containing the ISO standard codes for countries and regions.', N'SCHEMA', [Person], N'TABLE', [CountryRegion], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ISO standard code for countries and regions.', N'SCHEMA', [Person], N'TABLE', [CountryRegion], N'COLUMN', [CountryRegionCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Country or region name.', N'SCHEMA', [Person], N'TABLE', [CountryRegion], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Person], N'TABLE', [CountryRegion], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Customer credit card information.', N'SCHEMA', [Sales], N'TABLE', [CreditCard], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for CreditCard records.', N'SCHEMA', [Sales], N'TABLE', [CreditCard], N'COLUMN', [CreditCardID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Credit card name.', N'SCHEMA', [Sales], N'TABLE', [CreditCard], N'COLUMN', [CardType];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Credit card number.', N'SCHEMA', [Sales], N'TABLE', [CreditCard], N'COLUMN', [CardNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Credit card expiration month.', N'SCHEMA', [Sales], N'TABLE', [CreditCard], N'COLUMN', [ExpMonth];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Credit card expiration year.', N'SCHEMA', [Sales], N'TABLE', [CreditCard], N'COLUMN', [ExpYear];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [CreditCard], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Lookup table containing the languages in which some AdventureWorks data is stored.', N'SCHEMA', [Production], N'TABLE', [Culture], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for Culture records.', N'SCHEMA', [Production], N'TABLE', [Culture], N'COLUMN', [CultureID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Culture description.', N'SCHEMA', [Production], N'TABLE', [Culture], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [Culture], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Lookup table containing standard ISO currencies.', N'SCHEMA', [Sales], N'TABLE', [Currency], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The ISO code for the Currency.', N'SCHEMA', [Sales], N'TABLE', [Currency], N'COLUMN', [CurrencyCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Currency name.', N'SCHEMA', [Sales], N'TABLE', [Currency], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [Currency], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Currency exchange rates.', N'SCHEMA', [Sales], N'TABLE', [CurrencyRate], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for CurrencyRate records.', N'SCHEMA', [Sales], N'TABLE', [CurrencyRate], N'COLUMN', [CurrencyRateID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the exchange rate was obtained.', N'SCHEMA', [Sales], N'TABLE', [CurrencyRate], N'COLUMN', [CurrencyRateDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Exchange rate was converted from this currency code.', N'SCHEMA', [Sales], N'TABLE', [CurrencyRate], N'COLUMN', [FromCurrencyCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Exchange rate was converted to this currency code.', N'SCHEMA', [Sales], N'TABLE', [CurrencyRate], N'COLUMN', [ToCurrencyCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Average exchange rate for the day.', N'SCHEMA', [Sales], N'TABLE', [CurrencyRate], N'COLUMN', [AverageRate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Final exchange rate for the day.', N'SCHEMA', [Sales], N'TABLE', [CurrencyRate], N'COLUMN', [EndOfDayRate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [CurrencyRate], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Current customer information. Also see the Person and Store tables.', N'SCHEMA', [Sales], N'TABLE', [Customer], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key.', N'SCHEMA', [Sales], N'TABLE', [Customer], N'COLUMN', [CustomerID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key to Person.BusinessEntityID', N'SCHEMA', [Sales], N'TABLE', [Customer], N'COLUMN', [PersonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key to Store.BusinessEntityID', N'SCHEMA', [Sales], N'TABLE', [Customer], N'COLUMN', [StoreID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ID of the territory in which the customer is located. Foreign key to SalesTerritory.SalesTerritoryID.', N'SCHEMA', [Sales], N'TABLE', [Customer], N'COLUMN', [TerritoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique number identifying the customer assigned by the accounting system.', N'SCHEMA', [Sales], N'TABLE', [Customer], N'COLUMN', [AccountNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Sales], N'TABLE', [Customer], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [Customer], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Audit table tracking all DDL changes made to the AdventureWorks database. Data is captured by the database trigger ddlDatabaseTriggerLog.', N'SCHEMA', [dbo], N'TABLE', [DatabaseLog], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for DatabaseLog records.', N'SCHEMA', [dbo], N'TABLE', [DatabaseLog], N'COLUMN', [DatabaseLogID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The date and time the DDL change occurred.', N'SCHEMA', [dbo], N'TABLE', [DatabaseLog], N'COLUMN', [PostTime];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The user who implemented the DDL change.', N'SCHEMA', [dbo], N'TABLE', [DatabaseLog], N'COLUMN', [DatabaseUser];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The type of DDL statement that was executed.', N'SCHEMA', [dbo], N'TABLE', [DatabaseLog], N'COLUMN', [Event];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The schema to which the changed object belongs.', N'SCHEMA', [dbo], N'TABLE', [DatabaseLog], N'COLUMN', [Schema];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The object that was changed by the DDL statment.', N'SCHEMA', [dbo], N'TABLE', [DatabaseLog], N'COLUMN', [Object];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The exact Transact-SQL statement that was executed.', N'SCHEMA', [dbo], N'TABLE', [DatabaseLog], N'COLUMN', [TSQL];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The raw XML data generated by database trigger.', N'SCHEMA', [dbo], N'TABLE', [DatabaseLog], N'COLUMN', [XmlEvent];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Lookup table containing the departments within the Adventure Works Cycles company.', N'SCHEMA', [HumanResources], N'TABLE', [Department], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for Department records.', N'SCHEMA', [HumanResources], N'TABLE', [Department], N'COLUMN', [DepartmentID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Name of the department.', N'SCHEMA', [HumanResources], N'TABLE', [Department], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Name of the group to which the department belongs.', N'SCHEMA', [HumanResources], N'TABLE', [Department], N'COLUMN', [GroupName];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [HumanResources], N'TABLE', [Department], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product maintenance documents.', N'SCHEMA', [Production], N'TABLE', [Document], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for Document records.', N'SCHEMA', [Production], N'TABLE', [Document], N'COLUMN', [DocumentNode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Depth in the document hierarchy.', N'SCHEMA', [Production], N'TABLE', [Document], N'COLUMN', [DocumentLevel];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Title of the document.', N'SCHEMA', [Production], N'TABLE', [Document], N'COLUMN', [Title];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Employee who controls the document.  Foreign key to Employee.BusinessEntityID', N'SCHEMA', [Production], N'TABLE', [Document], N'COLUMN', [Owner];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'0 = This is a folder, 1 = This is a document.', N'SCHEMA', [Production], N'TABLE', [Document], N'COLUMN', [FolderFlag];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'File name of the document', N'SCHEMA', [Production], N'TABLE', [Document], N'COLUMN', [FileName];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'File extension indicating the document type. For example, .doc or .txt.', N'SCHEMA', [Production], N'TABLE', [Document], N'COLUMN', [FileExtension];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Revision number of the document. ', N'SCHEMA', [Production], N'TABLE', [Document], N'COLUMN', [Revision];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Engineering change approval number.', N'SCHEMA', [Production], N'TABLE', [Document], N'COLUMN', [ChangeNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'1 = Pending approval, 2 = Approved, 3 = Obsolete', N'SCHEMA', [Production], N'TABLE', [Document], N'COLUMN', [Status];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Document abstract.', N'SCHEMA', [Production], N'TABLE', [Document], N'COLUMN', [DocumentSummary];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Complete document.', N'SCHEMA', [Production], N'TABLE', [Document], N'COLUMN', [Document];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Required for FileStream.', N'SCHEMA', [Production], N'TABLE', [Document], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [Document], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Where to send a person email.', N'SCHEMA', [Person], N'TABLE', [EmailAddress], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Person associated with this email address.  Foreign key to Person.BusinessEntityID', N'SCHEMA', [Person], N'TABLE', [EmailAddress], N'COLUMN', [BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. ID of this email address.', N'SCHEMA', [Person], N'TABLE', [EmailAddress], N'COLUMN', [EmailAddressID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'E-mail address for the person.', N'SCHEMA', [Person], N'TABLE', [EmailAddress], N'COLUMN', [EmailAddress];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Person], N'TABLE', [EmailAddress], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Person], N'TABLE', [EmailAddress], N'COLUMN', [ModifiedDate];


EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Employee information such as salary, department, and title.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for Employee records.  Foreign key to BusinessEntity.BusinessEntityID.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'COLUMN', [BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique national identification number such as a social security number.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'COLUMN', [NationalIDNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Network login.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'COLUMN', [LoginID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Where the employee is located in corporate hierarchy.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'COLUMN', [OrganizationNode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The depth of the employee in the corporate hierarchy.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'COLUMN', [OrganizationLevel];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Work title such as Buyer or Sales Representative.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'COLUMN', [JobTitle];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date of birth.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'COLUMN', [BirthDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'M = Married, S = Single', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'COLUMN', [MaritalStatus];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'M = Male, F = Female', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'COLUMN', [Gender];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Employee hired on this date.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'COLUMN', [HireDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Job classification. 0 = Hourly, not exempt from collective bargaining. 1 = Salaried, exempt from collective bargaining.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'COLUMN', [SalariedFlag];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Number of available vacation hours.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'COLUMN', [VacationHours];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Number of available sick leave hours.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'COLUMN', [SickLeaveHours];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'0 = Inactive, 1 = Active', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'COLUMN', [CurrentFlag];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Employee department transfers.', N'SCHEMA', [HumanResources], N'TABLE', [EmployeeDepartmentHistory], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Employee identification number. Foreign key to Employee.BusinessEntityID.', N'SCHEMA', [HumanResources], N'TABLE', [EmployeeDepartmentHistory], N'COLUMN', [BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Department in which the employee worked including currently. Foreign key to Department.DepartmentID.', N'SCHEMA', [HumanResources], N'TABLE', [EmployeeDepartmentHistory], N'COLUMN', [DepartmentID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Identifies which 8-hour shift the employee works. Foreign key to Shift.Shift.ID.', N'SCHEMA', [HumanResources], N'TABLE', [EmployeeDepartmentHistory], N'COLUMN', [ShiftID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date the employee started work in the department.', N'SCHEMA', [HumanResources], N'TABLE', [EmployeeDepartmentHistory], N'COLUMN', [StartDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date the employee left the department. NULL = Current department.', N'SCHEMA', [HumanResources], N'TABLE', [EmployeeDepartmentHistory], N'COLUMN', [EndDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [HumanResources], N'TABLE', [EmployeeDepartmentHistory], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Employee pay history.', N'SCHEMA', [HumanResources], N'TABLE', [EmployeePayHistory], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Employee identification number. Foreign key to Employee.BusinessEntityID.', N'SCHEMA', [HumanResources], N'TABLE', [EmployeePayHistory], N'COLUMN', [BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date the change in pay is effective', N'SCHEMA', [HumanResources], N'TABLE', [EmployeePayHistory], N'COLUMN', [RateChangeDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Salary hourly rate.', N'SCHEMA', [HumanResources], N'TABLE', [EmployeePayHistory], N'COLUMN', [Rate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'1 = Salary received monthly, 2 = Salary received biweekly', N'SCHEMA', [HumanResources], N'TABLE', [EmployeePayHistory], N'COLUMN', [PayFrequency];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [HumanResources], N'TABLE', [EmployeePayHistory], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Audit table tracking errors in the the AdventureWorks database that are caught by the CATCH block of a TRY...CATCH construct. Data is inserted by stored procedure dbo.uspLogError when it is executed from inside the CATCH block of a TRY...CATCH construct.', N'SCHEMA', [dbo], N'TABLE', [ErrorLog], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for ErrorLog records.', N'SCHEMA', [dbo], N'TABLE', [ErrorLog], N'COLUMN', [ErrorLogID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The date and time at which the error occurred.', N'SCHEMA', [dbo], N'TABLE', [ErrorLog], N'COLUMN', [ErrorTime];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The user who executed the batch in which the error occurred.', N'SCHEMA', [dbo], N'TABLE', [ErrorLog], N'COLUMN', [UserName];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The error number of the error that occurred.', N'SCHEMA', [dbo], N'TABLE', [ErrorLog], N'COLUMN', [ErrorNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The severity of the error that occurred.', N'SCHEMA', [dbo], N'TABLE', [ErrorLog], N'COLUMN', [ErrorSeverity];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The state number of the error that occurred.', N'SCHEMA', [dbo], N'TABLE', [ErrorLog], N'COLUMN', [ErrorState];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The name of the stored procedure or trigger where the error occurred.', N'SCHEMA', [dbo], N'TABLE', [ErrorLog], N'COLUMN', [ErrorProcedure];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The line number at which the error occurred.', N'SCHEMA', [dbo], N'TABLE', [ErrorLog], N'COLUMN', [ErrorLine];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The message text of the error that occurred.', N'SCHEMA', [dbo], N'TABLE', [ErrorLog], N'COLUMN', [ErrorMessage];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Bicycle assembly diagrams.', N'SCHEMA', [Production], N'TABLE', [Illustration], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for Illustration records.', N'SCHEMA', [Production], N'TABLE', [Illustration], N'COLUMN', [IllustrationID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Illustrations used in manufacturing instructions. Stored as XML.', N'SCHEMA', [Production], N'TABLE', [Illustration], N'COLUMN', [Diagram];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [Illustration], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Résumés submitted to Human Resources by job applicants.', N'SCHEMA', [HumanResources], N'TABLE', [JobCandidate], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for JobCandidate records.', N'SCHEMA', [HumanResources], N'TABLE', [JobCandidate], N'COLUMN', [JobCandidateID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Employee identification number if applicant was hired. Foreign key to Employee.BusinessEntityID.', N'SCHEMA', [HumanResources], N'TABLE', [JobCandidate], N'COLUMN', [BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Résumé in XML format.', N'SCHEMA', [HumanResources], N'TABLE', [JobCandidate], N'COLUMN', [Resume];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [HumanResources], N'TABLE', [JobCandidate], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product inventory and manufacturing locations.', N'SCHEMA', [Production], N'TABLE', [Location], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for Location records.', N'SCHEMA', [Production], N'TABLE', [Location], N'COLUMN', [LocationID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Location description.', N'SCHEMA', [Production], N'TABLE', [Location], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Standard hourly cost of the manufacturing location.', N'SCHEMA', [Production], N'TABLE', [Location], N'COLUMN', [CostRate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Work capacity (in hours) of the manufacturing location.', N'SCHEMA', [Production], N'TABLE', [Location], N'COLUMN', [Availability];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [Location], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'One way hashed authentication information', N'SCHEMA', [Person], N'TABLE', [Password], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Password for the e-mail account.', N'SCHEMA', [Person], N'TABLE', [Password], N'COLUMN', [PasswordHash];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Random value concatenated with the password string before the password is hashed.', N'SCHEMA', [Person], N'TABLE', [Password], N'COLUMN', [PasswordSalt];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Person], N'TABLE', [Password], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Person], N'TABLE', [Password], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Human beings involved with AdventureWorks: employees, customer contacts, and vendor contacts.', N'SCHEMA', [Person], N'TABLE', [Person], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for Person records.', N'SCHEMA', [Person], N'TABLE', [Person], N'COLUMN', [BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary type of person: SC = Store Contact, IN = Individual (retail) customer, SP = Sales person, EM = Employee (non-sales), VC = Vendor contact, GC = General contact', N'SCHEMA', [Person], N'TABLE', [Person], N'COLUMN', [PersonType];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'0 = The data in FirstName and LastName are stored in western style (first name, last name) order.  1 = Eastern style (last name, first name) order.', N'SCHEMA', [Person], N'TABLE', [Person], N'COLUMN', [NameStyle];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'A courtesy title. For example, Mr. or Ms.', N'SCHEMA', [Person], N'TABLE', [Person], N'COLUMN', [Title];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'First name of the person.', N'SCHEMA', [Person], N'TABLE', [Person], N'COLUMN', [FirstName];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Middle name or middle initial of the person.', N'SCHEMA', [Person], N'TABLE', [Person], N'COLUMN', [MiddleName];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Last name of the person.', N'SCHEMA', [Person], N'TABLE', [Person], N'COLUMN', [LastName];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Surname suffix. For example, Sr. or Jr.', N'SCHEMA', [Person], N'TABLE', [Person], N'COLUMN', [Suffix];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'0 = Contact does not wish to receive e-mail promotions, 1 = Contact does wish to receive e-mail promotions from AdventureWorks, 2 = Contact does wish to receive e-mail promotions from AdventureWorks and selected partners. ', N'SCHEMA', [Person], N'TABLE', [Person], N'COLUMN', [EmailPromotion];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Personal information such as hobbies, and income collected from online shoppers. Used for sales analysis.', N'SCHEMA', [Person], N'TABLE', [Person], N'COLUMN', [Demographics];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Additional contact information about the person stored in xml format. ', N'SCHEMA', [Person], N'TABLE', [Person], N'COLUMN', [AdditionalContactInfo];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Person], N'TABLE', [Person], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Person], N'TABLE', [Person], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Cross-reference table mapping people to their credit card information in the CreditCard table. ', N'SCHEMA', [Sales], N'TABLE', [PersonCreditCard], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Business entity identification number. Foreign key to Person.BusinessEntityID.', N'SCHEMA', [Sales], N'TABLE', [PersonCreditCard], N'COLUMN', [BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Credit card identification number. Foreign key to CreditCard.CreditCardID.', N'SCHEMA', [Sales], N'TABLE', [PersonCreditCard], N'COLUMN', [CreditCardID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [PersonCreditCard], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Telephone number and type of a person.', N'SCHEMA', [Person], N'TABLE', [PersonPhone], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Business entity identification number. Foreign key to Person.BusinessEntityID.', N'SCHEMA', [Person], N'TABLE', [PersonPhone], N'COLUMN', [BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Telephone number identification number.', N'SCHEMA', [Person], N'TABLE', [PersonPhone], N'COLUMN', [PhoneNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Kind of phone number. Foreign key to PhoneNumberType.PhoneNumberTypeID.', N'SCHEMA', [Person], N'TABLE', [PersonPhone], N'COLUMN', [PhoneNumberTypeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Person], N'TABLE', [PersonPhone], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Type of phone number of a person.', N'SCHEMA', [Person], N'TABLE', [PhoneNumberType], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for telephone number type records.', N'SCHEMA', [Person], N'TABLE', [PhoneNumberType], N'COLUMN', [PhoneNumberTypeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Name of the telephone number type', N'SCHEMA', [Person], N'TABLE', [PhoneNumberType], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Person], N'TABLE', [PhoneNumberType], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Products sold or used in the manfacturing of sold products.', N'SCHEMA', [Production], N'TABLE', [Product], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for Product records.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Name of the product.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique product identification number.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [ProductNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'0 = Product is purchased, 1 = Product is manufactured in-house.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [MakeFlag];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'0 = Product is not a salable item. 1 = Product is salable.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [FinishedGoodsFlag];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product color.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [Color];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Minimum inventory quantity. ', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [SafetyStockLevel];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Inventory level that triggers a purchase order or work order. ', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [ReorderPoint];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Standard cost of the product.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [StandardCost];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Selling price.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [ListPrice];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product size.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [Size];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unit of measure for Size column.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [SizeUnitMeasureCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unit of measure for Weight column.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [WeightUnitMeasureCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product weight.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [Weight];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Number of days required to manufacture the product.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [DaysToManufacture];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'R = Road, M = Mountain, T = Touring, S = Standard', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [ProductLine];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'H = High, M = Medium, L = Low', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [Class];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'W = Womens, M = Mens, U = Universal', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [Style];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product is a member of this product subcategory. Foreign key to ProductSubCategory.ProductSubCategoryID. ', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [ProductSubcategoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product is a member of this product model. Foreign key to ProductModel.ProductModelID.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [ProductModelID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date the product was available for sale.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [SellStartDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date the product was no longer available for sale.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [SellEndDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date the product was discontinued.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [DiscontinuedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [Product], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'High-level product categorization.', N'SCHEMA', [Production], N'TABLE', [ProductCategory], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for ProductCategory records.', N'SCHEMA', [Production], N'TABLE', [ProductCategory], N'COLUMN', [ProductCategoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Category description.', N'SCHEMA', [Production], N'TABLE', [ProductCategory], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Production], N'TABLE', [ProductCategory], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [ProductCategory], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Changes in the cost of a product over time.', N'SCHEMA', [Production], N'TABLE', [ProductCostHistory], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product identification number. Foreign key to Product.ProductID', N'SCHEMA', [Production], N'TABLE', [ProductCostHistory], N'COLUMN', [ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product cost start date.', N'SCHEMA', [Production], N'TABLE', [ProductCostHistory], N'COLUMN', [StartDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product cost end date.', N'SCHEMA', [Production], N'TABLE', [ProductCostHistory], N'COLUMN', [EndDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Standard cost of the product.', N'SCHEMA', [Production], N'TABLE', [ProductCostHistory], N'COLUMN', [StandardCost];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [ProductCostHistory], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product descriptions in several languages.', N'SCHEMA', [Production], N'TABLE', [ProductDescription], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for ProductDescription records.', N'SCHEMA', [Production], N'TABLE', [ProductDescription], N'COLUMN', [ProductDescriptionID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Description of the product.', N'SCHEMA', [Production], N'TABLE', [ProductDescription], N'COLUMN', [Description];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Production], N'TABLE', [ProductDescription], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [ProductDescription], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Cross-reference table mapping products to related product documents.', N'SCHEMA', [Production], N'TABLE', [ProductDocument], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product identification number. Foreign key to Product.ProductID.', N'SCHEMA', [Production], N'TABLE', [ProductDocument], N'COLUMN', [ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Document identification number. Foreign key to Document.DocumentNode.', N'SCHEMA', [Production], N'TABLE', [ProductDocument], N'COLUMN', [DocumentNode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [ProductDocument], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product inventory information.', N'SCHEMA', [Production], N'TABLE', [ProductInventory], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product identification number. Foreign key to Product.ProductID.', N'SCHEMA', [Production], N'TABLE', [ProductInventory], N'COLUMN', [ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Inventory location identification number. Foreign key to Location.LocationID. ', N'SCHEMA', [Production], N'TABLE', [ProductInventory], N'COLUMN', [LocationID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Storage compartment within an inventory location.', N'SCHEMA', [Production], N'TABLE', [ProductInventory], N'COLUMN', [Shelf];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Storage container on a shelf in an inventory location.', N'SCHEMA', [Production], N'TABLE', [ProductInventory], N'COLUMN', [Bin];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Quantity of products in the inventory location.', N'SCHEMA', [Production], N'TABLE', [ProductInventory], N'COLUMN', [Quantity];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Production], N'TABLE', [ProductInventory], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [ProductInventory], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Changes in the list price of a product over time.', N'SCHEMA', [Production], N'TABLE', [ProductListPriceHistory], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product identification number. Foreign key to Product.ProductID', N'SCHEMA', [Production], N'TABLE', [ProductListPriceHistory], N'COLUMN', [ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'List price start date.', N'SCHEMA', [Production], N'TABLE', [ProductListPriceHistory], N'COLUMN', [StartDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'List price end date', N'SCHEMA', [Production], N'TABLE', [ProductListPriceHistory], N'COLUMN', [EndDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product list price.', N'SCHEMA', [Production], N'TABLE', [ProductListPriceHistory], N'COLUMN', [ListPrice];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [ProductListPriceHistory], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product model classification.', N'SCHEMA', [Production], N'TABLE', [ProductModel], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for ProductModel records.', N'SCHEMA', [Production], N'TABLE', [ProductModel], N'COLUMN', [ProductModelID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product model description.', N'SCHEMA', [Production], N'TABLE', [ProductModel], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Detailed product catalog information in xml format.', N'SCHEMA', [Production], N'TABLE', [ProductModel], N'COLUMN', [CatalogDescription];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Manufacturing instructions in xml format.', N'SCHEMA', [Production], N'TABLE', [ProductModel], N'COLUMN', [Instructions];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Production], N'TABLE', [ProductModel], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [ProductModel], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Cross-reference table mapping product models and illustrations.', N'SCHEMA', [Production], N'TABLE', [ProductModelIllustration], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Foreign key to ProductModel.ProductModelID.', N'SCHEMA', [Production], N'TABLE', [ProductModelIllustration], N'COLUMN', [ProductModelID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Foreign key to Illustration.IllustrationID.', N'SCHEMA', [Production], N'TABLE', [ProductModelIllustration], N'COLUMN', [IllustrationID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [ProductModelIllustration], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Cross-reference table mapping product descriptions and the language the description is written in.', N'SCHEMA', [Production], N'TABLE', [ProductModelProductDescriptionCulture], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Foreign key to ProductModel.ProductModelID.', N'SCHEMA', [Production], N'TABLE', [ProductModelProductDescriptionCulture], N'COLUMN', [ProductModelID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Foreign key to ProductDescription.ProductDescriptionID.', N'SCHEMA', [Production], N'TABLE', [ProductModelProductDescriptionCulture], N'COLUMN', [ProductDescriptionID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Culture identification number. Foreign key to Culture.CultureID.', N'SCHEMA', [Production], N'TABLE', [ProductModelProductDescriptionCulture], N'COLUMN', [CultureID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [ProductModelProductDescriptionCulture], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product images.', N'SCHEMA', [Production], N'TABLE', [ProductPhoto], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for ProductPhoto records.', N'SCHEMA', [Production], N'TABLE', [ProductPhoto], N'COLUMN', [ProductPhotoID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Small image of the product.', N'SCHEMA', [Production], N'TABLE', [ProductPhoto], N'COLUMN', [ThumbNailPhoto];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Small image file name.', N'SCHEMA', [Production], N'TABLE', [ProductPhoto], N'COLUMN', [ThumbnailPhotoFileName];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Large image of the product.', N'SCHEMA', [Production], N'TABLE', [ProductPhoto], N'COLUMN', [LargePhoto];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Large image file name.', N'SCHEMA', [Production], N'TABLE', [ProductPhoto], N'COLUMN', [LargePhotoFileName];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [ProductPhoto], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Cross-reference table mapping products and product photos.', N'SCHEMA', [Production], N'TABLE', [ProductProductPhoto], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product identification number. Foreign key to Product.ProductID.', N'SCHEMA', [Production], N'TABLE', [ProductProductPhoto], N'COLUMN', [ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product photo identification number. Foreign key to ProductPhoto.ProductPhotoID.', N'SCHEMA', [Production], N'TABLE', [ProductProductPhoto], N'COLUMN', [ProductPhotoID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'0 = Photo is not the principal image. 1 = Photo is the principal image.', N'SCHEMA', [Production], N'TABLE', [ProductProductPhoto], N'COLUMN', [Primary];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [ProductProductPhoto], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Customer reviews of products they have purchased.', N'SCHEMA', [Production], N'TABLE', [ProductReview], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for ProductReview records.', N'SCHEMA', [Production], N'TABLE', [ProductReview], N'COLUMN', [ProductReviewID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product identification number. Foreign key to Product.ProductID.', N'SCHEMA', [Production], N'TABLE', [ProductReview], N'COLUMN', [ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Name of the reviewer.', N'SCHEMA', [Production], N'TABLE', [ProductReview], N'COLUMN', [ReviewerName];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date review was submitted.', N'SCHEMA', [Production], N'TABLE', [ProductReview], N'COLUMN', [ReviewDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Reviewer''s e-mail address.', N'SCHEMA', [Production], N'TABLE', [ProductReview], N'COLUMN', [EmailAddress];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product rating given by the reviewer. Scale is 1 to 5 with 5 as the highest rating.', N'SCHEMA', [Production], N'TABLE', [ProductReview], N'COLUMN', [Rating];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Reviewer''s comments', N'SCHEMA', [Production], N'TABLE', [ProductReview], N'COLUMN', [Comments];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [ProductReview], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product subcategories. See ProductCategory table.', N'SCHEMA', [Production], N'TABLE', [ProductSubcategory], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for ProductSubcategory records.', N'SCHEMA', [Production], N'TABLE', [ProductSubcategory], N'COLUMN', [ProductSubcategoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product category identification number. Foreign key to ProductCategory.ProductCategoryID.', N'SCHEMA', [Production], N'TABLE', [ProductSubcategory], N'COLUMN', [ProductCategoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Subcategory description.', N'SCHEMA', [Production], N'TABLE', [ProductSubcategory], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Production], N'TABLE', [ProductSubcategory], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [ProductSubcategory], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Cross-reference table mapping vendors with the products they supply.', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Foreign key to Product.ProductID.', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'COLUMN', [ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Foreign key to Vendor.BusinessEntityID.', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'COLUMN', [BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The average span of time (in days) between placing an order with the vendor and receiving the purchased product.', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'COLUMN', [AverageLeadTime];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The vendor''s usual selling price.', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'COLUMN', [StandardPrice];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The selling price when last purchased.', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'COLUMN', [LastReceiptCost];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date the product was last received by the vendor.', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'COLUMN', [LastReceiptDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The maximum quantity that should be ordered.', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'COLUMN', [MinOrderQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The minimum quantity that should be ordered.', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'COLUMN', [MaxOrderQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The quantity currently on order.', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'COLUMN', [OnOrderQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'The product''s unit of measure.', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'COLUMN', [UnitMeasureCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Individual products associated with a specific purchase order. See PurchaseOrderHeader.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Foreign key to PurchaseOrderHeader.PurchaseOrderID.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'COLUMN', [PurchaseOrderID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. One line number per purchased product.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'COLUMN', [PurchaseOrderDetailID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date the product is expected to be received.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'COLUMN', [DueDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Quantity ordered.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'COLUMN', [OrderQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product identification number. Foreign key to Product.ProductID.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'COLUMN', [ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Vendor''s selling price of a single product.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'COLUMN', [UnitPrice];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Per product subtotal. Computed as OrderQty * UnitPrice.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'COLUMN', [LineTotal];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Quantity actually received from the vendor.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'COLUMN', [ReceivedQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Quantity rejected during inspection.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'COLUMN', [RejectedQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Quantity accepted into inventory. Computed as ReceivedQty - RejectedQty.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'COLUMN', [StockedQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'General purchase order information. See PurchaseOrderDetail.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'COLUMN', [PurchaseOrderID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Incremental number to track changes to the purchase order over time.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'COLUMN', [RevisionNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Order current status. 1 = Pending; 2 = Approved; 3 = Rejected; 4 = Complete', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'COLUMN', [Status];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Employee who created the purchase order. Foreign key to Employee.BusinessEntityID.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'COLUMN', [EmployeeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Vendor with whom the purchase order is placed. Foreign key to Vendor.BusinessEntityID.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'COLUMN', [VendorID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Shipping method. Foreign key to ShipMethod.ShipMethodID.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'COLUMN', [ShipMethodID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Purchase order creation date.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'COLUMN', [OrderDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Estimated shipment date from the vendor.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'COLUMN', [ShipDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Purchase order subtotal. Computed as SUM(PurchaseOrderDetail.LineTotal)for the appropriate PurchaseOrderID.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'COLUMN', [SubTotal];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Tax amount.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'COLUMN', [TaxAmt];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Shipping cost.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'COLUMN', [Freight];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Total due to vendor. Computed as Subtotal + TaxAmt + Freight.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'COLUMN', [TotalDue];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Individual products associated with a specific sales order. See SalesOrderHeader.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Foreign key to SalesOrderHeader.SalesOrderID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'COLUMN', [SalesOrderID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. One incremental unique number per product sold.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'COLUMN', [SalesOrderDetailID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Shipment tracking number supplied by the shipper.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'COLUMN', [CarrierTrackingNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Quantity ordered per product.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'COLUMN', [OrderQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product sold to customer. Foreign key to Product.ProductID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'COLUMN', [ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Promotional code. Foreign key to SpecialOffer.SpecialOfferID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'COLUMN', [SpecialOfferID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Selling price of a single product.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'COLUMN', [UnitPrice];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Discount amount.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'COLUMN', [UnitPriceDiscount];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Per product subtotal. Computed as UnitPrice * (1 - UnitPriceDiscount) * OrderQty.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'COLUMN', [LineTotal];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'General sales order information.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [SalesOrderID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Incremental number to track changes to the sales order over time.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [RevisionNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Dates the sales order was created.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [OrderDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date the order is due to the customer.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [DueDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date the order was shipped to the customer.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [ShipDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Order current status. 1 = In process; 2 = Approved; 3 = Backordered; 4 = Rejected; 5 = Shipped; 6 = Cancelled', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [Status];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'0 = Order placed by sales person. 1 = Order placed online by customer.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [OnlineOrderFlag];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique sales order identification number.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [SalesOrderNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Customer purchase order number reference. ', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [PurchaseOrderNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Financial accounting number reference.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [AccountNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Customer identification number. Foreign key to Customer.BusinessEntityID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [CustomerID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Sales person who created the sales order. Foreign key to SalesPerson.BusinessEntityID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [SalesPersonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Territory in which the sale was made. Foreign key to SalesTerritory.SalesTerritoryID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [TerritoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Customer billing address. Foreign key to Address.AddressID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [BillToAddressID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Customer shipping address. Foreign key to Address.AddressID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [ShipToAddressID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Shipping method. Foreign key to ShipMethod.ShipMethodID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [ShipMethodID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Credit card identification number. Foreign key to CreditCard.CreditCardID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [CreditCardID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Approval code provided by the credit card company.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [CreditCardApprovalCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Currency exchange rate used. Foreign key to CurrencyRate.CurrencyRateID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [CurrencyRateID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Sales subtotal. Computed as SUM(SalesOrderDetail.LineTotal)for the appropriate SalesOrderID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [SubTotal];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Tax amount.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [TaxAmt];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Shipping cost.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [Freight];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Total due from customer. Computed as Subtotal + TaxAmt + Freight.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [TotalDue];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Sales representative comments.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [Comment];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Cross-reference table mapping sales orders to sales reason codes.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeaderSalesReason], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Foreign key to SalesOrderHeader.SalesOrderID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeaderSalesReason], N'COLUMN', [SalesOrderID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Foreign key to SalesReason.SalesReasonID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeaderSalesReason], N'COLUMN', [SalesReasonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeaderSalesReason], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Sales representative current information.', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for SalesPerson records. Foreign key to Employee.BusinessEntityID', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'COLUMN', [BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Territory currently assigned to. Foreign key to SalesTerritory.SalesTerritoryID.', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'COLUMN', [TerritoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Projected yearly sales.', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'COLUMN', [SalesQuota];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Bonus due if quota is met.', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'COLUMN', [Bonus];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Commision percent received per sale.', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'COLUMN', [CommissionPct];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Sales total year to date.', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'COLUMN', [SalesYTD];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Sales total of previous year.', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'COLUMN', [SalesLastYear];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Sales performance tracking.', N'SCHEMA', [Sales], N'TABLE', [SalesPersonQuotaHistory], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Sales person identification number. Foreign key to SalesPerson.BusinessEntityID.', N'SCHEMA', [Sales], N'TABLE', [SalesPersonQuotaHistory], N'COLUMN', [BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Sales quota date.', N'SCHEMA', [Sales], N'TABLE', [SalesPersonQuotaHistory], N'COLUMN', [QuotaDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Sales quota amount.', N'SCHEMA', [Sales], N'TABLE', [SalesPersonQuotaHistory], N'COLUMN', [SalesQuota];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Sales], N'TABLE', [SalesPersonQuotaHistory], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [SalesPersonQuotaHistory], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Lookup table of customer purchase reasons.', N'SCHEMA', [Sales], N'TABLE', [SalesReason], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for SalesReason records.', N'SCHEMA', [Sales], N'TABLE', [SalesReason], N'COLUMN', [SalesReasonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Sales reason description.', N'SCHEMA', [Sales], N'TABLE', [SalesReason], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Category the sales reason belongs to.', N'SCHEMA', [Sales], N'TABLE', [SalesReason], N'COLUMN', [ReasonType];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [SalesReason], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Tax rate lookup table.', N'SCHEMA', [Sales], N'TABLE', [SalesTaxRate], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for SalesTaxRate records.', N'SCHEMA', [Sales], N'TABLE', [SalesTaxRate], N'COLUMN', [SalesTaxRateID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'State, province, or country/region the sales tax applies to.', N'SCHEMA', [Sales], N'TABLE', [SalesTaxRate], N'COLUMN', [StateProvinceID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'1 = Tax applied to retail transactions, 2 = Tax applied to wholesale transactions, 3 = Tax applied to all sales (retail and wholesale) transactions.', N'SCHEMA', [Sales], N'TABLE', [SalesTaxRate], N'COLUMN', [TaxType];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Tax rate amount.', N'SCHEMA', [Sales], N'TABLE', [SalesTaxRate], N'COLUMN', [TaxRate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Tax rate description.', N'SCHEMA', [Sales], N'TABLE', [SalesTaxRate], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Sales], N'TABLE', [SalesTaxRate], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [SalesTaxRate], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Sales territory lookup table.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for SalesTerritory records.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'COLUMN', [TerritoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Sales territory description', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ISO standard country or region code. Foreign key to CountryRegion.CountryRegionCode. ', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'COLUMN', [CountryRegionCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Geographic area to which the sales territory belong.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'COLUMN', [Group];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Sales in the territory year to date.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'COLUMN', [SalesYTD];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Sales in the territory the previous year.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'COLUMN', [SalesLastYear];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Business costs in the territory year to date.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'COLUMN', [CostYTD];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Business costs in the territory the previous year.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'COLUMN', [CostLastYear];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Sales representative transfers to other sales territories.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritoryHistory], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. The sales rep.  Foreign key to SalesPerson.BusinessEntityID.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritoryHistory], N'COLUMN', [BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Territory identification number. Foreign key to SalesTerritory.SalesTerritoryID.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritoryHistory], N'COLUMN', [TerritoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Date the sales representive started work in the territory.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritoryHistory], N'COLUMN', [StartDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date the sales representative left work in the territory.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritoryHistory], N'COLUMN', [EndDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritoryHistory], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritoryHistory], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Manufacturing failure reasons lookup table.', N'SCHEMA', [Production], N'TABLE', [ScrapReason], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for ScrapReason records.', N'SCHEMA', [Production], N'TABLE', [ScrapReason], N'COLUMN', [ScrapReasonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Failure description.', N'SCHEMA', [Production], N'TABLE', [ScrapReason], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [ScrapReason], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Work shift lookup table.', N'SCHEMA', [HumanResources], N'TABLE', [Shift], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for Shift records.', N'SCHEMA', [HumanResources], N'TABLE', [Shift], N'COLUMN', [ShiftID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Shift description.', N'SCHEMA', [HumanResources], N'TABLE', [Shift], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Shift start time.', N'SCHEMA', [HumanResources], N'TABLE', [Shift], N'COLUMN', [StartTime];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Shift end time.', N'SCHEMA', [HumanResources], N'TABLE', [Shift], N'COLUMN', [EndTime];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [HumanResources], N'TABLE', [Shift], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Shipping company lookup table.', N'SCHEMA', [Purchasing], N'TABLE', [ShipMethod], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for ShipMethod records.', N'SCHEMA', [Purchasing], N'TABLE', [ShipMethod], N'COLUMN', [ShipMethodID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Shipping company name.', N'SCHEMA', [Purchasing], N'TABLE', [ShipMethod], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Minimum shipping charge.', N'SCHEMA', [Purchasing], N'TABLE', [ShipMethod], N'COLUMN', [ShipBase];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Shipping charge per pound.', N'SCHEMA', [Purchasing], N'TABLE', [ShipMethod], N'COLUMN', [ShipRate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Purchasing], N'TABLE', [ShipMethod], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Purchasing], N'TABLE', [ShipMethod], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Contains online customer orders until the order is submitted or cancelled.', N'SCHEMA', [Sales], N'TABLE', [ShoppingCartItem], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for ShoppingCartItem records.', N'SCHEMA', [Sales], N'TABLE', [ShoppingCartItem], N'COLUMN', [ShoppingCartItemID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Shopping cart identification number.', N'SCHEMA', [Sales], N'TABLE', [ShoppingCartItem], N'COLUMN', [ShoppingCartID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product quantity ordered.', N'SCHEMA', [Sales], N'TABLE', [ShoppingCartItem], N'COLUMN', [Quantity];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product ordered. Foreign key to Product.ProductID.', N'SCHEMA', [Sales], N'TABLE', [ShoppingCartItem], N'COLUMN', [ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date the time the record was created.', N'SCHEMA', [Sales], N'TABLE', [ShoppingCartItem], N'COLUMN', [DateCreated];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [ShoppingCartItem], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Sale discounts lookup table.', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for SpecialOffer records.', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'COLUMN', [SpecialOfferID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Discount description.', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'COLUMN', [Description];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Discount precentage.', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'COLUMN', [DiscountPct];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Discount type category.', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'COLUMN', [Type];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Group the discount applies to such as Reseller or Customer.', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'COLUMN', [Category];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Discount start date.', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'COLUMN', [StartDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Discount end date.', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'COLUMN', [EndDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Minimum discount percent allowed.', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'COLUMN', [MinQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Maximum discount percent allowed.', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'COLUMN', [MaxQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Cross-reference table mapping products to special offer discounts.', N'SCHEMA', [Sales], N'TABLE', [SpecialOfferProduct], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for SpecialOfferProduct records.', N'SCHEMA', [Sales], N'TABLE', [SpecialOfferProduct], N'COLUMN', [SpecialOfferID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product identification number. Foreign key to Product.ProductID.', N'SCHEMA', [Sales], N'TABLE', [SpecialOfferProduct], N'COLUMN', [ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Sales], N'TABLE', [SpecialOfferProduct], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [SpecialOfferProduct], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'State and province lookup table.', N'SCHEMA', [Person], N'TABLE', [StateProvince], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for StateProvince records.', N'SCHEMA', [Person], N'TABLE', [StateProvince], N'COLUMN', [StateProvinceID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ISO standard state or province code.', N'SCHEMA', [Person], N'TABLE', [StateProvince], N'COLUMN', [StateProvinceCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ISO standard country or region code. Foreign key to CountryRegion.CountryRegionCode. ', N'SCHEMA', [Person], N'TABLE', [StateProvince], N'COLUMN', [CountryRegionCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'0 = StateProvinceCode exists. 1 = StateProvinceCode unavailable, using CountryRegionCode.', N'SCHEMA', [Person], N'TABLE', [StateProvince], N'COLUMN', [IsOnlyStateProvinceFlag];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'State or province description.', N'SCHEMA', [Person], N'TABLE', [StateProvince], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ID of the territory in which the state or province is located. Foreign key to SalesTerritory.SalesTerritoryID.', N'SCHEMA', [Person], N'TABLE', [StateProvince], N'COLUMN', [TerritoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Person], N'TABLE', [StateProvince], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Person], N'TABLE', [StateProvince], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Customers (resellers) of Adventure Works products.', N'SCHEMA', [Sales], N'TABLE', [Store], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Foreign key to Customer.BusinessEntityID.', N'SCHEMA', [Sales], N'TABLE', [Store], N'COLUMN', [BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Name of the store.', N'SCHEMA', [Sales], N'TABLE', [Store], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ID of the sales person assigned to the customer. Foreign key to SalesPerson.BusinessEntityID.', N'SCHEMA', [Sales], N'TABLE', [Store], N'COLUMN', [SalesPersonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Demographic informationg about the store such as the number of employees, annual sales and store type.', N'SCHEMA', [Sales], N'TABLE', [Store], N'COLUMN', [Demographics];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', N'SCHEMA', [Sales], N'TABLE', [Store], N'COLUMN', [rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Sales], N'TABLE', [Store], N'COLUMN', [ModifiedDate];
GO


EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Record of each purchase order, sales order, or work order transaction year to date.', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for TransactionHistory records.', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], N'COLUMN', [TransactionID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product identification number. Foreign key to Product.ProductID.', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], N'COLUMN', [ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Purchase order, sales order, or work order identification number.', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], N'COLUMN', [ReferenceOrderID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Line number associated with the purchase order, sales order, or work order.', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], N'COLUMN', [ReferenceOrderLineID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time of the transaction.', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], N'COLUMN', [TransactionDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'W = WorkOrder, S = SalesOrder, P = PurchaseOrder', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], N'COLUMN', [TransactionType];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product quantity.', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], N'COLUMN', [Quantity];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product cost.', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], N'COLUMN', [ActualCost];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Transactions for previous years.', N'SCHEMA', [Production], N'TABLE', [TransactionHistoryArchive], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for TransactionHistoryArchive records.', N'SCHEMA', [Production], N'TABLE', [TransactionHistoryArchive], N'COLUMN', [TransactionID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product identification number. Foreign key to Product.ProductID.', N'SCHEMA', [Production], N'TABLE', [TransactionHistoryArchive], N'COLUMN', [ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Purchase order, sales order, or work order identification number.', N'SCHEMA', [Production], N'TABLE', [TransactionHistoryArchive], N'COLUMN', [ReferenceOrderID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Line number associated with the purchase order, sales order, or work order.', N'SCHEMA', [Production], N'TABLE', [TransactionHistoryArchive], N'COLUMN', [ReferenceOrderLineID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time of the transaction.', N'SCHEMA', [Production], N'TABLE', [TransactionHistoryArchive], N'COLUMN', [TransactionDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'W = Work Order, S = Sales Order, P = Purchase Order', N'SCHEMA', [Production], N'TABLE', [TransactionHistoryArchive], N'COLUMN', [TransactionType];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product quantity.', N'SCHEMA', [Production], N'TABLE', [TransactionHistoryArchive], N'COLUMN', [Quantity];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product cost.', N'SCHEMA', [Production], N'TABLE', [TransactionHistoryArchive], N'COLUMN', [ActualCost];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [TransactionHistoryArchive], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unit of measure lookup table.', N'SCHEMA', [Production], N'TABLE', [UnitMeasure], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key.', N'SCHEMA', [Production], N'TABLE', [UnitMeasure], N'COLUMN', [UnitMeasureCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unit of measure description.', N'SCHEMA', [Production], N'TABLE', [UnitMeasure], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [UnitMeasure], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Companies from whom Adventure Works Cycles purchases parts or other goods.', N'SCHEMA', [Purchasing], N'TABLE', [Vendor], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for Vendor records.  Foreign key to BusinessEntity.BusinessEntityID', N'SCHEMA', [Purchasing], N'TABLE', [Vendor], N'COLUMN', [BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Vendor account (identification) number.', N'SCHEMA', [Purchasing], N'TABLE', [Vendor], N'COLUMN', [AccountNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Company name.', N'SCHEMA', [Purchasing], N'TABLE', [Vendor], N'COLUMN', [Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'1 = Superior, 2 = Excellent, 3 = Above average, 4 = Average, 5 = Below average', N'SCHEMA', [Purchasing], N'TABLE', [Vendor], N'COLUMN', [CreditRating];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'0 = Do not use if another vendor is available. 1 = Preferred over other vendors supplying the same product.', N'SCHEMA', [Purchasing], N'TABLE', [Vendor], N'COLUMN', [PreferredVendorStatus];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'0 = Vendor no longer used. 1 = Vendor is actively used.', N'SCHEMA', [Purchasing], N'TABLE', [Vendor], N'COLUMN', [ActiveFlag];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Vendor URL.', N'SCHEMA', [Purchasing], N'TABLE', [Vendor], N'COLUMN', [PurchasingWebServiceURL];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Purchasing], N'TABLE', [Vendor], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Manufacturing work orders.', N'SCHEMA', [Production], N'TABLE', [WorkOrder], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key for WorkOrder records.', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'COLUMN', [WorkOrderID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product identification number. Foreign key to Product.ProductID.', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'COLUMN', [ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product quantity to build.', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'COLUMN', [OrderQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Quantity built and put in inventory.', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'COLUMN', [StockedQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Quantity that failed inspection.', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'COLUMN', [ScrappedQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Work order start date.', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'COLUMN', [StartDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Work order end date.', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'COLUMN', [EndDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Work order due date.', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'COLUMN', [DueDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Reason for inspection failure.', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'COLUMN', [ScrapReasonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'COLUMN', [ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Work order details.', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Foreign key to WorkOrder.WorkOrderID.', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'COLUMN', [WorkOrderID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Foreign key to Product.ProductID.', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'COLUMN', [ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key. Indicates the manufacturing process sequence.', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'COLUMN', [OperationSequence];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Manufacturing location where the part is processed. Foreign key to Location.LocationID.', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'COLUMN', [LocationID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Planned manufacturing start date.', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'COLUMN', [ScheduledStartDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Planned manufacturing end date.', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'COLUMN', [ScheduledEndDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Actual start date.', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'COLUMN', [ActualStartDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Actual end date.', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'COLUMN', [ActualEndDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Number of manufacturing hours used.', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'COLUMN', [ActualResourceHrs];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Estimated manufacturing cost.', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'COLUMN', [PlannedCost];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Actual manufacturing cost.', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'COLUMN', [ActualCost];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Date and time the record was last updated.', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'COLUMN', [ModifiedDate];
GO

PRINT '    Triggers';
GO

-- Triggers
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'INSTEAD OF DELETE trigger which keeps Employees from being deleted.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'TRIGGER', [dEmployee];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'AFTER INSERT, UPDATE trigger inserting Individual only if the Customer does not exist in the Store table and setting the ModifiedDate column in the Person table to the current date.', N'SCHEMA', [Person], N'TABLE', [Person], N'TRIGGER', [iuPerson];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'AFTER INSERT trigger that inserts a row in the TransactionHistory table and updates the PurchaseOrderHeader.SubTotal column.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'TRIGGER', [iPurchaseOrderDetail];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'AFTER UPDATE trigger that inserts a row in the TransactionHistory table, updates ModifiedDate in PurchaseOrderDetail and updates the PurchaseOrderHeader.SubTotal column.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'TRIGGER', [uPurchaseOrderDetail];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'AFTER UPDATE trigger that updates the RevisionNumber and ModifiedDate columns in the PurchaseOrderHeader table.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'TRIGGER', [uPurchaseOrderHeader];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'AFTER INSERT, DELETE, UPDATE trigger that inserts a row in the TransactionHistory table, updates ModifiedDate in SalesOrderDetail and updates the SalesOrderHeader.SubTotal column.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'TRIGGER', [iduSalesOrderDetail];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'AFTER UPDATE trigger that updates the RevisionNumber and ModifiedDate columns in the SalesOrderHeader table.Updates the SalesYTD column in the SalesPerson and SalesTerritory tables.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'TRIGGER', [uSalesOrderHeader];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'INSTEAD OF DELETE trigger which keeps Vendors from being deleted.', N'SCHEMA', [Purchasing], N'TABLE', [Vendor], N'TRIGGER', [dVendor];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'AFTER INSERT trigger that inserts a row in the TransactionHistory table.', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'TRIGGER', [iWorkOrder];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'AFTER UPDATE trigger that inserts a row in the TransactionHistory table, updates ModifiedDate in the WorkOrder table.', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'TRIGGER', [uWorkOrder];
GO

PRINT '    Views';
GO

-- Views
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Displays the contact name and content from each element in the xml column AdditionalContactInfo for that person.', N'SCHEMA', [Person], N'VIEW', [vAdditionalContactInfo], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Employee names and addresses.', N'SCHEMA', [HumanResources], N'VIEW', [vEmployee], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Returns employee name, title, and current department.', N'SCHEMA', [HumanResources], N'VIEW', [vEmployeeDepartment], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Returns employee name and current and previous departments.', N'SCHEMA', [HumanResources], N'VIEW', [vEmployeeDepartmentHistory], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Individual customers (names and addresses) that purchase Adventure Works Cycles products online.', N'SCHEMA', [Sales], N'VIEW', [vIndividualCustomer], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Displays the content from each element in the xml column Demographics for each customer in the Person.Person table.', N'SCHEMA', [Sales], N'VIEW', [vPersonDemographics], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Job candidate names and resumes.', N'SCHEMA', [HumanResources], N'VIEW', [vJobCandidate], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Displays the content from each employement history related element in the xml column Resume in the HumanResources.JobCandidate table. The content has been localized into French, Simplified Chinese and Thai. Some data may not display correctly unless supplemental language support is installed.', N'SCHEMA', [HumanResources], N'VIEW', [vJobCandidateEmployment], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Displays the content from each education related element in the xml column Resume in the HumanResources.JobCandidate table. The content has been localized into French, Simplified Chinese and Thai. Some data may not display correctly unless supplemental language support is installed.', N'SCHEMA', [HumanResources], N'VIEW', [vJobCandidateEducation], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Product names and descriptions. Product descriptions are provided in multiple languages.', N'SCHEMA', [Production], N'VIEW', [vProductAndDescription], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Displays the content from each element in the xml column CatalogDescription for each product in the Production.ProductModel table that has catalog data.', N'SCHEMA', [Production], N'VIEW', [vProductModelCatalogDescription], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Displays the content from each element in the xml column Instructions for each product in the Production.ProductModel table that has manufacturing instructions.', N'SCHEMA', [Production], N'VIEW', [vProductModelInstructions], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Sales representiatives (names and addresses) and their sales-related information.', N'SCHEMA', [Sales], N'VIEW', [vSalesPerson], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Uses PIVOT to return aggregated sales information for each sales representative.', N'SCHEMA', [Sales], N'VIEW', [vSalesPersonSalesByFiscalYears], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Joins StateProvince table with CountryRegion table.', N'SCHEMA', [Person], N'VIEW', [vStateProvinceCountryRegion], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Stores (including demographics) that sell Adventure Works Cycles products to consumers.', N'SCHEMA', [Sales], N'VIEW', [vStoreWithDemographics], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Stores (including store contacts) that sell Adventure Works Cycles products to consumers.', N'SCHEMA', [Sales], N'VIEW', [vStoreWithContacts], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Stores (including store addresses) that sell Adventure Works Cycles products to consumers.', N'SCHEMA', [Sales], N'VIEW', [vStoreWithAddresses], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Vendor (company) names  and the names of vendor employees to contact.', N'SCHEMA', [Purchasing], N'VIEW', [vVendorWithContacts], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Vendor (company) names and addresses .', N'SCHEMA', [Purchasing], N'VIEW', [vVendorWithAddresses], NULL, NULL;
GO

PRINT '    Indexes';
GO

-- Indexes
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Person], N'TABLE', [Address], N'INDEX', [AK_Address_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Person], N'TABLE', [Address], N'INDEX', [IX_Address_AddressLine1_AddressLine2_City_StateProvinceID_PostalCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Person], N'TABLE', [Address], N'INDEX', [IX_Address_StateProvinceID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Person], N'TABLE', [Address], N'INDEX', [PK_Address_AddressID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Person], N'TABLE', [AddressType], N'INDEX', [AK_AddressType_Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Person], N'TABLE', [AddressType], N'INDEX', [AK_AddressType_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Person], N'TABLE', [AddressType], N'INDEX', [PK_AddressType_AddressTypeID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [dbo], N'TABLE', [AWBuildVersion], N'INDEX', [PK_AWBuildVersion_SystemInformationID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index.', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'INDEX', [AK_BillOfMaterials_ProductAssemblyID_ComponentID_StartDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'INDEX', [IX_BillOfMaterials_UnitMeasureCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'INDEX', [PK_BillOfMaterials_BillOfMaterialsID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Person], N'TABLE', [BusinessEntity], N'INDEX', [AK_BusinessEntity_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Person], N'TABLE', [BusinessEntity], N'INDEX', [PK_BusinessEntity_BusinessEntityID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityAddress], N'INDEX', [AK_BusinessEntityAddress_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityAddress], N'INDEX', [IX_BusinessEntityAddress_AddressID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityAddress], N'INDEX', [IX_BusinessEntityAddress_AddressTypeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityAddress], N'INDEX', [PK_BusinessEntityAddress_BusinessEntityID_AddressID_AddressTypeID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityContact], N'INDEX', [AK_BusinessEntityContact_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityContact], N'INDEX', [IX_BusinessEntityContact_PersonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityContact], N'INDEX', [IX_BusinessEntityContact_ContactTypeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityContact], N'INDEX', [PK_BusinessEntityContact_BusinessEntityID_PersonID_ContactTypeID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Person], N'TABLE', [ContactType], N'INDEX', [AK_ContactType_Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Person], N'TABLE', [ContactType], N'INDEX', [PK_ContactType_ContactTypeID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Person], N'TABLE', [CountryRegion], N'INDEX', [AK_CountryRegion_Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Person], N'TABLE', [CountryRegion], N'INDEX', [PK_CountryRegion_CountryRegionCode];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Sales], N'TABLE', [CountryRegionCurrency], N'INDEX', [IX_CountryRegionCurrency_CurrencyCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [CountryRegionCurrency], N'INDEX', [PK_CountryRegionCurrency_CountryRegionCode_CurrencyCode];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Sales], N'TABLE', [CreditCard], N'INDEX', [AK_CreditCard_CardNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [CreditCard], N'INDEX', [PK_CreditCard_CreditCardID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Production], N'TABLE', [Culture], N'INDEX', [AK_Culture_Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [Culture], N'INDEX', [PK_Culture_CultureID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Sales], N'TABLE', [Currency], N'INDEX', [AK_Currency_Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [Currency], N'INDEX', [PK_Currency_CurrencyCode];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Sales], N'TABLE', [CurrencyRate], N'INDEX', [AK_CurrencyRate_CurrencyRateDate_FromCurrencyCode_ToCurrencyCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [CurrencyRate], N'INDEX', [PK_CurrencyRate_CurrencyRateID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Sales], N'TABLE', [Customer], N'INDEX', [AK_Customer_AccountNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Sales], N'TABLE', [Customer], N'INDEX', [AK_Customer_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Sales], N'TABLE', [Customer], N'INDEX', [IX_Customer_TerritoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [Customer], N'INDEX', [PK_Customer_CustomerID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index created by a primary key constraint.', N'SCHEMA', [dbo], N'TABLE', [DatabaseLog], N'INDEX', [PK_DatabaseLog_DatabaseLogID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [HumanResources], N'TABLE', [Department], N'INDEX', [AK_Department_Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [HumanResources], N'TABLE', [Department], N'INDEX', [PK_Department_DepartmentID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Production], N'TABLE', [Document], N'INDEX', [AK_Document_DocumentLevel_DocumentNode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Production], N'TABLE', [Document], N'INDEX', [IX_Document_FileName_Revision];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [Document], N'INDEX', [PK_Document_DocumentNode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support FileStream.', N'SCHEMA', [Production], N'TABLE', [Document], N'INDEX', [AK_Document_rowguid];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Person], N'TABLE', [EmailAddress], N'INDEX', [IX_EmailAddress_EmailAddress];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Person], N'TABLE', [EmailAddress], N'INDEX', [PK_EmailAddress_BusinessEntityID_EmailAddressID];


EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'INDEX', [AK_Employee_LoginID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'INDEX', [AK_Employee_NationalIDNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'INDEX', [AK_Employee_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'INDEX', [IX_Employee_OrganizationNode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'INDEX', [IX_Employee_OrganizationLevel_OrganizationNode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'INDEX', [PK_Employee_BusinessEntityID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [HumanResources], N'TABLE', [EmployeeDepartmentHistory], N'INDEX', [IX_EmployeeDepartmentHistory_DepartmentID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [HumanResources], N'TABLE', [EmployeeDepartmentHistory], N'INDEX', [IX_EmployeeDepartmentHistory_ShiftID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [HumanResources], N'TABLE', [EmployeeDepartmentHistory], N'INDEX', [PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_DepartmentID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [HumanResources], N'TABLE', [EmployeePayHistory], N'INDEX', [PK_EmployeePayHistory_BusinessEntityID_RateChangeDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [dbo], N'TABLE', [ErrorLog], N'INDEX', [PK_ErrorLog_ErrorLogID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [Illustration], N'INDEX', [PK_Illustration_IllustrationID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [HumanResources], N'TABLE', [JobCandidate], N'INDEX', [IX_JobCandidate_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [HumanResources], N'TABLE', [JobCandidate], N'INDEX', [PK_JobCandidate_JobCandidateID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Production], N'TABLE', [Location], N'INDEX', [AK_Location_Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [Location], N'INDEX', [PK_Location_LocationID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Person], N'TABLE', [Password], N'INDEX', [PK_Password_BusinessEntityID];

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Person], N'TABLE', [Person], N'INDEX', [AK_Person_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Person], N'TABLE', [Person], N'INDEX', [PK_Person_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary XML index.', N'SCHEMA', [Person], N'TABLE', [Person], N'INDEX', [PXML_Person_Demographics];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Secondary XML index for path.', N'SCHEMA', [Person], N'TABLE', [Person], N'INDEX', [XMLPATH_Person_Demographics];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Secondary XML index for property.', N'SCHEMA', [Person], N'TABLE', [Person], N'INDEX', [XMLPROPERTY_Person_Demographics];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Secondary XML index for value.', N'SCHEMA', [Person], N'TABLE', [Person], N'INDEX', [XMLVALUE_Person_Demographics];

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary XML index.', N'SCHEMA', [Person], N'TABLE', [Person], N'INDEX', [PXML_Person_AddContact];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [PersonCreditCard], N'INDEX', [PK_PersonCreditCard_BusinessEntityID_CreditCardID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Person], N'TABLE', [PersonPhone], N'INDEX', [PK_PersonPhone_BusinessEntityID_PhoneNumber_PhoneNumberTypeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Person], N'TABLE', [PersonPhone], N'INDEX', [IX_PersonPhone_PhoneNumber];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Person], N'TABLE', [PhoneNumberType], N'INDEX', [PK_PhoneNumberType_PhoneNumberTypeID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Production], N'TABLE', [Product], N'INDEX', [AK_Product_ProductNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [Product], N'INDEX', [PK_Product_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Production], N'TABLE', [Product], N'INDEX', [AK_Product_Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Production], N'TABLE', [Product], N'INDEX', [AK_Product_rowguid];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Production], N'TABLE', [ProductCategory], N'INDEX', [AK_ProductCategory_Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Production], N'TABLE', [ProductCategory], N'INDEX', [AK_ProductCategory_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [ProductCategory], N'INDEX', [PK_ProductCategory_ProductCategoryID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [ProductCostHistory], N'INDEX', [PK_ProductCostHistory_ProductID_StartDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Production], N'TABLE', [ProductDescription], N'INDEX', [AK_ProductDescription_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [ProductDescription], N'INDEX', [PK_ProductDescription_ProductDescriptionID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [ProductDocument], N'INDEX', [PK_ProductDocument_ProductID_DocumentNode];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [ProductInventory], N'INDEX', [PK_ProductInventory_ProductID_LocationID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [ProductListPriceHistory], N'INDEX', [PK_ProductListPriceHistory_ProductID_StartDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Production], N'TABLE', [ProductModel], N'INDEX', [AK_ProductModel_Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Production], N'TABLE', [ProductModel], N'INDEX', [AK_ProductModel_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [ProductModel], N'INDEX', [PK_ProductModel_ProductModelID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary XML index.', N'SCHEMA', [Production], N'TABLE', [ProductModel], N'INDEX', [PXML_ProductModel_CatalogDescription];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary XML index.', N'SCHEMA', [Production], N'TABLE', [ProductModel], N'INDEX', [PXML_ProductModel_Instructions];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [ProductModelIllustration], N'INDEX', [PK_ProductModelIllustration_ProductModelID_IllustrationID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [ProductModelProductDescriptionCulture], N'INDEX', [PK_ProductModelProductDescriptionCulture_ProductModelID_ProductDescriptionID_CultureID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [ProductPhoto], N'INDEX', [PK_ProductPhoto_ProductPhotoID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [ProductProductPhoto], N'INDEX', [PK_ProductProductPhoto_ProductID_ProductPhotoID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Production], N'TABLE', [ProductReview], N'INDEX', [IX_ProductReview_ProductID_Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [ProductReview], N'INDEX', [PK_ProductReview_ProductReviewID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Production], N'TABLE', [ProductSubcategory], N'INDEX', [AK_ProductSubcategory_Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Production], N'TABLE', [ProductSubcategory], N'INDEX', [AK_ProductSubcategory_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [ProductSubcategory], N'INDEX', [PK_ProductSubcategory_ProductSubcategoryID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'INDEX', [IX_ProductVendor_UnitMeasureCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'INDEX', [IX_ProductVendor_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'INDEX', [PK_ProductVendor_ProductID_BusinessEntityID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'INDEX', [IX_PurchaseOrderDetail_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'INDEX', [PK_PurchaseOrderDetail_PurchaseOrderID_PurchaseOrderDetailID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'INDEX', [IX_PurchaseOrderHeader_EmployeeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'INDEX', [IX_PurchaseOrderHeader_VendorID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'INDEX', [PK_PurchaseOrderHeader_PurchaseOrderID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'INDEX', [AK_SalesOrderDetail_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'INDEX', [IX_SalesOrderDetail_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'INDEX', [PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'INDEX', [AK_SalesOrderHeader_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'INDEX', [AK_SalesOrderHeader_SalesOrderNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'INDEX', [IX_SalesOrderHeader_CustomerID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'INDEX', [IX_SalesOrderHeader_SalesPersonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'INDEX', [PK_SalesOrderHeader_SalesOrderID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeaderSalesReason], N'INDEX', [PK_SalesOrderHeaderSalesReason_SalesOrderID_SalesReasonID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'INDEX', [AK_SalesPerson_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'INDEX', [PK_SalesPerson_BusinessEntityID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Sales], N'TABLE', [SalesPersonQuotaHistory], N'INDEX', [AK_SalesPersonQuotaHistory_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [SalesPersonQuotaHistory], N'INDEX', [PK_SalesPersonQuotaHistory_BusinessEntityID_QuotaDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [SalesReason], N'INDEX', [PK_SalesReason_SalesReasonID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Sales], N'TABLE', [SalesTaxRate], N'INDEX', [AK_SalesTaxRate_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Sales], N'TABLE', [SalesTaxRate], N'INDEX', [AK_SalesTaxRate_StateProvinceID_TaxType];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [SalesTaxRate], N'INDEX', [PK_SalesTaxRate_SalesTaxRateID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'INDEX', [AK_SalesTerritory_Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'INDEX', [AK_SalesTerritory_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'INDEX', [PK_SalesTerritory_TerritoryID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritoryHistory], N'INDEX', [AK_SalesTerritoryHistory_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritoryHistory], N'INDEX', [PK_SalesTerritoryHistory_BusinessEntityID_StartDate_TerritoryID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Production], N'TABLE', [ScrapReason], N'INDEX', [AK_ScrapReason_Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [ScrapReason], N'INDEX', [PK_ScrapReason_ScrapReasonID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [HumanResources], N'TABLE', [Shift], N'INDEX', [AK_Shift_Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [HumanResources], N'TABLE', [Shift], N'INDEX', [AK_Shift_StartTime_EndTime];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [HumanResources], N'TABLE', [Shift], N'INDEX', [PK_Shift_ShiftID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Purchasing], N'TABLE', [ShipMethod], N'INDEX', [AK_ShipMethod_Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Purchasing], N'TABLE', [ShipMethod], N'INDEX', [AK_ShipMethod_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Purchasing], N'TABLE', [ShipMethod], N'INDEX', [PK_ShipMethod_ShipMethodID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Sales], N'TABLE', [ShoppingCartItem], N'INDEX', [IX_ShoppingCartItem_ShoppingCartID_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [ShoppingCartItem], N'INDEX', [PK_ShoppingCartItem_ShoppingCartItemID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'INDEX', [AK_SpecialOffer_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'INDEX', [PK_SpecialOffer_SpecialOfferID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Sales], N'TABLE', [SpecialOfferProduct], N'INDEX', [AK_SpecialOfferProduct_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Sales], N'TABLE', [SpecialOfferProduct], N'INDEX', [IX_SpecialOfferProduct_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [SpecialOfferProduct], N'INDEX', [PK_SpecialOfferProduct_SpecialOfferID_ProductID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Person], N'TABLE', [StateProvince], N'INDEX', [AK_StateProvince_Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Person], N'TABLE', [StateProvince], N'INDEX', [AK_StateProvince_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Person], N'TABLE', [StateProvince], N'INDEX', [AK_StateProvince_StateProvinceCode_CountryRegionCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Person], N'TABLE', [StateProvince], N'INDEX', [PK_StateProvince_StateProvinceID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', N'SCHEMA', [Sales], N'TABLE', [Store], N'INDEX', [AK_Store_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Sales], N'TABLE', [Store], N'INDEX', [PK_Store_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Sales], N'TABLE', [Store], N'INDEX', [IX_Store_SalesPersonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary XML index.', N'SCHEMA', [Sales], N'TABLE', [Store], N'INDEX', [PXML_Store_Demographics];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], N'INDEX', [IX_TransactionHistory_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], N'INDEX', [IX_TransactionHistory_ReferenceOrderID_ReferenceOrderLineID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], N'INDEX', [PK_TransactionHistory_TransactionID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Production], N'TABLE', [TransactionHistoryArchive], N'INDEX', [IX_TransactionHistoryArchive_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Production], N'TABLE', [TransactionHistoryArchive], N'INDEX', [IX_TransactionHistoryArchive_ReferenceOrderID_ReferenceOrderLineID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [TransactionHistoryArchive], N'INDEX', [PK_TransactionHistoryArchive_TransactionID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Production], N'TABLE', [UnitMeasure], N'INDEX', [AK_UnitMeasure_Name];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [UnitMeasure], N'INDEX', [PK_UnitMeasure_UnitMeasureCode];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Unique nonclustered index.', N'SCHEMA', [Purchasing], N'TABLE', [Vendor], N'INDEX', [AK_Vendor_AccountNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Purchasing], N'TABLE', [Vendor], N'INDEX', [PK_Vendor_BusinessEntityID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'INDEX', [IX_WorkOrder_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'INDEX', [IX_WorkOrder_ScrapReasonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'INDEX', [PK_WorkOrder_WorkOrderID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Nonclustered index.', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'INDEX', [IX_WorkOrderRouting_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index created by a primary key constraint.', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'INDEX', [PK_WorkOrderRouting_WorkOrderID_ProductID_OperationSequence];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index on the view vProductAndDescription.', N'SCHEMA', [Production], N'VIEW', [vProductAndDescription], N'INDEX', [IX_vProductAndDescription];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Clustered index on the view vStateProvinceCountryRegion.', N'SCHEMA', [Person], N'VIEW', [vStateProvinceCountryRegion], N'INDEX', [IX_vStateProvinceCountryRegion];
GO

PRINT '    Constraints - PK, FK, DF, CK';
GO

-- Constraints - PK, FK, DF, CK
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Person], N'TABLE', [Address], N'CONSTRAINT', [PK_Address_AddressID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing StateProvince.StateProvinceID.', N'SCHEMA', [Person], N'TABLE', [Address], N'CONSTRAINT', [FK_Address_StateProvince_StateProvinceID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Person], N'TABLE', [Address], N'CONSTRAINT', [DF_Address_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Person], N'TABLE', [Address], N'CONSTRAINT', [DF_Address_rowguid];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Person], N'TABLE', [AddressType], N'CONSTRAINT', [PK_AddressType_AddressTypeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Person], N'TABLE', [AddressType], N'CONSTRAINT', [DF_AddressType_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Person], N'TABLE', [AddressType], N'CONSTRAINT', [DF_AddressType_rowguid];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [dbo], N'TABLE', [AWBuildVersion], N'CONSTRAINT', [PK_AWBuildVersion_SystemInformationID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [dbo], N'TABLE', [AWBuildVersion], N'CONSTRAINT', [DF_AWBuildVersion_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'CONSTRAINT', [PK_BillOfMaterials_BillOfMaterialsID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Product.ComponentID.', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'CONSTRAINT', [FK_BillOfMaterials_Product_ComponentID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Product.ProductAssemblyID.', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'CONSTRAINT', [FK_BillOfMaterials_Product_ProductAssemblyID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing UnitMeasure.UnitMeasureCode.', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'CONSTRAINT', [FK_BillOfMaterials_UnitMeasure_UnitMeasureCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 1.0', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'CONSTRAINT', [DF_BillOfMaterials_PerAssemblyQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'CONSTRAINT', [DF_BillOfMaterials_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'CONSTRAINT', [DF_BillOfMaterials_StartDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [PerAssemblyQty] >= (1.00)', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'CONSTRAINT', [CK_BillOfMaterials_PerAssemblyQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [ProductAssemblyID] <> [ComponentID]', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'CONSTRAINT', [CK_BillOfMaterials_ProductAssemblyID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint EndDate] > [StartDate] OR [EndDate] IS NULL', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'CONSTRAINT', [CK_BillOfMaterials_EndDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [ProductAssemblyID] IS NULL AND [BOMLevel] = (0) AND [PerAssemblyQty] = (1) OR [ProductAssemblyID] IS NOT NULL AND [BOMLevel] >= (1)', N'SCHEMA', [Production], N'TABLE', [BillOfMaterials], N'CONSTRAINT', [CK_BillOfMaterials_BOMLevel];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Person], N'TABLE', [BusinessEntity], N'CONSTRAINT', [PK_BusinessEntity_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Person], N'TABLE', [BusinessEntity], N'CONSTRAINT', [DF_BusinessEntity_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Person], N'TABLE', [BusinessEntity], N'CONSTRAINT', [DF_BusinessEntity_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Person], N'TABLE', [BusinessEntityAddress], N'CONSTRAINT', [PK_BusinessEntityAddress_BusinessEntityID_AddressID_AddressTypeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Address.AddressID.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityAddress], N'CONSTRAINT', [FK_BusinessEntityAddress_Address_AddressID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing AddressType.AddressTypeID.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityAddress], N'CONSTRAINT', [FK_BusinessEntityAddress_AddressType_AddressTypeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing BusinessEntity.BusinessEntityID.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityAddress], N'CONSTRAINT', [FK_BusinessEntityAddress_BusinessEntity_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Person], N'TABLE', [BusinessEntityAddress], N'CONSTRAINT', [DF_BusinessEntityAddress_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Person], N'TABLE', [BusinessEntityAddress], N'CONSTRAINT', [DF_BusinessEntityAddress_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Person], N'TABLE', [BusinessEntityContact], N'CONSTRAINT', [PK_BusinessEntityContact_BusinessEntityID_PersonID_ContactTypeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Person.BusinessEntityID.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityContact], N'CONSTRAINT', [FK_BusinessEntityContact_Person_PersonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing ContactType.ContactTypeID.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityContact], N'CONSTRAINT', [FK_BusinessEntityContact_ContactType_ContactTypeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing BusinessEntity.BusinessEntityID.', N'SCHEMA', [Person], N'TABLE', [BusinessEntityContact], N'CONSTRAINT', [FK_BusinessEntityContact_BusinessEntity_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Person], N'TABLE', [BusinessEntityContact], N'CONSTRAINT', [DF_BusinessEntityContact_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Person], N'TABLE', [BusinessEntityContact], N'CONSTRAINT', [DF_BusinessEntityContact_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Person], N'TABLE', [ContactType], N'CONSTRAINT', [PK_ContactType_ContactTypeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Person], N'TABLE', [ContactType], N'CONSTRAINT', [DF_ContactType_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Person], N'TABLE', [CountryRegion], N'CONSTRAINT', [PK_CountryRegion_CountryRegionCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Person], N'TABLE', [CountryRegion], N'CONSTRAINT', [DF_CountryRegion_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [CountryRegionCurrency], N'CONSTRAINT', [PK_CountryRegionCurrency_CountryRegionCode_CurrencyCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing CountryRegion.CountryRegionCode.', N'SCHEMA', [Sales], N'TABLE', [CountryRegionCurrency], N'CONSTRAINT', [FK_CountryRegionCurrency_CountryRegion_CountryRegionCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Currency.CurrencyCode.', N'SCHEMA', [Sales], N'TABLE', [CountryRegionCurrency], N'CONSTRAINT', [FK_CountryRegionCurrency_Currency_CurrencyCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [CountryRegionCurrency], N'CONSTRAINT', [DF_CountryRegionCurrency_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [CreditCard], N'CONSTRAINT', [PK_CreditCard_CreditCardID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [CreditCard], N'CONSTRAINT', [DF_CreditCard_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [Culture], N'CONSTRAINT', [PK_Culture_CultureID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [Culture], N'CONSTRAINT', [DF_Culture_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [Currency], N'CONSTRAINT', [PK_Currency_CurrencyCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [Currency], N'CONSTRAINT', [DF_Currency_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [CurrencyRate], N'CONSTRAINT', [PK_CurrencyRate_CurrencyRateID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Currency.FromCurrencyCode.', N'SCHEMA', [Sales], N'TABLE', [CurrencyRate], N'CONSTRAINT', [FK_CurrencyRate_Currency_FromCurrencyCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Currency.ToCurrencyCode.', N'SCHEMA', [Sales], N'TABLE', [CurrencyRate], N'CONSTRAINT', [FK_CurrencyRate_Currency_ToCurrencyCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [CurrencyRate], N'CONSTRAINT', [DF_CurrencyRate_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [Customer], N'CONSTRAINT', [PK_Customer_CustomerID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Person.BusinessEntityID.', N'SCHEMA', [Sales], N'TABLE', [Customer], N'CONSTRAINT', [FK_Customer_Person_PersonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Store.BusinessEntityID.', N'SCHEMA', [Sales], N'TABLE', [Customer], N'CONSTRAINT', [FK_Customer_Store_StoreID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing SalesTerritory.TerritoryID.', N'SCHEMA', [Sales], N'TABLE', [Customer], N'CONSTRAINT', [FK_Customer_SalesTerritory_TerritoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [Customer], N'CONSTRAINT', [DF_Customer_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Sales], N'TABLE', [Customer], N'CONSTRAINT', [DF_Customer_rowguid];
GO

EXEC [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (nonclustered) constraint', N'SCHEMA', [dbo], N'TABLE', [DatabaseLog], N'CONSTRAINT', [PK_DatabaseLog_DatabaseLogID];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [HumanResources], N'TABLE', [Department], N'CONSTRAINT', [PK_Department_DepartmentID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [HumanResources], N'TABLE', [Department], N'CONSTRAINT', [DF_Department_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [Document], N'CONSTRAINT', [PK_Document_DocumentNode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Employee.BusinessEntityID.', N'SCHEMA', [Production], N'TABLE', [Document], N'CONSTRAINT', [FK_Document_Employee_Owner];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0', N'SCHEMA', [Production], N'TABLE', [Document], N'CONSTRAINT', [DF_Document_ChangeNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [Document], N'CONSTRAINT', [DF_Document_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [Status] BETWEEN (1) AND (3)', N'SCHEMA', [Production], N'TABLE', [Document], N'CONSTRAINT', [CK_Document_Status];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Production], N'TABLE', [Document], N'CONSTRAINT', [DF_Document_rowguid];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Person], N'TABLE', [EmailAddress], N'CONSTRAINT', [PK_EmailAddress_BusinessEntityID_EmailAddressID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Person.BusinessEntityID.', N'SCHEMA', [Person], N'TABLE', [EmailAddress], N'CONSTRAINT', [FK_EmailAddress_Person_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Person], N'TABLE', [EmailAddress], N'CONSTRAINT', [DF_EmailAddress_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Person], N'TABLE', [EmailAddress], N'CONSTRAINT', [DF_EmailAddress_rowguid];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'CONSTRAINT', [PK_Employee_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Person.BusinessEntityID.', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'CONSTRAINT', [FK_Employee_Person_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'CONSTRAINT', [DF_Employee_SickLeaveHours];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'CONSTRAINT', [DF_Employee_VacationHours];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 1 (TRUE)', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'CONSTRAINT', [DF_Employee_SalariedFlag];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 1', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'CONSTRAINT', [DF_Employee_CurrentFlag];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'CONSTRAINT', [DF_Employee_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'CONSTRAINT', [DF_Employee_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [BirthDate] >= ''1930-01-01'' AND [BirthDate] <= dateadd(year,(-18),GETDATE())', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'CONSTRAINT', [CK_Employee_BirthDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [HireDate] >= ''1996-07-01'' AND [HireDate] <= dateadd(day,(1),GETDATE())', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'CONSTRAINT', [CK_Employee_HireDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [SickLeaveHours] >= (0) AND [SickLeaveHours] <= (120)', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'CONSTRAINT', [CK_Employee_SickLeaveHours];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [VacationHours] >= (-40) AND [VacationHours] <= (240)', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'CONSTRAINT', [CK_Employee_VacationHours];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [Gender]=''f'' OR [Gender]=''m'' OR [Gender]=''F'' OR [Gender]=''M''', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'CONSTRAINT', [CK_Employee_Gender];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [MaritalStatus]=''s'' OR [MaritalStatus]=''m'' OR [MaritalStatus]=''S'' OR [MaritalStatus]=''M''', N'SCHEMA', [HumanResources], N'TABLE', [Employee], N'CONSTRAINT', [CK_Employee_MaritalStatus];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [HumanResources], N'TABLE', [EmployeeDepartmentHistory], N'CONSTRAINT', [PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_DepartmentID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Shift.ShiftID', N'SCHEMA', [HumanResources], N'TABLE', [EmployeeDepartmentHistory], N'CONSTRAINT', [FK_EmployeeDepartmentHistory_Shift_ShiftID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Department.DepartmentID.', N'SCHEMA', [HumanResources], N'TABLE', [EmployeeDepartmentHistory], N'CONSTRAINT', [FK_EmployeeDepartmentHistory_Department_DepartmentID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Employee.EmployeeID.', N'SCHEMA', [HumanResources], N'TABLE', [EmployeeDepartmentHistory], N'CONSTRAINT', [FK_EmployeeDepartmentHistory_Employee_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [HumanResources], N'TABLE', [EmployeeDepartmentHistory], N'CONSTRAINT', [DF_EmployeeDepartmentHistory_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [EndDate] >= [StartDate] OR [EndDate] IS NUL', N'SCHEMA', [HumanResources], N'TABLE', [EmployeeDepartmentHistory], N'CONSTRAINT', [CK_EmployeeDepartmentHistory_EndDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [HumanResources], N'TABLE', [EmployeePayHistory], N'CONSTRAINT', [PK_EmployeePayHistory_BusinessEntityID_RateChangeDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Employee.EmployeeID.', N'SCHEMA', [HumanResources], N'TABLE', [EmployeePayHistory], N'CONSTRAINT', [FK_EmployeePayHistory_Employee_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [HumanResources], N'TABLE', [EmployeePayHistory], N'CONSTRAINT', [DF_EmployeePayHistory_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [Rate] >= (6.50) AND [Rate] <= (200.00)', N'SCHEMA', [HumanResources], N'TABLE', [EmployeePayHistory], N'CONSTRAINT', [CK_EmployeePayHistory_Rate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [PayFrequency]=(3) OR [PayFrequency]=(2) OR [PayFrequency]=(1)', N'SCHEMA', [HumanResources], N'TABLE', [EmployeePayHistory], N'CONSTRAINT', [CK_EmployeePayHistory_PayFrequency];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [dbo], N'TABLE', [ErrorLog], N'CONSTRAINT', [PK_ErrorLog_ErrorLogID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [dbo], N'TABLE', [ErrorLog], N'CONSTRAINT', [DF_ErrorLog_ErrorTime];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [Illustration], N'CONSTRAINT', [PK_Illustration_IllustrationID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [Illustration], N'CONSTRAINT', [DF_Illustration_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [HumanResources], N'TABLE', [JobCandidate], N'CONSTRAINT', [PK_JobCandidate_JobCandidateID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Employee.EmployeeID.', N'SCHEMA', [HumanResources], N'TABLE', [JobCandidate], N'CONSTRAINT', [FK_JobCandidate_Employee_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [HumanResources], N'TABLE', [JobCandidate], N'CONSTRAINT', [DF_JobCandidate_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [Location], N'CONSTRAINT', [PK_Location_LocationID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.00', N'SCHEMA', [Production], N'TABLE', [Location], N'CONSTRAINT', [DF_Location_Availability];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Production], N'TABLE', [Location], N'CONSTRAINT', [DF_Location_CostRate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [Location], N'CONSTRAINT', [DF_Location_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [Availability] >= (0.00)', N'SCHEMA', [Production], N'TABLE', [Location], N'CONSTRAINT', [CK_Location_Availability];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [CostRate] >= (0.00)', N'SCHEMA', [Production], N'TABLE', [Location], N'CONSTRAINT', [CK_Location_CostRate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Person], N'TABLE', [Password], N'CONSTRAINT', [PK_Password_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Person.BusinessEntityID.', N'SCHEMA', [Person], N'TABLE', [Password], N'CONSTRAINT', [FK_Password_Person_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Person], N'TABLE', [Password], N'CONSTRAINT', [DF_Password_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Person], N'TABLE', [Password], N'CONSTRAINT', [DF_Password_rowguid];

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Person], N'TABLE', [Person], N'CONSTRAINT', [PK_Person_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing BusinessEntity.BusinessEntityID.', N'SCHEMA', [Person], N'TABLE', [Person], N'CONSTRAINT', [FK_Person_BusinessEntity_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0', N'SCHEMA', [Person], N'TABLE', [Person], N'CONSTRAINT', [DF_Person_EmailPromotion];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0', N'SCHEMA', [Person], N'TABLE', [Person], N'CONSTRAINT', [DF_Person_NameStyle];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Person], N'TABLE', [Person], N'CONSTRAINT', [DF_Person_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Person], N'TABLE', [Person], N'CONSTRAINT', [DF_Person_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [EmailPromotion] >= (0) AND [EmailPromotion] <= (2)', N'SCHEMA', [Person], N'TABLE', [Person], N'CONSTRAINT', [CK_Person_EmailPromotion];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [PersonType] is one of SC, VC, IN, EM or SP.', N'SCHEMA', [Person], N'TABLE', [Person], N'CONSTRAINT', [CK_Person_PersonType];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [PersonCreditCard], N'CONSTRAINT', [PK_PersonCreditCard_BusinessEntityID_CreditCardID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Person.BusinessEntityID.', N'SCHEMA', [Sales], N'TABLE', [PersonCreditCard], N'CONSTRAINT', [FK_PersonCreditCard_Person_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing CreditCard.CreditCardID.', N'SCHEMA', [Sales], N'TABLE', [PersonCreditCard], N'CONSTRAINT', [FK_PersonCreditCard_CreditCard_CreditCardID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [PersonCreditCard], N'CONSTRAINT', [DF_PersonCreditCard_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Person], N'TABLE', [PersonPhone], N'CONSTRAINT', [PK_PersonPhone_BusinessEntityID_PhoneNumber_PhoneNumberTypeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Person.BusinessEntityID.', N'SCHEMA', [Person], N'TABLE', [PersonPhone], N'CONSTRAINT', [FK_PersonPhone_Person_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing PhoneNumberType.PhoneNumberTypeID.', N'SCHEMA', [Person], N'TABLE', [PersonPhone], N'CONSTRAINT', [FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Person], N'TABLE', [PersonPhone], N'CONSTRAINT', [DF_PersonPhone_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Person], N'TABLE', [PhoneNumberType], N'CONSTRAINT', [PK_PhoneNumberType_PhoneNumberTypeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Person], N'TABLE', [PhoneNumberType], N'CONSTRAINT', [DF_PhoneNumberType_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [PK_Product_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing ProductModel.ProductModelID.', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [FK_Product_ProductModel_ProductModelID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing ProductSubcategory.ProductSubcategoryID.', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [FK_Product_ProductSubcategory_ProductSubcategoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing UnitMeasure.UnitMeasureCode.', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [FK_Product_UnitMeasure_SizeUnitMeasureCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing UnitMeasure.UnitMeasureCode.', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [FK_Product_UnitMeasure_WeightUnitMeasureCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of  1', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [DF_Product_FinishedGoodsFlag];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of  1', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [DF_Product_MakeFlag];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [DF_Product_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [DF_Product_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [DaysToManufacture] >= (0)', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [CK_Product_DaysToManufacture];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [ListPrice] >= (0.00)', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [CK_Product_ListPrice];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [ReorderPoint] > (0)', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [CK_Product_ReorderPoint];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [SafetyStockLevel] > (0)', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [CK_Product_SafetyStockLevel];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [SafetyStockLevel] > (0)', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [CK_Product_StandardCost];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [Weight] > (0.00)', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [CK_Product_Weight];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [Class]=''h'' OR [Class]=''m'' OR [Class]=''l'' OR [Class]=''H'' OR [Class]=''M'' OR [Class]=''L'' OR [Class] IS NULL', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [CK_Product_Class];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [ProductLine]=''r'' OR [ProductLine]=''m'' OR [ProductLine]=''t'' OR [ProductLine]=''s'' OR [ProductLine]=''R'' OR [ProductLine]=''M'' OR [ProductLine]=''T'' OR [ProductLine]=''S'' OR [ProductLine] IS NULL', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [CK_Product_ProductLine];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [SellEndDate] >= [SellStartDate] OR [SellEndDate] IS NULL', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [CK_Product_SellEndDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [Style]=''u'' OR [Style]=''m'' OR [Style]=''w'' OR [Style]=''U'' OR [Style]=''M'' OR [Style]=''W'' OR [Style] IS NULL', N'SCHEMA', [Production], N'TABLE', [Product], N'CONSTRAINT', [CK_Product_Style];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [ProductCategory], N'CONSTRAINT', [PK_ProductCategory_ProductCategoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [ProductCategory], N'CONSTRAINT', [DF_ProductCategory_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()()', N'SCHEMA', [Production], N'TABLE', [ProductCategory], N'CONSTRAINT', [DF_ProductCategory_rowguid];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [ProductCostHistory], N'CONSTRAINT', [PK_ProductCostHistory_ProductID_StartDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', N'SCHEMA', [Production], N'TABLE', [ProductCostHistory], N'CONSTRAINT', [FK_ProductCostHistory_Product_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [ProductCostHistory], N'CONSTRAINT', [DF_ProductCostHistory_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [StandardCost] >= (0.00)', N'SCHEMA', [Production], N'TABLE', [ProductCostHistory], N'CONSTRAINT', [CK_ProductCostHistory_StandardCost];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [EndDate] >= [StartDate] OR [EndDate] IS NULL', N'SCHEMA', [Production], N'TABLE', [ProductCostHistory], N'CONSTRAINT', [CK_ProductCostHistory_EndDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [ProductDescription], N'CONSTRAINT', [PK_ProductDescription_ProductDescriptionID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [ProductDescription], N'CONSTRAINT', [DF_ProductDescription_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Production], N'TABLE', [ProductDescription], N'CONSTRAINT', [DF_ProductDescription_rowguid];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [ProductDocument], N'CONSTRAINT', [PK_ProductDocument_ProductID_DocumentNode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Document.DocumentNode.', N'SCHEMA', [Production], N'TABLE', [ProductDocument], N'CONSTRAINT', [FK_ProductDocument_Document_DocumentNode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', N'SCHEMA', [Production], N'TABLE', [ProductDocument], N'CONSTRAINT', [FK_ProductDocument_Product_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [ProductDocument], N'CONSTRAINT', [DF_ProductDocument_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [ProductInventory], N'CONSTRAINT', [PK_ProductInventory_ProductID_LocationID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Location.LocationID.', N'SCHEMA', [Production], N'TABLE', [ProductInventory], N'CONSTRAINT', [FK_ProductInventory_Location_LocationID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', N'SCHEMA', [Production], N'TABLE', [ProductInventory], N'CONSTRAINT', [FK_ProductInventory_Product_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0', N'SCHEMA', [Production], N'TABLE', [ProductInventory], N'CONSTRAINT', [DF_ProductInventory_Quantity];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [ProductInventory], N'CONSTRAINT', [DF_ProductInventory_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Production], N'TABLE', [ProductInventory], N'CONSTRAINT', [DF_ProductInventory_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [Bin] BETWEEN (0) AND (100)', N'SCHEMA', [Production], N'TABLE', [ProductInventory], N'CONSTRAINT', [CK_ProductInventory_Bin];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [Shelf] like ''[A-Za-z]'' OR [Shelf]=''N/A''', N'SCHEMA', [Production], N'TABLE', [ProductInventory], N'CONSTRAINT', [CK_ProductInventory_Shelf];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [ProductListPriceHistory], N'CONSTRAINT', [PK_ProductListPriceHistory_ProductID_StartDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', N'SCHEMA', [Production], N'TABLE', [ProductListPriceHistory], N'CONSTRAINT', [FK_ProductListPriceHistory_Product_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [ProductListPriceHistory], N'CONSTRAINT', [DF_ProductListPriceHistory_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [ListPrice] > (0.00)', N'SCHEMA', [Production], N'TABLE', [ProductListPriceHistory], N'CONSTRAINT', [CK_ProductListPriceHistory_ListPrice];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [EndDate] >= [StartDate] OR [EndDate] IS NULL', N'SCHEMA', [Production], N'TABLE', [ProductListPriceHistory], N'CONSTRAINT', [CK_ProductListPriceHistory_EndDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [ProductModel], N'CONSTRAINT', [PK_ProductModel_ProductModelID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [ProductModel], N'CONSTRAINT', [DF_ProductModel_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Production], N'TABLE', [ProductModel], N'CONSTRAINT', [DF_ProductModel_rowguid];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [ProductModelIllustration], N'CONSTRAINT', [PK_ProductModelIllustration_ProductModelID_IllustrationID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Illustration.IllustrationID.', N'SCHEMA', [Production], N'TABLE', [ProductModelIllustration], N'CONSTRAINT', [FK_ProductModelIllustration_Illustration_IllustrationID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing ProductModel.ProductModelID.', N'SCHEMA', [Production], N'TABLE', [ProductModelIllustration], N'CONSTRAINT', [FK_ProductModelIllustration_ProductModel_ProductModelID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [ProductModelIllustration], N'CONSTRAINT', [DF_ProductModelIllustration_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [ProductModelProductDescriptionCulture], N'CONSTRAINT', [PK_ProductModelProductDescriptionCulture_ProductModelID_ProductDescriptionID_CultureID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Culture.CultureID.', N'SCHEMA', [Production], N'TABLE', [ProductModelProductDescriptionCulture], N'CONSTRAINT', [FK_ProductModelProductDescriptionCulture_Culture_CultureID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing ProductDescription.ProductDescriptionID.', N'SCHEMA', [Production], N'TABLE', [ProductModelProductDescriptionCulture], N'CONSTRAINT', [FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing ProductModel.ProductModelID.', N'SCHEMA', [Production], N'TABLE', [ProductModelProductDescriptionCulture], N'CONSTRAINT', [FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [ProductModelProductDescriptionCulture], N'CONSTRAINT', [DF_ProductModelProductDescriptionCulture_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [ProductPhoto], N'CONSTRAINT', [PK_ProductPhoto_ProductPhotoID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [ProductPhoto], N'CONSTRAINT', [DF_ProductPhoto_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [ProductProductPhoto], N'CONSTRAINT', [PK_ProductProductPhoto_ProductID_ProductPhotoID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', N'SCHEMA', [Production], N'TABLE', [ProductProductPhoto], N'CONSTRAINT', [FK_ProductProductPhoto_Product_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing ProductPhoto.ProductPhotoID.', N'SCHEMA', [Production], N'TABLE', [ProductProductPhoto], N'CONSTRAINT', [FK_ProductProductPhoto_ProductPhoto_ProductPhotoID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0 (FALSE)', N'SCHEMA', [Production], N'TABLE', [ProductProductPhoto], N'CONSTRAINT', [DF_ProductProductPhoto_Primary];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [ProductProductPhoto], N'CONSTRAINT', [DF_ProductProductPhoto_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [ProductReview], N'CONSTRAINT', [PK_ProductReview_ProductReviewID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', N'SCHEMA', [Production], N'TABLE', [ProductReview], N'CONSTRAINT', [FK_ProductReview_Product_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [ProductReview], N'CONSTRAINT', [DF_ProductReview_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [ProductReview], N'CONSTRAINT', [DF_ProductReview_ReviewDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [Rating] BETWEEN (1) AND (5)', N'SCHEMA', [Production], N'TABLE', [ProductReview], N'CONSTRAINT', [CK_ProductReview_Rating];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [ProductSubcategory], N'CONSTRAINT', [PK_ProductSubcategory_ProductSubcategoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing ProductCategory.ProductCategoryID.', N'SCHEMA', [Production], N'TABLE', [ProductSubcategory], N'CONSTRAINT', [FK_ProductSubcategory_ProductCategory_ProductCategoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [ProductSubcategory], N'CONSTRAINT', [DF_ProductSubcategory_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Production], N'TABLE', [ProductSubcategory], N'CONSTRAINT', [DF_ProductSubcategory_rowguid];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'CONSTRAINT', [PK_ProductVendor_ProductID_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'CONSTRAINT', [FK_ProductVendor_Product_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing UnitMeasure.UnitMeasureCode.', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'CONSTRAINT', [FK_ProductVendor_UnitMeasure_UnitMeasureCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Vendor.BusinessEntityID.', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'CONSTRAINT', [FK_ProductVendor_Vendor_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'CONSTRAINT', [DF_ProductVendor_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [AverageLeadTime] >= (1)', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'CONSTRAINT', [CK_ProductVendor_AverageLeadTime];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [LastReceiptCost] > (0.00)', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'CONSTRAINT', [CK_ProductVendor_LastReceiptCost];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [MaxOrderQty] >= (1)', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'CONSTRAINT', [CK_ProductVendor_MaxOrderQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [MinOrderQty] >= (1)', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'CONSTRAINT', [CK_ProductVendor_MinOrderQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [OnOrderQty] >= (0)', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'CONSTRAINT', [CK_ProductVendor_OnOrderQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [StandardPrice] > (0.00)', N'SCHEMA', [Purchasing], N'TABLE', [ProductVendor], N'CONSTRAINT', [CK_ProductVendor_StandardPrice];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'CONSTRAINT', [PK_PurchaseOrderDetail_PurchaseOrderID_PurchaseOrderDetailID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'CONSTRAINT', [FK_PurchaseOrderDetail_Product_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing PurchaseOrderHeader.PurchaseOrderID.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'CONSTRAINT', [FK_PurchaseOrderDetail_PurchaseOrderHeader_PurchaseOrderID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'CONSTRAINT', [DF_PurchaseOrderDetail_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [OrderQty] > (0)', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'CONSTRAINT', [CK_PurchaseOrderDetail_OrderQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [ReceivedQty] >= (0.00)', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'CONSTRAINT', [CK_PurchaseOrderDetail_ReceivedQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [RejectedQty] >= (0.00)', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'CONSTRAINT', [CK_PurchaseOrderDetail_RejectedQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [UnitPrice] >= (0.00)', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderDetail], N'CONSTRAINT', [CK_PurchaseOrderDetail_UnitPrice];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'CONSTRAINT', [PK_PurchaseOrderHeader_PurchaseOrderID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Employee.EmployeeID.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'CONSTRAINT', [FK_PurchaseOrderHeader_Employee_EmployeeID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing ShipMethod.ShipMethodID.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'CONSTRAINT', [FK_PurchaseOrderHeader_ShipMethod_ShipMethodID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Vendor.VendorID.', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'CONSTRAINT', [FK_PurchaseOrderHeader_Vendor_VendorID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'CONSTRAINT', [DF_PurchaseOrderHeader_RevisionNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'CONSTRAINT', [DF_PurchaseOrderHeader_Freight];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'CONSTRAINT', [DF_PurchaseOrderHeader_SubTotal];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'CONSTRAINT', [DF_PurchaseOrderHeader_TaxAmt];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 1', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'CONSTRAINT', [DF_PurchaseOrderHeader_Status];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'CONSTRAINT', [DF_PurchaseOrderHeader_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'CONSTRAINT', [DF_PurchaseOrderHeader_OrderDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [Freight] >= (0.00)', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'CONSTRAINT', [CK_PurchaseOrderHeader_Freight];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [SubTotal] >= (0.00)', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'CONSTRAINT', [CK_PurchaseOrderHeader_SubTotal];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [TaxAmt] >= (0.00)', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'CONSTRAINT', [CK_PurchaseOrderHeader_TaxAmt];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [ShipDate] >= [OrderDate] OR [ShipDate] IS NULL', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'CONSTRAINT', [CK_PurchaseOrderHeader_ShipDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [Status] BETWEEN (1) AND (4)', N'SCHEMA', [Purchasing], N'TABLE', [PurchaseOrderHeader], N'CONSTRAINT', [CK_PurchaseOrderHeader_Status];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'CONSTRAINT', [PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing SalesOrderHeader.PurchaseOrderID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'CONSTRAINT', [FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing SpecialOfferProduct.SpecialOfferIDProductID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'CONSTRAINT', [FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'CONSTRAINT', [DF_SalesOrderDetail_UnitPriceDiscount];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'CONSTRAINT', [DF_SalesOrderDetail_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'CONSTRAINT', [DF_SalesOrderDetail_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [OrderQty] > (0)', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'CONSTRAINT', [CK_SalesOrderDetail_OrderQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [UnitPrice] >= (0.00)', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'CONSTRAINT', [CK_SalesOrderDetail_UnitPrice];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [UnitPriceDiscount] >= (0.00)', N'SCHEMA', [Sales], N'TABLE', [SalesOrderDetail], N'CONSTRAINT', [CK_SalesOrderDetail_UnitPriceDiscount];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [PK_SalesOrderHeader_SalesOrderID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Address.AddressID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [FK_SalesOrderHeader_Address_BillToAddressID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Address.AddressID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [FK_SalesOrderHeader_Address_ShipToAddressID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing CreditCard.CreditCardID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [FK_SalesOrderHeader_CreditCard_CreditCardID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing CurrencyRate.CurrencyRateID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [FK_SalesOrderHeader_CurrencyRate_CurrencyRateID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Customer.CustomerID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [FK_SalesOrderHeader_Customer_CustomerID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing SalesPerson.SalesPersonID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [FK_SalesOrderHeader_SalesPerson_SalesPersonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing SalesTerritory.TerritoryID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [FK_SalesOrderHeader_SalesTerritory_TerritoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing ShipMethod.ShipMethodID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [FK_SalesOrderHeader_ShipMethod_ShipMethodID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [DF_SalesOrderHeader_RevisionNumber];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [DF_SalesOrderHeader_Freight];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [DF_SalesOrderHeader_SubTotal];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [DF_SalesOrderHeader_TaxAmt];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 1 (TRUE)', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [DF_SalesOrderHeader_OnlineOrderFlag];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 1', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [DF_SalesOrderHeader_Status];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [DF_SalesOrderHeader_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [DF_SalesOrderHeader_OrderDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [DF_SalesOrderHeader_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [Freight] >= (0.00)', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [CK_SalesOrderHeader_Freight];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [SubTotal] >= (0.00)', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [CK_SalesOrderHeader_SubTotal];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [TaxAmt] >= (0.00)', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [CK_SalesOrderHeader_TaxAmt];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [DueDate] >= [OrderDate]', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [CK_SalesOrderHeader_DueDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [ShipDate] >= [OrderDate] OR [ShipDate] IS NULL', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [CK_SalesOrderHeader_ShipDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [Status] BETWEEN (0) AND (8)', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeader], N'CONSTRAINT', [CK_SalesOrderHeader_Status];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeaderSalesReason], N'CONSTRAINT', [PK_SalesOrderHeaderSalesReason_SalesOrderID_SalesReasonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing SalesOrderHeader.SalesOrderID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeaderSalesReason], N'CONSTRAINT', [FK_SalesOrderHeaderSalesReason_SalesOrderHeader_SalesOrderID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing SalesReason.SalesReasonID.', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeaderSalesReason], N'CONSTRAINT', [FK_SalesOrderHeaderSalesReason_SalesReason_SalesReasonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [SalesOrderHeaderSalesReason], N'CONSTRAINT', [DF_SalesOrderHeaderSalesReason_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'CONSTRAINT', [PK_SalesPerson_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Employee.EmployeeID.', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'CONSTRAINT', [FK_SalesPerson_Employee_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing SalesTerritory.TerritoryID.', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'CONSTRAINT', [FK_SalesPerson_SalesTerritory_TerritoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'CONSTRAINT', [DF_SalesPerson_Bonus];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'CONSTRAINT', [DF_SalesPerson_CommissionPct];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'CONSTRAINT', [DF_SalesPerson_SalesLastYear];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'CONSTRAINT', [DF_SalesPerson_SalesYTD];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'CONSTRAINT', [DF_SalesPerson_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'CONSTRAINT', [DF_SalesPerson_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [Bonus] >= (0.00)', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'CONSTRAINT', [CK_SalesPerson_Bonus];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [CommissionPct] >= (0.00)', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'CONSTRAINT', [CK_SalesPerson_CommissionPct];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [SalesLastYear] >= (0.00)', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'CONSTRAINT', [CK_SalesPerson_SalesLastYear];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [SalesQuota] > (0.00)', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'CONSTRAINT', [CK_SalesPerson_SalesQuota];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [SalesYTD] >= (0.00)', N'SCHEMA', [Sales], N'TABLE', [SalesPerson], N'CONSTRAINT', [CK_SalesPerson_SalesYTD];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [SalesPersonQuotaHistory], N'CONSTRAINT', [PK_SalesPersonQuotaHistory_BusinessEntityID_QuotaDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing SalesPerson.SalesPersonID.', N'SCHEMA', [Sales], N'TABLE', [SalesPersonQuotaHistory], N'CONSTRAINT', [FK_SalesPersonQuotaHistory_SalesPerson_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [SalesPersonQuotaHistory], N'CONSTRAINT', [DF_SalesPersonQuotaHistory_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Sales], N'TABLE', [SalesPersonQuotaHistory], N'CONSTRAINT', [DF_SalesPersonQuotaHistory_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [SalesQuota] > (0.00)', N'SCHEMA', [Sales], N'TABLE', [SalesPersonQuotaHistory], N'CONSTRAINT', [CK_SalesPersonQuotaHistory_SalesQuota];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [SalesReason], N'CONSTRAINT', [PK_SalesReason_SalesReasonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [SalesReason], N'CONSTRAINT', [DF_SalesReason_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [SalesTaxRate], N'CONSTRAINT', [PK_SalesTaxRate_SalesTaxRateID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing StateProvince.StateProvinceID.', N'SCHEMA', [Sales], N'TABLE', [SalesTaxRate], N'CONSTRAINT', [FK_SalesTaxRate_StateProvince_StateProvinceID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Sales], N'TABLE', [SalesTaxRate], N'CONSTRAINT', [DF_SalesTaxRate_TaxRate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [SalesTaxRate], N'CONSTRAINT', [DF_SalesTaxRate_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Sales], N'TABLE', [SalesTaxRate], N'CONSTRAINT', [DF_SalesTaxRate_rowguid]; 
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [TaxType] BETWEEN (1) AND (3)', N'SCHEMA', [Sales], N'TABLE', [SalesTaxRate], N'CONSTRAINT', [CK_SalesTaxRate_TaxType];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'CONSTRAINT', [PK_SalesTerritory_TerritoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'CONSTRAINT', [DF_SalesTerritory_CostLastYear];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'CONSTRAINT', [DF_SalesTerritory_CostYTD];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'CONSTRAINT', [DF_SalesTerritory_SalesLastYear];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'CONSTRAINT', [DF_SalesTerritory_SalesYTD];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'CONSTRAINT', [DF_SalesTerritory_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'CONSTRAINT', [DF_SalesTerritory_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [CostLastYear] >= (0.00)', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'CONSTRAINT', [CK_SalesTerritory_CostLastYear];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [CostYTD] >= (0.00)', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'CONSTRAINT', [CK_SalesTerritory_CostYTD];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [SalesLastYear] >= (0.00)', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'CONSTRAINT', [CK_SalesTerritory_SalesLastYear];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [SalesYTD] >= (0.00)', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'CONSTRAINT', [CK_SalesTerritory_SalesYTD];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing CountryRegion.CountryRegionCode.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritory], N'CONSTRAINT', [FK_SalesTerritory_CountryRegion_CountryRegionCode];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [SalesTerritoryHistory], N'CONSTRAINT', [PK_SalesTerritoryHistory_BusinessEntityID_StartDate_TerritoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing SalesPerson.SalesPersonID.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritoryHistory], N'CONSTRAINT', [FK_SalesTerritoryHistory_SalesPerson_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing SalesTerritory.TerritoryID.', N'SCHEMA', [Sales], N'TABLE', [SalesTerritoryHistory], N'CONSTRAINT', [FK_SalesTerritoryHistory_SalesTerritory_TerritoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [SalesTerritoryHistory], N'CONSTRAINT', [DF_SalesTerritoryHistory_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Sales], N'TABLE', [SalesTerritoryHistory], N'CONSTRAINT', [DF_SalesTerritoryHistory_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [EndDate] >= [StartDate] OR [EndDate] IS NULL', N'SCHEMA', [Sales], N'TABLE', [SalesTerritoryHistory], N'CONSTRAINT', [CK_SalesTerritoryHistory_EndDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [ScrapReason], N'CONSTRAINT', [PK_ScrapReason_ScrapReasonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [ScrapReason], N'CONSTRAINT', [DF_ScrapReason_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [HumanResources], N'TABLE', [Shift], N'CONSTRAINT', [PK_Shift_ShiftID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [HumanResources], N'TABLE', [Shift], N'CONSTRAINT', [DF_Shift_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Purchasing], N'TABLE', [ShipMethod], N'CONSTRAINT', [PK_ShipMethod_ShipMethodID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Purchasing], N'TABLE', [ShipMethod], N'CONSTRAINT', [DF_ShipMethod_ShipBase];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Purchasing], N'TABLE', [ShipMethod], N'CONSTRAINT', [DF_ShipMethod_ShipRate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Purchasing], N'TABLE', [ShipMethod], N'CONSTRAINT', [DF_ShipMethod_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Purchasing], N'TABLE', [ShipMethod], N'CONSTRAINT', [DF_ShipMethod_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [ShipBase] > (0.00)', N'SCHEMA', [Purchasing], N'TABLE', [ShipMethod], N'CONSTRAINT', [CK_ShipMethod_ShipBase];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [ShipRate] > (0.00)', N'SCHEMA', [Purchasing], N'TABLE', [ShipMethod], N'CONSTRAINT', [CK_ShipMethod_ShipRate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [ShoppingCartItem], N'CONSTRAINT', [PK_ShoppingCartItem_ShoppingCartItemID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', N'SCHEMA', [Sales], N'TABLE', [ShoppingCartItem], N'CONSTRAINT', [FK_ShoppingCartItem_Product_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 1', N'SCHEMA', [Sales], N'TABLE', [ShoppingCartItem], N'CONSTRAINT', [DF_ShoppingCartItem_Quantity];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [ShoppingCartItem], N'CONSTRAINT', [DF_ShoppingCartItem_DateCreated];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [ShoppingCartItem], N'CONSTRAINT', [DF_ShoppingCartItem_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [Quantity] >= (1)', N'SCHEMA', [Sales], N'TABLE', [ShoppingCartItem], N'CONSTRAINT', [CK_ShoppingCartItem_Quantity];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'CONSTRAINT', [PK_SpecialOffer_SpecialOfferID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'CONSTRAINT', [DF_SpecialOffer_DiscountPct];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0.0', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'CONSTRAINT', [DF_SpecialOffer_MinQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'CONSTRAINT', [DF_SpecialOffer_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'CONSTRAINT', [DF_SpecialOffer_rowguid];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [DiscountPct] >= (0.00)', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'CONSTRAINT', [CK_SpecialOffer_DiscountPct];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [MaxQty] >= (0)', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'CONSTRAINT', [CK_SpecialOffer_MaxQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [MinQty] >= (0)', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'CONSTRAINT', [CK_SpecialOffer_MinQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [EndDate] >= [StartDate]', N'SCHEMA', [Sales], N'TABLE', [SpecialOffer], N'CONSTRAINT', [CK_SpecialOffer_EndDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [SpecialOfferProduct], N'CONSTRAINT', [PK_SpecialOfferProduct_SpecialOfferID_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', N'SCHEMA', [Sales], N'TABLE', [SpecialOfferProduct], N'CONSTRAINT', [FK_SpecialOfferProduct_Product_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing SpecialOffer.SpecialOfferID.', N'SCHEMA', [Sales], N'TABLE', [SpecialOfferProduct], N'CONSTRAINT', [FK_SpecialOfferProduct_SpecialOffer_SpecialOfferID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [SpecialOfferProduct], N'CONSTRAINT', [DF_SpecialOfferProduct_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Sales], N'TABLE', [SpecialOfferProduct], N'CONSTRAINT', [DF_SpecialOfferProduct_rowguid];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Person], N'TABLE', [StateProvince], N'CONSTRAINT', [PK_StateProvince_StateProvinceID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing CountryRegion.CountryRegionCode.', N'SCHEMA', [Person], N'TABLE', [StateProvince], N'CONSTRAINT', [FK_StateProvince_CountryRegion_CountryRegionCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing SalesTerritory.TerritoryID.', N'SCHEMA', [Person], N'TABLE', [StateProvince], N'CONSTRAINT', [FK_StateProvince_SalesTerritory_TerritoryID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 1 (TRUE)', N'SCHEMA', [Person], N'TABLE', [StateProvince], N'CONSTRAINT', [DF_StateProvince_IsOnlyStateProvinceFlag];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Person], N'TABLE', [StateProvince], N'CONSTRAINT', [DF_StateProvince_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Person], N'TABLE', [StateProvince], N'CONSTRAINT', [DF_StateProvince_rowguid];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Sales], N'TABLE', [Store], N'CONSTRAINT', [PK_Store_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing BusinessEntity.BusinessEntityID', N'SCHEMA', [Sales], N'TABLE', [Store], N'CONSTRAINT', [FK_Store_BusinessEntity_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing SalesPerson.SalesPersonID', N'SCHEMA', [Sales], N'TABLE', [Store], N'CONSTRAINT', [FK_Store_SalesPerson_SalesPersonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Sales], N'TABLE', [Store], N'CONSTRAINT', [DF_Store_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of NEWID()', N'SCHEMA', [Sales], N'TABLE', [Store], N'CONSTRAINT', [DF_Store_rowguid];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], N'CONSTRAINT', [PK_TransactionHistory_TransactionID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], N'CONSTRAINT', [FK_TransactionHistory_Product_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], N'CONSTRAINT', [DF_TransactionHistory_ReferenceOrderLineID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], N'CONSTRAINT', [DF_TransactionHistory_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], N'CONSTRAINT', [DF_TransactionHistory_TransactionDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [TransactionType]=''p'' OR [TransactionType]=''s'' OR [TransactionType]=''w'' OR [TransactionType]=''P'' OR [TransactionType]=''S'' OR [TransactionType]=''W'')', N'SCHEMA', [Production], N'TABLE', [TransactionHistory], N'CONSTRAINT', [CK_TransactionHistory_TransactionType];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [TransactionHistoryArchive], N'CONSTRAINT', [PK_TransactionHistoryArchive_TransactionID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 0', N'SCHEMA', [Production], N'TABLE', [TransactionHistoryArchive], N'CONSTRAINT', [DF_TransactionHistoryArchive_ReferenceOrderLineID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [TransactionHistoryArchive], N'CONSTRAINT', [DF_TransactionHistoryArchive_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [TransactionHistoryArchive], N'CONSTRAINT', [DF_TransactionHistoryArchive_TransactionDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [TransactionType]=''p'' OR [TransactionType]=''s'' OR [TransactionType]=''w'' OR [TransactionType]=''P'' OR [TransactionType]=''S'' OR [TransactionType]=''W''', N'SCHEMA', [Production], N'TABLE', [TransactionHistoryArchive], N'CONSTRAINT', [CK_TransactionHistoryArchive_TransactionType];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [UnitMeasure], N'CONSTRAINT', [PK_UnitMeasure_UnitMeasureCode];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [UnitMeasure], N'CONSTRAINT', [DF_UnitMeasure_ModifiedDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Purchasing], N'TABLE', [Vendor], N'CONSTRAINT', [PK_Vendor_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing BusinessEntity.BusinessEntityID', N'SCHEMA', [Purchasing], N'TABLE', [Vendor], N'CONSTRAINT', [FK_Vendor_BusinessEntity_BusinessEntityID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 1 (TRUE)', N'SCHEMA', [Purchasing], N'TABLE', [Vendor], N'CONSTRAINT', [DF_Vendor_ActiveFlag];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of 1 (TRUE)', N'SCHEMA', [Purchasing], N'TABLE', [Vendor], N'CONSTRAINT', [DF_Vendor_PreferredVendorStatus];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Purchasing], N'TABLE', [Vendor], N'CONSTRAINT', [DF_Vendor_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [CreditRating] BETWEEN (1) AND (5)', N'SCHEMA', [Purchasing], N'TABLE', [Vendor], N'CONSTRAINT', [CK_Vendor_CreditRating];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'CONSTRAINT', [PK_WorkOrder_WorkOrderID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'CONSTRAINT', [FK_WorkOrder_Product_ProductID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing ScrapReason.ScrapReasonID.', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'CONSTRAINT', [FK_WorkOrder_ScrapReason_ScrapReasonID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'CONSTRAINT', [DF_WorkOrder_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [OrderQty] > (0)', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'CONSTRAINT', [CK_WorkOrder_OrderQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [ScrappedQty] >= (0)', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'CONSTRAINT', [CK_WorkOrder_ScrappedQty];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [EndDate] >= [StartDate] OR [EndDate] IS NULL', N'SCHEMA', [Production], N'TABLE', [WorkOrder], N'CONSTRAINT', [CK_WorkOrder_EndDate];
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Primary key (clustered) constraint', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'CONSTRAINT', [PK_WorkOrderRouting_WorkOrderID_ProductID_OperationSequence];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing Location.LocationID.', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'CONSTRAINT', [FK_WorkOrderRouting_Location_LocationID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Foreign key constraint referencing WorkOrder.WorkOrderID.', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'CONSTRAINT', [FK_WorkOrderRouting_WorkOrder_WorkOrderID];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Default constraint value of GETDATE()', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'CONSTRAINT', [DF_WorkOrderRouting_ModifiedDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [ActualCost] > (0.00)', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'CONSTRAINT', [CK_WorkOrderRouting_ActualCost];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [ActualResourceHrs] >= (0.0000)', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'CONSTRAINT', [CK_WorkOrderRouting_ActualResourceHrs];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [PlannedCost] > (0.00)', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'CONSTRAINT', [CK_WorkOrderRouting_PlannedCost];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [ActualEndDate] >= [ActualStartDate] OR [ActualEndDate] IS NULL OR [ActualStartDate] IS NULL', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'CONSTRAINT', [CK_WorkOrderRouting_ActualEndDate];
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Check constraint [ScheduledEndDate] >= [ScheduledStartDate]', N'SCHEMA', [Production], N'TABLE', [WorkOrderRouting], N'CONSTRAINT', [CK_WorkOrderRouting_ScheduledEndDate];
GO

PRINT '    Functions';
GO

-- Functions
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Scalar function used in the uSalesOrderHeader trigger to set the starting account date.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetAccountingEndDate], NULL, NULL;
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Scalar function used in the uSalesOrderHeader trigger to set the ending account date.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetAccountingStartDate], NULL, NULL;
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Table value function returning the first name, last name, job title and contact type for a given contact.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetContactInformation], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the table value function ufnGetContactInformation. Enter a valid PersonID from the Person.Contact table.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetContactInformation], N'PARAMETER', '@PersonID';
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Scalar function returning the text representation of the Status column in the Document table.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetDocumentStatusText], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the scalar function ufnGetDocumentStatusText. Enter a valid integer.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetDocumentStatusText], N'PARAMETER', '@Status';
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Scalar function returning the dealer price for a given product on a particular order date.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetProductDealerPrice], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the scalar function ufnGetProductDealerPrice. Enter a valid ProductID from the Production.Product table.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetProductDealerPrice], N'PARAMETER', '@ProductID';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the scalar function ufnGetProductDealerPrice. Enter a valid order date.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetProductDealerPrice], N'PARAMETER', '@OrderDate';
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Scalar function returning the list price for a given product on a particular order date.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetProductListPrice], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the scalar function ufnGetProductListPrice. Enter a valid ProductID from the Production.Product table.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetProductListPrice], N'PARAMETER', '@ProductID';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the scalar function ufnGetProductListPrice. Enter a valid order date.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetProductListPrice], N'PARAMETER', '@OrderDate';
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Scalar function returning the standard cost for a given product on a particular order date.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetProductStandardCost], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the scalar function ufnGetProductStandardCost. Enter a valid ProductID from the Production.Product table.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetProductStandardCost], N'PARAMETER', '@ProductID';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the scalar function ufnGetProductStandardCost. Enter a valid order date.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetProductStandardCost], N'PARAMETER', '@OrderDate';
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Scalar function returning the text representation of the Status column in the PurchaseOrderHeader table.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetPurchaseOrderStatusText], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the scalar function ufnGetPurchaseOrdertStatusText. Enter a valid integer.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetPurchaseOrderStatusText], N'PARAMETER', '@Status';
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Scalar function returning the text representation of the Status column in the SalesOrderHeader table.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetSalesOrderStatusText], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the scalar function ufnGetSalesOrderStatusText. Enter a valid integer.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetSalesOrderStatusText], N'PARAMETER', '@Status';
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Scalar function returning the quantity of inventory in LocationID 6 (Miscellaneous Storage)for a specified ProductID.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetStock], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the scalar function ufnGetStock. Enter a valid ProductID from the Production.ProductInventory table.', N'SCHEMA', [dbo], N'FUNCTION', [ufnGetStock], N'PARAMETER', '@ProductID';
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Scalar function used by the Sales.Customer table to help set the account number.', N'SCHEMA', [dbo], N'FUNCTION', [ufnLeadingZeros], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the scalar function ufnLeadingZeros. Enter a valid integer.', N'SCHEMA', [dbo], N'FUNCTION', [ufnLeadingZeros], N'PARAMETER', '@Value';
GO

PRINT '    Stored Procedures';
GO

-- Stored Procedures
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Stored procedure using a recursive query to return a multi-level bill of material for the specified ProductID.', N'SCHEMA', [dbo], N'PROCEDURE', [uspGetBillOfMaterials], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspGetBillOfMaterials. Enter a valid ProductID from the Production.Product table.', N'SCHEMA', [dbo], N'PROCEDURE', [uspGetBillOfMaterials], N'PARAMETER', '@StartProductID';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspGetBillOfMaterials used to eliminate components not used after that date. Enter a valid date.', N'SCHEMA', [dbo], N'PROCEDURE', [uspGetBillOfMaterials], N'PARAMETER', '@CheckDate';
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Stored procedure using a recursive query to return the direct and indirect managers of the specified employee.', N'SCHEMA', [dbo], N'PROCEDURE', [uspGetEmployeeManagers], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspGetEmployeeManagers. Enter a valid BusinessEntityID from the HumanResources.Employee table.', N'SCHEMA', [dbo], N'PROCEDURE', [uspGetEmployeeManagers], N'PARAMETER', '@BusinessEntityID';
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Stored procedure using a recursive query to return the direct and indirect employees of the specified manager.', N'SCHEMA', [dbo], N'PROCEDURE', [uspGetManagerEmployees], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspGetManagerEmployees. Enter a valid BusinessEntityID of the manager from the HumanResources.Employee table.', N'SCHEMA', [dbo], N'PROCEDURE', [uspGetManagerEmployees], N'PARAMETER', '@BusinessEntityID';
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Stored procedure using a recursive query to return all components or assemblies that directly or indirectly use the specified ProductID.', N'SCHEMA', [dbo], N'PROCEDURE', [uspGetWhereUsedProductID], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspGetWhereUsedProductID. Enter a valid ProductID from the Production.Product table.', N'SCHEMA', [dbo], N'PROCEDURE', [uspGetWhereUsedProductID], N'PARAMETER', '@StartProductID';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspGetWhereUsedProductID used to eliminate components not used after that date. Enter a valid date.', N'SCHEMA', [dbo], N'PROCEDURE', [uspGetWhereUsedProductID], N'PARAMETER', '@CheckDate';
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Logs error information in the ErrorLog table about the error that caused execution to jump to the CATCH block of a TRY...CATCH construct. Should be executed from within the scope of a CATCH block otherwise it will return without inserting error information.', N'SCHEMA', [dbo], N'PROCEDURE', [uspLogError], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Output parameter for the stored procedure uspLogError. Contains the ErrorLogID value corresponding to the row inserted by uspLogError in the ErrorLog table.', N'SCHEMA', [dbo], N'PROCEDURE', [uspLogError], N'PARAMETER', '@ErrorLogID';
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Prints error information about the error that caused execution to jump to the CATCH block of a TRY...CATCH construct. Should be executed from within the scope of a CATCH block otherwise it will return without printing any error information.', N'SCHEMA', [dbo], N'PROCEDURE', [uspPrintError], NULL, NULL;
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Updates the Employee table and inserts a new row in the EmployeePayHistory table with the values specified in the input parameters.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeeHireInfo], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a valid BusinessEntityID from the Employee table.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeeHireInfo], N'PARAMETER', '@BusinessEntityID';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a title for the employee.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeeHireInfo], N'PARAMETER', '@JobTitle';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a hire date for the employee.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeeHireInfo], N'PARAMETER', '@HireDate';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter the date the rate changed for the employee.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeeHireInfo], N'PARAMETER', '@RateChangeDate';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter the new rate for the employee.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeeHireInfo], N'PARAMETER', '@Rate';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter the pay frequency for the employee.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeeHireInfo], N'PARAMETER', '@PayFrequency';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter the current flag for the employee.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeeHireInfo], N'PARAMETER', '@CurrentFlag';
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Updates the Employee table with the values specified in the input parameters for the given BusinessEntityID.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeeLogin], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeLogin. Enter a valid EmployeeID from the Employee table.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeeLogin], N'PARAMETER', '@BusinessEntityID';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a valid ManagerID for the employee.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeeLogin], N'PARAMETER', '@OrganizationNode';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a valid login for the employee.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeeLogin], N'PARAMETER', '@LoginID';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a title for the employee.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeeLogin], N'PARAMETER', '@JobTitle';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a hire date for the employee.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeeLogin], N'PARAMETER', '@HireDate';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter the current flag for the employee.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeeLogin], N'PARAMETER', '@CurrentFlag';
GO

EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Updates the Employee table with the values specified in the input parameters for the given EmployeeID.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeePersonalInfo], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeePersonalInfo. Enter a valid BusinessEntityID from the HumanResources.Employee table.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeePersonalInfo], N'PARAMETER', '@BusinessEntityID';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a national ID for the employee.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeePersonalInfo], N'PARAMETER', '@NationalIDNumber';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a birth date for the employee.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeePersonalInfo], N'PARAMETER', '@BirthDate';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a marital status for the employee.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeePersonalInfo], N'PARAMETER', '@MaritalStatus';
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a gender for the employee.', N'SCHEMA', [HumanResources], N'PROCEDURE', [uspUpdateEmployeePersonalInfo], N'PARAMETER', '@Gender';
GO

PRINT '    XML Schemas';
GO

-- XML Schemas
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Collection of XML schemas for the AdditionalContactInfo column in the Person.Contact table.', N'SCHEMA', [Person], N'XML SCHEMA COLLECTION', [AdditionalContactInfoSchemaCollection], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Collection of XML schemas for the Resume column in the HumanResources.JobCandidate table.', N'SCHEMA', [HumanResources], N'XML SCHEMA COLLECTION', [HRResumeSchemaCollection], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Collection of XML schemas for the Demographics column in the Person.Person table.', N'SCHEMA', [Person], N'XML SCHEMA COLLECTION', [IndividualSurveySchemaCollection], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Collection of XML schemas for the Instructions column in the Production.ProductModel table.', N'SCHEMA', [Production], N'XML SCHEMA COLLECTION', [ManuInstructionsSchemaCollection], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Collection of XML schemas for the CatalogDescription column in the Production.ProductModel table.', N'SCHEMA', [Production], N'XML SCHEMA COLLECTION', [ProductDescriptionSchemaCollection], NULL, NULL;
EXECUTE [sys].[sp_addextendedproperty] N'MS_Description', N'Collection of XML schemas for the Demographics column in the Sales.Store table.', N'SCHEMA', [Sales], N'XML SCHEMA COLLECTION', [StoreSurveySchemaCollection], NULL, NULL;
GO

SET NOCOUNT OFF;
GO


-- ****************************************
-- Drop DDL Trigger for Database
-- ****************************************
PRINT '';
PRINT '*** Disabling DDL Trigger for Database';
GO

DISABLE TRIGGER [ddlDatabaseTriggerLog] 
ON DATABASE;
GO

/*
-- Output database object creation messages
SELECT [PostTime], [DatabaseUser], [Event], [Schema], [Object], [TSQL], [XmlEvent]
FROM [dbo].[DatabaseLog];
*/
GO


USE [master];
GO

PRINT 'Finished - ' + CONVERT(varchar, GETDATE(), 121);
GO


SET NOEXEC OFF