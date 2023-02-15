/* Pubs Accounting package */
CREATE TABLE accounting.Chart_of_Accounts (id INTEGER PRIMARY KEY, Name VARCHAR(50) UNIQUE);
INSERT INTO accounting.Chart_of_Accounts (id, Name)
  SELECT f.id, f.name
    FROM
      (VALUES (110, 'Business Bank Account'), (120, 'Accounts Receivable'),
              (130, 'Petty Cash'), (135, 'Provision for Doubtful Debts'),
              (140, 'Prepayments'), (150, 'Withholding Tax Paid'),
              (160, 'Inventory'), (165, 'Provision for Stock Obsolence'),
              (170, 'Land'), (180, 'Building'),
              (185, 'Accumulated Depreciation on Building'),
              (190, 'Office Equipment'),
              (195, 'Accumulated Depreciation on Office Equipment'),
              (200, 'Computer Equipment'),
              (205, 'Accumulated Depreciation on Computer Equipment'),
              (210, 'Furniture'),
              (215, 'Accumulated Depreciation on Furniture'),
              (220, 'Motor Vehicles'),
              (225, 'Accumulated Depreciation on Motor Vehicles'),
              (310, 'Accounts Payable'), (320, 'Accrued Expenses'),
              (330, 'Revenue Received in Advance'),
              (340, 'Wages Payable - Payroll'),
              (350, 'Wages Deductions Payable'), (360, 'Income Tax'),
              (370, 'Finance Lease'), (380, 'Loans Payable'),
              (410, 'Owner - Investments'), (420, 'Owner - Drawings'),
              (430, 'Retained Earnings'), (510, 'Sales'),
              (520, 'Other Revenue'), (530, 'Interest Income'),
              (540, 'Dividends Received'), (610, 'Cost of Goods Sold'),
              (620, 'General Expenses'), (630, 'Supplies Expense'),
              (640, 'Advertising'), (650, 'Consulting & Accounting'),
              (660, 'Depreciation'), (670, 'Entertainment'),
              (680, 'Freight & Courier'), (690, 'Insurance'),
              (700, 'Legal expenses'), (710, 'Electricity'),
              (720, 'Motor Vehicle Expenses'), (730, 'Office Expenses'),
              (740, 'Printing & Stationery'), (750, 'Rates'), (760, 'Rent'),
              (770, 'Repairs and Maintenance'), (780, 'Salaries'),
              (790, 'Subscriptions'), (800, 'Telephone & Internet'),
              (810, 'Travel Expenses'), (820, 'Bank Fees'),
              (830, 'Interest Expense'), (840, 'Income Tax Expense')) f (id,
                                                                         name);

CREATE TABLE accounting.customer /* 
a customer can have many invoices but 
an invoice can’t belong to many customers*/
  (id INTEGER PRIMARY KEY,
   person_id INT NULL
     CONSTRAINT FK_person_id_Person_id
     REFERENCES people.Person (person_ID),
   organisation_id INT NULL
     CONSTRAINT FK_organisation_id_organisation_id
     REFERENCES people.Organisation (organisation_ID),
   CustomerFrom [DATE] NOT NULL,
   CustomerTo [DATE] NULL,
   [ModifiedDate] [DATETIME] NOT NULL
     DEFAULT GetDate ());

CREATE TABLE accounting.Invoice_Payments
  /* There’s a one-to-many 
relationship between Invoice_Payments and Invoices 
respectively (no partial payments) */
  (id INTEGER PRIMARY KEY,
   tran_date DATE NOT NULL,
   description NVARCHAR(MAX) NOT NULL, --Receipt from organisation, Receipt from individual
   reference NVARCHAR(MAX) NOT NULL,
   total DECIMAL(20, 2) NOT NULL,
   Chart_of_Accounts_id INTEGER NOT NULL,
   [ModifiedDate] [DATETIME] NOT NULL
     DEFAULT GetDate (),
   FOREIGN KEY (Chart_of_Accounts_id) REFERENCES accounting.Chart_of_Accounts
     (id));

CREATE TABLE accounting.Invoices
  (id INTEGER PRIMARY KEY,
   tran_date DATE NOT NULL,
   due_date DATE NULL,
   description NVARCHAR(MAX),
   reference NVARCHAR(MAX),
   total DECIMAL(10, 2) NOT NULL,
   status SMALLINT,
   customer_id INTEGER,
   invoice_payment_id INTEGER,
   Chart_of_Accounts_id INTEGER NOT NULL, -- automatically AR
   FOREIGN KEY (customer_id) REFERENCES accounting.customer (id),
   FOREIGN KEY (invoice_payment_id) REFERENCES accounting.Invoice_Payments
     (id),
   FOREIGN KEY (Chart_of_Accounts_id) REFERENCES accounting.Chart_of_Accounts
     (id));

CREATE TABLE accounting.Received_Moneys
  /* may have an optional Customer*/
  (id INTEGER PRIMARY KEY,
   tran_date DATE NOT NULL,
   description NVARCHAR(MAX),             --eg Interest from bank, Proceeds from shares issue
   reference NVARCHAR(MAX),
   total DECIMAL(20, 2) NOT NULL,
   customer_id INTEGER NOT NULL,
   Chart_of_Accounts_id INTEGER NOT NULL, -- automatically Bank
   FOREIGN KEY (customer_id) REFERENCES accounting.customer (id),
   FOREIGN KEY (Chart_of_Accounts_id) REFERENCES accounting.Chart_of_Accounts
     (id));

