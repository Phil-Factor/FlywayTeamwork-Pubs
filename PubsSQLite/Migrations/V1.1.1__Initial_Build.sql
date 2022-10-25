CREATE TABLE authors
  (au_id VARCHAR(11) NOT NULL,
   au_lname VARCHAR(40) NOT NULL,
   au_fname VARCHAR(20) NOT NULL,
   phone CHAR(12)
     DEFAULT 'UNKNOWN' NOT NULL,
   address VARCHAR(40),
   city VARCHAR(20),
   state CHAR(2),
   zip CHAR(5),
   contract INT NOT NULL,
   PRIMARY KEY (au_id));

CREATE TABLE jobs
  (job_id INT NOT NULL,
   job_desc VARCHAR(50)
     DEFAULT 'New Position - title not formalized yet' NOT NULL,
   min_lvl INT NOT NULL,
   max_lvl INT NOT NULL,
   PRIMARY KEY (job_id));

CREATE TABLE publishers
  (pub_id CHAR(4) NOT NULL,
   pub_name VARCHAR(40),
   city VARCHAR(20),
   state CHAR(2),
   country VARCHAR(30)
     DEFAULT 'USA',
   PRIMARY KEY (pub_id));

CREATE TABLE stores
  (stor_id CHAR(4) NOT NULL,
   stor_name VARCHAR(40),
   stor_address VARCHAR(40),
   city VARCHAR(20),
   state CHAR(2),
   zip CHAR(5),
   PRIMARY KEY (stor_id));

CREATE TABLE titles
  (title_id VARCHAR(6) NOT NULL,
   title VARCHAR(80) NOT NULL,
   type CHAR(12)
     DEFAULT 'UNDECIDED' NOT NULL,
   pub_id CHAR(4),
   price DECIMAL(19, 4),
   advance DECIMAL(19, 4),
   royalty INT,
   ytd_sales INT,
   notes VARCHAR(200),
   pubdate VARCHAR(50)
     DEFAULT (Date ('now')) NOT NULL,
   FOREIGN KEY (pub_id) REFERENCES publishers (pub_id),
   PRIMARY KEY (title_id));

CREATE TABLE pub_info
  (pub_id CHAR(4) NOT NULL,
   logo blob,
   pr_info clob,
   PRIMARY KEY (pub_id),
   FOREIGN KEY (pub_id) REFERENCES publishers (pub_id));

CREATE TABLE roysched
  (title_id VARCHAR(6) NOT NULL,
   lorange INT,
   hirange INT,
   royalty INT,
   FOREIGN KEY (title_id) REFERENCES titles (title_id));


CREATE TABLE discounts
  (discounttype VARCHAR(40) NOT NULL,
   stor_id CHAR(4),
   lowqty INT,
   highqty INT,
   discount DECIMAL(4, 2) NOT NULL,
   FOREIGN KEY (stor_id) REFERENCES stores (stor_id));

CREATE TABLE titleauthor
  (au_id VARCHAR(11) NOT NULL,
   title_id VARCHAR(6) NOT NULL,
   au_ord INT,
   royaltyper INT,
   FOREIGN KEY (au_id) REFERENCES authors (au_id),
   FOREIGN KEY (title_id) REFERENCES titles (title_id),
   PRIMARY KEY (au_id, title_id));


CREATE TABLE employee
  (emp_id CHAR(9) NOT NULL,
   fname VARCHAR(20) NOT NULL,
   minit CHAR(1),
   lname VARCHAR(30) NOT NULL,
   job_id INT
     DEFAULT ((1)) NOT NULL,
   job_lvl INT
     DEFAULT ((10)),
   pub_id CHAR(4)
     DEFAULT '9952' NOT NULL,
   hire_date VARCHAR(50)
     DEFAULT (Date ('now')) NOT NULL,
   FOREIGN KEY (job_id) REFERENCES jobs (job_id),
   FOREIGN KEY (pub_id) REFERENCES publishers (pub_id),
   PRIMARY KEY (emp_id));

CREATE TABLE sales
  (stor_id CHAR(4) NOT NULL,
   ord_num VARCHAR(20) NOT NULL,
   ord_date VARCHAR(50) NOT NULL,
   qty INT NOT NULL,
   payterms VARCHAR(12) NOT NULL,
   title_id VARCHAR(6) NOT NULL,
   PRIMARY KEY (ord_num, stor_id, title_id),
   FOREIGN KEY (stor_id) REFERENCES stores (stor_id),
   FOREIGN KEY (title_id) REFERENCES titles (title_id));



