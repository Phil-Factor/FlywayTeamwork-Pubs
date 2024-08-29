CREATE TABLE people.Person (
  person_ID INT NOT NULL AUTO_INCREMENT, -- AUTO_INCREMENT for MySQL
  Title VARCHAR(20) NULL, -- Title of the person
  Nickname VARCHAR(40) NULL, -- The way the person is usually addressed
  FirstName VARCHAR(40) NOT NULL, -- The person's first name
  MiddleName VARCHAR(40) NULL, -- Any middle name
  LastName VARCHAR(40) NOT NULL, -- The last name or surname
  Suffix VARCHAR(10) NULL, -- Any suffix used by the person
  fullName VARCHAR(200) AS (
    CONCAT(
      IFNULL(CONCAT(Title, ' '), ''), 
      FirstName, 
      IF(MiddleName IS NOT NULL AND MiddleName != '', CONCAT(' ', MiddleName), ''), 
      ' ', 
      LastName, 
      IF(Suffix IS NOT NULL AND Suffix != '', CONCAT(' ', Suffix), '')
    )
  ) STORED, -- Calculated column
  LegacyIdentifier VARCHAR(30) NULL, -- For more easily adding people in
  ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Default to current timestamp, auto-update on modification
  PRIMARY KEY (person_ID) -- Set PRIMARY KEY constraint
);

CREATE INDEX SearchByPersonLastname
ON people.Person (LastName ASC, FirstName ASC);

CREATE TABLE people.Organisation (
  organisation_ID INT NOT NULL AUTO_INCREMENT, -- AUTO_INCREMENT for MySQL
  OrganisationName VARCHAR(100) NOT NULL,
  LineOfBusiness VARCHAR(100) NOT NULL,
  LegacyIdentifier VARCHAR(30) NULL, -- For more easily adding people in
  ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Default to current timestamp and update on modification
  PRIMARY KEY (organisation_ID) -- Set PRIMARY KEY constraint
);

CREATE INDEX SearchByOrganisationName
ON people.Organisation (OrganisationName ASC);

CREATE TABLE ;(
  Address_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY, -- Surrogate key
  AddressLine1 VARCHAR(60) NULL, -- First line of the address
  AddressLine2 VARCHAR(60) NULL, -- Second line of the address
  City VARCHAR(20) NULL, -- The city
  Region VARCHAR(20) NULL, -- Region or state
  PostalCode VARCHAR(15) NULL, -- The ZIP code or postal code
  Country VARCHAR(50) NULL,
  Full_Address VARCHAR(255) AS (
    TRIM(CONCAT(
      IFNULL(CONCAT(AddressLine1, ', '), ''),
      IFNULL(CONCAT(AddressLine2, ', '), ''),
      IFNULL(CONCAT(City, ', '), ''),
      IFNULL(CONCAT(Region, ', '), ''),
      IFNULL(PostalCode, '')
    ))
  ) STORED, -- Calculated column
  LegacyIdentifier VARCHAR(30) NULL, -- For more easily adding people in
  ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Default to current timestamp and update on modification
  CHECK (
    COALESCE(AddressLine1, AddressLine2, City, PostalCode) IS NOT NULL
  ) -- Ensure the address is valid
);

CREATE TABLE people.AddressType (
  TypeOfAddress VARCHAR(40) NOT NULL PRIMARY KEY, -- Primary Key for address types
  ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- Default to current timestamp and update on modification
);

CREATE TABLE people.Abode (
  Abode_ID INT AUTO_INCREMENT PRIMARY KEY, -- Surrogate key
  Person_id INT NOT NULL, -- ID of the person
  Address_id INT NOT NULL, -- ID of the address
  TypeOfAddress VARCHAR(40) NOT NULL, -- Type of address
  Start_date DATETIME NOT NULL, -- When this relationship started
  End_date DATETIME NULL, -- When this relationship ended
  ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Default to current timestamp and update on modification
  FOREIGN KEY (Person_id) REFERENCES people.Person(person_ID),
  FOREIGN KEY (Address_id) REFERENCES people.Address(Address_ID),
  FOREIGN KEY (TypeOfAddress) REFERENCES people.AddressType(TypeOfAddress)
);

