CREATE TABLE [accounting].[Spent_Money_Lines]
(
[id] [int] NOT NULL,
[line_amount] [decimal] (20, 2) NOT NULL,
[spent_money_id] [int] NULL,
[line_Chart_of_Accounts_id] [int] NOT NULL
)
GO
ALTER TABLE [accounting].[Spent_Money_Lines] ADD CONSTRAINT [PK__Spent_Mo__3213E83FF1621D0E] PRIMARY KEY CLUSTERED ([id])
GO
ALTER TABLE [accounting].[Spent_Money_Lines] ADD CONSTRAINT [FK__Spent_Mon__line___39B87777] FOREIGN KEY ([line_Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
ALTER TABLE [accounting].[Spent_Money_Lines] ADD CONSTRAINT [FK__Spent_Mon__spent__38C4533E] FOREIGN KEY ([spent_money_id]) REFERENCES [accounting].[Spent_Moneys] ([id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'this is the joining table between Spent_Moneys and COA', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Money_Lines', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Money_Lines', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Money_Lines', 'COLUMN', N'line_amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Money_Lines', 'COLUMN', N'line_Chart_of_Accounts_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Money_Lines', 'COLUMN', N'spent_money_id'
GO
