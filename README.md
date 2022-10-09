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

    I use Docker file for elastic, because it needs some env variables, but Azure doesn't support this naming format

To run locally

1. docker compose -f docker-compose-api.yml -f docker-compose-elastic.yml -f docker-compose-identity.yml -f docker-compose-kafka.yml -f docker-compose-prometheus.yml  up --build
2. Run frontend, identity, write, read and gateway manually. These services, excepts frontend, need https, but I didn't cope with https in docker
