
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

PRINT N'Dropping [accounting].[Trial_Balance]'
GO
DROP VIEW accounting.Trial_Balance
GO
PRINT N'Dropping [accounting].[Spent_Money_Trans]'
GO
DROP VIEW accounting.Spent_Money_Trans
GO
PRINT N'Dropping [accounting].[Received_Money_Trans]'
GO
DROP VIEW accounting.Received_Money_Trans
GO
PRINT N'Dropping [accounting].[Bill_Trans]'
GO
DROP VIEW accounting.Bill_Trans
GO
PRINT N'Dropping [accounting].[Invoice_Trans]'
GO
DROP VIEW accounting.Invoice_Trans
GO
PRINT N'Dropping accounting.Bill_Lines';
GO
DROP table accounting.Bill_Lines;
GO
PRINT N'Dropping accounting.Spent_Money_Lines';
GO
DROP table accounting.Spent_Money_Lines;
GO
PRINT N'Dropping accounting.Invoice_Lines';
GO
DROP table accounting.Invoice_Lines;
GO
PRINT N'Dropping accounting.Received_Money_Lines';
GO
DROP table accounting.Received_Money_Lines;
GO
PRINT N'Dropping accounting.Bills';
GO
DROP table accounting.Bills;
GO
PRINT N'Dropping accounting.Invoices';
GO
DROP table accounting.Invoices;
GO
PRINT N'Dropping accounting.Received_Moneys';
GO
DROP table accounting.Received_Moneys;
GO
PRINT N'Dropping accounting.Spent_Moneys';
GO
DROP table accounting.Spent_Moneys;
GO
PRINT N'Dropping accounting.Bill_Payments';
GO
DROP table accounting.Bill_Payments;
GO
PRINT N'Dropping accounting.customer';
GO
DROP table accounting.customer;
GO
PRINT N'Dropping accounting.Invoice_Payments';
GO
DROP table accounting.Invoice_Payments;
GO
PRINT N'Dropping accounting.Suppliers';
GO
DROP table accounting.Suppliers;
GO
PRINT N'Dropping accounting.Chart_of_Accounts';
GO
DROP table accounting.Chart_of_Accounts;
GO