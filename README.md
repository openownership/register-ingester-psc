# Register Ingester PSC

Register Ingester PSC is an application designed for use with the People with significant control (PSC) data published by Companies House in the UK. See http://download.companieshouse.gov.uk/en_pscdata.html for an example of their latest snapshot data.

This application will ingest records from PSC Snapshots or their Stream API into an Elasticsearch database. Optionally, it will also publish newly discovered records into an AWS Kinesis Stream, which can be consumed for data transformations (eg into the BODS format).

The structure of the data records and connection to the database is handled by the register_sources_psc gem (https://github.com/openownership/register-sources-psc).

## One-time Setup

Ingest indexes:
```
bin/run setup_indexes
```

## Ingesting Snapshots

### 1. Discover Snapshots

This stage will retrieve the list of snapshots linked to on http://download.companieshouse.gov.uk/en_pscdata.html.

```
bin/run discover_snapshots {IMPORT_ID}
bin/run discover_snapshots 2022_09_29
```

### 2. Ingest Snapshots

This stage will iterate through the list of files uploaded to the designated prefix with the import id and ingest them into Elasticsearch.

```
bin/run ingest_snapshots {IMPORT_ID}
bin/run ingest_snapshots 2022_09_29
```

If the PSC_STREAM key is set, new records will also be published to the AWS Kinesis Stream.

## Ingesting from Stream

This will connect to the PSC Stream API using the PSC_STREAM_API_KEY and consume any new records. These records will be ingested into Elasticsearch.

```
bin/run ingest_streams
```

If the PSC_STREAM key is set, new records will also be published to the AWS Kinesis Stream.

Optionally, a stream position can be provided and if valid (and not too old) then the records will be streamed from this position:

```
bin/run ingest_streams {STREAM_POSITION}
```

## Testing

First build the docker image with:
```
bin/build
```
Then tests can be executed by running:
```
bin/test
```

## Configuration

```
PSC_STREAM_API_KEY=

BODS_S3_BUCKET_NAME=
BODS_AWS_REGION=
BODS_AWS_ACCESS_KEY_ID=
BODS_AWS_SECRET_ACCESS_KEY=

SPLIT_SNAPSHOTS_S3_PREFIX=

ELASTICSEARCH_HOST=
ELASTICSEARCH_PORT=443
ELASTICSEARCH_PROTOCOL=https
ELASTICSEARCH_SSL_VERIFY=true
ELASTICSEARCH_PASSWORD=

PSC_STREAM=
```

- PSC_STREAM_API_KEY - This is a registration key to use the PSC stream API - only necessary if making use of the Streams functionality as opposed to snapshots
- Elasticsearch credentials - these must be set
- BODS_S3_BUCKET_NAME - This should be the name of the AWS Bucket for storage of the ingested files
- PSC_STREAM - If this is set, newly discovered records (ie ones not previously ingested) will be published to the AWS Kinesis stream with this name
