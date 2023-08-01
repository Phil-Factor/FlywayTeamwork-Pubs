CREATE TABLE [dbo].[roysched]
(
[title_id] [dbo].[tid] NOT NULL,
[lorange] [int] NULL,
[hirange] [int] NULL,
[royalty] [int] NULL,
[roysched_id] [int] NOT NULL IDENTITY(1, 1)
)
GO
ALTER TABLE [dbo].[roysched] ADD CONSTRAINT [PK_Roysched] PRIMARY KEY CLUSTERED ([roysched_id])
GO
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[roysched] ([title_id])
GO
ALTER TABLE [dbo].[roysched] ADD CONSTRAINT [FK__roysched__title] FOREIGN KEY ([title_id]) REFERENCES [dbo].[publications] ([Publication_id]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'this is a table of the authors royalty schedule', 'SCHEMA', N'dbo', 'TABLE', N'roysched', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the highest range to which this royalty applies', 'SCHEMA', N'dbo', 'TABLE', N'roysched', 'COLUMN', N'hirange'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the lowest range to which the royalty applies', 'SCHEMA', N'dbo', 'TABLE', N'roysched', 'COLUMN', N'lorange'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the royalty', 'SCHEMA', N'dbo', 'TABLE', N'roysched', 'COLUMN', N'royalty'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the RoySched Table', 'SCHEMA', N'dbo', 'TABLE', N'roysched', 'COLUMN', N'roysched_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The title to which this applies', 'SCHEMA', N'dbo', 'TABLE', N'roysched', 'COLUMN', N'title_id'
GO
