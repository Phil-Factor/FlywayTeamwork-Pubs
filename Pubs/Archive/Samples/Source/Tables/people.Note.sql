CREATE TABLE [people].[Note]
(
[Note_id] [int] NOT NULL IDENTITY(1, 1),
[Note] [people].[PersonalNote] NOT NULL,
[NoteStart] AS (coalesce(left([Note],(850)),'Blank'+CONVERT([nvarchar](20),rand()*(20),(0)))),
[InsertionDate] [datetime] NOT NULL CONSTRAINT [NoteInsertionDateDL] DEFAULT (getdate()),
[InsertedBy] [sys].[sysname] NOT NULL CONSTRAINT [GetUserName] DEFAULT (user_name()),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [NoteModifiedDateD] DEFAULT (getdate())
)
GO
ALTER TABLE [people].[Note] ADD CONSTRAINT [NotePK] PRIMARY KEY CLUSTERED ([Note_id])
GO
EXEC sp_addextendedproperty N'MS_Description', N' a note relating to a customer ', 'SCHEMA', N'people', 'TABLE', N'Note', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Who inserted the note', 'SCHEMA', N'people', 'TABLE', N'Note', 'COLUMN', N'InsertedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when the note was inserted', 'SCHEMA', N'people', 'TABLE', N'Note', 'COLUMN', N'InsertionDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when the note  got changed', 'SCHEMA', N'people', 'TABLE', N'Note', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The actual text of the note', 'SCHEMA', N'people', 'TABLE', N'Note', 'COLUMN', N'Note'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Surrogate primary key for the Note', 'SCHEMA', N'people', 'TABLE', N'Note', 'COLUMN', N'Note_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'making it easier to search ...CONSTRAINT NoteStartUQ UNIQUE,', 'SCHEMA', N'people', 'TABLE', N'Note', 'COLUMN', N'NoteStart'
GO
