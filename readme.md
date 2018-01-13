# SCTA-RDF builder

This Application construct the SCTA RDF Database for its component parts.

# Install

Run with Docker

Install from Source

Clone repo and submodules

Dependencies

Ruby gem "thor" install with `gem install thor`
saxon
fuseki

`git clone --recursive git@github.com:scta/scta-rdf.git`

download scta-texts

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
