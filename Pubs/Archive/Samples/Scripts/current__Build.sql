/*
Run this script on:

        empty    -  This database will be modified

to synchronize it with:

        PentlowMillServ.PubsMain

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.5.1.18536 from Red Gate Software Ltd at 24/07/2023 15:14:01

*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
GO
GO
PRINT N'Creating schemas'
GO
CREATE SCHEMA [accounting]
AUTHORIZATION [dbo]
GO
CREATE SCHEMA [classic]
AUTHORIZATION [dbo]
GO
CREATE SCHEMA [people]
AUTHORIZATION [dbo]
GO
PRINT N'Creating types'
GO
CREATE TYPE [people].[PersonalTitle] FROM nvarchar (10) NOT NULL
GO
CREATE TYPE [people].[PersonalSuffix] FROM nvarchar (10) NULL
GO
CREATE TYPE [people].[PersonalPostalCode] FROM varchar (15) NOT NULL
GO
CREATE TYPE [people].[PersonalPhoneNumber] FROM varchar (20) NOT NULL
GO
CREATE TYPE [people].[PersonalPaymentCardNumber] FROM varchar (20) NOT NULL
GO
CREATE TYPE [people].[PersonalNote] FROM nvarchar (max) NOT NULL
GO
CREATE TYPE [people].[PersonalName] FROM nvarchar (40) NOT NULL
GO
CREATE TYPE [people].[PersonalLocation] FROM varchar (20) NULL
GO
CREATE TYPE [people].[PersonalEmailAddress] FROM nvarchar (40) NOT NULL
GO
CREATE TYPE [people].[PersonalCVC] FROM char (3) NOT NULL
GO
CREATE TYPE [people].[PersonalAddressline] FROM varchar (60) NULL
GO
CREATE TYPE [dbo].[tid] FROM varchar (6) NOT NULL
GO
CREATE TYPE [dbo].[id] FROM varchar (11) NOT NULL
GO
CREATE TYPE [dbo].[empid] FROM char (9) NOT NULL
GO
CREATE TYPE [dbo].[Dollars] FROM numeric (9, 2) NOT NULL
GO
PRINT N'Creating [people].[Address]'
GO
CREATE TABLE [people].[Address]
(
[Address_ID] [int] NOT NULL IDENTITY(1, 1),
[AddressLine1] [people].[PersonalAddressline] NULL,
[AddressLine2] [people].[PersonalAddressline] NULL,
[City] [people].[PersonalLocation] NULL,
[Region] [people].[PersonalLocation] NULL,
[PostalCode] [people].[PersonalPostalCode] NULL,
[country] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Full_Address] AS (stuff((((coalesce(', '+[AddressLine1],'')+coalesce(', '+[AddressLine2],''))+coalesce(', '+[City],''))+coalesce(', '+[Region],''))+coalesce(', '+[PostalCode],''),(1),(2),'')),
[LegacyIdentifier] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [AddressModifiedDateD] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [AddressPK] on [people].[Address]'
GO
ALTER TABLE [people].[Address] ADD CONSTRAINT [AddressPK] PRIMARY KEY CLUSTERED ([Address_ID]) ON [PRIMARY]
GO
PRINT N'Creating [people].[Abode]'
GO
CREATE TABLE [people].[Abode]
(
[Abode_ID] [int] NOT NULL IDENTITY(1, 1),
[Person_id] [int] NOT NULL,
[Address_id] [int] NOT NULL,
[TypeOfAddress] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[Start_date] [datetime] NOT NULL,
[End_date] [datetime] NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [AbodeModifiedD] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [AbodePK] on [people].[Abode]'
GO
ALTER TABLE [people].[Abode] ADD CONSTRAINT [AbodePK] PRIMARY KEY CLUSTERED ([Abode_ID]) ON [PRIMARY]
GO
PRINT N'Creating [people].[AddressType]'
GO
CREATE TABLE [people].[AddressType]
(
[TypeOfAddress] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [AddressTypeModifiedDateD] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [TypeOfAddressPK] on [people].[AddressType]'
GO
ALTER TABLE [people].[AddressType] ADD CONSTRAINT [TypeOfAddressPK] PRIMARY KEY CLUSTERED ([TypeOfAddress]) ON [PRIMARY]
GO
PRINT N'Creating [people].[Person]'
GO
CREATE TABLE [people].[Person]
(
[person_ID] [int] NOT NULL IDENTITY(1, 1),
[Title] [people].[PersonalTitle] NULL,
[Nickname] [people].[PersonalName] NULL,
[FirstName] [people].[PersonalName] NOT NULL,
[MiddleName] [people].[PersonalName] NULL,
[LastName] [people].[PersonalName] NOT NULL,
[Suffix] [people].[PersonalSuffix] NULL,
[fullName] AS (((((coalesce([Title]+' ','')+[FirstName])+coalesce(' '+[MiddleName],''))+' ')+[LastName])+coalesce(' '+[Suffix],'')),
[LegacyIdentifier] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [PersonModifiedDateD] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PersonIDPK] on [people].[Person]'
GO
ALTER TABLE [people].[Person] ADD CONSTRAINT [PersonIDPK] PRIMARY KEY CLUSTERED ([person_ID]) ON [PRIMARY]
GO
PRINT N'Creating index [SearchByPersonLastname] on [people].[Person]'
GO
CREATE NONCLUSTERED INDEX [SearchByPersonLastname] ON [people].[Person] ([LastName], [FirstName]) ON [PRIMARY]
GO
PRINT N'Creating [people].[CreditCard]'
GO
CREATE TABLE [people].[CreditCard]
(
[CreditCardID] [int] NOT NULL IDENTITY(1, 1),
[Person_id] [int] NOT NULL,
[CardNumber] [people].[PersonalPaymentCardNumber] NOT NULL,
[ValidFrom] [date] NOT NULL,
[ValidTo] [date] NOT NULL,
[CVC] [people].[PersonalCVC] NOT NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [CreditCardModifiedDateD] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [CreditCardPK] on [people].[CreditCard]'
GO
ALTER TABLE [people].[CreditCard] ADD CONSTRAINT [CreditCardPK] PRIMARY KEY CLUSTERED ([CreditCardID]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [people].[CreditCard]'
GO
ALTER TABLE [people].[CreditCard] ADD CONSTRAINT [CreditCardWasntUnique] UNIQUE NONCLUSTERED ([CardNumber]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [people].[CreditCard]'
GO
ALTER TABLE [people].[CreditCard] ADD CONSTRAINT [DuplicateCreditCardUK] UNIQUE NONCLUSTERED ([Person_id], [CardNumber]) ON [PRIMARY]
GO
PRINT N'Creating [people].[EmailAddress]'
GO
CREATE TABLE [people].[EmailAddress]
(
[EmailID] [int] NOT NULL IDENTITY(1, 1),
[Person_id] [int] NOT NULL,
[EmailAddress] [people].[PersonalEmailAddress] NOT NULL,
[StartDate] [date] NOT NULL CONSTRAINT [DF__EmailAddr__Start__007FFA1B] DEFAULT (getdate()),
[EndDate] [date] NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [EmailAddressModifiedDateD] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [EmailPK] on [people].[EmailAddress]'
GO
ALTER TABLE [people].[EmailAddress] ADD CONSTRAINT [EmailPK] PRIMARY KEY CLUSTERED ([EmailID]) ON [PRIMARY]
GO
PRINT N'Creating [accounting].[Bills]'
GO
CREATE TABLE [accounting].[Bills]
(
[id] [int] NOT NULL,
[tran_date] [date] NOT NULL,
[due_date] [date] NULL,
[description] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[reference] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[total] [decimal] (10, 2) NOT NULL,
[status] [smallint] NULL,
[supplier_id] [int] NULL,
[bill_payment_id] [int] NULL,
[Chart_of_Accounts_id] [int] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK__Bills__3213E83FA09F8C93] on [accounting].[Bills]'
GO
ALTER TABLE [accounting].[Bills] ADD CONSTRAINT [PK__Bills__3213E83FA09F8C93] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]
GO
PRINT N'Creating [accounting].[Bill_Lines]'
GO
CREATE TABLE [accounting].[Bill_Lines]
(
[id] [int] NOT NULL,
[line_amount] [decimal] (20, 2) NOT NULL,
[bill_id] [int] NULL,
[line_Chart_of_Accounts_id] [int] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK__Bill_Lin__3213E83FAE977E69] on [accounting].[Bill_Lines]'
GO
ALTER TABLE [accounting].[Bill_Lines] ADD CONSTRAINT [PK__Bill_Lin__3213E83FAE977E69] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]
GO
PRINT N'Creating [accounting].[Chart_of_Accounts]'
GO
CREATE TABLE [accounting].[Chart_of_Accounts]
(
[id] [int] NOT NULL,
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK__Chart_of__3213E83FE903E3B3] on [accounting].[Chart_of_Accounts]'
GO
ALTER TABLE [accounting].[Chart_of_Accounts] ADD CONSTRAINT [PK__Chart_of__3213E83FE903E3B3] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [accounting].[Chart_of_Accounts]'
GO
ALTER TABLE [accounting].[Chart_of_Accounts] ADD CONSTRAINT [UQ__Chart_of__737584F6B2A5ADFA] UNIQUE NONCLUSTERED ([Name]) ON [PRIMARY]
GO
PRINT N'Creating [accounting].[Bill_Payments]'
GO
CREATE TABLE [accounting].[Bill_Payments]
(
[id] [int] NOT NULL,
[tran_date] [date] NOT NULL,
[description] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[reference] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[total] [decimal] (20, 2) NOT NULL,
[Chart_of_Accounts_id] [int] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK__Bill_Pay__3213E83F79E72DBA] on [accounting].[Bill_Payments]'
GO
ALTER TABLE [accounting].[Bill_Payments] ADD CONSTRAINT [PK__Bill_Pay__3213E83F79E72DBA] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]
GO
PRINT N'Creating [accounting].[Suppliers]'
GO
CREATE TABLE [accounting].[Suppliers]
(
[id] [int] NOT NULL,
[supplier_id] [int] NULL,
[contact_id] [int] NULL,
[CustomerFrom] [date] NOT NULL,
[CustomerTo] [date] NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF__Suppliers__Modif__25B17ECA] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK__Supplier__3213E83FDDD2CA08] on [accounting].[Suppliers]'
GO
ALTER TABLE [accounting].[Suppliers] ADD CONSTRAINT [PK__Supplier__3213E83FDDD2CA08] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[stores]'
GO
CREATE TABLE [dbo].[stores]
(
[stor_id] [char] (4) COLLATE Latin1_General_CI_AS NOT NULL,
[stor_name] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[stor_address] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[city] [nvarchar] (40) COLLATE Latin1_General_CI_AS NULL,
[state] [char] (2) COLLATE Latin1_General_CI_AS NULL,
[zip] [char] (5) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [UPK_storeid] on [dbo].[stores]'
GO
ALTER TABLE [dbo].[stores] ADD CONSTRAINT [UPK_storeid] PRIMARY KEY CLUSTERED ([stor_id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[discounts]'
GO
CREATE TABLE [dbo].[discounts]
(
[discounttype] [nvarchar] (80) COLLATE Latin1_General_CI_AS NOT NULL,
[stor_id] [char] (4) COLLATE Latin1_General_CI_AS NULL,
[lowqty] [smallint] NULL,
[highqty] [smallint] NULL,
[discount] [decimal] (4, 2) NOT NULL,
[Discount_id] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Discounts] on [dbo].[discounts]'
GO
ALTER TABLE [dbo].[discounts] ADD CONSTRAINT [PK_Discounts] PRIMARY KEY CLUSTERED ([Discount_id]) ON [PRIMARY]
GO
PRINT N'Creating index [Storid_index] on [dbo].[discounts]'
GO
CREATE NONCLUSTERED INDEX [Storid_index] ON [dbo].[discounts] ([stor_id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[jobs]'
GO
CREATE TABLE [dbo].[jobs]
(
[job_id] [smallint] NOT NULL IDENTITY(1, 1),
[job_desc] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [AssumeANewPosition] DEFAULT ('New Position - title not formalized yet'),
[min_lvl] [tinyint] NOT NULL,
[max_lvl] [tinyint] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK__jobs__6E32B6A51A14E395] on [dbo].[jobs]'
GO
ALTER TABLE [dbo].[jobs] ADD CONSTRAINT [PK__jobs__6E32B6A51A14E395] PRIMARY KEY CLUSTERED ([job_id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[employee]'
GO
CREATE TABLE [dbo].[employee]
(
[emp_id] [dbo].[empid] NOT NULL,
[fname] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[minit] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[lname] [nvarchar] (60) COLLATE Latin1_General_CI_AS NOT NULL,
[job_id] [smallint] NOT NULL CONSTRAINT [AssumeJobIDof1] DEFAULT ((1)),
[job_lvl] [tinyint] NULL CONSTRAINT [AssumeJobLevelof10] DEFAULT ((10)),
[pub_id] [char] (8) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [AssumeAPub_IDof9952] DEFAULT ('9952'),
[hire_date] [datetime] NOT NULL CONSTRAINT [AssumeAewHire] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating index [employee_ind] on [dbo].[employee]'
GO
CREATE CLUSTERED INDEX [employee_ind] ON [dbo].[employee] ([lname], [fname], [minit]) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_emp_id] on [dbo].[employee]'
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [PK_emp_id] PRIMARY KEY NONCLUSTERED ([emp_id]) ON [PRIMARY]
GO
PRINT N'Creating index [JobID_index] on [dbo].[employee]'
GO
CREATE NONCLUSTERED INDEX [JobID_index] ON [dbo].[employee] ([job_id]) ON [PRIMARY]
GO
PRINT N'Creating index [pub_id_index] on [dbo].[employee]'
GO
CREATE NONCLUSTERED INDEX [pub_id_index] ON [dbo].[employee] ([pub_id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[publishers]'
GO
CREATE TABLE [dbo].[publishers]
(
[pub_id] [char] (8) COLLATE Latin1_General_CI_AS NOT NULL,
[pub_name] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[city] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[state] [char] (2) COLLATE Latin1_General_CI_AS NULL,
[country] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [AssumeItsTheSatates] DEFAULT ('USA')
) ON [PRIMARY]
GO
PRINT N'Creating primary key [UPKCL_pubind] on [dbo].[publishers]'
GO
ALTER TABLE [dbo].[publishers] ADD CONSTRAINT [UPKCL_pubind] PRIMARY KEY CLUSTERED ([pub_id]) ON [PRIMARY]
GO
PRINT N'Creating [accounting].[Invoices]'
GO
CREATE TABLE [accounting].[Invoices]
(
[id] [int] NOT NULL,
[tran_date] [date] NOT NULL,
[due_date] [date] NULL,
[description] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[reference] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[total] [decimal] (10, 2) NOT NULL,
[status] [smallint] NULL,
[customer_id] [int] NULL,
[invoice_payment_id] [int] NULL,
[Chart_of_Accounts_id] [int] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK__Invoices__3213E83F4046A87F] on [accounting].[Invoices]'
GO
ALTER TABLE [accounting].[Invoices] ADD CONSTRAINT [PK__Invoices__3213E83F4046A87F] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]
GO
PRINT N'Creating [accounting].[Invoice_Lines]'
GO
CREATE TABLE [accounting].[Invoice_Lines]
(
[id] [int] NOT NULL,
[line_amount] [decimal] (20, 2) NOT NULL,
[invoice_id] [int] NULL,
[line_Chart_of_Accounts_id] [int] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK__Invoice___3213E83F938F9E0B] on [accounting].[Invoice_Lines]'
GO
ALTER TABLE [accounting].[Invoice_Lines] ADD CONSTRAINT [PK__Invoice___3213E83F938F9E0B] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]
GO
PRINT N'Creating [accounting].[Invoice_Payments]'
GO
CREATE TABLE [accounting].[Invoice_Payments]
(
[id] [int] NOT NULL,
[tran_date] [date] NOT NULL,
[description] [nvarchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[reference] [nvarchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[total] [decimal] (20, 2) NOT NULL,
[Chart_of_Accounts_id] [int] NOT NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF__Invoice_P__Modif__24BD5A91] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK__Invoice___3213E83F09263632] on [accounting].[Invoice_Payments]'
GO
ALTER TABLE [accounting].[Invoice_Payments] ADD CONSTRAINT [PK__Invoice___3213E83F09263632] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]
GO
PRINT N'Creating [accounting].[customer]'
GO
CREATE TABLE [accounting].[customer]
(
[id] [int] NOT NULL,
[person_id] [int] NULL,
[organisation_id] [int] NULL,
[CustomerFrom] [date] NOT NULL,
[CustomerTo] [date] NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF__customer__Modifi__23C93658] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK__customer__3213E83F2E301F63] on [accounting].[customer]'
GO
ALTER TABLE [accounting].[customer] ADD CONSTRAINT [PK__customer__3213E83F2E301F63] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]
GO
PRINT N'Creating [people].[PhoneType]'
GO
CREATE TABLE [people].[PhoneType]
(
[TypeOfPhone] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [PhoneTypeModifiedDateD] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PhoneTypePK] on [people].[PhoneType]'
GO
ALTER TABLE [people].[PhoneType] ADD CONSTRAINT [PhoneTypePK] PRIMARY KEY CLUSTERED ([TypeOfPhone]) ON [PRIMARY]
GO
PRINT N'Creating [people].[Phone]'
GO
CREATE TABLE [people].[Phone]
(
[Phone_ID] [int] NOT NULL IDENTITY(1, 1),
[Person_id] [int] NOT NULL,
[TypeOfPhone] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[DiallingNumber] [people].[PersonalPhoneNumber] NOT NULL,
[Start_date] [datetime] NOT NULL,
[End_date] [datetime] NULL,
[ModifiedDate] [datetime] NULL CONSTRAINT [PhoneModifiedDateD] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PhonePK] on [people].[Phone]'
GO
ALTER TABLE [people].[Phone] ADD CONSTRAINT [PhonePK] PRIMARY KEY CLUSTERED ([Phone_ID]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[pub_info]'
GO
CREATE TABLE [dbo].[pub_info]
(
[pub_id] [char] (8) COLLATE Latin1_General_CI_AS NOT NULL,
[logo] [varbinary] (max) NULL,
[pr_info] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [UPKCL_pubinfo] on [dbo].[pub_info]'
GO
ALTER TABLE [dbo].[pub_info] ADD CONSTRAINT [UPKCL_pubinfo] PRIMARY KEY CLUSTERED ([pub_id]) ON [PRIMARY]
GO
PRINT N'Creating [accounting].[Received_Moneys]'
GO
CREATE TABLE [accounting].[Received_Moneys]
(
[id] [int] NOT NULL,
[tran_date] [date] NOT NULL,
[description] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[reference] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[total] [decimal] (20, 2) NOT NULL,
[customer_id] [int] NOT NULL,
[Chart_of_Accounts_id] [int] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK__Received__3213E83F7A768F35] on [accounting].[Received_Moneys]'
GO
ALTER TABLE [accounting].[Received_Moneys] ADD CONSTRAINT [PK__Received__3213E83F7A768F35] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]
GO
PRINT N'Creating [accounting].[Received_Money_Lines]'
GO
CREATE TABLE [accounting].[Received_Money_Lines]
(
[id] [int] NOT NULL,
[line_amount] [decimal] (20, 2) NOT NULL,
[received_money_id] [int] NULL,
[line_Chart_of_Accounts_id] [int] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK__Received__3213E83F8AB14401] on [accounting].[Received_Money_Lines]'
GO
ALTER TABLE [accounting].[Received_Money_Lines] ADD CONSTRAINT [PK__Received__3213E83F8AB14401] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[publications]'
GO
CREATE TABLE [dbo].[publications]
(
[Publication_id] [dbo].[tid] NOT NULL,
[title] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[pub_id] [char] (8) COLLATE Latin1_General_CI_AS NULL,
[notes] [nvarchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[pubdate] [datetime] NOT NULL CONSTRAINT [pub_NowDefault] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Publication] on [dbo].[publications]'
GO
ALTER TABLE [dbo].[publications] ADD CONSTRAINT [PK_Publication] PRIMARY KEY CLUSTERED ([Publication_id]) ON [PRIMARY]
GO
PRINT N'Creating index [pubid_index] on [dbo].[publications]'
GO
CREATE NONCLUSTERED INDEX [pubid_index] ON [dbo].[publications] ([pub_id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[roysched]'
GO
CREATE TABLE [dbo].[roysched]
(
[title_id] [dbo].[tid] NOT NULL,
[lorange] [int] NULL,
[hirange] [int] NULL,
[royalty] [int] NULL,
[roysched_id] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Roysched] on [dbo].[roysched]'
GO
ALTER TABLE [dbo].[roysched] ADD CONSTRAINT [PK_Roysched] PRIMARY KEY CLUSTERED ([roysched_id]) ON [PRIMARY]
GO
PRINT N'Creating index [titleidind] on [dbo].[roysched]'
GO
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[roysched] ([title_id]) ON [PRIMARY]
GO
PRINT N'Creating [accounting].[Spent_Moneys]'
GO
CREATE TABLE [accounting].[Spent_Moneys]
(
[id] [int] NOT NULL,
[tran_date] [date] NOT NULL,
[description] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[reference] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[total] [decimal] (20, 2) NOT NULL,
[supplier_id] [int] NULL,
[Chart_of_Accounts_id] [int] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK__Spent_Mo__3213E83FC36C739E] on [accounting].[Spent_Moneys]'
GO
ALTER TABLE [accounting].[Spent_Moneys] ADD CONSTRAINT [PK__Spent_Mo__3213E83FC36C739E] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]
GO
PRINT N'Creating [accounting].[Spent_Money_Lines]'
GO
CREATE TABLE [accounting].[Spent_Money_Lines]
(
[id] [int] NOT NULL,
[line_amount] [decimal] (20, 2) NOT NULL,
[spent_money_id] [int] NULL,
[line_Chart_of_Accounts_id] [int] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK__Spent_Mo__3213E83FF1621D0E] on [accounting].[Spent_Money_Lines]'
GO
ALTER TABLE [accounting].[Spent_Money_Lines] ADD CONSTRAINT [PK__Spent_Mo__3213E83FF1621D0E] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[authors]'
GO
CREATE TABLE [dbo].[authors]
(
[au_id] [dbo].[id] NOT NULL,
[au_lname] [nvarchar] (80) COLLATE Latin1_General_CI_AS NOT NULL,
[au_fname] [nvarchar] (80) COLLATE Latin1_General_CI_AS NOT NULL,
[phone] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [AssumeUnknown] DEFAULT ('UNKNOWN'),
[address] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[city] [nvarchar] (40) COLLATE Latin1_General_CI_AS NULL,
[state] [char] (2) COLLATE Latin1_General_CI_AS NULL,
[zip] [char] (5) COLLATE Latin1_General_CI_AS NULL,
[contract] [bit] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [UPKCL_auidind] on [dbo].[authors]'
GO
ALTER TABLE [dbo].[authors] ADD CONSTRAINT [UPKCL_auidind] PRIMARY KEY CLUSTERED ([au_id]) ON [PRIMARY]
GO
PRINT N'Creating index [aunmind] on [dbo].[authors]'
GO
CREATE NONCLUSTERED INDEX [aunmind] ON [dbo].[authors] ([au_lname], [au_fname]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[titleauthor]'
GO
CREATE TABLE [dbo].[titleauthor]
(
[au_id] [dbo].[id] NOT NULL,
[title_id] [dbo].[tid] NOT NULL,
[au_ord] [tinyint] NULL,
[royaltyper] [int] NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [UPKCL_taind] on [dbo].[titleauthor]'
GO
ALTER TABLE [dbo].[titleauthor] ADD CONSTRAINT [UPKCL_taind] PRIMARY KEY CLUSTERED ([au_id], [title_id]) ON [PRIMARY]
GO
PRINT N'Creating index [auidind] on [dbo].[titleauthor]'
GO
CREATE NONCLUSTERED INDEX [auidind] ON [dbo].[titleauthor] ([au_id]) ON [PRIMARY]
GO
PRINT N'Creating index [titleidind] on [dbo].[titleauthor]'
GO
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[titleauthor] ([title_id]) ON [PRIMARY]
GO
PRINT N'Creating [people].[Organisation]'
GO
CREATE TABLE [people].[Organisation]
(
[organisation_ID] [int] NOT NULL IDENTITY(1, 1),
[OrganisationName] [nvarchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[LineOfBusiness] [nvarchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[LegacyIdentifier] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [organisationModifiedDateD] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [organisationIDPK] on [people].[Organisation]'
GO
ALTER TABLE [people].[Organisation] ADD CONSTRAINT [organisationIDPK] PRIMARY KEY CLUSTERED ([organisation_ID]) ON [PRIMARY]
GO
PRINT N'Creating index [SearchByOrganisationName] on [people].[Organisation]'
GO
CREATE NONCLUSTERED INDEX [SearchByOrganisationName] ON [people].[Organisation] ([OrganisationName]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[editions]'
GO
CREATE TABLE [dbo].[editions]
(
[Edition_id] [int] NOT NULL IDENTITY(1, 1),
[publication_id] [dbo].[tid] NOT NULL,
[Publication_type] [nvarchar] (20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF__editions__Public__1F398B65] DEFAULT ('book'),
[EditionDate] [datetime2] NOT NULL CONSTRAINT [DF__editions__Editio__202DAF9E] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_editions] on [dbo].[editions]'
GO
ALTER TABLE [dbo].[editions] ADD CONSTRAINT [PK_editions] PRIMARY KEY CLUSTERED ([Edition_id]) ON [PRIMARY]
GO
PRINT N'Creating index [Publicationid_index] on [dbo].[editions]'
GO
CREATE NONCLUSTERED INDEX [Publicationid_index] ON [dbo].[editions] ([publication_id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[prices]'
GO
CREATE TABLE [dbo].[prices]
(
[Price_id] [int] NOT NULL IDENTITY(1, 1),
[Edition_id] [int] NULL,
[price] [dbo].[Dollars] NULL,
[advance] [dbo].[Dollars] NULL,
[royalty] [int] NULL,
[ytd_sales] [int] NULL,
[PriceStartDate] [datetime2] NOT NULL CONSTRAINT [DF__prices__PriceSta__230A1C49] DEFAULT (getdate()),
[PriceEndDate] [datetime2] NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Prices] on [dbo].[prices]'
GO
ALTER TABLE [dbo].[prices] ADD CONSTRAINT [PK_Prices] PRIMARY KEY CLUSTERED ([Price_id]) ON [PRIMARY]
GO
PRINT N'Creating index [editionid_index] on [dbo].[prices]'
GO
CREATE NONCLUSTERED INDEX [editionid_index] ON [dbo].[prices] ([Edition_id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Publication_Types]'
GO
CREATE TABLE [dbo].[Publication_Types]
(
[Publication_Type] [nvarchar] (20) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK__Publicat__66D9D2B3FB0C9D95] on [dbo].[Publication_Types]'
GO
ALTER TABLE [dbo].[Publication_Types] ADD CONSTRAINT [PK__Publicat__66D9D2B3FB0C9D95] PRIMARY KEY CLUSTERED ([Publication_Type]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[sales]'
GO
CREATE TABLE [dbo].[sales]
(
[stor_id] [char] (4) COLLATE Latin1_General_CI_AS NOT NULL,
[ord_num] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[ord_date] [datetime] NOT NULL,
[qty] [smallint] NOT NULL,
[payterms] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[title_id] [dbo].[tid] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [UPKCL_sales] on [dbo].[sales]'
GO
ALTER TABLE [dbo].[sales] ADD CONSTRAINT [UPKCL_sales] PRIMARY KEY CLUSTERED ([stor_id], [ord_num], [title_id]) ON [PRIMARY]
GO
PRINT N'Creating index [titleidind] on [dbo].[sales]'
GO
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[sales] ([title_id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[TagName]'
GO
CREATE TABLE [dbo].[TagName]
(
[TagName_ID] [int] NOT NULL IDENTITY(1, 1),
[Tag] [nvarchar] (80) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [TagnameSurrogate] on [dbo].[TagName]'
GO
ALTER TABLE [dbo].[TagName] ADD CONSTRAINT [TagnameSurrogate] PRIMARY KEY CLUSTERED ([TagName_ID]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[TagName]'
GO
ALTER TABLE [dbo].[TagName] ADD CONSTRAINT [Uniquetag] UNIQUE NONCLUSTERED ([Tag]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[TagTitle]'
GO
CREATE TABLE [dbo].[TagTitle]
(
[TagTitle_ID] [int] NOT NULL IDENTITY(1, 1),
[title_id] [dbo].[tid] NOT NULL,
[Is_Primary] [bit] NOT NULL CONSTRAINT [NotPrimary] DEFAULT ((0)),
[TagName_ID] [int] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_TagNameTitle] on [dbo].[TagTitle]'
GO
ALTER TABLE [dbo].[TagTitle] ADD CONSTRAINT [PK_TagNameTitle] PRIMARY KEY CLUSTERED ([title_id], [TagName_ID]) ON [PRIMARY]
GO
PRINT N'Creating index [TagName_index] on [dbo].[TagTitle]'
GO
CREATE NONCLUSTERED INDEX [TagName_index] ON [dbo].[TagTitle] ([TagName_ID]) ON [PRIMARY]
GO
PRINT N'Creating index [Titleid_index] on [dbo].[TagTitle]'
GO
CREATE NONCLUSTERED INDEX [Titleid_index] ON [dbo].[TagTitle] ([title_id]) ON [PRIMARY]
GO
PRINT N'Creating [people].[Word]'
GO
CREATE TABLE [people].[Word]
(
[Item] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[frequency] [int] NOT NULL CONSTRAINT [DF__Word__frequency__26A5A303] DEFAULT ((0))
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PKWord] on [people].[Word]'
GO
ALTER TABLE [people].[Word] ADD CONSTRAINT [PKWord] PRIMARY KEY CLUSTERED ([Item]) ON [PRIMARY]
GO
PRINT N'Creating [people].[WordOccurence]'
GO
CREATE TABLE [people].[WordOccurence]
(
[Item] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[location] [int] NOT NULL,
[Sequence] [int] NOT NULL,
[Note] [int] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PKWordOcurrence] on [people].[WordOccurence]'
GO
ALTER TABLE [people].[WordOccurence] ADD CONSTRAINT [PKWordOcurrence] PRIMARY KEY CLUSTERED ([Item], [Sequence], [Note]) ON [PRIMARY]
GO
PRINT N'Creating [people].[Location]'
GO
CREATE TABLE [people].[Location]
(
[Location_ID] [int] NOT NULL IDENTITY(1, 1),
[organisation_id] [int] NOT NULL,
[Address_id] [int] NOT NULL,
[TypeOfAddress] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[Start_date] [datetime] NOT NULL,
[End_date] [datetime] NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [LocationModifiedD] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [LocationPK] on [people].[Location]'
GO
ALTER TABLE [people].[Location] ADD CONSTRAINT [LocationPK] PRIMARY KEY CLUSTERED ([Location_ID]) ON [PRIMARY]
GO
PRINT N'Creating [people].[Note]'
GO
CREATE TABLE [people].[Note]
(
[Note_id] [int] NOT NULL IDENTITY(1, 1),
[Note] [people].[PersonalNote] NOT NULL,
[NoteStart] AS (coalesce(left([Note],(850)),'Blank'+CONVERT([nvarchar](20),rand()*(20),(0)))),
[InsertionDate] [datetime] NOT NULL CONSTRAINT [NoteInsertionDateDL] DEFAULT (getdate()),
[InsertedBy] [sys].[sysname] NOT NULL CONSTRAINT [GetUserName] DEFAULT (user_name()),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [NoteModifiedDateD] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [NotePK] on [people].[Note]'
GO
ALTER TABLE [people].[Note] ADD CONSTRAINT [NotePK] PRIMARY KEY CLUSTERED ([Note_id]) ON [PRIMARY]
GO
PRINT N'Creating [people].[NotePerson]'
GO
CREATE TABLE [people].[NotePerson]
(
[NotePerson_id] [int] NOT NULL IDENTITY(1, 1),
[Person_id] [int] NOT NULL,
[Note_id] [int] NOT NULL,
[InsertionDate] [datetime] NOT NULL CONSTRAINT [NotePersonInsertionDateD] DEFAULT (getdate()),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [NotePersonModifiedDateD] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [NotePersonPK] on [people].[NotePerson]'
GO
ALTER TABLE [people].[NotePerson] ADD CONSTRAINT [NotePersonPK] PRIMARY KEY CLUSTERED ([NotePerson_id]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [people].[NotePerson]'
GO
ALTER TABLE [people].[NotePerson] ADD CONSTRAINT [DuplicateUK] UNIQUE NONCLUSTERED ([Person_id], [Note_id], [InsertionDate]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[titles]'
GO
CREATE VIEW [dbo].[titles]
/* this view replaces the old TITLES table and shows only those books that represent each publication and only the current price */
AS
SELECT publications.Publication_id AS title_id, publications.title,
  Tag AS [Type], pub_id, price, advance, royalty, ytd_sales, notes, pubdate
  FROM publications
    INNER JOIN editions
      ON editions.publication_id = publications.Publication_id
     AND Publication_type = 'book'
    INNER JOIN prices
      ON prices.Edition_id = editions.Edition_id
    LEFT OUTER JOIN TagTitle
      ON TagTitle.title_id = publications.Publication_id
     AND TagTitle.Is_Primary = 1 --just the first, primary, tag
    LEFT OUTER JOIN dbo.TagName
      ON TagTitle.TagName_ID = TagName.TagName_ID
  WHERE prices.PriceEndDate IS NULL;
