CREATE TYPE dbo.empid FROM char (9) NOT NULL;

CREATE TYPE dbo.tid FROM varchar (6) NOT NULL;

CREATE TYPE dbo.Dollars FROM numeric (9,2) NOT NULL;

CREATE TYPE dbo.id FROM varchar (11) NOT NULL;

CREATE TYPE people.PersonalName FROM nvarchar (80) NOT NULL;

CREATE TYPE people.PersonalPhoneNumber FROM varchar (20) NOT NULL;

CREATE TYPE people.PersonalAddressline FROM varchar (60) NULL;

CREATE TYPE people.PersonalPostalCode FROM varchar (15) NOT NULL;

CREATE TYPE people.PersonalNote FROM nvarchar (MAX) NOT NULL;

CREATE TYPE people.PersonalCVC FROM char (3) NOT NULL;

CREATE TYPE people.PersonalTitle FROM nvarchar (20) NOT NULL;

CREATE TYPE people.PersonalPaymentCardNumber FROM varchar (20) NOT NULL;

CREATE TYPE people.PersonalLocation FROM varchar (20) NULL;

CREATE TYPE people.PersonalEmailAddress FROM nvarchar (80) NOT NULL;

CREATE TYPE people.PersonalSuffix FROM nvarchar (20) NULL;


CREATE TABLE accounting.Chart_of_Accounts (
      id int
        CONSTRAINT PK__Chart_of__3213E83FA5687BEA PRIMARY KEY (id),
     Name varchar(50)
        CONSTRAINT UQ__Chart_of__737584F696047034 UNIQUE (Name) 
 );

CREATE TABLE dbo.authors (
     /* The authors of the publications. a publication can have one or more author */
 au_id dbo.id -- The key to the Authors Table
        CONSTRAINT UPKCL_auidind PRIMARY KEY (au_id),
     au_lname nvarchar(80), -- last name of the author
     au_fname nvarchar(80), -- first name of the author
     phone nvarchar(40) -- the author's phone number
        CONSTRAINT AssumeUnknown DEFAULT ('UNKNOWN'),
     address nvarchar(80), -- the author=s firest line address
     city nvarchar(40), -- the city where the author lives
     state char(2), -- the state where the author lives
     zip char(5), -- the zip of the address where the author lives
     contract bit -- had the author agreed a contract? 
 );

CREATE TABLE dbo.jobs (
     /* These are the job descriptions and min/max salary level */
 job_id smallint IDENTITY(1,1) -- The surrogate key to the Jobs Table
        CONSTRAINT PK__jobs__6E32B6A51A14E395 PRIMARY KEY (job_id),
     job_desc varchar(50) -- The description of the job
        CONSTRAINT AssumeANewPosition DEFAULT ('New Position - title not formalized yet'),
     min_lvl tinyint, -- the minimum pay level appropriate for the job
     max_lvl tinyint -- the maximum pay level appropriate for the job 
 );

CREATE TABLE dbo.Publication_Types (
     /* An edition can be one of several types */
 Publication_Type nvarchar(20)
        CONSTRAINT PK__Publicat__66D9D2B335D2B455 PRIMARY KEY (Publication_Type) 
 );

CREATE TABLE dbo.publishers (
     /* this is a table of publishers who we distribute books for */
 pub_id char(8) -- The surrogate key to the Publishers Table
        CONSTRAINT UPKCL_pubind PRIMARY KEY (pub_id),
     pub_name nvarchar(100), -- The name of the publisher
     city nvarchar(100), -- the city where this publisher is based
     state char(2), -- Thge state where this publisher is based
     country nvarchar(80) -- The country where this publisher is based
        CONSTRAINT AssumeItsTheSatates DEFAULT ('USA') 
 );

CREATE TABLE dbo.stores (
     /* these are all the stores who are our customers */
 stor_id char(4) -- The primary key to the Store Table
        CONSTRAINT UPK_storeid PRIMARY KEY (stor_id),
     stor_name nvarchar(80), -- The name of the store
     stor_address nvarchar(80), -- The first-line address of the store
     city nvarchar(40), -- The city in which the store is based
     state char(2), -- The state where the store is base
     zip char(5) -- The zipt code for the store 
 );

