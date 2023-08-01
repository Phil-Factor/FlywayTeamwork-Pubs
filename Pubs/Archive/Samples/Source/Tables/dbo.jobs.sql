CREATE TABLE [dbo].[jobs]
(
[job_id] [smallint] NOT NULL IDENTITY(1, 1),
[job_desc] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [AssumeANewPosition] DEFAULT ('New Position - title not formalized yet'),
[min_lvl] [tinyint] NOT NULL,
[max_lvl] [tinyint] NOT NULL
)
GO
ALTER TABLE [dbo].[jobs] ADD CONSTRAINT [CK__jobs__max_lvl] CHECK (([max_lvl]<=(250)))
GO
ALTER TABLE [dbo].[jobs] ADD CONSTRAINT [CK__jobs__min_lvl] CHECK (([min_lvl]>=(10)))
GO
ALTER TABLE [dbo].[jobs] ADD CONSTRAINT [PK__jobs__6E32B6A51A14E395] PRIMARY KEY CLUSTERED ([job_id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'These are the job descriptions and min/max salary level', 'SCHEMA', N'dbo', 'TABLE', N'jobs', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The description of the job', 'SCHEMA', N'dbo', 'TABLE', N'jobs', 'COLUMN', N'job_desc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the Jobs Table', 'SCHEMA', N'dbo', 'TABLE', N'jobs', 'COLUMN', N'job_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the maximum pay level appropriate for the job', 'SCHEMA', N'dbo', 'TABLE', N'jobs', 'COLUMN', N'max_lvl'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the minimum pay level appropriate for the job', 'SCHEMA', N'dbo', 'TABLE', N'jobs', 'COLUMN', N'min_lvl'
GO
