SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [accounting].[Invoice_Trans]
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
