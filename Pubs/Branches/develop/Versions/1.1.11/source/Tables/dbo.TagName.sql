CREATE TABLE [dbo].[TagName]
(
[TagName_ID] [int] NOT NULL IDENTITY(1, 1),
[Tag] [nvarchar] (80) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TagName] ADD CONSTRAINT [TagnameSurrogate] PRIMARY KEY CLUSTERED  ([TagName_ID])
GO
ALTER TABLE [dbo].[TagName] ADD CONSTRAINT [Uniquetag] UNIQUE NONCLUSTERED  ([Tag])
GO
