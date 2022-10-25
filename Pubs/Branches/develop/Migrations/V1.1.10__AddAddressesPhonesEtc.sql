--only create the People schema if it does not exist
IF EXISTS (SELECT * FROM sys.schemas WHERE schemas.name LIKE 'People') SET NOEXEC ON;
GO
CREATE SCHEMA People;
GO

--
SET NOEXEC OFF;

--delete the table with all the foreign key references in it
IF Object_Id('People.EmailAddress') IS NOT NULL DROP TABLE People.EmailAddress;
GO

IF Object_Id('People.Abode') IS NOT NULL DROP TABLE People.Abode;
GO

IF Object_Id('People.NotePerson') IS NOT NULL DROP TABLE People.NotePerson;
GO
IF Object_Id('People.Note') IS NOT NULL DROP TABLE People.Note;
GO
IF Object_Id('People.Phone') IS NOT NULL DROP TABLE People.Phone;
GO

IF Object_Id('People.CreditCard') IS NOT NULL DROP TABLE People.CreditCard;
GO

IF Object_Id('People.Person') IS NOT NULL DROP TABLE People.Person;
GO
IF Object_Id('People.Location') IS NOT NULL DROP TABLE People.Location;
GO
IF Object_Id('People.Address') IS NOT NULL DROP TABLE People.Address;
GO



DROP TYPE IF EXISTS People.PersonalName;
DROP TYPE IF EXISTS People.PersonalTitle;
DROP TYPE IF EXISTS People.PersonalPhoneNumber;
DROP TYPE IF EXISTS People.PersonalAddressline;
DROP TYPE IF EXISTS People.PersonalLocation;
DROP TYPE IF EXISTS People.PersonalPostalCode;
DROP TYPE IF EXISTS People.PersonalSuffix;
DROP TYPE IF EXISTS People.PersonalNote;
DROP TYPE IF EXISTS People.PersonalPaymentCardNumber;
DROP TYPE IF EXISTS People.PersonalEmailAddress;
DROP TYPE IF EXISTS People.PersonalCVC

CREATE TYPE People.PersonalName FROM NVARCHAR(40) NOT null;
CREATE TYPE People.PersonalTitle FROM NVARCHAR(10) NOT null;
CREATE TYPE People.PersonalNote FROM NVARCHAR(Max) NOT null;
CREATE TYPE People.PersonalPhoneNumber FROM VARCHAR(20) NOT null;
CREATE TYPE People.PersonalAddressline FROM VARCHAR(60);
CREATE TYPE People.PersonalLocation FROM VARCHAR(20);
CREATE TYPE People.PersonalPostalCode FROM VARCHAR(15) NOT null;
CREATE TYPE People.PersonalEmailAddress FROM NVARCHAR(40) NOT null;
CREATE TYPE People.PersonalSuffix FROM NVARCHAR(10);
CREATE TYPE People.PersonalPaymentCardNumber FROM VARCHAR(20) NOT null;
CREATE TYPE People.PersonalCVC FROM CHAR(3) NOT NULL
GO


