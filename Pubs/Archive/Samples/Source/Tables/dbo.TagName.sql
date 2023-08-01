CREATE TABLE [dbo].[TagName]
(
[TagName_ID] [int] NOT NULL IDENTITY(1, 1),
[Tag] [nvarchar] (80) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TagName] ADD CONSTRAINT [TagnameSurrogate] PRIMARY KEY CLUSTERED ([TagName_ID])
GO
ALTER TABLE [dbo].[TagName] ADD CONSTRAINT [Uniquetag] UNIQUE NONCLUSTERED ([Tag])
GO
EXEC sp_addextendedproperty N'MS_Description', N'All the categories of publications', 'SCHEMA', N'dbo', 'TABLE', N'TagName', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the name of the tag', 'SCHEMA', N'dbo', 'TABLE', N'TagName', 'COLUMN', N'Tag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the Tag Table', 'SCHEMA', N'dbo', 'TABLE', N'TagName', 'COLUMN', N'TagName_ID'
GO
