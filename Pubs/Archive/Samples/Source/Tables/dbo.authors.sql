CREATE TABLE [dbo].[authors]
(
[au_id] [dbo].[id] NOT NULL,
[au_lname] [nvarchar] (80) COLLATE Latin1_General_CI_AS NOT NULL,
[au_fname] [nvarchar] (80) COLLATE Latin1_General_CI_AS NOT NULL,
[phone] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [AssumeUnknown] DEFAULT ('UNKNOWN'),
[address] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[city] [nvarchar] (40) COLLATE Latin1_General_CI_AS NULL,
[state] [char] (2) COLLATE Latin1_General_CI_AS NULL,
[zip] [char] (5) COLLATE Latin1_General_CI_AS NULL,
[contract] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[authors] ADD CONSTRAINT [CK__authors__au_id] CHECK (([au_id] like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[authors] ADD CONSTRAINT [CK__authors__zip] CHECK (([zip] like '[0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[authors] ADD CONSTRAINT [UPKCL_auidind] PRIMARY KEY CLUSTERED ([au_id])
GO
CREATE NONCLUSTERED INDEX [aunmind] ON [dbo].[authors] ([au_lname], [au_fname])
GO
EXEC sp_addextendedproperty N'MS_Description', N'The authors of the publications. a publication can have one or more author', 'SCHEMA', N'dbo', 'TABLE', N'authors', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the author=s firest line address', 'SCHEMA', N'dbo', 'TABLE', N'authors', 'COLUMN', N'address'
GO
EXEC sp_addextendedproperty N'MS_Description', N'first name of the author', 'SCHEMA', N'dbo', 'TABLE', N'authors', 'COLUMN', N'au_fname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The key to the Authors Table', 'SCHEMA', N'dbo', 'TABLE', N'authors', 'COLUMN', N'au_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'last name of the author', 'SCHEMA', N'dbo', 'TABLE', N'authors', 'COLUMN', N'au_lname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the city where the author lives', 'SCHEMA', N'dbo', 'TABLE', N'authors', 'COLUMN', N'city'
GO
EXEC sp_addextendedproperty N'MS_Description', N'had the author agreed a contract?', 'SCHEMA', N'dbo', 'TABLE', N'authors', 'COLUMN', N'contract'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the author''s phone number', 'SCHEMA', N'dbo', 'TABLE', N'authors', 'COLUMN', N'phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the state where the author lives', 'SCHEMA', N'dbo', 'TABLE', N'authors', 'COLUMN', N'state'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the zip of the address where the author lives', 'SCHEMA', N'dbo', 'TABLE', N'authors', 'COLUMN', N'zip'
GO
