# SCTA-RDF builder

This Application construct the SCTA RDF Database for its component parts.

# Install

`git clone --recursive git@github.com:scta/scta-rdf.git`

`docker build . -t scta-rdf`

Cloned versions do not come with rdf-build or prebuilds, enter into the docker container to create these builds

# Run With Docker

Enter into container to build data or manually start fuseki

`docker run -it -p 3030:3030 --entrypoint /bin/bash scta-rdf`

to create builds run

`/home/scta-rdf/bin2/scta-rdf extract_all`

this will take time and requires a lot of memory

once the rdf build is complete, you can load this into fuseki.

create a empty directory for the scta build

`/home/scta-rdf/bin2/scta-rdf create_TDB build-2018-01-13`

then you can start fuseki. Use Tmux to switch shells.

`tmux new -s fuseki`

the in the new shell RUN

`/home/scta-rdf/bin2/scta-rdf start_fuseki build-2018-01-13`

exit tmux

`ctl + b, d`

now load rdf graphs into the TDB directory via Fuseki

`/home/scta-rdf/bin2/scta-rdf load_all`

Once you have a build, you can turn fuseki on and off without entering the container by using the -d flag

To run fuseki container with default fuseki build in detach mode, run the following command

`docker run -d -p 3030:3030 scta-rdf /home/scta-rdf/bin2/scta-rdf start_fuseki build-2018-01-12`

#Install from Source

Install Dependencies

install ruby gem "thor" install with `gem install thor`
install saxon
install fuseki

Clone repo and submodules

`git clone --recursive git@github.com:scta/scta-rdf.git`

download and unzip scta texts

curl -L -o scta-texts.tar.gz http://gateway.ipfs.io/ipfs/QmWAt1qXzF6zRdAjs96HZLez2mSJEfjUia7Y5B8eoS3JYz && \
    tar -xvzf /scta-texts.tar.gz -C scta-texts/

Update config
`$base=LOCATION_OF_CLONED_REPO`
`$fuseki=LOCATION_OF_INSTALLED_FUSEKI_INSTANCE`
`$fuseki_builds=DESIRED_LOCATION_OF_FUSEKI_TDB_BUILDS`
`$textfilesbase=LOCATION_OF_DOWNLOADED_SCTA_TEXTS/` # with trailing slash

# How to Use

When in doubt you can look up commands with

`bin2/scta-rdf help`

To create your first RDF build run

`bin2/scta-rdf extract_all`

This will take some time

To load this into fuseki, create a directory for the TDB build

`bin2/scta-rdf create_TDB NAME_OF_BUILD_DIRECTORY`

Start FUSEKI with the build directory

`bin2/start_fuseki NAME_OF_BUILD_DIRECTORY`

then load the existing graphs into Fuseki/tdb with

`bin/load_canvases`
and
`bin2/load_all`
