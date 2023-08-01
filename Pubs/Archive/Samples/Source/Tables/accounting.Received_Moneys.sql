CREATE TABLE [accounting].[Received_Moneys]
(
[id] [int] NOT NULL,
[tran_date] [date] NOT NULL,
[description] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[reference] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[total] [decimal] (20, 2) NOT NULL,
[customer_id] [int] NOT NULL,
[Chart_of_Accounts_id] [int] NOT NULL
)
GO
ALTER TABLE [accounting].[Received_Moneys] ADD CONSTRAINT [PK__Received__3213E83F7A768F35] PRIMARY KEY CLUSTERED ([id])
GO
ALTER TABLE [accounting].[Received_Moneys] ADD CONSTRAINT [FK__Received___Chart__37D02F05] FOREIGN KEY ([Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
ALTER TABLE [accounting].[Received_Moneys] ADD CONSTRAINT [FK__Received___custo__36DC0ACC] FOREIGN KEY ([customer_id]) REFERENCES [accounting].[customer] ([id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'may have an optional Customer', 'SCHEMA', N'accounting', 'TABLE', N'Received_Moneys', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Moneys', 'COLUMN', N'Chart_of_Accounts_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Moneys', 'COLUMN', N'customer_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Moneys', 'COLUMN', N'description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Moneys', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Moneys', 'COLUMN', N'reference'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Moneys', 'COLUMN', N'total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Received_Moneys', 'COLUMN', N'tran_date'
GO
