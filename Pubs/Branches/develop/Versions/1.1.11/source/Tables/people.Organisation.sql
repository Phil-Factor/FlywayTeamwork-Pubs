CREATE TABLE [people].[Organisation]
(
[organisation_ID] [int] NOT NULL IDENTITY(1, 1),
[OrganisationName] [nvarchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[LineOfBusiness] [nvarchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[LegacyIdentifier] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [organisationModifiedDateD] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [people].[Organisation] ADD CONSTRAINT [organisationIDPK] PRIMARY KEY CLUSTERED  ([organisation_ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SearchByOrganisationName] ON [people].[Organisation] ([OrganisationName]) ON [PRIMARY]
GO
