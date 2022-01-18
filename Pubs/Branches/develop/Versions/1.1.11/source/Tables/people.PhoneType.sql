CREATE TABLE [people].[PhoneType]
(
[TypeOfPhone] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [PhoneTypeModifiedDateD] DEFAULT (getdate())
)
GO
ALTER TABLE [people].[PhoneType] ADD CONSTRAINT [PhoneTypePK] PRIMARY KEY CLUSTERED  ([TypeOfPhone])
GO
