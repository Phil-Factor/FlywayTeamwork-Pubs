CREATE TABLE [accounting].[Invoice_Payments]
(
[id] [int] NOT NULL,
[tran_date] [date] NOT NULL,
[description] [nvarchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[reference] [nvarchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[total] [decimal] (20, 2) NOT NULL,
[Chart_of_Accounts_id] [int] NOT NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF__Invoice_P__Modif__24BD5A91] DEFAULT (getdate())
)
GO
ALTER TABLE [accounting].[Invoice_Payments] ADD CONSTRAINT [PK__Invoice___3213E83F09263632] PRIMARY KEY CLUSTERED ([id])
GO
ALTER TABLE [accounting].[Invoice_Payments] ADD CONSTRAINT [FK__Invoice_P__Chart__31233176] FOREIGN KEY ([Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'one-to-many relationship between Invoice_Payments and Invoices respectively (no partial payments)', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Payments', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Payments', 'COLUMN', N'Chart_of_Accounts_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Payments', 'COLUMN', N'description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Payments', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Payments', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Payments', 'COLUMN', N'reference'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Payments', 'COLUMN', N'total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Invoice_Payments', 'COLUMN', N'tran_date'
GO
