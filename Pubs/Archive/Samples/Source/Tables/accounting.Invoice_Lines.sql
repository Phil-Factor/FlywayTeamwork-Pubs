CREATE TABLE [accounting].[Invoice_Lines]
(
[id] [int] NOT NULL,
[line_amount] [decimal] (20, 2) NOT NULL,
[invoice_id] [int] NULL,
[line_Chart_of_Accounts_id] [int] NOT NULL
)
GO
ALTER TABLE [accounting].[Invoice_Lines] ADD CONSTRAINT [PK__Invoice___3213E83F938F9E0B] PRIMARY KEY CLUSTERED ([id])
GO
ALTER TABLE [accounting].[Invoice_Lines] ADD CONSTRAINT [FK__Invoice_L__line___2F3AE904] FOREIGN KEY ([line_Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
ALTER TABLE [accounting].[Invoice_Lines] ADD CONSTRAINT [FK__Invoice_L__invoi__302F0D3D] FOREIGN KEY ([invoice_id]) REFERENCES [accounting].[Invoices] ([id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'joining table between Invoices and COA. An account may appear in multiple invoices and an invoice may have multiple accounts.', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Lines', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Lines', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Lines', 'COLUMN', N'invoice_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Lines', 'COLUMN', N'line_amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Lines', 'COLUMN', N'line_Chart_of_Accounts_id'
GO
