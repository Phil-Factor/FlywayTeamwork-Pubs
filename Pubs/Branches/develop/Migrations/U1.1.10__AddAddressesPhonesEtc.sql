EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"
PRINT N'Dropping foreign keys from [people].[Abode]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.foreign_keys
     WHERE
     object_id = Object_Id (N'[people].[Abode_PersonFK]', 'F')
 AND parent_object_id = Object_Id (N'[people].[Abode]', 'U'))
  ALTER TABLE [people].[Abode] DROP CONSTRAINT [Abode_PersonFK];
GO
IF EXISTS
  (SELECT 1
     FROM sys.foreign_keys
     WHERE
     object_id = Object_Id (N'[people].[Abode_AddressFK]', 'F')
 AND parent_object_id = Object_Id (N'[people].[Abode]', 'U'))
  ALTER TABLE [people].[Abode] DROP CONSTRAINT [Abode_AddressFK];
GO
IF EXISTS
  (SELECT 1
     FROM sys.foreign_keys
     WHERE
     object_id = Object_Id (N'[people].[Abode_AddressTypeFK]', 'F')
 AND parent_object_id = Object_Id (N'[people].[Abode]', 'U'))
  ALTER TABLE [people].[Abode] DROP CONSTRAINT [Abode_AddressTypeFK];
GO
PRINT N'Dropping foreign keys from [people].[Location]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.foreign_keys
     WHERE
     object_id = Object_Id (N'[people].[Location_AddressTypeFK]', 'F')
 AND parent_object_id = Object_Id (N'[people].[Location]', 'U'))
  ALTER TABLE [people].[Location] DROP CONSTRAINT [Location_AddressTypeFK];
GO
IF EXISTS
  (SELECT 1
     FROM sys.foreign_keys
     WHERE
     object_id = Object_Id (N'[people].[Location_AddressFK]', 'F')
 AND parent_object_id = Object_Id (N'[people].[Location]', 'U'))
  ALTER TABLE [people].[Location] DROP CONSTRAINT [Location_AddressFK];
GO
IF EXISTS
  (SELECT 1
     FROM sys.foreign_keys
     WHERE
     object_id = Object_Id (N'[people].[Location_organisationFK]', 'F')
 AND parent_object_id = Object_Id (N'[people].[Location]', 'U'))
  ALTER TABLE [people].[Location] DROP CONSTRAINT [Location_organisationFK];
GO
PRINT N'Dropping foreign keys from [people].[CreditCard]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.foreign_keys
     WHERE
     object_id = Object_Id (N'[people].[CreditCard_PersonFK]', 'F')
 AND parent_object_id = Object_Id (N'[people].[CreditCard]', 'U'))
  ALTER TABLE [people].[CreditCard] DROP CONSTRAINT [CreditCard_PersonFK];
GO
PRINT N'Dropping foreign keys from [people].[EmailAddress]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.foreign_keys
     WHERE
     object_id = Object_Id (N'[people].[EmailAddress_PersonFK]', 'F')
 AND parent_object_id = Object_Id (N'[people].[EmailAddress]', 'U'))
  ALTER TABLE [people].[EmailAddress] DROP CONSTRAINT [EmailAddress_PersonFK];
GO
PRINT N'Dropping foreign keys from [people].[NotePerson]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.foreign_keys
     WHERE
     object_id = Object_Id (N'[people].[NotePerson_PersonFK]', 'F')
 AND parent_object_id = Object_Id (N'[people].[NotePerson]', 'U'))
  ALTER TABLE [people].[NotePerson] DROP CONSTRAINT [NotePerson_PersonFK];
GO
IF EXISTS
  (SELECT 1
     FROM sys.foreign_keys
     WHERE
     object_id = Object_Id (N'[people].[NotePerson_NoteFK]', 'F')
 AND parent_object_id = Object_Id (N'[people].[NotePerson]', 'U'))
  ALTER TABLE [people].[NotePerson] DROP CONSTRAINT [NotePerson_NoteFK];
GO
PRINT N'Dropping foreign keys from [people].[Phone]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.foreign_keys
     WHERE
     object_id = Object_Id (N'[people].[Phone_PersonFK]', 'F')
 AND parent_object_id = Object_Id (N'[people].[Phone]', 'U'))
  ALTER TABLE [people].[Phone] DROP CONSTRAINT [Phone_PersonFK];