CREATE TABLE people.Location (
  Location_ID INT AUTO_INCREMENT PRIMARY KEY, -- Surrogate key
  organisation_id INT NOT NULL, -- ID of the organisation
  Address_id INT NOT NULL, -- ID of the address
  TypeOfAddress VARCHAR(40) NOT NULL, -- Type of address
  Start_date DATETIME NOT NULL, -- When this relationship started
  End_date DATETIME NULL, -- When this relationship ended
  ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Default to current timestamp and update on modification
  FOREIGN KEY (organisation_id) REFERENCES people.Organisation(organisation_ID),
  FOREIGN KEY (Address_id) REFERENCES people.Address(Address_ID),
  FOREIGN KEY (TypeOfAddress) REFERENCES people.AddressType(TypeOfAddress)
);

CREATE TABLE people.PhoneType (
  TypeOfPhone VARCHAR(40) NOT NULL PRIMARY KEY, -- Primary Key for phone types
  ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- Default to current timestamp and update on modification
);

CREATE TABLE people.Phone (
  Phone_ID INT AUTO_INCREMENT PRIMARY KEY, -- Surrogate key
  Person_id INT NOT NULL, -- ID of the person
  TypeOfPhone VARCHAR(40) NOT NULL, -- Type of phone
  DiallingNumber VARCHAR(20) NOT NULL, -- The actual dialing number
  Start_date DATETIME NOT NULL, -- When we first knew that the person was using the number
  End_date DATETIME NULL, -- When the person stopped using the number
  ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Default to current timestamp and update on modification
  FOREIGN KEY (Person_id) REFERENCES people.Person(person_ID),
  FOREIGN KEY (TypeOfPhone) REFERENCES people.PhoneType(TypeOfPhone)
);

CREATE TABLE people.Note (
  Note_id INT AUTO_INCREMENT PRIMARY KEY, -- Surrogate primary key
  Note TEXT NOT NULL, -- Note content
  NoteStart VARCHAR(850) AS (LEFT(Note, 850)) STORED, -- Calculated column for easier search
  InsertionDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- When the note was inserted
  InsertedBy VARCHAR(128) NOT NULL, -- Who inserted the note
  ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- Default to current timestamp and update on modification
);

-- Create a trigger to set the InsertedBy field to CURRENT_USER()
DELIMITER $$

CREATE TRIGGER people.set_inserted_by BEFORE INSERT ON people.Note
FOR EACH ROW
BEGIN
  SET NEW.InsertedBy = CURRENT_USER();
END$$

DELIMITER ;

CREATE TABLE people.NotePerson (
  NotePerson_id INT AUTO_INCREMENT PRIMARY KEY, -- Surrogate key
  Person_id INT NOT NULL, -- ID of the person
  Note_id INT NOT NULL, -- ID of the note
  InsertionDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- When the note was inserted
  ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Default to current timestamp and update on modification
  UNIQUE (Person_id, Note_id, InsertionDate), -- Constraint to prevent duplicates
  FOREIGN KEY (Person_id) REFERENCES people.Person(person_ID),
  FOREIGN KEY (Note_id) REFERENCES people.Note(Note_id)
);

CREATE TABLE people.CreditCard (
  CreditCardID INT AUTO_INCREMENT PRIMARY KEY, -- Surrogate key
  Person_id INT NOT NULL, -- ID of the person
  CardNumber VARCHAR(20) NOT NULL, -- Card number
  ValidFrom DATE NOT NULL, -- From when the credit card was valid
  ValidTo DATE NOT NULL, -- To when the credit card was valid
  CVC CHAR(3) NOT NULL, -- The CVC
  ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Default to current timestamp and update on modification
  UNIQUE (Person_id, CardNumber), -- Prevent duplicate card numbers
  FOREIGN KEY (Person_id) REFERENCES people.Person(person_ID)
);

