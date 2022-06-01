/* add all missing indexes on foreign keys */
	CREATE INDEX Publicationid_index ON Editions(publication_id);
	CREATE INDEX editionid_index ON prices(Edition_id);
	CREATE INDEX Storid_index ON Discounts(Stor_id);
	CREATE INDEX Titleid_index ON TagTitle(title_id);
	CREATE INDEX TagName_index ON TagTitle(Tagname_id);
	CREATE INDEX JobID_index ON employee(Job_id);
	CREATE INDEX pub_id_index ON employee(pub_id);
	CREATE INDEX pubid_index ON publications(pub_id);