GO
IF EXISTS
  (SELECT 1
     FROM sys.foreign_keys
     WHERE
     object_id = Object_Id (N'[people].[FK__Phone__TypeOfPho__483BA0F8]', 'F')
 AND parent_object_id = Object_Id (N'[people].[Phone]', 'U'))
  ALTER TABLE [people].[Phone]
  DROP CONSTRAINT [FK__Phone__TypeOfPho__483BA0F8];
GO
PRINT N'Dropping constraints from [people].[Address]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.check_constraints
     WHERE
     object_id = Object_Id (N'[people].[Address_Not_Complete]', 'C')
 AND parent_object_id = Object_Id (N'[people].[Address]', 'U'))
  ALTER TABLE [people].[Address] DROP CONSTRAINT [Address_Not_Complete];
GO
PRINT N'Dropping constraints from [people].[Address]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[people].[AddressPK]', 'PK')
 AND parent_object_id = Object_Id (N'[people].[Address]', 'U'))
  ALTER TABLE [people].[Address] DROP CONSTRAINT [AddressPK];
GO
PRINT N'Dropping constraints from [people].[Address]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.columns
     WHERE
     name = N'ModifiedDate'
 AND object_id = Object_Id (N'[people].[Address]', 'U')
 AND default_object_id = Object_Id (N'[people].[AddressModifiedDateD]', 'D'))
  ALTER TABLE [people].[Address] DROP CONSTRAINT [AddressModifiedDateD];
GO
PRINT N'Dropping constraints from [people].[Abode]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[people].[AbodePK]', 'PK')
 AND parent_object_id = Object_Id (N'[people].[Abode]', 'U'))
  ALTER TABLE [people].[Abode] DROP CONSTRAINT [AbodePK];
GO
PRINT N'Dropping constraints from [people].[Abode]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.columns
     WHERE
     name = N'ModifiedDate'
 AND object_id = Object_Id (N'[people].[Abode]', 'U')
 AND default_object_id = Object_Id (N'[people].[AbodeModifiedD]', 'D'))
  ALTER TABLE [people].[Abode] DROP CONSTRAINT [AbodeModifiedD];
GO
PRINT N'Dropping constraints from [people].[AddressType]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[people].[TypeOfAddressPK]', 'PK')
 AND parent_object_id = Object_Id (N'[people].[AddressType]', 'U'))
  ALTER TABLE [people].[AddressType] DROP CONSTRAINT [TypeOfAddressPK];
GO
PRINT N'Dropping constraints from [people].[AddressType]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.columns
     WHERE
     name = N'ModifiedDate'
 AND object_id = Object_Id (N'[people].[AddressType]', 'U')
 AND default_object_id = Object_Id (
                           N'[people].[AddressTypeModifiedDateD]', 'D'))
  ALTER TABLE [people].[AddressType]
  DROP CONSTRAINT [AddressTypeModifiedDateD];
GO
PRINT N'Dropping constraints from [people].[CreditCard]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[people].[CreditCardPK]', 'PK')
 AND parent_object_id = Object_Id (N'[people].[CreditCard]', 'U'))
  ALTER TABLE [people].[CreditCard] DROP CONSTRAINT [CreditCardPK];
GO
PRINT N'Dropping constraints from [people].[CreditCard]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[people].[DuplicateCreditCardUK]', 'UQ')
 AND parent_object_id = Object_Id (N'[people].[CreditCard]', 'U'))
  ALTER TABLE [people].[CreditCard] DROP CONSTRAINT [DuplicateCreditCardUK];
GO
PRINT N'Dropping constraints from [people].[CreditCard]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[people].[CreditCardWasntUnique]', 'UQ')
 AND parent_object_id = Object_Id (N'[people].[CreditCard]', 'U'))
  ALTER TABLE [people].[CreditCard] DROP CONSTRAINT [CreditCardWasntUnique];
GO
PRINT N'Dropping constraints from [people].[CreditCard]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.columns
     WHERE
     name = N'ModifiedDate'
 AND object_id = Object_Id (N'[people].[CreditCard]', 'U')
 AND default_object_id = Object_Id (
                           N'[people].[CreditCardModifiedDateD]', 'D'))
  ALTER TABLE [people].[CreditCard] DROP CONSTRAINT [CreditCardModifiedDateD];
