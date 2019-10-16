select * from sys.database_scoped_credentials;
select * from sys.external_data_sources;
select * from sys.external_file_formats;


-- Create a database scoped credential with Azure storage account key as the secret.
CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredential
WITH
     IDENTITY   = 'sqlva4onabrnvvfrkw'
,    SECRET     = '' --mykey
;

-- Create an external data source with CREDENTIAL option.
drop external data source MyAzureStorage
CREATE EXTERNAL DATA SOURCE MyAzureStorage
WITH
(    LOCATION   = 'wasbs://hiramblob@sqlva4onabrnvvfrkw.blob.core.windows.net/'
,    CREDENTIAL = AzureStorageCredential
,    TYPE       = HADOOP
)
;

--create external file formats
if exists (select 1 from sys.external_file_formats where name = 'parquet_file') drop external file format parquet_file;
CREATE EXTERNAL FILE FORMAT parquet_file
WITH (  
    FORMAT_TYPE = PARQUET,  
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'  
);


    if exists (select * from sys.external_tables where name ='demoparquet')
    begin 
        drop EXTERNAL TABLE demoparquet;
    end 
    else begin
    CREATE EXTERNAL TABLE demoparquet
        (field varchar(20))
        WITH (   
            LOCATION = 'demoparquet',  
            DATA_SOURCE = MyAzureStorage,  
            FILE_FORMAT = parquet_file  
        )  
        AS 
        select 'content' as field
    end;


--CSV Skip Header
if exists (select 1 from sys.external_file_formats where name = 'csv2') drop external file format csv2;
CREATE EXTERNAL FILE FORMAT csv2
WITH (FORMAT_TYPE = DELIMITEDTEXT,
      FORMAT_OPTIONS(
          FIELD_TERMINATOR = ',',
          STRING_DELIMITER = '"',
          FIRST_ROW = 2, 
          USE_TYPE_DEFAULT = True)
)

if exists (select 1 from sys.external_file_formats where name = 'csv') drop external file format csv;
CREATE EXTERNAL FILE FORMAT csv
WITH (FORMAT_TYPE = DELIMITEDTEXT,
      FORMAT_OPTIONS(
          FIELD_TERMINATOR = ',',
          STRING_DELIMITER = '"',
          USE_TYPE_DEFAULT = True)
)

    if exists (select * from sys.external_tables where name ='extBand')
    begin 
        drop EXTERNAL TABLE extBand;
    end
    else begin
    CREATE EXTERNAL TABLE extBand
        WITH (   
            LOCATION = 'extBand',  
            DATA_SOURCE = MyAzureStorage,  
            FILE_FORMAT = csv
        )  
        AS 
        select * from dbo.Band
    end;

sp_spaceused Band --119955              	
select count(*) from extBand --119955


    if exists (select * from sys.external_tables where name ='extBand2')
    begin 
        drop EXTERNAL TABLE extBand2;
    end
    else begin
    CREATE EXTERNAL TABLE extBand2
        WITH (   
            LOCATION = 'extBand',  
            DATA_SOURCE = MyAzureStorage,  
            FILE_FORMAT = csv2
        )  
        AS 
        select * from dbo.Band
    end;

select count(*) from extBand2 --239904	