CREATE TABLE dbo.TagName (
     /* All the categories of publications */
 TagName_ID int IDENTITY(1,1) -- The surrogate key to the Tag Table
        CONSTRAINT TagnameSurrogate PRIMARY KEY (TagName_ID),
     Tag nvarchar(80) -- the name of the tag
        CONSTRAINT Uniquetag UNIQUE (Tag) 
 );

CREATE TABLE people.Address (
     /* This contains the details of an addresss,
any address, it can be a home, office, factory or whatever  */
 Address_ID int IDENTITY(1,1) -- surrogate key 
        CONSTRAINT AddressPK PRIMARY KEY (Address_ID),
     AddressLine1 people.PersonalAddressline, -- first line address
     AddressLine2 people.PersonalAddressline, --  second line address
     City people.PersonalLocation, --  the city
     Region people.PersonalLocation,
     PostalCode people.PersonalPostalCode,
     country nvarchar(50),
     Full_Address  AS (stuff((((coalesce(', '+[AddressLine1],'')+coalesce(', '+[AddressLine2],''))+coalesce(', '+[City],''))+coalesce(', '+[Region],''))+coalesce(', '+[PostalCode],''),(1),(2),'')),
     LegacyIdentifier nvarchar(30),
     ModifiedDate datetime -- when the record was last modified
        CONSTRAINT AddressModifiedDateD DEFAULT (getdate()) 
 );

CREATE TABLE people.AddressType (
     /*  the way that a particular customer is using the address (e.g. Home, Office, hotel etc  */
 TypeOfAddress nvarchar(40) -- description of the type of address
        CONSTRAINT TypeOfAddressPK PRIMARY KEY (TypeOfAddress),
     ModifiedDate datetime -- when was this record LAST modified
        CONSTRAINT AddressTypeModifiedDateD DEFAULT (getdate()) 
 );

CREATE TABLE people.Note (
     /*  a note relating to a customer  */
 Note_id int IDENTITY(1,1) -- Surrogate primary key for the Note
        CONSTRAINT NotePK PRIMARY KEY (Note_id),
     Note people.PersonalNote, -- The actual text of the note
     NoteStart  AS (coalesce(left([Note],(850)),'Blank'+CONVERT([nvarchar](20),rand()*(20)))),
     InsertionDate datetime -- when the note was inserted
        CONSTRAINT NoteInsertionDateDL DEFAULT (getdate()),
     InsertedBy sysname -- Who inserted the note
        CONSTRAINT GetUserName DEFAULT (user_name()),
     ModifiedDate datetime -- when the note  got changed
        CONSTRAINT NoteModifiedDateD DEFAULT (getdate()) 
 );

CREATE TABLE people.Organisation (
      organisation_ID int IDENTITY(1,1)
        CONSTRAINT organisationIDPK PRIMARY KEY (organisation_ID),
     OrganisationName nvarchar(100),
     LineOfBusiness nvarchar(100),
     LegacyIdentifier nvarchar(30),
     ModifiedDate datetime
        CONSTRAINT organisationModifiedDateD DEFAULT (getdate()) 
 );

