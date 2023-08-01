CREATE TABLE [people].[Location]
(
[Location_ID] [int] NOT NULL IDENTITY(1, 1),
[organisation_id] [int] NOT NULL,
[Address_id] [int] NOT NULL,
[TypeOfAddress] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[Start_date] [datetime] NOT NULL,
[End_date] [datetime] NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [LocationModifiedD] DEFAULT (getdate())
)
GO
ALTER TABLE [people].[Location] ADD CONSTRAINT [LocationPK] PRIMARY KEY CLUSTERED ([Location_ID])
GO
ALTER TABLE [people].[Location] ADD CONSTRAINT [Location_AddressFK] FOREIGN KEY ([Address_id]) REFERENCES [people].[Address] ([Address_ID])
GO
ALTER TABLE [people].[Location] ADD CONSTRAINT [Location_AddressTypeFK] FOREIGN KEY ([TypeOfAddress]) REFERENCES [people].[AddressType] ([TypeOfAddress])
GO
ALTER TABLE [people].[Location] ADD CONSTRAINT [Location_organisationFK] FOREIGN KEY ([organisation_id]) REFERENCES [people].[Organisation] ([organisation_ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Location', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Location', 'COLUMN', N'Address_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Location', 'COLUMN', N'End_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Location', 'COLUMN', N'Location_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Location', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Location', 'COLUMN', N'organisation_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Location', 'COLUMN', N'Start_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'people', 'TABLE', N'Location', 'COLUMN', N'TypeOfAddress'
GO
