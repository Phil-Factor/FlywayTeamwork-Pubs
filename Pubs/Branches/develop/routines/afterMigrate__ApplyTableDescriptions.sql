PRINT 'Adding the descriptions for all tables and columns'

/*The script to make this JSON document is published here.
https://www.red-gate.com/hub/product-learning/flyway/managing-database-documentation-during-flyway-based-development
Flyway will produce this as a routine if you want, using 
 DatabaseBuildAndMigrateTasks.ps1 
 */
DECLARE @JSONTablesAndColumns NVARCHAR(MAX) =
  N'[
[
   {
      "TableObjectName":"dbo.publications",
      "Type":"user table",
      "Description":"This lists every publication marketed by the distributor",
      "Brief":"Current books etc",
      "TheColumns":{
         "Publication_id":"The surrogate key to the Publications Table",
         "title":"the title of the publicxation",
         "pub_id":"the legacy publication key",
         "notes":"any notes about this publication",
         "pubdate":"the date that it was published"
      }
   },
   {
      "TableObjectName":"dbo.employee_insupd",
      "Type":"Trigger",
      "Description":"Checks the salary level for the job",
      "Brief":"Checks salary",
      "TheColumns":{
      }
   },
   {
      "TableObjectName":"dbo.editions",
      "Type":"user table",
      "Description":"A publication can come out in several different editions, of maybe a different type",
      "Brief":"the editions of the publication",
      "TheColumns":{
         "Edition_id":"The surrogate key to the Editions Table",
         "publication_id":"the foreign key to the publication",
         "Publication_type":"the type of publication",
         "EditionDate":"the date at which this edition was created"
      }
   },
   {
      "TableObjectName":"dbo.prices",
      "Type":"user table",
      "Description":"these are the current prices of every edition of every publication",
      "Brief":"price for each edition of a book",
      "TheColumns":{
         "Price_id":"The surrogate key to the Prices Table",
         "Edition_id":"The edition that this price applies to",
         "price":"the price in dollars",
         "advance":"the advance to the authors",
         "royalty":"the royalty",
         "ytd_sales":"the current sales this year",
         "PriceStartDate":"the start date for which this price applies",
         "PriceEndDate":"null if the price is current, otherwise the date at which it was supoerceded"
      }
   },
   {
      "TableObjectName":"dbo.TagName",
      "Type":"user table",
      "Description":"All the categories of publications",
      "Brief":"publication category",
      "TheColumns":{
         "TagName_ID":"The surrogate key to the Tag Table",
         "Tag":"the name of the tag"
      }
   },
   {
      "TableObjectName":"dbo.TagTitle",
      "Type":"user table",
      "Description":"This relates tags (e.g. crime) to publications so that publications can have more than one",
      "Brief":"Tags for a publication",
      "TheColumns":{
         "TagTitle_ID":"The surrogate key to the TagTitle Table",
         "title_id":"The foreign key to the title",
         "Is_Primary":"is this the primary tag (e.g. ''Fiction'')",
         "TagName_ID":"The foreign key to the tagname"
      }
   },
   {
      "TableObjectName":"dbo.employee",
      "Type":"user table",
      "Description":"An employee of any of the publishers",
      "Brief":"a publishers employees",
      "TheColumns":{
         "emp_id":"The key to the Employee Table",
         "fname":"first name",
         "minit":"middle initial",
         "lname":"last name",
         "job_id":"the job that the employee does",
         "job_lvl":"the job level",
         "pub_id":"the publisher that the employee works for",
         "hire_date":"the date that the employeee was hired"
      }
   },
   {
      "TableObjectName":"dbo.jobs",
      "Type":"user table",
      "Description":"These are the job descriptions and min\/max salary level",
      "Brief":"Job descriptions",
      "TheColumns":{
         "job_id":"The surrogate key to the Jobs Table",
         "job_desc":"The description of the job",
         "min_lvl":"the minimum pay level appropriate for the job",
         "max_lvl":"the maximum pay level appropriate for the job"
      }
   },
   {
      "TableObjectName":"dbo.stores",
      "Type":"user table",
      "Description":"these are all the stores who are our customers",
      "Brief":"bookshops and stores",
      "TheColumns":{
         "stor_id":"The primary key to the Store Table",
         "stor_name":"The name of the store",
         "stor_address":"The first-line address of the store",
         "city":"The city in which the store is based",
         "state":"The state where the store is base",
         "zip":"The zipt code for the store"
      }
   },
   {
      "TableObjectName":"dbo.discounts",
      "Type":"user table",
      "Description":"These are the discounts offered by the sales people for bulk orders",
      "Brief":"bulk discounts",
      "TheColumns":{
         "discounttype":"The type of discount",
         "stor_id":"The store that has the discount",
         "lowqty":"The lowest order quantity for which the discount applies",
         "highqty":"The highest order quantity for which the discount applies",
         "discount":"the percentage discount",
         "Discount_id":"The surrogate key to the Discounts Table"
      }
   },
   {
      "TableObjectName":"dbo.publishers",
      "Type":"user table",
      "Description":"this is a table of publishers who we distribute books for",
      "Brief":"client publishers",
      "TheColumns":{
         "pub_id":"The surrogate key to the Publishers Table",
         "pub_name":"The name of the publisher",
         "city":"the city where this publisher is based",
         "state":"Thge state where this publisher is based",
         "country":"The country where this publisher is based"
      }
   },
   {
      "TableObjectName":"dbo.pub_info",
      "Type":"user table",
      "Description":"this holds the special information about every publisher",
      "Brief":"extended publisher info",
      "TheColumns":{
         "pub_id":"The foreign key to the publisher",
         "logo":"the publisher''s logo",
         "pr_info":"The blurb of this publisher"
      }
   },
   {
      "TableObjectName":"dbo.roysched",
      "Type":"user table",
      "Description":"this is a table of the authors royalty schedule",
      "Brief":"royalty schedule",
      "TheColumns":{
         "title_id":"The title to which this applies",
         "lorange":"the lowest range to which the royalty applies",
         "hirange":"the highest range to which this royalty applies",
         "royalty":"the royalty",
         "roysched_id":"The surrogate key to the RoySched Table"
      }
   },
   {
      "TableObjectName":"dbo.sales",
      "Type":"user table",
      "Description":"these are the sales of every edition of every publication",
      "Brief":"sales per edition",
      "TheColumns":{
         "stor_id":"The store for which the sales apply",
         "ord_num":"the reference to the order",
         "ord_date":"the date of the order",
         "qty":"the quantity ordered",
         "payterms":"the pay terms",
         "title_id":"foreign key to the title"
      }
   },
   {
      "TableObjectName":"dbo.authors",
      "Type":"user table",
      "Description":"The authors of the publications. a publication can have one or more author",
      "Brief":"authors of publications",
      "TheColumns":{
         "au_id":"The key to the Authors Table",
         "au_lname":"last name of the author",
         "au_fname":"first name of the author",
         "phone":"the author''s phone number",
         "address":"the author=s firest line address",
         "city":"the city where the author lives",
         "state":"the state where the author lives",
         "zip":"the zip of the address where the author lives",
         "contract":"had the author agreed a contract?"
      }
   },
   {
      "TableObjectName":"dbo.titleauthor",
      "Type":"user table",
      "Description":"this is a table that relates authors to publications, and gives their order of listing and royalty",
      "Brief":"publication authors by order",
      "TheColumns":{
         "au_id":"Foreign key to the author",
         "title_id":"Foreign key to the publication",
         "au_ord":" the order in which authors are listed",
         "royaltyper":"the royalty percentage figure"
      }
   },
   {
      "TableObjectName":"dbo.titleview",
      "Type":"view",
      "Description":"This shows the authors for every title ",
      "Brief":"author list for titles",
      "TheColumns":{
         "title":"the name of the title",
         "au_ord":"order in which the authors are listed",
         "au_lname":"author last name",
         "price":"the price of the title",
         "ytd_sales":"year to date sales",
         "pub_id":"the id if the publisher"
      }
   },
   {
      "TableObjectName":"dbo.titles",
      "Type":"view",
      "Description":"This mimics the old Titles Table",
      "Brief":"imitates legacy titles",
      "TheColumns":{
         "title_id":"The primary key to the Titles table",
         "title":"the name of the title",
         "Type":"the type/tag",
         "pub_id":"the id of the publisher",
         "price":"the price of the publication",
         "advance":"the advance",
         "royalty":"the royalty",
         "ytd_sales":"Year to date sales for the title",
         "notes":"Notes about the title",
         "pubdate":"Date of publication"
      }
   },
   {
      "TableObjectName":"dbo.PublishersByPublicationType",
      "Type":"view",
      "Description":"A view to provide the number of each type of publication produced by each publishe",
      "Brief":"publishersPublications",
      "TheColumns":{
         "publisher":"Name of the publisher",
         "AudioBook":"audiobook sales",
         "Book":"Book sales",
         "Calendar":"Calendar sales",
         "Ebook":"Ebook sales",
         "Hardback":"Hardback sales",
         "Map":"Map sales",
         "PaperBack":"Paperback sales",
         "total":"Total sales"
      }
   },
   {
      "TableObjectName":"dbo.TitlesAndEditionsByPublisher",
      "Type":"view",
      "Description":"A view to provide the number of each type of publication produced by each publisher",
      "Brief":"Titles And Editions By Publisher",
      "TheColumns":{
          "Publisher":"Name of publisher",
		  "Title":"the name of the title",
		  "Listofeditions":"a list of editions with its price"
      }
   },
   {
      "TableObjectName":"People.Person",
      "Type":"user table",
      "Description":" This table represents a person- can be a customer or a member of staff,or someone in one of the outsourced support agencies",
      "Brief":"any type of person in the system",
      "TheColumns":{
         "person_ID":"",
         "Title":" the title (Mr, Mrs, Ms etc",
         "Nickname":" the way the person is usually addressed",
         "FirstName":" the person''s first name",
         "MiddleName":"any middle name ",
         "LastName":" the lastname or surname ",
         "Suffix":"any suffix used by the person",
         "fullName":"A calculated column",
         "ModifiedDate":"when the record was last modified"
      }
   },
   {
      "TableObjectName":"People.Address",
      "Type":"user table",
      "Description":"This contains the details of an addresss,\r\nany address, it can be a home, office, factory or whatever ",
      "Brief":"all addresses",
      "TheColumns":{
         "Address_ID":"surrogate key ",
         "AddressLine1":"first line address",
         "AddressLine2":" second line address ",
         "City":" the city ",
         "County":" county or state ",
         "PostCode":"-the zip code or post code",
         "Full_Address":"A calculated column",
         "ModifiedDate":"when the record was last modified"
      }
   },
   {
      "TableObjectName":"People.AddressType",
      "Type":"user table",
      "Description":" the way that a particular customer is using the address (e.g. Home, Office, hotel etc ",
      "Brief":"type of address",
      "TheColumns":{
         "TypeOfAddress":"description of the type of address",
         "ModifiedDate":"when was this record LAST modified"
      }
   },
   {
      "TableObjectName":"People.Abode",
      "Type":"user table",
      "Description":" an abode describes the association has with an address and the period of time when the person had that association",
      "Brief":"relates person to an address",
      "TheColumns":{
         "Abode_ID":"the surrogate key for the place to which the person is associated",
         "Person_id":"the id of the person",
         "Address_id":"the id of the address",
         "TypeOfAddress":"the type of address",
         "Start_date":"when this relationship started ",
         "End_date":"when this relationship ended",
         "ModifiedDate":"when this record was last modified"
      }
   },
   {
      "TableObjectName":"People.PhoneType",
      "Type":"user table",
      "Description":" the description of the type of the phone (e.g. Mobile, Home, work) ",
      "Brief":"type of phone",
      "TheColumns":{
         "TypeOfPhone":"a description of the type of phone",
         "ModifiedDate":"when this record was last modified"
      }
   },
   {
      "TableObjectName":"People.Phone",
      "Type":"user table",
      "Description":" the actual phone number, and relates it to the person and the type of phone ",
      "Brief":"all phone numbers",
      "TheColumns":{
         "Phone_ID":"the surrogate key for the phone",
         "Person_id":"the person who has the phone number",
         "TypeOfPhone":"the type of phone",
         "DiallingNumber":"the actual dialling number ",
         "Start_date":" when we first knew thet the person was using the number",
         "End_date":" if not null, when the person stopped using the number",
         "ModifiedDate":"when the record was last modified"
      }
   },
   {
      "TableObjectName":"People.Note",
      "Type":"user table",
      "Description":" a note relating to a customer ",
      "Brief":"correspondence",
      "TheColumns":{
         "Note_id":"Surrogate primary key for the Note",
         "Note":"The actual text of the note",
         "NoteStart":"making it easier to search ...CONSTRAINT NoteStartUQ UNIQUE,",
         "InsertionDate":"when the note was inserted",
         "InsertedBy":"Who inserted the note",
         "ModifiedDate":"when the note  got changed"
      }
   },
   {
      "TableObjectName":"People.NotePerson",
      "Type":"user table",
      "Description":" relates a note to a person ",
       "Brief":"who wrote the note",
     "TheColumns":{
         "NotePerson_id":"Surrogate primary key for the link table",
         "Person_id":"foreign key to the person who has the addess",
         "Note_id":"foreign key to the actual note",
         "InsertionDate":" whan the note was inserted ",
         "ModifiedDate":" whan the association of note with person was last modified "
      }
   },
   {
      "TableObjectName":"People.CreditCard",
      "Type":"user table",
      "Description":" the customer''s credit card details. This is here just because this database is used as a nursery slope to check for personal information ",
      "Brief":"credit cards",
      "TheColumns":{
         "CreditCardID":"Surrogate primary key for the Credit card",
         "Person_id":"foreign key to the person who has the addess",
         "CardNumber":"The actual card-number",
         "ValidFrom":"from when the credit card was valid",
         "ValidTo":"to when the credit card was valid",
         "CVC":"the CVC",
         "ModifiedDate":"when was this last modified"
      }
   },
   {
      "TableObjectName":"People.EmailAddress",
      "Type":"user table",
      "Description":" the email address for the person. a person can have more than one ",
      "Brief":"email address",
      "TheColumns":{
         "EmailID":"Surrogate key for the email",
         "Person_id":"foreign key to the person who has the addess",
         "EmailAddress":"the actual email address",
         "StartDate":"when the customer started using this address",
         "EndDate":"when the customer stopped using this address",
         "ModifiedDate":"When the email address got modified"
      }
   },
   {
      "TableObjectName":"dbo.SplitStringToWords",
      "Type":"Function",
      "Description":"splits strings into words for indexing",
      "Brief":"string splitter",
      "TheColumns":{
      }
   }
 ]
