CREATE TABLE [people].[EmailAddress]
(
[EmailID] [int] NOT NULL IDENTITY(1, 1),
[Person_id] [int] NOT NULL,
[EmailAddress] [people].[PersonalEmailAddress] NOT NULL,
[StartDate] [date] NOT NULL CONSTRAINT [DF__EmailAddr__Start__168449D3] DEFAULT (getdate()),
[EndDate] [date] NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [EmailAddressModifiedDateD] DEFAULT (getdate())
)
GO
ALTER TABLE [people].[EmailAddress] ADD CONSTRAINT [EmailPK] PRIMARY KEY CLUSTERED  ([EmailID])
GO
ALTER TABLE [people].[EmailAddress] ADD CONSTRAINT [EmailAddress_PersonFK] FOREIGN KEY ([Person_id]) REFERENCES [people].[Person] ([person_ID])
GO
