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
ALTER TABLE [people].[Note] ADD CONSTRAINT [NotePK] PRIMARY KEY CLUSTERED  ([Note_id])
GO
