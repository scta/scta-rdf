#!/usr/bin/env bash

# script should be executed in the data folder

(cd ./lombardpress-lists && git checkout master)
(cd ./scta-codices && git checkout master)
(cd ./scta-people && git checkout master)
(cd ./scta-projectfiles && git checkout master)
(cd ./scta-quotations && git checkout master)
(cd ./scta-rdf-schema && git checkout master)