GO
PRINT N'Creating [dbo].[reptq2]'
GO
CREATE PROCEDURE [dbo].[reptq2]
AS
  BEGIN
    SELECT CASE WHEN Grouping(TN.tag) = 1 THEN 'ALL' ELSE TN.Tag END AS type,
      CASE WHEN Grouping(titles.pub_id) = 1 THEN 'ALL' ELSE titles.pub_id END AS pub_id,
      Avg(titles.ytd_sales) AS avg_ytd_sales
      FROM dbo.titles AS titles
        INNER JOIN dbo.TagTitle AS TagTitle
          ON TagTitle.title_id = titles.title_id
        INNER JOIN dbo.TagName AS TN
          ON TN.TagName_ID = TagTitle.TagName_ID
      WHERE titles.pub_id IS NOT NULL AND TagTitle.Is_Primary = 1
      GROUP BY titles.pub_id, TN.Tag WITH ROLLUP;
  END;
GO
PRINT N'Creating [dbo].[reptq3]'
GO
CREATE PROCEDURE [dbo].[reptq3] @lolimit dbo.Dollars, @hilimit dbo.Dollars,
  @type CHAR(12)
AS
  BEGIN
    SELECT CASE WHEN Grouping(titles.pub_id) = 1 THEN 'ALL' ELSE titles.pub_id END AS pub_id,
      CASE WHEN Grouping(TN.tag) = 1 THEN 'ALL' ELSE TN.Tag END AS type,
      Count(titles.title_id) AS cnt
      FROM dbo.titles AS titles
        INNER JOIN dbo.TagTitle AS TagTitle
          ON TagTitle.title_id = titles.title_id
        INNER JOIN dbo.TagName AS TN
          ON TN.TagName_ID = TagTitle.TagName_ID
      WHERE titles.price > @lolimit
        AND TagTitle.Is_Primary = 1
        AND titles.price < @hilimit
        AND TN.Tag = @type
         OR TN.Tag LIKE '%cook%'
      GROUP BY titles.pub_id, TN.Tag WITH ROLLUP;
  END;
