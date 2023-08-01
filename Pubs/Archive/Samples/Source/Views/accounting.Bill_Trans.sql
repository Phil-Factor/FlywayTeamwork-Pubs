SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [accounting].[Bill_Trans]
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
