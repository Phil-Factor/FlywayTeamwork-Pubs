CREATE TABLE [people].[NotePerson]
(
[NotePerson_id] [int] NOT NULL IDENTITY(1, 1),
[Person_id] [int] NOT NULL,
[Note_id] [int] NOT NULL,
[InsertionDate] [datetime] NOT NULL CONSTRAINT [NotePersonInsertionDateD] DEFAULT (getdate()),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [NotePersonModifiedDateD] DEFAULT (getdate())
)
GO
ALTER TABLE [people].[NotePerson] ADD CONSTRAINT [NotePersonPK] PRIMARY KEY CLUSTERED ([NotePerson_id])
GO
ALTER TABLE [people].[NotePerson] ADD CONSTRAINT [DuplicateUK] UNIQUE NONCLUSTERED ([Person_id], [Note_id], [InsertionDate])
GO
ALTER TABLE [people].[NotePerson] ADD CONSTRAINT [NotePerson_NoteFK] FOREIGN KEY ([Note_id]) REFERENCES [people].[Note] ([Note_id])
GO
ALTER TABLE [people].[NotePerson] ADD CONSTRAINT [NotePerson_PersonFK] FOREIGN KEY ([Person_id]) REFERENCES [people].[Person] ([person_ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N' relates a note to a person ', 'SCHEMA', N'people', 'TABLE', N'NotePerson', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N' whan the note was inserted ', 'SCHEMA', N'people', 'TABLE', N'NotePerson', 'COLUMN', N'InsertionDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N' whan the association of note with person was last modified ', 'SCHEMA', N'people', 'TABLE', N'NotePerson', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'foreign key to the actual note', 'SCHEMA', N'people', 'TABLE', N'NotePerson', 'COLUMN', N'Note_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Surrogate primary key for the link table', 'SCHEMA', N'people', 'TABLE', N'NotePerson', 'COLUMN', N'NotePerson_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'foreign key to the person who has the addess', 'SCHEMA', N'people', 'TABLE', N'NotePerson', 'COLUMN', N'Person_id'
GO