GO
PRINT N'Dropping constraints from [people].[EmailAddress]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[people].[EmailPK]', 'PK')
 AND parent_object_id = Object_Id (N'[people].[EmailAddress]', 'U'))
  ALTER TABLE [people].[EmailAddress] DROP CONSTRAINT [EmailPK];
GO
PRINT N'Dropping constraints from [people].[EmailAddress]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.columns
     WHERE
     name = N'StartDate'
 AND object_id = Object_Id (N'[people].[EmailAddress]', 'U')
 AND default_object_id = Object_Id (
                           N'[people].[DF__EmailAddr__Start__5E2AE217]', 'D'))
  ALTER TABLE [people].[EmailAddress]
  DROP CONSTRAINT [DF__EmailAddr__Start__5E2AE217];
GO
PRINT N'Dropping constraints from [people].[EmailAddress]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.columns
     WHERE
     name = N'ModifiedDate'
 AND object_id = Object_Id (N'[people].[EmailAddress]', 'U')
 AND default_object_id = Object_Id (
                           N'[people].[EmailAddressModifiedDateD]', 'D'))
  ALTER TABLE [people].[EmailAddress]
  DROP CONSTRAINT [EmailAddressModifiedDateD];
GO
PRINT N'Dropping constraints from [people].[Location]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[people].[LocationPK]', 'PK')
 AND parent_object_id = Object_Id (N'[people].[Location]', 'U'))
  ALTER TABLE [people].[Location] DROP CONSTRAINT [LocationPK];
GO
PRINT N'Dropping constraints from [people].[Location]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.columns
     WHERE
     name = N'ModifiedDate'
 AND object_id = Object_Id (N'[people].[Location]', 'U')
 AND default_object_id = Object_Id (N'[people].[LocationModifiedD]', 'D'))
  ALTER TABLE [people].[Location] DROP CONSTRAINT [LocationModifiedD];
GO
PRINT N'Dropping constraints from [people].[NotePerson]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[people].[NotePersonPK]', 'PK')
 AND parent_object_id = Object_Id (N'[people].[NotePerson]', 'U'))
  ALTER TABLE [people].[NotePerson] DROP CONSTRAINT [NotePersonPK];
GO
PRINT N'Dropping constraints from [people].[NotePerson]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[people].[DuplicateUK]', 'UQ')
 AND parent_object_id = Object_Id (N'[people].[NotePerson]', 'U'))
  ALTER TABLE [people].[NotePerson] DROP CONSTRAINT [DuplicateUK];
GO
PRINT N'Dropping constraints from [people].[NotePerson]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.columns
     WHERE
     name = N'InsertionDate'
 AND object_id = Object_Id (N'[people].[NotePerson]', 'U')
 AND default_object_id = Object_Id (
                           N'[people].[NotePersonInsertionDateD]', 'D'))
  ALTER TABLE [people].[NotePerson] DROP CONSTRAINT [NotePersonInsertionDateD];
GO
PRINT N'Dropping constraints from [people].[NotePerson]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.columns
     WHERE
     name = N'ModifiedDate'
 AND object_id = Object_Id (N'[people].[NotePerson]', 'U')
 AND default_object_id = Object_Id (
                           N'[people].[NotePersonModifiedDateD]', 'D'))
  ALTER TABLE [people].[NotePerson] DROP CONSTRAINT [NotePersonModifiedDateD];
GO
PRINT N'Dropping constraints from [people].[Note]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[people].[NotePK]', 'PK')
 AND parent_object_id = Object_Id (N'[people].[Note]', 'U'))
  ALTER TABLE [people].[Note] DROP CONSTRAINT [NotePK];
GO
PRINT N'Dropping constraints from [people].[Note]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.columns
     WHERE
     name = N'InsertionDate'
 AND object_id = Object_Id (N'[people].[Note]', 'U')
 AND default_object_id = Object_Id (N'[people].[NoteInsertionDateDL]', 'D'))
  ALTER TABLE [people].[Note] DROP CONSTRAINT [NoteInsertionDateDL];
GO
PRINT N'Dropping constraints from [people].[Note]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.columns
     WHERE
     name = N'InsertedBy'
 AND object_id = Object_Id (N'[people].[Note]', 'U')
 AND default_object_id = Object_Id (N'[people].[GetUserName]', 'D'))
  ALTER TABLE [people].[Note] DROP CONSTRAINT [GetUserName];
