CREATE TABLE [accounting].[Bills]
(
[id] [int] NOT NULL,
[tran_date] [date] NOT NULL,
[due_date] [date] NULL,
[description] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[reference] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[total] [decimal] (10, 2) NOT NULL,
[status] [smallint] NULL,
[supplier_id] [int] NULL,
[bill_payment_id] [int] NULL,
[Chart_of_Accounts_id] [int] NOT NULL
)
GO
ALTER TABLE [accounting].[Bills] ADD CONSTRAINT [PK__Bills__3213E83FA09F8C93] PRIMARY KEY CLUSTERED ([id])
GO
ALTER TABLE [accounting].[Bills] ADD CONSTRAINT [FK__Bills__bill_paym__2C5E7C59] FOREIGN KEY ([bill_payment_id]) REFERENCES [accounting].[Bill_Payments] ([id])
GO
ALTER TABLE [accounting].[Bills] ADD CONSTRAINT [FK__Bills__Chart_of___2A7633E7] FOREIGN KEY ([Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
ALTER TABLE [accounting].[Bills] ADD CONSTRAINT [FK__Bills__supplier___2B6A5820] FOREIGN KEY ([supplier_id]) REFERENCES [accounting].[Suppliers] ([id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'bill_payment_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'Chart_of_Accounts_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'due_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'reference'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'supplier_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bills', 'COLUMN', N'tran_date'
GO
