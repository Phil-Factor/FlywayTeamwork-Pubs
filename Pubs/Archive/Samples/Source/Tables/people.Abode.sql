CREATE TABLE [people].[Abode]
(
[Abode_ID] [int] NOT NULL IDENTITY(1, 1),
[Person_id] [int] NOT NULL,
[Address_id] [int] NOT NULL,
[TypeOfAddress] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[Start_date] [datetime] NOT NULL,
[End_date] [datetime] NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [AbodeModifiedD] DEFAULT (getdate())
)
GO
ALTER TABLE [people].[Abode] ADD CONSTRAINT [AbodePK] PRIMARY KEY CLUSTERED ([Abode_ID])
GO
ALTER TABLE [people].[Abode] ADD CONSTRAINT [Abode_AddressFK] FOREIGN KEY ([Address_id]) REFERENCES [people].[Address] ([Address_ID])
GO
ALTER TABLE [people].[Abode] ADD CONSTRAINT [Abode_AddressTypeFK] FOREIGN KEY ([TypeOfAddress]) REFERENCES [people].[AddressType] ([TypeOfAddress])
GO
ALTER TABLE [people].[Abode] ADD CONSTRAINT [Abode_PersonFK] FOREIGN KEY ([Person_id]) REFERENCES [people].[Person] ([person_ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N' an abode describes the association has with an address and the period of time when the person had that association', 'SCHEMA', N'people', 'TABLE', N'Abode', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the surrogate key for the place to which the person is associated', 'SCHEMA', N'people', 'TABLE', N'Abode', 'COLUMN', N'Abode_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the id of the address', 'SCHEMA', N'people', 'TABLE', N'Abode', 'COLUMN', N'Address_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when this relationship ended', 'SCHEMA', N'people', 'TABLE', N'Abode', 'COLUMN', N'End_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when this record was last modified', 'SCHEMA', N'people', 'TABLE', N'Abode', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the id of the person', 'SCHEMA', N'people', 'TABLE', N'Abode', 'COLUMN', N'Person_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when this relationship started ', 'SCHEMA', N'people', 'TABLE', N'Abode', 'COLUMN', N'Start_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the type of address', 'SCHEMA', N'people', 'TABLE', N'Abode', 'COLUMN', N'TypeOfAddress'
GO