GO
PRINT N'Dropping constraints from [people].[Note]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.columns
     WHERE
     name = N'ModifiedDate'
 AND object_id = Object_Id (N'[people].[Note]', 'U')
 AND default_object_id = Object_Id (N'[people].[NoteModifiedDateD]', 'D'))
  ALTER TABLE [people].[Note] DROP CONSTRAINT [NoteModifiedDateD];
GO
PRINT N'Dropping constraints from [people].[Organisation]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[people].[organisationIDPK]', 'PK')
 AND parent_object_id = Object_Id (N'[people].[Organisation]', 'U'))
  ALTER TABLE [people].[Organisation] DROP CONSTRAINT [organisationIDPK];
GO
PRINT N'Dropping constraints from [people].[Organisation]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.columns
     WHERE
     name = N'ModifiedDate'
 AND object_id = Object_Id (N'[people].[Organisation]', 'U')
 AND default_object_id = Object_Id (
                           N'[people].[organisationModifiedDateD]', 'D'))
  ALTER TABLE [people].[Organisation]
  DROP CONSTRAINT [organisationModifiedDateD];
GO
PRINT N'Dropping constraints from [people].[Person]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[people].[PersonIDPK]', 'PK')
 AND parent_object_id = Object_Id (N'[people].[Person]', 'U'))
  ALTER TABLE [people].[Person] DROP CONSTRAINT [PersonIDPK];
GO
PRINT N'Dropping constraints from [people].[Person]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.columns
     WHERE
     name = N'ModifiedDate'
 AND object_id = Object_Id (N'[people].[Person]', 'U')
 AND default_object_id = Object_Id (N'[people].[PersonModifiedDateD]', 'D'))
  ALTER TABLE [people].[Person] DROP CONSTRAINT [PersonModifiedDateD];
GO
PRINT N'Dropping constraints from [people].[PhoneType]';
GO
--The constraint 'PhoneTypePK' is being referenced by table 'Phone', foreign key constraint 'FK__Phone__TypeOfPho__74A4331B
DECLARE @PeskyConstraints NVARCHAR(MAX)=''
SELECT @PeskyConstraints=Coalesce(@PeskyConstraints,'')+'Alter table ['+Object_Schema_Name(parent_Object_id)+'].['+Object_Name(parent_Object_id)+ '] DROP CONSTRAINT ['+  name +'];' FROM sys.objects WHERE name LIKE 'FK__Phone__TypeOfPho%'
SELECT  @PeskyConstraints
EXEC (@PeskyConstraints)
---Alter Phone DROP CONSTRAINT [FK__Phone__TypeOfPho__74A4331B]

IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[people].[PhoneTypePK]', 'PK')
 AND parent_object_id = Object_Id (N'[people].[PhoneType]', 'U'))
  ALTER TABLE [people].[PhoneType] DROP CONSTRAINT [PhoneTypePK];
GO
PRINT N'Dropping constraints from [people].[PhoneType]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.columns
     WHERE
     name = N'ModifiedDate'
 AND object_id = Object_Id (N'[people].[PhoneType]', 'U')
 AND default_object_id = Object_Id (N'[people].[PhoneTypeModifiedDateD]', 'D'))
  ALTER TABLE [people].[PhoneType] DROP CONSTRAINT [PhoneTypeModifiedDateD];
GO
PRINT N'Dropping constraints from [people].[Phone]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[people].[PhonePK]', 'PK')
 AND parent_object_id = Object_Id (N'[people].[Phone]', 'U'))
  ALTER TABLE [people].[Phone] DROP CONSTRAINT [PhonePK];
GO
PRINT N'Dropping constraints from [people].[Phone]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.columns
     WHERE
     name = N'ModifiedDate'
 AND object_id = Object_Id (N'[people].[Phone]', 'U')
 AND default_object_id = Object_Id (N'[people].[PhoneModifiedDateD]', 'D'))
  ALTER TABLE [people].[Phone] DROP CONSTRAINT [PhoneModifiedDateD];
GO
PRINT N'Dropping index [SearchByOrganisationName] from [people].[Organisation]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.indexes
     WHERE
     name = N'SearchByOrganisationName'
 AND object_id = Object_Id (N'[people].[Organisation]'))
  DROP INDEX [SearchByOrganisationName] ON [people].[Organisation];
