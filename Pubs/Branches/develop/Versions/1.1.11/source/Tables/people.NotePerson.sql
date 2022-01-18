CREATE TABLE [people].[NotePerson]
(
[NotePerson_id] [int] NOT NULL IDENTITY(1, 1),
[Person_id] [int] NOT NULL,
[Note_id] [int] NOT NULL,
[InsertionDate] [datetime] NOT NULL CONSTRAINT [NotePersonInsertionDateD] DEFAULT (getdate()),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [NotePersonModifiedDateD] DEFAULT (getdate())
)
GO
ALTER TABLE [people].[NotePerson] ADD CONSTRAINT [NotePersonPK] PRIMARY KEY CLUSTERED  ([NotePerson_id])
GO
ALTER TABLE [people].[NotePerson] ADD CONSTRAINT [DuplicateUK] UNIQUE NONCLUSTERED  ([Person_id], [Note_id], [InsertionDate])
GO
ALTER TABLE [people].[NotePerson] ADD CONSTRAINT [NotePerson_NoteFK] FOREIGN KEY ([Note_id]) REFERENCES [people].[Note] ([Note_id])
GO
ALTER TABLE [people].[NotePerson] ADD CONSTRAINT [NotePerson_PersonFK] FOREIGN KEY ([Person_id]) REFERENCES [people].[Person] ([person_ID])
GO
