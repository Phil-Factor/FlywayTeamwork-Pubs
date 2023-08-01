CREATE TABLE [dbo].[titleauthor]
(
[au_id] [dbo].[id] NOT NULL,
[title_id] [dbo].[tid] NOT NULL,
[au_ord] [tinyint] NULL,
[royaltyper] [int] NULL
)
GO
ALTER TABLE [dbo].[titleauthor] ADD CONSTRAINT [UPKCL_taind] PRIMARY KEY CLUSTERED ([au_id], [title_id])
GO
CREATE NONCLUSTERED INDEX [auidind] ON [dbo].[titleauthor] ([au_id])
GO
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[titleauthor] ([title_id])
GO
ALTER TABLE [dbo].[titleauthor] ADD CONSTRAINT [FK__titleauth__au_id] FOREIGN KEY ([au_id]) REFERENCES [dbo].[authors] ([au_id])
GO
ALTER TABLE [dbo].[titleauthor] ADD CONSTRAINT [FK__titleauth__title] FOREIGN KEY ([title_id]) REFERENCES [dbo].[publications] ([Publication_id]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'this is a table that relates authors to publications, and gives their order of listing and royalty', 'SCHEMA', N'dbo', 'TABLE', N'titleauthor', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key to the author', 'SCHEMA', N'dbo', 'TABLE', N'titleauthor', 'COLUMN', N'au_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N' the order in which authors are listed', 'SCHEMA', N'dbo', 'TABLE', N'titleauthor', 'COLUMN', N'au_ord'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the royalty percentage figure', 'SCHEMA', N'dbo', 'TABLE', N'titleauthor', 'COLUMN', N'royaltyper'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key to the publication', 'SCHEMA', N'dbo', 'TABLE', N'titleauthor', 'COLUMN', N'title_id'
GO
