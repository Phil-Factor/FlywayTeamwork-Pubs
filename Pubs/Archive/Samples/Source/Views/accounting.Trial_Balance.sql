SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [accounting].[Trial_Balance]
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
