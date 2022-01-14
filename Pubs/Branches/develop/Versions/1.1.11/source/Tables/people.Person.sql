CREATE TABLE [people].[Person]
(
[person_ID] [int] NOT NULL IDENTITY(1, 1),
[Title] [people].[PersonalTitle] NULL,
[Nickname] [people].[PersonalName] NULL,
[FirstName] [people].[PersonalName] NOT NULL,
[MiddleName] [people].[PersonalName] NULL,
[LastName] [people].[PersonalName] NOT NULL,
[Suffix] [people].[PersonalSuffix] NULL,
[fullName] AS (((((coalesce([Title]+' ','')+[FirstName])+coalesce(' '+[MiddleName],''))+' ')+[LastName])+coalesce(' '+[Suffix],'')),
[LegacyIdentifier] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [PersonModifiedDateD] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [people].[Person] ADD CONSTRAINT [PersonIDPK] PRIMARY KEY CLUSTERED  ([person_ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SearchByPersonLastname] ON [people].[Person] ([LastName], [FirstName]) ON [PRIMARY]
GO
