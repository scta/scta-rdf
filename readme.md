# SCTA-RDF builder

This Application constructs the SCTA RDF Database for Raw Data structured according to SCTA Raw Data specifications (see https://scta.info/technical-details#data-creation-specifications) and outputs an RDF network graph structure according to the SCTA-RDF-Schema (see https://scta.info/technical-details#scta-rdf and http://scta.github.io/scta-rdf-schema/).

In addition to building the graph, the application can also index the resulting graph in Apache Jena TDB and make that indexed graph accessible for SPARQl query via the Apache Jena Fuseki.

Anyone can run the graph if they want to run an instance of the SCTA graph locally. It is also possible specify your own data sources and use the application to automate the construction of your own graph according to the SCTA-RDF-SCHEMA.

# Dependencies

* Ruby
* Apache Jena Fuseki
* Shasum

We highly recommend running this via a Docker container. Install and use instructions below all presume that you are using a docker container.

# Install

Clone the repo

`git clone --recurse-submodules git@github.com:scta/scta-rdf.git`

Change directories into the new directory.

`cd scta-rdf`


Build the docker image using docker-compose.

`docker-compose build`

Before running the application for the first time,

create a volume that Fuseki will use to store the indexed graph:

`mkdir -p ../scta-rdf-builds/fuseki-builds/build`

Note: if you want to clear the index graph and start over, you will want to delete this directory and then recreate it.

Next create a volume for the rdf builds:

`mkdir -p ../scta-rdf-builds/build`

Finally create a volume for the log files:

`mkdir -p ../scta-rdf-builds/logs`

You can change the location of these volumes, but the docker-compose file which mounts these volumes will need to be updated accordingly.

Once the volumes have been created,

Run a detached container from the newly created docker image.

`docker-compose up -d`git 

You should now have a running fuseki instance

Run `curl localhost:3030` to see if its working.

You can now run the first build.

The first build will take a considerable amount of time (think, perhaps 24 hours).

`docker exec -t sctardf_web_1 bin2/scta-rdf build_and_update`

The `build_and_update` command, will perform a sequence of actions.

1. Update texts and meta-text repositories from github
3. Build RDF graph from structured raw data
4. Ingest resulting graphs into indexed database.

Along the way, the application will be storing the hashes of the files (in the `logs` volume) it processes
and of the graphs it ingests.

The next time the `build_and_update` command is run, the hashes of the existing data
will be compared these hashes stored in the `logs` volume. If the hashes match,
processing or ingestion will be skipped for these files. Thus, `build_and_update` command
will take considerably less time as it will only process the files that need process.
It will still take some time however, as there will be thousands of hashes to be checked.

There are many more specialized commands that can be run with the SCTA-RDF CLI.

To see a list of commands run:

`docker exec -it sctardf_web_1 bin2/scta-rdf help`

You should see a list like the following:

```
Commands:
  scta-rdf build_and_update                    # performs full build and update pattern; assumes fuseki is running
  scta-rdf clear_TDB                           # clear TDB, set prebuild to 'all' to avoid using canvas-prebuild
  scta-rdf create_TDB BUILD_DIRECTORY          # create new build director at BUILD_DIRECTORY
  scta-rdf create_all_passive_relations_query  # create passive relations via SPARQL construct query
  scta-rdf create_article                      # create articles for specific article list
  scta-rdf create_articles                     # create articles for all article lists
  scta-rdf create_canvases                     # moves canvases from data to build folder
  scta-rdf create_codex CODEX                  # create codex
  scta-rdf create_codices                      # create codices
  scta-rdf create_expression EDF               # create expression
  scta-rdf create_expressions                  # create expressions
  scta-rdf create_institution INSTITUTION      # create_institution INSTITUTION
  scta-rdf create_institutions                 # create institutions
  scta-rdf create_manual_ttls                  # moves manual ttls from data to build folder
  scta-rdf create_names                        # create names
  scta-rdf create_passive_relation EDF         # create passive relation
  scta-rdf create_passive_relations            # create passive relations
  scta-rdf create_passive_relations_query      # create passive relations via SPARQL construct query
  scta-rdf create_person_groups                # create person groups
  scta-rdf create_subject_list                 # create subject list
  scta-rdf create_workgroups                   # create workgroups
  scta-rdf create_works                        # create work list
  scta-rdf delete_discarded_graphs graph       # delete graphs listed in log discardedgraphs.json file
  scta-rdf delete_graph graph                  # delete graph
  scta-rdf delete_graph_file                   # delete any file with matching name in any directory within the build folder
  scta-rdf extract_all                         # extract all
  scta-rdf get hash                            # creates hash for target and adds to specified hash table
  scta-rdf get hashes                          # creates hash table for targets and adds to specified hash table
  scta-rdf help [COMMAND]                      # Describe available commands or one specific command
  scta-rdf load_all                            # load all
  scta-rdf load_canvas                         # load canvas
  scta-rdf load_canvases                       # load canvases
  scta-rdf load_graph graph                    # load graph
  scta-rdf load_graphs                         # load graphs
  scta-rdf remove_hash                         # remove a hash from any log file
  scta-rdf same hash?                          # compares files and return true if the hashes are the same and false if they are diff...
  scta-rdf split_large_files                   # splits large build files into smaller versions
  scta-rdf start_fuseki                        # start fuseki
  scta-rdf update_all                          # updates all data
  scta-rdf update_all_graphs                   # update graphs
  scta-rdf update_canvas                       # load canvas
  scta-rdf update_canvases                     # load canvases
  scta-rdf update_data_repo                    # updates a data repo for a given github url 
  scta-rdf update_data_repos                   # updates all data repos besides texts 
  scta-rdf update_graph graph                  # update graph
  scta-rdf update_graph_toplevel               # update top level text graph and all sub items
  scta-rdf update_graphs                       # update graphs
  scta-rdf update_repo                         # update a single repo
  scta-rdf update_repos                        # update all data repos
  scta-rdf update_scta_texts                   # updates scta_texts data folder from url pointing to tarball
  scta-rdf update_text_repo                    # updates a single scta-text repo from url point to tarball
  scta-rdf update_text_repos                   # updates all texts repos using ids from edf/projectfiles

```

# Logging 

Improved logging is open feature request. 

But a simply logging for night builds can be set as follows:

First create `logs/build-logs` folder (at present it must be named "build-logs" other methods looping through log folder will not to skip it. TODO: this should be improved)

Second execute command to write stdout and stderr to timestamped log file. 
Note: this is an append method, so builds performed on the same date will output logs for successive builds to the same file
`docker exec -t sctardf_web_1 bin2/scta-rdf build_and_update >> logs/build-logs/$(date +'%d-%b-%Y').txt 2>> logs/build-logs/$(date +'%d-%b-%Y').txt`

To also output saved log to terminal, modify the above command slightly:
`docker exec -t sctardf_web_1 bin2/scta-rdf build_and_update >> >(tee logs/build-logs/$(date +'%d-%b-%Y').txt) 2>> >(tee logs/build-logs/$(date +'%d-%b-%Y').txt)`


bin2/scta-rdf update_graphs commentaries true >> >(tee logs/build-logs/$(date +'%d-%b-%Y')-j-files.txt) 2>> >(tee logs/build-logs/$(date +'%d-%b-%Y')-j-files.txt)
The above does not work in a crobjob because of differences in cron running environment. 
See: https://unix.stackexchange.com/questions/52330/how-to-redirect-output-to-a-file-from-within-cron
Instead try
`30 2 * * * root /opt/scta-rdf-cron-script.sh > /home/<username>/logs/scta-rdf-build-logs/backup.log 2>&1`

# Testing

Improved testing is an open feature request

But rough snapshot testing can be accomplished as follows, by setting the `dryrun` param (param 3) to `true` and the `logging` to false (param 4)

`scta-rdf update_graph_toplevel pp-projectdata true true false`

Dry run will simple check to see if a graph has changed without updating the database
By setting logging to false, all other logging messages will be silenced, and only files that have been changed will log to output


# Notes

To compact the growing size of the database, you can run: 

`curl -XPOST http://localhost:3030/$/compact/ds` on a running fuseki instance.

See: https://stackoverflow.com/questions/69946946/how-to-clear-the-unused-space-in-fuseki