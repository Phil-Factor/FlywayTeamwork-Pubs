CREATE TABLE [dbo].[employee]
(
[emp_id] [dbo].[empid] NOT NULL,
[fname] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[minit] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[lname] [nvarchar] (60) COLLATE Latin1_General_CI_AS NOT NULL,
[job_id] [smallint] NOT NULL CONSTRAINT [AssumeJobIDof1] DEFAULT ((1)),
[job_lvl] [tinyint] NULL CONSTRAINT [AssumeJobLevelof10] DEFAULT ((10)),
[pub_id] [char] (8) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [AssumeAPub_IDof9952] DEFAULT ('9952'),
[hire_date] [datetime] NOT NULL CONSTRAINT [AssumeAewHire] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [CK_emp_id] CHECK (([emp_id] like '[A-Z][A-Z][A-Z][1-9][0-9][0-9][0-9][0-9][FM]' OR [emp_id] like '[A-Z]-[A-Z][1-9][0-9][0-9][0-9][0-9][FM]'))
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [PK_emp_id] PRIMARY KEY NONCLUSTERED ([emp_id])
GO
CREATE NONCLUSTERED INDEX [JobID_index] ON [dbo].[employee] ([job_id])
GO
CREATE CLUSTERED INDEX [employee_ind] ON [dbo].[employee] ([lname], [fname], [minit])
GO
CREATE NONCLUSTERED INDEX [pub_id_index] ON [dbo].[employee] ([pub_id])
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [FK__employee__job_id] FOREIGN KEY ([job_id]) REFERENCES [dbo].[jobs] ([job_id])
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [FK__employee__pub_id] FOREIGN KEY ([pub_id]) REFERENCES [dbo].[publishers] ([pub_id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'An employee of any of the publishers', 'SCHEMA', N'dbo', 'TABLE', N'employee', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The key to the Employee Table', 'SCHEMA', N'dbo', 'TABLE', N'employee', 'COLUMN', N'emp_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'first name', 'SCHEMA', N'dbo', 'TABLE', N'employee', 'COLUMN', N'fname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the date that the employeee was hired', 'SCHEMA', N'dbo', 'TABLE', N'employee', 'COLUMN', N'hire_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the job that the employee does', 'SCHEMA', N'dbo', 'TABLE', N'employee', 'COLUMN', N'job_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the job level', 'SCHEMA', N'dbo', 'TABLE', N'employee', 'COLUMN', N'job_lvl'
GO
EXEC sp_addextendedproperty N'MS_Description', N'last name', 'SCHEMA', N'dbo', 'TABLE', N'employee', 'COLUMN', N'lname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'middle initial', 'SCHEMA', N'dbo', 'TABLE', N'employee', 'COLUMN', N'minit'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the publisher that the employee works for', 'SCHEMA', N'dbo', 'TABLE', N'employee', 'COLUMN', N'pub_id'
GO
