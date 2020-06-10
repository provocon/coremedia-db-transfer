INSERT INTO System (property, content) VALUES ('replicator_remote', '_sequenceno_');
INSERT INTO System (property, content) VALUES ('replicator_local', '_sequenceno_');
INSERT INTO System (property, content) VALUES ('replicator_tag', '_idtag_');
DELETE FROM CmLicenses;
UPDATE System SET content='live' WHERE property='repository_server_type' AND content='publication';