';

DECLARE @TableSourceToDocument TABLE
  (
  TheOrder INT IDENTITY,
  TableObjectName sysname NOT NULL,
  ObjectType NVARCHAR(60) NOT NULL,
  TheDescription NVARCHAR(3750) NOT NULL,
  TheColumns NVARCHAR(MAX) NOT NULL
  );
DECLARE @ColumnToDocument TABLE
  (
  TheOrder INT IDENTITY,
  TheDescription NVARCHAR(3750) NOT NULL,
  Level0Name sysname NOT NULL,
  ObjectType VARCHAR(128) NOT NULL,
  TableObjectName sysname NOT NULL,
  Level2Name sysname NOT NULL
  );
DECLARE @ii INT, @iiMax INT; --the iterators
--the values fetched for each row
DECLARE @TableObjectName sysname, @ObjectType NVARCHAR(60),
  @Schemaname sysname, @TheDescription NVARCHAR(3750),
  @TheColumns NVARCHAR(MAX), @Object_id INT, @Level0Name sysname,
  @Level2Name sysname, @TypeCode CHAR(2);

INSERT INTO @TableSourceToDocument (TableObjectName, ObjectType,
TheDescription, TheColumns)
  SELECT TableObjectName, [Type], [Description], TheColumns
    FROM
    OpenJson(@JSONTablesAndColumns)
    WITH
      (
      TableObjectName sysname, [Type] NVARCHAR(20),
      [Description] NVARCHAR(3700), TheColumns NVARCHAR(MAX) AS JSON
      );