CREATE TABLE accounting.Invoice_Lines
  /* this is the joining table between Invoices and Chart_of_Accounts. 
An account may appear in multiple invoices and an invoice may have multiple accounts. */
  (id INTEGER PRIMARY KEY,
   line_amount DECIMAL(20, 2) NOT NULL,
   invoice_id INTEGER,
   line_Chart_of_Accounts_id INTEGER NOT NULL,
   FOREIGN KEY (invoice_id) REFERENCES accounting.Invoices (id),
   FOREIGN KEY (line_Chart_of_Accounts_id) REFERENCES accounting.Chart_of_Accounts
     (id));

CREATE TABLE accounting.Received_Money_Lines
  /* this is the joining table between Received_Moneys and Chart_of_Accounts*/
  (id INTEGER PRIMARY KEY,
   line_amount DECIMAL(20, 2) NOT NULL,
   received_money_id INTEGER,
   line_Chart_of_Accounts_id INTEGER NOT NULL,
   FOREIGN KEY (received_money_id) REFERENCES accounting.Received_Moneys (id),
   FOREIGN KEY (line_Chart_of_Accounts_id) REFERENCES accounting.Chart_of_Accounts
     (id));

CREATE TABLE accounting.Suppliers /*
a supplier can have many bills but a bill can’t belong to many suppliers*/
  (id INTEGER PRIMARY KEY,
   supplier_id INT NULL
     CONSTRAINT FK_supplier_id_organisation_id
     REFERENCES people.Organisation (organisation_ID),
   contact_id INT NULL
     CONSTRAINT FK_contact_id_organisation_id
     REFERENCES people.Organisation (organisation_ID),
   CustomerFrom [DATE] NOT NULL,
   CustomerTo [DATE] NULL,
   [ModifiedDate] [DATETIME] NOT NULL
     DEFAULT GetDate ());

CREATE TABLE accounting.Bill_Payments
  /* there’s a one-to-many relationship between Bill_Payments and Bills respectively */
  (id INTEGER PRIMARY KEY,
   tran_date DATE NOT NULL,
   description NVARCHAR(MAX),             --Purchase FA
   reference NVARCHAR(MAX),
   total DECIMAL(20, 2) NOT NULL,
   Chart_of_Accounts_id INTEGER NOT NULL, -- automatically Bank
   FOREIGN KEY (Chart_of_Accounts_id) REFERENCES accounting.Chart_of_Accounts
     (id));

CREATE TABLE accounting.Bills
  (id INTEGER PRIMARY KEY,
   tran_date DATE NOT NULL,
   due_date DATE,
   description NVARCHAR(MAX),
   reference NVARCHAR(MAX),
   total DECIMAL(10, 2) NOT NULL,
   status SMALLINT,
   supplier_id INTEGER,
   bill_payment_id INTEGER,
   Chart_of_Accounts_id INTEGER NOT NULL, -- automatically AP
   FOREIGN KEY (supplier_id) REFERENCES accounting.Suppliers (id),
   FOREIGN KEY (bill_payment_id) REFERENCES accounting.Bill_Payments (id),
   FOREIGN KEY (Chart_of_Accounts_id) REFERENCES accounting.Chart_of_Accounts
     (id));

CREATE TABLE accounting.Spent_Moneys /* may have an optional Supplier*/
  (id INTEGER PRIMARY KEY,
   tran_date DATE NOT NULL,
   description NVARCHAR(MAX),             --Payment of interest or Payment of taxes
   reference NVARCHAR(MAX),
   total DECIMAL(20, 2) NOT NULL,
   supplier_id INTEGER,
   Chart_of_Accounts_id INTEGER NOT NULL, -- automatically Bank
   FOREIGN KEY (supplier_id) REFERENCES accounting.Suppliers (id),
   FOREIGN KEY (Chart_of_Accounts_id) REFERENCES accounting.Chart_of_Accounts
     (id));

CREATE TABLE accounting.Bill_Lines
  /* this is the joining table between Bills and Chart_of_Accounts. An account may appear
in multiple bills and a bill may have multiple accounts.*/
  (id INTEGER PRIMARY KEY,
   line_amount DECIMAL(20, 2) NOT NULL,
   bill_id INTEGER,
   line_Chart_of_Accounts_id INTEGER NOT NULL,
   FOREIGN KEY (bill_id) REFERENCES accounting.Bills (id),
   FOREIGN KEY (line_Chart_of_Accounts_id) REFERENCES accounting.Chart_of_Accounts
     (id));

CREATE TABLE accounting.Spent_Money_Lines /* This is the joining table
between Spent_Moneys and Chart_of_Accounts*/
  (id INTEGER PRIMARY KEY,
   line_amount DECIMAL(20, 2) NOT NULL,
   spent_money_id INTEGER,
   line_Chart_of_Accounts_id INTEGER NOT NULL,
   FOREIGN KEY (spent_money_id) REFERENCES accounting.Spent_Moneys (id),
   FOREIGN KEY (line_Chart_of_Accounts_id) REFERENCES accounting.Chart_of_Accounts
     (id));
GO
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

