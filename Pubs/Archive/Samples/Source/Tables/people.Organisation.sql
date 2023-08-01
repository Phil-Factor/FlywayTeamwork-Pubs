CREATE TABLE [people].[Organisation]
(
[organisation_ID] [int] NOT NULL IDENTITY(1, 1),
[OrganisationName] [nvarchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[LineOfBusiness] [nvarchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[LegacyIdentifier] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [organisationModifiedDateD] DEFAULT (getdate())
)
GO
ALTER TABLE [people].[Organisation] ADD CONSTRAINT [organisationIDPK] PRIMARY KEY CLUSTERED ([organisation_ID])
GO
CREATE NONCLUSTERED INDEX [SearchByOrganisationName] ON [people].[Organisation] ([OrganisationName])
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Organisation', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Organisation', 'COLUMN', N'LegacyIdentifier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Organisation', 'COLUMN', N'LineOfBusiness'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Organisation', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Organisation', 'COLUMN', N'organisation_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Organisation', 'COLUMN', N'OrganisationName'
GO