--initialise the iterator
SELECT @ii = 1, @iiMax = Max(TheOrder) FROM @TableSourceToDocument;
--loop through them all, adding the description of the table where possible
WHILE @ii <= @iiMax
  BEGIN
    SELECT @Schemaname = Object_Schema_Name(Object_Id(TableObjectName)),
      @TableObjectName = Object_Name(Object_Id(TableObjectName)),
      @ObjectType =
        CASE WHEN ObjectType LIKE '%TABLE' THEN 'TABLE'
          WHEN ObjectType LIKE 'VIEW' THEN 'VIEW' ELSE 'FUNCTION' END,
      @TypeCode = CASE ObjectType WHEN 'clr table valued function' THEN 'FT'
                    WHEN 'sql inline table valued function' THEN 'IF'
                    WHEN 'sql table valued function' THEN 'TF'
                    WHEN 'user table' THEN 'U' ELSE 'View' END,
      @TheColumns = TheColumns, @TheDescription = TheDescription,
      @Object_id = Object_Id(TableObjectName, @TypeCode)
      FROM @TableSourceToDocument
      WHERE @ii = TheOrder;
    IF (@Object_id IS NOT NULL) --if the table exists
      BEGIN
        IF NOT EXISTS --does the extended property exist?
          (
          SELECT 1
-- SQL Prompt formatting off
          FROM sys.fn_listextendedproperty(
		  N'MS_Description', N'SCHEMA', @Schemaname,
          @ObjectType, @TableObjectName,NULL,NULL
          )
        )
 -- SQL Prompt formatting on 
          EXEC sys.sp_addextendedproperty @name = N'MS_Description',
            @value = @TheDescription, @level0type = N'SCHEMA',
            @level0name = @Schemaname, @level1type = @ObjectType,
            @level1name = @TableObjectName;;
        ELSE
          EXEC sys.sp_updateextendedproperty @name = N'MS_Description',
            @value = @TheDescription, @level0type = N'SCHEMA',
            @level0name = @Schemaname, @level1type = @ObjectType,
            @level1name = @TableObjectName;
        --and add in the columns to annotate
        INSERT INTO @ColumnToDocument (TheDescription, Level0Name,
        ObjectType, TableObjectName, Level2Name)
          SELECT [Value], @Schemaname, @ObjectType, @TableObjectName, [Key]
            FROM OpenJson(@TheColumns);
      END;
    SELECT @ii = @ii + 1; -- on to the next one
  END;

