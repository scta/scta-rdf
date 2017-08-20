fusekibase="/Users/jcwitt/Applications/fuseki/apache-jena-fuseki-2.3.1/bin/"
rdfbase="/Users/jcwitt/Projects/scta/scta-rdf"

filename=$1
subdirectory=$2

#update build version file
$rdfbase/bin/logbuild.sh

#move to Jena directory
cd $fusekibase

./s-post http://localhost:3030/ds/data default $rdfbase/$subdirectory/$filename
