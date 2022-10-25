/* add all missing indexes on foreign keys */
CREATE INDEX Publicationid_index ON editions (publication_id);
CREATE INDEX editionid_index ON prices (Edition_id);
CREATE INDEX Storid_index ON discounts (stor_id);
CREATE INDEX Titleid_index ON TagTitle (title_id);
CREATE INDEX TagName_index ON TagTitle (TagName_ID);
CREATE INDEX JobID_index ON employee (job_id);
CREATE INDEX pub_id_index ON employee (pub_id);
CREATE INDEX pubid_index ON publications (pub_id);
