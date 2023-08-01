CREATE TABLE [accounting].[Spent_Moneys]
(
[id] [int] NOT NULL,
[tran_date] [date] NOT NULL,
[description] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[reference] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[total] [decimal] (20, 2) NOT NULL,
[supplier_id] [int] NULL,
[Chart_of_Accounts_id] [int] NOT NULL
)
GO
ALTER TABLE [accounting].[Spent_Moneys] ADD CONSTRAINT [PK__Spent_Mo__3213E83FC36C739E] PRIMARY KEY CLUSTERED ([id])
GO
ALTER TABLE [accounting].[Spent_Moneys] ADD CONSTRAINT [FK__Spent_Mon__Chart__3AAC9BB0] FOREIGN KEY ([Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
ALTER TABLE [accounting].[Spent_Moneys] ADD CONSTRAINT [FK__Spent_Mon__suppl__3BA0BFE9] FOREIGN KEY ([supplier_id]) REFERENCES [accounting].[Suppliers] ([id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'cash disbursements that are not bill payments. This may involve cash purchases but if you’re going to issue a bill, use the Bills feature', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Moneys', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Moneys', 'COLUMN', N'Chart_of_Accounts_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Moneys', 'COLUMN', N'description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Moneys', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Moneys', 'COLUMN', N'reference'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Moneys', 'COLUMN', N'supplier_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Moneys', 'COLUMN', N'total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Spent_Moneys', 'COLUMN', N'tran_date'
GO
