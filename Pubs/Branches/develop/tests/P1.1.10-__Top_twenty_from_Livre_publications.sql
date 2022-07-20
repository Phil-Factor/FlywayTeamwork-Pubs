SET QUOTED_IDENTIFIER ON
/* Top twenty publications from Livre publications*/
SELECT TOP 20  title, ListofEditions FROM dbo.TitlesAndEditionsByPublisher WHERE publisher LIKE 'Livre%'