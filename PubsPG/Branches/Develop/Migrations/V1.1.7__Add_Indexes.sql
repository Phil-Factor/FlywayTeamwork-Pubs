/* add all missing indexes on foreign keys */

CREATE INDEX IF NOT EXISTS Publicationid_index ON dbo.Editions(publication_id);
CREATE INDEX IF NOT EXISTS  Publicationid_index ON dbo.Editions(publication_id);
CREATE INDEX IF NOT EXISTS  editionid_index ON dbo.prices(Edition_id);
CREATE INDEX IF NOT EXISTS  Storid_index ON dbo.Discounts(Stor_id);
CREATE INDEX IF NOT EXISTS  Titleid_index ON dbo.TagTitle(title_id);
CREATE INDEX IF NOT EXISTS  TagName_index ON dbo.TagTitle(Tagname_id);
CREATE INDEX IF NOT EXISTS  JobID_index ON dbo.employee(Job_id);
CREATE INDEX IF NOT EXISTS  pub_id_index ON dbo.employee(pub_id);
CREATE INDEX IF NOT EXISTS  pubid_index ON dbo.publications(pub_id);
