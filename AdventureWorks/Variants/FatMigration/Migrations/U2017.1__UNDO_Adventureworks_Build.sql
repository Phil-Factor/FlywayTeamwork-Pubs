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