GO
PRINT N'Creating [people].[publishers]'
GO
CREATE VIEW [people].[publishers]
as
SELECT Replace (Address.LegacyIdentifier, 'pub-', '') AS pub_id,
  OrganisationName AS pub_name, City, Region AS state, country
  FROM People.Organisation
    INNER JOIN People.Location
      ON Location.organisation_id = Organisation.organisation_ID
    INNER JOIN People.Address
      ON Address.Address_ID = Location.Address_id
  WHERE LineOfBusiness = 'Publisher' AND End_date IS NULL;
GO
PRINT N'Creating [people].[authors]'
GO
CREATE VIEW [people].[authors]
AS
SELECT Replace (Address.LegacyIdentifier, 'au-', '') AS au_id,
  LastName AS au_lname, FirstName AS au_fname, DiallingNumber AS phone,
  Coalesce (AddressLine1, '') + Coalesce (' ' + AddressLine2, '') AS address,
  City, Region AS state, PostalCode AS zip
  FROM People.Person
    INNER JOIN People.Abode
      ON Abode.Person_id = Person.person_ID
    INNER JOIN People.Address
      ON Address.Address_ID = Abode.Address_id
    LEFT OUTER JOIN People.Phone
	 ON Phone.Person_id = Person.person_ID
  WHERE People.Abode.End_date IS NULL 
  AND phone.End_date IS null
  AND Person.LegacyIdentifier LIKE 'au-%';
GO
PRINT N'Creating [accounting].[Bill_Trans]'
GO
CREATE VIEW [accounting].[Bill_Trans]
AS
  WITH btrans
  AS (
     SELECT Convert (VARCHAR(10), b.id) AS tran_id, b.tran_date,
            b.Chart_of_Accounts_id AS ap_account,
            -- ABS(total) as total,
            c.Name, b.total, bl.id AS line_id, bl.line_Chart_of_Accounts_id,
            bl.line_amount, bp.id, bp.Chart_of_Accounts_id AS bank_account,
            'Business Bank Account' AS bank_name, b.status
       FROM
       accounting.Bills AS b
         LEFT JOIN accounting.Bill_Lines AS bl
           ON b.id = bl.bill_id
         LEFT JOIN accounting.Chart_of_Accounts AS c
           ON b.Chart_of_Accounts_id = c.id
         LEFT JOIN accounting.Bill_Payments AS bp
           ON b.bill_payment_id = bp.id)
  SELECT btrans.tran_id, btrans.tran_date, btrans.ap_account, btrans.Name,
         btrans.total, btrans.line_id, btrans.line_Chart_of_Accounts_id,
         btrans.line_amount, btrans.id, btrans.bank_account,
         btrans.bank_name, btrans.status,
         c.Name AS line_Chart_of_Accounts_name
    FROM
    btrans
      LEFT JOIN accounting.Chart_of_Accounts AS c
        ON btrans.line_Chart_of_Accounts_id = c.id;
GO
PRINT N'Creating [accounting].[Invoice_Trans]'
GO
CREATE VIEW [accounting].[Invoice_Trans]
AS
  WITH itrans
  AS (
     SELECT Convert (VARCHAR(10), i.id) AS tran_id, i.tran_date,
            i.Chart_of_Accounts_id AS ar_account, c.Name, i.total,
            il.id AS line_id, il.line_Chart_of_Accounts_id, il.line_amount,
            ip.id, ip.Chart_of_Accounts_id AS bank_account,
            'Business Bank account' AS bank_name, i.status
       FROM
       accounting.Invoices AS i
         LEFT JOIN accounting.Invoice_Lines AS il
           ON i.id = il.invoice_id
         LEFT JOIN accounting.Chart_of_Accounts AS c
           ON i.Chart_of_Accounts_id = c.id
         LEFT JOIN accounting.Invoice_Payments AS ip
           ON i.invoice_payment_id = ip.id)
  SELECT itrans.*, c.Name AS line_Chart_of_Accounts_name
    FROM
    itrans
      LEFT JOIN accounting.Chart_of_Accounts AS c
        ON itrans.line_Chart_of_Accounts_id = c.id;
GO
PRINT N'Creating [accounting].[Received_Money_Trans]'
GO
CREATE VIEW [accounting].[Received_Money_Trans]
AS
  SELECT 'RM' + Convert (VARCHAR(10), rm.id) AS tran_id, tran_date,
         Chart_of_Accounts_id,
         'Business Bank Account' AS Chart_of_Accounts_name, total,
         rml.id AS line_id, rml.line_Chart_of_Accounts_id,
         c.Name AS line_Chart_of_Accounts_name, rml.line_amount
    FROM
    accounting.Received_Moneys AS rm
      LEFT JOIN accounting.Received_Money_Lines AS rml
        ON rm.id = rml.received_money_id
      LEFT JOIN accounting.Chart_of_Accounts AS c
        ON c.id = rml.line_Chart_of_Accounts_id;
