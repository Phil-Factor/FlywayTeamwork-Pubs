/* add all missing indexes on foreign keys */

IF  (Object_Id('dbo.editions') IS NOT NULL
	AND IndexProperty(Object_Id('dbo.editions'),'Publicationid_index','IndexID') IS NULL)
	CREATE INDEX Publicationid_index ON dbo.Editions(publication_id)
IF  (Object_Id('dbo.prices') IS NOT NULL
	AND IndexProperty(Object_Id('dbo.prices'),'Editionid_index','IndexID') IS NULL)
	CREATE INDEX editionid_index ON dbo.prices(Edition_id)
IF  (Object_Id('dbo.Discounts') IS NOT NULL
	AND IndexProperty(Object_Id('dbo.Discounts'),'Storid_index','IndexID') IS NULL)
	CREATE INDEX Storid_index ON dbo.Discounts(Stor_id)
IF  (Object_Id('dbo.TagTitle') IS NOT NULL
	AND IndexProperty(Object_Id('dbo.TagTitle'),'Titleid_index','IndexID') IS NULL)
	CREATE INDEX Titleid_index ON dbo.TagTitle(title_id)
IF  (Object_Id('dbo.TagTitle') IS NOT NULL
	AND IndexProperty(Object_Id('dbo.TagTitle'),'TagName_index','IndexID') IS NULL)
	CREATE INDEX TagName_index ON dbo.TagTitle(Tagname_id)
IF  (Object_Id('dbo.employee') IS NOT NULL
	AND IndexProperty(Object_Id('dbo.employee'),'JobID_index','IndexID') IS NULL)
	CREATE INDEX JobID_index ON dbo.employee(Job_id)
IF  (Object_Id('dbo.employee') IS NOT NULL
	AND IndexProperty(Object_Id('dbo.employee'),'pub_id_index','IndexID') IS NULL)
	CREATE INDEX pub_id_index ON dbo.employee(pub_id)
IF  (Object_Id('dbo.publications') IS NOT NULL
	AND IndexProperty(Object_Id('dbo.publications'),'pubid_index','IndexID') IS NULL)
	CREATE INDEX pubid_index ON dbo.publications(pub_id)
	/*
IF  (Object_Id('dbo.editions') IS NOT NULL
	AND IndexProperty(Object_Id('dbo.editions'),'PublicationType_index','IndexID') IS NULL)
	CREATE INDEX PublicationType_index ON dbo.Editions(publication_Type)

Undo

IF  (IndexProperty(Object_Id('dbo.editions'),'Publicationid_index','IndexID') IS NOT NULL)
	DROP INDEX Publicationid_index ON dbo.editions
IF  (IndexProperty(Object_Id('dbo.prices'),'Editionid_index','IndexID') IS NOT NULL)
	DROP INDEX editionid_index ON dbo.prices
IF  (IndexProperty(Object_Id('dbo.Discounts'),'Storid_index','IndexID') IS NOT NULL)
	drop INDEX Storid_index ON dbo.Discounts
IF  (IndexProperty(Object_Id('dbo.TagTitle'),'Titleid_index','IndexID') IS NOT NULL)
	Drop INDEX Titleid_index ON dbo.TagTitle
IF  (IndexProperty(Object_Id('dbo.TagTitle'),'TagName_index','IndexID') IS NOT NULL)
	Drop INDEX TagName_index ON dbo.TagTitle
IF  (IndexProperty(Object_Id('dbo.employee'),'pub_id_index','IndexID') IS NOT NULL)
	Drop INDEX pub_id_index ON dbo.employee
IF  (IndexProperty(Object_Id('dbo.publications'),'pubid_index','IndexID') IS NOT NULL)
	Drop  INDEX pubid_index ON dbo.publications

*/

