-- this main script imports all scripts from other files 

-- drop 
@sql/schema/drop_tables.sql

-- create 
@sql/schema/create_tables.sql

-- inserting additional data 
@sql/schema/insert_data.sql

-- create sequences
@sql/sequences/sequences.sql

-- indexes
@sql/indexes/indexes.sql

-- triggers
@sql/triggers/triggers.sql

-- procedures
@sql/procedures/procedures.sql

-- functions
@sql/functions/functions.sql

-- packages
@sql/packages/packages.sql

commit;