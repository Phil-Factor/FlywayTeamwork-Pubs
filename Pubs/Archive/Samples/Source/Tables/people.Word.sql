CREATE TABLE [people].[Word]
(
[Item] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[frequency] [int] NOT NULL CONSTRAINT [DF__Word__frequency__26A5A303] DEFAULT ((0))
)
GO
ALTER TABLE [people].[Word] ADD CONSTRAINT [PKWord] PRIMARY KEY CLUSTERED ([Item])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Words used in the notes with their frequency, used for searching notes', 'SCHEMA', N'people', 'TABLE', N'Word', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Word', 'COLUMN', N'frequency'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Word', 'COLUMN', N'Item'
GO
