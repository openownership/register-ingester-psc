# Register Ingester PSC

Register Ingester PSC is a data ingester for the [OpenOwnership](https://www.openownership.org/en/) [Register](https://github.com/openownership/register) project. It processes bulk data published about [People with Significant Control (PSC)](https://download.companieshouse.gov.uk/en_pscdata.html) published by Companies House in the UK, and ingests records into [Elasticsearch](https://www.elastic.co/elasticsearch/). Optionally, it can also publish new records to [AWS Kinesis](https://aws.amazon.com/kinesis/). It uses raw records only, and doesn't do any conversion into the [Beneficial Ownership Data Standard (BODS)](https://www.openownership.org/en/topics/beneficial-ownership-data-standard/) format.

## Installation

Install and boot [Register](https://github.com/openownership/register).

Configure your environment using the example file:

```sh
cp .env.example .env
```

- `PSC_STREAM`: AWS Kinesis stream to which to publish new records (optional)
- `PSC_STREAM_API_KEY`: PSC Stream API registration key (optional; only necessary if ingesting via a stream rather than snapshots)

Create the Elasticsearch indexes:

```sh
docker compose run ingester-psc create-indexes
```

## Testing

Run the tests:

```sh
docker compose run ingester-psc test
```

## Usage

There are now three options:

- ingest via snapshots by using the helper script
- ingest via snapshots by running the commands step-by-step
- ingest via a stream by running the commands step-by-step (not fully functional)

### Snapshots using the helper script

To ingest the bulk data from a snapshot (published daily):

```sh
docker compose run ingester-psc ingest-bulk
```

### Snapshots step-by-step

Decide on an import ID relating to the data to download, e.g. `2023-10-06`. This is then used in subsequent commands.

Discover snapshots by retrieving the [list of snapshots](https://download.companieshouse.gov.uk/en_pscdata.html):

```sh
docker compose run ingester-psc discover-snapshots 2023_10_06
```

Ingest snapshots by iterating through the list of files uploaded to the designated prefix with the import ID, and ingest them into Elasticsearch:

```sh
docker compose run ingester-psc ingest-snapshots 2023_10_06
```

### Stream step-by-step (not fully functional)

Connect to the PSC Stream API, consume any new records, and ingest them into Elasticsearch (`PSC_STREAM_API_KEY` must be set):

```sh
docker compose run ingester-psc ingest-stream
```

Or to connect to the PSC Stream API using stream position `STREAM_POSITION` (if valid and not too old):

```sh
docker compose run ingester-psc ingest-stream <STREAM_POSITION>
```