GO
PRINT N'Dropping index [SearchByPersonLastname] from [people].[Person]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.indexes
     WHERE
     name = N'SearchByPersonLastname'
 AND object_id = Object_Id (N'[people].[Person]'))
  DROP INDEX [SearchByPersonLastname] ON [people].[Person];
GO
PRINT N'Unbinding types from columns';
GO
IF Col_Length (N'[people].[Address]', N'Full_Address') IS NOT NULL
 ALTER TABLE [people].[Address] drop COLUMN [Full_Address] 
GO
IF Col_Length (N'[people].[Address]', N'AddressLine1') IS NOT NULL
  ALTER TABLE [people].[Address] ALTER COLUMN [AddressLine1] VARCHAR(60) NULL;
GO
IF Col_Length (N'[people].[Address]', N'AddressLine2') IS NOT NULL
  ALTER TABLE [people].[Address] ALTER COLUMN [AddressLine2] VARCHAR(60) NULL;
GO
IF Col_Length (N'[people].[CreditCard]', N'CVC') IS NOT NULL
  ALTER TABLE [people].[CreditCard] ALTER COLUMN [CVC] CHAR(3) NOT NULL;
GO
IF Col_Length (N'[people].[EmailAddress]', N'EmailAddress') IS NOT NULL
  ALTER TABLE [people].[EmailAddress]
  ALTER COLUMN [EmailAddress] NVARCHAR(40) NOT NULL;
GO
IF Col_Length (N'[people].[Address]', N'City') IS NOT NULL
  ALTER TABLE [people].[Address] ALTER COLUMN [city] VARCHAR(20) NULL;
GO
IF Col_Length (N'[people].[Address]', N'Region') IS NOT NULL
  ALTER TABLE [people].[Address] ALTER COLUMN [Region] VARCHAR(20) NULL;
GO
IF Col_Length (N'[people].[Person]', N'Nickname') IS NOT NULL
  ALTER TABLE [people].[Person] ALTER COLUMN [Nickname] NVARCHAR(40) NULL;
GO
IF Col_Length (N'[people].[Person]', N'fullname') IS NOT NULL
 ALTER TABLE [people].[Person] drop COLUMN [fullname] 
GO
IF Col_Length (N'[people].[Person]', N'FirstName') IS NOT NULL
  ALTER TABLE [people].[Person]
  ALTER COLUMN [FirstName] NVARCHAR(40) NOT NULL;
GO
IF Col_Length (N'[people].[Person]', N'MiddleName') IS NOT NULL
  ALTER TABLE [people].[Person] ALTER COLUMN [MiddleName] NVARCHAR(40) NULL;
GO
IF Col_Length (N'[people].[Person]', N'LastName') IS NOT NULL
  ALTER TABLE [people].[Person] ALTER COLUMN [LastName] NVARCHAR(40) NOT NULL;
GO
IF Col_Length (N'[people].[Note]', N'NoteStart') IS NOT NULL
  ALTER TABLE [people].[Note] drop COLUMN [NoteStart] 
GO
IF Col_Length (N'[people].[Note]', N'Note') IS NOT NULL
  ALTER TABLE [people].[Note] ALTER COLUMN [Note] NVARCHAR(MAX) NOT NULL;
GO
IF Col_Length (N'[people].[CreditCard]', N'CardNumber') IS NOT NULL
  ALTER TABLE [people].[CreditCard]
  ALTER COLUMN [CardNumber] VARCHAR(20) NOT NULL;
GO
IF Col_Length (N'[people].[Phone]', N'DiallingNumber') IS NOT NULL
  ALTER TABLE [people].[Phone]
  ALTER COLUMN [DiallingNumber] VARCHAR(20) NOT NULL;
GO
IF Col_Length (N'[people].[Address]', N'PostalCode') IS NOT NULL
  ALTER TABLE [people].[Address] ALTER COLUMN [PostalCode] VARCHAR(15) NULL;
GO
IF Col_Length (N'[people].[Person]', N'Suffix') IS NOT NULL
  ALTER TABLE [people].[Person] ALTER COLUMN [Suffix] NVARCHAR(10) NULL;
GO
IF Col_Length (N'[people].[Person]', N'Title') IS NOT NULL
  ALTER TABLE [people].[Person] ALTER COLUMN [title] NVARCHAR(10) NULL;
