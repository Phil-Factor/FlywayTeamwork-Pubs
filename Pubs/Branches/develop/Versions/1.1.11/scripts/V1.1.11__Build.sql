SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Creating schemas'
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
ALTER TABLE [people].[Address] ADD CONSTRAINT [AddressPK] PRIMARY KEY CLUSTERED  ([Address_ID]) ON [PRIMARY]
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
ALTER TABLE [people].[Abode] ADD CONSTRAINT [AbodePK] PRIMARY KEY CLUSTERED  ([Abode_ID]) ON [PRIMARY]
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
ALTER TABLE [people].[AddressType] ADD CONSTRAINT [TypeOfAddressPK] PRIMARY KEY CLUSTERED  ([TypeOfAddress]) ON [PRIMARY]
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
ALTER TABLE [people].[Person] ADD CONSTRAINT [PersonIDPK] PRIMARY KEY CLUSTERED  ([person_ID]) ON [PRIMARY]
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
ALTER TABLE [people].[CreditCard] ADD CONSTRAINT [CreditCardPK] PRIMARY KEY CLUSTERED  ([CreditCardID]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [people].[CreditCard]'
GO
ALTER TABLE [people].[CreditCard] ADD CONSTRAINT [CreditCardWasntUnique] UNIQUE NONCLUSTERED  ([CardNumber]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [people].[CreditCard]'
GO
ALTER TABLE [people].[CreditCard] ADD CONSTRAINT [DuplicateCreditCardUK] UNIQUE NONCLUSTERED  ([Person_id], [CardNumber]) ON [PRIMARY]
GO
PRINT N'Creating [people].[EmailAddress]'
GO
CREATE TABLE [people].[EmailAddress]
(
[EmailID] [int] NOT NULL IDENTITY(1, 1),
[Person_id] [int] NOT NULL,
[EmailAddress] [people].[PersonalEmailAddress] NOT NULL,
[StartDate] [date] NOT NULL CONSTRAINT [DF__EmailAddr__Start__168449D3] DEFAULT (getdate()),
[EndDate] [date] NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [EmailAddressModifiedDateD] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [EmailPK] on [people].[EmailAddress]'
GO
ALTER TABLE [people].[EmailAddress] ADD CONSTRAINT [EmailPK] PRIMARY KEY CLUSTERED  ([EmailID]) ON [PRIMARY]
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
ALTER TABLE [dbo].[stores] ADD CONSTRAINT [UPK_storeid] PRIMARY KEY CLUSTERED  ([stor_id]) ON [PRIMARY]
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
ALTER TABLE [dbo].[discounts] ADD CONSTRAINT [PK_Discounts] PRIMARY KEY CLUSTERED  ([Discount_id]) ON [PRIMARY]
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
ALTER TABLE [dbo].[jobs] ADD CONSTRAINT [PK__jobs__6E32B6A51A14E395] PRIMARY KEY CLUSTERED  ([job_id]) ON [PRIMARY]
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
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [PK_emp_id] PRIMARY KEY NONCLUSTERED  ([emp_id]) ON [PRIMARY]
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
ALTER TABLE [dbo].[publishers] ADD CONSTRAINT [UPKCL_pubind] PRIMARY KEY CLUSTERED  ([pub_id]) ON [PRIMARY]
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
ALTER TABLE [people].[PhoneType] ADD CONSTRAINT [PhoneTypePK] PRIMARY KEY CLUSTERED  ([TypeOfPhone]) ON [PRIMARY]
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
ALTER TABLE [people].[Phone] ADD CONSTRAINT [PhonePK] PRIMARY KEY CLUSTERED  ([Phone_ID]) ON [PRIMARY]
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
ALTER TABLE [dbo].[pub_info] ADD CONSTRAINT [UPKCL_pubinfo] PRIMARY KEY CLUSTERED  ([pub_id]) ON [PRIMARY]
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
ALTER TABLE [dbo].[publications] ADD CONSTRAINT [PK_Publication] PRIMARY KEY CLUSTERED  ([Publication_id]) ON [PRIMARY]
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
ALTER TABLE [dbo].[roysched] ADD CONSTRAINT [PK_Roysched] PRIMARY KEY CLUSTERED  ([roysched_id]) ON [PRIMARY]
GO
PRINT N'Creating index [titleidind] on [dbo].[roysched]'
GO
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[roysched] ([title_id]) ON [PRIMARY]
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
ALTER TABLE [dbo].[authors] ADD CONSTRAINT [UPKCL_auidind] PRIMARY KEY CLUSTERED  ([au_id]) ON [PRIMARY]
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
ALTER TABLE [dbo].[titleauthor] ADD CONSTRAINT [UPKCL_taind] PRIMARY KEY CLUSTERED  ([au_id], [title_id]) ON [PRIMARY]
GO
PRINT N'Creating index [auidind] on [dbo].[titleauthor]'
GO
CREATE NONCLUSTERED INDEX [auidind] ON [dbo].[titleauthor] ([au_id]) ON [PRIMARY]
GO
PRINT N'Creating index [titleidind] on [dbo].[titleauthor]'
GO
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[titleauthor] ([title_id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[editions]'
GO
CREATE TABLE [dbo].[editions]
(
[Edition_id] [int] NOT NULL IDENTITY(1, 1),
[publication_id] [dbo].[tid] NOT NULL,
[Publication_type] [nvarchar] (20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF__editions__Public__353DDB1D] DEFAULT ('book'),
[EditionDate] [datetime2] NOT NULL CONSTRAINT [DF__editions__Editio__3631FF56] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_editions] on [dbo].[editions]'
GO
ALTER TABLE [dbo].[editions] ADD CONSTRAINT [PK_editions] PRIMARY KEY CLUSTERED  ([Edition_id]) ON [PRIMARY]
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
[PriceStartDate] [datetime2] NOT NULL CONSTRAINT [DF__prices__PriceSta__390E6C01] DEFAULT (getdate()),
[PriceEndDate] [datetime2] NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Prices] on [dbo].[prices]'
GO
ALTER TABLE [dbo].[prices] ADD CONSTRAINT [PK_Prices] PRIMARY KEY CLUSTERED  ([Price_id]) ON [PRIMARY]
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
PRINT N'Creating primary key [PK__Publicat__66D9D2B3F3539031] on [dbo].[Publication_Types]'
GO
ALTER TABLE [dbo].[Publication_Types] ADD CONSTRAINT [PK__Publicat__66D9D2B3F3539031] PRIMARY KEY CLUSTERED  ([Publication_Type]) ON [PRIMARY]
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
ALTER TABLE [dbo].[sales] ADD CONSTRAINT [UPKCL_sales] PRIMARY KEY CLUSTERED  ([stor_id], [ord_num], [title_id]) ON [PRIMARY]
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
ALTER TABLE [dbo].[TagName] ADD CONSTRAINT [TagnameSurrogate] PRIMARY KEY CLUSTERED  ([TagName_ID]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[TagName]'
GO
ALTER TABLE [dbo].[TagName] ADD CONSTRAINT [Uniquetag] UNIQUE NONCLUSTERED  ([Tag]) ON [PRIMARY]
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
ALTER TABLE [dbo].[TagTitle] ADD CONSTRAINT [PK_TagNameTitle] PRIMARY KEY CLUSTERED  ([title_id], [TagName_ID]) ON [PRIMARY]
GO
PRINT N'Creating index [TagName_index] on [dbo].[TagTitle]'
GO
CREATE NONCLUSTERED INDEX [TagName_index] ON [dbo].[TagTitle] ([TagName_ID]) ON [PRIMARY]
GO
PRINT N'Creating index [Titleid_index] on [dbo].[TagTitle]'
GO
CREATE NONCLUSTERED INDEX [Titleid_index] ON [dbo].[TagTitle] ([title_id]) ON [PRIMARY]
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
ALTER TABLE [people].[Location] ADD CONSTRAINT [LocationPK] PRIMARY KEY CLUSTERED  ([Location_ID]) ON [PRIMARY]
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
ALTER TABLE [people].[Organisation] ADD CONSTRAINT [organisationIDPK] PRIMARY KEY CLUSTERED  ([organisation_ID]) ON [PRIMARY]
GO
PRINT N'Creating index [SearchByOrganisationName] on [people].[Organisation]'
GO
CREATE NONCLUSTERED INDEX [SearchByOrganisationName] ON [people].[Organisation] ([OrganisationName]) ON [PRIMARY]
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
ALTER TABLE [people].[Note] ADD CONSTRAINT [NotePK] PRIMARY KEY CLUSTERED  ([Note_id]) ON [PRIMARY]
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
ALTER TABLE [people].[NotePerson] ADD CONSTRAINT [NotePersonPK] PRIMARY KEY CLUSTERED  ([NotePerson_id]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [people].[NotePerson]'
GO
ALTER TABLE [people].[NotePerson] ADD CONSTRAINT [DuplicateUK] UNIQUE NONCLUSTERED  ([Person_id], [Note_id], [InsertionDate]) ON [PRIMARY]
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
PRINT N'Creating [dbo].[flyway_schema_history]'
GO
CREATE TABLE [dbo].[flyway_schema_history]
(
[installed_rank] [int] NOT NULL,
[version] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[description] [nvarchar] (200) COLLATE Latin1_General_CI_AS NULL,
[type] [nvarchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[script] [nvarchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[checksum] [int] NULL,
[installed_by] [nvarchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[installed_on] [datetime] NOT NULL CONSTRAINT [DF__flyway_sc__insta__75586032] DEFAULT (getdate()),
[execution_time] [int] NOT NULL,
[success] [bit] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [flyway_schema_history_pk] on [dbo].[flyway_schema_history]'
GO
ALTER TABLE [dbo].[flyway_schema_history] ADD CONSTRAINT [flyway_schema_history_pk] PRIMARY KEY CLUSTERED  ([installed_rank]) ON [PRIMARY]
GO
PRINT N'Creating index [flyway_schema_history_s_idx] on [dbo].[flyway_schema_history]'
GO
CREATE NONCLUSTERED INDEX [flyway_schema_history_s_idx] ON [dbo].[flyway_schema_history] ([success]) ON [PRIMARY]
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
ALTER TABLE [people].[Phone] ADD CONSTRAINT [FK__Phone__TypeOfPho__009508B4] FOREIGN KEY ([TypeOfPhone]) REFERENCES [people].[PhoneType] ([TypeOfPhone])
GO
PRINT N'Creating extended properties'
GO
EXEC sp_addextendedproperty N'MS_Description', N'An edition can be one of several types', 'SCHEMA', N'dbo', 'TABLE', N'Publication_Types', NULL, NULL
GO
EXEC sp_addextendedproperty N'Database_Info', N'[{"Name":"Pubs","Version":"1.1.1","Description":"The Pubs (publishing) Database supports a fictitious publisher.","Modified":"2022-01-18T14:49:10.400","by":"PhilFactor"}]', NULL, NULL, NULL, NULL, NULL, NULL
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
