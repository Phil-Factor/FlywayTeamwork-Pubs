-- ------------------------------------------------------
--  File created - Thursday-March-29-2018   
-- ------------------------------------------------------
-- ------------------------------------------------------
--  DDL for Table CATEGORIES
-- ------------------------------------------------------

  CREATE TABLE "CATEGORIES" 
   (	"CATEGORY_ID" NUMBER(9,0), 
	"CATEGORY_NAME" VARCHAR2(15 BYTE), 
	"DESCRIPTION" VARCHAR2(2000 BYTE), 
	"PICTURE" VARCHAR2(255 BYTE)
   ) ;
   COMMENT ON COLUMN "CATEGORIES"."CATEGORY_ID" IS 'Number automatically assigned to a new category.';
   COMMENT ON COLUMN "CATEGORIES"."CATEGORY_NAME" IS 'Name of food category.';
   COMMENT ON COLUMN "CATEGORIES"."PICTURE" IS 'A picture representing the food category.';
--------------------------------------------------------
--  DDL for Table CUSTOMERS
--------------------------------------------------------

  CREATE TABLE "CUSTOMERS" 
   (	"CUSTOMER_ID" NUMBER(9,0), 
	"CUSTOMER_CODE" VARCHAR2(5 BYTE), 
	"COMPANY_NAME" VARCHAR2(40 BYTE), 
	"CONTACT_NAME" VARCHAR2(30 BYTE), 
	"CONTACT_TITLE" VARCHAR2(30 BYTE), 
	"ADDRESS" VARCHAR2(60 BYTE), 
	"CITY" VARCHAR2(15 BYTE), 
	"REGION" VARCHAR2(15 BYTE), 
	"POSTAL_CODE" VARCHAR2(10 BYTE), 
	"COUNTRY" VARCHAR2(15 BYTE), 
	"PHONE" VARCHAR2(24 BYTE), 
	"FAX" VARCHAR2(24 BYTE)
   );

   COMMENT ON COLUMN "CUSTOMERS"."CUSTOMER_ID" IS 'Unique five-character code based on customer name.';
   COMMENT ON COLUMN "CUSTOMERS"."ADDRESS" IS 'Street or post-office box.';
   COMMENT ON COLUMN "CUSTOMERS"."REGION" IS 'State or province.';
   COMMENT ON COLUMN "CUSTOMERS"."PHONE" IS 'Phone number includes country code or area code.';
   COMMENT ON COLUMN "CUSTOMERS"."FAX" IS 'Phone number includes country code or area code.';
--------------------------------------------------------
--  DDL for Table EMPLOYEES
--------------------------------------------------------

  CREATE TABLE "EMPLOYEES" 
   (	"EMPLOYEE_ID" NUMBER(9,0), 
	"LASTNAME" VARCHAR2(20 BYTE), 
	"FIRSTNAME" VARCHAR2(10 BYTE), 
	"TITLE" VARCHAR2(30 BYTE), 
	"TITLE_OF_COURTESY" VARCHAR2(25 BYTE), 
	"BIRTHDATE" DATE, 
	"HIREDATE" DATE, 
	"ADDRESS" VARCHAR2(60 BYTE), 
	"CITY" VARCHAR2(15 BYTE), 
	"REGION" VARCHAR2(15 BYTE), 
	"POSTAL_CODE" VARCHAR2(10 BYTE), 
	"COUNTRY" VARCHAR2(15 BYTE), 
	"HOME_PHONE" VARCHAR2(24 BYTE), 
	"EXTENSION" VARCHAR2(4 BYTE), 
	"PHOTO" VARCHAR2(255 BYTE), 
	"NOTES" VARCHAR2(2000 BYTE), 
	"REPORTS_TO" NUMBER(9,0)
   );

   COMMENT ON COLUMN "EMPLOYEES"."EMPLOYEE_ID" IS 'Number automatically assigned to new employee.';
   COMMENT ON COLUMN "EMPLOYEES"."TITLE" IS 'Employee''s title.';
   COMMENT ON COLUMN "EMPLOYEES"."TITLE_OF_COURTESY" IS 'Title used in salutations.';
   COMMENT ON COLUMN "EMPLOYEES"."ADDRESS" IS 'Street or post-office box.';
   COMMENT ON COLUMN "EMPLOYEES"."REGION" IS 'State or province.';
   COMMENT ON COLUMN "EMPLOYEES"."HOME_PHONE" IS 'Phone number includes country code or area code.';
   COMMENT ON COLUMN "EMPLOYEES"."EXTENSION" IS 'Internal telephone extension number.';
   COMMENT ON COLUMN "EMPLOYEES"."PHOTO" IS 'Picture of employee.';
   COMMENT ON COLUMN "EMPLOYEES"."NOTES" IS 'General information about employee''s background.';
   COMMENT ON COLUMN "EMPLOYEES"."REPORTS_TO" IS 'Employee''s supervisor.';
--------------------------------------------------------
--  DDL for Table ORDERS
--------------------------------------------------------

  CREATE TABLE "ORDERS" 
   (	"ORDER_ID" NUMBER(9,0), 
	"CUSTOMER_ID" NUMBER(9,0), 
	"EMPLOYEE_ID" NUMBER(9,0), 
	"ORDER_DATE" DATE, 
	"REQUIRED_DATE" DATE, 
	"SHIPPED_DATE" DATE, 
	"SHIP_VIA" NUMBER(9,0), 
	"FREIGHT" NUMBER(10,2) DEFAULT 0, 
	"SHIP_NAME" VARCHAR2(40 BYTE), 
	"SHIP_ADDRESS" VARCHAR2(60 BYTE), 
	"SHIP_CITY" VARCHAR2(15 BYTE), 
	"SHIP_REGION" VARCHAR2(15 BYTE), 
	"SHIP_POSTAL_CODE" VARCHAR2(10 BYTE), 
	"SHIP_COUNTRY" VARCHAR2(15 BYTE)
   ) ;

   COMMENT ON COLUMN "ORDERS"."ORDER_ID" IS 'Unique order number.';
   COMMENT ON COLUMN "ORDERS"."CUSTOMER_ID" IS 'Same entry as in Customers table.';
   COMMENT ON COLUMN "ORDERS"."EMPLOYEE_ID" IS 'Same entry as in Employees table.';
   COMMENT ON COLUMN "ORDERS"."SHIP_VIA" IS 'Same as Shipper ID in Shippers table.';
   COMMENT ON COLUMN "ORDERS"."SHIP_NAME" IS 'Name of person or company to receive the shipment.';
   COMMENT ON COLUMN "ORDERS"."SHIP_ADDRESS" IS 'Street address only -- no post-office box allowed.';
   COMMENT ON COLUMN "ORDERS"."SHIP_REGION" IS 'State or province.';
--------------------------------------------------------
--  DDL for Table ORDER_DETAILS
--------------------------------------------------------

  CREATE TABLE "ORDER_DETAILS" 
   (	"ORDER_ID" NUMBER(9,0), 
	"PRODUCT_ID" NUMBER(9,0), 
	"UNIT_PRICE" NUMBER(10,2) DEFAULT 0, 
	"QUANTITY" NUMBER(9,0) DEFAULT 1, 
	"DISCOUNT" NUMBER(4,2) DEFAULT 0
   ) ;

   COMMENT ON COLUMN "ORDER_DETAILS"."ORDER_ID" IS 'Same as Order ID in Orders table.';
   COMMENT ON COLUMN "ORDER_DETAILS"."PRODUCT_ID" IS 'Same as Product ID in Products table.';
--------------------------------------------------------
--  DDL for Table PRODUCTS
--------------------------------------------------------

  CREATE TABLE "PRODUCTS" 
   (	"PRODUCT_ID" NUMBER(9,0), 
	"PRODUCT_NAME" VARCHAR2(40 BYTE), 
	"SUPPLIER_ID" NUMBER(9,0), 
	"CATEGORY_ID" NUMBER(9,0), 
	"QUANTITY_PER_UNIT" VARCHAR2(20 BYTE), 
	"UNIT_PRICE" NUMBER(10,2) DEFAULT 0, 
	"UNITS_IN_STOCK" NUMBER(9,0) DEFAULT 0, 
	"UNITS_ON_ORDER" NUMBER(9,0) DEFAULT 0, 
	"REORDER_LEVEL" NUMBER(9,0) DEFAULT 0, 
	"DISCONTINUED" CHAR(1 BYTE) DEFAULT 'N'
   );

   COMMENT ON COLUMN "PRODUCTS"."PRODUCT_ID" IS 'Number automatically assigned to new product.';
   COMMENT ON COLUMN "PRODUCTS"."SUPPLIER_ID" IS 'Same entry as in Suppliers table.';
   COMMENT ON COLUMN "PRODUCTS"."CATEGORY_ID" IS 'Same entry as in Categories table.';
   COMMENT ON COLUMN "PRODUCTS"."QUANTITY_PER_UNIT" IS '(e.g., 24-count case, 1-liter bottle).';
   COMMENT ON COLUMN "PRODUCTS"."REORDER_LEVEL" IS 'Minimum units to maintain in stock.';
   COMMENT ON COLUMN "PRODUCTS"."DISCONTINUED" IS 'Yes means item is no longer available.';
--------------------------------------------------------
--  DDL for Table SHIPPERS
--------------------------------------------------------

  CREATE TABLE "SHIPPERS" 
   (	"SHIPPER_ID" NUMBER(9,0), 
	"COMPANY_NAME" VARCHAR2(40 BYTE), 
	"PHONE" VARCHAR2(24 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table SUPPLIERS
--------------------------------------------------------

  CREATE TABLE "SUPPLIERS" 
   (	"SUPPLIER_ID" NUMBER(9,0), 
	"COMPANY_NAME" VARCHAR2(40 BYTE), 
	"CONTACT_NAME" VARCHAR2(30 BYTE), 
	"CONTACT_TITLE" VARCHAR2(30 BYTE), 
	"ADDRESS" VARCHAR2(60 BYTE), 
	"CITY" VARCHAR2(15 BYTE), 
	"REGION" VARCHAR2(15 BYTE), 
	"POSTAL_CODE" VARCHAR2(10 BYTE), 
	"COUNTRY" VARCHAR2(15 BYTE), 
	"PHONE" VARCHAR2(24 BYTE), 
	"FAX" VARCHAR2(24 BYTE), 
	"HOME_PAGE" VARCHAR2(500 BYTE)
   ) ;

   COMMENT ON COLUMN "SUPPLIERS"."SUPPLIER_ID" IS 'Number automatically assigned to new supplier.';
   COMMENT ON COLUMN "SUPPLIERS"."ADDRESS" IS 'Street or post-office box.';
   COMMENT ON COLUMN "SUPPLIERS"."REGION" IS 'State or province.';
   COMMENT ON COLUMN "SUPPLIERS"."PHONE" IS 'Phone number includes country code or area code.';
   COMMENT ON COLUMN "SUPPLIERS"."FAX" IS 'Phone number includes country code or area code.';
   COMMENT ON COLUMN "SUPPLIERS"."HOME_PAGE" IS 'Supplier''s home page on World Wide Web.';
--------------------------------------------------------
--  DDL for Sequence SEQ_NW_CATEGORIES
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_NW_CATEGORIES"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 9 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_NW_CUSTOMERS
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_NW_CUSTOMERS"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 92 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_NW_EMPLOYEES
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_NW_EMPLOYEES"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 10 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_NW_ORDERS
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_NW_ORDERS"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 11018 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_NW_PRODUCTS
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_NW_PRODUCTS"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 78 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_NW_SHIPPERS
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_NW_SHIPPERS"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 4 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_NW_SUPPLIERS
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_NW_SUPPLIERS"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 30 NOCACHE  NOORDER  NOCYCLE ;
-- INSERTING into CATEGORIES
-- 
Insert into CATEGORIES (CATEGORY_ID,CATEGORY_NAME,DESCRIPTION,PICTURE) values (1,'Beverages','Soft drinks, coffees, teas, beers, and ales','beverages.gif');
Insert into CATEGORIES (CATEGORY_ID,CATEGORY_NAME,DESCRIPTION,PICTURE) values (2,'Condiments','Sweet and savory sauces, relishes, spreads, and seasonings','condiments.gif');
Insert into CATEGORIES (CATEGORY_ID,CATEGORY_NAME,DESCRIPTION,PICTURE) values (3,'Confections','Desserts, candies, and sweet breads','confections.gif');
Insert into CATEGORIES (CATEGORY_ID,CATEGORY_NAME,DESCRIPTION,PICTURE) values (4,'Dairy Products','Cheeses','diary.gif');
Insert into CATEGORIES (CATEGORY_ID,CATEGORY_NAME,DESCRIPTION,PICTURE) values (5,'Grains/Cereals','Breads, crackers, pasta, and cereal','cereals.gif');
Insert into CATEGORIES (CATEGORY_ID,CATEGORY_NAME,DESCRIPTION,PICTURE) values (6,'Meat/Poultry','Prepared meats','meat.gif');
Insert into CATEGORIES (CATEGORY_ID,CATEGORY_NAME,DESCRIPTION,PICTURE) values (7,'Produce','Dried fruit and bean curd','produce.gif');
Insert into CATEGORIES (CATEGORY_ID,CATEGORY_NAME,DESCRIPTION,PICTURE) values (8,'Seafood','Seaweed and fish','seafood.gif');
-- INSERTING into CUSTOMERS
-- 
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (1,'ALFKI','Alfreds Futterkiste','Maria Anders','Sales Representative','Obere Str. 57','Berlin',null,'12209','Germany','030-0074321','030-0076545');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (2,'ANATR','Ana Trujillo Emparedados y helados','Ana Trujillo','Owner','Avda. de la Constituci?n 2222','M?xico D.F.',null,'05021','Mexico','(5) 555-4729','(5) 555-3745');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (3,'ANTON','Antonio Moreno Taquer?a','Antonio Moreno','Owner','Mataderos  2312','M?xico D.F.',null,'05023','Mexico','(5) 555-3932',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (4,'AROUT','Around the Horn','Thomas Hardy','Sales Representative','120 Hanover Sq.','London',null,'WA1 1DP','UK','(171) 555-7788','(171) 555-6750');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (5,'BERGS','Berglunds snabbk?p','Christina Berglund','Order Administrator','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden','0921-12 34 65','0921-12 34 67');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (6,'BLAUS','Blauer See Delikatessen','Hanna Moos','Sales Representative','Forsterstr. 57','Mannheim',null,'68306','Germany','0621-08460','0621-08924');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (7,'BLONP','Blondel p?re et fils','Fr?d?rique Citeaux','Marketing Manager','24, place Kl?ber','Strasbourg',null,'67000','France','88.60.15.31','88.60.15.32');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (8,'BOLID','B?lido Comidas preparadas','Mart?n Sommer','Owner','C/ Araquil, 67','Madrid',null,'28023','Spain','(91) 555 22 82','(91) 555 91 99');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (9,'BONAP','Bon app''','Laurence Lebihan','Owner','12, rue des Bouchers','Marseille',null,'13008','France','91.24.45.40','91.24.45.41');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (10,'BOTTM','Bottom-Dollar Markets','Elizabeth Lincoln','Accounting Manager','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada','(604) 555-4729','(604) 555-3745');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (11,'BSBEV','B''s Beverages','Victoria Ashworth','Sales Representative','Fauntleroy Circus','London',null,'EC2 5NT','UK','(171) 555-1212',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (12,'CACTU','Cactus Comidas para llevar','Patricio Simpson','Sales Agent','Cerrito 333','Buenos Aires',null,'1010','Argentina','(1) 135-5555','(1) 135-4892');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (13,'CENTC','Centro comercial Moctezuma','Francisco Chang','Marketing Manager','Sierras de Granada 9993','M?xico D.F.',null,'05022','Mexico','(5) 555-3392','(5) 555-7293');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (14,'CHOPS','Chop-suey Chinese','Yang Wang','Owner','Hauptstr. 29','Bern',null,'3012','Switzerland','0452-076545',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (15,'COMMI','Com?rcio Mineiro','Pedro Afonso','Sales Associate','Av. dos Lus?adas, 23','S?o Paulo','SP','05432-043','Brazil','(11) 555-7647',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (16,'CONSH','Consolidated Holdings','Elizabeth Brown','Sales Representative','Berkeley Gardens
12  Brewery ','London',null,'WX1 6LT','UK','(171) 555-2282','(171) 555-9199');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (17,'DRACD','Drachenblut Delikatessen','Sven Ottlieb','Order Administrator','Walserweg 21','Aachen',null,'52066','Germany','0241-039123','0241-059428');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (18,'DUMON','Du monde entier','Janine Labrune','Owner','67, rue des Cinquante Otages','Nantes',null,'44000','France','40.67.88.88','40.67.89.89');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (19,'EASTC','Eastern Connection','Ann Devon','Sales Agent','35 King George','London',null,'WX3 6FW','UK','(171) 555-0297','(171) 555-3373');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (20,'ERNSH','Ernst Handel','Roland Mendel','Sales Manager','Kirchgasse 6','Graz',null,'8010','Austria','7675-3425','7675-3426');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (21,'FAMIA','Familia Arquibaldo','Aria Cruz','Marketing Assistant','Rua Or?s, 92','S?o Paulo','SP','05442-030','Brazil','(11) 555-9857',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (22,'FISSA','FISSA Fabrica Inter. Salchichas S.A.','Diego Roel','Accounting Manager','C/ Moralzarzal, 86','Madrid',null,'28034','Spain','(91) 555 94 44','(91) 555 55 93');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (23,'FOLIG','Folies gourmandes','Martine Ranc?','Assistant Sales Agent','184, chauss?e de Tournai','Lille',null,'59000','France','20.16.10.16','20.16.10.17');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (24,'FOLKO','Folk och f? HB','Maria Larsson','Owner','?kergatan 24','Br?cke',null,'S-844 67','Sweden','0695-34 67 21',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (25,'FRANK','Frankenversand','Peter Franken','Marketing Manager','Berliner Platz 43','M?nchen',null,'80805','Germany','089-0877310','089-0877451');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (26,'FRANR','France restauration','Carine Schmitt','Marketing Manager','54, rue Royale','Nantes',null,'44000','France','40.32.21.21','40.32.21.20');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (27,'FRANS','Franchi S.p.A.','Paolo Accorti','Sales Representative','Via Monte Bianco 34','Torino',null,'10100','Italy','011-4988260','011-4988261');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (28,'FURIB','Furia Bacalhau e Frutos do Mar','Lino Rodriguez ','Sales Manager','Jardim das rosas n. 32','Lisboa',null,'1675','Portugal','(1) 354-2534','(1) 354-2535');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (29,'GALED','Galer?a del gastr?nomo','Eduardo Saavedra','Marketing Manager','Rambla de Catalu?a, 23','Barcelona',null,'08022','Spain','(93) 203 4560','(93) 203 4561');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (30,'GODOS','Godos Cocina T?pica','Jos? Pedro Freyre','Sales Manager','C/ Romero, 33','Sevilla',null,'41101','Spain','(95) 555 82 82',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (31,'GOURL','Gourmet Lanchonetes','Andr? Fonseca','Sales Associate','Av. Brasil, 442','Campinas','SP','04876-786','Brazil','(11) 555-9482',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (32,'GREAL','Great Lakes Food Market','Howard Snyder','Marketing Manager','2732 Baker Blvd.','Eugene','OR','97403','USA','(503) 555-7555',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (33,'GROSR','GROSELLA-Restaurante','Manuel Pereira','Owner','5? Ave. Los Palos Grandes','Caracas','DF','1081','Venezuela','(2) 283-2951','(2) 283-3397');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (34,'HANAR','Hanari Carnes','Mario Pontes','Accounting Manager','Rua do Pa?o, 67','Rio de Janeiro','RJ','05454-876','Brazil','(21) 555-0091','(21) 555-8765');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (35,'HILAA','HILARI?N-Abastos','Carlos Hern?ndez','Sales Representative','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela','(5) 555-1340','(5) 555-1948');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (36,'HUNGC','Hungry Coyote Import Store','Yoshi Latimer','Sales Representative','City Center Plaza
516 Main St.','Elgin','OR','97827','USA','(503) 555-6874','(503) 555-2376');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (37,'HUNGO','Hungry Owl All-Night Grocers','Patricia McKenna','Sales Associate','8 Johnstown Road','Cork','Co. Cork',null,'Ireland','2967 542','2967 3333');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (38,'ISLAT','Island Trading','Helen Bennett','Marketing Manager','Garden House
Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK','(198) 555-8888',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (39,'KOENE','K?niglich Essen','Philip Cramer','Sales Associate','Maubelstr. 90','Brandenburg',null,'14776','Germany','0555-09876',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (40,'LACOR','La corne d''abondance','Daniel Tonini','Sales Representative','67, avenue de l''Europe','Versailles',null,'78000','France','30.59.84.10','30.59.85.11');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (41,'LAMAI','La maison d''Asie','Annette Roulet','Sales Manager','1 rue Alsace-Lorraine','Toulouse',null,'31000','France','61.77.61.10','61.77.61.11');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (42,'LAUGB','Laughing Bacchus Wine Cellars','Yoshi Tannamuri','Marketing Assistant','1900 Oak St.','Vancouver','BC','V3F 2K1','Canada','(604) 555-3392','(604) 555-7293');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (43,'LAZYK','Lazy K Kountry Store','John Steel','Marketing Manager','12 Orchestra Terrace','Walla Walla','WA','99362','USA','(509) 555-7969','(509) 555-6221');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (44,'LEHMS','Lehmanns Marktstand','Renate Messner','Sales Representative','Magazinweg 7','Frankfurt a.M. ',null,'60528','Germany','069-0245984','069-0245874');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (45,'LETSS','Let''s Stop N Shop','Jaime Yorres','Owner','87 Polk St.
Suite 5','San Francisco','CA','94117','USA','(415) 555-5938',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (46,'LILAS','LILA-Supermercado','Carlos Gonz?lez','Accounting Manager','Carrera 52 con Ave. Bol?var #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela','(9) 331-6954','(9) 331-7256');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (47,'LINOD','LINO-Delicateses','Felipe Izquierdo','Owner','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela','(8) 34-56-12','(8) 34-93-93');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (48,'LONEP','Lonesome Pine Restaurant','Fran Wilson','Sales Manager','89 Chiaroscuro Rd.','Portland','OR','97219','USA','(503) 555-9573','(503) 555-9646');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (49,'MAGAA','Magazzini Alimentari Riuniti','Giovanni Rovelli','Marketing Manager','Via Ludovico il Moro 22','Bergamo',null,'24100','Italy','035-640230','035-640231');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (50,'MAISD','Maison Dewey','Catherine Dewey','Sales Agent','Rue Joseph-Bens 532','Bruxelles',null,'B-1180','Belgium','(02) 201 24 67','(02) 201 24 68');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (51,'MEREP','M?re Paillarde','Jean Fresni?re','Marketing Assistant','43 rue St. Laurent','Montr?al','Qu?bec','H1J 1C3','Canada','(514) 555-8054','(514) 555-8055');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (52,'MORGK','Morgenstern Gesundkost','Alexander Feuer','Marketing Assistant','Heerstr. 22','Leipzig',null,'04179','Germany','0342-023176',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (53,'NORTS','North/South','Simon Crowther','Sales Associate','South House
300 Queensbridge','London',null,'SW7 1RZ','UK','(171) 555-7733','(171) 555-2530');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (54,'OCEAN','Oc?ano Atl?ntico Ltda.','Yvonne Moncada','Sales Agent','Ing. Gustavo Moncada 8585
Piso 20-A','Buenos Aires',null,'1010','Argentina','(1) 135-5333','(1) 135-5535');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (55,'OLDWO','Old World Delicatessen','Rene Phillips','Sales Representative','2743 Bering St.','Anchorage','AK','99508','USA','(907) 555-7584','(907) 555-2880');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (56,'OTTIK','Ottilies K?seladen','Henriette Pfalzheim','Owner','Mehrheimerstr. 369','K?ln',null,'50739','Germany','0221-0644327','0221-0765721');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (57,'PARIS','Paris sp?cialit?s','Marie Bertrand','Owner','265, boulevard Charonne','Paris',null,'75012','France','(1) 42.34.22.66','(1) 42.34.22.77');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (58,'PERIC','Pericles Comidas cl?sicas','Guillermo Fern?ndez','Sales Representative','Calle Dr. Jorge Cash 321','M?xico D.F.',null,'05033','Mexico','(5) 552-3745','(5) 545-3745');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (59,'PICCO','Piccolo und mehr','Georg Pipps','Sales Manager','Geislweg 14','Salzburg',null,'5020','Austria','6562-9722','6562-9723');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (60,'PRINI','Princesa Isabel Vinhos','Isabel de Castro','Sales Representative','Estrada da sa?de n. 58','Lisboa',null,'1756','Portugal','(1) 356-5634',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (61,'QUEDE','Que Del?cia','Bernardo Batista','Accounting Manager','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil','(21) 555-4252','(21) 555-4545');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (62,'QUEEN','Queen Cozinha','L?cia Carvalho','Marketing Assistant','Alameda dos Can?rios, 891','S?o Paulo','SP','05487-020','Brazil','(11) 555-1189',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (63,'QUICK','QUICK-Stop','Horst Kloss','Accounting Manager','Taucherstra?e 10','Cunewalde',null,'01307','Germany','0372-035188',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (64,'RANCH','Rancho grande','Sergio Guti?rrez','Sales Representative','Av. del Libertador 900','Buenos Aires',null,'1010','Argentina','(1) 123-5555','(1) 123-5556');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (65,'RATTC','Rattlesnake Canyon Grocery','Paula Wilson','Assistant Sales Representative','2817 Milton Dr.','Albuquerque','NM','87110','USA','(505) 555-5939','(505) 555-3620');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (66,'REGGC','Reggiani Caseifici','Maurizio Moroni','Sales Associate','Strada Provinciale 124','Reggio Emilia',null,'42100','Italy','0522-556721','0522-556722');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (67,'RICAR','Ricardo Adocicados','Janete Limeira','Assistant Sales Agent','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil','(21) 555-3412',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (68,'RICSU','Richter Supermarkt','Michael Holz','Sales Manager','Grenzacherweg 237','Gen?ve',null,'1203','Switzerland','0897-034214',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (69,'ROMEY','Romero y tomillo','Alejandra Camino','Accounting Manager','Gran V?a, 1','Madrid',null,'28001','Spain','(91) 745 6200','(91) 745 6210');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (70,'SANTG','Sant? Gourmet','Jonas Bergulfsen','Owner','Erling Skakkes gate 78','Stavern',null,'4110','Norway','07-98 92 35','07-98 92 47');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (71,'SAVEA','Save-a-lot Markets','Jose Pavarotti','Sales Representative','187 Suffolk Ln.','Boise','ID','83720','USA','(208) 555-8097',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (72,'SEVES','Seven Seas Imports','Hari Kumar','Sales Manager','90 Wadhurst Rd.','London',null,'OX15 4NB','UK','(171) 555-1717','(171) 555-5646');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (73,'SIMOB','Simons bistro','Jytte Petersen','Owner','Vinb?ltet 34','K?benhavn',null,'1734','Denmark','31 12 34 56','31 13 35 57');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (74,'SPECD','Sp?cialit?s du monde','Dominique Perrier','Marketing Manager','25, rue Lauriston','Paris',null,'75016','France','(1) 47.55.60.10','(1) 47.55.60.20');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (75,'SPLIR','Split Rail Beer & Ale','Art Braunschweiger','Sales Manager','P.O. Box 555','Lander','WY','82520','USA','(307) 555-4680','(307) 555-6525');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (76,'SUPRD','Supr?mes d?lices','Pascale Cartrain','Accounting Manager','Boulevard Tirou, 255','Charleroi',null,'B-6000','Belgium','(071) 23 67 22 20','(071) 23 67 22 21');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (77,'THEBI','The Big Cheese','Liz Nixon','Marketing Manager','89 Jefferson Way
Suite 2','Portland','OR','97201','USA','(503) 555-3612',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (78,'THECR','The Cracker Box','Liu Wong','Marketing Assistant','55 Grizzly Peak Rd.','Butte','MT','59801','USA','(406) 555-5834','(406) 555-8083');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (79,'TOMSP','Toms Spezialit?ten','Karin Josephs','Marketing Manager','Luisenstr. 48','M?nster',null,'44087','Germany','0251-031259','0251-035695');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (80,'TORTU','Tortuga Restaurante','Miguel Angel Paolino','Owner','Avda. Azteca 123','M?xico D.F.',null,'05033','Mexico','(5) 555-2933',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (81,'TRADH','Tradi??o Hipermercados','Anabela Domingues','Sales Representative','Av. In?s de Castro, 414','S?o Paulo','SP','05634-030','Brazil','(11) 555-2167','(11) 555-2168');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (82,'TRAIH','Trail''s Head Gourmet Provisioners','Helvetius Nagy','Sales Associate','722 DaVinci Blvd.','Kirkland','WA','98034','USA','(206) 555-8257','(206) 555-2174');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (83,'VAFFE','Vaffeljernet','Palle Ibsen','Sales Manager','Smagsl?get 45','?rhus',null,'8200','Denmark','86 21 32 43','86 22 33 44');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (84,'VICTE','Victuailles en stock','Mary Saveley','Sales Agent','2, rue du Commerce','Lyon',null,'69004','France','78.32.54.86','78.32.54.87');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (85,'VINET','Vins et alcools Chevalier','Paul Henriot','Accounting Manager','59 rue de l''Abbaye','Reims',null,'51100','France','26.47.15.10','26.47.15.11');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (86,'WANDK','Die Wandernde Kuh','Rita M?ller','Sales Representative','Adenauerallee 900','Stuttgart',null,'70563','Germany','0711-020361','0711-035428');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (87,'WARTH','Wartian Herkku','Pirkko Koskitalo','Accounting Manager','Torikatu 38','Oulu',null,'90110','Finland','981-443655','981-443655');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (88,'WELLI','Wellington Importadora','Paula Parente','Sales Manager','Rua do Mercado, 12','Resende','SP','08737-363','Brazil','(14) 555-8122',null);
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (89,'WHITC','White Clover Markets','Karl Jablonski','Owner','305 - 14th Ave. S.
Suite 3B','Seattle','WA','98128','USA','(206) 555-4112','(206) 555-4115');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (90,'WILMK','Wilman Kala','Matti Karttunen','Owner/Marketing Assistant','Keskuskatu 45','Helsinki',null,'21240','Finland','90-224 8858','90-224 8858');
Insert into CUSTOMERS (CUSTOMER_ID,CUSTOMER_CODE,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX) values (91,'WOLZA','Wolski  Zajazd','Zbyszek Piestrzeniewicz','Owner','ul. Filtrowa 68','Warszawa',null,'01-012','Poland','(26) 642-7012','(26) 642-7012');
-- INSERTING into EMPLOYEES
-- 
Insert into EMPLOYEES (EMPLOYEE_ID,LASTNAME,FIRSTNAME,TITLE,TITLE_OF_COURTESY,BIRTHDATE,HIREDATE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,HOME_PHONE,EXTENSION,PHOTO,NOTES,REPORTS_TO) values (1,'Davolio','Nancy','Sales Representative','Ms.',to_date('08-DEC-68','DD-MON-RR'),to_date('01-MAY-92','DD-MON-RR'),'507 - 20th Ave. E.Apt. 2A','Seattle','WA','98122','USA','(206) 555-9857','5467','nancy.jpg','Education includes a BA in psychology from Colorado State University.  She also completed "The Art of the Cold Call."  Nancy is a member of Toastmasters International.',2);
Insert into EMPLOYEES (EMPLOYEE_ID,LASTNAME,FIRSTNAME,TITLE,TITLE_OF_COURTESY,BIRTHDATE,HIREDATE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,HOME_PHONE,EXTENSION,PHOTO,NOTES,REPORTS_TO) values (2,'Fuller','Andrew','Vice President, Sales','Dr.',to_date('19-FEB-52','DD-MON-RR'),to_date('14-AUG-92','DD-MON-RR'),'908 W. Capital Way','Tacoma','WA','98401','USA','(206) 555-9482','3457','andrew  .jpg','Andrew received his BTS commercial and a Ph.D. in international marketing from the University of Dallas.  He is fluent in French and Italian and reads German.  He joined the company as a sales representative, was promoted to sales manager and was then named vice president of sales.  Andrew is a member of the Sales Management Roundtable, the Seattle Chamber of Commerce, and the Pacific Rim Importers Association.',null);
Insert into EMPLOYEES (EMPLOYEE_ID,LASTNAME,FIRSTNAME,TITLE,TITLE_OF_COURTESY,BIRTHDATE,HIREDATE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,HOME_PHONE,EXTENSION,PHOTO,NOTES,REPORTS_TO) values (3,'Leverling','Janet','Sales Representative','Ms.',to_date('30-AUG-63','DD-MON-RR'),to_date('01-APR-92','DD-MON-RR'),'722 Moss Bay Blvd.','Kirkland','WA','98033','USA','(206) 555-3412','3355','janet.jpg','Janet has a BS degree in chemistry from Boston College).  She has also completed a certificate program in food retailing management.  Janet was hired as a sales associate and was promoted to sales representative.',2);
Insert into EMPLOYEES (EMPLOYEE_ID,LASTNAME,FIRSTNAME,TITLE,TITLE_OF_COURTESY,BIRTHDATE,HIREDATE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,HOME_PHONE,EXTENSION,PHOTO,NOTES,REPORTS_TO) values (4,'Peacock','Margaret','Sales Representative','Mrs.',to_date('19-SEP-58','DD-MON-RR'),to_date('03-MAY-93','DD-MON-RR'),'4110 Old Redmond Rd.','Redmond','WA','98052','USA','(206) 555-8122','5176','margaret.jpg','Margaret holds a BA in English literature from Concordia College and an MA from the American Institute of Culinary Arts. She was temporarily assigned to the London office before returning to her permanent post in Seattle.',2);
Insert into EMPLOYEES (EMPLOYEE_ID,LASTNAME,FIRSTNAME,TITLE,TITLE_OF_COURTESY,BIRTHDATE,HIREDATE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,HOME_PHONE,EXTENSION,PHOTO,NOTES,REPORTS_TO) values (5,'Buchanan','Steven','Sales Manager','Mr.',to_date('04-MAR-55','DD-MON-RR'),to_date('17-OCT-93','DD-MON-RR'),'14 Garrett Hill','London',null,'SW1 8JR','UK','(71) 555-4848','3453','steven.jpg','Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree.  Upon joining the company as a sales representative, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London, where he was promoted to sales manager.  Mr. Buchanan has completed the courses "Successful Telemarketing" and "International Sales Management."  He is fluent in French.',2);
Insert into EMPLOYEES (EMPLOYEE_ID,LASTNAME,FIRSTNAME,TITLE,TITLE_OF_COURTESY,BIRTHDATE,HIREDATE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,HOME_PHONE,EXTENSION,PHOTO,NOTES,REPORTS_TO) values (6,'Suyama','Michael','Sales Representative','Mr.',to_date('02-JUL-63','DD-MON-RR'),to_date('17-OCT-93','DD-MON-RR'),'Coventry House Miner Rd.','London',null,'EC2 7JR','UK','(71) 555-7773','428','michael.jpg','Michael is a graduate of Sussex University (MA, economics) and the University of California at Los Angeles (MBA, marketing).  He has also taken the courses "Multi-Cultural Selling" and "Time Management for the Sales Professional."  He is fluent in Japanese and can read and write French, Portuguese, and Spanish.',5);
Insert into EMPLOYEES (EMPLOYEE_ID,LASTNAME,FIRSTNAME,TITLE,TITLE_OF_COURTESY,BIRTHDATE,HIREDATE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,HOME_PHONE,EXTENSION,PHOTO,NOTES,REPORTS_TO) values (7,'King','Robert','Sales Representative','Mr.',to_date('29-MAY-60','DD-MON-RR'),to_date('02-JAN-94','DD-MON-RR'),'Edgeham Hollow Winchester Way','London',null,'RG1 9SP','UK','(71) 555-5598','465','robert.jpg','Robert King served in the Peace Corps and traveled extensively before completing his degree in English at the University of Michigan and then joining the company.  After completing a course entitled "Selling in Europe," he was transferred to the London office.',5);
Insert into EMPLOYEES (EMPLOYEE_ID,LASTNAME,FIRSTNAME,TITLE,TITLE_OF_COURTESY,BIRTHDATE,HIREDATE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,HOME_PHONE,EXTENSION,PHOTO,NOTES,REPORTS_TO) values (8,'Callahan','Laura','Inside Sales Coordinator','Ms.',to_date('09-JAN-58','DD-MON-RR'),to_date('05-MAR-94','DD-MON-RR'),'4726 - 11th Ave. N.E.','Seattle','WA','98105','USA','(206) 555-1189','2344','laura.jpg','Laura received a BA in psychology from the University of Washington.  She has also completed a course in business French.  She reads and writes French.',2);
Insert into EMPLOYEES (EMPLOYEE_ID,LASTNAME,FIRSTNAME,TITLE,TITLE_OF_COURTESY,BIRTHDATE,HIREDATE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,HOME_PHONE,EXTENSION,PHOTO,NOTES,REPORTS_TO) values (9,'Dodsworth','Anne','Sales Representative','Ms.',to_date('02-JUL-69','DD-MON-RR'),to_date('15-NOV-94','DD-MON-RR'),'7 Houndstooth Rd.','London',null,'WG2 7LT','UK','(71) 555-4444','452','anne.jpg','Anne has a BA degree in English from St. Lawrence College.  She is fluent in French and German.',5);
-- INSERTING into ORDERS
-- 
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10313,63,2,to_date('24-SEP-96','DD-MON-RR'),to_date('22-OCT-96','DD-MON-RR'),to_date('04-OCT-96','DD-MON-RR'),2,1.96,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10314,65,1,to_date('25-SEP-96','DD-MON-RR'),to_date('23-OCT-96','DD-MON-RR'),to_date('04-OCT-96','DD-MON-RR'),2,74.16,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10315,38,4,to_date('26-SEP-96','DD-MON-RR'),to_date('24-OCT-96','DD-MON-RR'),to_date('03-OCT-96','DD-MON-RR'),2,41.76,'Island Trading','Garden House
Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10316,65,1,to_date('27-SEP-96','DD-MON-RR'),to_date('25-OCT-96','DD-MON-RR'),to_date('08-OCT-96','DD-MON-RR'),3,150.15,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10317,48,6,to_date('30-SEP-96','DD-MON-RR'),to_date('28-OCT-96','DD-MON-RR'),to_date('10-OCT-96','DD-MON-RR'),1,12.69,'Lonesome Pine Restaurant','89 Chiaroscuro Rd.','Portland','OR','97219','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10318,38,8,to_date('01-OCT-96','DD-MON-RR'),to_date('29-OCT-96','DD-MON-RR'),to_date('04-OCT-96','DD-MON-RR'),2,4.73,'Island Trading','Garden House
Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10319,80,7,to_date('02-OCT-96','DD-MON-RR'),to_date('30-OCT-96','DD-MON-RR'),to_date('11-OCT-96','DD-MON-RR'),3,64.5,'Tortuga Restaurante','Avda. Azteca 123','M?xico D.F.',null,'05033','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10320,87,5,to_date('03-OCT-96','DD-MON-RR'),to_date('17-OCT-96','DD-MON-RR'),to_date('18-OCT-96','DD-MON-RR'),3,34.57,'Wartian Herkku','Torikatu 38','Oulu',null,'90110','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10321,38,3,to_date('03-OCT-96','DD-MON-RR'),to_date('31-OCT-96','DD-MON-RR'),to_date('11-OCT-96','DD-MON-RR'),2,3.43,'Island Trading','Garden House
Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10322,58,7,to_date('04-OCT-96','DD-MON-RR'),to_date('01-NOV-96','DD-MON-RR'),to_date('23-OCT-96','DD-MON-RR'),3,0.4,'Pericles Comidas cl?sicas','Calle Dr. Jorge Cash 321','M?xico D.F.',null,'05033','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10323,39,4,to_date('07-OCT-96','DD-MON-RR'),to_date('04-NOV-96','DD-MON-RR'),to_date('14-OCT-96','DD-MON-RR'),1,4.88,'K?niglich Essen','Maubelstr. 90','Brandenburg',null,'14776','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10324,71,9,to_date('08-OCT-96','DD-MON-RR'),to_date('05-NOV-96','DD-MON-RR'),to_date('10-OCT-96','DD-MON-RR'),1,214.27,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10325,39,1,to_date('09-OCT-96','DD-MON-RR'),to_date('23-OCT-96','DD-MON-RR'),to_date('14-OCT-96','DD-MON-RR'),3,64.86,'K?niglich Essen','Maubelstr. 90','Brandenburg',null,'14776','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10326,8,4,to_date('10-OCT-96','DD-MON-RR'),to_date('07-NOV-96','DD-MON-RR'),to_date('14-OCT-96','DD-MON-RR'),2,77.92,'B?lido Comidas preparadas','C/ Araquil, 67','Madrid',null,'28023','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10327,24,2,to_date('11-OCT-96','DD-MON-RR'),to_date('08-NOV-96','DD-MON-RR'),to_date('14-OCT-96','DD-MON-RR'),1,63.36,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10328,28,4,to_date('14-OCT-96','DD-MON-RR'),to_date('11-NOV-96','DD-MON-RR'),to_date('17-OCT-96','DD-MON-RR'),3,87.03,'Furia Bacalhau e Frutos do Mar','Jardim das rosas n. 32','Lisboa',null,'1675','Portugal');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10329,75,4,to_date('15-OCT-96','DD-MON-RR'),to_date('26-NOV-96','DD-MON-RR'),to_date('23-OCT-96','DD-MON-RR'),2,191.67,'Split Rail Beer & Ale','P.O. Box 555','Lander','WY','82520','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10330,46,3,to_date('16-OCT-96','DD-MON-RR'),to_date('13-NOV-96','DD-MON-RR'),to_date('28-OCT-96','DD-MON-RR'),1,12.75,'LILA-Supermercado','Carrera 52 con Ave. Bol?var #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10331,9,9,to_date('16-OCT-96','DD-MON-RR'),to_date('27-NOV-96','DD-MON-RR'),to_date('21-OCT-96','DD-MON-RR'),1,10.19,'Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10332,51,3,to_date('17-OCT-96','DD-MON-RR'),to_date('28-NOV-96','DD-MON-RR'),to_date('21-OCT-96','DD-MON-RR'),2,52.84,'M?re Paillarde','43 rue St. Laurent','Montr?al','Qu?bec','H1J 1C3','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10333,87,5,to_date('18-OCT-96','DD-MON-RR'),to_date('15-NOV-96','DD-MON-RR'),to_date('25-OCT-96','DD-MON-RR'),3,0.59,'Wartian Herkku','Torikatu 38','Oulu',null,'90110','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10334,84,8,to_date('21-OCT-96','DD-MON-RR'),to_date('18-NOV-96','DD-MON-RR'),to_date('28-OCT-96','DD-MON-RR'),2,8.56,'Victuailles en stock','2, rue du Commerce','Lyon',null,'69004','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10335,37,7,to_date('22-OCT-96','DD-MON-RR'),to_date('19-NOV-96','DD-MON-RR'),to_date('24-OCT-96','DD-MON-RR'),2,42.11,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10336,60,7,to_date('23-OCT-96','DD-MON-RR'),to_date('20-NOV-96','DD-MON-RR'),to_date('25-OCT-96','DD-MON-RR'),2,15.51,'Princesa Isabel Vinhos','Estrada da sa?de n. 58','Lisboa',null,'1756','Portugal');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10337,25,4,to_date('24-OCT-96','DD-MON-RR'),to_date('21-NOV-96','DD-MON-RR'),to_date('29-OCT-96','DD-MON-RR'),3,108.26,'Frankenversand','Berliner Platz 43','M?nchen',null,'80805','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10338,55,4,to_date('25-OCT-96','DD-MON-RR'),to_date('22-NOV-96','DD-MON-RR'),to_date('29-OCT-96','DD-MON-RR'),3,84.21,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10339,51,2,to_date('28-OCT-96','DD-MON-RR'),to_date('25-NOV-96','DD-MON-RR'),to_date('04-NOV-96','DD-MON-RR'),2,15.66,'M?re Paillarde','43 rue St. Laurent','Montr?al','Qu?bec','H1J 1C3','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10340,9,1,to_date('29-OCT-96','DD-MON-RR'),to_date('26-NOV-96','DD-MON-RR'),to_date('08-NOV-96','DD-MON-RR'),3,166.31,'Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10341,73,7,to_date('29-OCT-96','DD-MON-RR'),to_date('26-NOV-96','DD-MON-RR'),to_date('05-NOV-96','DD-MON-RR'),3,26.78,'Simons bistro','Vinb?ltet 34','K?benhavn',null,'1734','Denmark');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10342,25,4,to_date('30-OCT-96','DD-MON-RR'),to_date('13-NOV-96','DD-MON-RR'),to_date('04-NOV-96','DD-MON-RR'),2,54.83,'Frankenversand','Berliner Platz 43','M?nchen',null,'80805','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10343,44,4,to_date('31-OCT-96','DD-MON-RR'),to_date('28-NOV-96','DD-MON-RR'),to_date('06-NOV-96','DD-MON-RR'),1,110.37,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M. ',null,'60528','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10344,89,4,to_date('01-NOV-96','DD-MON-RR'),to_date('29-NOV-96','DD-MON-RR'),to_date('05-NOV-96','DD-MON-RR'),2,23.29,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10345,63,2,to_date('04-NOV-96','DD-MON-RR'),to_date('02-DEC-96','DD-MON-RR'),to_date('11-NOV-96','DD-MON-RR'),2,249.06,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10346,65,3,to_date('05-NOV-96','DD-MON-RR'),to_date('17-DEC-96','DD-MON-RR'),to_date('08-NOV-96','DD-MON-RR'),3,142.08,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10347,21,4,to_date('06-NOV-96','DD-MON-RR'),to_date('04-DEC-96','DD-MON-RR'),to_date('08-NOV-96','DD-MON-RR'),3,3.1,'Familia Arquibaldo','Rua Or?s, 92','S?o Paulo','SP','05442-030','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10348,86,4,to_date('07-NOV-96','DD-MON-RR'),to_date('05-DEC-96','DD-MON-RR'),to_date('15-NOV-96','DD-MON-RR'),2,0.78,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',null,'70563','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10349,75,7,to_date('08-NOV-96','DD-MON-RR'),to_date('06-DEC-96','DD-MON-RR'),to_date('15-NOV-96','DD-MON-RR'),1,8.63,'Split Rail Beer & Ale','P.O. Box 555','Lander','WY','82520','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10350,41,6,to_date('11-NOV-96','DD-MON-RR'),to_date('09-DEC-96','DD-MON-RR'),to_date('03-DEC-96','DD-MON-RR'),2,64.19,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',null,'31000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10351,20,1,to_date('11-NOV-96','DD-MON-RR'),to_date('09-DEC-96','DD-MON-RR'),to_date('20-NOV-96','DD-MON-RR'),1,162.33,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10352,28,3,to_date('12-NOV-96','DD-MON-RR'),to_date('26-NOV-96','DD-MON-RR'),to_date('18-NOV-96','DD-MON-RR'),3,1.3,'Furia Bacalhau e Frutos do Mar','Jardim das rosas n. 32','Lisboa',null,'1675','Portugal');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10353,59,7,to_date('13-NOV-96','DD-MON-RR'),to_date('11-DEC-96','DD-MON-RR'),to_date('25-NOV-96','DD-MON-RR'),3,360.63,'Piccolo und mehr','Geislweg 14','Salzburg',null,'5020','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10354,58,8,to_date('14-NOV-96','DD-MON-RR'),to_date('12-DEC-96','DD-MON-RR'),to_date('20-NOV-96','DD-MON-RR'),3,53.8,'Pericles Comidas cl?sicas','Calle Dr. Jorge Cash 321','M?xico D.F.',null,'05033','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10355,4,6,to_date('15-NOV-96','DD-MON-RR'),to_date('13-DEC-96','DD-MON-RR'),to_date('20-NOV-96','DD-MON-RR'),1,41.95,'Around the Horn','Brook Farm
Stratford St. Mary','Colchester','Essex','CO7 6JX','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10356,86,6,to_date('18-NOV-96','DD-MON-RR'),to_date('16-DEC-96','DD-MON-RR'),to_date('27-NOV-96','DD-MON-RR'),2,36.71,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',null,'70563','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10357,46,1,to_date('19-NOV-96','DD-MON-RR'),to_date('17-DEC-96','DD-MON-RR'),to_date('02-DEC-96','DD-MON-RR'),3,34.88,'LILA-Supermercado','Carrera 52 con Ave. Bol?var #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10358,41,5,to_date('20-NOV-96','DD-MON-RR'),to_date('18-DEC-96','DD-MON-RR'),to_date('27-NOV-96','DD-MON-RR'),1,19.64,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',null,'31000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10359,72,5,to_date('21-NOV-96','DD-MON-RR'),to_date('19-DEC-96','DD-MON-RR'),to_date('26-NOV-96','DD-MON-RR'),3,288.43,'Seven Seas Imports','90 Wadhurst Rd.','London',null,'OX15 4NB','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10360,7,4,to_date('22-NOV-96','DD-MON-RR'),to_date('20-DEC-96','DD-MON-RR'),to_date('02-DEC-96','DD-MON-RR'),3,131.7,'Blondel p?re et fils','24, place Kl?ber','Strasbourg',null,'67000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10361,63,1,to_date('22-NOV-96','DD-MON-RR'),to_date('20-DEC-96','DD-MON-RR'),to_date('03-DEC-96','DD-MON-RR'),2,183.17,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10362,9,3,to_date('25-NOV-96','DD-MON-RR'),to_date('23-DEC-96','DD-MON-RR'),to_date('28-NOV-96','DD-MON-RR'),1,96.04,'Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10363,17,4,to_date('26-NOV-96','DD-MON-RR'),to_date('24-DEC-96','DD-MON-RR'),to_date('04-DEC-96','DD-MON-RR'),3,30.54,'Drachenblut Delikatessen','Walserweg 21','Aachen',null,'52066','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10364,19,1,to_date('26-NOV-96','DD-MON-RR'),to_date('07-JAN-97','DD-MON-RR'),to_date('04-DEC-96','DD-MON-RR'),1,71.97,'Eastern Connection','35 King George','London',null,'WX3 6FW','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10365,3,3,to_date('27-NOV-96','DD-MON-RR'),to_date('25-DEC-96','DD-MON-RR'),to_date('02-DEC-96','DD-MON-RR'),2,22,'Antonio Moreno Taquer?a','Mataderos  2312','M?xico D.F.',null,'05023','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10366,29,8,to_date('28-NOV-96','DD-MON-RR'),to_date('09-JAN-97','DD-MON-RR'),to_date('30-DEC-96','DD-MON-RR'),2,10.14,'Galer?a del gastron?mo','Rambla de Catalu?a, 23','Barcelona',null,'8022','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10367,83,7,to_date('28-NOV-96','DD-MON-RR'),to_date('26-DEC-96','DD-MON-RR'),to_date('02-DEC-96','DD-MON-RR'),3,13.55,'Vaffeljernet','Smagsl?get 45','?rhus',null,'8200','Denmark');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10368,20,2,to_date('29-NOV-96','DD-MON-RR'),to_date('27-DEC-96','DD-MON-RR'),to_date('02-DEC-96','DD-MON-RR'),2,101.95,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10369,75,8,to_date('02-DEC-96','DD-MON-RR'),to_date('30-DEC-96','DD-MON-RR'),to_date('09-DEC-96','DD-MON-RR'),2,195.68,'Split Rail Beer & Ale','P.O. Box 555','Lander','WY','82520','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10370,14,6,to_date('03-DEC-96','DD-MON-RR'),to_date('31-DEC-96','DD-MON-RR'),to_date('27-DEC-96','DD-MON-RR'),2,1.17,'Chop-suey Chinese','Hauptstr. 31','Bern',null,'3012','Switzerland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10371,41,1,to_date('03-DEC-96','DD-MON-RR'),to_date('31-DEC-96','DD-MON-RR'),to_date('24-DEC-96','DD-MON-RR'),1,0.45,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',null,'31000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10372,62,5,to_date('04-DEC-96','DD-MON-RR'),to_date('01-JAN-97','DD-MON-RR'),to_date('09-DEC-96','DD-MON-RR'),2,890.78,'Queen Cozinha','Alameda dos Can?rios, 891','S?o Paulo','SP','05487-020','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10939,49,2,to_date('10-MAR-98','DD-MON-RR'),to_date('07-APR-98','DD-MON-RR'),to_date('13-MAR-98','DD-MON-RR'),2,76.33,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',null,'24100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10940,9,8,to_date('11-MAR-98','DD-MON-RR'),to_date('08-APR-98','DD-MON-RR'),to_date('23-MAR-98','DD-MON-RR'),3,19.77,'Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10941,71,7,to_date('11-MAR-98','DD-MON-RR'),to_date('08-APR-98','DD-MON-RR'),to_date('20-MAR-98','DD-MON-RR'),2,400.81,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10373,37,4,to_date('05-DEC-96','DD-MON-RR'),to_date('02-JAN-97','DD-MON-RR'),to_date('11-DEC-96','DD-MON-RR'),3,124.12,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10374,91,1,to_date('05-DEC-96','DD-MON-RR'),to_date('02-JAN-97','DD-MON-RR'),to_date('09-DEC-96','DD-MON-RR'),3,3.94,'Wolski Zajazd','ul. Filtrowa 68','Warszawa',null,'01-012','Poland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10375,36,3,to_date('06-DEC-96','DD-MON-RR'),to_date('03-JAN-97','DD-MON-RR'),to_date('09-DEC-96','DD-MON-RR'),2,20.12,'Hungry Coyote Import Store','City Center Plaza
516 Main St.','Elgin','OR','97827','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10376,51,1,to_date('09-DEC-96','DD-MON-RR'),to_date('06-JAN-97','DD-MON-RR'),to_date('13-DEC-96','DD-MON-RR'),2,20.39,'M?re Paillarde','43 rue St. Laurent','Montr?al','Qu?bec','H1J 1C3','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10377,72,1,to_date('09-DEC-96','DD-MON-RR'),to_date('06-JAN-97','DD-MON-RR'),to_date('13-DEC-96','DD-MON-RR'),3,22.21,'Seven Seas Imports','90 Wadhurst Rd.','London',null,'OX15 4NB','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10378,24,5,to_date('10-DEC-96','DD-MON-RR'),to_date('07-JAN-97','DD-MON-RR'),to_date('19-DEC-96','DD-MON-RR'),3,5.44,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10379,61,2,to_date('11-DEC-96','DD-MON-RR'),to_date('08-JAN-97','DD-MON-RR'),to_date('13-DEC-96','DD-MON-RR'),1,45.03,'Que Del?cia','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10380,37,8,to_date('12-DEC-96','DD-MON-RR'),to_date('09-JAN-97','DD-MON-RR'),to_date('16-JAN-97','DD-MON-RR'),3,35.03,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10381,46,3,to_date('12-DEC-96','DD-MON-RR'),to_date('09-JAN-97','DD-MON-RR'),to_date('13-DEC-96','DD-MON-RR'),3,7.99,'LILA-Supermercado','Carrera 52 con Ave. Bol?var #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10382,20,4,to_date('13-DEC-96','DD-MON-RR'),to_date('10-JAN-97','DD-MON-RR'),to_date('16-DEC-96','DD-MON-RR'),1,94.77,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10383,4,8,to_date('16-DEC-96','DD-MON-RR'),to_date('13-JAN-97','DD-MON-RR'),to_date('18-DEC-96','DD-MON-RR'),3,34.24,'Around the Horn','Brook Farm
Stratford St. Mary','Colchester','Essex','CO7 6JX','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10384,5,3,to_date('16-DEC-96','DD-MON-RR'),to_date('13-JAN-97','DD-MON-RR'),to_date('20-DEC-96','DD-MON-RR'),3,168.64,'Berglunds snabbk?p','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10385,75,1,to_date('17-DEC-96','DD-MON-RR'),to_date('14-JAN-97','DD-MON-RR'),to_date('23-DEC-96','DD-MON-RR'),2,30.96,'Split Rail Beer & Ale','P.O. Box 555','Lander','WY','82520','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10386,21,9,to_date('18-DEC-96','DD-MON-RR'),to_date('01-JAN-97','DD-MON-RR'),to_date('25-DEC-96','DD-MON-RR'),3,13.99,'Familia Arquibaldo','Rua Or?s, 92','S?o Paulo','SP','05442-030','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10387,70,1,to_date('18-DEC-96','DD-MON-RR'),to_date('15-JAN-97','DD-MON-RR'),to_date('20-DEC-96','DD-MON-RR'),2,93.63,'Sant? Gourmet','Erling Skakkes gate 78','Stavern',null,'4110','Norway');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10388,72,2,to_date('19-DEC-96','DD-MON-RR'),to_date('16-JAN-97','DD-MON-RR'),to_date('20-DEC-96','DD-MON-RR'),1,34.86,'Seven Seas Imports','90 Wadhurst Rd.','London',null,'OX15 4NB','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10389,10,4,to_date('20-DEC-96','DD-MON-RR'),to_date('17-JAN-97','DD-MON-RR'),to_date('24-DEC-96','DD-MON-RR'),2,47.42,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10390,20,6,to_date('23-DEC-96','DD-MON-RR'),to_date('20-JAN-97','DD-MON-RR'),to_date('26-DEC-96','DD-MON-RR'),1,126.38,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10391,17,3,to_date('23-DEC-96','DD-MON-RR'),to_date('20-JAN-97','DD-MON-RR'),to_date('31-DEC-96','DD-MON-RR'),3,5.45,'Drachenblut Delikatessen','Walserweg 21','Aachen',null,'52066','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10392,59,2,to_date('24-DEC-96','DD-MON-RR'),to_date('21-JAN-97','DD-MON-RR'),to_date('01-JAN-97','DD-MON-RR'),3,122.46,'Piccolo und mehr','Geislweg 14','Salzburg',null,'5020','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10393,71,1,to_date('25-DEC-96','DD-MON-RR'),to_date('22-JAN-97','DD-MON-RR'),to_date('03-JAN-97','DD-MON-RR'),3,126.56,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10394,36,1,to_date('25-DEC-96','DD-MON-RR'),to_date('22-JAN-97','DD-MON-RR'),to_date('03-JAN-97','DD-MON-RR'),3,30.34,'Hungry Coyote Import Store','City Center Plaza
516 Main St.','Elgin','OR','97827','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10395,35,6,to_date('26-DEC-96','DD-MON-RR'),to_date('23-JAN-97','DD-MON-RR'),to_date('03-JAN-97','DD-MON-RR'),1,184.41,'HILARI?N-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10396,25,1,to_date('27-DEC-96','DD-MON-RR'),to_date('10-JAN-97','DD-MON-RR'),to_date('06-JAN-97','DD-MON-RR'),3,135.35,'Frankenversand','Berliner Platz 43','M?nchen',null,'80805','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10397,60,5,to_date('27-DEC-96','DD-MON-RR'),to_date('24-JAN-97','DD-MON-RR'),to_date('02-JAN-97','DD-MON-RR'),1,60.26,'Princesa Isabel Vinhos','Estrada da sa?de n. 58','Lisboa',null,'1756','Portugal');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10398,71,2,to_date('30-DEC-96','DD-MON-RR'),to_date('27-JAN-97','DD-MON-RR'),to_date('09-JAN-97','DD-MON-RR'),3,89.16,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10399,83,8,to_date('31-DEC-96','DD-MON-RR'),to_date('14-JAN-97','DD-MON-RR'),to_date('08-JAN-97','DD-MON-RR'),3,27.36,'Vaffeljernet','Smagsl?get 45','?rhus',null,'8200','Denmark');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10400,19,1,to_date('01-JAN-97','DD-MON-RR'),to_date('29-JAN-97','DD-MON-RR'),to_date('16-JAN-97','DD-MON-RR'),3,83.93,'Eastern Connection','35 King George','London',null,'WX3 6FW','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10401,65,1,to_date('01-JAN-97','DD-MON-RR'),to_date('29-JAN-97','DD-MON-RR'),to_date('10-JAN-97','DD-MON-RR'),1,12.51,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10402,20,8,to_date('02-JAN-97','DD-MON-RR'),to_date('13-FEB-97','DD-MON-RR'),to_date('10-JAN-97','DD-MON-RR'),2,67.88,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10403,20,4,to_date('03-JAN-97','DD-MON-RR'),to_date('31-JAN-97','DD-MON-RR'),to_date('09-JAN-97','DD-MON-RR'),3,73.79,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10404,49,2,to_date('03-JAN-97','DD-MON-RR'),to_date('31-JAN-97','DD-MON-RR'),to_date('08-JAN-97','DD-MON-RR'),1,155.97,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',null,'24100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10405,47,1,to_date('06-JAN-97','DD-MON-RR'),to_date('03-FEB-97','DD-MON-RR'),to_date('22-JAN-97','DD-MON-RR'),1,34.82,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10406,62,7,to_date('07-JAN-97','DD-MON-RR'),to_date('18-FEB-97','DD-MON-RR'),to_date('13-JAN-97','DD-MON-RR'),1,108.04,'Queen Cozinha','Alameda dos Can?rios, 891','S?o Paulo','SP','05487-020','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10407,56,2,to_date('07-JAN-97','DD-MON-RR'),to_date('04-FEB-97','DD-MON-RR'),to_date('30-JAN-97','DD-MON-RR'),2,91.48,'Ottilies K?seladen','Mehrheimerstr. 369','K?ln',null,'50739','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10408,23,8,to_date('08-JAN-97','DD-MON-RR'),to_date('05-FEB-97','DD-MON-RR'),to_date('14-JAN-97','DD-MON-RR'),1,11.26,'Folies gourmandes','184, chauss?e de Tournai','Lille',null,'59000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10409,54,3,to_date('09-JAN-97','DD-MON-RR'),to_date('06-FEB-97','DD-MON-RR'),to_date('14-JAN-97','DD-MON-RR'),1,29.83,'Oc?ano Atl?ntico Ltda.','Ing. Gustavo Moncada 8585
Piso 20-A','Buenos Aires',null,'1010','Argentina');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10410,10,3,to_date('10-JAN-97','DD-MON-RR'),to_date('07-FEB-97','DD-MON-RR'),to_date('15-JAN-97','DD-MON-RR'),3,2.4,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10411,10,9,to_date('10-JAN-97','DD-MON-RR'),to_date('07-FEB-97','DD-MON-RR'),to_date('21-JAN-97','DD-MON-RR'),3,23.65,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10412,87,8,to_date('13-JAN-97','DD-MON-RR'),to_date('10-FEB-97','DD-MON-RR'),to_date('15-JAN-97','DD-MON-RR'),2,3.77,'Wartian Herkku','Torikatu 38','Oulu',null,'90110','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10413,41,3,to_date('14-JAN-97','DD-MON-RR'),to_date('11-FEB-97','DD-MON-RR'),to_date('16-JAN-97','DD-MON-RR'),2,95.66,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',null,'31000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10414,21,2,to_date('14-JAN-97','DD-MON-RR'),to_date('11-FEB-97','DD-MON-RR'),to_date('17-JAN-97','DD-MON-RR'),3,21.48,'Familia Arquibaldo','Rua Or?s, 92','S?o Paulo','SP','05442-030','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10415,36,3,to_date('15-JAN-97','DD-MON-RR'),to_date('12-FEB-97','DD-MON-RR'),to_date('24-JAN-97','DD-MON-RR'),1,0.2,'Hungry Coyote Import Store','City Center Plaza
516 Main St.','Elgin','OR','97827','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10416,87,8,to_date('16-JAN-97','DD-MON-RR'),to_date('13-FEB-97','DD-MON-RR'),to_date('27-JAN-97','DD-MON-RR'),3,22.72,'Wartian Herkku','Torikatu 38','Oulu',null,'90110','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10417,73,4,to_date('16-JAN-97','DD-MON-RR'),to_date('13-FEB-97','DD-MON-RR'),to_date('28-JAN-97','DD-MON-RR'),3,70.29,'Simons bistro','Vinb?ltet 34','K?benhavn',null,'1734','Denmark');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10418,63,4,to_date('17-JAN-97','DD-MON-RR'),to_date('14-FEB-97','DD-MON-RR'),to_date('24-JAN-97','DD-MON-RR'),1,17.55,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10419,68,4,to_date('20-JAN-97','DD-MON-RR'),to_date('17-FEB-97','DD-MON-RR'),to_date('30-JAN-97','DD-MON-RR'),2,137.35,'Richter Supermarkt','Starenweg 5','Gen?ve',null,'1204','Switzerland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10420,88,3,to_date('21-JAN-97','DD-MON-RR'),to_date('18-FEB-97','DD-MON-RR'),to_date('27-JAN-97','DD-MON-RR'),1,44.12,'Wellington Importadora','Rua do Mercado, 12','Resende','SP','08737-363','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10421,61,8,to_date('21-JAN-97','DD-MON-RR'),to_date('04-MAR-97','DD-MON-RR'),to_date('27-JAN-97','DD-MON-RR'),1,99.23,'Que Del?cia','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10422,27,2,to_date('22-JAN-97','DD-MON-RR'),to_date('19-FEB-97','DD-MON-RR'),to_date('31-JAN-97','DD-MON-RR'),1,3.02,'Franchi S.p.A.','Via Monte Bianco 34','Torino',null,'10100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10423,31,6,to_date('23-JAN-97','DD-MON-RR'),to_date('06-FEB-97','DD-MON-RR'),to_date('24-FEB-97','DD-MON-RR'),3,24.5,'Gourmet Lanchonetes','Av. Brasil, 442','Campinas','SP','04876-786','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10424,51,7,to_date('23-JAN-97','DD-MON-RR'),to_date('20-FEB-97','DD-MON-RR'),to_date('27-JAN-97','DD-MON-RR'),2,370.61,'M?re Paillarde','43 rue St. Laurent','Montr?al','Qu?bec','H1J 1C3','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10425,41,6,to_date('24-JAN-97','DD-MON-RR'),to_date('21-FEB-97','DD-MON-RR'),to_date('14-FEB-97','DD-MON-RR'),2,7.93,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',null,'31000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10426,29,4,to_date('27-JAN-97','DD-MON-RR'),to_date('24-FEB-97','DD-MON-RR'),to_date('06-FEB-97','DD-MON-RR'),1,18.69,'Galer?a del gastron?mo','Rambla de Catalu?a, 23','Barcelona',null,'8022','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10427,59,4,to_date('27-JAN-97','DD-MON-RR'),to_date('24-FEB-97','DD-MON-RR'),to_date('03-MAR-97','DD-MON-RR'),2,31.29,'Piccolo und mehr','Geislweg 14','Salzburg',null,'5020','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10428,66,7,to_date('28-JAN-97','DD-MON-RR'),to_date('25-FEB-97','DD-MON-RR'),to_date('04-FEB-97','DD-MON-RR'),1,11.09,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',null,'42100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10429,37,3,to_date('29-JAN-97','DD-MON-RR'),to_date('12-MAR-97','DD-MON-RR'),to_date('07-FEB-97','DD-MON-RR'),2,56.63,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10430,20,4,to_date('30-JAN-97','DD-MON-RR'),to_date('13-FEB-97','DD-MON-RR'),to_date('03-FEB-97','DD-MON-RR'),1,458.78,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10431,10,4,to_date('30-JAN-97','DD-MON-RR'),to_date('13-FEB-97','DD-MON-RR'),to_date('07-FEB-97','DD-MON-RR'),2,44.17,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10432,75,3,to_date('31-JAN-97','DD-MON-RR'),to_date('14-FEB-97','DD-MON-RR'),to_date('07-FEB-97','DD-MON-RR'),2,4.34,'Split Rail Beer & Ale','P.O. Box 555','Lander','WY','82520','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10433,60,3,to_date('03-FEB-97','DD-MON-RR'),to_date('03-MAR-97','DD-MON-RR'),to_date('04-MAR-97','DD-MON-RR'),3,73.83,'Princesa Isabel Vinhos','Estrada da sa?de n. 58','Lisboa',null,'1756','Portugal');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10434,24,3,to_date('03-FEB-97','DD-MON-RR'),to_date('03-MAR-97','DD-MON-RR'),to_date('13-FEB-97','DD-MON-RR'),2,17.92,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10435,16,8,to_date('04-FEB-97','DD-MON-RR'),to_date('18-MAR-97','DD-MON-RR'),to_date('07-FEB-97','DD-MON-RR'),2,9.21,'Consolidated Holdings','Berkeley Gardens
12  Brewery ','London',null,'WX1 6LT','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10436,7,3,to_date('05-FEB-97','DD-MON-RR'),to_date('05-MAR-97','DD-MON-RR'),to_date('11-FEB-97','DD-MON-RR'),2,156.66,'Blondel p?re et fils','24, place Kl?ber','Strasbourg',null,'67000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10437,87,8,to_date('05-FEB-97','DD-MON-RR'),to_date('05-MAR-97','DD-MON-RR'),to_date('12-FEB-97','DD-MON-RR'),1,19.97,'Wartian Herkku','Torikatu 38','Oulu',null,'90110','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10438,79,3,to_date('06-FEB-97','DD-MON-RR'),to_date('06-MAR-97','DD-MON-RR'),to_date('14-FEB-97','DD-MON-RR'),2,8.24,'Toms Spezialit?ten','Luisenstr. 48','M?nster',null,'44087','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10439,51,6,to_date('07-FEB-97','DD-MON-RR'),to_date('07-MAR-97','DD-MON-RR'),to_date('10-FEB-97','DD-MON-RR'),3,4.07,'M?re Paillarde','43 rue St. Laurent','Montr?al','Qu?bec','H1J 1C3','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11018,48,4,to_date('13-APR-98','DD-MON-RR'),to_date('11-MAY-98','DD-MON-RR'),to_date('16-APR-98','DD-MON-RR'),2,11.65,'Lonesome Pine Restaurant','89 Chiaroscuro Rd.','Portland','OR','97219','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11019,64,6,to_date('13-APR-98','DD-MON-RR'),to_date('11-MAY-98','DD-MON-RR'),null,3,3.17,'Rancho grande','Av. del Libertador 900','Buenos Aires',null,'1010','Argentina');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10440,71,4,to_date('10-FEB-97','DD-MON-RR'),to_date('10-MAR-97','DD-MON-RR'),to_date('28-FEB-97','DD-MON-RR'),2,86.53,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10441,55,3,to_date('10-FEB-97','DD-MON-RR'),to_date('24-MAR-97','DD-MON-RR'),to_date('14-MAR-97','DD-MON-RR'),2,73.02,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10442,20,3,to_date('11-FEB-97','DD-MON-RR'),to_date('11-MAR-97','DD-MON-RR'),to_date('18-FEB-97','DD-MON-RR'),2,47.94,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10443,66,8,to_date('12-FEB-97','DD-MON-RR'),to_date('12-MAR-97','DD-MON-RR'),to_date('14-FEB-97','DD-MON-RR'),1,13.95,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',null,'42100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10444,5,3,to_date('12-FEB-97','DD-MON-RR'),to_date('12-MAR-97','DD-MON-RR'),to_date('21-FEB-97','DD-MON-RR'),3,3.5,'Berglunds snabbk?p','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10445,5,3,to_date('13-FEB-97','DD-MON-RR'),to_date('13-MAR-97','DD-MON-RR'),to_date('20-FEB-97','DD-MON-RR'),1,9.3,'Berglunds snabbk?p','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10446,79,6,to_date('14-FEB-97','DD-MON-RR'),to_date('14-MAR-97','DD-MON-RR'),to_date('19-FEB-97','DD-MON-RR'),1,14.68,'Toms Spezialit?ten','Luisenstr. 48','M?nster',null,'44087','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10447,67,4,to_date('14-FEB-97','DD-MON-RR'),to_date('14-MAR-97','DD-MON-RR'),to_date('07-MAR-97','DD-MON-RR'),2,68.66,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10448,64,4,to_date('17-FEB-97','DD-MON-RR'),to_date('17-MAR-97','DD-MON-RR'),to_date('24-FEB-97','DD-MON-RR'),2,38.82,'Rancho grande','Av. del Libertador 900','Buenos Aires',null,'1010','Argentina');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10449,7,3,to_date('18-FEB-97','DD-MON-RR'),to_date('18-MAR-97','DD-MON-RR'),to_date('27-FEB-97','DD-MON-RR'),2,53.3,'Blondel p?re et fils','24, place Kl?ber','Strasbourg',null,'67000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10450,84,8,to_date('19-FEB-97','DD-MON-RR'),to_date('19-MAR-97','DD-MON-RR'),to_date('11-MAR-97','DD-MON-RR'),2,7.23,'Victuailles en stock','2, rue du Commerce','Lyon',null,'69004','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10451,63,4,to_date('19-FEB-97','DD-MON-RR'),to_date('05-MAR-97','DD-MON-RR'),to_date('12-MAR-97','DD-MON-RR'),3,189.09,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10452,71,8,to_date('20-FEB-97','DD-MON-RR'),to_date('20-MAR-97','DD-MON-RR'),to_date('26-FEB-97','DD-MON-RR'),1,140.26,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10453,4,1,to_date('21-FEB-97','DD-MON-RR'),to_date('21-MAR-97','DD-MON-RR'),to_date('26-FEB-97','DD-MON-RR'),2,25.36,'Around the Horn','Brook Farm
Stratford St. Mary','Colchester','Essex','CO7 6JX','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10454,41,4,to_date('21-FEB-97','DD-MON-RR'),to_date('21-MAR-97','DD-MON-RR'),to_date('25-FEB-97','DD-MON-RR'),3,2.74,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',null,'31000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10455,87,8,to_date('24-FEB-97','DD-MON-RR'),to_date('07-APR-97','DD-MON-RR'),to_date('03-MAR-97','DD-MON-RR'),2,180.45,'Wartian Herkku','Torikatu 38','Oulu',null,'90110','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10456,39,8,to_date('25-FEB-97','DD-MON-RR'),to_date('08-APR-97','DD-MON-RR'),to_date('28-FEB-97','DD-MON-RR'),2,8.12,'K?niglich Essen','Maubelstr. 90','Brandenburg',null,'14776','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10457,39,2,to_date('25-FEB-97','DD-MON-RR'),to_date('25-MAR-97','DD-MON-RR'),to_date('03-MAR-97','DD-MON-RR'),1,11.57,'K?niglich Essen','Maubelstr. 90','Brandenburg',null,'14776','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10458,76,7,to_date('26-FEB-97','DD-MON-RR'),to_date('26-MAR-97','DD-MON-RR'),to_date('04-MAR-97','DD-MON-RR'),3,147.06,'Supr?mes d?lices','Boulevard Tirou, 255','Charleroi',null,'B-6000','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10459,84,4,to_date('27-FEB-97','DD-MON-RR'),to_date('27-MAR-97','DD-MON-RR'),to_date('28-FEB-97','DD-MON-RR'),2,25.09,'Victuailles en stock','2, rue du Commerce','Lyon',null,'69004','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10460,24,8,to_date('28-FEB-97','DD-MON-RR'),to_date('28-MAR-97','DD-MON-RR'),to_date('03-MAR-97','DD-MON-RR'),1,16.27,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10461,46,1,to_date('28-FEB-97','DD-MON-RR'),to_date('28-MAR-97','DD-MON-RR'),to_date('05-MAR-97','DD-MON-RR'),3,148.61,'LILA-Supermercado','Carrera 52 con Ave. Bol?var #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10462,16,2,to_date('03-MAR-97','DD-MON-RR'),to_date('31-MAR-97','DD-MON-RR'),to_date('18-MAR-97','DD-MON-RR'),1,6.17,'Consolidated Holdings','Berkeley Gardens
12  Brewery ','London',null,'WX1 6LT','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10463,76,5,to_date('04-MAR-97','DD-MON-RR'),to_date('01-APR-97','DD-MON-RR'),to_date('06-MAR-97','DD-MON-RR'),3,14.78,'Supr?mes d?lices','Boulevard Tirou, 255','Charleroi',null,'B-6000','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10464,28,4,to_date('04-MAR-97','DD-MON-RR'),to_date('01-APR-97','DD-MON-RR'),to_date('14-MAR-97','DD-MON-RR'),2,89,'Furia Bacalhau e Frutos do Mar','Jardim das rosas n. 32','Lisboa',null,'1675','Portugal');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10465,83,1,to_date('05-MAR-97','DD-MON-RR'),to_date('02-APR-97','DD-MON-RR'),to_date('14-MAR-97','DD-MON-RR'),3,145.04,'Vaffeljernet','Smagsl?get 45','?rhus',null,'8200','Denmark');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10466,15,4,to_date('06-MAR-97','DD-MON-RR'),to_date('03-APR-97','DD-MON-RR'),to_date('13-MAR-97','DD-MON-RR'),1,11.93,'Com?rcio Mineiro','Av. dos Lus?adas, 23','S?o Paulo','SP','05432-043','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10467,49,8,to_date('06-MAR-97','DD-MON-RR'),to_date('03-APR-97','DD-MON-RR'),to_date('11-MAR-97','DD-MON-RR'),2,4.93,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',null,'24100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10468,39,3,to_date('07-MAR-97','DD-MON-RR'),to_date('04-APR-97','DD-MON-RR'),to_date('12-MAR-97','DD-MON-RR'),3,44.12,'K?niglich Essen','Maubelstr. 90','Brandenburg',null,'14776','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10469,89,1,to_date('10-MAR-97','DD-MON-RR'),to_date('07-APR-97','DD-MON-RR'),to_date('14-MAR-97','DD-MON-RR'),1,60.18,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10470,9,4,to_date('11-MAR-97','DD-MON-RR'),to_date('08-APR-97','DD-MON-RR'),to_date('14-MAR-97','DD-MON-RR'),2,64.56,'Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10471,11,2,to_date('11-MAR-97','DD-MON-RR'),to_date('08-APR-97','DD-MON-RR'),to_date('18-MAR-97','DD-MON-RR'),3,45.59,'B''s Beverages','Fauntleroy Circus','London',null,'EC2 5NT','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10472,72,8,to_date('12-MAR-97','DD-MON-RR'),to_date('09-APR-97','DD-MON-RR'),to_date('19-MAR-97','DD-MON-RR'),1,4.2,'Seven Seas Imports','90 Wadhurst Rd.','London',null,'OX15 4NB','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10473,38,1,to_date('13-MAR-97','DD-MON-RR'),to_date('27-MAR-97','DD-MON-RR'),to_date('21-MAR-97','DD-MON-RR'),3,16.37,'Island Trading','Garden House
Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10474,58,5,to_date('13-MAR-97','DD-MON-RR'),to_date('10-APR-97','DD-MON-RR'),to_date('21-MAR-97','DD-MON-RR'),2,83.49,'Pericles Comidas cl?sicas','Calle Dr. Jorge Cash 321','M?xico D.F.',null,'05033','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10475,76,9,to_date('14-MAR-97','DD-MON-RR'),to_date('11-APR-97','DD-MON-RR'),to_date('04-APR-97','DD-MON-RR'),1,68.52,'Supr?mes d?lices','Boulevard Tirou, 255','Charleroi',null,'B-6000','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10476,35,8,to_date('17-MAR-97','DD-MON-RR'),to_date('14-APR-97','DD-MON-RR'),to_date('24-MAR-97','DD-MON-RR'),3,4.41,'HILARI?N-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10477,60,5,to_date('17-MAR-97','DD-MON-RR'),to_date('14-APR-97','DD-MON-RR'),to_date('25-MAR-97','DD-MON-RR'),2,13.02,'Princesa Isabel Vinhos','Estrada da sa?de n. 58','Lisboa',null,'1756','Portugal');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10478,84,2,to_date('18-MAR-97','DD-MON-RR'),to_date('01-APR-97','DD-MON-RR'),to_date('26-MAR-97','DD-MON-RR'),3,4.81,'Victuailles en stock','2, rue du Commerce','Lyon',null,'69004','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10479,65,3,to_date('19-MAR-97','DD-MON-RR'),to_date('16-APR-97','DD-MON-RR'),to_date('21-MAR-97','DD-MON-RR'),3,708.95,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10480,23,6,to_date('20-MAR-97','DD-MON-RR'),to_date('17-APR-97','DD-MON-RR'),to_date('24-MAR-97','DD-MON-RR'),2,1.35,'Folies gourmandes','184, chauss?e de Tournai','Lille',null,'59000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10481,67,8,to_date('20-MAR-97','DD-MON-RR'),to_date('17-APR-97','DD-MON-RR'),to_date('25-MAR-97','DD-MON-RR'),2,64.33,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10482,43,1,to_date('21-MAR-97','DD-MON-RR'),to_date('18-APR-97','DD-MON-RR'),to_date('10-APR-97','DD-MON-RR'),3,7.48,'Lazy K Kountry Store','12 Orchestra Terrace','Walla Walla','WA','99362','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10483,89,7,to_date('24-MAR-97','DD-MON-RR'),to_date('21-APR-97','DD-MON-RR'),to_date('25-APR-97','DD-MON-RR'),2,15.28,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10484,11,3,to_date('24-MAR-97','DD-MON-RR'),to_date('21-APR-97','DD-MON-RR'),to_date('01-APR-97','DD-MON-RR'),3,6.88,'B''s Beverages','Fauntleroy Circus','London',null,'EC2 5NT','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10485,47,4,to_date('25-MAR-97','DD-MON-RR'),to_date('08-APR-97','DD-MON-RR'),to_date('31-MAR-97','DD-MON-RR'),2,64.45,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10486,35,1,to_date('26-MAR-97','DD-MON-RR'),to_date('23-APR-97','DD-MON-RR'),to_date('02-APR-97','DD-MON-RR'),2,30.53,'HILARI?N-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10487,62,2,to_date('26-MAR-97','DD-MON-RR'),to_date('23-APR-97','DD-MON-RR'),to_date('28-MAR-97','DD-MON-RR'),2,71.07,'Queen Cozinha','Alameda dos Can?rios, 891','S?o Paulo','SP','05487-020','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10488,25,8,to_date('27-MAR-97','DD-MON-RR'),to_date('24-APR-97','DD-MON-RR'),to_date('02-APR-97','DD-MON-RR'),2,4.93,'Frankenversand','Berliner Platz 43','M?nchen',null,'80805','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10489,59,6,to_date('28-MAR-97','DD-MON-RR'),to_date('25-APR-97','DD-MON-RR'),to_date('09-APR-97','DD-MON-RR'),2,5.29,'Piccolo und mehr','Geislweg 14','Salzburg',null,'5020','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10490,35,7,to_date('31-MAR-97','DD-MON-RR'),to_date('28-APR-97','DD-MON-RR'),to_date('03-APR-97','DD-MON-RR'),2,210.19,'HILARI?N-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10491,28,8,to_date('31-MAR-97','DD-MON-RR'),to_date('28-APR-97','DD-MON-RR'),to_date('08-APR-97','DD-MON-RR'),3,16.96,'Furia Bacalhau e Frutos do Mar','Jardim das rosas n. 32','Lisboa',null,'1675','Portugal');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10492,10,3,to_date('01-APR-97','DD-MON-RR'),to_date('29-APR-97','DD-MON-RR'),to_date('11-APR-97','DD-MON-RR'),1,62.89,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10493,41,4,to_date('02-APR-97','DD-MON-RR'),to_date('30-APR-97','DD-MON-RR'),to_date('10-APR-97','DD-MON-RR'),3,10.64,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',null,'31000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10494,15,4,to_date('02-APR-97','DD-MON-RR'),to_date('30-APR-97','DD-MON-RR'),to_date('09-APR-97','DD-MON-RR'),2,65.99,'Com?rcio Mineiro','Av. dos Lus?adas, 23','S?o Paulo','SP','05432-043','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10495,42,3,to_date('03-APR-97','DD-MON-RR'),to_date('01-MAY-97','DD-MON-RR'),to_date('11-APR-97','DD-MON-RR'),3,4.65,'Laughing Bacchus Wine Cellars','2319 Elm St.','Vancouver','BC','V3F 2K1','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10496,81,7,to_date('04-APR-97','DD-MON-RR'),to_date('02-MAY-97','DD-MON-RR'),to_date('07-APR-97','DD-MON-RR'),2,46.77,'Tradi??o Hipermercados','Av. In?s de Castro, 414','S?o Paulo','SP','05634-030','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10497,44,7,to_date('04-APR-97','DD-MON-RR'),to_date('02-MAY-97','DD-MON-RR'),to_date('07-APR-97','DD-MON-RR'),1,36.21,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M. ',null,'60528','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10498,35,8,to_date('07-APR-97','DD-MON-RR'),to_date('05-MAY-97','DD-MON-RR'),to_date('11-APR-97','DD-MON-RR'),2,29.75,'HILARI?N-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10499,46,4,to_date('08-APR-97','DD-MON-RR'),to_date('06-MAY-97','DD-MON-RR'),to_date('16-APR-97','DD-MON-RR'),2,102.02,'LILA-Supermercado','Carrera 52 con Ave. Bol?var #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10500,41,6,to_date('09-APR-97','DD-MON-RR'),to_date('07-MAY-97','DD-MON-RR'),to_date('17-APR-97','DD-MON-RR'),1,42.68,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',null,'31000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10501,6,9,to_date('09-APR-97','DD-MON-RR'),to_date('07-MAY-97','DD-MON-RR'),to_date('16-APR-97','DD-MON-RR'),3,8.85,'Blauer See Delikatessen','Forsterstr. 57','Mannheim',null,'68306','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10502,58,2,to_date('10-APR-97','DD-MON-RR'),to_date('08-MAY-97','DD-MON-RR'),to_date('29-APR-97','DD-MON-RR'),1,69.32,'Pericles Comidas cl?sicas','Calle Dr. Jorge Cash 321','M?xico D.F.',null,'05033','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10503,37,6,to_date('11-APR-97','DD-MON-RR'),to_date('09-MAY-97','DD-MON-RR'),to_date('16-APR-97','DD-MON-RR'),2,16.74,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10504,89,4,to_date('11-APR-97','DD-MON-RR'),to_date('09-MAY-97','DD-MON-RR'),to_date('18-APR-97','DD-MON-RR'),3,59.13,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10505,51,3,to_date('14-APR-97','DD-MON-RR'),to_date('12-MAY-97','DD-MON-RR'),to_date('21-APR-97','DD-MON-RR'),3,7.13,'M?re Paillarde','43 rue St. Laurent','Montr?al','Qu?bec','H1J 1C3','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10506,39,9,to_date('15-APR-97','DD-MON-RR'),to_date('13-MAY-97','DD-MON-RR'),to_date('02-MAY-97','DD-MON-RR'),2,21.19,'K?niglich Essen','Maubelstr. 90','Brandenburg',null,'14776','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10507,3,7,to_date('15-APR-97','DD-MON-RR'),to_date('13-MAY-97','DD-MON-RR'),to_date('22-APR-97','DD-MON-RR'),1,47.45,'Antonio Moreno Taquer?a','Mataderos  2312','M?xico D.F.',null,'05023','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10508,56,1,to_date('16-APR-97','DD-MON-RR'),to_date('14-MAY-97','DD-MON-RR'),to_date('13-MAY-97','DD-MON-RR'),2,4.99,'Ottilies K?seladen','Mehrheimerstr. 369','K?ln',null,'50739','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10509,6,4,to_date('17-APR-97','DD-MON-RR'),to_date('15-MAY-97','DD-MON-RR'),to_date('29-APR-97','DD-MON-RR'),1,0.15,'Blauer See Delikatessen','Forsterstr. 57','Mannheim',null,'68306','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10510,71,6,to_date('18-APR-97','DD-MON-RR'),to_date('16-MAY-97','DD-MON-RR'),to_date('28-APR-97','DD-MON-RR'),3,367.63,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10511,9,4,to_date('18-APR-97','DD-MON-RR'),to_date('16-MAY-97','DD-MON-RR'),to_date('21-APR-97','DD-MON-RR'),3,350.64,'Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10512,21,7,to_date('21-APR-97','DD-MON-RR'),to_date('19-MAY-97','DD-MON-RR'),to_date('24-APR-97','DD-MON-RR'),2,3.53,'Familia Arquibaldo','Rua Or?s, 92','S?o Paulo','SP','05442-030','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10513,86,7,to_date('22-APR-97','DD-MON-RR'),to_date('03-JUN-97','DD-MON-RR'),to_date('28-APR-97','DD-MON-RR'),1,105.65,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',null,'70563','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10514,20,3,to_date('22-APR-97','DD-MON-RR'),to_date('20-MAY-97','DD-MON-RR'),to_date('16-MAY-97','DD-MON-RR'),2,789.95,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10515,63,2,to_date('23-APR-97','DD-MON-RR'),to_date('07-MAY-97','DD-MON-RR'),to_date('23-MAY-97','DD-MON-RR'),1,204.47,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10516,37,2,to_date('24-APR-97','DD-MON-RR'),to_date('22-MAY-97','DD-MON-RR'),to_date('01-MAY-97','DD-MON-RR'),3,62.78,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10517,53,3,to_date('24-APR-97','DD-MON-RR'),to_date('22-MAY-97','DD-MON-RR'),to_date('29-APR-97','DD-MON-RR'),3,32.07,'North/South','South House
300 Queensbridge','London',null,'SW7 1RZ','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10518,80,4,to_date('25-APR-97','DD-MON-RR'),to_date('09-MAY-97','DD-MON-RR'),to_date('05-MAY-97','DD-MON-RR'),2,218.15,'Tortuga Restaurante','Avda. Azteca 123','M?xico D.F.',null,'05033','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10519,14,6,to_date('28-APR-97','DD-MON-RR'),to_date('26-MAY-97','DD-MON-RR'),to_date('01-MAY-97','DD-MON-RR'),3,91.76,'Chop-suey Chinese','Hauptstr. 31','Bern',null,'3012','Switzerland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10520,70,7,to_date('29-APR-97','DD-MON-RR'),to_date('27-MAY-97','DD-MON-RR'),to_date('01-MAY-97','DD-MON-RR'),1,13.37,'Sant? Gourmet','Erling Skakkes gate 78','Stavern',null,'4110','Norway');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10521,12,8,to_date('29-APR-97','DD-MON-RR'),to_date('27-MAY-97','DD-MON-RR'),to_date('02-MAY-97','DD-MON-RR'),2,17.22,'Cactus Comidas para llevar','Cerrito 333','Buenos Aires',null,'1010','Argentina');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10522,44,4,to_date('30-APR-97','DD-MON-RR'),to_date('28-MAY-97','DD-MON-RR'),to_date('06-MAY-97','DD-MON-RR'),1,45.33,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M. ',null,'60528','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10523,72,7,to_date('01-MAY-97','DD-MON-RR'),to_date('29-MAY-97','DD-MON-RR'),to_date('30-MAY-97','DD-MON-RR'),2,77.63,'Seven Seas Imports','90 Wadhurst Rd.','London',null,'OX15 4NB','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10524,5,1,to_date('01-MAY-97','DD-MON-RR'),to_date('29-MAY-97','DD-MON-RR'),to_date('07-MAY-97','DD-MON-RR'),2,244.79,'Berglunds snabbk?p','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10525,9,1,to_date('02-MAY-97','DD-MON-RR'),to_date('30-MAY-97','DD-MON-RR'),to_date('23-MAY-97','DD-MON-RR'),2,11.06,'Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10526,87,4,to_date('05-MAY-97','DD-MON-RR'),to_date('02-JUN-97','DD-MON-RR'),to_date('15-MAY-97','DD-MON-RR'),2,58.59,'Wartian Herkku','Torikatu 38','Oulu',null,'90110','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10527,63,7,to_date('05-MAY-97','DD-MON-RR'),to_date('02-JUN-97','DD-MON-RR'),to_date('07-MAY-97','DD-MON-RR'),1,41.9,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10528,32,6,to_date('06-MAY-97','DD-MON-RR'),to_date('20-MAY-97','DD-MON-RR'),to_date('09-MAY-97','DD-MON-RR'),2,3.35,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10529,50,5,to_date('07-MAY-97','DD-MON-RR'),to_date('04-JUN-97','DD-MON-RR'),to_date('09-MAY-97','DD-MON-RR'),2,66.69,'Maison Dewey','Rue Joseph-Bens 532','Bruxelles',null,'B-1180','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10530,59,3,to_date('08-MAY-97','DD-MON-RR'),to_date('05-JUN-97','DD-MON-RR'),to_date('12-MAY-97','DD-MON-RR'),2,339.22,'Piccolo und mehr','Geislweg 14','Salzburg',null,'5020','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10531,54,7,to_date('08-MAY-97','DD-MON-RR'),to_date('05-JUN-97','DD-MON-RR'),to_date('19-MAY-97','DD-MON-RR'),1,8.12,'Oc?ano Atl?ntico Ltda.','Ing. Gustavo Moncada 8585
Piso 20-A','Buenos Aires',null,'1010','Argentina');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10532,19,7,to_date('09-MAY-97','DD-MON-RR'),to_date('06-JUN-97','DD-MON-RR'),to_date('12-MAY-97','DD-MON-RR'),3,74.46,'Eastern Connection','35 King George','London',null,'WX3 6FW','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10533,24,8,to_date('12-MAY-97','DD-MON-RR'),to_date('09-JUN-97','DD-MON-RR'),to_date('22-MAY-97','DD-MON-RR'),1,188.04,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10534,44,8,to_date('12-MAY-97','DD-MON-RR'),to_date('09-JUN-97','DD-MON-RR'),to_date('14-MAY-97','DD-MON-RR'),2,27.94,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M. ',null,'60528','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10535,3,4,to_date('13-MAY-97','DD-MON-RR'),to_date('10-JUN-97','DD-MON-RR'),to_date('21-MAY-97','DD-MON-RR'),1,15.64,'Antonio Moreno Taquer?a','Mataderos  2312','M?xico D.F.',null,'05023','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10536,44,3,to_date('14-MAY-97','DD-MON-RR'),to_date('11-JUN-97','DD-MON-RR'),to_date('06-JUN-97','DD-MON-RR'),2,58.88,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M. ',null,'60528','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10537,68,1,to_date('14-MAY-97','DD-MON-RR'),to_date('28-MAY-97','DD-MON-RR'),to_date('19-MAY-97','DD-MON-RR'),1,78.85,'Richter Supermarkt','Starenweg 5','Gen?ve',null,'1204','Switzerland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10538,11,9,to_date('15-MAY-97','DD-MON-RR'),to_date('12-JUN-97','DD-MON-RR'),to_date('16-MAY-97','DD-MON-RR'),3,4.87,'B''s Beverages','Fauntleroy Circus','London',null,'EC2 5NT','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10539,11,6,to_date('16-MAY-97','DD-MON-RR'),to_date('13-JUN-97','DD-MON-RR'),to_date('23-MAY-97','DD-MON-RR'),3,12.36,'B''s Beverages','Fauntleroy Circus','London',null,'EC2 5NT','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10540,63,3,to_date('19-MAY-97','DD-MON-RR'),to_date('16-JUN-97','DD-MON-RR'),to_date('13-JUN-97','DD-MON-RR'),3,1007.64,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10541,34,2,to_date('19-MAY-97','DD-MON-RR'),to_date('16-JUN-97','DD-MON-RR'),to_date('29-MAY-97','DD-MON-RR'),1,68.65,'Hanari Carnes','Rua do Pa?o, 67','Rio de Janeiro','RJ','05454-876','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10542,39,1,to_date('20-MAY-97','DD-MON-RR'),to_date('17-JUN-97','DD-MON-RR'),to_date('26-MAY-97','DD-MON-RR'),3,10.95,'K?niglich Essen','Maubelstr. 90','Brandenburg',null,'14776','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10543,46,8,to_date('21-MAY-97','DD-MON-RR'),to_date('18-JUN-97','DD-MON-RR'),to_date('23-MAY-97','DD-MON-RR'),2,48.17,'LILA-Supermercado','Carrera 52 con Ave. Bol?var #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10544,48,4,to_date('21-MAY-97','DD-MON-RR'),to_date('18-JUN-97','DD-MON-RR'),to_date('30-MAY-97','DD-MON-RR'),1,24.91,'Lonesome Pine Restaurant','89 Chiaroscuro Rd.','Portland','OR','97219','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10545,43,8,to_date('22-MAY-97','DD-MON-RR'),to_date('19-JUN-97','DD-MON-RR'),to_date('26-JUN-97','DD-MON-RR'),2,11.92,'Lazy K Kountry Store','12 Orchestra Terrace','Walla Walla','WA','99362','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10546,84,1,to_date('23-MAY-97','DD-MON-RR'),to_date('20-JUN-97','DD-MON-RR'),to_date('27-MAY-97','DD-MON-RR'),3,194.72,'Victuailles en stock','2, rue du Commerce','Lyon',null,'69004','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10547,72,3,to_date('23-MAY-97','DD-MON-RR'),to_date('20-JUN-97','DD-MON-RR'),to_date('02-JUN-97','DD-MON-RR'),2,178.43,'Seven Seas Imports','90 Wadhurst Rd.','London',null,'OX15 4NB','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10548,79,3,to_date('26-MAY-97','DD-MON-RR'),to_date('23-JUN-97','DD-MON-RR'),to_date('02-JUN-97','DD-MON-RR'),2,1.43,'Toms Spezialit?ten','Luisenstr. 48','M?nster',null,'44087','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10549,63,5,to_date('27-MAY-97','DD-MON-RR'),to_date('10-JUN-97','DD-MON-RR'),to_date('30-MAY-97','DD-MON-RR'),1,171.24,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10550,30,7,to_date('28-MAY-97','DD-MON-RR'),to_date('25-JUN-97','DD-MON-RR'),to_date('06-JUN-97','DD-MON-RR'),3,4.32,'Godos Cocina T?pica','C/ Romero, 33','Sevilla',null,'41101','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10551,28,4,to_date('28-MAY-97','DD-MON-RR'),to_date('09-JUL-97','DD-MON-RR'),to_date('06-JUN-97','DD-MON-RR'),3,72.95,'Furia Bacalhau e Frutos do Mar','Jardim das rosas n. 32','Lisboa',null,'1675','Portugal');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10552,35,2,to_date('29-MAY-97','DD-MON-RR'),to_date('26-JUN-97','DD-MON-RR'),to_date('05-JUN-97','DD-MON-RR'),1,83.22,'HILARI?N-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10553,87,2,to_date('30-MAY-97','DD-MON-RR'),to_date('27-JUN-97','DD-MON-RR'),to_date('03-JUN-97','DD-MON-RR'),2,149.49,'Wartian Herkku','Torikatu 38','Oulu',null,'90110','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10554,56,4,to_date('30-MAY-97','DD-MON-RR'),to_date('27-JUN-97','DD-MON-RR'),to_date('05-JUN-97','DD-MON-RR'),3,120.97,'Ottilies K?seladen','Mehrheimerstr. 369','K?ln',null,'50739','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10555,71,6,to_date('02-JUN-97','DD-MON-RR'),to_date('30-JUN-97','DD-MON-RR'),to_date('04-JUN-97','DD-MON-RR'),3,252.49,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10556,73,2,to_date('03-JUN-97','DD-MON-RR'),to_date('15-JUL-97','DD-MON-RR'),to_date('13-JUN-97','DD-MON-RR'),1,9.8,'Simons bistro','Vinb?ltet 34','K?benhavn',null,'1734','Denmark');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10557,44,9,to_date('03-JUN-97','DD-MON-RR'),to_date('17-JUN-97','DD-MON-RR'),to_date('06-JUN-97','DD-MON-RR'),2,96.72,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M. ',null,'60528','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10558,4,1,to_date('04-JUN-97','DD-MON-RR'),to_date('02-JUL-97','DD-MON-RR'),to_date('10-JUN-97','DD-MON-RR'),2,72.97,'Around the Horn','Brook Farm
Stratford St. Mary','Colchester','Essex','CO7 6JX','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10559,7,6,to_date('05-JUN-97','DD-MON-RR'),to_date('03-JUL-97','DD-MON-RR'),to_date('13-JUN-97','DD-MON-RR'),1,8.05,'Blondel p?re et fils','24, place Kl?ber','Strasbourg',null,'67000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10560,25,8,to_date('06-JUN-97','DD-MON-RR'),to_date('04-JUL-97','DD-MON-RR'),to_date('09-JUN-97','DD-MON-RR'),1,36.65,'Frankenversand','Berliner Platz 43','M?nchen',null,'80805','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10248,85,5,to_date('04-JUL-96','DD-MON-RR'),to_date('01-AUG-96','DD-MON-RR'),to_date('16-JUL-96','DD-MON-RR'),3,32.38,'Vins et alcools Chevalier','59 rue de l''Abbaye','Reims',null,'51100','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10249,79,6,to_date('05-JUL-96','DD-MON-RR'),to_date('16-AUG-96','DD-MON-RR'),to_date('10-JUL-96','DD-MON-RR'),1,11.61,'Toms Spezialit?ten','Luisenstr. 48','M?nster',null,'44087','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10250,34,4,to_date('08-JUL-96','DD-MON-RR'),to_date('05-AUG-96','DD-MON-RR'),to_date('12-JUL-96','DD-MON-RR'),2,65.83,'Hanari Carnes','Rua do Pa?o, 67','Rio de Janeiro','RJ','05454-876','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10251,84,3,to_date('08-JUL-96','DD-MON-RR'),to_date('05-AUG-96','DD-MON-RR'),to_date('15-JUL-96','DD-MON-RR'),1,41.34,'Victuailles en stock','2, rue du Commerce','Lyon',null,'69004','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10252,76,4,to_date('09-JUL-96','DD-MON-RR'),to_date('06-AUG-96','DD-MON-RR'),to_date('11-JUL-96','DD-MON-RR'),2,51.3,'Supr?mes d?lices','Boulevard Tirou, 255','Charleroi',null,'B-6000','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10253,34,3,to_date('10-JUL-96','DD-MON-RR'),to_date('24-JUL-96','DD-MON-RR'),to_date('16-JUL-96','DD-MON-RR'),2,58.17,'Hanari Carnes','Rua do Pa?o, 67','Rio de Janeiro','RJ','05454-876','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10254,14,5,to_date('11-JUL-96','DD-MON-RR'),to_date('08-AUG-96','DD-MON-RR'),to_date('23-JUL-96','DD-MON-RR'),2,22.98,'Chop-suey Chinese','Hauptstr. 31','Bern',null,'3012','Switzerland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10255,68,9,to_date('12-JUL-96','DD-MON-RR'),to_date('09-AUG-96','DD-MON-RR'),to_date('15-JUL-96','DD-MON-RR'),3,148.33,'Richter Supermarkt','Starenweg 5','Gen?ve',null,'1204','Switzerland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10256,88,3,to_date('15-JUL-96','DD-MON-RR'),to_date('12-AUG-96','DD-MON-RR'),to_date('17-JUL-96','DD-MON-RR'),2,13.97,'Wellington Importadora','Rua do Mercado, 12','Resende','SP','08737-363','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10257,35,4,to_date('16-JUL-96','DD-MON-RR'),to_date('13-AUG-96','DD-MON-RR'),to_date('22-JUL-96','DD-MON-RR'),3,81.91,'HILARI?N-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10258,20,1,to_date('17-JUL-96','DD-MON-RR'),to_date('14-AUG-96','DD-MON-RR'),to_date('23-JUL-96','DD-MON-RR'),1,140.51,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10259,13,4,to_date('18-JUL-96','DD-MON-RR'),to_date('15-AUG-96','DD-MON-RR'),to_date('25-JUL-96','DD-MON-RR'),3,3.25,'Centro comercial Moctezuma','Sierras de Granada 9993','M?xico D.F.',null,'05022','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10260,56,4,to_date('19-JUL-96','DD-MON-RR'),to_date('16-AUG-96','DD-MON-RR'),to_date('29-JUL-96','DD-MON-RR'),1,55.09,'Ottilies K?seladen','Mehrheimerstr. 369','K?ln',null,'50739','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10261,61,4,to_date('19-JUL-96','DD-MON-RR'),to_date('16-AUG-96','DD-MON-RR'),to_date('30-JUL-96','DD-MON-RR'),2,3.05,'Que Del?cia','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10262,65,8,to_date('22-JUL-96','DD-MON-RR'),to_date('19-AUG-96','DD-MON-RR'),to_date('25-JUL-96','DD-MON-RR'),3,48.29,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10263,20,9,to_date('23-JUL-96','DD-MON-RR'),to_date('20-AUG-96','DD-MON-RR'),to_date('31-JUL-96','DD-MON-RR'),3,146.06,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10264,24,6,to_date('24-JUL-96','DD-MON-RR'),to_date('21-AUG-96','DD-MON-RR'),to_date('23-AUG-96','DD-MON-RR'),3,3.67,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10265,7,2,to_date('25-JUL-96','DD-MON-RR'),to_date('22-AUG-96','DD-MON-RR'),to_date('12-AUG-96','DD-MON-RR'),1,55.28,'Blondel p?re et fils','24, place Kl?ber','Strasbourg',null,'67000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10266,87,3,to_date('26-JUL-96','DD-MON-RR'),to_date('06-SEP-96','DD-MON-RR'),to_date('31-JUL-96','DD-MON-RR'),3,25.73,'Wartian Herkku','Torikatu 38','Oulu',null,'90110','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10267,25,4,to_date('29-JUL-96','DD-MON-RR'),to_date('26-AUG-96','DD-MON-RR'),to_date('06-AUG-96','DD-MON-RR'),1,208.58,'Frankenversand','Berliner Platz 43','M?nchen',null,'80805','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10268,33,8,to_date('30-JUL-96','DD-MON-RR'),to_date('27-AUG-96','DD-MON-RR'),to_date('02-AUG-96','DD-MON-RR'),3,66.29,'GROSELLA-Restaurante','5? Ave. Los Palos Grandes','Caracas','DF','1081','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10269,89,5,to_date('31-JUL-96','DD-MON-RR'),to_date('14-AUG-96','DD-MON-RR'),to_date('09-AUG-96','DD-MON-RR'),1,4.56,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10270,87,1,to_date('01-AUG-96','DD-MON-RR'),to_date('29-AUG-96','DD-MON-RR'),to_date('02-AUG-96','DD-MON-RR'),1,136.54,'Wartian Herkku','Torikatu 38','Oulu',null,'90110','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10271,75,6,to_date('01-AUG-96','DD-MON-RR'),to_date('29-AUG-96','DD-MON-RR'),to_date('30-AUG-96','DD-MON-RR'),2,4.54,'Split Rail Beer & Ale','P.O. Box 555','Lander','WY','82520','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10272,65,6,to_date('02-AUG-96','DD-MON-RR'),to_date('30-AUG-96','DD-MON-RR'),to_date('06-AUG-96','DD-MON-RR'),2,98.03,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10273,63,3,to_date('05-AUG-96','DD-MON-RR'),to_date('02-SEP-96','DD-MON-RR'),to_date('12-AUG-96','DD-MON-RR'),3,76.07,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10274,85,6,to_date('06-AUG-96','DD-MON-RR'),to_date('03-SEP-96','DD-MON-RR'),to_date('16-AUG-96','DD-MON-RR'),1,6.01,'Vins et alcools Chevalier','59 rue de l''Abbaye','Reims',null,'51100','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10275,49,1,to_date('07-AUG-96','DD-MON-RR'),to_date('04-SEP-96','DD-MON-RR'),to_date('09-AUG-96','DD-MON-RR'),1,26.93,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',null,'24100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10276,80,8,to_date('08-AUG-96','DD-MON-RR'),to_date('22-AUG-96','DD-MON-RR'),to_date('14-AUG-96','DD-MON-RR'),3,13.84,'Tortuga Restaurante','Avda. Azteca 123','M?xico D.F.',null,'05033','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10277,52,2,to_date('09-AUG-96','DD-MON-RR'),to_date('06-SEP-96','DD-MON-RR'),to_date('13-AUG-96','DD-MON-RR'),3,125.77,'Morgenstern Gesundkost','Heerstr. 22','Leipzig',null,'04179','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10278,5,8,to_date('12-AUG-96','DD-MON-RR'),to_date('09-SEP-96','DD-MON-RR'),to_date('16-AUG-96','DD-MON-RR'),2,92.69,'Berglunds snabbk?p','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10279,44,8,to_date('13-AUG-96','DD-MON-RR'),to_date('10-SEP-96','DD-MON-RR'),to_date('16-AUG-96','DD-MON-RR'),2,25.83,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M. ',null,'60528','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10280,5,2,to_date('14-AUG-96','DD-MON-RR'),to_date('11-SEP-96','DD-MON-RR'),to_date('12-SEP-96','DD-MON-RR'),1,8.98,'Berglunds snabbk?p','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10281,69,4,to_date('14-AUG-96','DD-MON-RR'),to_date('28-AUG-96','DD-MON-RR'),to_date('21-AUG-96','DD-MON-RR'),1,2.94,'Romero y tomillo','Gran V?a, 1','Madrid',null,'28001','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10282,69,4,to_date('15-AUG-96','DD-MON-RR'),to_date('12-SEP-96','DD-MON-RR'),to_date('21-AUG-96','DD-MON-RR'),1,12.69,'Romero y tomillo','Gran V?a, 1','Madrid',null,'28001','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10283,46,3,to_date('16-AUG-96','DD-MON-RR'),to_date('13-SEP-96','DD-MON-RR'),to_date('23-AUG-96','DD-MON-RR'),3,84.81,'LILA-Supermercado','Carrera 52 con Ave. Bol?var #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10284,44,4,to_date('19-AUG-96','DD-MON-RR'),to_date('16-SEP-96','DD-MON-RR'),to_date('27-AUG-96','DD-MON-RR'),1,76.56,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M. ',null,'60528','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10285,63,1,to_date('20-AUG-96','DD-MON-RR'),to_date('17-SEP-96','DD-MON-RR'),to_date('26-AUG-96','DD-MON-RR'),2,76.83,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10286,63,8,to_date('21-AUG-96','DD-MON-RR'),to_date('18-SEP-96','DD-MON-RR'),to_date('30-AUG-96','DD-MON-RR'),3,229.24,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10287,67,8,to_date('22-AUG-96','DD-MON-RR'),to_date('19-SEP-96','DD-MON-RR'),to_date('28-AUG-96','DD-MON-RR'),3,12.76,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10288,66,4,to_date('23-AUG-96','DD-MON-RR'),to_date('20-SEP-96','DD-MON-RR'),to_date('03-SEP-96','DD-MON-RR'),1,7.45,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',null,'42100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10289,11,7,to_date('26-AUG-96','DD-MON-RR'),to_date('23-SEP-96','DD-MON-RR'),to_date('28-AUG-96','DD-MON-RR'),3,22.77,'B''s Beverages','Fauntleroy Circus','London',null,'EC2 5NT','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10290,15,8,to_date('27-AUG-96','DD-MON-RR'),to_date('24-SEP-96','DD-MON-RR'),to_date('03-SEP-96','DD-MON-RR'),1,79.7,'Com?rcio Mineiro','Av. dos Lus?adas, 23','S?o Paulo','SP','05432-043','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10291,61,6,to_date('27-AUG-96','DD-MON-RR'),to_date('24-SEP-96','DD-MON-RR'),to_date('04-SEP-96','DD-MON-RR'),2,6.4,'Que Del?cia','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10292,81,1,to_date('28-AUG-96','DD-MON-RR'),to_date('25-SEP-96','DD-MON-RR'),to_date('02-SEP-96','DD-MON-RR'),2,1.35,'Tradi??o Hipermercados','Av. In?s de Castro, 414','S?o Paulo','SP','05634-030','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10293,80,1,to_date('29-AUG-96','DD-MON-RR'),to_date('26-SEP-96','DD-MON-RR'),to_date('11-SEP-96','DD-MON-RR'),3,21.18,'Tortuga Restaurante','Avda. Azteca 123','M?xico D.F.',null,'05033','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10294,65,4,to_date('30-AUG-96','DD-MON-RR'),to_date('27-SEP-96','DD-MON-RR'),to_date('05-SEP-96','DD-MON-RR'),2,147.26,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10295,85,2,to_date('02-SEP-96','DD-MON-RR'),to_date('30-SEP-96','DD-MON-RR'),to_date('10-SEP-96','DD-MON-RR'),2,1.15,'Vins et alcools Chevalier','59 rue de l''Abbaye','Reims',null,'51100','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10296,46,6,to_date('03-SEP-96','DD-MON-RR'),to_date('01-OCT-96','DD-MON-RR'),to_date('11-SEP-96','DD-MON-RR'),1,0.12,'LILA-Supermercado','Carrera 52 con Ave. Bol?var #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10297,7,5,to_date('04-SEP-96','DD-MON-RR'),to_date('16-OCT-96','DD-MON-RR'),to_date('10-SEP-96','DD-MON-RR'),2,5.74,'Blondel p?re et fils','24, place Kl?ber','Strasbourg',null,'67000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10298,37,6,to_date('05-SEP-96','DD-MON-RR'),to_date('03-OCT-96','DD-MON-RR'),to_date('11-SEP-96','DD-MON-RR'),2,168.22,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10299,67,4,to_date('06-SEP-96','DD-MON-RR'),to_date('04-OCT-96','DD-MON-RR'),to_date('13-SEP-96','DD-MON-RR'),2,29.76,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10300,49,2,to_date('09-SEP-96','DD-MON-RR'),to_date('07-OCT-96','DD-MON-RR'),to_date('18-SEP-96','DD-MON-RR'),2,17.68,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',null,'24100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10301,86,8,to_date('09-SEP-96','DD-MON-RR'),to_date('07-OCT-96','DD-MON-RR'),to_date('17-SEP-96','DD-MON-RR'),2,45.08,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',null,'70563','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10302,76,4,to_date('10-SEP-96','DD-MON-RR'),to_date('08-OCT-96','DD-MON-RR'),to_date('09-OCT-96','DD-MON-RR'),2,6.27,'Supr?mes d?lices','Boulevard Tirou, 255','Charleroi',null,'B-6000','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10303,30,7,to_date('11-SEP-96','DD-MON-RR'),to_date('09-OCT-96','DD-MON-RR'),to_date('18-SEP-96','DD-MON-RR'),2,107.83,'Godos Cocina T?pica','C/ Romero, 33','Sevilla',null,'41101','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10304,80,1,to_date('12-SEP-96','DD-MON-RR'),to_date('10-OCT-96','DD-MON-RR'),to_date('17-SEP-96','DD-MON-RR'),2,63.79,'Tortuga Restaurante','Avda. Azteca 123','M?xico D.F.',null,'05033','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10305,55,8,to_date('13-SEP-96','DD-MON-RR'),to_date('11-OCT-96','DD-MON-RR'),to_date('09-OCT-96','DD-MON-RR'),3,257.62,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10306,69,1,to_date('16-SEP-96','DD-MON-RR'),to_date('14-OCT-96','DD-MON-RR'),to_date('23-SEP-96','DD-MON-RR'),3,7.56,'Romero y tomillo','Gran V?a, 1','Madrid',null,'28001','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10307,48,2,to_date('17-SEP-96','DD-MON-RR'),to_date('15-OCT-96','DD-MON-RR'),to_date('25-SEP-96','DD-MON-RR'),2,0.56,'Lonesome Pine Restaurant','89 Chiaroscuro Rd.','Portland','OR','97219','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10308,2,7,to_date('18-SEP-96','DD-MON-RR'),to_date('16-OCT-96','DD-MON-RR'),to_date('24-SEP-96','DD-MON-RR'),3,1.61,'Ana Trujillo Emparedados y helados','Avda. de la Constituci?n 2222','M?xico D.F.',null,'05021','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10309,37,3,to_date('19-SEP-96','DD-MON-RR'),to_date('17-OCT-96','DD-MON-RR'),to_date('23-OCT-96','DD-MON-RR'),1,47.3,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10310,77,8,to_date('20-SEP-96','DD-MON-RR'),to_date('18-OCT-96','DD-MON-RR'),to_date('27-SEP-96','DD-MON-RR'),2,17.52,'The Big Cheese','89 Jefferson Way
Suite 2','Portland','OR','97201','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10311,18,1,to_date('20-SEP-96','DD-MON-RR'),to_date('04-OCT-96','DD-MON-RR'),to_date('26-SEP-96','DD-MON-RR'),3,24.69,'Du monde entier','67, rue des Cinquante Otages','Nantes',null,'44000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10691,63,2,to_date('03-OCT-97','DD-MON-RR'),to_date('14-NOV-97','DD-MON-RR'),to_date('22-OCT-97','DD-MON-RR'),2,810.05,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10692,1,4,to_date('03-OCT-97','DD-MON-RR'),to_date('31-OCT-97','DD-MON-RR'),to_date('13-OCT-97','DD-MON-RR'),2,61.02,'Alfreds Futterkiste','Obere Str. 57','Berlin',null,'12209','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10693,89,3,to_date('06-OCT-97','DD-MON-RR'),to_date('20-OCT-97','DD-MON-RR'),to_date('10-OCT-97','DD-MON-RR'),3,139.34,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10694,63,8,to_date('06-OCT-97','DD-MON-RR'),to_date('03-NOV-97','DD-MON-RR'),to_date('09-OCT-97','DD-MON-RR'),3,398.36,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10695,90,7,to_date('07-OCT-97','DD-MON-RR'),to_date('18-NOV-97','DD-MON-RR'),to_date('14-OCT-97','DD-MON-RR'),1,16.72,'Wilman Kala','Keskuskatu 45','Helsinki',null,'21240','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10696,89,8,to_date('08-OCT-97','DD-MON-RR'),to_date('19-NOV-97','DD-MON-RR'),to_date('14-OCT-97','DD-MON-RR'),3,102.55,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10697,47,3,to_date('08-OCT-97','DD-MON-RR'),to_date('05-NOV-97','DD-MON-RR'),to_date('14-OCT-97','DD-MON-RR'),1,45.52,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10698,20,4,to_date('09-OCT-97','DD-MON-RR'),to_date('06-NOV-97','DD-MON-RR'),to_date('17-OCT-97','DD-MON-RR'),1,272.47,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10699,52,3,to_date('09-OCT-97','DD-MON-RR'),to_date('06-NOV-97','DD-MON-RR'),to_date('13-OCT-97','DD-MON-RR'),3,0.58,'Morgenstern Gesundkost','Heerstr. 22','Leipzig',null,'04179','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10312,86,2,to_date('23-SEP-96','DD-MON-RR'),to_date('21-OCT-96','DD-MON-RR'),to_date('03-OCT-96','DD-MON-RR'),2,40.26,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',null,'70563','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10720,61,8,to_date('28-OCT-97','DD-MON-RR'),to_date('11-NOV-97','DD-MON-RR'),to_date('05-NOV-97','DD-MON-RR'),2,9.53,'Que Del?cia','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10721,63,5,to_date('29-OCT-97','DD-MON-RR'),to_date('26-NOV-97','DD-MON-RR'),to_date('31-OCT-97','DD-MON-RR'),3,48.92,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10722,71,8,to_date('29-OCT-97','DD-MON-RR'),to_date('10-DEC-97','DD-MON-RR'),to_date('04-NOV-97','DD-MON-RR'),1,74.58,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10723,89,3,to_date('30-OCT-97','DD-MON-RR'),to_date('27-NOV-97','DD-MON-RR'),to_date('25-NOV-97','DD-MON-RR'),1,21.72,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10724,51,8,to_date('30-OCT-97','DD-MON-RR'),to_date('11-DEC-97','DD-MON-RR'),to_date('05-NOV-97','DD-MON-RR'),2,57.75,'M?re Paillarde','43 rue St. Laurent','Montr?al','Qu?bec','H1J 1C3','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10725,21,4,to_date('31-OCT-97','DD-MON-RR'),to_date('28-NOV-97','DD-MON-RR'),to_date('05-NOV-97','DD-MON-RR'),3,10.83,'Familia Arquibaldo','Rua Or?s, 92','S?o Paulo','SP','05442-030','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10726,19,4,to_date('03-NOV-97','DD-MON-RR'),to_date('17-NOV-97','DD-MON-RR'),to_date('05-DEC-97','DD-MON-RR'),1,16.56,'Eastern Connection','35 King George','London',null,'WX3 6FW','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10727,66,2,to_date('03-NOV-97','DD-MON-RR'),to_date('01-DEC-97','DD-MON-RR'),to_date('05-DEC-97','DD-MON-RR'),1,89.9,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',null,'42100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10728,62,4,to_date('04-NOV-97','DD-MON-RR'),to_date('02-DEC-97','DD-MON-RR'),to_date('11-NOV-97','DD-MON-RR'),2,58.33,'Queen Cozinha','Alameda dos Can?rios, 891','S?o Paulo','SP','05487-020','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10729,47,8,to_date('04-NOV-97','DD-MON-RR'),to_date('16-DEC-97','DD-MON-RR'),to_date('14-NOV-97','DD-MON-RR'),3,141.06,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10730,9,5,to_date('05-NOV-97','DD-MON-RR'),to_date('03-DEC-97','DD-MON-RR'),to_date('14-NOV-97','DD-MON-RR'),1,20.12,'Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10731,14,7,to_date('06-NOV-97','DD-MON-RR'),to_date('04-DEC-97','DD-MON-RR'),to_date('14-NOV-97','DD-MON-RR'),1,96.65,'Chop-suey Chinese','Hauptstr. 31','Bern',null,'3012','Switzerland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10732,9,3,to_date('06-NOV-97','DD-MON-RR'),to_date('04-DEC-97','DD-MON-RR'),to_date('07-NOV-97','DD-MON-RR'),1,16.97,'Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10733,5,1,to_date('07-NOV-97','DD-MON-RR'),to_date('05-DEC-97','DD-MON-RR'),to_date('10-NOV-97','DD-MON-RR'),3,110.11,'Berglunds snabbk?p','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10734,31,2,to_date('07-NOV-97','DD-MON-RR'),to_date('05-DEC-97','DD-MON-RR'),to_date('12-NOV-97','DD-MON-RR'),3,1.63,'Gourmet Lanchonetes','Av. Brasil, 442','Campinas','SP','04876-786','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10735,45,6,to_date('10-NOV-97','DD-MON-RR'),to_date('08-DEC-97','DD-MON-RR'),to_date('21-NOV-97','DD-MON-RR'),2,45.97,'Let''s Stop N Shop','87 Polk St.
Suite 5','San Francisco','CA','94117','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10736,37,9,to_date('11-NOV-97','DD-MON-RR'),to_date('09-DEC-97','DD-MON-RR'),to_date('21-NOV-97','DD-MON-RR'),2,44.1,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10737,85,2,to_date('11-NOV-97','DD-MON-RR'),to_date('09-DEC-97','DD-MON-RR'),to_date('18-NOV-97','DD-MON-RR'),2,7.79,'Vins et alcools Chevalier','59 rue de l''Abbaye','Reims',null,'51100','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10738,74,2,to_date('12-NOV-97','DD-MON-RR'),to_date('10-DEC-97','DD-MON-RR'),to_date('18-NOV-97','DD-MON-RR'),1,2.91,'Sp?cialit?s du monde','25, rue Lauriston','Paris',null,'75016','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10739,85,3,to_date('12-NOV-97','DD-MON-RR'),to_date('10-DEC-97','DD-MON-RR'),to_date('17-NOV-97','DD-MON-RR'),3,11.08,'Vins et alcools Chevalier','59 rue de l''Abbaye','Reims',null,'51100','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10740,89,4,to_date('13-NOV-97','DD-MON-RR'),to_date('11-DEC-97','DD-MON-RR'),to_date('25-NOV-97','DD-MON-RR'),2,81.88,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10741,4,4,to_date('14-NOV-97','DD-MON-RR'),to_date('28-NOV-97','DD-MON-RR'),to_date('18-NOV-97','DD-MON-RR'),3,10.96,'Around the Horn','Brook Farm
Stratford St. Mary','Colchester','Essex','CO7 6JX','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10742,10,3,to_date('14-NOV-97','DD-MON-RR'),to_date('12-DEC-97','DD-MON-RR'),to_date('18-NOV-97','DD-MON-RR'),3,243.73,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10743,4,1,to_date('17-NOV-97','DD-MON-RR'),to_date('15-DEC-97','DD-MON-RR'),to_date('21-NOV-97','DD-MON-RR'),2,23.72,'Around the Horn','Brook Farm
Stratford St. Mary','Colchester','Essex','CO7 6JX','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10744,83,6,to_date('17-NOV-97','DD-MON-RR'),to_date('15-DEC-97','DD-MON-RR'),to_date('24-NOV-97','DD-MON-RR'),1,69.19,'Vaffeljernet','Smagsl?get 45','?rhus',null,'8200','Denmark');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10745,63,9,to_date('18-NOV-97','DD-MON-RR'),to_date('16-DEC-97','DD-MON-RR'),to_date('27-NOV-97','DD-MON-RR'),1,3.52,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10746,14,1,to_date('19-NOV-97','DD-MON-RR'),to_date('17-DEC-97','DD-MON-RR'),to_date('21-NOV-97','DD-MON-RR'),3,31.43,'Chop-suey Chinese','Hauptstr. 31','Bern',null,'3012','Switzerland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10747,59,6,to_date('19-NOV-97','DD-MON-RR'),to_date('17-DEC-97','DD-MON-RR'),to_date('26-NOV-97','DD-MON-RR'),1,117.33,'Piccolo und mehr','Geislweg 14','Salzburg',null,'5020','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10748,71,3,to_date('20-NOV-97','DD-MON-RR'),to_date('18-DEC-97','DD-MON-RR'),to_date('28-NOV-97','DD-MON-RR'),1,232.55,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10749,38,4,to_date('20-NOV-97','DD-MON-RR'),to_date('18-DEC-97','DD-MON-RR'),to_date('19-DEC-97','DD-MON-RR'),2,61.53,'Island Trading','Garden House
Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10750,87,9,to_date('21-NOV-97','DD-MON-RR'),to_date('19-DEC-97','DD-MON-RR'),to_date('24-NOV-97','DD-MON-RR'),1,79.3,'Wartian Herkku','Torikatu 38','Oulu',null,'90110','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10751,68,3,to_date('24-NOV-97','DD-MON-RR'),to_date('22-DEC-97','DD-MON-RR'),to_date('03-DEC-97','DD-MON-RR'),3,130.79,'Richter Supermarkt','Starenweg 5','Gen?ve',null,'1204','Switzerland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10752,53,2,to_date('24-NOV-97','DD-MON-RR'),to_date('22-DEC-97','DD-MON-RR'),to_date('28-NOV-97','DD-MON-RR'),3,1.39,'North/South','South House
300 Queensbridge','London',null,'SW7 1RZ','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10753,27,3,to_date('25-NOV-97','DD-MON-RR'),to_date('23-DEC-97','DD-MON-RR'),to_date('27-NOV-97','DD-MON-RR'),1,7.7,'Franchi S.p.A.','Via Monte Bianco 34','Torino',null,'10100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10754,49,6,to_date('25-NOV-97','DD-MON-RR'),to_date('23-DEC-97','DD-MON-RR'),to_date('27-NOV-97','DD-MON-RR'),3,2.38,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',null,'24100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10755,9,4,to_date('26-NOV-97','DD-MON-RR'),to_date('24-DEC-97','DD-MON-RR'),to_date('28-NOV-97','DD-MON-RR'),2,16.71,'Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10756,75,8,to_date('27-NOV-97','DD-MON-RR'),to_date('25-DEC-97','DD-MON-RR'),to_date('02-DEC-97','DD-MON-RR'),2,73.21,'Split Rail Beer & Ale','P.O. Box 555','Lander','WY','82520','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10757,71,6,to_date('27-NOV-97','DD-MON-RR'),to_date('25-DEC-97','DD-MON-RR'),to_date('15-DEC-97','DD-MON-RR'),1,8.19,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10758,68,3,to_date('28-NOV-97','DD-MON-RR'),to_date('26-DEC-97','DD-MON-RR'),to_date('04-DEC-97','DD-MON-RR'),3,138.17,'Richter Supermarkt','Starenweg 5','Gen?ve',null,'1204','Switzerland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10759,2,3,to_date('28-NOV-97','DD-MON-RR'),to_date('26-DEC-97','DD-MON-RR'),to_date('12-DEC-97','DD-MON-RR'),3,11.99,'Ana Trujillo Emparedados y helados','Avda. de la Constituci?n 2222','M?xico D.F.',null,'05021','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10760,50,4,to_date('01-DEC-97','DD-MON-RR'),to_date('29-DEC-97','DD-MON-RR'),to_date('10-DEC-97','DD-MON-RR'),1,155.64,'Maison Dewey','Rue Joseph-Bens 532','Bruxelles',null,'B-1180','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10761,65,5,to_date('02-DEC-97','DD-MON-RR'),to_date('30-DEC-97','DD-MON-RR'),to_date('08-DEC-97','DD-MON-RR'),2,18.66,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10762,24,3,to_date('02-DEC-97','DD-MON-RR'),to_date('30-DEC-97','DD-MON-RR'),to_date('09-DEC-97','DD-MON-RR'),1,328.74,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10763,23,3,to_date('03-DEC-97','DD-MON-RR'),to_date('31-DEC-97','DD-MON-RR'),to_date('08-DEC-97','DD-MON-RR'),3,37.35,'Folies gourmandes','184, chauss?e de Tournai','Lille',null,'59000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10764,20,6,to_date('03-DEC-97','DD-MON-RR'),to_date('31-DEC-97','DD-MON-RR'),to_date('08-DEC-97','DD-MON-RR'),3,145.45,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10765,63,3,to_date('04-DEC-97','DD-MON-RR'),to_date('01-JAN-98','DD-MON-RR'),to_date('09-DEC-97','DD-MON-RR'),3,42.74,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10766,56,4,to_date('05-DEC-97','DD-MON-RR'),to_date('02-JAN-98','DD-MON-RR'),to_date('09-DEC-97','DD-MON-RR'),1,157.55,'Ottilies K?seladen','Mehrheimerstr. 369','K?ln',null,'50739','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10767,76,4,to_date('05-DEC-97','DD-MON-RR'),to_date('02-JAN-98','DD-MON-RR'),to_date('15-DEC-97','DD-MON-RR'),3,1.59,'Supr?mes d?lices','Boulevard Tirou, 255','Charleroi',null,'B-6000','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10768,4,3,to_date('08-DEC-97','DD-MON-RR'),to_date('05-JAN-98','DD-MON-RR'),to_date('15-DEC-97','DD-MON-RR'),2,146.32,'Around the Horn','Brook Farm
Stratford St. Mary','Colchester','Essex','CO7 6JX','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10769,83,3,to_date('08-DEC-97','DD-MON-RR'),to_date('05-JAN-98','DD-MON-RR'),to_date('12-DEC-97','DD-MON-RR'),1,65.06,'Vaffeljernet','Smagsl?get 45','?rhus',null,'8200','Denmark');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10770,34,8,to_date('09-DEC-97','DD-MON-RR'),to_date('06-JAN-98','DD-MON-RR'),to_date('17-DEC-97','DD-MON-RR'),3,5.32,'Hanari Carnes','Rua do Pa?o, 67','Rio de Janeiro','RJ','05454-876','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10771,20,9,to_date('10-DEC-97','DD-MON-RR'),to_date('07-JAN-98','DD-MON-RR'),to_date('02-JAN-98','DD-MON-RR'),2,11.19,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10772,44,3,to_date('10-DEC-97','DD-MON-RR'),to_date('07-JAN-98','DD-MON-RR'),to_date('19-DEC-97','DD-MON-RR'),2,91.28,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M. ',null,'60528','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10773,20,1,to_date('11-DEC-97','DD-MON-RR'),to_date('08-JAN-98','DD-MON-RR'),to_date('16-DEC-97','DD-MON-RR'),3,96.43,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10774,24,4,to_date('11-DEC-97','DD-MON-RR'),to_date('25-DEC-97','DD-MON-RR'),to_date('12-DEC-97','DD-MON-RR'),1,48.2,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10775,78,7,to_date('12-DEC-97','DD-MON-RR'),to_date('09-JAN-98','DD-MON-RR'),to_date('26-DEC-97','DD-MON-RR'),1,20.25,'The Cracker Box','55 Grizzly Peak Rd.','Butte','MT','59801','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10776,20,1,to_date('15-DEC-97','DD-MON-RR'),to_date('12-JAN-98','DD-MON-RR'),to_date('18-DEC-97','DD-MON-RR'),3,351.53,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10777,31,7,to_date('15-DEC-97','DD-MON-RR'),to_date('29-DEC-97','DD-MON-RR'),to_date('21-JAN-98','DD-MON-RR'),2,3.01,'Gourmet Lanchonetes','Av. Brasil, 442','Campinas','SP','04876-786','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10778,5,3,to_date('16-DEC-97','DD-MON-RR'),to_date('13-JAN-98','DD-MON-RR'),to_date('24-DEC-97','DD-MON-RR'),1,6.79,'Berglunds snabbk?p','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10779,52,3,to_date('16-DEC-97','DD-MON-RR'),to_date('13-JAN-98','DD-MON-RR'),to_date('14-JAN-98','DD-MON-RR'),2,58.13,'Morgenstern Gesundkost','Heerstr. 22','Leipzig',null,'04179','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10780,46,2,to_date('16-DEC-97','DD-MON-RR'),to_date('30-DEC-97','DD-MON-RR'),to_date('25-DEC-97','DD-MON-RR'),1,42.13,'LILA-Supermercado','Carrera 52 con Ave. Bol?var #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10781,87,2,to_date('17-DEC-97','DD-MON-RR'),to_date('14-JAN-98','DD-MON-RR'),to_date('19-DEC-97','DD-MON-RR'),3,73.16,'Wartian Herkku','Torikatu 38','Oulu',null,'90110','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10782,12,9,to_date('17-DEC-97','DD-MON-RR'),to_date('14-JAN-98','DD-MON-RR'),to_date('22-DEC-97','DD-MON-RR'),3,1.1,'Cactus Comidas para llevar','Cerrito 333','Buenos Aires',null,'1010','Argentina');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10783,34,4,to_date('18-DEC-97','DD-MON-RR'),to_date('15-JAN-98','DD-MON-RR'),to_date('19-DEC-97','DD-MON-RR'),2,124.98,'Hanari Carnes','Rua do Pa?o, 67','Rio de Janeiro','RJ','05454-876','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10784,49,4,to_date('18-DEC-97','DD-MON-RR'),to_date('15-JAN-98','DD-MON-RR'),to_date('22-DEC-97','DD-MON-RR'),3,70.09,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',null,'24100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10785,33,1,to_date('18-DEC-97','DD-MON-RR'),to_date('15-JAN-98','DD-MON-RR'),to_date('24-DEC-97','DD-MON-RR'),3,1.51,'GROSELLA-Restaurante','5? Ave. Los Palos Grandes','Caracas','DF','1081','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10786,62,8,to_date('19-DEC-97','DD-MON-RR'),to_date('16-JAN-98','DD-MON-RR'),to_date('23-DEC-97','DD-MON-RR'),1,110.87,'Queen Cozinha','Alameda dos Can?rios, 891','S?o Paulo','SP','05487-020','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10787,41,2,to_date('19-DEC-97','DD-MON-RR'),to_date('02-JAN-98','DD-MON-RR'),to_date('26-DEC-97','DD-MON-RR'),1,249.93,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',null,'31000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10976,35,1,to_date('25-MAR-98','DD-MON-RR'),to_date('06-MAY-98','DD-MON-RR'),to_date('03-APR-98','DD-MON-RR'),1,37.97,'HILARI?N-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10977,24,8,to_date('26-MAR-98','DD-MON-RR'),to_date('23-APR-98','DD-MON-RR'),to_date('10-APR-98','DD-MON-RR'),3,208.5,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10978,50,9,to_date('26-MAR-98','DD-MON-RR'),to_date('23-APR-98','DD-MON-RR'),to_date('23-APR-98','DD-MON-RR'),2,32.82,'Maison Dewey','Rue Joseph-Bens 532','Bruxelles',null,'B-1180','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10979,20,8,to_date('26-MAR-98','DD-MON-RR'),to_date('23-APR-98','DD-MON-RR'),to_date('31-MAR-98','DD-MON-RR'),2,353.07,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10980,24,4,to_date('27-MAR-98','DD-MON-RR'),to_date('08-MAY-98','DD-MON-RR'),to_date('17-APR-98','DD-MON-RR'),1,1.26,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10981,34,1,to_date('27-MAR-98','DD-MON-RR'),to_date('24-APR-98','DD-MON-RR'),to_date('02-APR-98','DD-MON-RR'),2,193.37,'Hanari Carnes','Rua do Pa?o, 67','Rio de Janeiro','RJ','05454-876','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10982,10,2,to_date('27-MAR-98','DD-MON-RR'),to_date('24-APR-98','DD-MON-RR'),to_date('08-APR-98','DD-MON-RR'),1,14.01,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10983,71,2,to_date('27-MAR-98','DD-MON-RR'),to_date('24-APR-98','DD-MON-RR'),to_date('06-APR-98','DD-MON-RR'),2,657.54,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10984,71,1,to_date('30-MAR-98','DD-MON-RR'),to_date('27-APR-98','DD-MON-RR'),to_date('03-APR-98','DD-MON-RR'),3,211.22,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10985,37,2,to_date('30-MAR-98','DD-MON-RR'),to_date('27-APR-98','DD-MON-RR'),to_date('02-APR-98','DD-MON-RR'),1,91.51,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10986,54,8,to_date('30-MAR-98','DD-MON-RR'),to_date('27-APR-98','DD-MON-RR'),to_date('21-APR-98','DD-MON-RR'),2,217.86,'Oc?ano Atl?ntico Ltda.','Ing. Gustavo Moncada 8585
Piso 20-A','Buenos Aires',null,'1010','Argentina');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10987,19,8,to_date('31-MAR-98','DD-MON-RR'),to_date('28-APR-98','DD-MON-RR'),to_date('06-APR-98','DD-MON-RR'),1,185.48,'Eastern Connection','35 King George','London',null,'WX3 6FW','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10988,65,3,to_date('31-MAR-98','DD-MON-RR'),to_date('28-APR-98','DD-MON-RR'),to_date('10-APR-98','DD-MON-RR'),2,61.14,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10989,61,2,to_date('31-MAR-98','DD-MON-RR'),to_date('28-APR-98','DD-MON-RR'),to_date('02-APR-98','DD-MON-RR'),1,34.76,'Que Del?cia','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10990,20,2,to_date('01-APR-98','DD-MON-RR'),to_date('13-MAY-98','DD-MON-RR'),to_date('07-APR-98','DD-MON-RR'),3,117.61,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10991,63,1,to_date('01-APR-98','DD-MON-RR'),to_date('29-APR-98','DD-MON-RR'),to_date('07-APR-98','DD-MON-RR'),1,38.51,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10992,77,1,to_date('01-APR-98','DD-MON-RR'),to_date('29-APR-98','DD-MON-RR'),to_date('03-APR-98','DD-MON-RR'),3,4.27,'The Big Cheese','89 Jefferson Way
Suite 2','Portland','OR','97201','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10993,24,7,to_date('01-APR-98','DD-MON-RR'),to_date('29-APR-98','DD-MON-RR'),to_date('10-APR-98','DD-MON-RR'),3,8.81,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10994,83,2,to_date('02-APR-98','DD-MON-RR'),to_date('16-APR-98','DD-MON-RR'),to_date('09-APR-98','DD-MON-RR'),3,65.53,'Vaffeljernet','Smagsl?get 45','?rhus',null,'8200','Denmark');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10995,58,1,to_date('02-APR-98','DD-MON-RR'),to_date('30-APR-98','DD-MON-RR'),to_date('06-APR-98','DD-MON-RR'),3,46,'Pericles Comidas cl?sicas','Calle Dr. Jorge Cash 321','M?xico D.F.',null,'05033','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10996,63,4,to_date('02-APR-98','DD-MON-RR'),to_date('30-APR-98','DD-MON-RR'),to_date('10-APR-98','DD-MON-RR'),2,1.12,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10997,46,8,to_date('03-APR-98','DD-MON-RR'),to_date('15-MAY-98','DD-MON-RR'),to_date('13-APR-98','DD-MON-RR'),2,73.91,'LILA-Supermercado','Carrera 52 con Ave. Bol?var #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10998,91,8,to_date('03-APR-98','DD-MON-RR'),to_date('17-APR-98','DD-MON-RR'),to_date('17-APR-98','DD-MON-RR'),2,20.31,'Wolski Zajazd','ul. Filtrowa 68','Warszawa',null,'01-012','Poland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10999,56,6,to_date('03-APR-98','DD-MON-RR'),to_date('01-MAY-98','DD-MON-RR'),to_date('10-APR-98','DD-MON-RR'),2,96.35,'Ottilies K?seladen','Mehrheimerstr. 369','K?ln',null,'50739','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11000,65,2,to_date('06-APR-98','DD-MON-RR'),to_date('04-MAY-98','DD-MON-RR'),to_date('14-APR-98','DD-MON-RR'),3,55.12,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11001,24,2,to_date('06-APR-98','DD-MON-RR'),to_date('04-MAY-98','DD-MON-RR'),to_date('14-APR-98','DD-MON-RR'),2,197.3,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11002,71,4,to_date('06-APR-98','DD-MON-RR'),to_date('04-MAY-98','DD-MON-RR'),to_date('16-APR-98','DD-MON-RR'),1,141.16,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11003,78,3,to_date('06-APR-98','DD-MON-RR'),to_date('04-MAY-98','DD-MON-RR'),to_date('08-APR-98','DD-MON-RR'),3,14.91,'The Cracker Box','55 Grizzly Peak Rd.','Butte','MT','59801','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11004,50,3,to_date('07-APR-98','DD-MON-RR'),to_date('05-MAY-98','DD-MON-RR'),to_date('20-APR-98','DD-MON-RR'),1,44.84,'Maison Dewey','Rue Joseph-Bens 532','Bruxelles',null,'B-1180','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11005,90,2,to_date('07-APR-98','DD-MON-RR'),to_date('05-MAY-98','DD-MON-RR'),to_date('10-APR-98','DD-MON-RR'),1,0.75,'Wilman Kala','Keskuskatu 45','Helsinki',null,'21240','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11006,32,3,to_date('07-APR-98','DD-MON-RR'),to_date('05-MAY-98','DD-MON-RR'),to_date('15-APR-98','DD-MON-RR'),2,25.19,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11007,60,8,to_date('08-APR-98','DD-MON-RR'),to_date('06-MAY-98','DD-MON-RR'),to_date('13-APR-98','DD-MON-RR'),2,202.24,'Princesa Isabel Vinhos','Estrada da sa?de n. 58','Lisboa',null,'1756','Portugal');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11008,20,7,to_date('08-APR-98','DD-MON-RR'),to_date('06-MAY-98','DD-MON-RR'),null,3,79.46,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11009,30,2,to_date('08-APR-98','DD-MON-RR'),to_date('06-MAY-98','DD-MON-RR'),to_date('10-APR-98','DD-MON-RR'),1,59.11,'Godos Cocina T?pica','C/ Romero, 33','Sevilla',null,'41101','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11010,66,2,to_date('09-APR-98','DD-MON-RR'),to_date('07-MAY-98','DD-MON-RR'),to_date('21-APR-98','DD-MON-RR'),2,28.71,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',null,'42100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11011,1,3,to_date('09-APR-98','DD-MON-RR'),to_date('07-MAY-98','DD-MON-RR'),to_date('13-APR-98','DD-MON-RR'),1,1.21,'Alfreds Futterkiste','Obere Str. 57','Berlin',null,'12209','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11012,25,1,to_date('09-APR-98','DD-MON-RR'),to_date('23-APR-98','DD-MON-RR'),to_date('17-APR-98','DD-MON-RR'),3,242.95,'Frankenversand','Berliner Platz 43','M?nchen',null,'80805','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11013,69,2,to_date('09-APR-98','DD-MON-RR'),to_date('07-MAY-98','DD-MON-RR'),to_date('10-APR-98','DD-MON-RR'),1,32.99,'Romero y tomillo','Gran V?a, 1','Madrid',null,'28001','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11014,47,2,to_date('10-APR-98','DD-MON-RR'),to_date('08-MAY-98','DD-MON-RR'),to_date('15-APR-98','DD-MON-RR'),3,23.6,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11015,70,2,to_date('10-APR-98','DD-MON-RR'),to_date('24-APR-98','DD-MON-RR'),to_date('20-APR-98','DD-MON-RR'),2,4.62,'Sant? Gourmet','Erling Skakkes gate 78','Stavern',null,'4110','Norway');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11016,4,9,to_date('10-APR-98','DD-MON-RR'),to_date('08-MAY-98','DD-MON-RR'),to_date('13-APR-98','DD-MON-RR'),2,33.8,'Around the Horn','Brook Farm
Stratford St. Mary','Colchester','Essex','CO7 6JX','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11017,20,9,to_date('13-APR-98','DD-MON-RR'),to_date('11-MAY-98','DD-MON-RR'),to_date('20-APR-98','DD-MON-RR'),2,754.26,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10788,63,1,to_date('22-DEC-97','DD-MON-RR'),to_date('19-JAN-98','DD-MON-RR'),to_date('19-JAN-98','DD-MON-RR'),2,42.7,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10789,23,1,to_date('22-DEC-97','DD-MON-RR'),to_date('19-JAN-98','DD-MON-RR'),to_date('31-DEC-97','DD-MON-RR'),2,100.6,'Folies gourmandes','184, chauss?e de Tournai','Lille',null,'59000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10790,31,6,to_date('22-DEC-97','DD-MON-RR'),to_date('19-JAN-98','DD-MON-RR'),to_date('26-DEC-97','DD-MON-RR'),1,28.23,'Gourmet Lanchonetes','Av. Brasil, 442','Campinas','SP','04876-786','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10791,25,6,to_date('23-DEC-97','DD-MON-RR'),to_date('20-JAN-98','DD-MON-RR'),to_date('01-JAN-98','DD-MON-RR'),2,16.85,'Frankenversand','Berliner Platz 43','M?nchen',null,'80805','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10792,91,1,to_date('23-DEC-97','DD-MON-RR'),to_date('20-JAN-98','DD-MON-RR'),to_date('31-DEC-97','DD-MON-RR'),3,23.79,'Wolski Zajazd','ul. Filtrowa 68','Warszawa',null,'01-012','Poland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10793,4,3,to_date('24-DEC-97','DD-MON-RR'),to_date('21-JAN-98','DD-MON-RR'),to_date('08-JAN-98','DD-MON-RR'),3,4.52,'Around the Horn','Brook Farm
Stratford St. Mary','Colchester','Essex','CO7 6JX','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10794,61,6,to_date('24-DEC-97','DD-MON-RR'),to_date('21-JAN-98','DD-MON-RR'),to_date('02-JAN-98','DD-MON-RR'),1,21.49,'Que Del?cia','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10795,20,8,to_date('24-DEC-97','DD-MON-RR'),to_date('21-JAN-98','DD-MON-RR'),to_date('20-JAN-98','DD-MON-RR'),2,126.66,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10796,35,3,to_date('25-DEC-97','DD-MON-RR'),to_date('22-JAN-98','DD-MON-RR'),to_date('14-JAN-98','DD-MON-RR'),1,26.52,'HILARI?N-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10797,17,7,to_date('25-DEC-97','DD-MON-RR'),to_date('22-JAN-98','DD-MON-RR'),to_date('05-JAN-98','DD-MON-RR'),2,33.35,'Drachenblut Delikatessen','Walserweg 21','Aachen',null,'52066','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10798,38,2,to_date('26-DEC-97','DD-MON-RR'),to_date('23-JAN-98','DD-MON-RR'),to_date('05-JAN-98','DD-MON-RR'),1,2.33,'Island Trading','Garden House
Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10799,39,9,to_date('26-DEC-97','DD-MON-RR'),to_date('06-FEB-98','DD-MON-RR'),to_date('05-JAN-98','DD-MON-RR'),3,30.76,'K?niglich Essen','Maubelstr. 90','Brandenburg',null,'14776','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10800,72,1,to_date('26-DEC-97','DD-MON-RR'),to_date('23-JAN-98','DD-MON-RR'),to_date('05-JAN-98','DD-MON-RR'),3,137.44,'Seven Seas Imports','90 Wadhurst Rd.','London',null,'OX15 4NB','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10801,8,4,to_date('29-DEC-97','DD-MON-RR'),to_date('26-JAN-98','DD-MON-RR'),to_date('31-DEC-97','DD-MON-RR'),2,97.09,'B?lido Comidas preparadas','C/ Araquil, 67','Madrid',null,'28023','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10802,73,4,to_date('29-DEC-97','DD-MON-RR'),to_date('26-JAN-98','DD-MON-RR'),to_date('02-JAN-98','DD-MON-RR'),2,257.26,'Simons bistro','Vinb?ltet 34','K?benhavn',null,'1734','Denmark');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10803,88,4,to_date('30-DEC-97','DD-MON-RR'),to_date('27-JAN-98','DD-MON-RR'),to_date('06-JAN-98','DD-MON-RR'),1,55.23,'Wellington Importadora','Rua do Mercado, 12','Resende','SP','08737-363','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10804,72,6,to_date('30-DEC-97','DD-MON-RR'),to_date('27-JAN-98','DD-MON-RR'),to_date('07-JAN-98','DD-MON-RR'),2,27.33,'Seven Seas Imports','90 Wadhurst Rd.','London',null,'OX15 4NB','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10805,77,2,to_date('30-DEC-97','DD-MON-RR'),to_date('27-JAN-98','DD-MON-RR'),to_date('09-JAN-98','DD-MON-RR'),3,237.34,'The Big Cheese','89 Jefferson Way
Suite 2','Portland','OR','97201','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10806,84,3,to_date('31-DEC-97','DD-MON-RR'),to_date('28-JAN-98','DD-MON-RR'),to_date('05-JAN-98','DD-MON-RR'),2,22.11,'Victuailles en stock','2, rue du Commerce','Lyon',null,'69004','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10807,27,4,to_date('31-DEC-97','DD-MON-RR'),to_date('28-JAN-98','DD-MON-RR'),to_date('30-JAN-98','DD-MON-RR'),1,1.36,'Franchi S.p.A.','Via Monte Bianco 34','Torino',null,'10100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10808,55,2,to_date('01-JAN-98','DD-MON-RR'),to_date('29-JAN-98','DD-MON-RR'),to_date('09-JAN-98','DD-MON-RR'),3,45.53,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10809,88,7,to_date('01-JAN-98','DD-MON-RR'),to_date('29-JAN-98','DD-MON-RR'),to_date('07-JAN-98','DD-MON-RR'),1,4.87,'Wellington Importadora','Rua do Mercado, 12','Resende','SP','08737-363','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10810,42,2,to_date('01-JAN-98','DD-MON-RR'),to_date('29-JAN-98','DD-MON-RR'),to_date('07-JAN-98','DD-MON-RR'),3,4.33,'Laughing Bacchus Wine Cellars','2319 Elm St.','Vancouver','BC','V3F 2K1','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10811,47,8,to_date('02-JAN-98','DD-MON-RR'),to_date('30-JAN-98','DD-MON-RR'),to_date('08-JAN-98','DD-MON-RR'),1,31.22,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10812,66,5,to_date('02-JAN-98','DD-MON-RR'),to_date('30-JAN-98','DD-MON-RR'),to_date('12-JAN-98','DD-MON-RR'),1,59.78,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',null,'42100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10813,67,1,to_date('05-JAN-98','DD-MON-RR'),to_date('02-FEB-98','DD-MON-RR'),to_date('09-JAN-98','DD-MON-RR'),1,47.38,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10814,84,3,to_date('05-JAN-98','DD-MON-RR'),to_date('02-FEB-98','DD-MON-RR'),to_date('14-JAN-98','DD-MON-RR'),3,130.94,'Victuailles en stock','2, rue du Commerce','Lyon',null,'69004','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10815,71,2,to_date('05-JAN-98','DD-MON-RR'),to_date('02-FEB-98','DD-MON-RR'),to_date('14-JAN-98','DD-MON-RR'),3,14.62,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10816,32,4,to_date('06-JAN-98','DD-MON-RR'),to_date('03-FEB-98','DD-MON-RR'),to_date('04-FEB-98','DD-MON-RR'),2,719.78,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10817,39,3,to_date('06-JAN-98','DD-MON-RR'),to_date('20-JAN-98','DD-MON-RR'),to_date('13-JAN-98','DD-MON-RR'),2,306.07,'K?niglich Essen','Maubelstr. 90','Brandenburg',null,'14776','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10818,49,7,to_date('07-JAN-98','DD-MON-RR'),to_date('04-FEB-98','DD-MON-RR'),to_date('12-JAN-98','DD-MON-RR'),3,65.48,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',null,'24100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10819,12,2,to_date('07-JAN-98','DD-MON-RR'),to_date('04-FEB-98','DD-MON-RR'),to_date('16-JAN-98','DD-MON-RR'),3,19.76,'Cactus Comidas para llevar','Cerrito 333','Buenos Aires',null,'1010','Argentina');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10820,65,3,to_date('07-JAN-98','DD-MON-RR'),to_date('04-FEB-98','DD-MON-RR'),to_date('13-JAN-98','DD-MON-RR'),2,37.52,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10821,75,1,to_date('08-JAN-98','DD-MON-RR'),to_date('05-FEB-98','DD-MON-RR'),to_date('15-JAN-98','DD-MON-RR'),1,36.68,'Split Rail Beer & Ale','P.O. Box 555','Lander','WY','82520','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10822,82,6,to_date('08-JAN-98','DD-MON-RR'),to_date('05-FEB-98','DD-MON-RR'),to_date('16-JAN-98','DD-MON-RR'),3,7,'Trail''s Head Gourmet Provisioners','722 DaVinci Blvd.','Kirkland','WA','98034','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10823,46,5,to_date('09-JAN-98','DD-MON-RR'),to_date('06-FEB-98','DD-MON-RR'),to_date('13-JAN-98','DD-MON-RR'),2,163.97,'LILA-Supermercado','Carrera 52 con Ave. Bol?var #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10824,24,8,to_date('09-JAN-98','DD-MON-RR'),to_date('06-FEB-98','DD-MON-RR'),to_date('30-JAN-98','DD-MON-RR'),1,1.23,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10825,17,1,to_date('09-JAN-98','DD-MON-RR'),to_date('06-FEB-98','DD-MON-RR'),to_date('14-JAN-98','DD-MON-RR'),1,79.25,'Drachenblut Delikatessen','Walserweg 21','Aachen',null,'52066','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10826,7,6,to_date('12-JAN-98','DD-MON-RR'),to_date('09-FEB-98','DD-MON-RR'),to_date('06-FEB-98','DD-MON-RR'),1,7.09,'Blondel p?re et fils','24, place Kl?ber','Strasbourg',null,'67000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10827,9,1,to_date('12-JAN-98','DD-MON-RR'),to_date('26-JAN-98','DD-MON-RR'),to_date('06-FEB-98','DD-MON-RR'),2,63.54,'Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10828,64,9,to_date('13-JAN-98','DD-MON-RR'),to_date('27-JAN-98','DD-MON-RR'),to_date('04-FEB-98','DD-MON-RR'),1,90.85,'Rancho grande','Av. del Libertador 900','Buenos Aires',null,'1010','Argentina');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10829,38,9,to_date('13-JAN-98','DD-MON-RR'),to_date('10-FEB-98','DD-MON-RR'),to_date('23-JAN-98','DD-MON-RR'),1,154.72,'Island Trading','Garden House
Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10830,81,4,to_date('13-JAN-98','DD-MON-RR'),to_date('24-FEB-98','DD-MON-RR'),to_date('21-JAN-98','DD-MON-RR'),2,81.83,'Tradi??o Hipermercados','Av. In?s de Castro, 414','S?o Paulo','SP','05634-030','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10831,70,3,to_date('14-JAN-98','DD-MON-RR'),to_date('11-FEB-98','DD-MON-RR'),to_date('23-JAN-98','DD-MON-RR'),2,72.19,'Sant? Gourmet','Erling Skakkes gate 78','Stavern',null,'4110','Norway');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10832,41,2,to_date('14-JAN-98','DD-MON-RR'),to_date('11-FEB-98','DD-MON-RR'),to_date('19-JAN-98','DD-MON-RR'),2,43.26,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',null,'31000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10833,56,6,to_date('15-JAN-98','DD-MON-RR'),to_date('12-FEB-98','DD-MON-RR'),to_date('23-JAN-98','DD-MON-RR'),2,71.49,'Ottilies K?seladen','Mehrheimerstr. 369','K?ln',null,'50739','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10834,81,1,to_date('15-JAN-98','DD-MON-RR'),to_date('12-FEB-98','DD-MON-RR'),to_date('19-JAN-98','DD-MON-RR'),3,29.78,'Tradi??o Hipermercados','Av. In?s de Castro, 414','S?o Paulo','SP','05634-030','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10835,1,1,to_date('15-JAN-98','DD-MON-RR'),to_date('12-FEB-98','DD-MON-RR'),to_date('21-JAN-98','DD-MON-RR'),3,69.53,'Alfreds Futterkiste','Obere Str. 57','Berlin',null,'12209','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10836,20,7,to_date('16-JAN-98','DD-MON-RR'),to_date('13-FEB-98','DD-MON-RR'),to_date('21-JAN-98','DD-MON-RR'),1,411.88,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10837,5,9,to_date('16-JAN-98','DD-MON-RR'),to_date('13-FEB-98','DD-MON-RR'),to_date('23-JAN-98','DD-MON-RR'),3,13.32,'Berglunds snabbk?p','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10838,47,3,to_date('19-JAN-98','DD-MON-RR'),to_date('16-FEB-98','DD-MON-RR'),to_date('23-JAN-98','DD-MON-RR'),3,59.28,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10839,81,3,to_date('19-JAN-98','DD-MON-RR'),to_date('16-FEB-98','DD-MON-RR'),to_date('22-JAN-98','DD-MON-RR'),3,35.43,'Tradi??o Hipermercados','Av. In?s de Castro, 414','S?o Paulo','SP','05634-030','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10840,47,4,to_date('19-JAN-98','DD-MON-RR'),to_date('02-MAR-98','DD-MON-RR'),to_date('16-FEB-98','DD-MON-RR'),2,2.71,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10841,76,5,to_date('20-JAN-98','DD-MON-RR'),to_date('17-FEB-98','DD-MON-RR'),to_date('29-JAN-98','DD-MON-RR'),2,424.3,'Supr?mes d?lices','Boulevard Tirou, 255','Charleroi',null,'B-6000','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10842,80,1,to_date('20-JAN-98','DD-MON-RR'),to_date('17-FEB-98','DD-MON-RR'),to_date('29-JAN-98','DD-MON-RR'),3,54.42,'Tortuga Restaurante','Avda. Azteca 123','M?xico D.F.',null,'05033','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10843,84,4,to_date('21-JAN-98','DD-MON-RR'),to_date('18-FEB-98','DD-MON-RR'),to_date('26-JAN-98','DD-MON-RR'),2,9.26,'Victuailles en stock','2, rue du Commerce','Lyon',null,'69004','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10844,59,8,to_date('21-JAN-98','DD-MON-RR'),to_date('18-FEB-98','DD-MON-RR'),to_date('26-JAN-98','DD-MON-RR'),2,25.22,'Piccolo und mehr','Geislweg 14','Salzburg',null,'5020','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10845,63,8,to_date('21-JAN-98','DD-MON-RR'),to_date('04-FEB-98','DD-MON-RR'),to_date('30-JAN-98','DD-MON-RR'),1,212.98,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10846,76,2,to_date('22-JAN-98','DD-MON-RR'),to_date('05-MAR-98','DD-MON-RR'),to_date('23-JAN-98','DD-MON-RR'),3,56.46,'Supr?mes d?lices','Boulevard Tirou, 255','Charleroi',null,'B-6000','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10847,71,4,to_date('22-JAN-98','DD-MON-RR'),to_date('05-FEB-98','DD-MON-RR'),to_date('10-FEB-98','DD-MON-RR'),3,487.57,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10848,16,7,to_date('23-JAN-98','DD-MON-RR'),to_date('20-FEB-98','DD-MON-RR'),to_date('29-JAN-98','DD-MON-RR'),2,38.24,'Consolidated Holdings','Berkeley Gardens
12  Brewery ','London',null,'WX1 6LT','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10849,39,9,to_date('23-JAN-98','DD-MON-RR'),to_date('20-FEB-98','DD-MON-RR'),to_date('30-JAN-98','DD-MON-RR'),2,0.56,'K?niglich Essen','Maubelstr. 90','Brandenburg',null,'14776','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10850,84,1,to_date('23-JAN-98','DD-MON-RR'),to_date('06-MAR-98','DD-MON-RR'),to_date('30-JAN-98','DD-MON-RR'),1,49.19,'Victuailles en stock','2, rue du Commerce','Lyon',null,'69004','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10851,67,5,to_date('26-JAN-98','DD-MON-RR'),to_date('23-FEB-98','DD-MON-RR'),to_date('02-FEB-98','DD-MON-RR'),1,160.55,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10852,65,8,to_date('26-JAN-98','DD-MON-RR'),to_date('09-FEB-98','DD-MON-RR'),to_date('30-JAN-98','DD-MON-RR'),1,174.05,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10853,6,9,to_date('27-JAN-98','DD-MON-RR'),to_date('24-FEB-98','DD-MON-RR'),to_date('03-FEB-98','DD-MON-RR'),2,53.83,'Blauer See Delikatessen','Forsterstr. 57','Mannheim',null,'68306','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10854,20,3,to_date('27-JAN-98','DD-MON-RR'),to_date('24-FEB-98','DD-MON-RR'),to_date('05-FEB-98','DD-MON-RR'),2,100.22,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10855,55,3,to_date('27-JAN-98','DD-MON-RR'),to_date('24-FEB-98','DD-MON-RR'),to_date('04-FEB-98','DD-MON-RR'),1,170.97,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10856,3,3,to_date('28-JAN-98','DD-MON-RR'),to_date('25-FEB-98','DD-MON-RR'),to_date('10-FEB-98','DD-MON-RR'),2,58.43,'Antonio Moreno Taquer?a','Mataderos  2312','M?xico D.F.',null,'05023','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10857,5,8,to_date('28-JAN-98','DD-MON-RR'),to_date('25-FEB-98','DD-MON-RR'),to_date('06-FEB-98','DD-MON-RR'),2,188.85,'Berglunds snabbk?p','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10858,40,2,to_date('29-JAN-98','DD-MON-RR'),to_date('26-FEB-98','DD-MON-RR'),to_date('03-FEB-98','DD-MON-RR'),1,52.51,'La corne d''abondance','67, avenue de l''Europe','Versailles',null,'78000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10859,25,1,to_date('29-JAN-98','DD-MON-RR'),to_date('26-FEB-98','DD-MON-RR'),to_date('02-FEB-98','DD-MON-RR'),2,76.1,'Frankenversand','Berliner Platz 43','M?nchen',null,'80805','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10860,26,3,to_date('29-JAN-98','DD-MON-RR'),to_date('26-FEB-98','DD-MON-RR'),to_date('04-FEB-98','DD-MON-RR'),3,19.26,'France restauration','54, rue Royale','Nantes',null,'44000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10861,89,4,to_date('30-JAN-98','DD-MON-RR'),to_date('27-FEB-98','DD-MON-RR'),to_date('17-FEB-98','DD-MON-RR'),2,14.93,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10862,44,8,to_date('30-JAN-98','DD-MON-RR'),to_date('13-MAR-98','DD-MON-RR'),to_date('02-FEB-98','DD-MON-RR'),2,53.23,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M. ',null,'60528','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10863,35,4,to_date('02-FEB-98','DD-MON-RR'),to_date('02-MAR-98','DD-MON-RR'),to_date('17-FEB-98','DD-MON-RR'),2,30.26,'HILARI?N-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10864,4,4,to_date('02-FEB-98','DD-MON-RR'),to_date('02-MAR-98','DD-MON-RR'),to_date('09-FEB-98','DD-MON-RR'),2,3.04,'Around the Horn','Brook Farm
Stratford St. Mary','Colchester','Essex','CO7 6JX','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10865,63,2,to_date('02-FEB-98','DD-MON-RR'),to_date('16-FEB-98','DD-MON-RR'),to_date('12-FEB-98','DD-MON-RR'),1,348.14,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10866,5,5,to_date('03-FEB-98','DD-MON-RR'),to_date('03-MAR-98','DD-MON-RR'),to_date('12-FEB-98','DD-MON-RR'),1,109.11,'Berglunds snabbk?p','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10867,48,6,to_date('03-FEB-98','DD-MON-RR'),to_date('17-MAR-98','DD-MON-RR'),to_date('11-FEB-98','DD-MON-RR'),1,1.93,'Lonesome Pine Restaurant','89 Chiaroscuro Rd.','Portland','OR','97219','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10868,62,7,to_date('04-FEB-98','DD-MON-RR'),to_date('04-MAR-98','DD-MON-RR'),to_date('23-FEB-98','DD-MON-RR'),2,191.27,'Queen Cozinha','Alameda dos Can?rios, 891','S?o Paulo','SP','05487-020','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10869,72,5,to_date('04-FEB-98','DD-MON-RR'),to_date('04-MAR-98','DD-MON-RR'),to_date('09-FEB-98','DD-MON-RR'),1,143.28,'Seven Seas Imports','90 Wadhurst Rd.','London',null,'OX15 4NB','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10870,91,5,to_date('04-FEB-98','DD-MON-RR'),to_date('04-MAR-98','DD-MON-RR'),to_date('13-FEB-98','DD-MON-RR'),3,12.04,'Wolski Zajazd','ul. Filtrowa 68','Warszawa',null,'01-012','Poland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10871,9,9,to_date('05-FEB-98','DD-MON-RR'),to_date('05-MAR-98','DD-MON-RR'),to_date('10-FEB-98','DD-MON-RR'),2,112.27,'Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10872,30,5,to_date('05-FEB-98','DD-MON-RR'),to_date('05-MAR-98','DD-MON-RR'),to_date('09-FEB-98','DD-MON-RR'),2,175.32,'Godos Cocina T?pica','C/ Romero, 33','Sevilla',null,'41101','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10873,90,4,to_date('06-FEB-98','DD-MON-RR'),to_date('06-MAR-98','DD-MON-RR'),to_date('09-FEB-98','DD-MON-RR'),1,0.82,'Wilman Kala','Keskuskatu 45','Helsinki',null,'21240','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10874,30,5,to_date('06-FEB-98','DD-MON-RR'),to_date('06-MAR-98','DD-MON-RR'),to_date('11-FEB-98','DD-MON-RR'),2,19.58,'Godos Cocina T?pica','C/ Romero, 33','Sevilla',null,'41101','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10875,5,4,to_date('06-FEB-98','DD-MON-RR'),to_date('06-MAR-98','DD-MON-RR'),to_date('03-MAR-98','DD-MON-RR'),2,32.37,'Berglunds snabbk?p','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10876,9,7,to_date('09-FEB-98','DD-MON-RR'),to_date('09-MAR-98','DD-MON-RR'),to_date('12-FEB-98','DD-MON-RR'),3,60.42,'Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10877,67,1,to_date('09-FEB-98','DD-MON-RR'),to_date('09-MAR-98','DD-MON-RR'),to_date('19-FEB-98','DD-MON-RR'),1,38.06,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10878,63,4,to_date('10-FEB-98','DD-MON-RR'),to_date('10-MAR-98','DD-MON-RR'),to_date('12-FEB-98','DD-MON-RR'),1,46.69,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10879,90,3,to_date('10-FEB-98','DD-MON-RR'),to_date('10-MAR-98','DD-MON-RR'),to_date('12-FEB-98','DD-MON-RR'),3,8.5,'Wilman Kala','Keskuskatu 45','Helsinki',null,'21240','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10880,24,7,to_date('10-FEB-98','DD-MON-RR'),to_date('24-MAR-98','DD-MON-RR'),to_date('18-FEB-98','DD-MON-RR'),1,88.01,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10881,12,4,to_date('11-FEB-98','DD-MON-RR'),to_date('11-MAR-98','DD-MON-RR'),to_date('18-FEB-98','DD-MON-RR'),1,2.84,'Cactus Comidas para llevar','Cerrito 333','Buenos Aires',null,'1010','Argentina');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10882,71,4,to_date('11-FEB-98','DD-MON-RR'),to_date('11-MAR-98','DD-MON-RR'),to_date('20-FEB-98','DD-MON-RR'),3,23.1,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10883,48,8,to_date('12-FEB-98','DD-MON-RR'),to_date('12-MAR-98','DD-MON-RR'),to_date('20-FEB-98','DD-MON-RR'),3,0.53,'Lonesome Pine Restaurant','89 Chiaroscuro Rd.','Portland','OR','97219','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10884,45,4,to_date('12-FEB-98','DD-MON-RR'),to_date('12-MAR-98','DD-MON-RR'),to_date('13-FEB-98','DD-MON-RR'),2,90.97,'Let''s Stop N Shop','87 Polk St.
Suite 5','San Francisco','CA','94117','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10885,76,6,to_date('12-FEB-98','DD-MON-RR'),to_date('12-MAR-98','DD-MON-RR'),to_date('18-FEB-98','DD-MON-RR'),3,5.64,'Supr?mes d?lices','Boulevard Tirou, 255','Charleroi',null,'B-6000','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10886,34,1,to_date('13-FEB-98','DD-MON-RR'),to_date('13-MAR-98','DD-MON-RR'),to_date('02-MAR-98','DD-MON-RR'),1,4.99,'Hanari Carnes','Rua do Pa?o, 67','Rio de Janeiro','RJ','05454-876','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10887,29,8,to_date('13-FEB-98','DD-MON-RR'),to_date('13-MAR-98','DD-MON-RR'),to_date('16-FEB-98','DD-MON-RR'),3,1.25,'Galer?a del gastron?mo','Rambla de Catalu?a, 23','Barcelona',null,'8022','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10888,30,1,to_date('16-FEB-98','DD-MON-RR'),to_date('16-MAR-98','DD-MON-RR'),to_date('23-FEB-98','DD-MON-RR'),2,51.87,'Godos Cocina T?pica','C/ Romero, 33','Sevilla',null,'41101','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10889,65,9,to_date('16-FEB-98','DD-MON-RR'),to_date('16-MAR-98','DD-MON-RR'),to_date('23-FEB-98','DD-MON-RR'),3,280.61,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10890,18,7,to_date('16-FEB-98','DD-MON-RR'),to_date('16-MAR-98','DD-MON-RR'),to_date('18-FEB-98','DD-MON-RR'),1,32.76,'Du monde entier','67, rue des Cinquante Otages','Nantes',null,'44000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10891,44,7,to_date('17-FEB-98','DD-MON-RR'),to_date('17-MAR-98','DD-MON-RR'),to_date('19-FEB-98','DD-MON-RR'),2,20.37,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M. ',null,'60528','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10892,50,4,to_date('17-FEB-98','DD-MON-RR'),to_date('17-MAR-98','DD-MON-RR'),to_date('19-FEB-98','DD-MON-RR'),2,120.27,'Maison Dewey','Rue Joseph-Bens 532','Bruxelles',null,'B-1180','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10893,39,9,to_date('18-FEB-98','DD-MON-RR'),to_date('18-MAR-98','DD-MON-RR'),to_date('20-FEB-98','DD-MON-RR'),2,77.78,'K?niglich Essen','Maubelstr. 90','Brandenburg',null,'14776','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10894,71,1,to_date('18-FEB-98','DD-MON-RR'),to_date('18-MAR-98','DD-MON-RR'),to_date('20-FEB-98','DD-MON-RR'),1,116.13,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10895,20,3,to_date('18-FEB-98','DD-MON-RR'),to_date('18-MAR-98','DD-MON-RR'),to_date('23-FEB-98','DD-MON-RR'),1,162.75,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10896,50,7,to_date('19-FEB-98','DD-MON-RR'),to_date('19-MAR-98','DD-MON-RR'),to_date('27-FEB-98','DD-MON-RR'),3,32.45,'Maison Dewey','Rue Joseph-Bens 532','Bruxelles',null,'B-1180','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10897,37,3,to_date('19-FEB-98','DD-MON-RR'),to_date('19-MAR-98','DD-MON-RR'),to_date('25-FEB-98','DD-MON-RR'),2,603.54,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10898,54,4,to_date('20-FEB-98','DD-MON-RR'),to_date('20-MAR-98','DD-MON-RR'),to_date('06-MAR-98','DD-MON-RR'),2,1.27,'Oc?ano Atl?ntico Ltda.','Ing. Gustavo Moncada 8585
Piso 20-A','Buenos Aires',null,'1010','Argentina');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10899,46,5,to_date('20-FEB-98','DD-MON-RR'),to_date('20-MAR-98','DD-MON-RR'),to_date('26-FEB-98','DD-MON-RR'),3,1.21,'LILA-Supermercado','Carrera 52 con Ave. Bol?var #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10900,88,1,to_date('20-FEB-98','DD-MON-RR'),to_date('20-MAR-98','DD-MON-RR'),to_date('04-MAR-98','DD-MON-RR'),2,1.66,'Wellington Importadora','Rua do Mercado, 12','Resende','SP','08737-363','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10901,35,4,to_date('23-FEB-98','DD-MON-RR'),to_date('23-MAR-98','DD-MON-RR'),to_date('26-FEB-98','DD-MON-RR'),1,62.09,'HILARI?N-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10902,24,1,to_date('23-FEB-98','DD-MON-RR'),to_date('23-MAR-98','DD-MON-RR'),to_date('03-MAR-98','DD-MON-RR'),1,44.15,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10903,34,3,to_date('24-FEB-98','DD-MON-RR'),to_date('24-MAR-98','DD-MON-RR'),to_date('04-MAR-98','DD-MON-RR'),3,36.71,'Hanari Carnes','Rua do Pa?o, 67','Rio de Janeiro','RJ','05454-876','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10904,89,3,to_date('24-FEB-98','DD-MON-RR'),to_date('24-MAR-98','DD-MON-RR'),to_date('27-FEB-98','DD-MON-RR'),3,162.95,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10905,88,9,to_date('24-FEB-98','DD-MON-RR'),to_date('24-MAR-98','DD-MON-RR'),to_date('06-MAR-98','DD-MON-RR'),2,13.72,'Wellington Importadora','Rua do Mercado, 12','Resende','SP','08737-363','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10906,91,4,to_date('25-FEB-98','DD-MON-RR'),to_date('11-MAR-98','DD-MON-RR'),to_date('03-MAR-98','DD-MON-RR'),3,26.29,'Wolski Zajazd','ul. Filtrowa 68','Warszawa',null,'01-012','Poland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10907,74,6,to_date('25-FEB-98','DD-MON-RR'),to_date('25-MAR-98','DD-MON-RR'),to_date('27-FEB-98','DD-MON-RR'),3,9.19,'Sp?cialit?s du monde','25, rue Lauriston','Paris',null,'75016','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10908,66,4,to_date('26-FEB-98','DD-MON-RR'),to_date('26-MAR-98','DD-MON-RR'),to_date('06-MAR-98','DD-MON-RR'),2,32.96,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',null,'42100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10909,70,1,to_date('26-FEB-98','DD-MON-RR'),to_date('26-MAR-98','DD-MON-RR'),to_date('10-MAR-98','DD-MON-RR'),2,53.05,'Sant? Gourmet','Erling Skakkes gate 78','Stavern',null,'4110','Norway');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10910,90,1,to_date('26-FEB-98','DD-MON-RR'),to_date('26-MAR-98','DD-MON-RR'),to_date('04-MAR-98','DD-MON-RR'),3,38.11,'Wilman Kala','Keskuskatu 45','Helsinki',null,'21240','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10911,30,3,to_date('26-FEB-98','DD-MON-RR'),to_date('26-MAR-98','DD-MON-RR'),to_date('05-MAR-98','DD-MON-RR'),1,38.19,'Godos Cocina T?pica','C/ Romero, 33','Sevilla',null,'41101','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10912,37,2,to_date('26-FEB-98','DD-MON-RR'),to_date('26-MAR-98','DD-MON-RR'),to_date('18-MAR-98','DD-MON-RR'),2,580.91,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10913,62,4,to_date('26-FEB-98','DD-MON-RR'),to_date('26-MAR-98','DD-MON-RR'),to_date('04-MAR-98','DD-MON-RR'),1,33.05,'Queen Cozinha','Alameda dos Can?rios, 891','S?o Paulo','SP','05487-020','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10914,62,6,to_date('27-FEB-98','DD-MON-RR'),to_date('27-MAR-98','DD-MON-RR'),to_date('02-MAR-98','DD-MON-RR'),1,21.19,'Queen Cozinha','Alameda dos Can?rios, 891','S?o Paulo','SP','05487-020','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10915,80,2,to_date('27-FEB-98','DD-MON-RR'),to_date('27-MAR-98','DD-MON-RR'),to_date('02-MAR-98','DD-MON-RR'),2,3.51,'Tortuga Restaurante','Avda. Azteca 123','M?xico D.F.',null,'05033','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10916,64,1,to_date('27-FEB-98','DD-MON-RR'),to_date('27-MAR-98','DD-MON-RR'),to_date('09-MAR-98','DD-MON-RR'),2,63.77,'Rancho grande','Av. del Libertador 900','Buenos Aires',null,'1010','Argentina');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10917,69,4,to_date('02-MAR-98','DD-MON-RR'),to_date('30-MAR-98','DD-MON-RR'),to_date('11-MAR-98','DD-MON-RR'),2,8.29,'Romero y tomillo','Gran V?a, 1','Madrid',null,'28001','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10918,10,3,to_date('02-MAR-98','DD-MON-RR'),to_date('30-MAR-98','DD-MON-RR'),to_date('11-MAR-98','DD-MON-RR'),3,48.83,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10919,47,2,to_date('02-MAR-98','DD-MON-RR'),to_date('30-MAR-98','DD-MON-RR'),to_date('04-MAR-98','DD-MON-RR'),2,19.8,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10920,4,4,to_date('03-MAR-98','DD-MON-RR'),to_date('31-MAR-98','DD-MON-RR'),to_date('09-MAR-98','DD-MON-RR'),2,29.61,'Around the Horn','Brook Farm
Stratford St. Mary','Colchester','Essex','CO7 6JX','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10921,83,1,to_date('03-MAR-98','DD-MON-RR'),to_date('14-APR-98','DD-MON-RR'),to_date('09-MAR-98','DD-MON-RR'),1,176.48,'Vaffeljernet','Smagsl?get 45','?rhus',null,'8200','Denmark');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10922,34,5,to_date('03-MAR-98','DD-MON-RR'),to_date('31-MAR-98','DD-MON-RR'),to_date('05-MAR-98','DD-MON-RR'),3,62.74,'Hanari Carnes','Rua do Pa?o, 67','Rio de Janeiro','RJ','05454-876','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10923,41,7,to_date('03-MAR-98','DD-MON-RR'),to_date('14-APR-98','DD-MON-RR'),to_date('13-MAR-98','DD-MON-RR'),3,68.26,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',null,'31000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10924,5,3,to_date('04-MAR-98','DD-MON-RR'),to_date('01-APR-98','DD-MON-RR'),to_date('08-APR-98','DD-MON-RR'),2,151.52,'Berglunds snabbk?p','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10925,34,3,to_date('04-MAR-98','DD-MON-RR'),to_date('01-APR-98','DD-MON-RR'),to_date('13-MAR-98','DD-MON-RR'),1,2.27,'Hanari Carnes','Rua do Pa?o, 67','Rio de Janeiro','RJ','05454-876','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10926,2,4,to_date('04-MAR-98','DD-MON-RR'),to_date('01-APR-98','DD-MON-RR'),to_date('11-MAR-98','DD-MON-RR'),3,39.92,'Ana Trujillo Emparedados y helados','Avda. de la Constituci?n 2222','M?xico D.F.',null,'05021','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10927,40,4,to_date('05-MAR-98','DD-MON-RR'),to_date('02-APR-98','DD-MON-RR'),to_date('08-APR-98','DD-MON-RR'),1,19.79,'La corne d''abondance','67, avenue de l''Europe','Versailles',null,'78000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10928,29,1,to_date('05-MAR-98','DD-MON-RR'),to_date('02-APR-98','DD-MON-RR'),to_date('18-MAR-98','DD-MON-RR'),1,1.36,'Galer?a del gastron?mo','Rambla de Catalu?a, 23','Barcelona',null,'8022','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10929,25,6,to_date('05-MAR-98','DD-MON-RR'),to_date('02-APR-98','DD-MON-RR'),to_date('12-MAR-98','DD-MON-RR'),1,33.93,'Frankenversand','Berliner Platz 43','M?nchen',null,'80805','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10930,76,4,to_date('06-MAR-98','DD-MON-RR'),to_date('17-APR-98','DD-MON-RR'),to_date('18-MAR-98','DD-MON-RR'),3,15.55,'Supr?mes d?lices','Boulevard Tirou, 255','Charleroi',null,'B-6000','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10931,68,4,to_date('06-MAR-98','DD-MON-RR'),to_date('20-MAR-98','DD-MON-RR'),to_date('19-MAR-98','DD-MON-RR'),2,13.6,'Richter Supermarkt','Starenweg 5','Gen?ve',null,'1204','Switzerland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10932,9,8,to_date('06-MAR-98','DD-MON-RR'),to_date('03-APR-98','DD-MON-RR'),to_date('24-MAR-98','DD-MON-RR'),1,134.64,'Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10933,38,6,to_date('06-MAR-98','DD-MON-RR'),to_date('03-APR-98','DD-MON-RR'),to_date('16-MAR-98','DD-MON-RR'),3,54.15,'Island Trading','Garden House
Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10934,44,3,to_date('09-MAR-98','DD-MON-RR'),to_date('06-APR-98','DD-MON-RR'),to_date('12-MAR-98','DD-MON-RR'),3,32.01,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M. ',null,'60528','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10935,88,4,to_date('09-MAR-98','DD-MON-RR'),to_date('06-APR-98','DD-MON-RR'),to_date('18-MAR-98','DD-MON-RR'),3,47.59,'Wellington Importadora','Rua do Mercado, 12','Resende','SP','08737-363','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10936,32,3,to_date('09-MAR-98','DD-MON-RR'),to_date('06-APR-98','DD-MON-RR'),to_date('18-MAR-98','DD-MON-RR'),2,33.68,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10937,12,7,to_date('10-MAR-98','DD-MON-RR'),to_date('24-MAR-98','DD-MON-RR'),to_date('13-MAR-98','DD-MON-RR'),3,31.51,'Cactus Comidas para llevar','Cerrito 333','Buenos Aires',null,'1010','Argentina');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10938,63,3,to_date('10-MAR-98','DD-MON-RR'),to_date('07-APR-98','DD-MON-RR'),to_date('16-MAR-98','DD-MON-RR'),2,31.89,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11067,17,1,to_date('04-MAY-98','DD-MON-RR'),to_date('18-MAY-98','DD-MON-RR'),to_date('06-MAY-98','DD-MON-RR'),2,7.98,'Drachenblut Delikatessen','Walserweg 21','Aachen',null,'52066','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11068,62,8,to_date('04-MAY-98','DD-MON-RR'),to_date('01-JUN-98','DD-MON-RR'),null,2,81.75,'Queen Cozinha','Alameda dos Can?rios, 891','S?o Paulo','SP','05487-020','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11069,80,1,to_date('04-MAY-98','DD-MON-RR'),to_date('01-JUN-98','DD-MON-RR'),to_date('06-MAY-98','DD-MON-RR'),2,15.67,'Tortuga Restaurante','Avda. Azteca 123','M?xico D.F.',null,'05033','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11070,44,2,to_date('05-MAY-98','DD-MON-RR'),to_date('02-JUN-98','DD-MON-RR'),null,1,136,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M. ',null,'60528','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11071,46,1,to_date('05-MAY-98','DD-MON-RR'),to_date('02-JUN-98','DD-MON-RR'),null,1,0.93,'LILA-Supermercado','Carrera 52 con Ave. Bol?var #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10942,66,9,to_date('11-MAR-98','DD-MON-RR'),to_date('08-APR-98','DD-MON-RR'),to_date('18-MAR-98','DD-MON-RR'),3,17.95,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',null,'42100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10943,11,4,to_date('11-MAR-98','DD-MON-RR'),to_date('08-APR-98','DD-MON-RR'),to_date('19-MAR-98','DD-MON-RR'),2,2.17,'B''s Beverages','Fauntleroy Circus','London',null,'EC2 5NT','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10944,10,6,to_date('12-MAR-98','DD-MON-RR'),to_date('26-MAR-98','DD-MON-RR'),to_date('13-MAR-98','DD-MON-RR'),3,52.92,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10945,52,4,to_date('12-MAR-98','DD-MON-RR'),to_date('09-APR-98','DD-MON-RR'),to_date('18-MAR-98','DD-MON-RR'),1,10.22,'Morgenstern Gesundkost','Heerstr. 22','Leipzig',null,'04179','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10946,83,1,to_date('12-MAR-98','DD-MON-RR'),to_date('09-APR-98','DD-MON-RR'),to_date('19-MAR-98','DD-MON-RR'),2,27.2,'Vaffeljernet','Smagsl?get 45','?rhus',null,'8200','Denmark');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10947,11,3,to_date('13-MAR-98','DD-MON-RR'),to_date('10-APR-98','DD-MON-RR'),to_date('16-MAR-98','DD-MON-RR'),2,3.26,'B''s Beverages','Fauntleroy Circus','London',null,'EC2 5NT','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10948,30,3,to_date('13-MAR-98','DD-MON-RR'),to_date('10-APR-98','DD-MON-RR'),to_date('19-MAR-98','DD-MON-RR'),3,23.39,'Godos Cocina T?pica','C/ Romero, 33','Sevilla',null,'41101','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10949,10,2,to_date('13-MAR-98','DD-MON-RR'),to_date('10-APR-98','DD-MON-RR'),to_date('17-MAR-98','DD-MON-RR'),3,74.44,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10950,49,1,to_date('16-MAR-98','DD-MON-RR'),to_date('13-APR-98','DD-MON-RR'),to_date('23-MAR-98','DD-MON-RR'),2,2.5,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',null,'24100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10951,68,9,to_date('16-MAR-98','DD-MON-RR'),to_date('27-APR-98','DD-MON-RR'),to_date('07-APR-98','DD-MON-RR'),2,30.85,'Richter Supermarkt','Starenweg 5','Gen?ve',null,'1204','Switzerland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10952,1,1,to_date('16-MAR-98','DD-MON-RR'),to_date('27-APR-98','DD-MON-RR'),to_date('24-MAR-98','DD-MON-RR'),1,40.42,'Alfreds Futterkiste','Obere Str. 57','Berlin',null,'12209','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10579,45,1,to_date('25-JUN-97','DD-MON-RR'),to_date('23-JUL-97','DD-MON-RR'),to_date('04-JUL-97','DD-MON-RR'),2,13.73,'Let''s Stop N Shop','87 Polk St.
Suite 5','San Francisco','CA','94117','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10580,56,4,to_date('26-JUN-97','DD-MON-RR'),to_date('24-JUL-97','DD-MON-RR'),to_date('01-JUL-97','DD-MON-RR'),3,75.89,'Ottilies K?seladen','Mehrheimerstr. 369','K?ln',null,'50739','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10581,21,3,to_date('26-JUN-97','DD-MON-RR'),to_date('24-JUL-97','DD-MON-RR'),to_date('02-JUL-97','DD-MON-RR'),1,3.01,'Familia Arquibaldo','Rua Or?s, 92','S?o Paulo','SP','05442-030','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10582,6,3,to_date('27-JUN-97','DD-MON-RR'),to_date('25-JUL-97','DD-MON-RR'),to_date('14-JUL-97','DD-MON-RR'),2,27.71,'Blauer See Delikatessen','Forsterstr. 57','Mannheim',null,'68306','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10583,87,2,to_date('30-JUN-97','DD-MON-RR'),to_date('28-JUL-97','DD-MON-RR'),to_date('04-JUL-97','DD-MON-RR'),2,7.28,'Wartian Herkku','Torikatu 38','Oulu',null,'90110','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10584,7,4,to_date('30-JUN-97','DD-MON-RR'),to_date('28-JUL-97','DD-MON-RR'),to_date('04-JUL-97','DD-MON-RR'),1,59.14,'Blondel p?re et fils','24, place Kl?ber','Strasbourg',null,'67000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10585,88,7,to_date('01-JUL-97','DD-MON-RR'),to_date('29-JUL-97','DD-MON-RR'),to_date('10-JUL-97','DD-MON-RR'),1,13.41,'Wellington Importadora','Rua do Mercado, 12','Resende','SP','08737-363','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10586,66,9,to_date('02-JUL-97','DD-MON-RR'),to_date('30-JUL-97','DD-MON-RR'),to_date('09-JUL-97','DD-MON-RR'),1,0.48,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',null,'42100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10587,61,1,to_date('02-JUL-97','DD-MON-RR'),to_date('30-JUL-97','DD-MON-RR'),to_date('09-JUL-97','DD-MON-RR'),1,62.52,'Que Del?cia','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10588,63,2,to_date('03-JUL-97','DD-MON-RR'),to_date('31-JUL-97','DD-MON-RR'),to_date('10-JUL-97','DD-MON-RR'),3,194.67,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10589,32,8,to_date('04-JUL-97','DD-MON-RR'),to_date('01-AUG-97','DD-MON-RR'),to_date('14-JUL-97','DD-MON-RR'),2,4.42,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10590,51,4,to_date('07-JUL-97','DD-MON-RR'),to_date('04-AUG-97','DD-MON-RR'),to_date('14-JUL-97','DD-MON-RR'),3,44.77,'M?re Paillarde','43 rue St. Laurent','Montr?al','Qu?bec','H1J 1C3','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10591,83,1,to_date('07-JUL-97','DD-MON-RR'),to_date('21-JUL-97','DD-MON-RR'),to_date('16-JUL-97','DD-MON-RR'),1,55.92,'Vaffeljernet','Smagsl?get 45','?rhus',null,'8200','Denmark');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10592,44,3,to_date('08-JUL-97','DD-MON-RR'),to_date('05-AUG-97','DD-MON-RR'),to_date('16-JUL-97','DD-MON-RR'),1,32.1,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M. ',null,'60528','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10593,44,7,to_date('09-JUL-97','DD-MON-RR'),to_date('06-AUG-97','DD-MON-RR'),to_date('13-AUG-97','DD-MON-RR'),2,174.2,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M. ',null,'60528','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10594,55,3,to_date('09-JUL-97','DD-MON-RR'),to_date('06-AUG-97','DD-MON-RR'),to_date('16-JUL-97','DD-MON-RR'),2,5.24,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10595,20,2,to_date('10-JUL-97','DD-MON-RR'),to_date('07-AUG-97','DD-MON-RR'),to_date('14-JUL-97','DD-MON-RR'),1,96.78,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10596,89,8,to_date('11-JUL-97','DD-MON-RR'),to_date('08-AUG-97','DD-MON-RR'),to_date('12-AUG-97','DD-MON-RR'),1,16.34,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10597,59,7,to_date('11-JUL-97','DD-MON-RR'),to_date('08-AUG-97','DD-MON-RR'),to_date('18-JUL-97','DD-MON-RR'),3,35.12,'Piccolo und mehr','Geislweg 14','Salzburg',null,'5020','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10598,65,1,to_date('14-JUL-97','DD-MON-RR'),to_date('11-AUG-97','DD-MON-RR'),to_date('18-JUL-97','DD-MON-RR'),3,44.42,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10599,11,6,to_date('15-JUL-97','DD-MON-RR'),to_date('26-AUG-97','DD-MON-RR'),to_date('21-JUL-97','DD-MON-RR'),3,29.98,'B''s Beverages','Fauntleroy Circus','London',null,'EC2 5NT','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10600,36,4,to_date('16-JUL-97','DD-MON-RR'),to_date('13-AUG-97','DD-MON-RR'),to_date('21-JUL-97','DD-MON-RR'),1,45.13,'Hungry Coyote Import Store','City Center Plaza
516 Main St.','Elgin','OR','97827','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10601,35,7,to_date('16-JUL-97','DD-MON-RR'),to_date('27-AUG-97','DD-MON-RR'),to_date('22-JUL-97','DD-MON-RR'),1,58.3,'HILARI?N-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10602,83,8,to_date('17-JUL-97','DD-MON-RR'),to_date('14-AUG-97','DD-MON-RR'),to_date('22-JUL-97','DD-MON-RR'),2,2.92,'Vaffeljernet','Smagsl?get 45','?rhus',null,'8200','Denmark');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10603,71,8,to_date('18-JUL-97','DD-MON-RR'),to_date('15-AUG-97','DD-MON-RR'),to_date('08-AUG-97','DD-MON-RR'),2,48.77,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10604,28,1,to_date('18-JUL-97','DD-MON-RR'),to_date('15-AUG-97','DD-MON-RR'),to_date('29-JUL-97','DD-MON-RR'),1,7.46,'Furia Bacalhau e Frutos do Mar','Jardim das rosas n. 32','Lisboa',null,'1675','Portugal');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10605,51,1,to_date('21-JUL-97','DD-MON-RR'),to_date('18-AUG-97','DD-MON-RR'),to_date('29-JUL-97','DD-MON-RR'),2,379.13,'M?re Paillarde','43 rue St. Laurent','Montr?al','Qu?bec','H1J 1C3','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10606,81,4,to_date('22-JUL-97','DD-MON-RR'),to_date('19-AUG-97','DD-MON-RR'),to_date('31-JUL-97','DD-MON-RR'),3,79.4,'Tradi??o Hipermercados','Av. In?s de Castro, 414','S?o Paulo','SP','05634-030','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10607,71,5,to_date('22-JUL-97','DD-MON-RR'),to_date('19-AUG-97','DD-MON-RR'),to_date('25-JUL-97','DD-MON-RR'),1,200.24,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10608,79,4,to_date('23-JUL-97','DD-MON-RR'),to_date('20-AUG-97','DD-MON-RR'),to_date('01-AUG-97','DD-MON-RR'),2,27.79,'Toms Spezialit?ten','Luisenstr. 48','M?nster',null,'44087','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10609,18,7,to_date('24-JUL-97','DD-MON-RR'),to_date('21-AUG-97','DD-MON-RR'),to_date('30-JUL-97','DD-MON-RR'),2,1.85,'Du monde entier','67, rue des Cinquante Otages','Nantes',null,'44000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10610,41,8,to_date('25-JUL-97','DD-MON-RR'),to_date('22-AUG-97','DD-MON-RR'),to_date('06-AUG-97','DD-MON-RR'),1,26.78,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',null,'31000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10611,91,6,to_date('25-JUL-97','DD-MON-RR'),to_date('22-AUG-97','DD-MON-RR'),to_date('01-AUG-97','DD-MON-RR'),2,80.65,'Wolski Zajazd','ul. Filtrowa 68','Warszawa',null,'01-012','Poland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10612,71,1,to_date('28-JUL-97','DD-MON-RR'),to_date('25-AUG-97','DD-MON-RR'),to_date('01-AUG-97','DD-MON-RR'),2,544.08,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10613,35,4,to_date('29-JUL-97','DD-MON-RR'),to_date('26-AUG-97','DD-MON-RR'),to_date('01-AUG-97','DD-MON-RR'),2,8.11,'HILARI?N-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10614,6,8,to_date('29-JUL-97','DD-MON-RR'),to_date('26-AUG-97','DD-MON-RR'),to_date('01-AUG-97','DD-MON-RR'),3,1.93,'Blauer See Delikatessen','Forsterstr. 57','Mannheim',null,'68306','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10615,90,2,to_date('30-JUL-97','DD-MON-RR'),to_date('27-AUG-97','DD-MON-RR'),to_date('06-AUG-97','DD-MON-RR'),3,0.75,'Wilman Kala','Keskuskatu 45','Helsinki',null,'21240','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10616,32,1,to_date('31-JUL-97','DD-MON-RR'),to_date('28-AUG-97','DD-MON-RR'),to_date('05-AUG-97','DD-MON-RR'),2,116.53,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10617,32,4,to_date('31-JUL-97','DD-MON-RR'),to_date('28-AUG-97','DD-MON-RR'),to_date('04-AUG-97','DD-MON-RR'),2,18.53,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10618,51,1,to_date('01-AUG-97','DD-MON-RR'),to_date('12-SEP-97','DD-MON-RR'),to_date('08-AUG-97','DD-MON-RR'),1,154.68,'M?re Paillarde','43 rue St. Laurent','Montr?al','Qu?bec','H1J 1C3','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10619,51,3,to_date('04-AUG-97','DD-MON-RR'),to_date('01-SEP-97','DD-MON-RR'),to_date('07-AUG-97','DD-MON-RR'),3,91.05,'M?re Paillarde','43 rue St. Laurent','Montr?al','Qu?bec','H1J 1C3','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10620,42,2,to_date('05-AUG-97','DD-MON-RR'),to_date('02-SEP-97','DD-MON-RR'),to_date('14-AUG-97','DD-MON-RR'),3,0.94,'Laughing Bacchus Wine Cellars','2319 Elm St.','Vancouver','BC','V3F 2K1','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10621,38,4,to_date('05-AUG-97','DD-MON-RR'),to_date('02-SEP-97','DD-MON-RR'),to_date('11-AUG-97','DD-MON-RR'),2,23.73,'Island Trading','Garden House
Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10622,67,4,to_date('06-AUG-97','DD-MON-RR'),to_date('03-SEP-97','DD-MON-RR'),to_date('11-AUG-97','DD-MON-RR'),3,50.97,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10623,25,8,to_date('07-AUG-97','DD-MON-RR'),to_date('04-SEP-97','DD-MON-RR'),to_date('12-AUG-97','DD-MON-RR'),2,97.18,'Frankenversand','Berliner Platz 43','M?nchen',null,'80805','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10624,78,4,to_date('07-AUG-97','DD-MON-RR'),to_date('04-SEP-97','DD-MON-RR'),to_date('19-AUG-97','DD-MON-RR'),2,94.8,'The Cracker Box','55 Grizzly Peak Rd.','Butte','MT','59801','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10625,2,3,to_date('08-AUG-97','DD-MON-RR'),to_date('05-SEP-97','DD-MON-RR'),to_date('14-AUG-97','DD-MON-RR'),1,43.9,'Ana Trujillo Emparedados y helados','Avda. de la Constituci?n 2222','M?xico D.F.',null,'05021','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10626,5,1,to_date('11-AUG-97','DD-MON-RR'),to_date('08-SEP-97','DD-MON-RR'),to_date('20-AUG-97','DD-MON-RR'),2,138.69,'Berglunds snabbk?p','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10627,71,8,to_date('11-AUG-97','DD-MON-RR'),to_date('22-SEP-97','DD-MON-RR'),to_date('21-AUG-97','DD-MON-RR'),3,107.46,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10628,7,4,to_date('12-AUG-97','DD-MON-RR'),to_date('09-SEP-97','DD-MON-RR'),to_date('20-AUG-97','DD-MON-RR'),3,30.36,'Blondel p?re et fils','24, place Kl?ber','Strasbourg',null,'67000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10629,30,4,to_date('12-AUG-97','DD-MON-RR'),to_date('09-SEP-97','DD-MON-RR'),to_date('20-AUG-97','DD-MON-RR'),3,85.46,'Godos Cocina T?pica','C/ Romero, 33','Sevilla',null,'41101','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10630,39,1,to_date('13-AUG-97','DD-MON-RR'),to_date('10-SEP-97','DD-MON-RR'),to_date('19-AUG-97','DD-MON-RR'),2,32.35,'K?niglich Essen','Maubelstr. 90','Brandenburg',null,'14776','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10631,41,8,to_date('14-AUG-97','DD-MON-RR'),to_date('11-SEP-97','DD-MON-RR'),to_date('15-AUG-97','DD-MON-RR'),1,0.87,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',null,'31000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10632,86,8,to_date('14-AUG-97','DD-MON-RR'),to_date('11-SEP-97','DD-MON-RR'),to_date('19-AUG-97','DD-MON-RR'),1,41.38,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',null,'70563','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10633,20,7,to_date('15-AUG-97','DD-MON-RR'),to_date('12-SEP-97','DD-MON-RR'),to_date('18-AUG-97','DD-MON-RR'),3,477.9,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10634,23,4,to_date('15-AUG-97','DD-MON-RR'),to_date('12-SEP-97','DD-MON-RR'),to_date('21-AUG-97','DD-MON-RR'),3,487.38,'Folies gourmandes','184, chauss?e de Tournai','Lille',null,'59000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10635,49,8,to_date('18-AUG-97','DD-MON-RR'),to_date('15-SEP-97','DD-MON-RR'),to_date('21-AUG-97','DD-MON-RR'),3,47.46,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',null,'24100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10636,87,4,to_date('19-AUG-97','DD-MON-RR'),to_date('16-SEP-97','DD-MON-RR'),to_date('26-AUG-97','DD-MON-RR'),1,1.15,'Wartian Herkku','Torikatu 38','Oulu',null,'90110','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10637,62,6,to_date('19-AUG-97','DD-MON-RR'),to_date('16-SEP-97','DD-MON-RR'),to_date('26-AUG-97','DD-MON-RR'),1,201.29,'Queen Cozinha','Alameda dos Can?rios, 891','S?o Paulo','SP','05487-020','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10638,47,3,to_date('20-AUG-97','DD-MON-RR'),to_date('17-SEP-97','DD-MON-RR'),to_date('01-SEP-97','DD-MON-RR'),1,158.44,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10639,70,7,to_date('20-AUG-97','DD-MON-RR'),to_date('17-SEP-97','DD-MON-RR'),to_date('27-AUG-97','DD-MON-RR'),3,38.64,'Sant? Gourmet','Erling Skakkes gate 78','Stavern',null,'4110','Norway');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10640,86,4,to_date('21-AUG-97','DD-MON-RR'),to_date('18-SEP-97','DD-MON-RR'),to_date('28-AUG-97','DD-MON-RR'),1,23.55,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',null,'70563','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10641,35,4,to_date('22-AUG-97','DD-MON-RR'),to_date('19-SEP-97','DD-MON-RR'),to_date('26-AUG-97','DD-MON-RR'),2,179.61,'HILARI?N-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10642,73,7,to_date('22-AUG-97','DD-MON-RR'),to_date('19-SEP-97','DD-MON-RR'),to_date('05-SEP-97','DD-MON-RR'),3,41.89,'Simons bistro','Vinb?ltet 34','K?benhavn',null,'1734','Denmark');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10643,1,6,to_date('25-AUG-97','DD-MON-RR'),to_date('22-SEP-97','DD-MON-RR'),to_date('02-SEP-97','DD-MON-RR'),1,29.46,'Alfreds Futterkiste','Obere Str. 57A 
FDS','Berlin',null,'12209','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10644,88,3,to_date('25-AUG-97','DD-MON-RR'),to_date('22-SEP-97','DD-MON-RR'),to_date('01-SEP-97','DD-MON-RR'),2,0.14,'Wellington Importadora','Rua do Mercado, 12','Resende','SP','08737-363','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10645,34,4,to_date('26-AUG-97','DD-MON-RR'),to_date('23-SEP-97','DD-MON-RR'),to_date('02-SEP-97','DD-MON-RR'),1,12.41,'Hanari Carnes','Rua do Pa?o, 67','Rio de Janeiro','RJ','05454-876','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10646,37,9,to_date('27-AUG-97','DD-MON-RR'),to_date('08-OCT-97','DD-MON-RR'),to_date('03-SEP-97','DD-MON-RR'),3,142.33,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10647,61,4,to_date('27-AUG-97','DD-MON-RR'),to_date('10-SEP-97','DD-MON-RR'),to_date('03-SEP-97','DD-MON-RR'),2,45.54,'Que Del?cia','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10648,67,5,to_date('28-AUG-97','DD-MON-RR'),to_date('09-OCT-97','DD-MON-RR'),to_date('09-SEP-97','DD-MON-RR'),2,14.25,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10953,4,9,to_date('16-MAR-98','DD-MON-RR'),to_date('30-MAR-98','DD-MON-RR'),to_date('25-MAR-98','DD-MON-RR'),2,23.72,'Around the Horn','Brook Farm
Stratford St. Mary','Colchester','Essex','CO7 6JX','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10954,47,5,to_date('17-MAR-98','DD-MON-RR'),to_date('28-APR-98','DD-MON-RR'),to_date('20-MAR-98','DD-MON-RR'),1,27.91,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10955,24,8,to_date('17-MAR-98','DD-MON-RR'),to_date('14-APR-98','DD-MON-RR'),to_date('20-MAR-98','DD-MON-RR'),2,3.26,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10956,6,6,to_date('17-MAR-98','DD-MON-RR'),to_date('28-APR-98','DD-MON-RR'),to_date('20-MAR-98','DD-MON-RR'),2,44.65,'Blauer See Delikatessen','Forsterstr. 57','Mannheim',null,'68306','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10957,35,8,to_date('18-MAR-98','DD-MON-RR'),to_date('15-APR-98','DD-MON-RR'),to_date('27-MAR-98','DD-MON-RR'),3,105.36,'HILARI?N-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10958,54,7,to_date('18-MAR-98','DD-MON-RR'),to_date('15-APR-98','DD-MON-RR'),to_date('27-MAR-98','DD-MON-RR'),2,49.56,'Oc?ano Atl?ntico Ltda.','Ing. Gustavo Moncada 8585
Piso 20-A','Buenos Aires',null,'1010','Argentina');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10959,31,6,to_date('18-MAR-98','DD-MON-RR'),to_date('29-APR-98','DD-MON-RR'),to_date('23-MAR-98','DD-MON-RR'),2,4.98,'Gourmet Lanchonetes','Av. Brasil, 442','Campinas','SP','04876-786','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10960,35,3,to_date('19-MAR-98','DD-MON-RR'),to_date('02-APR-98','DD-MON-RR'),to_date('08-APR-98','DD-MON-RR'),1,2.08,'HILARI?N-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10961,62,8,to_date('19-MAR-98','DD-MON-RR'),to_date('16-APR-98','DD-MON-RR'),to_date('30-MAR-98','DD-MON-RR'),1,104.47,'Queen Cozinha','Alameda dos Can?rios, 891','S?o Paulo','SP','05487-020','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10962,63,8,to_date('19-MAR-98','DD-MON-RR'),to_date('16-APR-98','DD-MON-RR'),to_date('23-MAR-98','DD-MON-RR'),2,275.79,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10963,28,9,to_date('19-MAR-98','DD-MON-RR'),to_date('16-APR-98','DD-MON-RR'),to_date('26-MAR-98','DD-MON-RR'),3,2.7,'Furia Bacalhau e Frutos do Mar','Jardim das rosas n. 32','Lisboa',null,'1675','Portugal');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10964,74,3,to_date('20-MAR-98','DD-MON-RR'),to_date('17-APR-98','DD-MON-RR'),to_date('24-MAR-98','DD-MON-RR'),2,87.38,'Sp?cialit?s du monde','25, rue Lauriston','Paris',null,'75016','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10965,55,6,to_date('20-MAR-98','DD-MON-RR'),to_date('17-APR-98','DD-MON-RR'),to_date('30-MAR-98','DD-MON-RR'),3,144.38,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10966,14,4,to_date('20-MAR-98','DD-MON-RR'),to_date('17-APR-98','DD-MON-RR'),to_date('08-APR-98','DD-MON-RR'),1,27.19,'Chop-suey Chinese','Hauptstr. 31','Bern',null,'3012','Switzerland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10967,79,2,to_date('23-MAR-98','DD-MON-RR'),to_date('20-APR-98','DD-MON-RR'),to_date('02-APR-98','DD-MON-RR'),2,62.22,'Toms Spezialit?ten','Luisenstr. 48','M?nster',null,'44087','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10968,20,1,to_date('23-MAR-98','DD-MON-RR'),to_date('20-APR-98','DD-MON-RR'),to_date('01-APR-98','DD-MON-RR'),3,74.6,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10969,15,1,to_date('23-MAR-98','DD-MON-RR'),to_date('20-APR-98','DD-MON-RR'),to_date('30-MAR-98','DD-MON-RR'),2,0.21,'Com?rcio Mineiro','Av. dos Lus?adas, 23','S?o Paulo','SP','05432-043','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10970,8,9,to_date('24-MAR-98','DD-MON-RR'),to_date('07-APR-98','DD-MON-RR'),to_date('24-APR-98','DD-MON-RR'),1,16.16,'B?lido Comidas preparadas','C/ Araquil, 67','Madrid',null,'28023','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10971,26,2,to_date('24-MAR-98','DD-MON-RR'),to_date('21-APR-98','DD-MON-RR'),to_date('02-APR-98','DD-MON-RR'),2,121.82,'France restauration','54, rue Royale','Nantes',null,'44000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10972,40,4,to_date('24-MAR-98','DD-MON-RR'),to_date('21-APR-98','DD-MON-RR'),to_date('26-MAR-98','DD-MON-RR'),2,0.02,'La corne d''abondance','67, avenue de l''Europe','Versailles',null,'78000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10973,40,6,to_date('24-MAR-98','DD-MON-RR'),to_date('21-APR-98','DD-MON-RR'),to_date('27-MAR-98','DD-MON-RR'),2,15.17,'La corne d''abondance','67, avenue de l''Europe','Versailles',null,'78000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10974,75,3,to_date('25-MAR-98','DD-MON-RR'),to_date('08-APR-98','DD-MON-RR'),to_date('03-APR-98','DD-MON-RR'),3,12.96,'Split Rail Beer & Ale','P.O. Box 555','Lander','WY','82520','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10975,10,1,to_date('25-MAR-98','DD-MON-RR'),to_date('22-APR-98','DD-MON-RR'),to_date('27-MAR-98','DD-MON-RR'),3,32.27,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11020,56,2,to_date('14-APR-98','DD-MON-RR'),to_date('12-MAY-98','DD-MON-RR'),to_date('16-APR-98','DD-MON-RR'),2,43.3,'Ottilies K?seladen','Mehrheimerstr. 369','K?ln',null,'50739','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11021,63,3,to_date('14-APR-98','DD-MON-RR'),to_date('12-MAY-98','DD-MON-RR'),to_date('21-APR-98','DD-MON-RR'),1,297.18,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11022,34,9,to_date('14-APR-98','DD-MON-RR'),to_date('12-MAY-98','DD-MON-RR'),to_date('04-MAY-98','DD-MON-RR'),2,6.27,'Hanari Carnes','Rua do Pa?o, 67','Rio de Janeiro','RJ','05454-876','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11023,11,1,to_date('14-APR-98','DD-MON-RR'),to_date('28-APR-98','DD-MON-RR'),to_date('24-APR-98','DD-MON-RR'),2,123.83,'B''s Beverages','Fauntleroy Circus','London',null,'EC2 5NT','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11024,19,4,to_date('15-APR-98','DD-MON-RR'),to_date('13-MAY-98','DD-MON-RR'),to_date('20-APR-98','DD-MON-RR'),1,74.36,'Eastern Connection','35 King George','London',null,'WX3 6FW','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11025,87,6,to_date('15-APR-98','DD-MON-RR'),to_date('13-MAY-98','DD-MON-RR'),to_date('24-APR-98','DD-MON-RR'),3,29.17,'Wartian Herkku','Torikatu 38','Oulu',null,'90110','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11026,27,4,to_date('15-APR-98','DD-MON-RR'),to_date('13-MAY-98','DD-MON-RR'),to_date('28-APR-98','DD-MON-RR'),1,47.09,'Franchi S.p.A.','Via Monte Bianco 34','Torino',null,'10100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11027,10,1,to_date('16-APR-98','DD-MON-RR'),to_date('14-MAY-98','DD-MON-RR'),to_date('20-APR-98','DD-MON-RR'),1,52.52,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11028,39,2,to_date('16-APR-98','DD-MON-RR'),to_date('14-MAY-98','DD-MON-RR'),to_date('22-APR-98','DD-MON-RR'),1,29.59,'K?niglich Essen','Maubelstr. 90','Brandenburg',null,'14776','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11029,14,4,to_date('16-APR-98','DD-MON-RR'),to_date('14-MAY-98','DD-MON-RR'),to_date('27-APR-98','DD-MON-RR'),1,47.84,'Chop-suey Chinese','Hauptstr. 31','Bern',null,'3012','Switzerland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11030,71,7,to_date('17-APR-98','DD-MON-RR'),to_date('15-MAY-98','DD-MON-RR'),to_date('27-APR-98','DD-MON-RR'),2,830.75,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11031,71,6,to_date('17-APR-98','DD-MON-RR'),to_date('15-MAY-98','DD-MON-RR'),to_date('24-APR-98','DD-MON-RR'),2,227.22,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11032,89,2,to_date('17-APR-98','DD-MON-RR'),to_date('15-MAY-98','DD-MON-RR'),to_date('23-APR-98','DD-MON-RR'),3,606.19,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11033,68,7,to_date('17-APR-98','DD-MON-RR'),to_date('15-MAY-98','DD-MON-RR'),to_date('23-APR-98','DD-MON-RR'),3,84.74,'Richter Supermarkt','Starenweg 5','Gen?ve',null,'1204','Switzerland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11034,55,8,to_date('20-APR-98','DD-MON-RR'),to_date('01-JUN-98','DD-MON-RR'),to_date('27-APR-98','DD-MON-RR'),1,40.32,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11035,76,2,to_date('20-APR-98','DD-MON-RR'),to_date('18-MAY-98','DD-MON-RR'),to_date('24-APR-98','DD-MON-RR'),2,0.17,'Supr?mes d?lices','Boulevard Tirou, 255','Charleroi',null,'B-6000','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11036,17,8,to_date('20-APR-98','DD-MON-RR'),to_date('18-MAY-98','DD-MON-RR'),to_date('22-APR-98','DD-MON-RR'),3,149.47,'Drachenblut Delikatessen','Walserweg 21','Aachen',null,'52066','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11037,30,7,to_date('21-APR-98','DD-MON-RR'),to_date('19-MAY-98','DD-MON-RR'),to_date('27-APR-98','DD-MON-RR'),1,3.2,'Godos Cocina T?pica','C/ Romero, 33','Sevilla',null,'41101','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11038,76,1,to_date('21-APR-98','DD-MON-RR'),to_date('19-MAY-98','DD-MON-RR'),to_date('30-APR-98','DD-MON-RR'),2,29.59,'Supr?mes d?lices','Boulevard Tirou, 255','Charleroi',null,'B-6000','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11039,47,1,to_date('21-APR-98','DD-MON-RR'),to_date('19-MAY-98','DD-MON-RR'),null,2,65,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11040,32,4,to_date('22-APR-98','DD-MON-RR'),to_date('20-MAY-98','DD-MON-RR'),null,3,18.84,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11041,14,3,to_date('22-APR-98','DD-MON-RR'),to_date('20-MAY-98','DD-MON-RR'),to_date('28-APR-98','DD-MON-RR'),2,48.22,'Chop-suey Chinese','Hauptstr. 31','Bern',null,'3012','Switzerland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11042,15,2,to_date('22-APR-98','DD-MON-RR'),to_date('06-MAY-98','DD-MON-RR'),to_date('01-MAY-98','DD-MON-RR'),1,29.99,'Com?rcio Mineiro','Av. dos Lus?adas, 23','S?o Paulo','SP','05432-043','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11043,74,5,to_date('22-APR-98','DD-MON-RR'),to_date('20-MAY-98','DD-MON-RR'),to_date('29-APR-98','DD-MON-RR'),2,8.8,'Sp?cialit?s du monde','25, rue Lauriston','Paris',null,'75016','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11044,91,4,to_date('23-APR-98','DD-MON-RR'),to_date('21-MAY-98','DD-MON-RR'),to_date('01-MAY-98','DD-MON-RR'),1,8.72,'Wolski Zajazd','ul. Filtrowa 68','Warszawa',null,'01-012','Poland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11045,10,6,to_date('23-APR-98','DD-MON-RR'),to_date('21-MAY-98','DD-MON-RR'),null,2,70.58,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11046,86,8,to_date('23-APR-98','DD-MON-RR'),to_date('21-MAY-98','DD-MON-RR'),to_date('24-APR-98','DD-MON-RR'),2,71.64,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',null,'70563','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11047,19,7,to_date('24-APR-98','DD-MON-RR'),to_date('22-MAY-98','DD-MON-RR'),to_date('01-MAY-98','DD-MON-RR'),3,46.62,'Eastern Connection','35 King George','London',null,'WX3 6FW','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11048,10,7,to_date('24-APR-98','DD-MON-RR'),to_date('22-MAY-98','DD-MON-RR'),to_date('30-APR-98','DD-MON-RR'),3,24.12,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11049,31,3,to_date('24-APR-98','DD-MON-RR'),to_date('22-MAY-98','DD-MON-RR'),to_date('04-MAY-98','DD-MON-RR'),1,8.34,'Gourmet Lanchonetes','Av. Brasil, 442','Campinas','SP','04876-786','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11050,24,8,to_date('27-APR-98','DD-MON-RR'),to_date('25-MAY-98','DD-MON-RR'),to_date('05-MAY-98','DD-MON-RR'),2,59.41,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11051,41,7,to_date('27-APR-98','DD-MON-RR'),to_date('25-MAY-98','DD-MON-RR'),null,3,2.79,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',null,'31000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11052,34,3,to_date('27-APR-98','DD-MON-RR'),to_date('25-MAY-98','DD-MON-RR'),to_date('01-MAY-98','DD-MON-RR'),1,67.26,'Hanari Carnes','Rua do Pa?o, 67','Rio de Janeiro','RJ','05454-876','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11053,59,2,to_date('27-APR-98','DD-MON-RR'),to_date('25-MAY-98','DD-MON-RR'),to_date('29-APR-98','DD-MON-RR'),2,53.05,'Piccolo und mehr','Geislweg 14','Salzburg',null,'5020','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11054,12,8,to_date('28-APR-98','DD-MON-RR'),to_date('26-MAY-98','DD-MON-RR'),null,1,0.33,'Cactus Comidas para llevar','Cerrito 333','Buenos Aires',null,'1010','Argentina');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11055,35,7,to_date('28-APR-98','DD-MON-RR'),to_date('26-MAY-98','DD-MON-RR'),to_date('05-MAY-98','DD-MON-RR'),2,120.92,'HILARI?N-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11056,19,8,to_date('28-APR-98','DD-MON-RR'),to_date('12-MAY-98','DD-MON-RR'),to_date('01-MAY-98','DD-MON-RR'),2,278.96,'Eastern Connection','35 King George','London',null,'WX3 6FW','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11057,53,3,to_date('29-APR-98','DD-MON-RR'),to_date('27-MAY-98','DD-MON-RR'),to_date('01-MAY-98','DD-MON-RR'),3,4.13,'North/South','South House
300 Queensbridge','London',null,'SW7 1RZ','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11058,6,9,to_date('29-APR-98','DD-MON-RR'),to_date('27-MAY-98','DD-MON-RR'),null,3,31.14,'Blauer See Delikatessen','Forsterstr. 57','Mannheim',null,'68306','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11059,67,2,to_date('29-APR-98','DD-MON-RR'),to_date('10-JUN-98','DD-MON-RR'),null,2,85.8,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11060,27,2,to_date('30-APR-98','DD-MON-RR'),to_date('28-MAY-98','DD-MON-RR'),to_date('04-MAY-98','DD-MON-RR'),2,10.98,'Franchi S.p.A.','Via Monte Bianco 34','Torino',null,'10100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11061,32,4,to_date('30-APR-98','DD-MON-RR'),to_date('11-JUN-98','DD-MON-RR'),null,3,14.01,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11062,66,4,to_date('30-APR-98','DD-MON-RR'),to_date('28-MAY-98','DD-MON-RR'),null,2,29.93,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',null,'42100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11063,37,3,to_date('30-APR-98','DD-MON-RR'),to_date('28-MAY-98','DD-MON-RR'),to_date('06-MAY-98','DD-MON-RR'),2,81.73,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11064,71,1,to_date('01-MAY-98','DD-MON-RR'),to_date('29-MAY-98','DD-MON-RR'),to_date('04-MAY-98','DD-MON-RR'),1,30.09,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11065,46,8,to_date('01-MAY-98','DD-MON-RR'),to_date('29-MAY-98','DD-MON-RR'),null,1,12.91,'LILA-Supermercado','Carrera 52 con Ave. Bol?var #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11066,89,7,to_date('01-MAY-98','DD-MON-RR'),to_date('29-MAY-98','DD-MON-RR'),to_date('04-MAY-98','DD-MON-RR'),2,44.72,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10561,24,2,to_date('06-JUN-97','DD-MON-RR'),to_date('04-JUL-97','DD-MON-RR'),to_date('09-JUN-97','DD-MON-RR'),2,242.21,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10562,66,1,to_date('09-JUN-97','DD-MON-RR'),to_date('07-JUL-97','DD-MON-RR'),to_date('12-JUN-97','DD-MON-RR'),1,22.95,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',null,'42100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10563,67,2,to_date('10-JUN-97','DD-MON-RR'),to_date('22-JUL-97','DD-MON-RR'),to_date('24-JUN-97','DD-MON-RR'),2,60.43,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10564,65,4,to_date('10-JUN-97','DD-MON-RR'),to_date('08-JUL-97','DD-MON-RR'),to_date('16-JUN-97','DD-MON-RR'),3,13.75,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10565,51,8,to_date('11-JUN-97','DD-MON-RR'),to_date('09-JUL-97','DD-MON-RR'),to_date('18-JUN-97','DD-MON-RR'),2,7.15,'M?re Paillarde','43 rue St. Laurent','Montr?al','Qu?bec','H1J 1C3','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10566,7,9,to_date('12-JUN-97','DD-MON-RR'),to_date('10-JUL-97','DD-MON-RR'),to_date('18-JUN-97','DD-MON-RR'),1,88.4,'Blondel p?re et fils','24, place Kl?ber','Strasbourg',null,'67000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10567,37,1,to_date('12-JUN-97','DD-MON-RR'),to_date('10-JUL-97','DD-MON-RR'),to_date('17-JUN-97','DD-MON-RR'),1,33.97,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10568,29,3,to_date('13-JUN-97','DD-MON-RR'),to_date('11-JUL-97','DD-MON-RR'),to_date('09-JUL-97','DD-MON-RR'),3,6.54,'Galer?a del gastron?mo','Rambla de Catalu?a, 23','Barcelona',null,'8022','Spain');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10569,65,5,to_date('16-JUN-97','DD-MON-RR'),to_date('14-JUL-97','DD-MON-RR'),to_date('11-JUL-97','DD-MON-RR'),1,58.98,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10570,51,3,to_date('17-JUN-97','DD-MON-RR'),to_date('15-JUL-97','DD-MON-RR'),to_date('19-JUN-97','DD-MON-RR'),3,188.99,'M?re Paillarde','43 rue St. Laurent','Montr?al','Qu?bec','H1J 1C3','Canada');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10571,20,8,to_date('17-JUN-97','DD-MON-RR'),to_date('29-JUL-97','DD-MON-RR'),to_date('04-JUL-97','DD-MON-RR'),3,26.06,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10572,5,3,to_date('18-JUN-97','DD-MON-RR'),to_date('16-JUL-97','DD-MON-RR'),to_date('25-JUN-97','DD-MON-RR'),2,116.43,'Berglunds snabbk?p','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10573,3,7,to_date('19-JUN-97','DD-MON-RR'),to_date('17-JUL-97','DD-MON-RR'),to_date('20-JUN-97','DD-MON-RR'),3,84.84,'Antonio Moreno Taquer?a','Mataderos  2312','M?xico D.F.',null,'05023','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10574,82,4,to_date('19-JUN-97','DD-MON-RR'),to_date('17-JUL-97','DD-MON-RR'),to_date('30-JUN-97','DD-MON-RR'),2,37.6,'Trail''s Head Gourmet Provisioners','722 DaVinci Blvd.','Kirkland','WA','98034','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10575,52,5,to_date('20-JUN-97','DD-MON-RR'),to_date('04-JUL-97','DD-MON-RR'),to_date('30-JUN-97','DD-MON-RR'),1,127.34,'Morgenstern Gesundkost','Heerstr. 22','Leipzig',null,'04179','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10576,80,3,to_date('23-JUN-97','DD-MON-RR'),to_date('07-JUL-97','DD-MON-RR'),to_date('30-JUN-97','DD-MON-RR'),3,18.56,'Tortuga Restaurante','Avda. Azteca 123','M?xico D.F.',null,'05033','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10577,82,9,to_date('23-JUN-97','DD-MON-RR'),to_date('04-AUG-97','DD-MON-RR'),to_date('30-JUN-97','DD-MON-RR'),2,25.41,'Trail''s Head Gourmet Provisioners','722 DaVinci Blvd.','Kirkland','WA','98034','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10578,11,4,to_date('24-JUN-97','DD-MON-RR'),to_date('22-JUL-97','DD-MON-RR'),to_date('25-JUL-97','DD-MON-RR'),3,29.6,'B''s Beverages','Fauntleroy Circus','London',null,'EC2 5NT','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10649,50,5,to_date('28-AUG-97','DD-MON-RR'),to_date('25-SEP-97','DD-MON-RR'),to_date('29-AUG-97','DD-MON-RR'),3,6.2,'Maison Dewey','Rue Joseph-Bens 532','Bruxelles',null,'B-1180','Belgium');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10650,21,5,to_date('29-AUG-97','DD-MON-RR'),to_date('26-SEP-97','DD-MON-RR'),to_date('03-SEP-97','DD-MON-RR'),3,176.81,'Familia Arquibaldo','Rua Or?s, 92','S?o Paulo','SP','05442-030','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10651,86,8,to_date('01-SEP-97','DD-MON-RR'),to_date('29-SEP-97','DD-MON-RR'),to_date('11-SEP-97','DD-MON-RR'),2,20.6,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',null,'70563','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10652,31,4,to_date('01-SEP-97','DD-MON-RR'),to_date('29-SEP-97','DD-MON-RR'),to_date('08-SEP-97','DD-MON-RR'),2,7.14,'Gourmet Lanchonetes','Av. Brasil, 442','Campinas','SP','04876-786','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10653,25,1,to_date('02-SEP-97','DD-MON-RR'),to_date('30-SEP-97','DD-MON-RR'),to_date('19-SEP-97','DD-MON-RR'),1,93.25,'Frankenversand','Berliner Platz 43','M?nchen',null,'80805','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10654,5,5,to_date('02-SEP-97','DD-MON-RR'),to_date('30-SEP-97','DD-MON-RR'),to_date('11-SEP-97','DD-MON-RR'),1,55.26,'Berglunds snabbk?p','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10655,66,1,to_date('03-SEP-97','DD-MON-RR'),to_date('01-OCT-97','DD-MON-RR'),to_date('11-SEP-97','DD-MON-RR'),2,4.41,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',null,'42100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10656,32,6,to_date('04-SEP-97','DD-MON-RR'),to_date('02-OCT-97','DD-MON-RR'),to_date('10-SEP-97','DD-MON-RR'),1,57.15,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10657,71,2,to_date('04-SEP-97','DD-MON-RR'),to_date('02-OCT-97','DD-MON-RR'),to_date('15-SEP-97','DD-MON-RR'),2,352.69,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10658,63,4,to_date('05-SEP-97','DD-MON-RR'),to_date('03-OCT-97','DD-MON-RR'),to_date('08-SEP-97','DD-MON-RR'),1,364.15,'QUICK-Stop','Taucherstra?e 10','Cunewalde',null,'01307','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10659,62,7,to_date('05-SEP-97','DD-MON-RR'),to_date('03-OCT-97','DD-MON-RR'),to_date('10-SEP-97','DD-MON-RR'),2,105.81,'Queen Cozinha','Alameda dos Can?rios, 891','S?o Paulo','SP','05487-020','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10660,36,8,to_date('08-SEP-97','DD-MON-RR'),to_date('06-OCT-97','DD-MON-RR'),to_date('15-OCT-97','DD-MON-RR'),1,111.29,'Hungry Coyote Import Store','City Center Plaza
516 Main St.','Elgin','OR','97827','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10661,37,7,to_date('09-SEP-97','DD-MON-RR'),to_date('07-OCT-97','DD-MON-RR'),to_date('15-SEP-97','DD-MON-RR'),3,17.55,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10662,48,3,to_date('09-SEP-97','DD-MON-RR'),to_date('07-OCT-97','DD-MON-RR'),to_date('18-SEP-97','DD-MON-RR'),2,1.28,'Lonesome Pine Restaurant','89 Chiaroscuro Rd.','Portland','OR','97219','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10663,9,2,to_date('10-SEP-97','DD-MON-RR'),to_date('24-SEP-97','DD-MON-RR'),to_date('03-OCT-97','DD-MON-RR'),2,113.15,'Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10664,28,1,to_date('10-SEP-97','DD-MON-RR'),to_date('08-OCT-97','DD-MON-RR'),to_date('19-SEP-97','DD-MON-RR'),3,1.27,'Furia Bacalhau e Frutos do Mar','Jardim das rosas n. 32','Lisboa',null,'1675','Portugal');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10665,48,1,to_date('11-SEP-97','DD-MON-RR'),to_date('09-OCT-97','DD-MON-RR'),to_date('17-SEP-97','DD-MON-RR'),2,26.31,'Lonesome Pine Restaurant','89 Chiaroscuro Rd.','Portland','OR','97219','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10666,68,7,to_date('12-SEP-97','DD-MON-RR'),to_date('10-OCT-97','DD-MON-RR'),to_date('22-SEP-97','DD-MON-RR'),2,232.42,'Richter Supermarkt','Starenweg 5','Gen?ve',null,'1204','Switzerland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10667,20,7,to_date('12-SEP-97','DD-MON-RR'),to_date('10-OCT-97','DD-MON-RR'),to_date('19-SEP-97','DD-MON-RR'),1,78.09,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10668,86,1,to_date('15-SEP-97','DD-MON-RR'),to_date('13-OCT-97','DD-MON-RR'),to_date('23-SEP-97','DD-MON-RR'),2,47.22,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',null,'70563','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10669,73,2,to_date('15-SEP-97','DD-MON-RR'),to_date('13-OCT-97','DD-MON-RR'),to_date('22-SEP-97','DD-MON-RR'),1,24.39,'Simons bistro','Vinb?ltet 34','K?benhavn',null,'1734','Denmark');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10670,25,4,to_date('16-SEP-97','DD-MON-RR'),to_date('14-OCT-97','DD-MON-RR'),to_date('18-SEP-97','DD-MON-RR'),1,203.48,'Frankenversand','Berliner Platz 43','M?nchen',null,'80805','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10671,26,1,to_date('17-SEP-97','DD-MON-RR'),to_date('15-OCT-97','DD-MON-RR'),to_date('24-SEP-97','DD-MON-RR'),1,30.34,'France restauration','54, rue Royale','Nantes',null,'44000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10672,5,9,to_date('17-SEP-97','DD-MON-RR'),to_date('01-OCT-97','DD-MON-RR'),to_date('26-SEP-97','DD-MON-RR'),2,95.75,'Berglunds snabbk?p','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10673,90,2,to_date('18-SEP-97','DD-MON-RR'),to_date('16-OCT-97','DD-MON-RR'),to_date('19-SEP-97','DD-MON-RR'),1,22.76,'Wilman Kala','Keskuskatu 45','Helsinki',null,'21240','Finland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10674,38,4,to_date('18-SEP-97','DD-MON-RR'),to_date('16-OCT-97','DD-MON-RR'),to_date('30-SEP-97','DD-MON-RR'),2,0.9,'Island Trading','Garden House
Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10675,25,5,to_date('19-SEP-97','DD-MON-RR'),to_date('17-OCT-97','DD-MON-RR'),to_date('23-SEP-97','DD-MON-RR'),2,31.85,'Frankenversand','Berliner Platz 43','M?nchen',null,'80805','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10676,80,2,to_date('22-SEP-97','DD-MON-RR'),to_date('20-OCT-97','DD-MON-RR'),to_date('29-SEP-97','DD-MON-RR'),2,2.01,'Tortuga Restaurante','Avda. Azteca 123','M?xico D.F.',null,'05033','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10677,3,1,to_date('22-SEP-97','DD-MON-RR'),to_date('20-OCT-97','DD-MON-RR'),to_date('26-SEP-97','DD-MON-RR'),3,4.03,'Antonio Moreno Taquer?a','Mataderos  2312','M?xico D.F.',null,'05023','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10678,71,7,to_date('23-SEP-97','DD-MON-RR'),to_date('21-OCT-97','DD-MON-RR'),to_date('16-OCT-97','DD-MON-RR'),3,388.98,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10679,7,8,to_date('23-SEP-97','DD-MON-RR'),to_date('21-OCT-97','DD-MON-RR'),to_date('30-SEP-97','DD-MON-RR'),3,27.94,'Blondel p?re et fils','24, place Kl?ber','Strasbourg',null,'67000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10680,55,1,to_date('24-SEP-97','DD-MON-RR'),to_date('22-OCT-97','DD-MON-RR'),to_date('26-SEP-97','DD-MON-RR'),1,26.61,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10681,32,3,to_date('25-SEP-97','DD-MON-RR'),to_date('23-OCT-97','DD-MON-RR'),to_date('30-SEP-97','DD-MON-RR'),3,76.13,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10682,3,3,to_date('25-SEP-97','DD-MON-RR'),to_date('23-OCT-97','DD-MON-RR'),to_date('01-OCT-97','DD-MON-RR'),2,36.13,'Antonio Moreno Taquer?a','Mataderos  2312','M?xico D.F.',null,'05023','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10683,18,2,to_date('26-SEP-97','DD-MON-RR'),to_date('24-OCT-97','DD-MON-RR'),to_date('01-OCT-97','DD-MON-RR'),1,4.4,'Du monde entier','67, rue des Cinquante Otages','Nantes',null,'44000','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10684,56,3,to_date('26-SEP-97','DD-MON-RR'),to_date('24-OCT-97','DD-MON-RR'),to_date('30-SEP-97','DD-MON-RR'),1,145.63,'Ottilies K?seladen','Mehrheimerstr. 369','K?ln',null,'50739','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10685,31,4,to_date('29-SEP-97','DD-MON-RR'),to_date('13-OCT-97','DD-MON-RR'),to_date('03-OCT-97','DD-MON-RR'),2,33.75,'Gourmet Lanchonetes','Av. Brasil, 442','Campinas','SP','04876-786','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10686,59,2,to_date('30-SEP-97','DD-MON-RR'),to_date('28-OCT-97','DD-MON-RR'),to_date('08-OCT-97','DD-MON-RR'),1,96.5,'Piccolo und mehr','Geislweg 14','Salzburg',null,'5020','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10687,37,9,to_date('30-SEP-97','DD-MON-RR'),to_date('28-OCT-97','DD-MON-RR'),to_date('30-OCT-97','DD-MON-RR'),2,296.43,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10688,83,4,to_date('01-OCT-97','DD-MON-RR'),to_date('15-OCT-97','DD-MON-RR'),to_date('07-OCT-97','DD-MON-RR'),2,299.09,'Vaffeljernet','Smagsl?get 45','?rhus',null,'8200','Denmark');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10689,5,1,to_date('01-OCT-97','DD-MON-RR'),to_date('29-OCT-97','DD-MON-RR'),to_date('07-OCT-97','DD-MON-RR'),2,13.42,'Berglunds snabbk?p','Berguvsv?gen  8','Lule?',null,'S-958 22','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10690,34,1,to_date('02-OCT-97','DD-MON-RR'),to_date('30-OCT-97','DD-MON-RR'),to_date('03-OCT-97','DD-MON-RR'),1,15.8,'Hanari Carnes','Rua do Pa?o, 67','Rio de Janeiro','RJ','05454-876','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11072,20,4,to_date('05-MAY-98','DD-MON-RR'),to_date('02-JUN-98','DD-MON-RR'),null,2,258.64,'Ernst Handel','Kirchgasse 6','Graz',null,'8010','Austria');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11073,58,2,to_date('05-MAY-98','DD-MON-RR'),to_date('02-JUN-98','DD-MON-RR'),null,2,24.95,'Pericles Comidas cl?sicas','Calle Dr. Jorge Cash 321','M?xico D.F.',null,'05033','Mexico');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11074,73,7,to_date('06-MAY-98','DD-MON-RR'),to_date('03-JUN-98','DD-MON-RR'),null,2,18.44,'Simons bistro','Vinb?ltet 34','K?benhavn',null,'1734','Denmark');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11075,68,8,to_date('06-MAY-98','DD-MON-RR'),to_date('03-JUN-98','DD-MON-RR'),null,2,6.19,'Richter Supermarkt','Starenweg 5','Gen?ve',null,'1204','Switzerland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11076,9,4,to_date('06-MAY-98','DD-MON-RR'),to_date('03-JUN-98','DD-MON-RR'),null,2,38.28,'Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (11077,65,1,to_date('06-MAY-98','DD-MON-RR'),to_date('03-JUN-98','DD-MON-RR'),null,2,8.53,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10700,71,3,to_date('10-OCT-97','DD-MON-RR'),to_date('07-NOV-97','DD-MON-RR'),to_date('16-OCT-97','DD-MON-RR'),1,65.1,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10701,37,6,to_date('13-OCT-97','DD-MON-RR'),to_date('27-OCT-97','DD-MON-RR'),to_date('15-OCT-97','DD-MON-RR'),3,220.31,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10702,1,4,to_date('13-OCT-97','DD-MON-RR'),to_date('24-NOV-97','DD-MON-RR'),to_date('21-OCT-97','DD-MON-RR'),1,23.94,'Alfreds Futterkiste','Obere Str. 57','Berlin',null,'12209','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10703,24,6,to_date('14-OCT-97','DD-MON-RR'),to_date('11-NOV-97','DD-MON-RR'),to_date('20-OCT-97','DD-MON-RR'),2,152.3,'Folk och f? HB','?kergatan 24','Br?cke',null,'S-844 67','Sweden');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10704,62,6,to_date('14-OCT-97','DD-MON-RR'),to_date('11-NOV-97','DD-MON-RR'),to_date('07-NOV-97','DD-MON-RR'),1,4.78,'Queen Cozinha','Alameda dos Can?rios, 891','S?o Paulo','SP','05487-020','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10705,35,9,to_date('15-OCT-97','DD-MON-RR'),to_date('12-NOV-97','DD-MON-RR'),to_date('18-NOV-97','DD-MON-RR'),2,3.52,'HILARI?N-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Crist?bal','T?chira','5022','Venezuela');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10706,55,8,to_date('16-OCT-97','DD-MON-RR'),to_date('13-NOV-97','DD-MON-RR'),to_date('21-OCT-97','DD-MON-RR'),3,135.63,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10707,4,4,to_date('16-OCT-97','DD-MON-RR'),to_date('30-OCT-97','DD-MON-RR'),to_date('23-OCT-97','DD-MON-RR'),3,21.74,'Around the Horn','Brook Farm
Stratford St. Mary','Colchester','Essex','CO7 6JX','UK');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10708,77,6,to_date('17-OCT-97','DD-MON-RR'),to_date('28-NOV-97','DD-MON-RR'),to_date('05-NOV-97','DD-MON-RR'),2,2.96,'The Big Cheese','89 Jefferson Way
Suite 2','Portland','OR','97201','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10709,31,1,to_date('17-OCT-97','DD-MON-RR'),to_date('14-NOV-97','DD-MON-RR'),to_date('20-NOV-97','DD-MON-RR'),3,210.8,'Gourmet Lanchonetes','Av. Brasil, 442','Campinas','SP','04876-786','Brazil');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10710,27,1,to_date('20-OCT-97','DD-MON-RR'),to_date('17-NOV-97','DD-MON-RR'),to_date('23-OCT-97','DD-MON-RR'),1,4.98,'Franchi S.p.A.','Via Monte Bianco 34','Torino',null,'10100','Italy');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10711,71,5,to_date('21-OCT-97','DD-MON-RR'),to_date('02-DEC-97','DD-MON-RR'),to_date('29-OCT-97','DD-MON-RR'),2,52.41,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10712,37,3,to_date('21-OCT-97','DD-MON-RR'),to_date('18-NOV-97','DD-MON-RR'),to_date('31-OCT-97','DD-MON-RR'),1,89.93,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',null,'Ireland');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10713,71,1,to_date('22-OCT-97','DD-MON-RR'),to_date('19-NOV-97','DD-MON-RR'),to_date('24-OCT-97','DD-MON-RR'),1,167.05,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10714,71,5,to_date('22-OCT-97','DD-MON-RR'),to_date('19-NOV-97','DD-MON-RR'),to_date('27-OCT-97','DD-MON-RR'),3,24.49,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10715,9,3,to_date('23-OCT-97','DD-MON-RR'),to_date('06-NOV-97','DD-MON-RR'),to_date('29-OCT-97','DD-MON-RR'),1,63.2,'Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10716,64,4,to_date('24-OCT-97','DD-MON-RR'),to_date('21-NOV-97','DD-MON-RR'),to_date('27-OCT-97','DD-MON-RR'),2,22.57,'Rancho grande','Av. del Libertador 900','Buenos Aires',null,'1010','Argentina');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10717,25,1,to_date('24-OCT-97','DD-MON-RR'),to_date('21-NOV-97','DD-MON-RR'),to_date('29-OCT-97','DD-MON-RR'),2,59.25,'Frankenversand','Berliner Platz 43','M?nchen',null,'80805','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10718,39,1,to_date('27-OCT-97','DD-MON-RR'),to_date('24-NOV-97','DD-MON-RR'),to_date('29-OCT-97','DD-MON-RR'),3,170.88,'K?niglich Essen','Maubelstr. 90','Brandenburg',null,'14776','Germany');
Insert into ORDERS (ORDER_ID,CUSTOMER_ID,EMPLOYEE_ID,ORDER_DATE,REQUIRED_DATE,SHIPPED_DATE,SHIP_VIA,FREIGHT,SHIP_NAME,SHIP_ADDRESS,SHIP_CITY,SHIP_REGION,SHIP_POSTAL_CODE,SHIP_COUNTRY) values (10719,45,8,to_date('27-OCT-97','DD-MON-RR'),to_date('24-NOV-97','DD-MON-RR'),to_date('05-NOV-97','DD-MON-RR'),2,51.44,'Let''s Stop N Shop','87 Polk St.
Suite 5','San Francisco','CA','94117','USA');
-- INSERTING into ORDER_DETAILS
-- 
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10837,40,18.4,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10837,47,9.5,40,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10837,76,18,21,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10838,1,18,4,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10838,18,62.5,25,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10838,36,19,50,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10839,58,13.25,30,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10839,72,34.8,15,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10840,25,14,6,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10840,39,18,10,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10841,10,31,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10841,56,38,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10841,59,55,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10841,77,13,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10842,11,21,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10842,43,46,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10842,68,12.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10842,70,15,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10843,51,53,4,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10844,22,21,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10845,23,9,70,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10845,35,18,25,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10845,42,14,42,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10845,58,13.25,60,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10845,64,33.25,48,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10846,4,22,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10846,70,15,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10846,74,10,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10847,1,18,80,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10847,19,9.2,12,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10847,37,26,60,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10847,45,9.5,36,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10847,60,34,45,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10847,71,21.5,55,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10848,5,21.35,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10848,9,97,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10849,3,10,49,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10849,26,31.23,18,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10850,25,14,20,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10850,33,2.5,4,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10850,70,15,30,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10851,2,19,5,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10851,25,14,10,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10851,57,19.5,10,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10851,59,55,42,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10852,2,19,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10852,17,39,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10852,62,49.3,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10853,18,62.5,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10854,10,31,100,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10854,13,6,65,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10855,16,17.45,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10855,31,12.5,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10855,56,38,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10855,65,21.05,15,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10856,2,19,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10856,42,14,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10857,3,10,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10857,26,31.23,35,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10857,29,123.79,10,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10858,7,30,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10858,27,43.9,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10858,70,15,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10859,24,4.5,40,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10859,54,7.45,35,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10859,64,33.25,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10860,51,53,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10860,76,18,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10861,17,39,42,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10861,18,62.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10861,21,10,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10861,33,2.5,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10861,62,49.3,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10862,11,21,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10862,52,7,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10863,1,18,20,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10863,58,13.25,12,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10864,35,18,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10864,67,14,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10865,38,263.5,60,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10865,39,18,80,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10866,2,19,21,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10866,24,4.5,6,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10866,30,25.89,40,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10867,53,32.8,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10868,26,31.23,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10868,35,18,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10868,49,20,42,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10869,1,18,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10869,11,21,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10869,23,9,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10869,68,12.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10870,35,18,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10870,51,53,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10871,6,25,50,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10871,16,17.45,12,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10871,17,39,16,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10872,55,24,10,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10872,62,49.3,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10872,64,33.25,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10872,65,21.05,21,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10873,21,10,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10873,28,45.6,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10874,10,31,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10875,19,9.2,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10875,47,9.5,21,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10875,49,20,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10876,46,12,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10876,64,33.25,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10877,16,17.45,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10877,18,62.5,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10878,20,81,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10879,40,18.4,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10879,65,21.05,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10879,76,18,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10880,23,9,30,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10880,61,28.5,30,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10880,70,15,50,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10881,73,15,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10882,42,14,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10882,49,20,20,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10882,54,7.45,32,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10883,24,4.5,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10884,21,10,40,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10884,56,38,21,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10884,65,21.05,12,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10885,2,19,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10885,24,4.5,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10885,70,15,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10885,77,13,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10886,10,31,70,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10886,31,12.5,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10886,77,13,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10887,25,14,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10888,2,19,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10888,68,12.5,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10889,11,21,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10889,38,263.5,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10890,17,39,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10890,34,14,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10890,41,9.65,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10891,30,25.89,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10892,59,55,40,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10893,8,40,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10893,24,4.5,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10893,29,123.79,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10893,30,25.89,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10893,36,19,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10894,13,6,28,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10894,69,36,50,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10894,75,7.75,120,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10895,24,4.5,110,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10895,39,18,45,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10895,40,18.4,91,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10895,60,34,100,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10896,45,9.5,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10896,56,38,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10897,29,123.79,80,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10897,30,25.89,36,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10898,13,6,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10899,39,18,8,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10900,70,15,3,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10901,41,9.65,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10901,71,21.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10902,55,24,30,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10902,62,49.3,6,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10903,13,6,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10903,65,21.05,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10903,68,12.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10904,58,13.25,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10904,62,49.3,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10905,1,18,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10906,61,28.5,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10907,75,7.75,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10908,7,30,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10908,52,7,14,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10909,7,30,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10909,16,17.45,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10909,41,9.65,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10910,19,9.2,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10910,49,20,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10910,61,28.5,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10911,1,18,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10911,17,39,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10911,67,14,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10912,11,21,40,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10912,29,123.79,60,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10913,4,22,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10913,33,2.5,40,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10913,58,13.25,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10914,71,21.5,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10915,17,39,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10915,33,2.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10915,54,7.45,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10916,16,17.45,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10916,32,32,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10916,57,19.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10917,30,25.89,1,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10917,60,34,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10918,1,18,60,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10918,60,34,25,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10919,16,17.45,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10919,25,14,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10919,40,18.4,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10920,50,16.25,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10921,35,18,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10921,63,43.9,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10922,17,39,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10922,24,4.5,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10923,42,14,10,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10923,43,46,10,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10923,67,14,24,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10924,10,31,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10924,28,45.6,30,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10924,75,7.75,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10925,36,19,25,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10925,52,7,12,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10926,11,21,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10926,13,6,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10926,19,9.2,7,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10926,72,34.8,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10927,20,81,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10566,76,18,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10567,31,12.5,60,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10567,51,53,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10567,59,55,40,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10568,10,31,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10569,31,12.5,35,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10569,76,18,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10570,11,21,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10570,56,38,60,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10571,14,23.25,11,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10571,42,14,28,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10572,16,17.45,12,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10572,32,32,10,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10572,40,18.4,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10572,75,7.75,15,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10573,17,39,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10573,34,14,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10573,53,32.8,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10574,33,2.5,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10574,40,18.4,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10574,62,49.3,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10574,64,33.25,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10575,59,55,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10575,63,43.9,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10575,72,34.8,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10575,76,18,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10576,1,18,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10576,31,12.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10576,44,19.45,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10577,39,18,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10577,75,7.75,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10577,77,13,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10578,35,18,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10578,57,19.5,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10579,15,15.5,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10579,75,7.75,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10580,14,23.25,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10580,41,9.65,9,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10580,65,21.05,30,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10581,75,7.75,50,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10582,57,19.5,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10582,76,18,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10583,29,123.79,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10583,60,34,24,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10583,69,36,10,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10584,31,12.5,50,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10585,47,9.5,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10586,52,7,4,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10587,26,31.23,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10587,35,18,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10587,77,13,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10588,18,62.5,40,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10588,42,14,100,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10589,35,18,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10590,1,18,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10590,77,13,60,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10591,3,10,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10591,7,30,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10591,54,7.45,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10592,15,15.5,25,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10592,26,31.23,5,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10593,20,81,21,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10593,69,36,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10593,76,18,4,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10594,52,7,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10594,58,13.25,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10595,35,18,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10595,61,28.5,120,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10595,69,36,65,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10596,56,38,5,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10596,63,43.9,24,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10596,75,7.75,30,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10597,24,4.5,35,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10597,57,19.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10597,65,21.05,12,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10598,27,43.9,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10598,71,21.5,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10599,62,49.3,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10600,54,7.45,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10600,73,15,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10601,13,6,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10601,59,55,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10602,77,13,5,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10603,22,21,48,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10603,49,20,25,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10604,48,12.75,6,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10604,76,18,10,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10605,16,17.45,30,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10605,59,55,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10605,60,34,70,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10605,71,21.5,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10606,4,22,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10606,55,24,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10606,62,49.3,10,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10607,7,30,45,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10607,17,39,100,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10607,33,2.5,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10607,40,18.4,42,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10607,72,34.8,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10608,56,38,28,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10609,1,18,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10609,10,31,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10609,21,10,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10610,36,19,21,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10611,1,18,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10611,2,19,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10611,60,34,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10612,10,31,70,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10612,36,19,55,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10612,49,20,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10612,60,34,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10612,76,18,80,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10613,13,6,8,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10613,75,7.75,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10614,11,21,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10614,21,10,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10614,39,18,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10615,55,24,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10616,38,263.5,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10616,56,38,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10616,70,15,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10616,71,21.5,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10617,59,55,30,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10618,6,25,70,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10618,56,38,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10618,68,12.5,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10619,21,10,42,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10619,22,21,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10620,24,4.5,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10620,52,7,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10621,19,9.2,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10621,23,9,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10621,70,15,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10621,71,21.5,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10622,2,19,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10622,68,12.5,18,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10623,14,23.25,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10623,19,9.2,15,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10623,21,10,25,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10623,24,4.5,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10623,35,18,30,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10624,28,45.6,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10624,29,123.79,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10624,44,19.45,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10625,14,23.25,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10625,42,14,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10625,60,34,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10626,53,32.8,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10626,60,34,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10626,71,21.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10627,62,49.3,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10627,73,15,35,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10628,1,18,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10629,29,123.79,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10629,64,33.25,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10630,55,24,12,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10630,76,18,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10631,75,7.75,8,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10632,2,19,30,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10632,33,2.5,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10633,12,38,36,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10633,13,6,13,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10633,26,31.23,35,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10633,62,49.3,80,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10634,7,30,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10634,18,62.5,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10634,51,53,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10634,75,7.75,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10635,4,22,10,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10635,5,21.35,15,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10635,22,21,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10636,4,22,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10636,58,13.25,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10637,11,21,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10637,50,16.25,25,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10637,56,38,60,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10638,45,9.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10638,65,21.05,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10638,72,34.8,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10639,18,62.5,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10640,69,36,20,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10640,70,15,15,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10641,2,19,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10641,40,18.4,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10642,21,10,30,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10642,61,28.5,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10643,28,45.6,15,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10643,39,18,21,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10643,46,12,2,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10644,18,62.5,4,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10644,43,46,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10644,46,12,21,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10645,18,62.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10645,36,19,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10646,1,18,15,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10646,10,31,18,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10646,71,21.5,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10646,77,13,35,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10647,19,9.2,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10647,39,18,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10648,22,21,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10648,24,4.5,15,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10649,28,45.6,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10649,72,34.8,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10650,30,25.89,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10650,53,32.8,25,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10650,54,7.45,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10651,19,9.2,12,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10651,22,21,20,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10652,30,25.89,2,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10652,42,14,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10653,16,17.45,30,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10653,60,34,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10654,4,22,12,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10654,39,18,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10654,54,7.45,6,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10655,41,9.65,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10656,14,23.25,3,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10656,44,19.45,28,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10656,47,9.5,6,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10657,15,15.5,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10657,41,9.65,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10657,46,12,45,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10657,47,9.5,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10657,56,38,45,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10657,60,34,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10658,21,10,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10658,40,18.4,70,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10658,60,34,55,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10658,77,13,70,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10659,31,12.5,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10659,40,18.4,24,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10659,70,15,40,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10660,20,81,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10661,39,18,3,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10661,58,13.25,49,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10662,68,12.5,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10663,40,18.4,30,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10663,42,14,30,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10663,51,53,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10664,10,31,24,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10664,56,38,12,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10664,65,21.05,15,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10665,51,53,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10665,59,55,1,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10665,76,18,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10666,29,123.79,36,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10666,65,21.05,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10667,69,36,45,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10667,71,21.5,14,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10668,31,12.5,8,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10668,55,24,4,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10668,64,33.25,15,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10669,36,19,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10670,23,9,32,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10670,46,12,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10670,67,14,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10670,73,15,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10670,75,7.75,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10671,16,17.45,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10671,62,49.3,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10671,65,21.05,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10672,38,263.5,15,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10672,71,21.5,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10673,16,17.45,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10673,42,14,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10673,43,46,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10674,23,9,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10675,14,23.25,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10675,53,32.8,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10675,58,13.25,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10676,10,31,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10676,19,9.2,7,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10676,44,19.45,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10677,26,31.23,30,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10677,33,2.5,8,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10678,12,38,100,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10678,33,2.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10678,41,9.65,120,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10678,54,7.45,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10679,59,55,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10680,16,17.45,50,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10680,31,12.5,20,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10680,42,14,40,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10681,19,9.2,30,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10681,21,10,12,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10681,64,33.25,28,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10682,33,2.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10682,66,17,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10682,75,7.75,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10683,52,7,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10684,40,18.4,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10684,47,9.5,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10684,60,34,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10685,10,31,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10685,41,9.65,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10685,47,9.5,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10686,17,39,30,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10686,26,31.23,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10687,9,97,50,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10687,29,123.79,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10687,36,19,6,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10688,10,31,18,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11052,61,28.5,10,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11053,18,62.5,35,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11053,32,32,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11053,64,33.25,25,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11054,33,2.5,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11054,67,14,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11055,24,4.5,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11055,25,14,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11055,51,53,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11055,57,19.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11056,7,30,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11056,55,24,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11056,60,34,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11057,70,15,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11058,21,10,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11058,60,34,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11058,61,28.5,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11059,13,6,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11059,17,39,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11059,60,34,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11060,60,34,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11060,77,13,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11061,60,34,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11062,53,32.8,10,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11062,70,15,12,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11063,34,14,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11063,40,18.4,40,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11063,41,9.65,30,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11064,17,39,77,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11064,41,9.65,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11064,53,32.8,25,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11064,55,24,4,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11064,68,12.5,55,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11065,30,25.89,4,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11065,54,7.45,20,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11066,16,17.45,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11066,19,9.2,42,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11066,34,14,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11067,41,9.65,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11068,28,45.6,8,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11068,43,46,36,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11068,77,13,28,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11069,39,18,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11070,1,18,40,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11070,2,19,20,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11070,16,17.45,30,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11070,31,12.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11071,7,30,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11071,13,6,10,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11072,2,19,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11072,41,9.65,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11072,50,16.25,22,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11072,64,33.25,130,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11073,11,21,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11073,24,4.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11074,16,17.45,14,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11075,2,19,10,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11075,46,12,30,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11075,76,18,2,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11076,6,25,20,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11076,14,23.25,20,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11076,19,9.2,10,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,2,19,24,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,3,10,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,4,22,1,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,6,25,1,0.02);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,7,30,1,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,8,40,2,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,10,31,1,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,12,38,2,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,13,6,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,14,23.25,1,0.03);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,16,17.45,2,0.03);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,20,81,1,0.04);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,23,9,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,32,32,1,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,39,18,2,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,41,9.65,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,46,12,3,0.02);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,52,7,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,55,24,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,60,34,2,0.06);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,64,33.25,2,0.03);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,66,17,1,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,73,15,2,0.01);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,75,7.75,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11077,77,13,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10726,11,21,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10727,17,39,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10727,56,38,10,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10727,59,55,10,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10728,30,25.89,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10728,40,18.4,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10728,55,24,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10728,60,34,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10729,1,18,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10729,21,10,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10729,50,16.25,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10730,16,17.45,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10730,31,12.5,3,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10730,65,21.05,10,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10731,21,10,40,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10731,51,53,30,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10732,76,18,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10733,14,23.25,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10733,28,45.6,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10733,52,7,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10734,6,25,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10734,30,25.89,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10734,76,18,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10735,61,28.5,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10735,77,13,2,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10736,65,21.05,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10736,75,7.75,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10737,13,6,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10737,41,9.65,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10738,16,17.45,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10739,36,19,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10739,52,7,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10740,28,45.6,5,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10740,35,18,35,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10740,45,9.5,40,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10740,56,38,14,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10741,2,19,15,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10742,3,10,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10742,60,34,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10742,72,34.8,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10743,46,12,28,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10744,40,18.4,50,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10745,18,62.5,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10745,44,19.45,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10745,59,55,45,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10745,72,34.8,7,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10746,13,6,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10746,42,14,28,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10746,62,49.3,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10746,69,36,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10747,31,12.5,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10248,11,14,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10248,42,9.8,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10248,72,34.8,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10249,14,18.6,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10249,51,42.4,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10250,41,7.7,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10250,51,42.4,35,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10250,65,16.8,15,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10251,22,16.8,6,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10251,57,15.6,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10251,65,16.8,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10252,20,64.8,40,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10252,33,2,25,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10252,60,27.2,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10253,31,10,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10253,39,14.4,42,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10253,49,16,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10254,24,3.6,15,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10254,55,19.2,21,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10254,74,8,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10255,2,15.2,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10255,16,13.9,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10255,36,15.2,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10255,59,44,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10256,53,26.2,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10256,77,10.4,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10257,27,35.1,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10257,39,14.4,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10257,77,10.4,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10258,2,15.2,50,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10258,5,17,65,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10258,32,25.6,6,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10259,21,8,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10259,37,20.8,1,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10260,41,7.7,16,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10260,57,15.6,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10260,62,39.4,15,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10260,70,12,21,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10261,21,8,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10261,35,14.4,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10262,5,17,12,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10262,7,24,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10262,56,30.4,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10263,16,13.9,60,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10263,24,3.6,28,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10263,30,20.7,60,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10263,74,8,36,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10264,2,15.2,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10264,41,7.7,25,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10265,17,31.2,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10265,70,12,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10266,12,30.4,12,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10267,40,14.7,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10267,59,44,70,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10267,76,14.4,15,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10268,29,99,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10268,72,27.8,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10269,33,2,60,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10269,72,27.8,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10270,36,15.2,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10270,43,36.8,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10271,33,2,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10272,20,64.8,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10272,31,10,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10272,72,27.8,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10273,10,24.8,24,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10273,31,10,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10273,33,2,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10273,40,14.7,60,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10273,76,14.4,33,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10274,71,17.2,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10274,72,27.8,7,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10275,24,3.6,12,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10275,59,44,6,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10276,10,24.8,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10276,13,4.8,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10277,28,36.4,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10277,62,39.4,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10278,44,15.5,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10278,59,44,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10278,63,35.1,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10278,73,12,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10279,17,31.2,15,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10280,24,3.6,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10280,55,19.2,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10280,75,6.2,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10281,19,7.3,1,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10281,24,3.6,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10281,35,14.4,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10282,30,20.7,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10282,57,15.6,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10283,15,12.4,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10283,19,7.3,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10283,60,27.2,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10283,72,27.8,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10284,27,35.1,15,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10284,44,15.5,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10284,60,27.2,20,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10284,67,11.2,5,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10285,1,14.4,45,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10285,40,14.7,40,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10285,53,26.2,36,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10286,35,14.4,100,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10286,62,39.4,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10287,16,13.9,40,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10287,34,11.2,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10287,46,9.6,15,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10288,54,5.9,10,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10288,68,10,3,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10289,3,8,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10289,64,26.6,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10290,5,17,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10290,29,99,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10290,49,16,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10290,77,10.4,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10291,13,4.8,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10291,44,15.5,24,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10291,51,42.4,2,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10292,20,64.8,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10293,18,50,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10293,24,3.6,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10293,63,35.1,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10293,75,6.2,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10294,1,14.4,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10294,17,31.2,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10294,43,36.8,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10294,60,27.2,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10294,75,6.2,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10295,56,30.4,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10296,11,16.8,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10296,16,13.9,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10296,69,28.8,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10297,39,14.4,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10297,72,27.8,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10298,2,15.2,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10298,36,15.2,40,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10298,59,44,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10298,62,39.4,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10299,19,7.3,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10299,70,12,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10300,66,13.6,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10300,68,10,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10301,40,14.7,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10301,56,30.4,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10302,17,31.2,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10302,28,36.4,28,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10302,43,36.8,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10303,40,14.7,40,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10303,65,16.8,30,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10303,68,10,15,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10304,49,16,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10304,59,44,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10304,71,17.2,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10305,18,50,25,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10305,29,99,25,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10305,39,14.4,30,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10306,30,20.7,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10306,53,26.2,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10306,54,5.9,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10307,62,39.4,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10307,68,10,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10308,69,28.8,1,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10308,70,12,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10309,4,17.6,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10309,6,20,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10309,42,11.2,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10309,43,36.8,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10309,71,17.2,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10310,16,13.9,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10310,62,39.4,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10311,42,11.2,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10311,69,28.8,7,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10312,28,36.4,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10312,43,36.8,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10312,53,26.2,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10312,75,6.2,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10313,36,15.2,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10314,32,25.6,40,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10314,58,10.6,30,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10314,62,39.4,25,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10315,34,11.2,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10315,70,12,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10316,41,7.7,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10316,62,39.4,70,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10317,1,14.4,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10318,41,7.7,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10318,76,14.4,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10319,17,31.2,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10319,28,36.4,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10319,76,14.4,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10320,71,17.2,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10321,35,14.4,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10322,52,5.6,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10323,15,12.4,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10323,25,11.2,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10323,39,14.4,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10324,16,13.9,21,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10324,35,14.4,70,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10324,46,9.6,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10324,59,44,40,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10324,63,35.1,80,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10325,6,20,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10325,13,4.8,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10325,14,18.6,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10325,31,10,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10325,72,27.8,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10326,4,17.6,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10326,57,15.6,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10326,75,6.2,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10327,2,15.2,25,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10327,11,16.8,50,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10327,30,20.7,35,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10327,58,10.6,30,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10328,59,44,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10328,65,16.8,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10328,68,10,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10329,19,7.3,10,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10329,30,20.7,8,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10329,38,210.8,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10329,56,30.4,12,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10330,26,24.9,50,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10330,72,27.8,25,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10331,54,5.9,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10332,18,50,40,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10332,42,11.2,10,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10332,47,7.6,16,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10333,14,18.6,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10333,21,8,10,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10333,71,17.2,40,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10334,52,5.6,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10334,68,10,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10335,2,15.2,7,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10335,31,10,25,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10335,32,25.6,6,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10335,51,42.4,48,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10336,4,17.6,18,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10337,23,7.2,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10337,26,24.9,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10337,36,15.2,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10337,37,20.8,28,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10337,72,27.8,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10338,17,31.2,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10338,30,20.7,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10339,4,17.6,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10339,17,31.2,70,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10339,62,39.4,28,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10340,18,50,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10340,41,7.7,12,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10340,43,36.8,40,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10341,33,2,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10341,59,44,9,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10342,2,15.2,24,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10342,31,10,56,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10439,12,30.4,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10439,16,13.9,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10439,64,26.6,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10439,74,8,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10440,2,15.2,45,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10440,16,13.9,49,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10440,29,99,24,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10440,61,22.8,90,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10441,27,35.1,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10442,11,16.8,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10442,54,5.9,80,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10442,66,13.6,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10443,11,16.8,6,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10443,28,36.4,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10444,17,31.2,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10444,26,24.9,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10444,35,14.4,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10444,41,7.7,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10445,39,14.4,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10445,54,5.9,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10446,19,7.3,12,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10446,24,3.6,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10446,31,10,3,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10446,52,5.6,15,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10447,19,7.3,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10447,65,16.8,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10447,71,17.2,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10448,26,24.9,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10448,40,14.7,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10449,10,24.8,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10449,52,5.6,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10449,62,39.4,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10450,10,24.8,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10450,54,5.9,6,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10451,55,19.2,120,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10451,64,26.6,35,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10451,65,16.8,28,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10451,77,10.4,55,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10452,28,36.4,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10452,44,15.5,100,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10453,48,10.2,15,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10453,70,12,25,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10454,16,13.9,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10454,33,2,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10454,46,9.6,10,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10455,39,14.4,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10455,53,26.2,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10455,61,22.8,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10455,71,17.2,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10456,21,8,40,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10456,49,16,21,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10457,59,44,36,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10458,26,24.9,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10458,28,36.4,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10458,43,36.8,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10458,56,30.4,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10458,71,17.2,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10459,7,24,16,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10459,46,9.6,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10459,72,27.8,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10460,68,10,21,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10460,75,6.2,4,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10461,21,8,40,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10461,30,20.7,28,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10461,55,19.2,60,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10462,13,4.8,1,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10462,23,7.2,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10463,19,7.3,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10463,42,11.2,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10464,4,17.6,16,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10464,43,36.8,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10464,56,30.4,30,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10464,60,27.2,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10465,24,3.6,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10465,29,99,18,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10465,40,14.7,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10465,45,7.6,30,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10465,50,13,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10466,11,16.8,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10466,46,9.6,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10467,24,3.6,28,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10467,25,11.2,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10468,30,20.7,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10468,43,36.8,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10469,2,15.2,40,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10469,16,13.9,35,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10469,44,15.5,2,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10470,18,50,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10470,23,7.2,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10470,64,26.6,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10471,7,24,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10471,56,30.4,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10472,24,3.6,80,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10472,51,42.4,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10473,33,2,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10473,71,17.2,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10474,14,18.6,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10474,28,36.4,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10474,40,14.7,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10474,75,6.2,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10475,31,10,35,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10475,66,13.6,60,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10475,76,14.4,42,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10476,55,19.2,2,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10476,70,12,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10477,1,14.4,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10477,21,8,21,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10477,39,14.4,20,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10478,10,24.8,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10479,38,210.8,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10479,53,26.2,28,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10479,59,44,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10479,64,26.6,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10480,47,7.6,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10480,59,44,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10481,49,16,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10481,60,27.2,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10482,40,14.7,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10483,34,11.2,35,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10483,77,10.4,30,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10484,21,8,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10484,40,14.7,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10484,51,42.4,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10485,2,15.2,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10485,3,8,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10485,55,19.2,30,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10485,70,12,60,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10486,11,16.8,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10486,51,42.4,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10486,74,8,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10487,19,7.3,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10487,26,24.9,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10487,54,5.9,24,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10488,59,44,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10488,73,12,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10489,11,16.8,15,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10489,16,13.9,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10490,59,44,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10490,68,10,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10490,75,6.2,36,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10491,44,15.5,15,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10491,77,10.4,7,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10492,25,11.2,60,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10492,42,11.2,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10493,65,16.8,15,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10493,66,13.6,10,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10493,69,28.8,10,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10494,56,30.4,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10495,23,7.2,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10495,41,7.7,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10495,77,10.4,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10496,31,10,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10497,56,30.4,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10497,72,27.8,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10497,77,10.4,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10498,24,4.5,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10498,40,18.4,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10498,42,14,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10499,28,45.6,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10499,49,20,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10500,15,15.5,12,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10500,28,45.6,8,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10501,54,7.45,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10502,45,9.5,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10502,53,32.8,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10502,67,14,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10503,14,23.25,70,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10503,65,21.05,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10504,2,19,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10504,21,10,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10504,53,32.8,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10504,61,28.5,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10505,62,49.3,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10506,25,14,18,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10506,70,15,14,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10507,43,46,15,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10507,48,12.75,15,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10508,13,6,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10508,39,18,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10509,28,45.6,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10510,29,123.79,36,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10510,75,7.75,36,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10511,4,22,50,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10511,7,30,50,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10511,8,40,10,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10512,24,4.5,10,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10512,46,12,9,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10512,47,9.5,6,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10512,60,34,12,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10513,21,10,40,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10513,32,32,50,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10513,61,28.5,15,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10514,20,81,39,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10514,28,45.6,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10514,56,38,70,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10514,65,21.05,39,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10514,75,7.75,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10515,9,97,16,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10515,16,17.45,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10515,27,43.9,120,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10515,33,2.5,16,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10515,60,34,84,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10516,18,62.5,25,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10516,41,9.65,80,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10516,42,14,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10517,52,7,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10517,59,55,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10517,70,15,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10518,24,4.5,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10518,38,263.5,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10518,44,19.45,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10519,10,31,16,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10519,56,38,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10519,60,34,10,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10520,24,4.5,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10520,53,32.8,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10521,35,18,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10521,41,9.65,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10521,68,12.5,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10522,1,18,40,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10522,8,40,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10522,30,25.89,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10522,40,18.4,25,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10523,17,39,25,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10523,20,81,15,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10523,37,26,18,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10523,41,9.65,6,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10524,10,31,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10524,30,25.89,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10524,43,46,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10524,54,7.45,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10525,36,19,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10525,40,18.4,15,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10526,1,18,8,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10526,13,6,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10526,56,38,30,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10527,4,22,50,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10527,36,19,30,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10528,11,21,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10528,33,2.5,8,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10528,72,34.8,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10529,55,24,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10529,68,12.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10529,69,36,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10530,17,39,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10530,43,46,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10530,61,28.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10530,76,18,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10531,59,55,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10532,30,25.89,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10532,66,17,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10533,4,22,50,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10533,72,34.8,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10533,73,15,24,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10534,30,25.89,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10534,40,18.4,10,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10534,54,7.45,10,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10535,11,21,50,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10535,40,18.4,10,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10535,57,19.5,5,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10535,59,55,15,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10536,12,38,15,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10536,31,12.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10536,33,2.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10536,60,34,35,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10537,31,12.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10537,51,53,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10537,58,13.25,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10537,72,34.8,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10537,73,15,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10538,70,15,7,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10538,72,34.8,1,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10539,13,6,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10539,21,10,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10539,33,2.5,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10539,49,20,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10540,3,10,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10540,26,31.23,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10540,38,263.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10540,68,12.5,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10541,24,4.5,35,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10541,38,263.5,4,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10541,65,21.05,36,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10541,71,21.5,9,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10542,11,21,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10542,54,7.45,24,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10543,12,38,30,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10543,23,9,70,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10544,28,45.6,7,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10544,67,14,7,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10545,11,21,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10546,7,30,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10546,35,18,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10546,62,49.3,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10547,32,32,24,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10547,36,19,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10548,34,14,10,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10548,41,9.65,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10549,31,12.5,55,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10549,45,9.5,100,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10549,51,53,48,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10550,17,39,8,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10550,19,9.2,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10550,21,10,6,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10550,61,28.5,10,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10551,16,17.45,40,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10551,35,18,20,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10551,44,19.45,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10552,69,36,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10552,75,7.75,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10553,11,21,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10553,16,17.45,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10553,22,21,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10553,31,12.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10553,35,18,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10554,16,17.45,30,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10554,23,9,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10554,62,49.3,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10554,77,13,10,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10555,14,23.25,30,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10555,19,9.2,35,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10555,24,4.5,18,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10555,51,53,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10555,56,38,40,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10556,72,34.8,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10557,64,33.25,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10557,75,7.75,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10558,47,9.5,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10558,51,53,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10558,52,7,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10558,53,32.8,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10558,73,15,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10559,41,9.65,12,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10559,55,24,18,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10560,30,25.89,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10560,62,49.3,15,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10561,44,19.45,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10561,51,53,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10562,33,2.5,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10562,62,49.3,10,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10563,36,19,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10563,52,7,70,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10564,17,39,16,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10564,31,12.5,6,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10564,55,24,25,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10565,24,4.5,25,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10565,64,33.25,18,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10566,11,21,35,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10566,18,62.5,18,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10688,28,45.6,60,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10688,34,14,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10689,1,18,35,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10690,56,38,20,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10690,77,13,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10691,1,18,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10691,29,123.79,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10691,43,46,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10691,44,19.45,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10691,62,49.3,48,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10692,63,43.9,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10693,9,97,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10693,54,7.45,60,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10693,69,36,30,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10693,73,15,15,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10694,7,30,90,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10694,59,55,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10694,70,15,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10695,8,40,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10695,12,38,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10695,24,4.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10696,17,39,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10696,46,12,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10697,19,9.2,7,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10697,35,18,9,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10697,58,13.25,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10697,70,15,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10698,11,21,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10698,17,39,8,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10698,29,123.79,12,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10698,65,21.05,65,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10698,70,15,8,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10699,47,9.5,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10700,1,18,5,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10700,34,14,12,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10700,68,12.5,40,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10700,71,21.5,60,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10701,59,55,42,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10701,71,21.5,20,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10701,76,18,35,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10702,3,10,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10702,76,18,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10703,2,19,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10703,59,55,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10703,73,15,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10704,4,22,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10704,24,4.5,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10704,48,12.75,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10705,31,12.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10705,32,32,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10706,16,17.45,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10706,43,46,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10706,59,55,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10707,55,24,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10707,57,19.5,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10707,70,15,28,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10708,5,21.35,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10708,36,19,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10709,8,40,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10709,51,53,28,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10709,60,34,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10710,19,9.2,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10710,47,9.5,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10711,19,9.2,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10711,41,9.65,42,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10711,53,32.8,120,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10712,53,32.8,3,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10712,56,38,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10713,10,31,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10713,26,31.23,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10713,45,9.5,110,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10713,46,12,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10714,2,19,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10714,17,39,27,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10714,47,9.5,50,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10714,56,38,18,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10714,58,13.25,12,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10715,10,31,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10715,71,21.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10716,21,10,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10716,51,53,7,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10716,61,28.5,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10717,21,10,32,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10717,54,7.45,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10717,69,36,25,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10718,12,38,36,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10718,16,17.45,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10718,36,19,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10718,62,49.3,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10719,18,62.5,12,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10719,30,25.89,3,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10719,54,7.45,40,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10720,35,18,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10720,71,21.5,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10721,44,19.45,50,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10722,2,19,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10722,31,12.5,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10722,68,12.5,45,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10722,75,7.75,42,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10723,26,31.23,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10724,10,31,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10724,61,28.5,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10725,41,9.65,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10725,52,7,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10725,55,24,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10726,4,22,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10342,36,15.2,40,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10342,55,19.2,40,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10343,64,26.6,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10343,68,10,4,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10343,76,14.4,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10344,4,17.6,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10344,8,32,70,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10345,8,32,70,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10345,19,7.3,80,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10345,42,11.2,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10346,17,31.2,36,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10346,56,30.4,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10347,25,11.2,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10347,39,14.4,50,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10347,40,14.7,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10347,75,6.2,6,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10348,1,14.4,15,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10348,23,7.2,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10349,54,5.9,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10350,50,13,15,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10350,69,28.8,18,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10351,38,210.8,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10351,41,7.7,13,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10351,44,15.5,77,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10351,65,16.8,10,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10352,24,3.6,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10352,54,5.9,20,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10353,11,16.8,12,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10353,38,210.8,50,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10354,1,14.4,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10354,29,99,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10355,24,3.6,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10355,57,15.6,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10356,31,10,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10356,55,19.2,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10356,69,28.8,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10357,10,24.8,30,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10357,26,24.9,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10357,60,27.2,8,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10358,24,3.6,10,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10358,34,11.2,10,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10358,36,15.2,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10359,16,13.9,56,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10359,31,10,70,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10359,60,27.2,80,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10360,28,36.4,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10360,29,99,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10360,38,210.8,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10360,49,16,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10360,54,5.9,28,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10361,39,14.4,54,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10361,60,27.2,55,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10362,25,11.2,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10362,51,42.4,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10362,54,5.9,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10363,31,10,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10363,75,6.2,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10363,76,14.4,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10364,69,28.8,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10364,71,17.2,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10365,11,16.8,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10366,65,16.8,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10366,77,10.4,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10367,34,11.2,36,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10367,54,5.9,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10367,65,16.8,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10367,77,10.4,7,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10368,21,8,5,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10368,28,36.4,13,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10368,57,15.6,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10368,64,26.6,35,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10369,29,99,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10369,56,30.4,18,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10370,1,14.4,15,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10370,64,26.6,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10370,74,8,20,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10371,36,15.2,6,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10372,20,64.8,12,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10372,38,210.8,40,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10372,60,27.2,70,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10372,72,27.8,42,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10373,58,10.6,80,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10373,71,17.2,50,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10374,31,10,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10374,58,10.6,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10375,14,18.6,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10375,54,5.9,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10376,31,10,42,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10377,28,36.4,20,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10377,39,14.4,20,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10378,71,17.2,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10379,41,7.7,8,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10379,63,35.1,16,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10379,65,16.8,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10380,30,20.7,18,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10380,53,26.2,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10380,60,27.2,6,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10380,70,12,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10381,74,8,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10382,5,17,32,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10382,18,50,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10382,29,99,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10382,33,2,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10382,74,8,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10383,13,4.8,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10383,50,13,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10383,56,30.4,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10384,20,64.8,28,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10384,60,27.2,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10385,7,24,10,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10385,60,27.2,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10385,68,10,8,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10386,24,3.6,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10386,34,11.2,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10387,24,3.6,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10387,28,36.4,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10387,59,44,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10387,71,17.2,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10388,45,7.6,15,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10388,52,5.6,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10388,53,26.2,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10389,10,24.8,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10389,55,19.2,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10389,62,39.4,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10389,70,12,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10390,31,10,60,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10390,35,14.4,40,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10390,46,9.6,45,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10390,72,27.8,24,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10391,13,4.8,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10392,69,28.8,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10393,2,15.2,25,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10393,14,18.6,42,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10393,25,11.2,7,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10393,26,24.9,70,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10393,31,10,32,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10394,13,4.8,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10394,62,39.4,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10395,46,9.6,28,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10395,53,26.2,70,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10395,69,28.8,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10396,23,7.2,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10396,71,17.2,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10396,72,27.8,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10397,21,8,10,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10397,51,42.4,18,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10398,35,14.4,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10398,55,19.2,120,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10399,68,10,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10399,71,17.2,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10399,76,14.4,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10399,77,10.4,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10400,29,99,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10400,35,14.4,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10400,49,16,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10401,30,20.7,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10401,56,30.4,70,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10401,65,16.8,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10401,71,17.2,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10402,23,7.2,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10402,63,35.1,65,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10403,16,13.9,21,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10403,48,10.2,70,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10404,26,24.9,30,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10404,42,11.2,40,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10404,49,16,30,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10405,3,8,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10406,1,14.4,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10406,21,8,30,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10406,28,36.4,42,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10406,36,15.2,5,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10406,40,14.7,2,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10407,11,16.8,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10407,69,28.8,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10407,71,17.2,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10408,37,20.8,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10408,54,5.9,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10408,62,39.4,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10409,14,18.6,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10409,21,8,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10410,33,2,49,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10410,59,44,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10411,41,7.7,25,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10411,44,15.5,40,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10411,59,44,9,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10412,14,18.6,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10413,1,14.4,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10413,62,39.4,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10413,76,14.4,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10414,19,7.3,18,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10414,33,2,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10415,17,31.2,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10415,33,2,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10416,19,7.3,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10416,53,26.2,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10416,57,15.6,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10417,38,210.8,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10417,46,9.6,2,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10417,68,10,36,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10417,77,10.4,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10418,2,15.2,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10418,47,7.6,55,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10418,61,22.8,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10418,74,8,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10419,60,27.2,60,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10419,69,28.8,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10420,9,77.6,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10420,13,4.8,2,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10420,70,12,8,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10420,73,12,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10421,19,7.3,4,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10421,26,24.9,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10421,53,26.2,15,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10421,77,10.4,10,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10422,26,24.9,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10423,31,10,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10423,59,44,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10424,35,14.4,60,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10424,38,210.8,49,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10424,68,10,30,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10425,55,19.2,10,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10425,76,14.4,20,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10426,56,30.4,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10426,64,26.6,7,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10427,14,18.6,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10428,46,9.6,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10429,50,13,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10429,63,35.1,35,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10430,17,31.2,45,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10430,21,8,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10430,56,30.4,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10430,59,44,70,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10431,17,31.2,50,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10431,40,14.7,50,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10431,47,7.6,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10432,26,24.9,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10432,54,5.9,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10433,56,30.4,28,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10434,11,16.8,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10434,76,14.4,18,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10435,2,15.2,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10435,22,16.8,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10435,72,27.8,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10436,46,9.6,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10436,56,30.4,40,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10436,64,26.6,30,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10436,75,6.2,24,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10437,53,26.2,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10438,19,7.3,15,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10438,34,11.2,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10438,57,15.6,15,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10829,60,34,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10830,6,25,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10830,39,18,28,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10830,60,34,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10830,68,12.5,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10831,19,9.2,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10831,35,18,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10831,38,263.5,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10831,43,46,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10832,13,6,3,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10832,25,14,10,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10832,44,19.45,16,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10832,64,33.25,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10833,7,30,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10833,31,12.5,9,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10833,53,32.8,9,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10834,29,123.79,8,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10834,30,25.89,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10835,59,55,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10835,77,13,2,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10836,22,21,52,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10836,35,18,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10836,57,19.5,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10836,60,34,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10836,64,33.25,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10837,13,6,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10747,41,9.65,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10747,63,43.9,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10747,69,36,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10748,23,9,44,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10748,40,18.4,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10748,56,38,28,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10749,56,38,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10749,59,55,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10749,76,18,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10750,14,23.25,5,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10750,45,9.5,40,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10750,59,55,25,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10751,26,31.23,12,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10751,30,25.89,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10751,50,16.25,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10751,73,15,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10752,1,18,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10752,69,36,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10753,45,9.5,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10753,74,10,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10754,40,18.4,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10755,47,9.5,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10755,56,38,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10755,57,19.5,14,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10755,69,36,25,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10756,18,62.5,21,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10756,36,19,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10756,68,12.5,6,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10756,69,36,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10757,34,14,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10757,59,55,7,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10757,62,49.3,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10757,64,33.25,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10758,26,31.23,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10758,52,7,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10758,70,15,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10759,32,32,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10760,25,14,12,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10760,27,43.9,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10760,43,46,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10761,25,14,35,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10761,75,7.75,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10762,39,18,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10762,47,9.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10762,51,53,28,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10762,56,38,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10763,21,10,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10763,22,21,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10763,24,4.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10764,3,10,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10764,39,18,130,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10765,65,21.05,80,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10766,2,19,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10766,7,30,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10766,68,12.5,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10767,42,14,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10768,22,21,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10768,31,12.5,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10768,60,34,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10768,71,21.5,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10769,41,9.65,30,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10769,52,7,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10769,61,28.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10769,62,49.3,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10770,11,21,15,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10771,71,21.5,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10772,29,123.79,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10772,59,55,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10773,17,39,33,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10773,31,12.5,70,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10773,75,7.75,7,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10774,31,12.5,2,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10774,66,17,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10775,10,31,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10775,67,14,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10776,31,12.5,16,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10776,42,14,12,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10776,45,9.5,27,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10776,51,53,120,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10777,42,14,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10778,41,9.65,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10779,16,17.45,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10779,62,49.3,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10780,70,15,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10780,77,13,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10781,54,7.45,3,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10781,56,38,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10781,74,10,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10782,31,12.5,1,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10783,31,12.5,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10783,38,263.5,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10784,36,19,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10784,39,18,2,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10784,72,34.8,30,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10785,10,31,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10785,75,7.75,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10786,8,40,30,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10786,30,25.89,15,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10786,75,7.75,42,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10787,2,19,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10787,29,123.79,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10788,19,9.2,50,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10788,75,7.75,40,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10789,18,62.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10789,35,18,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10789,63,43.9,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10789,68,12.5,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10790,7,30,3,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10790,56,38,20,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10791,29,123.79,14,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10791,41,9.65,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10792,2,19,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10792,54,7.45,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10792,68,12.5,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10793,41,9.65,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10793,52,7,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10794,14,23.25,15,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10794,54,7.45,6,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10795,16,17.45,65,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10795,17,39,35,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10796,26,31.23,21,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10796,44,19.45,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10796,64,33.25,35,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10796,69,36,24,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10797,11,21,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10798,62,49.3,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10798,72,34.8,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10799,13,6,20,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10799,24,4.5,20,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10799,59,55,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10800,11,21,50,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10800,51,53,10,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10800,54,7.45,7,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10801,17,39,40,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10801,29,123.79,20,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10802,30,25.89,25,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10802,51,53,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10802,55,24,60,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10802,62,49.3,5,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10803,19,9.2,24,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10803,25,14,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10803,59,55,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10804,10,31,36,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10804,28,45.6,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10804,49,20,4,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10805,34,14,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10805,38,263.5,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10806,2,19,20,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10806,65,21.05,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10806,74,10,15,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10807,40,18.4,1,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10808,56,38,20,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10808,76,18,50,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10809,52,7,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10810,13,6,7,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10810,25,14,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10810,70,15,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10811,19,9.2,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10811,23,9,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10811,40,18.4,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10812,31,12.5,16,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10812,72,34.8,40,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10812,77,13,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10813,2,19,12,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10813,46,12,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10814,41,9.65,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10814,43,46,20,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10814,48,12.75,8,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10814,61,28.5,30,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10815,33,2.5,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10816,38,263.5,30,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10816,62,49.3,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10817,26,31.23,40,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10817,38,263.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10817,40,18.4,60,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10817,62,49.3,25,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10818,32,32,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10818,41,9.65,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10819,43,46,7,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10819,75,7.75,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10820,56,38,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10821,35,18,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10821,51,53,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10822,62,49.3,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10822,70,15,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10823,11,21,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10823,57,19.5,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10823,59,55,40,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10823,77,13,15,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10824,41,9.65,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10824,70,15,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10825,26,31.23,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10825,53,32.8,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10826,31,12.5,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10826,57,19.5,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10827,10,31,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10827,39,18,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10828,20,81,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10828,38,263.5,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10829,2,19,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10829,8,40,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10829,13,6,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10927,52,7,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10927,76,18,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10928,47,9.5,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10928,76,18,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10929,21,10,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10929,75,7.75,49,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10929,77,13,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10930,21,10,36,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10930,27,43.9,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10930,55,24,25,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10930,58,13.25,30,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10931,13,6,42,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10931,57,19.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10932,16,17.45,30,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10932,62,49.3,14,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10932,72,34.8,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10932,75,7.75,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10933,53,32.8,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10933,61,28.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10934,6,25,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10935,1,18,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10935,18,62.5,4,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10935,23,9,8,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10936,36,19,30,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10937,28,45.6,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10937,34,14,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10938,13,6,20,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10938,43,46,24,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10938,60,34,49,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10938,71,21.5,35,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10939,2,19,10,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10939,67,14,40,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10940,7,30,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10940,13,6,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10941,31,12.5,44,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10941,62,49.3,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10941,68,12.5,80,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10941,72,34.8,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10942,49,20,28,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10943,13,6,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10943,22,21,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10943,46,12,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10944,11,21,5,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10944,44,19.45,18,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10944,56,38,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10945,13,6,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10945,31,12.5,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10946,10,31,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10946,24,4.5,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10946,77,13,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10947,59,55,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10948,50,16.25,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10948,51,53,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10948,55,24,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10949,6,25,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10949,10,31,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10949,17,39,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10949,62,49.3,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10950,4,22,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10951,33,2.5,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10951,41,9.65,6,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10951,75,7.75,50,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10952,6,25,16,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10952,28,45.6,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10953,20,81,50,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10953,31,12.5,50,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10954,16,17.45,28,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10954,31,12.5,25,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10954,45,9.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10954,60,34,24,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10955,75,7.75,12,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10956,21,10,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10956,47,9.5,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10956,51,53,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10957,30,25.89,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10957,35,18,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10957,64,33.25,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10958,5,21.35,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10958,7,30,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10958,72,34.8,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10959,75,7.75,20,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10960,24,4.5,10,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10960,41,9.65,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10961,52,7,6,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10961,76,18,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10962,7,30,45,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10962,13,6,77,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10962,53,32.8,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10962,69,36,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10962,76,18,44,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10963,60,34,2,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10964,18,62.5,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10964,38,263.5,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10964,69,36,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10965,51,53,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10966,37,26,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10966,56,38,12,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10966,62,49.3,12,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10967,19,9.2,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10967,49,20,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10968,12,38,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10968,24,4.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10968,64,33.25,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10969,46,12,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10970,52,7,40,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10971,29,123.79,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10972,17,39,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10972,33,2.5,7,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10973,26,31.23,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10973,41,9.65,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10973,75,7.75,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10974,63,43.9,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10975,8,40,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10975,75,7.75,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10976,28,45.6,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10977,39,18,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10977,47,9.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10977,51,53,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10977,63,43.9,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10978,8,40,20,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10978,21,10,40,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10978,40,18.4,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10978,44,19.45,6,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10979,7,30,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10979,12,38,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10979,24,4.5,80,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10979,27,43.9,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10979,31,12.5,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10979,63,43.9,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10980,75,7.75,40,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10981,38,263.5,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10982,7,30,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10982,43,46,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10983,13,6,84,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10983,57,19.5,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10984,16,17.45,55,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10984,24,4.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10984,36,19,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10985,16,17.45,36,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10985,18,62.5,8,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10985,32,32,35,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10986,11,21,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10986,20,81,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10986,76,18,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10986,77,13,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10987,7,30,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10987,43,46,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10987,72,34.8,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10988,7,30,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10988,62,49.3,40,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10989,6,25,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10989,11,21,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10989,41,9.65,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10990,21,10,65,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10990,34,14,60,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10990,55,24,65,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10990,61,28.5,66,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10991,2,19,50,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10991,70,15,20,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10991,76,18,90,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10992,72,34.8,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10993,29,123.79,50,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10993,41,9.65,35,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10994,59,55,18,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10995,51,53,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10995,60,34,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10996,42,14,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10997,32,32,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10997,46,12,20,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10997,52,7,20,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10998,24,4.5,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10998,61,28.5,7,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10998,74,10,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10998,75,7.75,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10999,41,9.65,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10999,51,53,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (10999,77,13,21,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11000,4,22,25,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11000,24,4.5,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11000,77,13,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11001,7,30,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11001,22,21,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11001,46,12,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11001,55,24,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11002,13,6,56,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11002,35,18,15,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11002,42,14,24,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11002,55,24,40,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11003,1,18,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11003,40,18.4,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11003,52,7,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11004,26,31.23,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11004,76,18,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11005,1,18,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11005,59,55,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11006,1,18,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11006,29,123.79,2,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11007,8,40,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11007,29,123.79,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11007,42,14,14,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11008,28,45.6,70,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11008,34,14,90,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11008,71,21.5,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11009,24,4.5,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11009,36,19,18,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11009,60,34,9,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11010,7,30,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11010,24,4.5,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11011,58,13.25,40,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11011,71,21.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11012,19,9.2,50,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11012,60,34,36,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11012,71,21.5,60,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11013,23,9,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11013,42,14,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11013,45,9.5,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11013,68,12.5,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11014,41,9.65,28,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11015,30,25.89,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11015,77,13,18,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11016,31,12.5,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11016,36,19,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11017,3,10,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11017,59,55,110,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11017,70,15,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11018,12,38,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11018,18,62.5,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11018,56,38,5,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11019,46,12,3,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11019,49,20,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11020,10,31,24,0.15);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11021,2,19,11,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11021,20,81,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11021,26,31.23,63,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11021,51,53,44,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11021,72,34.8,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11022,19,9.2,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11022,69,36,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11023,7,30,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11023,43,46,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11024,26,31.23,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11024,33,2.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11024,65,21.05,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11024,71,21.5,50,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11025,1,18,10,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11025,13,6,20,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11026,18,62.5,8,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11026,51,53,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11027,24,4.5,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11027,62,49.3,21,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11028,55,24,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11028,59,55,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11029,56,38,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11029,63,43.9,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11030,2,19,100,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11030,5,21.35,70,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11030,29,123.79,60,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11030,59,55,100,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11031,1,18,45,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11031,13,6,80,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11031,24,4.5,21,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11031,64,33.25,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11031,71,21.5,16,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11032,36,19,35,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11032,38,263.5,25,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11032,59,55,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11033,53,32.8,70,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11033,69,36,36,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11034,21,10,15,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11034,44,19.45,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11034,61,28.5,6,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11035,1,18,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11035,35,18,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11035,42,14,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11035,54,7.45,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11036,13,6,7,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11036,59,55,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11037,70,15,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11038,40,18.4,5,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11038,52,7,2,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11038,71,21.5,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11039,28,45.6,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11039,35,18,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11039,49,20,60,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11039,57,19.5,28,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11040,21,10,20,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11041,2,19,30,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11041,63,43.9,30,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11042,44,19.45,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11042,61,28.5,4,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11043,11,21,10,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11044,62,49.3,12,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11045,33,2.5,15,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11045,51,53,24,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11046,12,38,20,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11046,32,32,15,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11046,35,18,18,0.05);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11047,1,18,25,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11047,5,21.35,30,0.25);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11048,68,12.5,42,0);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11049,2,19,10,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11049,12,38,4,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11050,76,18,50,0.1);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11051,24,4.5,10,0.2);
Insert into ORDER_DETAILS (ORDER_ID,PRODUCT_ID,UNIT_PRICE,QUANTITY,DISCOUNT) values (11052,43,46,30,0.2);
-- INSERTING into PRODUCTS
-- 
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (1,'Chai',1,1,'10 boxes x 20 bags',18,39,0,10,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (2,'Chang',1,1,'24 - 12 oz bottles',19,17,40,25,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (3,'Aniseed Syrup',1,2,'12 - 550 ml bottles',10,13,70,25,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (4,'Chef Anton''s Cajun Seasoning',2,2,'48 - 6 oz jars',22,53,0,0,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (5,'Chef Anton''s Gumbo Mix',2,2,'36 boxes',21.35,0,0,0,'Y');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (6,'Grandma''s Boysenberry Spread',3,2,'12 - 8 oz jars',25,120,0,25,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (7,'Uncle Bob''s Organic Dried Pears',3,7,'12 - 1 lb pkgs.',30,15,0,10,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (8,'Northwoods Cranberry Sauce',3,2,'12 - 12 oz jars',40,6,0,0,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (9,'Mishi Kobe Niku',4,6,'18 - 500 g pkgs.',97,29,0,0,'Y');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (10,'Ikura',4,8,'12 - 200 ml jars',31,31,0,0,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (11,'Queso Cabrales',5,4,'1 kg pkg.',21,22,30,30,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (12,'Queso Manchego La Pastora',5,4,'10 - 500 g pkgs.',38,86,0,0,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (13,'Konbu',6,8,'2 kg box',6,24,0,5,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (14,'Tofu',6,7,'40 - 100 g pkgs.',23.25,35,0,0,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (15,'Genen Shouyu',6,2,'24 - 250 ml bottles',15.5,39,0,5,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (16,'Pavlova',7,3,'32 - 500 g boxes',17.45,29,0,10,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (17,'Alice Mutton',7,6,'20 - 1 kg tins',39,0,0,0,'Y');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (18,'Carnarvon Tigers',7,8,'16 kg pkg.',62.5,42,0,0,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (19,'Teatime Chocolate Biscuits',8,3,'10 boxes x 12 pieces',9.2,25,0,5,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (20,'Sir Rodney''s Marmalade',8,3,'30 gift boxes',81,40,0,0,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (21,'Sir Rodney''s Scones',8,3,'24 pkgs. x 4 pieces',10,3,40,5,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (22,'Gustaf''s Kn?ckebr?d',9,5,'24 - 500 g pkgs.',21,104,0,25,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (23,'Tunnbr?d',9,5,'12 - 250 g pkgs.',9,61,0,25,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (24,'Guaran? Fant?stica',10,1,'12 - 355 ml cans',4.5,20,0,0,'Y');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (25,'NuNuCa Nu?-Nougat-Creme',11,3,'20 - 450 g glasses',14,76,0,30,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (26,'Gumb?r Gummib?rchen',11,3,'100 - 250 g bags',31.23,15,0,0,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (27,'Schoggi Schokolade',11,3,'100 - 100 g pieces',43.9,49,0,30,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (28,'R?ssle Sauerkraut',12,7,'25 - 825 g cans',45.6,26,0,0,'Y');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (29,'Th?ringer Rostbratwurst',12,6,'50 bags x 30 sausgs.',123.79,0,0,0,'Y');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (30,'Nord-Ost Matjeshering',13,8,'10 - 200 g glasses',25.89,10,0,15,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (31,'Gorgonzola Telino',14,4,'12 - 100 g pkgs',12.5,0,70,20,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (32,'Mascarpone Fabioli',14,4,'24 - 200 g pkgs.',32,9,40,25,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (33,'Geitost',15,4,'500 g',2.5,112,0,20,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (34,'Sasquatch Ale',16,1,'24 - 12 oz bottles',14,111,0,15,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (35,'Steeleye Stout',16,1,'24 - 12 oz bottles',18,20,0,15,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (36,'Inlagd Sill',17,8,'24 - 250 g  jars',19,112,0,20,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (37,'Gravad lax',17,8,'12 - 500 g pkgs.',26,11,50,25,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (38,'C?te de Blaye',18,1,'12 - 75 cl bottles',263.5,17,0,15,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (39,'Chartreuse verte',18,1,'750 cc per bottle',18,69,0,5,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (40,'Boston Crab Meat',19,8,'24 - 4 oz tins',18.4,123,0,30,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (41,'Jack''s New England Clam Chowder',19,8,'12 - 12 oz cans',9.65,85,0,10,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (42,'Singaporean Hokkien Fried Mee',20,5,'32 - 1 kg pkgs.',14,26,0,0,'Y');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (43,'Ipoh Coffee',20,1,'16 - 500 g tins',46,17,10,25,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (44,'Gula Malacca',20,2,'20 - 2 kg bags',19.45,27,0,15,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (45,'R?gede sild',21,8,'1k pkg.',9.5,5,70,15,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (46,'Spegesild',21,8,'4 - 450 g glasses',12,95,0,0,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (47,'Zaanse koeken',22,3,'10 - 4 oz boxes',9.5,36,0,0,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (48,'Chocolade',22,3,'10 pkgs.',12.75,15,70,25,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (49,'Maxilaku',23,3,'24 - 50 g pkgs.',20,10,60,15,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (50,'Valkoinen suklaa',23,3,'12 - 100 g bars',16.25,65,0,30,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (51,'Manjimup Dried Apples',24,7,'50 - 300 g pkgs.',53,20,0,10,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (52,'Filo Mix',24,5,'16 - 2 kg boxes',7,38,0,25,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (53,'Perth Pasties',24,6,'48 pieces',32.8,0,0,0,'Y');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (54,'Tourti?re',25,6,'16 pies',7.45,21,0,10,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (55,'P?t? chinois',25,6,'24 boxes x 2 pies',24,115,0,20,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (56,'Gnocchi di nonna Alice',26,5,'24 - 250 g pkgs.',38,21,10,30,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (57,'Ravioli Angelo',26,5,'24 - 250 g pkgs.',19.5,36,0,20,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (58,'Escargots de Bourgogne',27,8,'24 pieces',13.25,62,0,20,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (59,'Raclette Courdavault',28,4,'5 kg pkg.',55,79,0,0,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (60,'Camembert Pierrot',28,4,'15 - 300 g rounds',34,19,0,0,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (61,'Sirop d''?rable',29,2,'24 - 500 ml bottles',28.5,113,0,25,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (62,'Tarte au sucre',29,3,'48 pies',49.3,17,0,0,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (63,'Vegie-spread',7,2,'15 - 625 g jars',43.9,24,0,5,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (64,'Wimmers gute Semmelkn?del',12,5,'20 bags x 4 pieces',33.25,22,80,30,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (65,'Louisiana Fiery Hot Pepper Sauce',2,2,'32 - 8 oz bottles',21.05,76,0,0,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (66,'Louisiana Hot Spiced Okra',2,2,'24 - 8 oz jars',17,4,100,20,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (67,'Laughing Lumberjack Lager',16,1,'24 - 12 oz bottles',14,52,0,10,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (68,'Scottish Longbreads',8,3,'10 boxes x 8 pieces',12.5,6,10,15,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (69,'Gudbrandsdalsost',15,4,'10 kg pkg.',36,26,0,15,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (70,'Outback Lager',7,1,'24 - 355 ml bottles',15,15,10,30,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (71,'Fl?temysost',15,4,'10 - 500 g pkgs.',21.5,26,0,0,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (72,'Mozzarella di Giovanni',14,4,'24 - 200 g pkgs.',34.8,14,0,0,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (73,'R?d Kaviar',17,8,'24 - 150 g jars',15,101,0,5,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (74,'Longlife Tofu',4,7,'5 kg pkg.',10,4,20,5,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (75,'Rh?nbr?u Klosterbier',12,1,'24 - 0.5 l bottles',7.75,125,0,25,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (76,'Lakkalik??ri',23,1,'500 ml',18,57,0,20,'N');
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,SUPPLIER_ID,CATEGORY_ID,QUANTITY_PER_UNIT,UNIT_PRICE,UNITS_IN_STOCK,UNITS_ON_ORDER,REORDER_LEVEL,DISCONTINUED) values (77,'Original Frankfurter gr?ne So?e',12,2,'12 boxes',13,32,0,15,'N');
-- INSERTING into SHIPPERS
-- 
Insert into SHIPPERS (SHIPPER_ID,COMPANY_NAME,PHONE) values (1,'Speedy Express','(503) 555-9831');
Insert into SHIPPERS (SHIPPER_ID,COMPANY_NAME,PHONE) values (2,'United Package','(503) 555-3199');
Insert into SHIPPERS (SHIPPER_ID,COMPANY_NAME,PHONE) values (3,'Federal Shipping','(503) 555-9931');
-- INSERTING into SUPPLIERS
-- 
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (1,'Exotic Liquids','Charlotte Cooper','Purchasing Manager','49 Gilbert St.','London',null,'EC1 4SD','UK','(171) 555-2222',null,null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (2,'New Orleans Cajun Delights','Shelley Burke','Order Administrator','P.O. Box 78934','New Orleans','LA','70117','USA','(100) 555-4822',null,null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (3,'Grandma Kelly''s Homestead','Regina Murphy','Sales Representative','707 Oxford Rd.','Ann Arbor','MI','48104','USA','(313) 555-5735','(313) 555-3349',null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (4,'Tokyo Traders','Yoshi Nagase','Marketing Manager','9-8 SekimaiMusashino-shi','Tokyo',null,'100','Japan','(03) 3555-5011',null,null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (5,'Cooperativa de Quesos ''Las Cabras''','Antonio del Valle Saavedra ','Export Administrator','Calle del Rosal 4','Oviedo','Asturias','33007','Spain','(98) 598 76 54',null,null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (6,'Mayumi''s','Mayumi Ohno','Marketing Representative','92 SetsukoChuo-ku','Osaka',null,'545','Japan','(06) 431-7877',null,null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (7,'Pavlova, Ltd.','Ian Devling','Marketing Manager','74 Rose St.Moonie Ponds','Melbourne','Victoria','3058','Australia','(03) 444-2343','(03) 444-6588',null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (8,'Specialty Biscuits, Ltd.','Peter Wilson','Sales Representative','29 King''s Way','Manchester',null,'M14 GSD','UK','(161) 555-4448',null,null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (9,'PB Kn?ckebr?d AB','Lars Peterson','Sales Agent','Kaloadagatan 13','G?teborg',null,'S-345 67','Sweden ','031-987 65 43','031-987 65 91',null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (10,'Refrescos Americanas LTDA','Carlos Diaz','Marketing Manager','Av. das Americanas 12.890','S?o Paulo',null,'5442','Brazil','(11) 555 4640',null,null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (11,'Heli S??waren GmbH & Co. KG','Petra Winkler','Sales Manager','Tiergartenstra?e 5','Berlin',null,'10785','Germany','(010) 9984510',null,null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (12,'Plutzer Lebensmittelgro?m?rkte AG','Martin Bein','International Marketing Mgr.','Bogenallee 51','Frankfurt',null,'60439','Germany','(069) 992755',null,null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (13,'Nord-Ost-Fisch Handelsgesellschaft mbH','Sven Petersen','Coordinator Foreign Markets','Frahmredder 112a','Cuxhaven',null,'27478','Germany','(04721) 8713','(04721) 8714',null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (14,'Formaggi Fortini s.r.l.','Elio Rossi','Sales Representative','Viale Dante, 75','Ravenna',null,'48100','Italy','(0544) 60323','(0544) 60603',null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (15,'Norske Meierier','Beate Vileid','Marketing Manager','Hatlevegen 5','Sandvika',null,'1320','Norway','(0)2-953010',null,null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (16,'Bigfoot Breweries','Cheryl Saylor','Regional Account Rep.','3400 - 8th AvenueSuite 210','Bend','OR','97101','USA','(503) 555-9931',null,null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (17,'Svensk Sj?f?da AB','Michael Bj?rn','Sales Representative','Brovallav?gen 231','Stockholm',null,'S-123 45','Sweden','08-123 45 67',null,null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (18,'Aux joyeux eccl?siastiques','Guyl?ne Nodier','Sales Manager','203, Rue des Francs-Bourgeois','Paris',null,'75004','France','(1) 03.83.00.68','(1) 03.83.00.62',null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (19,'New England Seafood Cannery','Robb Merchant','Wholesale Account Agent','Order Processing Dept. 2100 Paul Revere Blvd.','Boston','MA','02134','USA','(617) 555-3267','(617) 555-3389',null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (20,'Leka Trading','Chandra Leka','Owner','471 Serangoon Loop, Suite #402','Singapore',null,'0512','Singapore','555-8787',null,null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (21,'Lyngbysild','Niels Petersen','Sales Manager','LyngbysildFiskebakken 10','Lyngby',null,'2800','Denmark','43844108','43844115',null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (22,'Zaanse Snoepfabriek','Dirk Luchte','Accounting Manager','VerkoopRijnweg 22','Zaandam',null,'9999 ZZ','Netherlands','(12345) 1212','(12345) 1210',null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (23,'Karkki Oy','Anne Heikkonen','Product Manager','Valtakatu 12','Lappeenranta',null,'53120','Finland','(953) 10956',null,null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (24,'G''day, Mate','Wendy Mackenzie','Sales Representative','170 Prince Edward ParadeHunter''s Hill','Sydney','NSW','2042','Australia','(02) 555-5914','(02) 555-4873',null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (25,'Ma Maison','Jean-Guy Lauzon','Marketing Manager','2960 Rue St. Laurent','Montr?al','Qu?bec','H1J 1C3','Canada','(514) 555-9022',null,null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (26,'Pasta Buttini s.r.l.','Giovanni Giudici','Order Administrator','Via dei Gelsomini, 153','Salerno',null,'84100','Italy','(089) 6547665','(089) 6547667',null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (27,'Escargots Nouveaux','Marie Delamare','Sales Manager','22, rue H. Voiron','Montceau',null,'71300','France','85.57.00.07',null,null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (28,'Gai p?turage','Eliane Noz','Sales Representative','Bat. B3, rue des Alpes','Annecy',null,'74000','France','38.76.98.06','38.76.98.58',null);
Insert into SUPPLIERS (SUPPLIER_ID,COMPANY_NAME,CONTACT_NAME,CONTACT_TITLE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,PHONE,FAX,HOME_PAGE) values (29,'For?ts d''?rables','Chantal Goulet','Accounting Manager','148 rue Chasseur','Ste-Hyacinthe','Qu?bec','J2S 7S8','Canada','(514) 555-2955','(514) 555-2921',null);
--------------------------------------------------------
--  DDL for Index IDX_CUSTOMERS_CITY
--------------------------------------------------------

  CREATE INDEX "IDX_CUSTOMERS_CITY" ON "CUSTOMERS" ("CITY") ;
--------------------------------------------------------
--  DDL for Index IDX_CUSTOMERS_COMPANY_NAME
--------------------------------------------------------

  CREATE INDEX "IDX_CUSTOMERS_COMPANY_NAME" ON "CUSTOMERS" ("COMPANY_NAME");
--------------------------------------------------------
--  DDL for Index IDX_CUSTOMERS_POSTAL_CODE
--------------------------------------------------------

  CREATE INDEX "IDX_CUSTOMERS_POSTAL_CODE" ON "CUSTOMERS" ("POSTAL_CODE") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_CUSTOMERS_REGION
--------------------------------------------------------

  CREATE INDEX "IDX_CUSTOMERS_REGION" ON "CUSTOMERS" ("REGION") ;
--------------------------------------------------------
--  DDL for Index IDX_EMPLOYEES_LASTNAME
--------------------------------------------------------

  CREATE INDEX "IDX_EMPLOYEES_LASTNAME" ON "EMPLOYEES" ("LASTNAME");
--------------------------------------------------------
--  DDL for Index IDX_EMPLOYEES_POSTAL_CODE
--------------------------------------------------------

  CREATE INDEX "IDX_EMPLOYEES_POSTAL_CODE" ON "EMPLOYEES" ("POSTAL_CODE") ;
--------------------------------------------------------
--  DDL for Index IDX_ORDERS_CUSTOMER_ID
--------------------------------------------------------

  CREATE INDEX "IDX_ORDERS_CUSTOMER_ID" ON "ORDERS" ("CUSTOMER_ID");
--------------------------------------------------------
--  DDL for Index IDX_ORDERS_EMPLOYEE_ID
--------------------------------------------------------

  CREATE INDEX "IDX_ORDERS_EMPLOYEE_ID" ON "ORDERS" ("EMPLOYEE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_ORDERS_ORDER_DATE
--------------------------------------------------------

  CREATE INDEX "IDX_ORDERS_ORDER_DATE" ON "ORDERS" ("ORDER_DATE") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_ORDERS_SHIPPED_DATE
--------------------------------------------------------

  CREATE INDEX "IDX_ORDERS_SHIPPED_DATE" ON "ORDERS" ("SHIPPED_DATE") 
   ;
--------------------------------------------------------
--  DDL for Index IDX_ORDERS_SHIPPER_ID
--------------------------------------------------------

  CREATE INDEX "IDX_ORDERS_SHIPPER_ID" ON "ORDERS" ("SHIP_VIA") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_ORDERS_SHIP_POSTAL_CODE
--------------------------------------------------------

  CREATE INDEX "IDX_ORDERS_SHIP_POSTAL_CODE" ON "ORDERS" ("SHIP_POSTAL_CODE") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_ORDER_DETAILS_ORDER_ID
--------------------------------------------------------

  CREATE INDEX "IDX_ORDER_DETAILS_ORDER_ID" ON "ORDER_DETAILS" ("ORDER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_ORDER_DETAILS_PRODUCT_ID
--------------------------------------------------------

  CREATE INDEX "IDX_ORDER_DETAILS_PRODUCT_ID" ON "ORDER_DETAILS" ("PRODUCT_ID")  ;
--------------------------------------------------------
--  DDL for Index IDX_PRODUCTS_CATEGORY_ID
--------------------------------------------------------

  CREATE INDEX "IDX_PRODUCTS_CATEGORY_ID" ON "PRODUCTS" ("CATEGORY_ID") ;
--------------------------------------------------------
--  DDL for Index IDX_PRODUCTS_SUPPLIER_ID
--------------------------------------------------------

  CREATE INDEX "IDX_PRODUCTS_SUPPLIER_ID" ON "PRODUCTS" ("SUPPLIER_ID") ;
--------------------------------------------------------
--  DDL for Index IDX_SUPPLIERS_COMPANY_NAME
--------------------------------------------------------

  CREATE INDEX "IDX_SUPPLIERS_COMPANY_NAME" ON "SUPPLIERS" ("COMPANY_NAME")  ;
--------------------------------------------------------
--  DDL for Index IDX_SUPPLIERS_POSTAL_CODE
--------------------------------------------------------

  CREATE INDEX "IDX_SUPPLIERS_POSTAL_CODE" ON "SUPPLIERS" ("POSTAL_CODE") 
   ;
--------------------------------------------------------
--  DDL for Index PK_CATEGORIES
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_CATEGORIES" ON "CATEGORIES" ("CATEGORY_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_CUSTOMERS
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_CUSTOMERS" ON "CUSTOMERS" ("CUSTOMER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_EMPLOYEES
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_EMPLOYEES" ON "EMPLOYEES" ("EMPLOYEE_ID") 
   ;
--------------------------------------------------------
--  DDL for Index PK_ORDERS
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_ORDERS" ON "ORDERS" ("ORDER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_ORDER_DETAILS
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_ORDER_DETAILS" ON "ORDER_DETAILS" ("ORDER_ID", "PRODUCT_ID") 
 ;
--------------------------------------------------------
--  DDL for Index PK_PRODUCTS
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_PRODUCTS" ON "PRODUCTS" ("PRODUCT_ID") 
   ;
--------------------------------------------------------
--  DDL for Index PK_SHIPPERS
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_SHIPPERS" ON "SHIPPERS" ("SHIPPER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PK_SUPPLIERS
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_SUPPLIERS" ON "SUPPLIERS" ("SUPPLIER_ID") 
   ;
--------------------------------------------------------
--  DDL for Index UIDX_CATEGORY_NAME
--------------------------------------------------------

  CREATE UNIQUE INDEX "UIDX_CATEGORY_NAME" ON "CATEGORIES" ("CATEGORY_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index UIDX_CUSTOMERS_CODE
--------------------------------------------------------

  CREATE UNIQUE INDEX "UIDX_CUSTOMERS_CODE" ON "CUSTOMERS" ("CUSTOMER_CODE") 
 ;
--------------------------------------------------------
--  Constraints for Table CATEGORIES
--------------------------------------------------------

  ALTER TABLE "CATEGORIES" ADD CONSTRAINT "PK_CATEGORIES" PRIMARY KEY ("CATEGORY_ID");
  ALTER TABLE "CATEGORIES" MODIFY ("CATEGORY_NAME" NOT NULL ENABLE);
  ALTER TABLE "CATEGORIES" MODIFY ("CATEGORY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table CUSTOMERS
--------------------------------------------------------

  ALTER TABLE "CUSTOMERS" ADD CONSTRAINT "PK_CUSTOMERS" PRIMARY KEY ("CUSTOMER_ID");
  ALTER TABLE "CUSTOMERS" MODIFY ("COMPANY_NAME" NOT NULL ENABLE);
  ALTER TABLE "CUSTOMERS" MODIFY ("CUSTOMER_CODE" NOT NULL ENABLE);
  ALTER TABLE "CUSTOMERS" MODIFY ("CUSTOMER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table EMPLOYEES
--------------------------------------------------------

  ALTER TABLE "EMPLOYEES" ADD CONSTRAINT "PK_EMPLOYEES" PRIMARY KEY ("EMPLOYEE_ID");
  ALTER TABLE "EMPLOYEES" MODIFY ("FIRSTNAME" NOT NULL ENABLE);
  ALTER TABLE "EMPLOYEES" MODIFY ("LASTNAME" NOT NULL ENABLE);
  ALTER TABLE "EMPLOYEES" MODIFY ("EMPLOYEE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table ORDERS
--------------------------------------------------------

  ALTER TABLE "ORDERS" ADD CONSTRAINT "PK_ORDERS" PRIMARY KEY ("ORDER_ID");
  ALTER TABLE "ORDERS" MODIFY ("ORDER_DATE" NOT NULL ENABLE);
  ALTER TABLE "ORDERS" MODIFY ("EMPLOYEE_ID" NOT NULL ENABLE);
  ALTER TABLE "ORDERS" MODIFY ("CUSTOMER_ID" NOT NULL ENABLE);
  ALTER TABLE "ORDERS" MODIFY ("ORDER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table ORDER_DETAILS
--------------------------------------------------------

  ALTER TABLE "ORDER_DETAILS" ADD CONSTRAINT "PK_ORDER_DETAILS" PRIMARY KEY ("ORDER_ID", "PRODUCT_ID");
  ALTER TABLE "ORDER_DETAILS" ADD CONSTRAINT "CK_ORDER_DETAILS_DISCOUNT" CHECK (Discount between 0 and 1) ENABLE;
  ALTER TABLE "ORDER_DETAILS" ADD CONSTRAINT "CK_ORDER_DETAILS_QUANTITY" CHECK (Quantity>0) ENABLE;
  ALTER TABLE "ORDER_DETAILS" ADD CONSTRAINT "CK_ORDER_DETAILS_UNIT_PRICE" CHECK (Unit_Price>=0) ENABLE;
  ALTER TABLE "ORDER_DETAILS" MODIFY ("DISCOUNT" NOT NULL ENABLE);
  ALTER TABLE "ORDER_DETAILS" MODIFY ("QUANTITY" NOT NULL ENABLE);
  ALTER TABLE "ORDER_DETAILS" MODIFY ("UNIT_PRICE" NOT NULL ENABLE);
  ALTER TABLE "ORDER_DETAILS" MODIFY ("PRODUCT_ID" NOT NULL ENABLE);
  ALTER TABLE "ORDER_DETAILS" MODIFY ("ORDER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table PRODUCTS
--------------------------------------------------------

  ALTER TABLE "PRODUCTS" ADD CONSTRAINT "PK_PRODUCTS" PRIMARY KEY ("PRODUCT_ID");
  ALTER TABLE "PRODUCTS" ADD CONSTRAINT "CK_PRODUCTS_DISCONTINUED" CHECK (Discontinued in ('Y','N')) ENABLE;
  ALTER TABLE "PRODUCTS" ADD CONSTRAINT "CK_PRODUCTS_REORDER_LEVEL" CHECK (Reorder_Level>=0) ENABLE;
  ALTER TABLE "PRODUCTS" ADD CONSTRAINT "CK_PRODUCTS_UNITS_ON_ORDER" CHECK (Units_On_Order>=0) ENABLE;
  ALTER TABLE "PRODUCTS" ADD CONSTRAINT "CK_PRODUCTS_UNITS_IN_STOCK" CHECK (Units_In_Stock>=0) ENABLE;
  ALTER TABLE "PRODUCTS" ADD CONSTRAINT "CK_PRODUCTS_UNIT_PRICE" CHECK (Unit_Price>=0) ENABLE;
  ALTER TABLE "PRODUCTS" MODIFY ("DISCONTINUED" NOT NULL ENABLE);
  ALTER TABLE "PRODUCTS" MODIFY ("REORDER_LEVEL" NOT NULL ENABLE);
  ALTER TABLE "PRODUCTS" MODIFY ("UNITS_ON_ORDER" NOT NULL ENABLE);
  ALTER TABLE "PRODUCTS" MODIFY ("UNITS_IN_STOCK" NOT NULL ENABLE);
  ALTER TABLE "PRODUCTS" MODIFY ("UNIT_PRICE" NOT NULL ENABLE);
  ALTER TABLE "PRODUCTS" MODIFY ("CATEGORY_ID" NOT NULL ENABLE);
  ALTER TABLE "PRODUCTS" MODIFY ("SUPPLIER_ID" NOT NULL ENABLE);
  ALTER TABLE "PRODUCTS" MODIFY ("PRODUCT_NAME" NOT NULL ENABLE);
  ALTER TABLE "PRODUCTS" MODIFY ("PRODUCT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table SHIPPERS
--------------------------------------------------------

  ALTER TABLE "SHIPPERS" ADD CONSTRAINT "PK_SHIPPERS" PRIMARY KEY ("SHIPPER_ID");
  ALTER TABLE "SHIPPERS" MODIFY ("COMPANY_NAME" NOT NULL ENABLE);
  ALTER TABLE "SHIPPERS" MODIFY ("SHIPPER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table SUPPLIERS
--------------------------------------------------------

  ALTER TABLE "SUPPLIERS" ADD CONSTRAINT "PK_SUPPLIERS" PRIMARY KEY ("SUPPLIER_ID");
  ALTER TABLE "SUPPLIERS" MODIFY ("COMPANY_NAME" NOT NULL ENABLE);
  ALTER TABLE "SUPPLIERS" MODIFY ("SUPPLIER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Ref Constraints for Table EMPLOYEES
--------------------------------------------------------

  ALTER TABLE "EMPLOYEES" ADD CONSTRAINT "FK_REPORTS_TO" FOREIGN KEY ("REPORTS_TO")
	  REFERENCES "EMPLOYEES" ("EMPLOYEE_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table ORDERS
--------------------------------------------------------

  ALTER TABLE "ORDERS" ADD CONSTRAINT "FK_CUSTOMER_ID" FOREIGN KEY ("CUSTOMER_ID")
	  REFERENCES "CUSTOMERS" ("CUSTOMER_ID") ENABLE;
  ALTER TABLE "ORDERS" ADD CONSTRAINT "FK_EMPLOYEE_ID" FOREIGN KEY ("EMPLOYEE_ID")
	  REFERENCES "EMPLOYEES" ("EMPLOYEE_ID") ENABLE;
  ALTER TABLE "ORDERS" ADD CONSTRAINT "FK_SHIPPER_ID" FOREIGN KEY ("SHIP_VIA")
	  REFERENCES "SHIPPERS" ("SHIPPER_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table ORDER_DETAILS
--------------------------------------------------------

  ALTER TABLE "ORDER_DETAILS" ADD CONSTRAINT "FK_ORDER_ID" FOREIGN KEY ("ORDER_ID")
	  REFERENCES "ORDERS" ("ORDER_ID") ENABLE;
  ALTER TABLE "ORDER_DETAILS" ADD CONSTRAINT "FK_PRODUCT_ID" FOREIGN KEY ("PRODUCT_ID")
	  REFERENCES "PRODUCTS" ("PRODUCT_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table PRODUCTS
--------------------------------------------------------

  ALTER TABLE "PRODUCTS" ADD CONSTRAINT "FK_CATEGORY_ID" FOREIGN KEY ("CATEGORY_ID")
	  REFERENCES "CATEGORIES" ("CATEGORY_ID") ENABLE;
  ALTER TABLE "PRODUCTS" ADD CONSTRAINT "FK_SUPPLIER_ID" FOREIGN KEY ("SUPPLIER_ID")
	  REFERENCES "SUPPLIERS" ("SUPPLIER_ID") ENABLE;