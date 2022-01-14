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
) ON [PRIMARY]
GO
ALTER TABLE [people].[Address] ADD CONSTRAINT [Address_Not_Complete] CHECK ((coalesce([AddressLine1],[AddressLine2],[City],[PostalCode]) IS NOT NULL))
GO
ALTER TABLE [people].[Address] ADD CONSTRAINT [AddressPK] PRIMARY KEY CLUSTERED  ([Address_ID]) ON [PRIMARY]
GO
