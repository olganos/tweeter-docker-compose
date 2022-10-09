# tweeter-docker-compose

Docker compose files for local and production Azur eenvironments.
The project contains deployment scripts and auxillary files as well.

to deploy into Azure

1. Create a resource group 
    run createResource.sh

2. Publish services manually
    It's better to create environment variables for every servises in the cloud in order not to store DB or other credentials,
    but for now I stored them in the application settings json.

3. Create Mongo DB manually, create Confluent api for kafka manually too.

4. Create Postgres for Identity service by running createPostgresDb.sh

5. Run setupPrometheus.sh

6. Run setupElasticsearch.sh
    it needs to create indeces in Kibana:
    tweeter-read-*
    tweeter-synchroniser-*
    tweeter-write-*

    I couldn't connect with logstash in production, so in the Azure I just send the data into elastic directly