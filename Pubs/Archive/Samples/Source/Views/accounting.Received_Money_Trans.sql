SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [accounting].[Received_Money_Trans]
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
