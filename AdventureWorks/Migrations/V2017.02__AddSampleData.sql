
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

