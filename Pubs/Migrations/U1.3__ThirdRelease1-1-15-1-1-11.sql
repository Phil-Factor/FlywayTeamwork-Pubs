SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Dropping foreign keys from [accounting].[Bill_Lines]'
GO
ALTER TABLE [accounting].[Bill_Lines] DROP CONSTRAINT [FK__Bill_Line__bill___69FBBC1F]
GO
ALTER TABLE [accounting].[Bill_Lines] DROP CONSTRAINT [FK__Bill_Line__line___6AEFE058]
GO
PRINT N'Dropping foreign keys from [accounting].[Bills]'
GO
ALTER TABLE [accounting].[Bills] DROP CONSTRAINT [FK__Bills__bill_paym__6EC0713C]
GO
ALTER TABLE [accounting].[Bills] DROP CONSTRAINT [FK__Bills__supplier___6DCC4D03]
GO
ALTER TABLE [accounting].[Bills] DROP CONSTRAINT [FK__Bills__Chart_of___6CD828CA]
GO
PRINT N'Dropping foreign keys from [accounting].[Bill_Payments]'
GO
ALTER TABLE [accounting].[Bill_Payments] DROP CONSTRAINT [FK__Bill_Paym__Chart__6BE40491]
GO
PRINT N'Dropping foreign keys from [accounting].[Invoice_Lines]'
GO
ALTER TABLE [accounting].[Invoice_Lines] DROP CONSTRAINT [FK__Invoice_L__line___719CDDE7]
GO
ALTER TABLE [accounting].[Invoice_Lines] DROP CONSTRAINT [FK__Invoice_L__invoi__72910220]
GO
PRINT N'Dropping foreign keys from [accounting].[Invoice_Payments]'
GO
ALTER TABLE [accounting].[Invoice_Payments] DROP CONSTRAINT [FK__Invoice_P__Chart__73852659]
GO
PRINT N'Dropping foreign keys from [accounting].[Invoices]'
GO
ALTER TABLE [accounting].[Invoices] DROP CONSTRAINT [FK__Invoices__Chart___76619304]
GO
ALTER TABLE [accounting].[Invoices] DROP CONSTRAINT [FK__Invoices__invoic__756D6ECB]
GO
ALTER TABLE [accounting].[Invoices] DROP CONSTRAINT [FK__Invoices__custom__74794A92]
GO
PRINT N'Dropping foreign keys from [accounting].[Received_Money_Lines]'
GO
ALTER TABLE [accounting].[Received_Money_Lines] DROP CONSTRAINT [FK__Received___line___7849DB76]
GO
ALTER TABLE [accounting].[Received_Money_Lines] DROP CONSTRAINT [FK__Received___recei__7755B73D]
GO
PRINT N'Dropping foreign keys from [accounting].[Received_Moneys]'
GO
ALTER TABLE [accounting].[Received_Moneys] DROP CONSTRAINT [FK__Received___Chart__7A3223E8]
GO
ALTER TABLE [accounting].[Received_Moneys] DROP CONSTRAINT [FK__Received___custo__793DFFAF]
GO
PRINT N'Dropping foreign keys from [accounting].[Spent_Money_Lines]'
GO
ALTER TABLE [accounting].[Spent_Money_Lines] DROP CONSTRAINT [FK__Spent_Mon__line___7C1A6C5A]
GO
ALTER TABLE [accounting].[Spent_Money_Lines] DROP CONSTRAINT [FK__Spent_Mon__spent__7B264821]
GO
PRINT N'Dropping foreign keys from [accounting].[Spent_Moneys]'
GO
ALTER TABLE [accounting].[Spent_Moneys] DROP CONSTRAINT [FK__Spent_Mon__Chart__7D0E9093]
GO
ALTER TABLE [accounting].[Spent_Moneys] DROP CONSTRAINT [FK__Spent_Mon__suppl__7E02B4CC]
GO
PRINT N'Dropping foreign keys from [accounting].[Suppliers]'
GO
ALTER TABLE [accounting].[Suppliers] DROP CONSTRAINT [FK_supplier_id_organisation_id]
GO
ALTER TABLE [accounting].[Suppliers] DROP CONSTRAINT [FK_contact_id_organisation_id]
GO
PRINT N'Dropping foreign keys from [accounting].[customer]'
GO
ALTER TABLE [accounting].[customer] DROP CONSTRAINT [FK_person_id_Person_id]
GO
ALTER TABLE [accounting].[customer] DROP CONSTRAINT [FK_organisation_id_organisation_id]
GO
PRINT N'Dropping foreign keys from [people].[WordOccurence]'
GO
ALTER TABLE [people].[WordOccurence] DROP CONSTRAINT [FKWordOccurenceWord]
GO
PRINT N'Dropping constraints from [accounting].[Bill_Lines]'
GO
ALTER TABLE [accounting].[Bill_Lines] DROP CONSTRAINT [PK__Bill_Lin__3213E83F820F5DC6]
GO
PRINT N'Dropping constraints from [accounting].[Bill_Payments]'
GO
ALTER TABLE [accounting].[Bill_Payments] DROP CONSTRAINT [PK__Bill_Pay__3213E83FA17B97E4]
GO
PRINT N'Dropping constraints from [accounting].[Bills]'
GO
ALTER TABLE [accounting].[Bills] DROP CONSTRAINT [PK__Bills__3213E83F2342097E]
GO
PRINT N'Dropping constraints from [accounting].[Chart_of_Accounts]'
GO
ALTER TABLE [accounting].[Chart_of_Accounts] DROP CONSTRAINT [PK__Chart_of__3213E83F54F30B5F]
GO
PRINT N'Dropping constraints from [accounting].[Chart_of_Accounts]'
GO
ALTER TABLE [accounting].[Chart_of_Accounts] DROP CONSTRAINT [UQ__Chart_of__737584F6EDBB954A]
GO
PRINT N'Dropping constraints from [accounting].[Invoice_Lines]'
GO
ALTER TABLE [accounting].[Invoice_Lines] DROP CONSTRAINT [PK__Invoice___3213E83FE4EEF7B5]
GO
PRINT N'Dropping constraints from [accounting].[Invoice_Payments]'
GO
ALTER TABLE [accounting].[Invoice_Payments] DROP CONSTRAINT [PK__Invoice___3213E83FB64743CD]
GO
PRINT N'Dropping constraints from [accounting].[Invoices]'
GO
ALTER TABLE [accounting].[Invoices] DROP CONSTRAINT [PK__Invoices__3213E83F529A0A8A]
GO
PRINT N'Dropping constraints from [accounting].[Received_Money_Lines]'
GO
ALTER TABLE [accounting].[Received_Money_Lines] DROP CONSTRAINT [PK__Received__3213E83F7ACB8598]
GO
PRINT N'Dropping constraints from [accounting].[Received_Moneys]'
GO
ALTER TABLE [accounting].[Received_Moneys] DROP CONSTRAINT [PK__Received__3213E83F28ABC04A]
GO
PRINT N'Dropping constraints from [accounting].[Spent_Money_Lines]'
GO
ALTER TABLE [accounting].[Spent_Money_Lines] DROP CONSTRAINT [PK__Spent_Mo__3213E83F14257720]
GO
PRINT N'Dropping constraints from [accounting].[Spent_Moneys]'
GO
ALTER TABLE [accounting].[Spent_Moneys] DROP CONSTRAINT [PK__Spent_Mo__3213E83FFDC874C3]
GO
PRINT N'Dropping constraints from [accounting].[Suppliers]'
GO
ALTER TABLE [accounting].[Suppliers] DROP CONSTRAINT [PK__Supplier__3213E83FBC677E0E]
GO
PRINT N'Dropping constraints from [accounting].[customer]'
GO
ALTER TABLE [accounting].[customer] DROP CONSTRAINT [PK__customer__3213E83F9E91205E]
GO
PRINT N'Dropping constraints from [people].[WordOccurence]'
GO
ALTER TABLE [people].[WordOccurence] DROP CONSTRAINT [PKWordOcurrence]
GO
PRINT N'Dropping constraints from [people].[Word]'
GO
ALTER TABLE [people].[Word] DROP CONSTRAINT [PKWord]
GO
PRINT N'Dropping constraints from [accounting].[Invoice_Payments]'
GO
ALTER TABLE [accounting].[Invoice_Payments] DROP CONSTRAINT [DF__Invoice_P__Modif__671F4F74]
GO
PRINT N'Dropping constraints from [accounting].[Suppliers]'
GO
ALTER TABLE [accounting].[Suppliers] DROP CONSTRAINT [DF__Suppliers__Modif__681373AD]
GO
PRINT N'Dropping constraints from [accounting].[customer]'
GO
ALTER TABLE [accounting].[customer] DROP CONSTRAINT [DF__customer__Modifi__662B2B3B]
GO
PRINT N'Dropping constraints from [people].[Word]'
GO
ALTER TABLE [people].[Word] DROP CONSTRAINT [DF__Word__frequency__690797E6]
GO
PRINT N'Dropping [dbo].[SearchNotes]'
GO
DROP FUNCTION [dbo].[SearchNotes]
GO
PRINT N'Dropping [dbo].[FindWords]'
GO
DROP FUNCTION [dbo].[FindWords]
GO
PRINT N'Dropping [dbo].[FindString]'
GO
DROP FUNCTION [dbo].[FindString]
GO
PRINT N'Dropping [dbo].[IterativeWordChop]'
GO
DROP FUNCTION [dbo].[IterativeWordChop]
GO
PRINT N'Dropping [accounting].[Trial_Balance]'
GO
DROP VIEW [accounting].[Trial_Balance]
GO
PRINT N'Dropping [accounting].[Spent_Money_Trans]'
GO
DROP VIEW [accounting].[Spent_Money_Trans]
GO
PRINT N'Dropping [accounting].[Received_Money_Trans]'
GO
DROP VIEW [accounting].[Received_Money_Trans]
GO
PRINT N'Dropping [accounting].[Invoice_Trans]'
GO
DROP VIEW [accounting].[Invoice_Trans]
GO
PRINT N'Dropping [accounting].[Bill_Trans]'
GO
DROP VIEW [accounting].[Bill_Trans]
GO
PRINT N'Dropping [people].[WordOccurence]'
GO
DROP TABLE [people].[WordOccurence]
GO
PRINT N'Dropping [people].[Word]'
GO
DROP TABLE [people].[Word]
GO
PRINT N'Dropping [accounting].[Spent_Money_Lines]'
GO
DROP TABLE [accounting].[Spent_Money_Lines]
GO
PRINT N'Dropping [accounting].[Spent_Moneys]'
GO
DROP TABLE [accounting].[Spent_Moneys]
GO
PRINT N'Dropping [accounting].[Received_Money_Lines]'
GO
DROP TABLE [accounting].[Received_Money_Lines]
GO
PRINT N'Dropping [accounting].[Received_Moneys]'
GO
DROP TABLE [accounting].[Received_Moneys]
GO
PRINT N'Dropping [accounting].[customer]'
GO
DROP TABLE [accounting].[customer]
GO
PRINT N'Dropping [accounting].[Invoice_Payments]'
GO
DROP TABLE [accounting].[Invoice_Payments]
GO
PRINT N'Dropping [accounting].[Invoice_Lines]'
GO
DROP TABLE [accounting].[Invoice_Lines]
GO
PRINT N'Dropping [accounting].[Invoices]'
GO
DROP TABLE [accounting].[Invoices]
GO
PRINT N'Dropping [accounting].[Suppliers]'
GO
DROP TABLE [accounting].[Suppliers]
GO
PRINT N'Dropping [accounting].[Bill_Payments]'
GO
DROP TABLE [accounting].[Bill_Payments]
GO
PRINT N'Dropping [accounting].[Chart_of_Accounts]'
GO
DROP TABLE [accounting].[Chart_of_Accounts]
GO
PRINT N'Dropping [accounting].[Bill_Lines]'
GO
DROP TABLE [accounting].[Bill_Lines]
GO
PRINT N'Dropping [accounting].[Bills]'
GO
DROP TABLE [accounting].[Bills]
GO
PRINT N'Altering extended properties'
GO
EXEC sp_updateextendedproperty N'Database_Info', N'[{"Name":"PubsMain","Version":"1.2","Description":"A sample team-based Flyway project","Project":"Pubs","Modified":"2025-01-08T16:41:34.997","by":"PhilFactor"}]', NULL, NULL, NULL, NULL, NULL, NULL
GO

