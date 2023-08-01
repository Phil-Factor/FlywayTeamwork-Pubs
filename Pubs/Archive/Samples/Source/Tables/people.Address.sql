CREATE TABLE [people].[Address]
(
[Address_ID] [int] NOT NULL IDENTITY(1, 1),
[AddressLine1] [people].[PersonalAddressline] NULL,
[AddressLine2] [people].[PersonalAddressline] NULL,
[City] [people].[PersonalLocation] NULL,
[Region] [people].[PersonalLocation] NULL,
[PostalCode] [people].[PersonalPostalCode] NULL,
[country] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Full_Address] AS (stuff((((coalesce(', '+[AddressLine1],'')+coalesce(', '+[AddressLine2],''))+coalesce(', '+[City],''))+coalesce(', '+[Region],''))+coalesce(', '+[PostalCode],''),(1),(2),'')),
[LegacyIdentifier] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [AddressModifiedDateD] DEFAULT (getdate())
)
GO
ALTER TABLE [people].[Address] ADD CONSTRAINT [Address_Not_Complete] CHECK ((coalesce([AddressLine1],[AddressLine2],[City],[PostalCode]) IS NOT NULL))
GO
ALTER TABLE [people].[Address] ADD CONSTRAINT [AddressPK] PRIMARY KEY CLUSTERED ([Address_ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'This contains the details of an addresss,
any address, it can be a home, office, factory or whatever ', 'SCHEMA', N'people', 'TABLE', N'Address', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'surrogate key ', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'Address_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'first line address', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'AddressLine1'
GO
EXEC sp_addextendedproperty N'MS_Description', N' second line address ', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'AddressLine2'
GO
EXEC sp_addextendedproperty N'MS_Description', N' the city ', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'country'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A calculated column', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'Full_Address'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'LegacyIdentifier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when the record was last modified', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'PostalCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Address', 'COLUMN', N'Region'
GO
