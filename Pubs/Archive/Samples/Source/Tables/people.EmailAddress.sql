CREATE TABLE [people].[EmailAddress]
(
[EmailID] [int] NOT NULL IDENTITY(1, 1),
[Person_id] [int] NOT NULL,
[EmailAddress] [people].[PersonalEmailAddress] NOT NULL,
[StartDate] [date] NOT NULL CONSTRAINT [DF__EmailAddr__Start__007FFA1B] DEFAULT (getdate()),
[EndDate] [date] NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [EmailAddressModifiedDateD] DEFAULT (getdate())
)
GO
ALTER TABLE [people].[EmailAddress] ADD CONSTRAINT [EmailPK] PRIMARY KEY CLUSTERED ([EmailID])
GO
ALTER TABLE [people].[EmailAddress] ADD CONSTRAINT [EmailAddress_PersonFK] FOREIGN KEY ([Person_id]) REFERENCES [people].[Person] ([person_ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N' the email address for the person. a person can have more than one ', 'SCHEMA', N'people', 'TABLE', N'EmailAddress', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the actual email address', 'SCHEMA', N'people', 'TABLE', N'EmailAddress', 'COLUMN', N'EmailAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Surrogate key for the email', 'SCHEMA', N'people', 'TABLE', N'EmailAddress', 'COLUMN', N'EmailID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when the customer stopped using this address', 'SCHEMA', N'people', 'TABLE', N'EmailAddress', 'COLUMN', N'EndDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When the email address got modified', 'SCHEMA', N'people', 'TABLE', N'EmailAddress', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'foreign key to the person who has the addess', 'SCHEMA', N'people', 'TABLE', N'EmailAddress', 'COLUMN', N'Person_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when the customer started using this address', 'SCHEMA', N'people', 'TABLE', N'EmailAddress', 'COLUMN', N'StartDate'
GO
