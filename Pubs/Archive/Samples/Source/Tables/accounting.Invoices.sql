CREATE TABLE [accounting].[Invoices]
(
[id] [int] NOT NULL,
[tran_date] [date] NOT NULL,
[due_date] [date] NULL,
[description] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[reference] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[total] [decimal] (10, 2) NOT NULL,
[status] [smallint] NULL,
[customer_id] [int] NULL,
[invoice_payment_id] [int] NULL,
[Chart_of_Accounts_id] [int] NOT NULL
)
GO
ALTER TABLE [accounting].[Invoices] ADD CONSTRAINT [PK__Invoices__3213E83F4046A87F] PRIMARY KEY CLUSTERED ([id])
GO
ALTER TABLE [accounting].[Invoices] ADD CONSTRAINT [FK__Invoices__Chart___33FF9E21] FOREIGN KEY ([Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
ALTER TABLE [accounting].[Invoices] ADD CONSTRAINT [FK__Invoices__custom__321755AF] FOREIGN KEY ([customer_id]) REFERENCES [accounting].[customer] ([id])
GO
ALTER TABLE [accounting].[Invoices] ADD CONSTRAINT [FK__Invoices__invoic__330B79E8] FOREIGN KEY ([invoice_payment_id]) REFERENCES [accounting].[Invoice_Payments] ([id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'Chart_of_Accounts_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'customer_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'due_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'invoice_payment_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'reference'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoices', 'COLUMN', N'tran_date'
GO
