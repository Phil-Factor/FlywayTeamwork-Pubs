CREATE TABLE [accounting].[Bill_Payments]
(
[id] [int] NOT NULL,
[tran_date] [date] NOT NULL,
[description] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[reference] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[total] [decimal] (20, 2) NOT NULL,
[Chart_of_Accounts_id] [int] NOT NULL
)
GO
ALTER TABLE [accounting].[Bill_Payments] ADD CONSTRAINT [PK__Bill_Pay__3213E83F79E72DBA] PRIMARY KEY CLUSTERED ([id])
GO
ALTER TABLE [accounting].[Bill_Payments] ADD CONSTRAINT [FK__Bill_Paym__Chart__29820FAE] FOREIGN KEY ([Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'payments of the outstanding Bills. there’s a one-to-many relationship between Bill_Payments and Bills respectively', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Payments', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Payments', 'COLUMN', N'Chart_of_Accounts_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Payments', 'COLUMN', N'description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Payments', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Payments', 'COLUMN', N'reference'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Payments', 'COLUMN', N'total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Payments', 'COLUMN', N'tran_date'
GO
