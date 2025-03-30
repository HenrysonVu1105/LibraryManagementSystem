-- main script... imports all scripts from other files 

-- drop 
@sql/schema/drop_tables.sql

-- create tables 
@sql/schema/create_tables.sql

-- add additional sample data
@sql/schema/insert_data.sql

-- create sequences
@sql/sequences/sequences.sql

-- create indexes
@sql/indexes/indexes.sql

-- create triggers
@sql/triggers/triggers.sql

-- create procedures
@sql/procedures/procedures.sql

-- create functions
@sql/functions/functions.sql

-- create packages
@sql/packages/packages.sql

commit;