GO
PRINT N'Creating [accounting].[Spent_Money_Trans]'
GO
CREATE VIEW [accounting].[Spent_Money_Trans]
AS
  SELECT 'SM' + Convert (VARCHAR(10), sm.id) AS tran_id, tran_date,
         Chart_of_Accounts_id,
         'Business Bank Account' AS Chart_of_Accounts_name, total,
         sml.id AS line_id, sml.line_Chart_of_Accounts_id,
         c.Name AS line_Chart_of_Accounts_name, sml.line_amount
    FROM
    accounting.Spent_Moneys AS sm
      LEFT JOIN accounting.Spent_Money_Lines AS sml
        ON sm.id = sml.spent_money_id
      LEFT JOIN accounting.Chart_of_Accounts AS c
        ON c.id = sml.line_Chart_of_Accounts_id;
--SELECT * from accounting.Spent_Money_Trans;
GO
PRINT N'Creating [accounting].[Trial_Balance]'
GO
CREATE VIEW [accounting].[Trial_Balance]
AS
  SELECT line_Chart_of_Accounts_id AS acct_code,
         line_Chart_of_Accounts_name AS acct_name,
         (CASE WHEN Sum (line_amount) > 0 THEN Sum (line_amount) ELSE 0 END) AS debit_bal,
         (CASE WHEN Sum (line_amount) < 0 THEN Sum (line_amount) ELSE 0 END) AS credit_bal
    FROM accounting.Invoice_Trans
    GROUP BY
    line_Chart_of_Accounts_id, line_Chart_of_Accounts_name
  -- select all purchases
  UNION ALL
  SELECT line_Chart_of_Accounts_id AS acct_code,
         line_Chart_of_Accounts_name AS acct_name,
         (CASE WHEN Sum (line_amount) > 0 THEN Sum (line_amount) ELSE 0 END) AS debit_bal,
         (CASE WHEN Sum (line_amount) < 0 THEN Sum (line_amount) ELSE 0 END) AS credit_bal
    FROM accounting.Bill_Trans
    GROUP BY
    line_Chart_of_Accounts_id, line_Chart_of_Accounts_name
  -- select all received money
  UNION ALL
  SELECT line_Chart_of_Accounts_id AS acct_code,
         line_Chart_of_Accounts_name AS acct_name,
         (CASE WHEN Sum (line_amount) > 0 THEN Sum (line_amount) ELSE 0 END) AS debit_bal,
         (CASE WHEN Sum (line_amount) < 0 THEN Sum (line_amount) ELSE 0 END) AS credit_bal
    FROM accounting.Received_Money_Trans
    GROUP BY
    line_Chart_of_Accounts_id, line_Chart_of_Accounts_name
  -- select all spent money
  UNION ALL
  SELECT line_Chart_of_Accounts_id AS acct_code,
         line_Chart_of_Accounts_name AS acct_name,
         (CASE WHEN Sum (line_amount) > 0 THEN Sum (line_amount) ELSE 0 END) AS debit_bal,
         (CASE WHEN Sum (line_amount) < 0 THEN Sum (line_amount) ELSE 0 END) AS credit_bal
    FROM accounting.Spent_Money_Trans
    GROUP BY
    line_Chart_of_Accounts_id, line_Chart_of_Accounts_name
  -- select all AP
  UNION ALL
  SELECT Max (ap_account) AS acct_code,
         Max (line_Chart_of_Accounts_name) AS acct_name,
         - (CASE WHEN Sum (line_amount) < 0 THEN Sum (line_amount) ELSE 0 END) AS debit_bal,
         - (CASE WHEN Sum (line_amount) > 0 THEN Sum (line_amount) ELSE 0 END) AS credit_bal
    FROM accounting.Bill_Trans
    WHERE status = 0
  -- select all AR
  UNION ALL
  SELECT Max (ar_account) AS acct_code,
         Max (line_Chart_of_Accounts_name) AS acct_name,
         - (CASE WHEN Sum (line_amount) < 0 THEN Sum (line_amount) ELSE 0 END) AS debit_bal,
         - (CASE WHEN Sum (line_amount) > 0 THEN Sum (line_amount) ELSE 0 END) AS credit_bal
    FROM accounting.Invoice_Trans
    WHERE status = 0
  -- select all bill_payments
  UNION ALL
  SELECT Max (bank_account) AS acct_code, Max (bank_name) AS acct_name,
         - (CASE WHEN Sum (line_amount) < 0 THEN Sum (line_amount) ELSE 0 END) AS debit_bal,
         - (CASE WHEN Sum (line_amount) > 0 THEN Sum (line_amount) ELSE 0 END) AS credit_bal
    FROM accounting.Bill_Trans
    WHERE status = 1
  -- select all invoice_payments
  UNION ALL
  SELECT Max (bank_account) AS acct_code, Max (bank_name) AS acct_name,
         - (CASE WHEN Sum (line_amount) < 0 THEN Sum (line_amount) ELSE 0 END) AS debit_bal,
         - (CASE WHEN Sum (line_amount) > 0 THEN Sum (line_amount) ELSE 0 END) AS credit_bal
    FROM accounting.Invoice_Trans
    WHERE status = 1
  -- select all received_money
  UNION ALL
  SELECT Max (Chart_of_Accounts_id) AS acct_code,
         Max (Chart_of_Accounts_name) AS acct_name,
         - (CASE WHEN Sum (line_amount) < 0 THEN Sum (line_amount) ELSE 0 END) AS debit_bal,
         - (CASE WHEN Sum (line_amount) > 0 THEN Sum (line_amount) ELSE 0 END) AS credit_bal
    FROM accounting.Received_Money_Trans
  -- select all spent_money
  UNION ALL
  SELECT Max (Chart_of_Accounts_id) AS acct_code,
         Max (Chart_of_Accounts_name) AS acct_name,
         - (CASE WHEN Sum (line_amount) < 0 THEN Sum (line_amount) ELSE 0 END) AS debit_bal,
         - (CASE WHEN Sum (line_amount) > 0 THEN Sum (line_amount) ELSE 0 END) AS credit_bal
    FROM accounting.Spent_Money_Trans;
GO
PRINT N'Creating [dbo].[IterativeWordChop]'
GO
CREATE FUNCTION [dbo].[IterativeWordChop]
/*
summary:   >
This Table-valued function takes any text as a parameter and splits it into its constituent words,
passing back the order in which they occured and their location in the text. 
Author: Phil Factor
Revision: 1.3
date: 2 Apr 2014
example:
     - code: SELECT * FROM IterativeWordChop('this tests stuff. Will it work?')
     - code: SELECT * FROM IterativeWordChop('this ------- tests it again; Will it work ...')
     - code: SELECT * FROM IterativeWordChop('Do we allow %Wildcards% like %x%?')
returns:   >
Table of SequenceNumber, item (word) and sequence no.
**/
( 
@string VARCHAR(MAX)
) 
RETURNS
@Results TABLE
(
Item VARCHAR(255),
location INT,
Sequence INT IDENTITY PRIMARY KEY
)
AS
BEGIN
DECLARE @Len INT, @Start INT, @end INT, @Cursor INT,@length INT
SELECT @Cursor=1, @len=Len(@string)
WHILE @cursor<@len
   BEGIN
   SELECT @start=PatIndex('%[^A-Za-z0-9][A-Za-z0-9%]%',
                   ' '+Substring (@string,@cursor,50)
                   )-1
   IF @start<0 BREAK                
   SELECT @length=PatIndex('%[^A-Z''a-z0-9-%]%',Substring (@string,@cursor+@start+1,50)+' ')   
   INSERT INTO @results(item, location) 
       SELECT  Substring(@string,@cursor+@start,@length), @cursor+@start
   SELECT @Cursor=@Cursor+@Start+@length+1
   END
RETURN
END
GO
PRINT N'Creating [dbo].[FindString]'
GO
CREATE FUNCTION [dbo].[FindString]
  /*
summary:  >
 This Table-valued function takes text as a parameter and 
 tries to find it in the WordOccurence table
example:
   - code: SELECT * FROM FindString('disgusting')
   - code: SELECT TOP 10 note_id, Max(NoteStart) AS Note_Start, 
                 Max(InsertionDate)AS Insertion_Date, 
                 Max(InsertedBy) AS Inserted_by  
             from 
	         (SELECT note_id, NoteStart, InsertionDate, InsertedBy 
	         FROM people.note NS
	         INNER JOIN FindString('despite trying all sorts') FW
	         ON FW.note=NS.note_id)f
             group by Note_id
             order by Max(InsertionDate) desc
returns:  >
passes back the location where they were found, and 
the number of words matched in the string.
**/
  (@string VARCHAR(100))
RETURNS @finds TABLE (location INT NOT NULL, note INT NOT NULL, hits INT NOT NULL)
AS
  BEGIN
    DECLARE @WordsToLookUp TABLE
      (
      Item VARCHAR(255) NOT NULL,
      location INT NOT NULL,
      Sequence INT NOT NULL PRIMARY KEY
      );
    DECLARE @wordCount INT, @searches INT;
    -- chop the string into its constituent words, with the sequence
    INSERT INTO @WordsToLookUp (Item, location, Sequence)
      SELECT Item, location, Sequence FROM dbo.IterativeWordChop(@string);
    -- determine how many words and work out what proportion to search for
    SELECT @wordCount = @@RowCount;
    SELECT @searches =
       CASE WHEN @wordCount < 3 THEN @wordCount ELSE 2 + (@wordCount / 2) END;
    IF @wordcount=1
		BEGIN
		INSERT INTO @finds (location, note, hits)
			SELECT MIN(location), note, 1 
				FROM people.wordoccurence WHERE item LIKE @string GROUP BY note
        return
		END 
    INSERT INTO @finds (location, Note, hits)
      SELECT Min(WordOccurence.location), Note, Count(*) AS matches
        FROM people.WordOccurence
          INNER JOIN
            (
            SELECT TOP (@searches) Word.Item, searchterm.Sequence
              FROM @WordsToLookUp searchterm
                INNER JOIN people.Word
                  ON searchterm.Item = Word.Item
              ORDER BY frequency
            ) LessFrequentWords(item, Sequence)
            ON LessFrequentWords.item = WordOccurence.Item
        GROUP BY WordOccurence.Sequence - LessFrequentWords.Sequence,
        note
        HAVING Count(*) >= @searches
        ORDER BY Count(*) DESC;
    RETURN;
  END;
GO
PRINT N'Creating [dbo].[FindWords]'
GO
CREATE FUNCTION [dbo].[FindWords]
  /*
summary:  >
This Table-valued function takes text as a parameter and tries to find it in the people.WordOccurence table
Author: Phil Factor
example:
   - code: SELECT * FROM FindWords('disgusting')
   - code: SELECT * FROM FindWords('Yvonne')
   - code: SELECT * FROM FindWords('unacceptable')
   - code: SELECT TOP 10 note_id, Max(NoteStart) AS Note_Start, 
                 Max(InsertionDate)AS Insertion_Date, 
                 Max(InsertedBy) AS Inserted_by  
             from 
	         (SELECT note_id, NoteStart, InsertionDate, InsertedBy 
	         FROM people.note NS
	         INNER JOIN FindWords('disgusting ridiculous') FW
	         ON FW.note=NS.note_id)f
             group by Note_id
             order by Max(InsertionDate) desc
returns:  >
passes back the location where they were found, and the number of words matched in the string.
**/
  (@string VARCHAR(100))
RETURNS @finds TABLE (location INT NOT NULL, Note INT NOT NULL, hits INT NOT NULL)
AS
  BEGIN
    DECLARE @WordsToLookUp TABLE
      (
      Item VARCHAR(255) NOT NULL,
      location INT NOT NULL,
      Sequence INT NOT NULL PRIMARY KEY
      );
    DECLARE @wordCount INT, @searches INT;
    -- chop the string into its constituent words, with the sequence
    INSERT INTO @WordsToLookUp (Item, location, Sequence)
      SELECT Item, location, Sequence FROM dbo.IterativeWordChop(@string);
    -- determine how many words and work out what proportion to search for
    SELECT @wordCount = @@RowCount;
    SELECT @searches =
       CASE WHEN @wordCount < 6 THEN @wordCount ELSE 2 + (@wordCount / 2) END;
    IF @wordcount=1
		BEGIN
		INSERT INTO @finds (location, Note, hits)
			SELECT MIN(location), Note, 1 
			FROM people.WordOccurence WHERE item LIKE @string GROUP BY Note
        return
		END 
		INSERT INTO @finds (location, Note, hits)
		   SELECT Min(Firstlocation), Note, @wordcount  FROM 
	  (SELECT wordswanted.[sequence] AS theorder,Note,
	  Min(WordOccurence.location) AS FirstLocation 
        FROM -- @WordsToLookUp wordsWanted
		(
            SELECT TOP (@searches) Word.Item, searchterm.Sequence
              FROM @WordsToLookUp searchterm
                INNER JOIN people.Word
                  ON searchterm.Item = Word.Item
              ORDER BY frequency
            ) wordsWanted(item, Sequence)
	  INNER JOIN people.WordOccurence ON WordOccurence.Item = wordsWanted.Item
	  GROUP BY Note,wordsWanted.[sequence])f
 GROUP BY Note
 HAVING Count(*)=@searches
    RETURN;
  END;
