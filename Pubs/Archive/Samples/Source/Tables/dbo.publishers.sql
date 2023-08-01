CREATE TABLE [dbo].[publishers]
(
[pub_id] [char] (8) COLLATE Latin1_General_CI_AS NOT NULL,
[pub_name] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[city] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[state] [char] (2) COLLATE Latin1_General_CI_AS NULL,
[country] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [AssumeItsTheSatates] DEFAULT ('USA')
)
GO
ALTER TABLE [dbo].[publishers] ADD CONSTRAINT [CK__publisher__pub_id] CHECK (([pub_id]='1756' OR [pub_id]='1622' OR [pub_id]='0877' OR [pub_id]='0736' OR [pub_id]='1389' OR [pub_id] like '99[0-9][0-9]'))
GO
ALTER TABLE [dbo].[publishers] ADD CONSTRAINT [UPKCL_pubind] PRIMARY KEY CLUSTERED ([pub_id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'this is a table of publishers who we distribute books for', 'SCHEMA', N'dbo', 'TABLE', N'publishers', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the city where this publisher is based', 'SCHEMA', N'dbo', 'TABLE', N'publishers', 'COLUMN', N'city'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The country where this publisher is based', 'SCHEMA', N'dbo', 'TABLE', N'publishers', 'COLUMN', N'country'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the Publishers Table', 'SCHEMA', N'dbo', 'TABLE', N'publishers', 'COLUMN', N'pub_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name of the publisher', 'SCHEMA', N'dbo', 'TABLE', N'publishers', 'COLUMN', N'pub_name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Thge state where this publisher is based', 'SCHEMA', N'dbo', 'TABLE', N'publishers', 'COLUMN', N'state'
GO
