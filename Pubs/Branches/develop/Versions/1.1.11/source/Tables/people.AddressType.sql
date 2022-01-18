CREATE TABLE [people].[AddressType]
(
[TypeOfAddress] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [AddressTypeModifiedDateD] DEFAULT (getdate())
)
GO
ALTER TABLE [people].[AddressType] ADD CONSTRAINT [TypeOfAddressPK] PRIMARY KEY CLUSTERED  ([TypeOfAddress])
GO