GO
PRINT N'Creating [dbo].[SearchNotes]'
GO
/*
*/
Create FUNCTION [dbo].[SearchNotes] (@TheStrings NVARCHAR(400))
/**
Summary: >
  This is the application interface, in that it provides the 
  context and works out if the user is specifying a string to
  search for or a collection of words. It chooses to use one 
  of two search algorithms depending on whether it is given
  a word or phrase to search for.
Author: Phil Factor
Date: Wednesday, 13 July 2022
Database: PubsSearch- for the pubs project
Examples:
  - SELECT * FROM dbo.searchNotes('"I''ve tried calling"')
  - SELECT * FROM dbo.searchNotes('I''ve tried calling')
Returns: >
  a table of results, giving the context where the string was found and 
  thew key to the record.
**/
RETURNS @FoundInRecord TABLE
  (TheOrder INT,
   theWord NVARCHAR(100),
   context NVARCHAR(800),
   Thekey INT,
   TheDate DATETIME,
   InsertedBy NVARCHAR(100))
AS
  BEGIN
    DECLARE @SearchResult TABLE
      (TheOrder INT IDENTITY,
       location INT,
       Note INT,
       hits INT);
    DECLARE @InputWasAString INT;
    SELECT @InputWasAString =
    CASE WHEN LTrim(@TheStrings) LIKE '[''"]%' AND RTrim(@TheStrings) LIKE '%[''"]'  THEN 1 ELSE 0 END;
    /* the output of the search */
    IF @InputWasAString = 0
      INSERT INTO @SearchResult (location, Note, hits)
        SELECT location, Note, hits FROM FindWords (@TheStrings);
    ELSE
      INSERT INTO @SearchResult (location, Note, hits)
        SELECT location, note, hits FROM FindString (@TheStrings);
    DECLARE @ii INT, @iiMax INT, @Location INT, @Key INT;
    SELECT @ii = Min (TheOrder), @iiMax = Max (TheOrder) FROM @SearchResult;
    WHILE (@ii <= @iiMax)
      BEGIN
        SELECT @Location = location, @Key = Note FROM @SearchResult WHERE
        TheOrder = @ii;
        INSERT INTO @FoundInRecord
          (TheOrder, theWord, context, Thekey, TheDate, InsertedBy)
          SELECT @ii, @TheStrings,
                 '...' + Substring (Note, @Location - 70, 150) + '...',
                 @key, InsertionDate, InsertedBy
            FROM people.Note
            WHERE Note_id = @Key;
        SELECT @ii = @ii + 1;
      END;
    RETURN;
  END;
GO
PRINT N'Creating [dbo].[PublishersByPublicationType]'
GO
CREATE VIEW [dbo].[PublishersByPublicationType] as
/* A view to provide the number of each type of publication produced
by each publisher*/
SELECT Coalesce(publishers.pub_name, '---All types') AS publisher,
Sum(CASE WHEN Editions.Publication_type = 'AudioBook' THEN 1 ELSE 0 END) AS 'AudioBook',
Sum(CASE WHEN Editions.Publication_type ='Book' THEN 1 ELSE 0 END) AS 'Book',
Sum(CASE WHEN Editions.Publication_type ='Calendar' THEN 1 ELSE 0 END) AS 'Calendar',
Sum(CASE WHEN Editions.Publication_type ='Ebook' THEN 1 ELSE 0 END) AS 'Ebook',
Sum(CASE WHEN Editions.Publication_type ='Hardback' THEN 1 ELSE 0 END) AS 'Hardback',
Sum(CASE WHEN Editions.Publication_type ='Map' THEN 1 ELSE 0 END) AS 'Map',
Sum(CASE WHEN Editions.Publication_type ='Paperback' THEN 1 ELSE 0 END) AS 'PaperBack',
Count(*) AS total
 FROM dbo.publishers
INNER JOIN dbo.publications
ON publications.pub_id = publishers.pub_id
INNER JOIN editions ON editions.publication_id = publications.Publication_id
INNER JOIN dbo.prices ON prices.Edition_id = editions.Edition_id
WHERE prices.PriceEndDate IS null 
GROUP BY publishers.pub_name
WITH ROLLUP
GO
PRINT N'Creating [dbo].[TitlesAndEditionsByPublisher]'
GO
CREATE VIEW [dbo].[TitlesAndEditionsByPublisher]
AS
/* A view to provide the number of each type of publication produced
Select * from [dbo].[TitlesAndEditionsByPublisher]
by each publisher*/
SELECT publishers.pub_name AS publisher, title,
  String_Agg
    (
    Publication_type + ' ($' + Convert(VARCHAR(20), price) + ')', ', '
    ) AS ListOfEditions
  FROM dbo.publishers
    INNER JOIN dbo.publications
      ON publications.pub_id = publishers.pub_id
    INNER JOIN editions
      ON editions.publication_id = publications.Publication_id
    INNER JOIN dbo.prices
      ON prices.Edition_id = editions.Edition_id
  WHERE prices.PriceEndDate IS NULL
  GROUP BY publishers.pub_name, title;
GO
PRINT N'Creating [dbo].[titleview]'
GO
CREATE VIEW [dbo].[titleview]
AS
SELECT title, au_ord, au_lname, price, ytd_sales, pub_id
  FROM authors, titles, titleauthor
  WHERE authors.au_id = titleauthor.au_id
    AND titles.title_id = titleauthor.title_id;
GO
PRINT N'Creating [dbo].[byroyalty]'
GO
CREATE PROCEDURE [dbo].[byroyalty] @percentage INT
AS
  BEGIN
    SELECT titleauthor.au_id
      FROM dbo.titleauthor AS titleauthor
      WHERE titleauthor.royaltyper = @percentage;
  END;
GO
PRINT N'Creating [dbo].[reptq1]'
GO
CREATE PROCEDURE [dbo].[reptq1]
AS
  BEGIN
    SELECT CASE WHEN Grouping(publications.pub_id) = 1 
	         THEN 'ALL' ELSE publications.pub_id END AS pub_id,
      Avg(price) AS avg_price
      FROM dbo.publishers
        INNER JOIN dbo.publications
          ON publications.pub_id = publishers.pub_id
        INNER JOIN editions
          ON editions.publication_id = publications.Publication_id
        INNER JOIN dbo.prices
          ON prices.Edition_id = editions.Edition_id
      WHERE prices.PriceEndDate IS NULL
      GROUP BY publications.pub_id WITH ROLLUP
      ORDER BY publications.pub_id;
  END;
GO
PRINT N'Creating [dbo].[SentenceFrom]'
GO
Create   function [dbo].[SentenceFrom] (
 @JsonData NVARCHAR(MAX), --the collection of objects, each one
 -- consisting of arrays of strings. If a word is prepended by  a 
 -- ^ character, it is the name of the object whose value is the array 
 -- of strings
 @Reference NVARCHAR(100), --the JSON reference to the object containing the
 -- list of strings to choose one item from.
 @level INT = 5--the depth of recursion allowed . 0 means don't recurse.
 ) 
/**
Summary: > 
   this function takes a json document that describes all the
   alternative components
   of a string and from it, it returns a string.
   basically, you give it a list of alternatives and it selects one of them. However
   if you put in the name of an array as one of the alternatives,rather than a word,
   it will, if it selects it, treat it as a new reference and will select one of 
   these alternatives.
Author: PhilFactor
Date: 05/11/2020
Database: PhilsScripts
Examples:
   - select dbo.SentenceFrom('{
     "name":[ "^prefix ^firstname ^lastname ^suffix",
	   "^prefix ^firstname ^lastname","^firstname ^lastname"
      ],
      "prefix":["Mr","Mrs","Miss","Sir","Dr","professor"
      ],
      "firstname":["Dick","Bob","Ravi","Jess","Karen"
      ],
      "lastname":["Stevens","Payne","Boyd","Sims","Brown"
      ],
      "suffix":["3rd","MA","BSc","","","","",""
      ]
    }
    ','$.name',5)
Returns: >
  a randomised string.
**/

RETURNS NVARCHAR(MAX)
AS
  BEGIN
    IF coalesce(@level,-1) < 0 RETURN 'too many levels'; /* if there is mutual 
references, this can potentially lead to a deadly embrace. This checks for that */
    IF IsJson(@JsonData) <> 0 --check that the data is valid
      BEGIN
        DECLARE @Choices TABLE ([KEY] INT, value NVARCHAR(MAX));
        DECLARE @words TABLE ([KEY] INT, value NVARCHAR(MAX));
        DECLARE @ii INT, @iiMax INT, @Output NVARCHAR(MAX);
        DECLARE @Endpunctuation VARCHAR(80); -- used to ensure we don't lose end punctuation
        DECLARE @SingleWord NVARCHAR(800), @ValidJsonList NVARCHAR(800);
		--we check for a missing or global reference and use the first object
        IF coalesce(@Reference,'$') = '$' 
		   SELECT top 1 @Reference = '$.'+[key] --just get the first
		     FROM OpenJson(@JSONData ,'$') where type=4;
        insert into @choices ([key],Value) --put the choices in a temp table
          SELECT [key],value FROM OpenJson(@JSONData ,@reference) where type=1
		-- if there was an easy way of getting the length of the array then we
		--could use JSON_VALUE ( expression , path ) to get the element   
        -- and get the chosen string
		DECLARE @string NVARCHAR(4000) =
           (SELECT TOP 1 value FROM @Choices 
		     CROSS JOIN RAN ORDER BY RAN.number);
        SELECT @ValidJsonList = N'["' + Replace(string_escape(@string,'json'), ' ', '","') + N'"]';
        IF IsJson(@ValidJsonList) = 0 RETURN N'invalid reference- '
                                             + @ValidJsonList;
        --now we examine each word in the string to see if it is reference
		--to another array within the JSON.
		INSERT INTO @words ([KEY], value)
		  SELECT [KEY], value
			FROM OpenJson( @ValidJsonList,'$');
        IF @@RowCount = 0 RETURN @ValidJsonList + ' returned no words';
        SELECT @ii = 0, @iiMax = Max([KEY]) FROM @words;
		-- we now loop through the words either treating the words as strings
		-- or symbols representing arrays
        WHILE (@ii < (@iiMax + 1))
          BEGIN
            SELECT @SingleWord = value FROM @words WHERE [KEY] = @ii;
            IF @@RowCount = 0
              BEGIN
                SELECT @Output =
                N'no words in' + N'["' + Replace(@string, ' ', '","') + N'"]';
                RETURN @Output;
              END;
            SELECT @ii = @ii + 1;
            IF Left(LTrim(@SingleWord), 1) = '^'-- it is a reference
              BEGIN -- nick out the '^' symbol
                SELECT @Reference = '$.' + Stuff(@SingleWord, 1, 1, ''),
                @Endpunctuation = '';
                WHILE Reverse(@Reference) LIKE '[:;.,-_()]%'
                  BEGIN --rescue any punctuation after the symbol
                    DECLARE @End INT = Len(@Reference);
                    SELECT @Endpunctuation = Substring(@Reference, @End, 1);
                    SELECT @Reference = Substring(@Reference, 1, @End - 1);
                  END; --and we call it recursively
                IF @level > 0
                  SELECT @Output =
                    Coalesce(@Output + ' ', '')
                    + dbo.SentenceFrom(@JsonData, @Reference, @level - 1)
                    + @Endpunctuation;
              END;
            -- otherwise it is plain sailing. Would that it were always
			-- that simple
            ELSE SELECT @Output = Coalesce(@Output + ' ', '') + @SingleWord;
          END;
      END;
    ELSE SELECT @Output = 'sorry. Error in the JSON';
    RETURN @Output; --and return whatever (it could be a novel!)
  END;
GO
PRINT N'Creating [dbo].[SplitStringToWords]'
GO
CREATE FUNCTION [dbo].[SplitStringToWords] (@TheString NVARCHAR(MAX))
/**
Summary: >
  This table function takes a string of text and splits it into words. It
  takes the approach of identifying spaces between words so as to accomodate
  other character sets
Author: Phil Factor
Date: 27/05/2021
Revised: 28/10/2021
Examples:
   - SELECT * FROM dbo.SplitStringToWords 
         ('This, (I think), might be working')
   - SELECT * FROM dbo.SplitStringToWords('This, 
        must -I assume - deal with <brackets> ')
Returns: >
  a table of the words and their order in the text.
**/
RETURNS @Words TABLE ([TheOrder] INT IDENTITY, TheWord NVARCHAR(50) NOT NULL)
AS
  BEGIN
    DECLARE @StartWildcard VARCHAR(80), @EndWildcard VARCHAR(80), @Max INT,
      @start INT, @end INT, @Searched INT, @ii INT;
    SELECT @TheString=@TheString+' !',
		   @StartWildcard = '%[^'+Char(1)+'-'+Char(64)+'\-`<>{}|~]%', 
	       @EndWildcard   = '%[^1-9A-Z''-]%', 
           @Max = Len (@TheString), @Searched = 0, 
		   @end = -1, @Start = -2, @ii = 1
	  WHILE (@end <> 0 AND @start<>0 AND @end<>@start AND @ii<1000)
      BEGIN
        SELECT @start =
        PatIndex (@StartWildcard, Right(@TheString, @Max - @Searched) 
		  COLLATE Latin1_General_CI_AI )
        SELECT @end =
        @start
        + PatIndex (
                   @EndWildcard, Right(@TheString, @Max - @Searched - @start) 
				     COLLATE Latin1_General_CI_AI
                   );
        IF @end > 0 AND @start > 0 AND @end<>@start
          BEGIN
-- SQL Prompt formatting off
		  INSERT INTO @Words(TheWord) 
		    SELECT Substring(@THeString,@searched+@Start,@end-@start)
			-- to force an error try commenting out the line above
			-- and uncommenting this next line below
			--SELECT Substring(@THeString,@searched+@Start+1,@end-@start)
			--to make the tests fail
		  END