CREATE TABLE people.Person (
     /*  This table represents a person- can be a customer or a member of staff,or someone in one of the outsourced support agencies */
 person_ID int IDENTITY(1,1) -- 
        CONSTRAINT PersonIDPK PRIMARY KEY (person_ID),
     Title people.PersonalTitle, --  the title (Mr, Mrs, Ms etc
     Nickname people.PersonalName, --  the way the person is usually addressed
     FirstName people.PersonalName, --  the person's first name
     MiddleName people.PersonalName, -- any middle name
     LastName people.PersonalName, --  the lastname or surname
     Suffix people.PersonalSuffix, -- any suffix used by the person
     fullName  AS (((((coalesce([Title]+' ','')+[FirstName])+coalesce(' '+[MiddleName],''))+' ')+[LastName])+coalesce(' '+[Suffix],'')),
     LegacyIdentifier nvarchar(30),
     ModifiedDate datetime -- when the record was last modified
        CONSTRAINT PersonModifiedDateD DEFAULT (getdate()) 
 );

CREATE TABLE people.PhoneType (
     /*  the description of the type of the phone (e.g. Mobile, Home, work)  */
 TypeOfPhone nvarchar(40) -- a description of the type of phone
        CONSTRAINT PhoneTypePK PRIMARY KEY (TypeOfPhone),
     ModifiedDate datetime -- when this record was last modified
        CONSTRAINT PhoneTypeModifiedDateD DEFAULT (getdate()) 
 );

CREATE TABLE people.Word (
      Item varchar(255)
        CONSTRAINT PKWord PRIMARY KEY (Item),
     frequency int
        CONSTRAINT DF__Word__frequency__296D0115 DEFAULT ((0)) 
 );

CREATE TABLE accounting.Bill_Payments (
      id int
        CONSTRAINT PK__Bill_Pay__3213E83F7A77B0C4 PRIMARY KEY (id),
     tran_date date,
     description nvarchar(MAX),
     reference nvarchar(MAX),
     total decimal(20,2),
     Chart_of_Accounts_id int
        CONSTRAINT FK__Bill_Paym__Chart__2C496DC0 FOREIGN KEY (Chart_of_Accounts_id)
               REFERENCES accounting.Chart_of_Accounts (id) 
 );

CREATE TABLE accounting.customer (
      id int
        CONSTRAINT PK__customer__3213E83F2DF13DBF PRIMARY KEY (id),
     person_id int
        CONSTRAINT FK_person_id_Person_id FOREIGN KEY (person_id)
               REFERENCES people.Person (person_ID),
     organisation_id int
        CONSTRAINT FK_organisation_id_organisation_id FOREIGN KEY (organisation_id)
               REFERENCES people.Organisation (organisation_ID),
     CustomerFrom date,
     CustomerTo date,
     ModifiedDate datetime
        CONSTRAINT DF__customer__Modifi__2690946A DEFAULT (getdate()) 
 );

CREATE TABLE accounting.Invoice_Payments (
      id int
        CONSTRAINT PK__Invoice___3213E83F21689241 PRIMARY KEY (id),
     tran_date date,
     description nvarchar(MAX),
     reference nvarchar(MAX),
     total decimal(20,2),
     Chart_of_Accounts_id int
        CONSTRAINT FK__Invoice_P__Chart__33EA8F88 FOREIGN KEY (Chart_of_Accounts_id)
               REFERENCES accounting.Chart_of_Accounts (id),
     ModifiedDate datetime
        CONSTRAINT DF__Invoice_P__Modif__2784B8A3 DEFAULT (getdate()) 
 );

CREATE TABLE accounting.Suppliers (
      id int
        CONSTRAINT PK__Supplier__3213E83F75F279F9 PRIMARY KEY (id),
     supplier_id int
        CONSTRAINT FK_supplier_id_organisation_id FOREIGN KEY (supplier_id)
               REFERENCES people.Organisation (organisation_ID),
     contact_id int
        CONSTRAINT FK_contact_id_organisation_id FOREIGN KEY (contact_id)
               REFERENCES people.Organisation (organisation_ID),
     CustomerFrom date,
     CustomerTo date,
     ModifiedDate datetime
        CONSTRAINT DF__Suppliers__Modif__2878DCDC DEFAULT (getdate()) 
 );

CREATE TABLE dbo.discounts (
     /* These are the discounts offered by the sales people for bulk orders */
 discounttype nvarchar(80), -- The type of discount
     stor_id char(4) -- The store that has the discount
        CONSTRAINT FK__discounts__store FOREIGN KEY (stor_id)
               REFERENCES dbo.stores (stor_id),
     lowqty smallint, -- The lowest order quantity for which the discount applies
     highqty smallint, -- The highest order quantity for which the discount applies
     discount decimal(4,2), -- the percentage discount
     Discount_id int IDENTITY(1,1) -- The surrogate key to the Discounts Table
        CONSTRAINT PK_Discounts PRIMARY KEY (Discount_id) 
 );

CREATE TABLE dbo.employee (
     /* An employee of any of the publishers */
 emp_id dbo.empid -- The key to the Employee Table
        CONSTRAINT PK_emp_id PRIMARY KEY (emp_id),
     fname nvarchar(40), -- first name
     minit char(1), -- middle initial
     lname nvarchar(60), -- last name
     job_id smallint -- the job that the employee does
        CONSTRAINT AssumeJobIDof1 DEFAULT ((1)) 
        CONSTRAINT FK__employee__job_id FOREIGN KEY (job_id)
               REFERENCES dbo.jobs (job_id),
     job_lvl tinyint -- the job level
        CONSTRAINT AssumeJobLevelof10 DEFAULT ((10)),
     pub_id char(8) -- the publisher that the employee works for
        CONSTRAINT AssumeAPub_IDof9952 DEFAULT ('9952') 
        CONSTRAINT FK__employee__pub_id FOREIGN KEY (pub_id)
               REFERENCES dbo.publishers (pub_id),
     hire_date datetime -- the date that the employeee was hired
        CONSTRAINT AssumeAewHire DEFAULT (getdate()) 
 );

CREATE TABLE dbo.pub_info (
     /* this holds the special information about every publisher */
 pub_id char(8) -- The foreign key to the publisher
        CONSTRAINT UPKCL_pubinfo PRIMARY KEY (pub_id) 
        CONSTRAINT FK__pub_info__pub_id FOREIGN KEY (pub_id)
               REFERENCES dbo.publishers (pub_id),
     logo varbinary, -- the publisher's logo
     pr_info nvarchar(MAX) -- The blurb of this publisher 
 );

CREATE TABLE dbo.publications (
     /* This lists every publication marketed by the distributor */
 Publication_id dbo.tid -- The surrogate key to the Publications Table
        CONSTRAINT PK_Publication PRIMARY KEY (Publication_id),
     title nvarchar(255), -- the title of the publicxation
     pub_id char(8) -- the legacy publication key
        CONSTRAINT fkPublishers FOREIGN KEY (pub_id)
               REFERENCES dbo.publishers (pub_id),
     notes nvarchar(4000), -- any notes about this publication
     pubdate datetime -- the date that it was published
        CONSTRAINT pub_NowDefault DEFAULT (getdate()) 
 );

CREATE TABLE people.Abode (
     /*  an abode describes the association has with an address and the period of time when the person had that association */
 Abode_ID int IDENTITY(1,1) -- the surrogate key for the place to which the person is associated
        CONSTRAINT AbodePK PRIMARY KEY (Abode_ID),
     Person_id int -- the id of the person
        CONSTRAINT Abode_PersonFK FOREIGN KEY (Person_id)
               REFERENCES people.Person (person_ID),
     Address_id int -- the id of the address
        CONSTRAINT Abode_AddressFK FOREIGN KEY (Address_id)
               REFERENCES people.Address (Address_ID),
     TypeOfAddress nvarchar(40) -- the type of address
        CONSTRAINT Abode_AddressTypeFK FOREIGN KEY (TypeOfAddress)
               REFERENCES people.AddressType (TypeOfAddress),
     Start_date datetime, -- when this relationship started
     End_date datetime, -- when this relationship ended
     ModifiedDate datetime -- when this record was last modified
        CONSTRAINT AbodeModifiedD DEFAULT (getdate()) 
 );

CREATE TABLE people.CreditCard (
     /*  the customer's credit card details. This is here just because this database is used as a nursery slope to check for personal information  */
 CreditCardID int IDENTITY(1,1) -- Surrogate primary key for the Credit card
        CONSTRAINT CreditCardPK PRIMARY KEY (CreditCardID),
     Person_id int -- foreign key to the person who has the addess
        CONSTRAINT CreditCard_PersonFK FOREIGN KEY (Person_id)
               REFERENCES people.Person (person_ID),
     CardNumber people.PersonalPaymentCardNumber -- The actual card-number
        CONSTRAINT CreditCardWasntUnique UNIQUE (CardNumber),
     ValidFrom date, -- from when the credit card was valid
     ValidTo date, -- to when the credit card was valid
     CVC people.PersonalCVC, -- the CVC
     ModifiedDate datetime -- when was this last modified
        CONSTRAINT CreditCardModifiedDateD DEFAULT (getdate()) ,
     CONSTRAINT DuplicateCreditCardUK UNIQUE (Person_id,CardNumber)
 );

CREATE TABLE people.EmailAddress (
     /*  the email address for the person. a person can have more than one  */
 EmailID int IDENTITY(1,1) -- Surrogate key for the email
        CONSTRAINT EmailPK PRIMARY KEY (EmailID),
     Person_id int -- foreign key to the person who has the addess
        CONSTRAINT EmailAddress_PersonFK FOREIGN KEY (Person_id)
               REFERENCES people.Person (person_ID),
     EmailAddress people.PersonalEmailAddress, -- the actual email address
     StartDate date -- when the customer started using this address
        CONSTRAINT DF__EmailAddr__Start__0347582D DEFAULT (getdate()),
     EndDate date, -- when the customer stopped using this address
     ModifiedDate datetime -- When the email address got modified
        CONSTRAINT EmailAddressModifiedDateD DEFAULT (getdate()) 
 );

CREATE TABLE people.Location (
      Location_ID int IDENTITY(1,1)
        CONSTRAINT LocationPK PRIMARY KEY (Location_ID),
     organisation_id int
        CONSTRAINT Location_organisationFK FOREIGN KEY (organisation_id)
               REFERENCES people.Organisation (organisation_ID),
     Address_id int
        CONSTRAINT Location_AddressFK FOREIGN KEY (Address_id)
               REFERENCES people.Address (Address_ID),
     TypeOfAddress nvarchar(40)
        CONSTRAINT Location_AddressTypeFK FOREIGN KEY (TypeOfAddress)
               REFERENCES people.AddressType (TypeOfAddress),
     Start_date datetime,
     End_date datetime,
     ModifiedDate datetime
        CONSTRAINT LocationModifiedD DEFAULT (getdate()) 
 );

CREATE TABLE people.NotePerson (
     /*  relates a note to a person  */
 NotePerson_id int IDENTITY(1,1) -- Surrogate primary key for the link table
        CONSTRAINT NotePersonPK PRIMARY KEY (NotePerson_id),
     Person_id int -- foreign key to the person who has the addess
        CONSTRAINT NotePerson_PersonFK FOREIGN KEY (Person_id)
               REFERENCES people.Person (person_ID),
     Note_id int -- foreign key to the actual note
        CONSTRAINT NotePerson_NoteFK FOREIGN KEY (Note_id)
               REFERENCES people.Note (Note_id),
     InsertionDate datetime --  whan the note was inserted 
        CONSTRAINT NotePersonInsertionDateD DEFAULT (getdate()),
     ModifiedDate datetime --  whan the association of note with person was last modified 
        CONSTRAINT NotePersonModifiedDateD DEFAULT (getdate()) ,
     CONSTRAINT DuplicateUK UNIQUE (Person_id,Note_id,InsertionDate)
 );

CREATE TABLE people.Phone (
     /*  the actual phone number, and relates it to the person and the type of phone  */
 Phone_ID int IDENTITY(1,1) -- the surrogate key for the phone
        CONSTRAINT PhonePK PRIMARY KEY (Phone_ID),
     Person_id int -- the person who has the phone number
        CONSTRAINT Phone_PersonFK FOREIGN KEY (Person_id)
               REFERENCES people.Person (person_ID),
     TypeOfPhone nvarchar(40) -- the type of phone
        CONSTRAINT FK__Phone__TypeOfPho__6D58170E FOREIGN KEY (TypeOfPhone)
               REFERENCES people.PhoneType (TypeOfPhone),
     DiallingNumber people.PersonalPhoneNumber, -- the actual dialling number
     Start_date datetime, --  when we first knew thet the person was using the number
     End_date datetime, --  if not null, when the person stopped using the number
     ModifiedDate datetime -- when the record was last modified
        CONSTRAINT PhoneModifiedDateD DEFAULT (getdate()) 
 );

CREATE TABLE people.WordOccurence (
      Item varchar(255)
        CONSTRAINT FKWordOccurenceWord FOREIGN KEY (Item)
               REFERENCES people.Word (Item),
     location int,
     Sequence int,
     Note int ,
     CONSTRAINT PKWordOcurrence PRIMARY KEY (Item,Sequence,Note)
 );

CREATE TABLE accounting.Bills (
      id int
        CONSTRAINT PK__Bills__3213E83F609141D2 PRIMARY KEY (id),
     tran_date date,
     due_date date,
     description nvarchar(MAX),
     reference nvarchar(MAX),
     total decimal(10,2),
     status smallint,
     supplier_id int
        CONSTRAINT FK__Bills__supplier___2E31B632 FOREIGN KEY (supplier_id)
               REFERENCES accounting.Suppliers (id),
     bill_payment_id int
        CONSTRAINT FK__Bills__bill_paym__2F25DA6B FOREIGN KEY (bill_payment_id)
               REFERENCES accounting.Bill_Payments (id),
     Chart_of_Accounts_id int
        CONSTRAINT FK__Bills__Chart_of___2D3D91F9 FOREIGN KEY (Chart_of_Accounts_id)
               REFERENCES accounting.Chart_of_Accounts (id) 
 );

CREATE TABLE accounting.Invoices (
      id int
        CONSTRAINT PK__Invoices__3213E83F8A0ADB35 PRIMARY KEY (id),
     tran_date date,
     due_date date,
     description nvarchar(MAX),
     reference nvarchar(MAX),
     total decimal(10,2),
     status smallint,
     customer_id int
        CONSTRAINT FK__Invoices__custom__34DEB3C1 FOREIGN KEY (customer_id)
               REFERENCES accounting.customer (id),
     invoice_payment_id int
        CONSTRAINT FK__Invoices__invoic__35D2D7FA FOREIGN KEY (invoice_payment_id)
               REFERENCES accounting.Invoice_Payments (id),
     Chart_of_Accounts_id int
        CONSTRAINT FK__Invoices__Chart___36C6FC33 FOREIGN KEY (Chart_of_Accounts_id)
               REFERENCES accounting.Chart_of_Accounts (id) 
 );

CREATE TABLE accounting.Received_Moneys (
      id int
        CONSTRAINT PK__Received__3213E83F4D9C1DD1 PRIMARY KEY (id),
     tran_date date,
     description nvarchar(MAX),
     reference nvarchar(MAX),
     total decimal(20,2),
     customer_id int
        CONSTRAINT FK__Received___custo__39A368DE FOREIGN KEY (customer_id)
               REFERENCES accounting.customer (id),
     Chart_of_Accounts_id int
        CONSTRAINT FK__Received___Chart__3A978D17 FOREIGN KEY (Chart_of_Accounts_id)
               REFERENCES accounting.Chart_of_Accounts (id) 
 );

CREATE TABLE accounting.Spent_Moneys (
      id int
        CONSTRAINT PK__Spent_Mo__3213E83FDCD3F1B7 PRIMARY KEY (id),
     tran_date date,
     description nvarchar(MAX),
     reference nvarchar(MAX),
     total decimal(20,2),
     supplier_id int
        CONSTRAINT FK__Spent_Mon__suppl__3E681DFB FOREIGN KEY (supplier_id)
               REFERENCES accounting.Suppliers (id),
     Chart_of_Accounts_id int
        CONSTRAINT FK__Spent_Mon__Chart__3D73F9C2 FOREIGN KEY (Chart_of_Accounts_id)
               REFERENCES accounting.Chart_of_Accounts (id) 
 );

CREATE TABLE dbo.editions (
     /* A publication can come out in several different editions, of maybe a different type */
 Edition_id int IDENTITY(1,1) -- The surrogate key to the Editions Table
        CONSTRAINT PK_editions PRIMARY KEY (Edition_id),
     publication_id dbo.tid -- the foreign key to the publication
        CONSTRAINT fk_edition FOREIGN KEY (publication_id)
               REFERENCES dbo.publications (Publication_id),
     Publication_type nvarchar(20) -- the type of publication
        CONSTRAINT DF__editions__Public__2200E977 DEFAULT ('book') 
        CONSTRAINT fk_Publication_Type FOREIGN KEY (Publication_type)
               REFERENCES dbo.Publication_Types (Publication_Type),
     EditionDate datetime2 -- the date at which this edition was created
        CONSTRAINT DF__editions__Editio__22F50DB0 DEFAULT (getdate()) 
 );

CREATE TABLE dbo.roysched (
     /* this is a table of the authors royalty schedule */
 title_id dbo.tid -- The title to which this applies
        CONSTRAINT FK__roysched__title FOREIGN KEY (title_id)
               REFERENCES dbo.publications (Publication_id),
     lorange int, -- the lowest range to which the royalty applies
     hirange int, -- the highest range to which this royalty applies
     royalty int, -- the royalty
     roysched_id int IDENTITY(1,1) -- The surrogate key to the RoySched Table
        CONSTRAINT PK_Roysched PRIMARY KEY (roysched_id) 
 );

CREATE TABLE dbo.sales (
     /* these are the sales of every edition of every publication */
 stor_id char(4) -- The store for which the sales apply
        CONSTRAINT FK_Sales_Stores FOREIGN KEY (stor_id)
               REFERENCES dbo.stores (stor_id),
     ord_num nvarchar(40), -- the reference to the order
     ord_date datetime, -- the date of the order
     qty smallint, -- the quantity ordered
     payterms nvarchar(40), -- the pay terms
     title_id dbo.tid -- foreign key to the title
        CONSTRAINT FK_Sales_Title FOREIGN KEY (title_id)
               REFERENCES dbo.publications (Publication_id) ,
     CONSTRAINT UPKCL_sales PRIMARY KEY (stor_id,ord_num,title_id)
 );

CREATE TABLE dbo.TagTitle (
     /* This relates tags (e.g. crime) to publications so that publications can have more than one */
 TagTitle_ID int IDENTITY(1,1), -- The surrogate key to the TagTitle Table
     title_id dbo.tid -- The foreign key to the title
        CONSTRAINT FKTitle_id FOREIGN KEY (title_id)
               REFERENCES dbo.publications (Publication_id),
     Is_Primary bit -- is this the primary tag (e.g. 'Fiction')
        CONSTRAINT NotPrimary DEFAULT ((0)),
     TagName_ID int -- The foreign key to the tagname
        CONSTRAINT fkTagname FOREIGN KEY (TagName_ID)
               REFERENCES dbo.TagName (TagName_ID) ,
     CONSTRAINT PK_TagNameTitle PRIMARY KEY (title_id,TagName_ID)
 );

CREATE TABLE dbo.titleauthor (
     /* this is a table that relates authors to publications, and gives their order of listing and royalty */
 au_id dbo.id -- Foreign key to the author
        CONSTRAINT FK__titleauth__au_id FOREIGN KEY (au_id)
               REFERENCES dbo.authors (au_id),
     title_id dbo.tid -- Foreign key to the publication
        CONSTRAINT FK__titleauth__title FOREIGN KEY (title_id)
               REFERENCES dbo.publications (Publication_id),
     au_ord tinyint, --  the order in which authors are listed
     royaltyper int -- the royalty percentage figure ,
     CONSTRAINT UPKCL_taind PRIMARY KEY (au_id,title_id)
 );

CREATE TABLE accounting.Bill_Lines (
      id int
        CONSTRAINT PK__Bill_Lin__3213E83F03EFF334 PRIMARY KEY (id),
     line_amount decimal(20,2),
     bill_id int
        CONSTRAINT FK__Bill_Line__bill___2A61254E FOREIGN KEY (bill_id)
               REFERENCES accounting.Bills (id),
     line_Chart_of_Accounts_id int
        CONSTRAINT FK__Bill_Line__line___2B554987 FOREIGN KEY (line_Chart_of_Accounts_id)
               REFERENCES accounting.Chart_of_Accounts (id) 
 );

CREATE TABLE accounting.Invoice_Lines (
      id int
        CONSTRAINT PK__Invoice___3213E83F1470A0AA PRIMARY KEY (id),
     line_amount decimal(20,2),
     invoice_id int
        CONSTRAINT FK__Invoice_L__invoi__32F66B4F FOREIGN KEY (invoice_id)
               REFERENCES accounting.Invoices (id),
     line_Chart_of_Accounts_id int
        CONSTRAINT FK__Invoice_L__line___32024716 FOREIGN KEY (line_Chart_of_Accounts_id)
               REFERENCES accounting.Chart_of_Accounts (id) 
 );

CREATE TABLE accounting.Received_Money_Lines (
      id int
        CONSTRAINT PK__Received__3213E83F690C6CED PRIMARY KEY (id),
     line_amount decimal(20,2),
     received_money_id int
        CONSTRAINT FK__Received___recei__37BB206C FOREIGN KEY (received_money_id)
               REFERENCES accounting.Received_Moneys (id),
     line_Chart_of_Accounts_id int
        CONSTRAINT FK__Received___line___38AF44A5 FOREIGN KEY (line_Chart_of_Accounts_id)
               REFERENCES accounting.Chart_of_Accounts (id) 
 );

CREATE TABLE accounting.Spent_Money_Lines (
      id int
        CONSTRAINT PK__Spent_Mo__3213E83FC7711242 PRIMARY KEY (id),
     line_amount decimal(20,2),
     spent_money_id int
        CONSTRAINT FK__Spent_Mon__spent__3B8BB150 FOREIGN KEY (spent_money_id)
               REFERENCES accounting.Spent_Moneys (id),
     line_Chart_of_Accounts_id int
        CONSTRAINT FK__Spent_Mon__line___3C7FD589 FOREIGN KEY (line_Chart_of_Accounts_id)
               REFERENCES accounting.Chart_of_Accounts (id) 
 );

CREATE TABLE dbo.prices (
     /* these are the current prices of every edition of every publication */
 Price_id int IDENTITY(1,1) -- The surrogate key to the Prices Table
        CONSTRAINT PK_Prices PRIMARY KEY (Price_id),
     Edition_id int -- The edition that this price applies to
        CONSTRAINT fk_prices FOREIGN KEY (Edition_id)
               REFERENCES dbo.editions (Edition_id),
     price dbo.Dollars, -- the price in dollars
     advance dbo.Dollars, -- the advance to the authors
     royalty int, -- the royalty
     ytd_sales int, -- the current sales this year
     PriceStartDate datetime2 -- the start date for which this price applies
        CONSTRAINT DF__prices__PriceSta__25D17A5B DEFAULT (getdate()),
     PriceEndDate datetime2 -- null if the price is current, otherwise the date at which it was supoerceded 
 );

GO
/* Create the accounting Bill_Trans View  */
CREATE VIEW accounting.Bill_Trans
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
/* Create the accounting Invoice_Trans View  */
CREATE VIEW accounting.Invoice_Trans
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
/* Create the accounting Received_Money_Trans View  */
CREATE VIEW accounting.Received_Money_Trans
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
/* Create the accounting Spent_Money_Trans View  */
CREATE VIEW accounting.Spent_Money_Trans
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
/* Create the dbo titles View  */
CREATE VIEW dbo.titles
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
/* Create the people authors View  */
CREATE VIEW People.authors
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
/* Create the people publishers View  */
CREATE VIEW People.publishers
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
/* Create the accounting Trial_Balance View  */
CREATE VIEW accounting.Trial_Balance
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
/* Create the dbo PublishersByPublicationType View  */
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
/* Create the dbo TitlesAndEditionsByPublisher View  */
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
/* Create the dbo titleview View  */
CREATE VIEW [dbo].[titleview]
AS
SELECT title, au_ord, au_lname, price, ytd_sales, pub_id
  FROM authors, titles, titleauthor
  WHERE authors.au_id = titleauthor.au_id
    AND titles.title_id = titleauthor.title_id;


GO
/* Create the table valued function dbo.SearchNotes */
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
/* Create the table valued function dbo.FindWords */
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
/* Create the table valued function dbo.IterativeWordChop */
CREATE FUNCTION dbo.IterativeWordChop
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
/* Create the table valued function dbo.FindString */
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
/* Create the table valued function dbo.SplitStringToWords */
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
/* Create the scalar function dbo.SentenceFrom */
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
/* Create the stored procedure dbo.reptq2 */
CREATE PROCEDURE dbo.reptq2
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
/* Create the stored procedure dbo.reptq1 */
CREATE PROCEDURE reptq1
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
/* Create the stored procedure dbo.byroyalty */
CREATE PROCEDURE byroyalty @percentage INT
AS
  BEGIN
    SELECT titleauthor.au_id
      FROM dbo.titleauthor AS titleauthor
      WHERE titleauthor.royaltyper = @percentage;
  END;


GO
/* Create the stored procedure dbo.reptq3 */
CREATE PROCEDURE dbo.reptq3 @lolimit dbo.Dollars, @hilimit dbo.Dollars,
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

