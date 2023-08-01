CREATE TABLE [people].[Phone]
(
[Phone_ID] [int] NOT NULL IDENTITY(1, 1),
[Person_id] [int] NOT NULL,
[TypeOfPhone] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[DiallingNumber] [people].[PersonalPhoneNumber] NOT NULL,
[Start_date] [datetime] NOT NULL,
[End_date] [datetime] NULL,
[ModifiedDate] [datetime] NULL CONSTRAINT [PhoneModifiedDateD] DEFAULT (getdate())
)
GO
ALTER TABLE [people].[Phone] ADD CONSTRAINT [PhonePK] PRIMARY KEY CLUSTERED ([Phone_ID])
GO
ALTER TABLE [people].[Phone] ADD CONSTRAINT [Phone_PersonFK] FOREIGN KEY ([Person_id]) REFERENCES [people].[Person] ([person_ID])
GO
ALTER TABLE [people].[Phone] ADD CONSTRAINT [FK__Phone__TypeOfPho__6A90B8FC] FOREIGN KEY ([TypeOfPhone]) REFERENCES [people].[PhoneType] ([TypeOfPhone])
GO
EXEC sp_addextendedproperty N'MS_Description', N' the actual phone number, and relates it to the person and the type of phone ', 'SCHEMA', N'people', 'TABLE', N'Phone', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the actual dialling number ', 'SCHEMA', N'people', 'TABLE', N'Phone', 'COLUMN', N'DiallingNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N' if not null, when the person stopped using the number', 'SCHEMA', N'people', 'TABLE', N'Phone', 'COLUMN', N'End_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when the record was last modified', 'SCHEMA', N'people', 'TABLE', N'Phone', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the person who has the phone number', 'SCHEMA', N'people', 'TABLE', N'Phone', 'COLUMN', N'Person_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the surrogate key for the phone', 'SCHEMA', N'people', 'TABLE', N'Phone', 'COLUMN', N'Phone_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N' when we first knew thet the person was using the number', 'SCHEMA', N'people', 'TABLE', N'Phone', 'COLUMN', N'Start_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the type of phone', 'SCHEMA', N'people', 'TABLE', N'Phone', 'COLUMN', N'TypeOfPhone'
GO