-- SQL Prompt formatting on
        SELECT @Searched = @Searched + @end, @ii = @ii + 1;
      END;
    RETURN;
  END;
GO
PRINT N'Adding constraints to [dbo].[authors]'
GO
ALTER TABLE [dbo].[authors] ADD CONSTRAINT [CK__authors__au_id] CHECK (([au_id] like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[authors] ADD CONSTRAINT [CK__authors__zip] CHECK (([zip] like '[0-9][0-9][0-9][0-9][0-9]'))
GO
PRINT N'Adding constraints to [dbo].[employee]'
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [CK_emp_id] CHECK (([emp_id] like '[A-Z][A-Z][A-Z][1-9][0-9][0-9][0-9][0-9][FM]' OR [emp_id] like '[A-Z]-[A-Z][1-9][0-9][0-9][0-9][0-9][FM]'))
GO
PRINT N'Adding constraints to [dbo].[jobs]'
GO
ALTER TABLE [dbo].[jobs] ADD CONSTRAINT [CK__jobs__min_lvl] CHECK (([min_lvl]>=(10)))
GO
ALTER TABLE [dbo].[jobs] ADD CONSTRAINT [CK__jobs__max_lvl] CHECK (([max_lvl]<=(250)))
GO
PRINT N'Adding constraints to [dbo].[publishers]'
GO
ALTER TABLE [dbo].[publishers] ADD CONSTRAINT [CK__publisher__pub_id] CHECK (([pub_id]='1756' OR [pub_id]='1622' OR [pub_id]='0877' OR [pub_id]='0736' OR [pub_id]='1389' OR [pub_id] like '99[0-9][0-9]'))
GO
PRINT N'Adding constraints to [people].[Address]'
GO
ALTER TABLE [people].[Address] ADD CONSTRAINT [Address_Not_Complete] CHECK ((coalesce([AddressLine1],[AddressLine2],[City],[PostalCode]) IS NOT NULL))
GO
PRINT N'Adding foreign keys to [accounting].[Bill_Lines]'
GO
ALTER TABLE [accounting].[Bill_Lines] ADD CONSTRAINT [FK__Bill_Line__bill___2799C73C] FOREIGN KEY ([bill_id]) REFERENCES [accounting].[Bills] ([id])
GO
ALTER TABLE [accounting].[Bill_Lines] ADD CONSTRAINT [FK__Bill_Line__line___288DEB75] FOREIGN KEY ([line_Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
PRINT N'Adding foreign keys to [accounting].[Bills]'
GO
ALTER TABLE [accounting].[Bills] ADD CONSTRAINT [FK__Bills__bill_paym__2C5E7C59] FOREIGN KEY ([bill_payment_id]) REFERENCES [accounting].[Bill_Payments] ([id])
GO
ALTER TABLE [accounting].[Bills] ADD CONSTRAINT [FK__Bills__supplier___2B6A5820] FOREIGN KEY ([supplier_id]) REFERENCES [accounting].[Suppliers] ([id])
GO
ALTER TABLE [accounting].[Bills] ADD CONSTRAINT [FK__Bills__Chart_of___2A7633E7] FOREIGN KEY ([Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
PRINT N'Adding foreign keys to [accounting].[Bill_Payments]'
GO
ALTER TABLE [accounting].[Bill_Payments] ADD CONSTRAINT [FK__Bill_Paym__Chart__29820FAE] FOREIGN KEY ([Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
PRINT N'Adding foreign keys to [accounting].[Invoice_Lines]'
GO
ALTER TABLE [accounting].[Invoice_Lines] ADD CONSTRAINT [FK__Invoice_L__line___2F3AE904] FOREIGN KEY ([line_Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
ALTER TABLE [accounting].[Invoice_Lines] ADD CONSTRAINT [FK__Invoice_L__invoi__302F0D3D] FOREIGN KEY ([invoice_id]) REFERENCES [accounting].[Invoices] ([id])
GO
PRINT N'Adding foreign keys to [accounting].[Invoice_Payments]'
GO
ALTER TABLE [accounting].[Invoice_Payments] ADD CONSTRAINT [FK__Invoice_P__Chart__31233176] FOREIGN KEY ([Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
PRINT N'Adding foreign keys to [accounting].[Invoices]'
GO
ALTER TABLE [accounting].[Invoices] ADD CONSTRAINT [FK__Invoices__Chart___33FF9E21] FOREIGN KEY ([Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
ALTER TABLE [accounting].[Invoices] ADD CONSTRAINT [FK__Invoices__invoic__330B79E8] FOREIGN KEY ([invoice_payment_id]) REFERENCES [accounting].[Invoice_Payments] ([id])
GO
ALTER TABLE [accounting].[Invoices] ADD CONSTRAINT [FK__Invoices__custom__321755AF] FOREIGN KEY ([customer_id]) REFERENCES [accounting].[customer] ([id])
GO
PRINT N'Adding foreign keys to [accounting].[Received_Moneys]'
GO
ALTER TABLE [accounting].[Received_Moneys] ADD CONSTRAINT [FK__Received___Chart__37D02F05] FOREIGN KEY ([Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
ALTER TABLE [accounting].[Received_Moneys] ADD CONSTRAINT [FK__Received___custo__36DC0ACC] FOREIGN KEY ([customer_id]) REFERENCES [accounting].[customer] ([id])
GO
PRINT N'Adding foreign keys to [accounting].[Received_Money_Lines]'
GO
ALTER TABLE [accounting].[Received_Money_Lines] ADD CONSTRAINT [FK__Received___line___35E7E693] FOREIGN KEY ([line_Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
ALTER TABLE [accounting].[Received_Money_Lines] ADD CONSTRAINT [FK__Received___recei__34F3C25A] FOREIGN KEY ([received_money_id]) REFERENCES [accounting].[Received_Moneys] ([id])
GO
PRINT N'Adding foreign keys to [accounting].[Spent_Moneys]'
GO
ALTER TABLE [accounting].[Spent_Moneys] ADD CONSTRAINT [FK__Spent_Mon__Chart__3AAC9BB0] FOREIGN KEY ([Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
ALTER TABLE [accounting].[Spent_Moneys] ADD CONSTRAINT [FK__Spent_Mon__suppl__3BA0BFE9] FOREIGN KEY ([supplier_id]) REFERENCES [accounting].[Suppliers] ([id])
GO
PRINT N'Adding foreign keys to [accounting].[Spent_Money_Lines]'
GO
ALTER TABLE [accounting].[Spent_Money_Lines] ADD CONSTRAINT [FK__Spent_Mon__line___39B87777] FOREIGN KEY ([line_Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
ALTER TABLE [accounting].[Spent_Money_Lines] ADD CONSTRAINT [FK__Spent_Mon__spent__38C4533E] FOREIGN KEY ([spent_money_id]) REFERENCES [accounting].[Spent_Moneys] ([id])
GO
PRINT N'Adding foreign keys to [accounting].[Suppliers]'
GO
ALTER TABLE [accounting].[Suppliers] ADD CONSTRAINT [FK_supplier_id_organisation_id] FOREIGN KEY ([supplier_id]) REFERENCES [people].[Organisation] ([organisation_ID])
GO
ALTER TABLE [accounting].[Suppliers] ADD CONSTRAINT [FK_contact_id_organisation_id] FOREIGN KEY ([contact_id]) REFERENCES [people].[Organisation] ([organisation_ID])
GO
PRINT N'Adding foreign keys to [accounting].[customer]'
GO
ALTER TABLE [accounting].[customer] ADD CONSTRAINT [FK_person_id_Person_id] FOREIGN KEY ([person_id]) REFERENCES [people].[Person] ([person_ID])
GO
ALTER TABLE [accounting].[customer] ADD CONSTRAINT [FK_organisation_id_organisation_id] FOREIGN KEY ([organisation_id]) REFERENCES [people].[Organisation] ([organisation_ID])
GO
PRINT N'Adding foreign keys to [dbo].[editions]'
GO
ALTER TABLE [dbo].[editions] ADD CONSTRAINT [fk_Publication_Type] FOREIGN KEY ([Publication_type]) REFERENCES [dbo].[Publication_Types] ([Publication_Type])
GO
ALTER TABLE [dbo].[editions] ADD CONSTRAINT [fk_edition] FOREIGN KEY ([publication_id]) REFERENCES [dbo].[publications] ([Publication_id])
GO
PRINT N'Adding foreign keys to [dbo].[TagTitle]'
GO
ALTER TABLE [dbo].[TagTitle] ADD CONSTRAINT [fkTagname] FOREIGN KEY ([TagName_ID]) REFERENCES [dbo].[TagName] ([TagName_ID])
GO
ALTER TABLE [dbo].[TagTitle] ADD CONSTRAINT [FKTitle_id] FOREIGN KEY ([title_id]) REFERENCES [dbo].[publications] ([Publication_id])
GO
PRINT N'Adding foreign keys to [dbo].[titleauthor]'
GO
ALTER TABLE [dbo].[titleauthor] ADD CONSTRAINT [FK__titleauth__au_id] FOREIGN KEY ([au_id]) REFERENCES [dbo].[authors] ([au_id])
GO
ALTER TABLE [dbo].[titleauthor] ADD CONSTRAINT [FK__titleauth__title] FOREIGN KEY ([title_id]) REFERENCES [dbo].[publications] ([Publication_id]) ON DELETE CASCADE
GO
PRINT N'Adding foreign keys to [dbo].[discounts]'
GO
ALTER TABLE [dbo].[discounts] ADD CONSTRAINT [FK__discounts__store] FOREIGN KEY ([stor_id]) REFERENCES [dbo].[stores] ([stor_id])
GO
PRINT N'Adding foreign keys to [dbo].[prices]'
GO
ALTER TABLE [dbo].[prices] ADD CONSTRAINT [fk_prices] FOREIGN KEY ([Edition_id]) REFERENCES [dbo].[editions] ([Edition_id])
GO
PRINT N'Adding foreign keys to [dbo].[employee]'
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [FK__employee__job_id] FOREIGN KEY ([job_id]) REFERENCES [dbo].[jobs] ([job_id])
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [FK__employee__pub_id] FOREIGN KEY ([pub_id]) REFERENCES [dbo].[publishers] ([pub_id])
GO
PRINT N'Adding foreign keys to [dbo].[pub_info]'
GO
ALTER TABLE [dbo].[pub_info] ADD CONSTRAINT [FK__pub_info__pub_id] FOREIGN KEY ([pub_id]) REFERENCES [dbo].[publishers] ([pub_id])
GO
PRINT N'Adding foreign keys to [dbo].[roysched]'
GO
ALTER TABLE [dbo].[roysched] ADD CONSTRAINT [FK__roysched__title] FOREIGN KEY ([title_id]) REFERENCES [dbo].[publications] ([Publication_id]) ON DELETE CASCADE
GO
PRINT N'Adding foreign keys to [dbo].[sales]'
GO
ALTER TABLE [dbo].[sales] ADD CONSTRAINT [FK_Sales_Title] FOREIGN KEY ([title_id]) REFERENCES [dbo].[publications] ([Publication_id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[sales] ADD CONSTRAINT [FK_Sales_Stores] FOREIGN KEY ([stor_id]) REFERENCES [dbo].[stores] ([stor_id])
GO
PRINT N'Adding foreign keys to [dbo].[publications]'
GO
ALTER TABLE [dbo].[publications] ADD CONSTRAINT [fkPublishers] FOREIGN KEY ([pub_id]) REFERENCES [dbo].[publishers] ([pub_id])
GO
PRINT N'Adding foreign keys to [people].[Abode]'
GO
ALTER TABLE [people].[Abode] ADD CONSTRAINT [Abode_PersonFK] FOREIGN KEY ([Person_id]) REFERENCES [people].[Person] ([person_ID])
GO
ALTER TABLE [people].[Abode] ADD CONSTRAINT [Abode_AddressFK] FOREIGN KEY ([Address_id]) REFERENCES [people].[Address] ([Address_ID])
GO
ALTER TABLE [people].[Abode] ADD CONSTRAINT [Abode_AddressTypeFK] FOREIGN KEY ([TypeOfAddress]) REFERENCES [people].[AddressType] ([TypeOfAddress])
GO
PRINT N'Adding foreign keys to [people].[Location]'
GO
ALTER TABLE [people].[Location] ADD CONSTRAINT [Location_AddressTypeFK] FOREIGN KEY ([TypeOfAddress]) REFERENCES [people].[AddressType] ([TypeOfAddress])
GO
ALTER TABLE [people].[Location] ADD CONSTRAINT [Location_AddressFK] FOREIGN KEY ([Address_id]) REFERENCES [people].[Address] ([Address_ID])
GO
ALTER TABLE [people].[Location] ADD CONSTRAINT [Location_organisationFK] FOREIGN KEY ([organisation_id]) REFERENCES [people].[Organisation] ([organisation_ID])
GO
PRINT N'Adding foreign keys to [people].[CreditCard]'
GO
ALTER TABLE [people].[CreditCard] ADD CONSTRAINT [CreditCard_PersonFK] FOREIGN KEY ([Person_id]) REFERENCES [people].[Person] ([person_ID])
GO
PRINT N'Adding foreign keys to [people].[EmailAddress]'
GO
ALTER TABLE [people].[EmailAddress] ADD CONSTRAINT [EmailAddress_PersonFK] FOREIGN KEY ([Person_id]) REFERENCES [people].[Person] ([person_ID])
GO
PRINT N'Adding foreign keys to [people].[NotePerson]'
GO
ALTER TABLE [people].[NotePerson] ADD CONSTRAINT [NotePerson_PersonFK] FOREIGN KEY ([Person_id]) REFERENCES [people].[Person] ([person_ID])
GO
ALTER TABLE [people].[NotePerson] ADD CONSTRAINT [NotePerson_NoteFK] FOREIGN KEY ([Note_id]) REFERENCES [people].[Note] ([Note_id])
GO
PRINT N'Adding foreign keys to [people].[Phone]'
GO
ALTER TABLE [people].[Phone] ADD CONSTRAINT [Phone_PersonFK] FOREIGN KEY ([Person_id]) REFERENCES [people].[Person] ([person_ID])
GO
ALTER TABLE [people].[Phone] ADD CONSTRAINT [FK__Phone__TypeOfPho__6A90B8FC] FOREIGN KEY ([TypeOfPhone]) REFERENCES [people].[PhoneType] ([TypeOfPhone])
GO
PRINT N'Adding foreign keys to [people].[WordOccurence]'
GO
ALTER TABLE [people].[WordOccurence] ADD CONSTRAINT [FKWordOccurenceWord] FOREIGN KEY ([Item]) REFERENCES [people].[Word] ([Item])
GO
PRINT N'Creating extended properties'
GO
EXEC sp_addextendedproperty N'MS_Description', N'this is the joining table between Bills and COA. An account may appear in multiple bills and a bill may have multiple accounts.', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Lines', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Lines', 'COLUMN', N'bill_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Lines', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Lines', 'COLUMN', N'line_amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Lines', 'COLUMN', N'line_Chart_of_Accounts_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'payments of the outstanding Bills. there’s a one-to-many relationship between Bill_Payments and Bills respectively', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Payments', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Payments', 'COLUMN', N'Chart_of_Accounts_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Payments', 'COLUMN', N'description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Payments', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Payments', 'COLUMN', N'reference'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Payments', 'COLUMN', N'total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Payments', 'COLUMN', N'tran_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'bill_payment_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'Chart_of_Accounts_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'due_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'reference'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'supplier_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'tran_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Chart_of_Accounts', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Chart_of_Accounts', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Chart_of_Accounts', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'joining table between Invoices and COA. An account may appear in multiple invoices and an invoice may have multiple accounts.', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Lines', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Lines', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Lines', 'COLUMN', N'invoice_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Lines', 'COLUMN', N'line_amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Lines', 'COLUMN', N'line_Chart_of_Accounts_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'one-to-many relationship between Invoice_Payments and Invoices respectively (no partial payments)', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Payments', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Payments', 'COLUMN', N'Chart_of_Accounts_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Payments', 'COLUMN', N'description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Payments', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Payments', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Payments', 'COLUMN', N'reference'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Payments', 'COLUMN', N'total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Payments', 'COLUMN', N'tran_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'Chart_of_Accounts_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'customer_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'due_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'invoice_payment_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'reference'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'tran_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'this is the joining table between Received_Moneys and COA', 'SCHEMA', N'accounting', 'TABLE', N'Received_Money_Lines', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Money_Lines', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Money_Lines', 'COLUMN', N'line_amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Money_Lines', 'COLUMN', N'line_Chart_of_Accounts_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Money_Lines', 'COLUMN', N'received_money_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'may have an optional Customer', 'SCHEMA', N'accounting', 'TABLE', N'Received_Moneys', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Moneys', 'COLUMN', N'Chart_of_Accounts_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Moneys', 'COLUMN', N'customer_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Moneys', 'COLUMN', N'description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Moneys', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Moneys', 'COLUMN', N'reference'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Moneys', 'COLUMN', N'total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Moneys', 'COLUMN', N'tran_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'this is the joining table between Spent_Moneys and COA', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Money_Lines', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Money_Lines', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Money_Lines', 'COLUMN', N'line_amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Money_Lines', 'COLUMN', N'line_Chart_of_Accounts_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Money_Lines', 'COLUMN', N'spent_money_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'cash disbursements that are not bill payments. This may involve cash purchases but if you’re going to issue a bill, use the Bills feature', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Moneys', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Moneys', 'COLUMN', N'Chart_of_Accounts_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Moneys', 'COLUMN', N'description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Moneys', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Moneys', 'COLUMN', N'reference'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Moneys', 'COLUMN', N'supplier_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Moneys', 'COLUMN', N'total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Moneys', 'COLUMN', N'tran_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'a supplier can have many bills but a bill can’t belong to many suppliers', 'SCHEMA', N'accounting', 'TABLE', N'Suppliers', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Suppliers', 'COLUMN', N'contact_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Suppliers', 'COLUMN', N'CustomerFrom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Suppliers', 'COLUMN', N'CustomerTo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Suppliers', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Suppliers', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Suppliers', 'COLUMN', N'supplier_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'a customer can have many invoices but an invoice can’t belong to many customers', 'SCHEMA', N'accounting', 'TABLE', N'customer', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'customer', 'COLUMN', N'CustomerFrom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'customer', 'COLUMN', N'CustomerTo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'customer', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'customer', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'customer', 'COLUMN', N'organisation_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'customer', 'COLUMN', N'person_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'An edition can be one of several types', 'SCHEMA', N'dbo', 'TABLE', N'Publication_Types', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'Publication_Types', 'COLUMN', N'Publication_Type'
GO
EXEC sp_addextendedproperty N'MS_Description', N'All the categories of publications', 'SCHEMA', N'dbo', 'TABLE', N'TagName', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the name of the tag', 'SCHEMA', N'dbo', 'TABLE', N'TagName', 'COLUMN', N'Tag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the Tag Table', 'SCHEMA', N'dbo', 'TABLE', N'TagName', 'COLUMN', N'TagName_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This relates tags (e.g. crime) to publications so that publications can have more than one', 'SCHEMA', N'dbo', 'TABLE', N'TagTitle', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'is this the primary tag (e.g. ''Fiction'')', 'SCHEMA', N'dbo', 'TABLE', N'TagTitle', 'COLUMN', N'Is_Primary'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The foreign key to the tagname', 'SCHEMA', N'dbo', 'TABLE', N'TagTitle', 'COLUMN', N'TagName_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the TagTitle Table', 'SCHEMA', N'dbo', 'TABLE', N'TagTitle', 'COLUMN', N'TagTitle_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The foreign key to the title', 'SCHEMA', N'dbo', 'TABLE', N'TagTitle', 'COLUMN', N'title_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The authors of the publications. a publication can have one or more author', 'SCHEMA', N'dbo', 'TABLE', N'authors', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the author=s firest line address', 'SCHEMA', N'dbo', 'TABLE', N'authors', 'COLUMN', N'address'
GO
EXEC sp_addextendedproperty N'MS_Description', N'first name of the author', 'SCHEMA', N'dbo', 'TABLE', N'authors', 'COLUMN', N'au_fname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The key to the Authors Table', 'SCHEMA', N'dbo', 'TABLE', N'authors', 'COLUMN', N'au_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'last name of the author', 'SCHEMA', N'dbo', 'TABLE', N'authors', 'COLUMN', N'au_lname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the city where the author lives', 'SCHEMA', N'dbo', 'TABLE', N'authors', 'COLUMN', N'city'
GO
EXEC sp_addextendedproperty N'MS_Description', N'had the author agreed a contract?', 'SCHEMA', N'dbo', 'TABLE', N'authors', 'COLUMN', N'contract'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the author''s phone number', 'SCHEMA', N'dbo', 'TABLE', N'authors', 'COLUMN', N'phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the state where the author lives', 'SCHEMA', N'dbo', 'TABLE', N'authors', 'COLUMN', N'state'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the zip of the address where the author lives', 'SCHEMA', N'dbo', 'TABLE', N'authors', 'COLUMN', N'zip'
GO
EXEC sp_addextendedproperty N'MS_Description', N'These are the discounts offered by the sales people for bulk orders', 'SCHEMA', N'dbo', 'TABLE', N'discounts', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the percentage discount', 'SCHEMA', N'dbo', 'TABLE', N'discounts', 'COLUMN', N'discount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the Discounts Table', 'SCHEMA', N'dbo', 'TABLE', N'discounts', 'COLUMN', N'Discount_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The type of discount', 'SCHEMA', N'dbo', 'TABLE', N'discounts', 'COLUMN', N'discounttype'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The highest order quantity for which the discount applies', 'SCHEMA', N'dbo', 'TABLE', N'discounts', 'COLUMN', N'highqty'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The lowest order quantity for which the discount applies', 'SCHEMA', N'dbo', 'TABLE', N'discounts', 'COLUMN', N'lowqty'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The store that has the discount', 'SCHEMA', N'dbo', 'TABLE', N'discounts', 'COLUMN', N'stor_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A publication can come out in several different editions, of maybe a different type', 'SCHEMA', N'dbo', 'TABLE', N'editions', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the Editions Table', 'SCHEMA', N'dbo', 'TABLE', N'editions', 'COLUMN', N'Edition_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the date at which this edition was created', 'SCHEMA', N'dbo', 'TABLE', N'editions', 'COLUMN', N'EditionDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the foreign key to the publication', 'SCHEMA', N'dbo', 'TABLE', N'editions', 'COLUMN', N'publication_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the type of publication', 'SCHEMA', N'dbo', 'TABLE', N'editions', 'COLUMN', N'Publication_type'
GO
EXEC sp_addextendedproperty N'MS_Description', N'An employee of any of the publishers', 'SCHEMA', N'dbo', 'TABLE', N'employee', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The key to the Employee Table', 'SCHEMA', N'dbo', 'TABLE', N'employee', 'COLUMN', N'emp_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'first name', 'SCHEMA', N'dbo', 'TABLE', N'employee', 'COLUMN', N'fname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the date that the employeee was hired', 'SCHEMA', N'dbo', 'TABLE', N'employee', 'COLUMN', N'hire_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the job that the employee does', 'SCHEMA', N'dbo', 'TABLE', N'employee', 'COLUMN', N'job_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the job level', 'SCHEMA', N'dbo', 'TABLE', N'employee', 'COLUMN', N'job_lvl'
GO
EXEC sp_addextendedproperty N'MS_Description', N'last name', 'SCHEMA', N'dbo', 'TABLE', N'employee', 'COLUMN', N'lname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'middle initial', 'SCHEMA', N'dbo', 'TABLE', N'employee', 'COLUMN', N'minit'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the publisher that the employee works for', 'SCHEMA', N'dbo', 'TABLE', N'employee', 'COLUMN', N'pub_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'These are the job descriptions and min/max salary level', 'SCHEMA', N'dbo', 'TABLE', N'jobs', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The description of the job', 'SCHEMA', N'dbo', 'TABLE', N'jobs', 'COLUMN', N'job_desc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the Jobs Table', 'SCHEMA', N'dbo', 'TABLE', N'jobs', 'COLUMN', N'job_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the maximum pay level appropriate for the job', 'SCHEMA', N'dbo', 'TABLE', N'jobs', 'COLUMN', N'max_lvl'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the minimum pay level appropriate for the job', 'SCHEMA', N'dbo', 'TABLE', N'jobs', 'COLUMN', N'min_lvl'
GO
EXEC sp_addextendedproperty N'MS_Description', N'these are the current prices of every edition of every publication', 'SCHEMA', N'dbo', 'TABLE', N'prices', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the advance to the authors', 'SCHEMA', N'dbo', 'TABLE', N'prices', 'COLUMN', N'advance'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The edition that this price applies to', 'SCHEMA', N'dbo', 'TABLE', N'prices', 'COLUMN', N'Edition_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the price in dollars', 'SCHEMA', N'dbo', 'TABLE', N'prices', 'COLUMN', N'price'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the Prices Table', 'SCHEMA', N'dbo', 'TABLE', N'prices', 'COLUMN', N'Price_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'null if the price is current, otherwise the date at which it was supoerceded', 'SCHEMA', N'dbo', 'TABLE', N'prices', 'COLUMN', N'PriceEndDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the start date for which this price applies', 'SCHEMA', N'dbo', 'TABLE', N'prices', 'COLUMN', N'PriceStartDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the royalty', 'SCHEMA', N'dbo', 'TABLE', N'prices', 'COLUMN', N'royalty'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the current sales this year', 'SCHEMA', N'dbo', 'TABLE', N'prices', 'COLUMN', N'ytd_sales'
GO
EXEC sp_addextendedproperty N'MS_Description', N'this holds the special information about every publisher', 'SCHEMA', N'dbo', 'TABLE', N'pub_info', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the publisher''s logo', 'SCHEMA', N'dbo', 'TABLE', N'pub_info', 'COLUMN', N'logo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The blurb of this publisher', 'SCHEMA', N'dbo', 'TABLE', N'pub_info', 'COLUMN', N'pr_info'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The foreign key to the publisher', 'SCHEMA', N'dbo', 'TABLE', N'pub_info', 'COLUMN', N'pub_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This lists every publication marketed by the distributor', 'SCHEMA', N'dbo', 'TABLE', N'publications', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'any notes about this publication', 'SCHEMA', N'dbo', 'TABLE', N'publications', 'COLUMN', N'notes'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the legacy publication key', 'SCHEMA', N'dbo', 'TABLE', N'publications', 'COLUMN', N'pub_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the date that it was published', 'SCHEMA', N'dbo', 'TABLE', N'publications', 'COLUMN', N'pubdate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the Publications Table', 'SCHEMA', N'dbo', 'TABLE', N'publications', 'COLUMN', N'Publication_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the title of the publicxation', 'SCHEMA', N'dbo', 'TABLE', N'publications', 'COLUMN', N'title'
GO
EXEC sp_addextendedproperty N'MS_Description', N'this is a table of publishers who we distribute books for', 'SCHEMA', N'dbo', 'TABLE', N'publishers', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the city where this publisher is based', 'SCHEMA', N'dbo', 'TABLE', N'publishers', 'COLUMN', N'city'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The country where this publisher is based', 'SCHEMA', N'dbo', 'TABLE', N'publishers', 'COLUMN', N'country'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the Publishers Table', 'SCHEMA', N'dbo', 'TABLE', N'publishers', 'COLUMN', N'pub_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name of the publisher', 'SCHEMA', N'dbo', 'TABLE', N'publishers', 'COLUMN', N'pub_name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Thge state where this publisher is based', 'SCHEMA', N'dbo', 'TABLE', N'publishers', 'COLUMN', N'state'
GO
EXEC sp_addextendedproperty N'MS_Description', N'this is a table of the authors royalty schedule', 'SCHEMA', N'dbo', 'TABLE', N'roysched', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the highest range to which this royalty applies', 'SCHEMA', N'dbo', 'TABLE', N'roysched', 'COLUMN', N'hirange'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the lowest range to which the royalty applies', 'SCHEMA', N'dbo', 'TABLE', N'roysched', 'COLUMN', N'lorange'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the royalty', 'SCHEMA', N'dbo', 'TABLE', N'roysched', 'COLUMN', N'royalty'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the RoySched Table', 'SCHEMA', N'dbo', 'TABLE', N'roysched', 'COLUMN', N'roysched_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The title to which this applies', 'SCHEMA', N'dbo', 'TABLE', N'roysched', 'COLUMN', N'title_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'these are the sales of every edition of every publication', 'SCHEMA', N'dbo', 'TABLE', N'sales', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the date of the order', 'SCHEMA', N'dbo', 'TABLE', N'sales', 'COLUMN', N'ord_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the reference to the order', 'SCHEMA', N'dbo', 'TABLE', N'sales', 'COLUMN', N'ord_num'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the pay terms', 'SCHEMA', N'dbo', 'TABLE', N'sales', 'COLUMN', N'payterms'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the quantity ordered', 'SCHEMA', N'dbo', 'TABLE', N'sales', 'COLUMN', N'qty'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The store for which the sales apply', 'SCHEMA', N'dbo', 'TABLE', N'sales', 'COLUMN', N'stor_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'foreign key to the title', 'SCHEMA', N'dbo', 'TABLE', N'sales', 'COLUMN', N'title_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'these are all the stores who are our customers', 'SCHEMA', N'dbo', 'TABLE', N'stores', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The city in which the store is based', 'SCHEMA', N'dbo', 'TABLE', N'stores', 'COLUMN', N'city'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The state where the store is base', 'SCHEMA', N'dbo', 'TABLE', N'stores', 'COLUMN', N'state'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The first-line address of the store', 'SCHEMA', N'dbo', 'TABLE', N'stores', 'COLUMN', N'stor_address'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The primary key to the Store Table', 'SCHEMA', N'dbo', 'TABLE', N'stores', 'COLUMN', N'stor_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name of the store', 'SCHEMA', N'dbo', 'TABLE', N'stores', 'COLUMN', N'stor_name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The zipt code for the store', 'SCHEMA', N'dbo', 'TABLE', N'stores', 'COLUMN', N'zip'
GO
EXEC sp_addextendedproperty N'MS_Description', N'this is a table that relates authors to publications, and gives their order of listing and royalty', 'SCHEMA', N'dbo', 'TABLE', N'titleauthor', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key to the author', 'SCHEMA', N'dbo', 'TABLE', N'titleauthor', 'COLUMN', N'au_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N' the order in which authors are listed', 'SCHEMA', N'dbo', 'TABLE', N'titleauthor', 'COLUMN', N'au_ord'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the royalty percentage figure', 'SCHEMA', N'dbo', 'TABLE', N'titleauthor', 'COLUMN', N'royaltyper'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key to the publication', 'SCHEMA', N'dbo', 'TABLE', N'titleauthor', 'COLUMN', N'title_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N' an abode describes the association has with an address and the period of time when the person had that association', 'SCHEMA', N'people', 'TABLE', N'Abode', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the surrogate key for the place to which the person is associated', 'SCHEMA', N'people', 'TABLE', N'Abode', 'COLUMN', N'Abode_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the id of the address', 'SCHEMA', N'people', 'TABLE', N'Abode', 'COLUMN', N'Address_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when this relationship ended', 'SCHEMA', N'people', 'TABLE', N'Abode', 'COLUMN', N'End_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when this record was last modified', 'SCHEMA', N'people', 'TABLE', N'Abode', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the id of the person', 'SCHEMA', N'people', 'TABLE', N'Abode', 'COLUMN', N'Person_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when this relationship started ', 'SCHEMA', N'people', 'TABLE', N'Abode', 'COLUMN', N'Start_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the type of address', 'SCHEMA', N'people', 'TABLE', N'Abode', 'COLUMN', N'TypeOfAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N' the way that a particular customer is using the address (e.g. Home, Office, hotel etc ', 'SCHEMA', N'people', 'TABLE', N'AddressType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'when was this record LAST modified', 'SCHEMA', N'people', 'TABLE', N'AddressType', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'description of the type of address', 'SCHEMA', N'people', 'TABLE', N'AddressType', 'COLUMN', N'TypeOfAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This contains the details of an addresss,
any address, it can be a home, office, factory or whatever ', 'SCHEMA', N'people', 'TABLE', N'Address', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'surrogate key ', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'Address_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'first line address', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'AddressLine1'
GO
EXEC sp_addextendedproperty N'MS_Description', N' second line address ', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'AddressLine2'
GO
EXEC sp_addextendedproperty N'MS_Description', N' the city ', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'country'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A calculated column', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'Full_Address'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'LegacyIdentifier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when the record was last modified', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'PostalCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'Region'
GO
EXEC sp_addextendedproperty N'MS_Description', N' the customer''s credit card details. This is here just because this database is used as a nursery slope to check for personal information ', 'SCHEMA', N'people', 'TABLE', N'CreditCard', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The actual card-number', 'SCHEMA', N'people', 'TABLE', N'CreditCard', 'COLUMN', N'CardNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Surrogate primary key for the Credit card', 'SCHEMA', N'people', 'TABLE', N'CreditCard', 'COLUMN', N'CreditCardID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the CVC', 'SCHEMA', N'people', 'TABLE', N'CreditCard', 'COLUMN', N'CVC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when was this last modified', 'SCHEMA', N'people', 'TABLE', N'CreditCard', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'foreign key to the person who has the addess', 'SCHEMA', N'people', 'TABLE', N'CreditCard', 'COLUMN', N'Person_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'from when the credit card was valid', 'SCHEMA', N'people', 'TABLE', N'CreditCard', 'COLUMN', N'ValidFrom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'to when the credit card was valid', 'SCHEMA', N'people', 'TABLE', N'CreditCard', 'COLUMN', N'ValidTo'
GO
EXEC sp_addextendedproperty N'MS_Description', N' the email address for the person. a person can have more than one ', 'SCHEMA', N'people', 'TABLE', N'EmailAddress', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the actual email address', 'SCHEMA', N'people', 'TABLE', N'EmailAddress', 'COLUMN', N'EmailAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Surrogate key for the email', 'SCHEMA', N'people', 'TABLE', N'EmailAddress', 'COLUMN', N'EmailID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when the customer stopped using this address', 'SCHEMA', N'people', 'TABLE', N'EmailAddress', 'COLUMN', N'EndDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When the email address got modified', 'SCHEMA', N'people', 'TABLE', N'EmailAddress', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'foreign key to the person who has the addess', 'SCHEMA', N'people', 'TABLE', N'EmailAddress', 'COLUMN', N'Person_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when the customer started using this address', 'SCHEMA', N'people', 'TABLE', N'EmailAddress', 'COLUMN', N'StartDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Location', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Location', 'COLUMN', N'Address_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Location', 'COLUMN', N'End_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Location', 'COLUMN', N'Location_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Location', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Location', 'COLUMN', N'organisation_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Location', 'COLUMN', N'Start_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Location', 'COLUMN', N'TypeOfAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N' relates a note to a person ', 'SCHEMA', N'people', 'TABLE', N'NotePerson', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N' whan the note was inserted ', 'SCHEMA', N'people', 'TABLE', N'NotePerson', 'COLUMN', N'InsertionDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N' whan the association of note with person was last modified ', 'SCHEMA', N'people', 'TABLE', N'NotePerson', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'foreign key to the actual note', 'SCHEMA', N'people', 'TABLE', N'NotePerson', 'COLUMN', N'Note_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Surrogate primary key for the link table', 'SCHEMA', N'people', 'TABLE', N'NotePerson', 'COLUMN', N'NotePerson_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'foreign key to the person who has the addess', 'SCHEMA', N'people', 'TABLE', N'NotePerson', 'COLUMN', N'Person_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N' a note relating to a customer ', 'SCHEMA', N'people', 'TABLE', N'Note', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Who inserted the note', 'SCHEMA', N'people', 'TABLE', N'Note', 'COLUMN', N'InsertedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when the note was inserted', 'SCHEMA', N'people', 'TABLE', N'Note', 'COLUMN', N'InsertionDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when the note  got changed', 'SCHEMA', N'people', 'TABLE', N'Note', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The actual text of the note', 'SCHEMA', N'people', 'TABLE', N'Note', 'COLUMN', N'Note'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Surrogate primary key for the Note', 'SCHEMA', N'people', 'TABLE', N'Note', 'COLUMN', N'Note_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'making it easier to search ...CONSTRAINT NoteStartUQ UNIQUE,', 'SCHEMA', N'people', 'TABLE', N'Note', 'COLUMN', N'NoteStart'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Organisation', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Organisation', 'COLUMN', N'LegacyIdentifier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Organisation', 'COLUMN', N'LineOfBusiness'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Organisation', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Organisation', 'COLUMN', N'organisation_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Organisation', 'COLUMN', N'OrganisationName'
GO
EXEC sp_addextendedproperty N'MS_Description', N' This table represents a person- can be a customer or a member of staff,or someone in one of the outsourced support agencies', 'SCHEMA', N'people', 'TABLE', N'Person', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N' the person''s first name', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'FirstName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A calculated column', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'fullName'
GO
EXEC sp_addextendedproperty N'MS_Description', N' the lastname or surname ', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'LastName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'LegacyIdentifier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'any middle name ', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'MiddleName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when the record was last modified', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N' the way the person is usually addressed', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'Nickname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'person_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'any suffix used by the person', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'Suffix'
GO
EXEC sp_addextendedproperty N'MS_Description', N' the title (Mr, Mrs, Ms etc', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'Title'
GO
EXEC sp_addextendedproperty N'MS_Description', N' the description of the type of the phone (e.g. Mobile, Home, work) ', 'SCHEMA', N'people', 'TABLE', N'PhoneType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'when this record was last modified', 'SCHEMA', N'people', 'TABLE', N'PhoneType', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'a description of the type of phone', 'SCHEMA', N'people', 'TABLE', N'PhoneType', 'COLUMN', N'TypeOfPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N' the actual phone number, and relates it to the person and the type of phone ', 'SCHEMA', N'people', 'TABLE', N'Phone', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the actual dialling number ', 'SCHEMA', N'people', 'TABLE', N'Phone', 'COLUMN', N'DiallingNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N' if not null, when the person stopped using the number', 'SCHEMA', N'people', 'TABLE', N'Phone', 'COLUMN', N'End_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when the record was last modified', 'SCHEMA', N'people', 'TABLE', N'Phone', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the person who has the phone number', 'SCHEMA', N'people', 'TABLE', N'Phone', 'COLUMN', N'Person_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the surrogate key for the phone', 'SCHEMA', N'people', 'TABLE', N'Phone', 'COLUMN', N'Phone_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N' when we first knew thet the person was using the number', 'SCHEMA', N'people', 'TABLE', N'Phone', 'COLUMN', N'Start_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the type of phone', 'SCHEMA', N'people', 'TABLE', N'Phone', 'COLUMN', N'TypeOfPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Whereabouts the word was found in the text fiels within a table', 'SCHEMA', N'people', 'TABLE', N'WordOccurence', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'WordOccurence', 'COLUMN', N'Item'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'WordOccurence', 'COLUMN', N'location'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'WordOccurence', 'COLUMN', N'Note'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'WordOccurence', 'COLUMN', N'Sequence'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Words used in the notes with their frequency, used for searching notes', 'SCHEMA', N'people', 'TABLE', N'Word', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Word', 'COLUMN', N'frequency'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Word', 'COLUMN', N'Item'
GO
EXEC sp_addextendedproperty N'Database_Info', N'[{"Name":"Pubs","Version":"1.1.1","Description":"The Pubs (publishing) Database supports a fictitious publisher.","Modified":"2023-04-19T14:20:58.860","by":"PhilFactor"}]', NULL, NULL, NULL, NULL, NULL, NULL
GO
-- This statement writes to the SQL Server Log so SQL Monitor can show this deployment.
IF HAS_PERMS_BY_NAME(N'sys.xp_logevent', N'OBJECT', N'EXECUTE') = 1
BEGIN
    DECLARE @databaseName AS nvarchar(2048), @eventMessage AS nvarchar(2048)
    SET @databaseName = REPLACE(REPLACE(DB_NAME(), N'\', N'\\'), N'"', N'\"')
    SET @eventMessage = N'Redgate SQL Compare: { "deployment": { "description": "Redgate SQL Compare deployed to ' + @databaseName + N'", "database": "' + @databaseName + N'" }}'
    EXECUTE sys.xp_logevent 55000, @eventMessage
END
GO
