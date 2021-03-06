SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
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
[country] [nvarchar] (50) NULL,
[Full_Address] AS (stuff((((coalesce(', '+[AddressLine1],'')+coalesce(', '+[AddressLine2],''))+coalesce(', '+[City],''))+coalesce(', '+[Region],''))+coalesce(', '+[PostalCode],''),(1),(2),'')),
[LegacyIdentifier] [nvarchar] (30) NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [AddressModifiedDateD] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [AddressPK] on [people].[Address]'
GO
ALTER TABLE [people].[Address] ADD CONSTRAINT [AddressPK] PRIMARY KEY CLUSTERED  ([Address_ID])
GO
PRINT N'Creating [people].[Abode]'
GO
CREATE TABLE [people].[Abode]
(
[Abode_ID] [int] NOT NULL IDENTITY(1, 1),
[Person_id] [int] NOT NULL,
[Address_id] [int] NOT NULL,
[TypeOfAddress] [nvarchar] (40) NOT NULL,
[Start_date] [datetime] NOT NULL,
[End_date] [datetime] NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [AbodeModifiedD] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [AbodePK] on [people].[Abode]'
GO
ALTER TABLE [people].[Abode] ADD CONSTRAINT [AbodePK] PRIMARY KEY CLUSTERED  ([Abode_ID])
GO
PRINT N'Creating [people].[AddressType]'
GO
CREATE TABLE [people].[AddressType]
(
[TypeOfAddress] [nvarchar] (40) NOT NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [AddressTypeModifiedDateD] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [TypeOfAddressPK] on [people].[AddressType]'
GO
ALTER TABLE [people].[AddressType] ADD CONSTRAINT [TypeOfAddressPK] PRIMARY KEY CLUSTERED  ([TypeOfAddress])
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
[LegacyIdentifier] [nvarchar] (30) NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [PersonModifiedDateD] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PersonIDPK] on [people].[Person]'
GO
ALTER TABLE [people].[Person] ADD CONSTRAINT [PersonIDPK] PRIMARY KEY CLUSTERED  ([person_ID])
GO
PRINT N'Creating index [SearchByPersonLastname] on [people].[Person]'
GO
CREATE NONCLUSTERED INDEX [SearchByPersonLastname] ON [people].[Person] ([LastName], [FirstName])
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
)
GO
PRINT N'Creating primary key [CreditCardPK] on [people].[CreditCard]'
GO
ALTER TABLE [people].[CreditCard] ADD CONSTRAINT [CreditCardPK] PRIMARY KEY CLUSTERED  ([CreditCardID])
GO
PRINT N'Adding constraints to [people].[CreditCard]'
GO
ALTER TABLE [people].[CreditCard] ADD CONSTRAINT [CreditCardWasntUnique] UNIQUE NONCLUSTERED  ([CardNumber])
GO
PRINT N'Adding constraints to [people].[CreditCard]'
GO
ALTER TABLE [people].[CreditCard] ADD CONSTRAINT [DuplicateCreditCardUK] UNIQUE NONCLUSTERED  ([Person_id], [CardNumber])
GO
PRINT N'Creating [people].[EmailAddress]'
GO
CREATE TABLE [people].[EmailAddress]
(
[EmailID] [int] NOT NULL IDENTITY(1, 1),
[Person_id] [int] NOT NULL,
[EmailAddress] [people].[PersonalEmailAddress] NOT NULL,
[StartDate] [date] NOT NULL DEFAULT (getdate()),
[EndDate] [date] NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [EmailAddressModifiedDateD] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [EmailPK] on [people].[EmailAddress]'
GO
ALTER TABLE [people].[EmailAddress] ADD CONSTRAINT [EmailPK] PRIMARY KEY CLUSTERED  ([EmailID])
GO
PRINT N'Creating [people].[PhoneType]'
GO
CREATE TABLE [people].[PhoneType]
(
[TypeOfPhone] [nvarchar] (40) NOT NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [PhoneTypeModifiedDateD] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PhoneTypePK] on [people].[PhoneType]'
GO
ALTER TABLE [people].[PhoneType] ADD CONSTRAINT [PhoneTypePK] PRIMARY KEY CLUSTERED  ([TypeOfPhone])
GO
PRINT N'Creating [people].[Phone]'
GO
CREATE TABLE [people].[Phone]
(
[Phone_ID] [int] NOT NULL IDENTITY(1, 1),
[Person_id] [int] NOT NULL,
[TypeOfPhone] [nvarchar] (40) NOT NULL,
[DiallingNumber] [people].[PersonalPhoneNumber] NOT NULL,
[Start_date] [datetime] NOT NULL,
[End_date] [datetime] NULL,
[ModifiedDate] [datetime] NULL CONSTRAINT [PhoneModifiedDateD] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PhonePK] on [people].[Phone]'
GO
ALTER TABLE [people].[Phone] ADD CONSTRAINT [PhonePK] PRIMARY KEY CLUSTERED  ([Phone_ID])
GO
PRINT N'Creating [dbo].[Publication_Types]'
GO
CREATE TABLE [dbo].[Publication_Types]
(
[Publication_Type] [nvarchar] (20) NOT NULL
)
GO
PRINT N'Creating primary key [PK__Publicat__66D9D2B3D2672FEB] on [dbo].[Publication_Types]'
GO
ALTER TABLE [dbo].[Publication_Types] ADD PRIMARY KEY CLUSTERED  ([Publication_Type])
GO
PRINT N'Creating [people].[Location]'
GO
CREATE TABLE [people].[Location]
(
[Location_ID] [int] NOT NULL IDENTITY(1, 1),
[organisation_id] [int] NOT NULL,
[Address_id] [int] NOT NULL,
[TypeOfAddress] [nvarchar] (40) NOT NULL,
[Start_date] [datetime] NOT NULL,
[End_date] [datetime] NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [LocationModifiedD] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [LocationPK] on [people].[Location]'
GO
ALTER TABLE [people].[Location] ADD CONSTRAINT [LocationPK] PRIMARY KEY CLUSTERED  ([Location_ID])
GO
PRINT N'Creating [people].[Organisation]'
GO
CREATE TABLE [people].[Organisation]
(
[organisation_ID] [int] NOT NULL IDENTITY(1, 1),
[OrganisationName] [nvarchar] (100) NOT NULL,
[LineOfBusiness] [nvarchar] (100) NOT NULL,
[LegacyIdentifier] [nvarchar] (30) NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [organisationModifiedDateD] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [organisationIDPK] on [people].[Organisation]'
GO
ALTER TABLE [people].[Organisation] ADD CONSTRAINT [organisationIDPK] PRIMARY KEY CLUSTERED  ([organisation_ID])
GO
PRINT N'Creating index [SearchByOrganisationName] on [people].[Organisation]'
GO
CREATE NONCLUSTERED INDEX [SearchByOrganisationName] ON [people].[Organisation] ([OrganisationName])
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
)
GO
PRINT N'Creating primary key [NotePK] on [people].[Note]'
GO
ALTER TABLE [people].[Note] ADD CONSTRAINT [NotePK] PRIMARY KEY CLUSTERED  ([Note_id])
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
)
GO
PRINT N'Creating primary key [NotePersonPK] on [people].[NotePerson]'
GO
ALTER TABLE [people].[NotePerson] ADD CONSTRAINT [NotePersonPK] PRIMARY KEY CLUSTERED  ([NotePerson_id])
GO
PRINT N'Adding constraints to [people].[NotePerson]'
GO
ALTER TABLE [people].[NotePerson] ADD CONSTRAINT [DuplicateUK] UNIQUE NONCLUSTERED  ([Person_id], [Note_id], [InsertionDate])
GO
PRINT N'Refreshing [dbo].[titles]'
GO
EXEC sp_refreshview N'[dbo].[titles]'
GO
PRINT N'Refreshing [dbo].[PublishersByPublicationType]'
GO
EXEC sp_refreshview N'[dbo].[PublishersByPublicationType]'
GO
PRINT N'Altering [dbo].[TitlesAndEditionsByPublisher]'
GO
ALTER VIEW [dbo].[TitlesAndEditionsByPublisher] (Publisher,Title,ListofEditions)
AS
/* A view to provide the number of each type of publication produced
Select * from [dbo].[TitlesAndEditionsByPublisher]
by each publisher*/

SELECT publishers.pub_name AS publisher, publications.title,
  Stuff(
         (
         SELECT ', ' + editions.Publication_type + ' ($' + Convert(VARCHAR(20), prices.price)
                + ')'
           FROM editions
             INNER JOIN dbo.prices 
               ON prices.Edition_id = editions.Edition_id
           WHERE prices.PriceEndDate IS NULL
             AND editions.publication_id = publications.Publication_id
         FOR XML PATH(''), TYPE
         ).value('.', 'nvarchar(max)'), 1, 2, '' ) AS ListOfEditions
  FROM dbo.publishers
    INNER JOIN dbo.publications
      ON publications.pub_id = publishers.pub_id;
GO
PRINT N'Refreshing [dbo].[titleview]'
GO
EXEC sp_refreshview N'[dbo].[titleview]'
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
PRINT N'Creating index [TagName_index] on [dbo].[TagTitle]'
GO
CREATE NONCLUSTERED INDEX [TagName_index] ON [dbo].[TagTitle] ([TagName_ID])
GO
PRINT N'Creating index [Titleid_index] on [dbo].[TagTitle]'
GO
CREATE NONCLUSTERED INDEX [Titleid_index] ON [dbo].[TagTitle] ([title_id])
GO
PRINT N'Creating index [Storid_index] on [dbo].[discounts]'
GO
CREATE NONCLUSTERED INDEX [Storid_index] ON [dbo].[discounts] ([stor_id])
GO
PRINT N'Creating index [Publicationid_index] on [dbo].[editions]'
GO
CREATE NONCLUSTERED INDEX [Publicationid_index] ON [dbo].[editions] ([publication_id])
GO
PRINT N'Creating index [JobID_index] on [dbo].[employee]'
GO
CREATE NONCLUSTERED INDEX [JobID_index] ON [dbo].[employee] ([job_id])
GO
PRINT N'Creating index [pub_id_index] on [dbo].[employee]'
GO
CREATE NONCLUSTERED INDEX [pub_id_index] ON [dbo].[employee] ([pub_id])
GO
PRINT N'Creating index [editionid_index] on [dbo].[prices]'
GO
CREATE NONCLUSTERED INDEX [editionid_index] ON [dbo].[prices] ([Edition_id])
GO
PRINT N'Creating index [pubid_index] on [dbo].[publications]'
GO
CREATE NONCLUSTERED INDEX [pubid_index] ON [dbo].[publications] ([pub_id])
GO
PRINT N'Adding constraints to [people].[Address]'
GO
ALTER TABLE [people].[Address] ADD CONSTRAINT [Address_Not_Complete] CHECK ((coalesce([AddressLine1],[AddressLine2],[City],[PostalCode]) IS NOT NULL))
GO
PRINT N'Adding foreign keys to [dbo].[editions]'
GO
ALTER TABLE [dbo].[editions] ADD CONSTRAINT [fk_Publication_Type] FOREIGN KEY ([Publication_type]) REFERENCES [dbo].[Publication_Types] ([Publication_Type])
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
ALTER TABLE [people].[Phone] ADD FOREIGN KEY ([TypeOfPhone]) REFERENCES [people].[PhoneType] ([TypeOfPhone])
GO
PRINT N'Altering extended properties'
GO
EXEC sp_updateextendedproperty N'Database_Info', N'[{"Name":"$(flyway:database)","Version":"1.1.12","Description":"$(projectDescription)","Project":"$(projectName)","Modified":"2022-02-14T11:32:35.743","by":"PhilFactor"}]', NULL, NULL, NULL, NULL, NULL, NULL
GO
PRINT N'Creating extended properties'
GO
EXEC sp_addextendedproperty N'MS_Description', N'An edition can be one of several types', 'SCHEMA', N'dbo', 'TABLE', N'Publication_Types', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'All the categories of publications', 'SCHEMA', N'dbo', 'TABLE', N'TagName', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the name of the tag', 'SCHEMA', N'dbo', 'TABLE', N'TagName', 'COLUMN', N'Tag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the Tag Table', 'SCHEMA', N'dbo', 'TABLE', N'TagName', 'COLUMN', N'TagName_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This relates tags to publications so that publications can have more than one', 'SCHEMA', N'dbo', 'TABLE', N'TagTitle', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'is this the primary tag (e.g. ''Fiction'')', 'SCHEMA', N'dbo', 'TABLE', N'TagTitle', 'COLUMN', N'Is_Primary'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The foreign key to the tagname', 'SCHEMA', N'dbo', 'TABLE', N'TagTitle', 'COLUMN', N'TagName_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the TagTitle Table', 'SCHEMA', N'dbo', 'TABLE', N'TagTitle', 'COLUMN', N'TagTitle_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The foreign key to the title', 'SCHEMA', N'dbo', 'TABLE', N'TagTitle', 'COLUMN', N'title_id'
GO
