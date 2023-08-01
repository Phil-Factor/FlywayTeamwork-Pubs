CREATE TABLE [people].[WordOccurence]
(
[Item] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[location] [int] NOT NULL,
[Sequence] [int] NOT NULL,
[Note] [int] NOT NULL
)
GO
ALTER TABLE [people].[WordOccurence] ADD CONSTRAINT [PKWordOcurrence] PRIMARY KEY CLUSTERED ([Item], [Sequence], [Note])
GO
ALTER TABLE [people].[WordOccurence] ADD CONSTRAINT [FKWordOccurenceWord] FOREIGN KEY ([Item]) REFERENCES [people].[Word] ([Item])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Whereabouts the word was found in the text fiels within a table', 'SCHEMA', N'people', 'TABLE', N'WordOccurence', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'WordOccurence', 'COLUMN', N'Item'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'WordOccurence', 'COLUMN', N'location'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'WordOccurence', 'COLUMN', N'Note'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'WordOccurence', 'COLUMN', N'Sequence'
GO