CREATE TABLE people.EmailAddress (
  EmailID INT AUTO_INCREMENT PRIMARY KEY, -- Surrogate primary key
  Person_id INT NOT NULL, -- ID of the person
  EmailAddress VARCHAR(40) NOT NULL, -- The actual email address
  StartDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- When we first knew about this email address
  EndDate DATETIME NULL, -- When the person stopped using this address
  ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Default to current timestamp and update on modification
  FOREIGN KEY (Person_id) REFERENCES people.Person(person_ID)
);

-- Now we add the old data into the new framework
INSERT INTO people.Person (legacyIdentifier, Title, Nickname, FirstName, MiddleName, LastName, Suffix)
SELECT CONCAT('au-', au_id), NULL, NULL, au_fname, NULL, au_lname, NULL FROM authors 
UNION ALL
SELECT CONCAT('em-', emp_id), NULL, NULL, fname, minit, lname, NULL FROM employee;

INSERT INTO people.Address (legacyIdentifier, AddressLine2, City, Region, PostalCode, Country)
SELECT CONCAT('au-', au_id), address, city, state, zip, 'USA' FROM dbo.authors;

INSERT IGNORE INTO people.AddressType (TypeOfAddress) VALUES ('Home');

INSERT INTO people.Abode (Person_id, Address_id, TypeOfAddress, Start_date, End_date, ModifiedDate)
SELECT person_id, address_id, 'Home', CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP 
FROM people.Person
INNER JOIN people.Address 
ON Address.LegacyIdentifier = Person.LegacyIdentifier;

-- Add a 'Home' phone-type
INSERT IGNORE INTO people.PhoneType (TypeOfPhone) VALUES ('Home');

INSERT INTO people.Phone (Person_id, TypeOfPhone, DiallingNumber, Start_date)
SELECT person_ID, 'Home', phone, CURRENT_TIMESTAMP FROM dbo.authors
INNER JOIN people.Person ON REPLACE(LegacyIdentifier, 'au-', '') = au_id;

-- Now add the publishers
ALTER TABLE people.Address AUTO_INCREMENT=1000;
INSERT INTO people.Address (legacyIdentifier, AddressLine2, City, Region, PostalCode, Country)
SELECT CONCAT('pub-',pub_id), pub_name, city, state, NULL, country FROM dbo.publishers;

-- Ensure the type of address is in place
INSERT IGNORE INTO people.AddressType (TypeOfAddress) VALUES ('Business');

-- Add the publishers as organisations
INSERT INTO people.Organisation (OrganisationName, LineOfBusiness, LegacyIdentifier, ModifiedDate)
SELECT pub_name, 'Publisher', CONCAT('pub-', pub_id), CURRENT_TIMESTAMP FROM dbo.publishers;

-- Add the publishers' location
INSERT INTO people.Location (organisation_id, Address_id, TypeOfAddress, Start_date)
SELECT organisation_ID, Address_ID, 'Business', CURRENT_TIMESTAMP
FROM people.Organisation
INNER JOIN people.Address 
ON Address.LegacyIdentifier = Organisation.LegacyIdentifier;

-- Create views
CREATE VIEW people.publishers AS
SELECT REPLACE(Address.LegacyIdentifier, 'pub-', '') AS pub_id,
  OrganisationName AS pub_name, City, Region AS state, Country
  FROM people.Organisation
  INNER JOIN people.Location ON Location.organisation_id = Organisation.organisation_ID
  INNER JOIN people.Address ON Address.Address_ID = Location.Address_id
  WHERE LineOfBusiness = 'Publisher' AND End_date IS NULL;

CREATE VIEW people.authors AS
SELECT REPLACE(Address.LegacyIdentifier, 'au-', '') AS au_id,
  LastName AS au_lname, FirstName AS au_fname, DiallingNumber AS phone,
  COALESCE(AddressLine1, '') + COALESCE(' ' + AddressLine2, '') AS address,
  City, Region AS state, PostalCode AS zip
  FROM people.Person
  INNER JOIN people.Abode ON Abode.Person_id = Person.person_ID
  INNER JOIN people.Address ON Address.Address_ID = Abode.Address_id
  LEFT JOIN people.Phone ON Phone.Person_id = Person.person_ID
  WHERE people.Abode.End_date IS NULL 
  AND Phone.End_date IS NULL
  AND Person.LegacyIdentifier LIKE 'au-%';