SELECT @ii = 1, @iiMax = Max(TheOrder) FROM @ColumnToDocument;
--loop through them all, adding the description of the table where possible
WHILE @ii <= @iiMax
  BEGIN
    SELECT @TheDescription = TheDescription, @Level0Name = Level0Name,
      @ObjectType = ObjectType, @TableObjectName = TableObjectName,
      @Level2Name = Level2Name
      FROM @ColumnToDocument
      WHERE @ii = TheOrder;
    IF EXISTS --does the column exist?
      (
      SELECT 1
        FROM sys.columns c
        WHERE c.name LIKE @Level2Name
          AND c.object_id = Object_Id(@Level0Name + '.' + @TableObjectName)
      )
      BEGIN --IF the column exists then apply the extended property
        IF NOT EXISTS --does the extended property already exist?
          (
-- SQL Prompt formatting off
          SELECT 1 --does the EP exist?
            FROM sys.fn_listextendedproperty(
                N'MS_Description',N'SCHEMA',@Level0Name,
                @ObjectType,@TableObjectName,N'Column',
                @Level2Name
				)
          )--add it
-- SQL Prompt formatting on
          EXEC sys.sp_addextendedproperty @name = N'MS_Description',
            @value = @TheDescription, @level0type = N'SCHEMA',
            @level0name = @Level0Name, @level1type = @ObjectType,
            @level1name = @TableObjectName, @level2type = N'Column',
            @level2name = @Level2Name;
        ELSE --update it 
          EXEC sys.sp_updateextendedproperty @name = N'MS_Description',
            @value = @TheDescription, @level0type = N'SCHEMA',
            @level0name = @Level0Name, @level1type = @ObjectType,
            @level1name = @TableObjectName, @level2type = N'Column',
            @level2name = @Level2Name;
      END;
    SELECT @ii = @ii + 1; -- on to the next one
  END;
GO


