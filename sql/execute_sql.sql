-- import scripts
@sql/schema/create_tables.sql
@sql/schema/insert_data.sql
@sql/sequences/sequences.sql
@sql/indexes/indexes.sql
@sql/triggers/triggers.sql
@sql/procedures/procedures.sql
@sql/functions/functions.sql
@sql/packages/packages.sql

COMMIT;