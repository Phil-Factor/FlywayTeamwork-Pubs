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
ALTER TABLE [people].[Phone] ADD CONSTRAINT [PhonePK] PRIMARY KEY CLUSTERED  ([Phone_ID])
GO
ALTER TABLE [people].[Phone] ADD CONSTRAINT [Phone_PersonFK] FOREIGN KEY ([Person_id]) REFERENCES [people].[Person] ([person_ID])
GO
ALTER TABLE [people].[Phone] ADD CONSTRAINT [FK__Phone__TypeOfPho__009508B4] FOREIGN KEY ([TypeOfPhone]) REFERENCES [people].[PhoneType] ([TypeOfPhone])
GO
