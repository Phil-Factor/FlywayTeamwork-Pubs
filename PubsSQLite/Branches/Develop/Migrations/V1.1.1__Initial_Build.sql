CREATE TABLE authors (
	au_id varchar(11) NOT NULL,
	au_lname varchar(40) NOT NULL,
	au_fname varchar(20) NOT NULL,
	phone char(12) DEFAULT 'UNKNOWN' NOT NULL,
	address varchar(40),
	city varchar(20),
	state char(2),
	zip char(5),
	contract int NOT NULL,
	PRIMARY KEY (au_id)
);

CREATE TABLE jobs (
	job_id int NOT NULL,
	job_desc varchar(50) DEFAULT 'New Position - title not formalized yet' NOT NULL,
	min_lvl int NOT NULL,
	max_lvl int NOT NULL,
	PRIMARY KEY (job_id)
);

CREATE TABLE publishers (
	pub_id char(4) NOT NULL,
	pub_name varchar(40),
	city varchar(20),
	state char(2),
	country varchar(30) DEFAULT 'USA',
	PRIMARY KEY (pub_id)
);

CREATE TABLE stores (
	stor_id char(4) NOT NULL,
	stor_name varchar(40),
	stor_address varchar(40),
	city varchar(20),
	state char(2),
	zip char(5),
	PRIMARY KEY (stor_id)
);

CREATE TABLE titles (
	title_id varchar(6) NOT NULL,
	title varchar(80) NOT NULL,
	type char(12) DEFAULT 'UNDECIDED' NOT NULL,
	pub_id char(4),
	price decimal(19,4),
	advance decimal(19,4),
	royalty int,
	ytd_sales int,
	notes varchar(200),
   pubdate varchar(50)  DEFAULT (DATE('now')) NOT NULL,
	FOREIGN KEY (pub_id) REFERENCES publishers (pub_id),
	PRIMARY KEY (title_id)
);	

CREATE TABLE pub_info (
	pub_id char(4) NOT NULL,
	logo blob,
	pr_info clob,
	PRIMARY KEY (pub_id),
	FOREIGN KEY (pub_id) REFERENCES publishers (pub_id)
);

CREATE TABLE roysched (
	title_id varchar(6) NOT NULL,
	lorange int,
	hirange int,
	royalty int,
	FOREIGN KEY (title_id) REFERENCES titles (title_id)
);


CREATE TABLE discounts (
	discounttype varchar(40) NOT NULL,
	stor_id char(4),
	lowqty int,
	highqty int,
	discount decimal(4,2) NOT NULL,
	FOREIGN KEY (stor_id) 
	REFERENCES stores (stor_id)
);

CREATE TABLE titleauthor (
	au_id varchar(11) NOT NULL,
	title_id varchar(6) NOT NULL,
	au_ord int,
	royaltyper int,
	FOREIGN KEY (au_id) REFERENCES authors (au_id),
   FOREIGN KEY (title_id) REFERENCES titles (title_id),
	PRIMARY KEY (au_id,title_id)
);


CREATE TABLE employee (
	emp_id char(9) NOT NULL,
	fname varchar(20) NOT NULL,
	minit char(1),
	lname varchar(30) NOT NULL,
	job_id int DEFAULT ((1)) NOT NULL,
	job_lvl int DEFAULT ((10)),
	pub_id char(4) DEFAULT '9952' NOT NULL,
	hire_date varchar(50) DEFAULT (DATE('now')) NOT NULL,
	FOREIGN KEY (job_id) REFERENCES jobs (job_id),
	FOREIGN KEY (pub_id)  REFERENCES publishers (pub_id),
	PRIMARY KEY (emp_id)
);

CREATE TABLE sales (
	stor_id char(4) NOT NULL,
	ord_num varchar(20) NOT NULL,
	ord_date varchar(50) NOT NULL,
	qty int NOT NULL,
	payterms varchar(12) NOT NULL,
	title_id varchar(6) NOT NULL,
	PRIMARY KEY (ord_num,stor_id,title_id),
	FOREIGN KEY (stor_id) REFERENCES stores (stor_id)
	FOREIGN KEY (title_id) REFERENCES titles (title_id));



