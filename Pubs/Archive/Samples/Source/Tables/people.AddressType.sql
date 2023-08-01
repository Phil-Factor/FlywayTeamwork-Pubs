CREATE TABLE [people].[AddressType]
(
[TypeOfAddress] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [AddressTypeModifiedDateD] DEFAULT (getdate())
)
GO
ALTER TABLE [people].[AddressType] ADD CONSTRAINT [TypeOfAddressPK] PRIMARY KEY CLUSTERED ([TypeOfAddress])
GO
EXEC sp_addextendedproperty N'MS_Description', N' the way that a particular customer is using the address (e.g. Home, Office, hotel etc ', 'SCHEMA', N'people', 'TABLE', N'AddressType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'when was this record LAST modified', 'SCHEMA', N'people', 'TABLE', N'AddressType', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'description of the type of address', 'SCHEMA', N'people', 'TABLE', N'AddressType', 'COLUMN', N'TypeOfAddress'
GO
