CREATE TABLE [accounting].[Suppliers]
(
[id] [int] NOT NULL,
[supplier_id] [int] NULL,
[contact_id] [int] NULL,
[CustomerFrom] [date] NOT NULL,
[CustomerTo] [date] NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF__Suppliers__Modif__25B17ECA] DEFAULT (getdate())
)
GO
ALTER TABLE [accounting].[Suppliers] ADD CONSTRAINT [PK__Supplier__3213E83FDDD2CA08] PRIMARY KEY CLUSTERED ([id])
GO
ALTER TABLE [accounting].[Suppliers] ADD CONSTRAINT [FK_contact_id_organisation_id] FOREIGN KEY ([contact_id]) REFERENCES [people].[Organisation] ([organisation_ID])
GO
ALTER TABLE [accounting].[Suppliers] ADD CONSTRAINT [FK_supplier_id_organisation_id] FOREIGN KEY ([supplier_id]) REFERENCES [people].[Organisation] ([organisation_ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'a supplier can have many bills but a bill can’t belong to many suppliers', 'SCHEMA', N'accounting', 'TABLE', N'Suppliers', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Suppliers', 'COLUMN', N'contact_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Suppliers', 'COLUMN', N'CustomerFrom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Suppliers', 'COLUMN', N'CustomerTo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Suppliers', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Suppliers', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Suppliers', 'COLUMN', N'supplier_id'
GO