/* This table represents a person- can be a People or a member of staff,
or someone in one of the outsourced support agencies*/
CREATE TABLE People.Person
  (
  person_ID INT NOT NULL IDENTITY CONSTRAINT PersonIDPK PRIMARY KEY,--  has to be surrogate
  Title People.PersonalTitle null, -- the title (Mr, Mrs, Ms etc
  Nickname People.PersonalName null, -- the way the person is usually addressed
  FirstName People.PersonalName NOT null, -- the person's first name
  MiddleName People.PersonalName null, --any middle name 
  LastName People.PersonalName NOT null, -- the lastname or surname 
  Suffix People.PersonalSuffix NULL, --any suffix used by the person
  fullName AS --A calculated column
    (Coalesce(Title + ' ', '') + FirstName + Coalesce(' ' + MiddleName, '')
     + ' ' + LastName + Coalesce(' ' + Suffix, '')
    ),
  LegacyIdentifier NVARCHAR(30) NULL, --for more easily adding people in
  ModifiedDate DATETIME NOT NULL --when the record was last modified
    CONSTRAINT PersonModifiedDateD DEFAULT GetDate() --the current date by default
  );

CREATE NONCLUSTERED INDEX SearchByPersonLastname /* this is an index associated with 
People.Person */
ON People.Person (LastName ASC, FirstName ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,
     DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON,
     ALLOW_PAGE_LOCKS = ON
     );
GO

/* This table represents a organisation- can be a People or a member of staff,
or someone in one of the outsourced support agencies*/
CREATE TABLE People.Organisation
  (
  organisation_ID INT NOT NULL IDENTITY CONSTRAINT organisationIDPK PRIMARY KEY,--  has to be surrogate
  OrganisationName nvarchar(100) NOT null,
  LineOfBusiness nvarchar(100) NOT null,
  LegacyIdentifier NVARCHAR(30) NULL, --for more easily adding people in
  ModifiedDate DATETIME NOT NULL --when the record was last modified
    CONSTRAINT organisationModifiedDateD DEFAULT GetDate() --the current date by default
  );

CREATE NONCLUSTERED INDEX SearchByOrganisationName /* this is an index associated with 
People.Organisation */
ON People.Organisation (OrganisationName ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,
     DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON,
     ALLOW_PAGE_LOCKS = ON
     );
GO

CREATE TABLE People.Address /*This contains the details of an addresss,
any address, it can be a home, office, factory or whatever */
  (
  Address_ID INT IDENTITY /*surrogate key */ CONSTRAINT AddressPK PRIMARY KEY,--the unique key 
  AddressLine1 People.PersonalAddressline NULL, --first line address
  AddressLine2 People.PersonalAddressline NULL,/* second line address */
  City People.PersonalLocation NULL,/* the city */
  Region People.PersonalLocation NULL, /* Region or state */
  PostalCode People.PersonalPostalCode NULL, ---the zip code or post code
  country NVARCHAR(50) NULL,
  Full_Address AS --A calculated column
    (Stuff(
            Coalesce(', ' + AddressLine1, '')
            + Coalesce(', ' + AddressLine2, '') + Coalesce(', ' + City, '')
            + Coalesce(', ' + Region, '') + Coalesce(', ' + PostalCode, ''),
            1,
            2,
            ''
          )
    ),
  LegacyIdentifier NVARCHAR(30) NULL, --for more easily adding people in
  ModifiedDate DATETIME NOT NULL --when the record was last modified
    CONSTRAINT AddressModifiedDateD DEFAULT GetDate(), --if necessary, now.
  CONSTRAINT Address_Not_Complete CHECK (Coalesce(
AddressLine1, AddressLine2, City, PostalCode
) IS NOT NULL
)
  );--check to ensure that the address was valid
GO

IF Object_Id('People.AddressType') IS NOT NULL DROP TABLE People.AddressType;
GO

CREATE TABLE People.AddressType /* the  way that a particular People is using
the address (e.g. Home, Office, hotel etc */
  (
  TypeOfAddress NVARCHAR(40) NOT NULL --description of the type of address
    CONSTRAINT TypeOfAddressPK PRIMARY KEY, --ensure that there are no duplicates
  ModifiedDate DATETIME NOT NULL --when was this record LAST modified
    CONSTRAINT AddressTypeModifiedDateD DEFAULT GetDate()-- in case nobody fills it in
  );
GO

IF Object_Id('People.Abode') IS NOT NULL DROP TABLE People.Abode;
GO

CREATE TABLE People.Abode /* an abode describes the association has with an
address and  the period of time when the person had that association*/
  (
  Abode_ID INT IDENTITY --the surrogate key
     CONSTRAINT AbodePK PRIMARY KEY, --because it is the only unique column
  Person_id INT NOT NULL --the id of the person
     CONSTRAINT Abode_PersonFK FOREIGN KEY REFERENCES People.Person,
  Address_id INT NOT NULL --the id of the address
     CONSTRAINT Abode_AddressFK FOREIGN KEY REFERENCES People.Address,
  TypeOfAddress NVARCHAR(40) NOT NULL --the type of address
     CONSTRAINT Abode_AddressTypeFK FOREIGN KEY REFERENCES People.AddressType,
  Start_date DATETIME NOT NULL, --when this relationship started 
  End_date DATETIME NULL, --when this relationship ended
  ModifiedDate DATETIME NOT NULL --when this record was last modified
     CONSTRAINT AbodeModifiedD DEFAULT GetDate()--when the abode record was created/modified
  );

  IF Object_Id('People.Location') IS NOT NULL DROP TABLE People.Location;
GO

CREATE TABLE People.Location /* an location describes the association has with an
organisation and  the period of time when the organisation had that association*/
  (
  Location_ID INT IDENTITY --the surrogate key
     CONSTRAINT LocationPK PRIMARY KEY, --because it is the only unique column
  organisation_id INT NOT NULL --the id of the organisation
     CONSTRAINT Location_organisationFK FOREIGN KEY REFERENCES People.organisation,
  Address_id INT NOT NULL --the id of the address
     CONSTRAINT Location_AddressFK FOREIGN KEY REFERENCES People.Address,
  TypeOfAddress NVARCHAR(40) NOT NULL --the type of address
     CONSTRAINT Location_AddressTypeFK FOREIGN KEY REFERENCES People.AddressType,
  Start_date DATETIME NOT NULL, --when this relationship started 
  End_date DATETIME NULL, --when this relationship ended
  ModifiedDate DATETIME NOT NULL --when this record was last modified
     CONSTRAINT LocationModifiedD DEFAULT GetDate()--when the Location record was created/modified
  );

IF Object_Id('People.PhoneType') IS NOT NULL DROP TABLE People.PhoneType;
GO
/* the description of the type of the phone (e.g. Mobile, Home, work) */
CREATE TABLE People.PhoneType
  (
  TypeOfPhone NVARCHAR(40) NOT NULL
  --a description of the type of phone
    CONSTRAINT PhoneTypePK PRIMARY KEY,-- assures unique and indexed
  ModifiedDate DATETIME NOT NULL --when this record was last modified
    CONSTRAINT PhoneTypeModifiedDateD DEFAULT GetDate()
	--when the abode record was created/modified
  );


CREATE TABLE People.Phone 
/* the actual phone number, and relates it to the person and the type of phone */
  (
  Phone_ID INT IDENTITY --the surrogate key
    CONSTRAINT PhonePK PRIMARY KEY, --defunes the phone_id as being the primry key
  Person_id INT NOT NULL --the person who has the phone number
    CONSTRAINT Phone_PersonFK FOREIGN KEY REFERENCES People.Person,
  TypeOfPhone NVARCHAR(40) NOT NULL /*the type of phone*/ FOREIGN KEY REFERENCES People.PhoneType,
  DiallingNumber  People.PersonalPhoneNumber NOT null,--the actual dialling number 
  Start_date  DATETIME NOT NULL, -- when we first knew thet the person was using the number
  End_date DATETIME NULL, -- if not null, when the person stopped using the number
  ModifiedDate DATETIME NULL --when the record was last modified
    CONSTRAINT PhoneModifiedDateD DEFAULT GetDate()-- to make data entry easier!
  );

CREATE TABLE People.Note /* a note relating to a People */
  (
  Note_id INT IDENTITY CONSTRAINT NotePK PRIMARY KEY, --the surrogate primary key
  Note People.PersonalNote NOT null,
  NoteStart AS
    Coalesce(Left(Note, 850), 'Blank' + Convert(NvARCHAR(20), Rand() * 20))
	/*making it easier to search ...*/,
  --CONSTRAINT NoteStartUQ UNIQUE,
  InsertionDate DATETIME NOT NULL --when the note was inserted
    CONSTRAINT NoteInsertionDateDL DEFAULT GetDate(),
  InsertedBy sysname NOT NULL CONSTRAINT GetUserName DEFAULT CURRENT_USER, ---who inserted it
  /* we add a ModifiedDate as usual */
  ModifiedDate DATETIME NOT NULL CONSTRAINT NoteModifiedDateD DEFAULT GetDate()
  );

CREATE TABLE People.NotePerson /* relates a note to a person */
  (
  NotePerson_id INT IDENTITY CONSTRAINT NotePersonPK PRIMARY KEY,
  Person_id INT NOT NULL CONSTRAINT NotePerson_PersonFK FOREIGN KEY REFERENCES People.Person,
  --the person to whom the note applies
  Note_id INT NOT NULL CONSTRAINT NotePerson_NoteFK FOREIGN KEY REFERENCES People.Note,
  /* the note that applies to the person */
  InsertionDate DATETIME NOT NULL /* whan the note was inserted */
    CONSTRAINT NotePersonInsertionDateD DEFAULT GetDate(),
  ModifiedDate DATETIME NOT NULL /* whan the note was last modified */
    CONSTRAINT NotePersonModifiedDateD DEFAULT GetDate(),
  CONSTRAINT DuplicateUK UNIQUE (Person_id, Note_id, InsertionDate) 
  /* constraint to prevent duplicates*/
  );

/* the People's credit card details. This is here just because this database is used as 
a nursery slope to check for personal information */
CREATE TABLE People.CreditCard
  (
  CreditCardID INT IDENTITY NOT NULL CONSTRAINT CreditCardPK PRIMARY KEY,
  Person_id INT NOT NULL CONSTRAINT CreditCard_PersonFK FOREIGN KEY REFERENCES People.Person,
  CardNumber People.PersonalPaymentCardNumber NOT NULL CONSTRAINT CreditCardWasntUnique UNIQUE, 
  ValidFrom DATE NOT NULL,--from when the credit card was valid
  ValidTo DATE NOT NULL,--to when the credit card was valid
  CVC People.PersonalCVC NOT null,--the CVC
  ModifiedDate DATETIME NOT NULL--when was this last modified
    CONSTRAINT CreditCardModifiedDateD DEFAULT (GetDate()),-- if not specified, it was now
  CONSTRAINT DuplicateCreditCardUK UNIQUE (Person_id, CardNumber) --prevend duplicate card numbers
  );
/* the email address for the person. a person can have more than one */
CREATE TABLE People.EmailAddress
  (
  EmailID INT IDENTITY(1, 1) NOT NULL CONSTRAINT EmailPK PRIMARY KEY,--surrogate primary key 
  Person_id INT NOT NULL CONSTRAINT EmailAddress_PersonFK FOREIGN KEY REFERENCES People.Person, /*
  make the connectiopn between the person and the email address */
  EmailAddress People.PersonalEmailAddress  NOT NULL, --the actual email address
  StartDate DATE NOT NULL DEFAULT (GetDate()),--when we first knew about this email address
  EndDate DATE NULL,--when the People stopped using this address
  ModifiedDate DATETIME NOT NULL
    CONSTRAINT EmailAddressModifiedDateD DEFAULT (GetDate()),
  ) ON [PRIMARY];
GO

/* now we add the old data into the new framework */
INSERT INTO people.Person (legacyIdentifier, Title, Nickname, FirstName, MiddleName, LastName, Suffix)
SELECT 'au-'+au_id, NULL, NULL, au_fname,NULL, au_lname, NULL FROM authors 
UNION ALL
SELECT 'em-'+emp_id, NULL,NULL, fname, minit, lname, NULL  FROM employee

INSERT INTO people.Address(legacyIdentifier, AddressLine2, City,Region,PostalCode, country)
SELECT  'au-'+au_id,address, city, state, zip,'USA' FROM dbo.authors

IF NOT EXISTS (SELECT * FROM People.AddressType WHERE TypeOfAddress='Home')
INSERT INTO People.AddressType(TypeOfAddress) SELECT 'Home'

INSERT INTO People.Abode (Person_id, Address_id, TypeOfAddress, Start_date,
End_date, ModifiedDate)
select person_id, address_id, 'home', GetDate(), NULL, GetDate()  
FROM People.Person
INNER JOIN People.Address 
ON Address.LegacyIdentifier = Person.LegacyIdentifier
--add a 'home' phone-type
IF NOT EXISTS (SELECT * FROM People.PhoneType WHERE TypeOfPhone='Home')
INSERT INTO People.PhoneType (TypeOfPhone)
VALUES
  (N'Home' -- TypeOfPhone - nvarchar(40)
  )
INSERT INTO People.Phone (Person_id, TypeOfPhone, DiallingNumber, Start_date)
SELECT person_ID,'Home', phone, GetDate() FROM dbo.authors
INNER JOIN people.Person
ON Replace(LegacyIdentifier,'au-','')=au_id

/* Now add the publishers 
*/
INSERT INTO people.Address(legacyIdentifier, AddressLine2, City,Region,PostalCode,Country)
SELECT  'pub-'+Convert(VARCHAR(5),pub_id), pub_name, city, state, NULL ,country FROM dbo.publishers
--make sure the type of address in in-place
IF NOT EXISTS (SELECT * FROM People.AddressType WHERE TypeOfAddress='Business')
INSERT INTO People.AddressType(TypeOfAddress) SELECT 'Business'
--add the publishers as organisations
INSERT INTO People.Organisation (OrganisationName, LineOfBusiness,
LegacyIdentifier, ModifiedDate)
SELECT  pub_name,'Publisher','pub-'+Convert(VARCHAR(5),pub_id),GetDate() FROM dbo.publishers
--now we add the publishers location in
INSERT INTO People.Location (organisation_id, Address_id, TypeOfAddress,Start_date)
SELECT organisation_ID,  Address_ID, 'Business',GetDate()
       FROM People.Organisation
INNER JOIN People.Address 
ON Address.LegacyIdentifier = organisation.LegacyIdentifier

go
CREATE VIEW People.publishers --provides all organisations that are publishers
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
CREATE VIEW /* provides a legacy 'authors table */ People.authors
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
go

--SELECT @@TranCount
--ROLLBACK TRANSACTION
--SELECT object_schema_name(object_id)+'.'+name FROM sys.tables