GO
PRINT N'Dropping [people].[authors]';
GO
IF Object_Id (N'[people].[authors]', 'V') IS NOT NULL
  DROP VIEW [people].[authors];
GO
PRINT N'Dropping [people].[publishers]';
GO
IF Object_Id (N'[people].[publishers]', 'V') IS NOT NULL
  DROP VIEW [people].[publishers];
GO
PRINT N'Dropping [people].[NotePerson]';
GO
IF Object_Id (N'[people].[NotePerson]', 'U') IS NOT NULL
  DROP TABLE [people].[NotePerson];
GO
PRINT N'Dropping [people].[Note]';
GO
IF Object_Id (N'[people].[Note]', 'U') IS NOT NULL
  DROP TABLE [people].[Note];
GO
PRINT N'Dropping [people].[Organisation]';
GO
IF Object_Id (N'[people].[Organisation]', 'U') IS NOT NULL
  DROP TABLE [people].[Organisation];
GO
PRINT N'Dropping [people].[Location]';
GO
IF Object_Id (N'[people].[Location]', 'U') IS NOT NULL
  DROP TABLE [people].[Location];
GO
PRINT N'Dropping [people].[Phone]';
GO
IF Object_Id (N'[people].[Phone]', 'U') IS NOT NULL
  DROP TABLE [people].[Phone];
GO
PRINT N'Dropping [people].[PhoneType]';
GO
IF Object_Id (N'[people].[PhoneType]', 'U') IS NOT NULL
  DROP TABLE [people].[PhoneType];
GO
PRINT N'Dropping [people].[EmailAddress]';
GO
IF Object_Id (N'[people].[EmailAddress]', 'U') IS NOT NULL
  DROP TABLE [people].[EmailAddress];
GO
PRINT N'Dropping [people].[CreditCard]';
GO
IF Object_Id (N'[people].[CreditCard]', 'U') IS NOT NULL
  DROP TABLE [people].[CreditCard];
GO
PRINT N'Dropping [people].[Person]';
GO
IF Object_Id (N'[people].[Person]', 'U') IS NOT NULL
  DROP TABLE [people].[Person];
GO
PRINT N'Dropping [people].[AddressType]';
GO
IF Object_Id (N'[people].[AddressType]', 'U') IS NOT NULL
  DROP TABLE [people].[AddressType];
GO
PRINT N'Dropping [people].[Abode]';
GO
IF Object_Id (N'[people].[Abode]', 'U') IS NOT NULL
  DROP TABLE [people].[Abode];
GO
PRINT N'Dropping [people].[Address]';
GO
IF Object_Id (N'[people].[Address]', 'U') IS NOT NULL
  DROP TABLE [people].[Address];
GO
PRINT N'Dropping types';
GO
IF Type_Id (N'[people].[PersonalAddressline]') IS NOT NULL
  DROP TYPE [people].[PersonalAddressline];
GO
IF Type_Id (N'[people].[PersonalCVC]') IS NOT NULL
  DROP TYPE [people].[PersonalCVC];
GO
IF Type_Id (N'[people].[PersonalEmailAddress]') IS NOT NULL
  DROP TYPE [people].[PersonalEmailAddress];
GO
IF Type_Id (N'[people].[PersonalLocation]') IS NOT NULL
  DROP TYPE [people].[PersonalLocation];
GO
IF Type_Id (N'[people].[PersonalName]') IS NOT NULL
  DROP TYPE [people].[PersonalName];
GO
IF Type_Id (N'[people].[PersonalNote]') IS NOT NULL
  DROP TYPE [people].[PersonalNote];
GO
IF Type_Id (N'[people].[PersonalPaymentCardNumber]') IS NOT NULL
  DROP TYPE [people].[PersonalPaymentCardNumber];
GO
IF Type_Id (N'[people].[PersonalPhoneNumber]') IS NOT NULL
  DROP TYPE [people].[PersonalPhoneNumber];
GO
IF Type_Id (N'[people].[PersonalPostalCode]') IS NOT NULL
  DROP TYPE [people].[PersonalPostalCode];
GO
IF Type_Id (N'[people].[PersonalSuffix]') IS NOT NULL
  DROP TYPE [people].[PersonalSuffix];
GO
IF Type_Id (N'[people].[PersonalTitle]') IS NOT NULL
  DROP TYPE [people].[PersonalTitle];
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"

