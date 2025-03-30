-- -- this main script imports all scripts from other files 

-- -- drop 
-- @./sql/schema/drop_tables.sql

-- -- create 
-- @sql/schema/create_tables.sql

-- -- inserting additional data 
-- @sql/schema/insert_data.sql

-- -- create sequences
-- @sql/sequences/sequences.sql

-- -- indexes
-- @sql/indexes/indexes.sql

-- -- triggers
-- @sql/triggers/triggers.sql

-- -- procedures
-- @sql/procedures/procedures.sql

-- -- functions
-- @sql/functions/functions.sql

-- -- packages
-- @packages/packages.sql

-- commit;


-- HOST cd 


-- filepath: c:\Users\norma\OneDrive\Documents\GitHub\LibraryManagementSystem\main_script.sql
-- this main script imports all scripts from other files

-- drop all objects
SET SERVEROUTPUT ON

DECLARE
  v_sql VARCHAR2(1000);
BEGIN
  -- Drop all tables
  FOR rec IN (SELECT table_name FROM user_tables) LOOP
    BEGIN
      v_sql := 'DROP TABLE ' || rec.table_name || ' CASCADE CONSTRAINTS';
      DBMS_OUTPUT.PUT_LINE('Dropping table: ' || rec.table_name);
      EXECUTE IMMEDIATE v_sql;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error dropping table ' || rec.table_name || ': ' || SQLERRM);
    END;
  END LOOP;

  -- Drop all triggers
  FOR rec IN (SELECT trigger_name FROM user_triggers) LOOP
    BEGIN
      v_sql := 'DROP TRIGGER ' || rec.trigger_name;
      DBMS_OUTPUT.PUT_LINE('Dropping trigger: ' || rec.trigger_name);
      EXECUTE IMMEDIATE v_sql;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error dropping trigger ' || rec.trigger_name || ': ' || SQLERRM);
    END;
  END LOOP;

  -- Drop all packages
  FOR rec IN (SELECT object_name FROM user_objects WHERE object_type = 'PACKAGE') LOOP
    BEGIN
      v_sql := 'DROP PACKAGE ' || rec.object_name;
      DBMS_OUTPUT.PUT_LINE('Dropping package: ' || rec.object_name);
      EXECUTE IMMEDIATE v_sql;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error dropping package ' || rec.object_name || ': ' || SQLERRM);
    END;
  END LOOP;

  -- Drop all procedures
  FOR rec IN (SELECT object_name FROM user_objects WHERE object_type = 'PROCEDURE') LOOP
    BEGIN
      v_sql := 'DROP PROCEDURE ' || rec.object_name;
      DBMS_OUTPUT.PUT_LINE('Dropping procedure: ' || rec.object_name);
      EXECUTE IMMEDIATE v_sql;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error dropping procedure ' || rec.object_name || ': ' || SQLERRM);
    END;
  END LOOP;

  -- Drop all functions
  FOR rec IN (SELECT object_name FROM user_objects WHERE object_type = 'FUNCTION') LOOP
    BEGIN
      v_sql := 'DROP FUNCTION ' || rec.object_name;
      DBMS_OUTPUT.PUT_LINE('Dropping function: ' || rec.object_name);
      EXECUTE IMMEDIATE v_sql;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error dropping function ' || rec.object_name || ': ' || SQLERRM);
    END;
  END LOOP;

  -- Drop all sequences
  FOR rec IN (SELECT sequence_name FROM user_sequences) LOOP
    BEGIN
      v_sql := 'DROP SEQUENCE ' || rec.sequence_name;
      DBMS_OUTPUT.PUT_LINE('Dropping sequence: ' || rec.sequence_name);
      EXECUTE IMMEDIATE v_sql;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error dropping sequence ' || rec.sequence_name || ': ' || SQLERRM);
    END;
  END LOOP;

  -- Drop all indexes
  FOR rec IN (SELECT index_name FROM user_indexes WHERE index_type != 'LOB') LOOP
    BEGIN
      v_sql := 'DROP INDEX ' || rec.index_name;
      DBMS_OUTPUT.PUT_LINE('Dropping index: ' || rec.index_name);
      EXECUTE IMMEDIATE v_sql;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error dropping index ' || rec.index_name || ': ' || SQLERRM);
    END;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('All user objects have been processed.');
END;
/

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