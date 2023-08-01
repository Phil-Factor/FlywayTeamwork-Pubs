CREATE TABLE [people].[PhoneType]
(
[TypeOfPhone] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [PhoneTypeModifiedDateD] DEFAULT (getdate())
)
GO
ALTER TABLE [people].[PhoneType] ADD CONSTRAINT [PhoneTypePK] PRIMARY KEY CLUSTERED ([TypeOfPhone])
GO
EXEC sp_addextendedproperty N'MS_Description', N' the description of the type of the phone (e.g. Mobile, Home, work) ', 'SCHEMA', N'people', 'TABLE', N'PhoneType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'when this record was last modified', 'SCHEMA', N'people', 'TABLE', N'PhoneType', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'a description of the type of phone', 'SCHEMA', N'people', 'TABLE', N'PhoneType', 'COLUMN', N'TypeOfPhone'
GO
