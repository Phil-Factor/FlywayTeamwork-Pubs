SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [accounting].[Spent_Money_Trans]
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
