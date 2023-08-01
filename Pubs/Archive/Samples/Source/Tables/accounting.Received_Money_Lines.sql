CREATE TABLE [accounting].[Received_Money_Lines]
(
[id] [int] NOT NULL,
[line_amount] [decimal] (20, 2) NOT NULL,
[received_money_id] [int] NULL,
[line_Chart_of_Accounts_id] [int] NOT NULL
)
GO
ALTER TABLE [accounting].[Received_Money_Lines] ADD CONSTRAINT [PK__Received__3213E83F8AB14401] PRIMARY KEY CLUSTERED ([id])
GO
ALTER TABLE [accounting].[Received_Money_Lines] ADD CONSTRAINT [FK__Received___line___35E7E693] FOREIGN KEY ([line_Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
ALTER TABLE [accounting].[Received_Money_Lines] ADD CONSTRAINT [FK__Received___recei__34F3C25A] FOREIGN KEY ([received_money_id]) REFERENCES [accounting].[Received_Moneys] ([id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'this is the joining table between Received_Moneys and COA', 'SCHEMA', N'accounting', 'TABLE', N'Received_Money_Lines', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Money_Lines', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Money_Lines', 'COLUMN', N'line_amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Money_Lines', 'COLUMN', N'line_Chart_of_Accounts_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Money_Lines', 'COLUMN', N'received_money_id'
GO
