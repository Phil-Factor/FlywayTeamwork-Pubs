CREATE TABLE [accounting].[customer]
(
[id] [int] NOT NULL,
[person_id] [int] NULL,
[organisation_id] [int] NULL,
[CustomerFrom] [date] NOT NULL,
[CustomerTo] [date] NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF__customer__Modifi__23C93658] DEFAULT (getdate())
)
GO
ALTER TABLE [accounting].[customer] ADD CONSTRAINT [PK__customer__3213E83F2E301F63] PRIMARY KEY CLUSTERED ([id])
GO
ALTER TABLE [accounting].[customer] ADD CONSTRAINT [FK_organisation_id_organisation_id] FOREIGN KEY ([organisation_id]) REFERENCES [people].[Organisation] ([organisation_ID])
GO
ALTER TABLE [accounting].[customer] ADD CONSTRAINT [FK_person_id_Person_id] FOREIGN KEY ([person_id]) REFERENCES [people].[Person] ([person_ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'a customer can have many invoices but an invoice can’t belong to many customers', 'SCHEMA', N'accounting', 'TABLE', N'customer', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'customer', 'COLUMN', N'CustomerFrom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'customer', 'COLUMN', N'CustomerTo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'customer', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'customer', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'customer', 'COLUMN', N'organisation_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'customer', 'COLUMN', N'person_id'
GO
