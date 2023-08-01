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
)
GO
ALTER TABLE [people].[Person] ADD CONSTRAINT [PersonIDPK] PRIMARY KEY CLUSTERED ([person_ID])
GO
CREATE NONCLUSTERED INDEX [SearchByPersonLastname] ON [people].[Person] ([LastName], [FirstName])
GO
EXEC sp_addextendedproperty N'MS_Description', N' This table represents a person- can be a customer or a member of staff,or someone in one of the outsourced support agencies', 'SCHEMA', N'people', 'TABLE', N'Person', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N' the person''s first name', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'FirstName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A calculated column', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'fullName'
GO
EXEC sp_addextendedproperty N'MS_Description', N' the lastname or surname ', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'LastName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'LegacyIdentifier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'any middle name ', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'MiddleName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when the record was last modified', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N' the way the person is usually addressed', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'Nickname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'person_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'any suffix used by the person', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'Suffix'
GO
EXEC sp_addextendedproperty N'MS_Description', N' the title (Mr, Mrs, Ms etc', 'SCHEMA', N'people', 'TABLE', N'Person', 'COLUMN', N'Title'
GO
