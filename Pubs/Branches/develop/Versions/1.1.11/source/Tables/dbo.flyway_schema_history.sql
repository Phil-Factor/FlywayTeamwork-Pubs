CREATE TABLE [dbo].[flyway_schema_history]
(
[installed_rank] [int] NOT NULL,
[version] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[description] [nvarchar] (200) COLLATE Latin1_General_CI_AS NULL,
[type] [nvarchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[script] [nvarchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[checksum] [int] NULL,
[installed_by] [nvarchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[installed_on] [datetime] NOT NULL CONSTRAINT [DF__flyway_sc__insta__75586032] DEFAULT (getdate()),
[execution_time] [int] NOT NULL,
[success] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[flyway_schema_history] ADD CONSTRAINT [flyway_schema_history_pk] PRIMARY KEY CLUSTERED  ([installed_rank])
GO
CREATE NONCLUSTERED INDEX [flyway_schema_history_s_idx] ON [dbo].[flyway_schema_history] ([success])
GO
