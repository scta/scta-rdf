jsonldbase="/Users/jcwitt/Projects/scta/scta-codices/canvases"
fusekibase="/Users/jcwitt/Applications/fuseki/apache-jena-fuseki-2.3.1/bin/"

echo "loading jsonld"
for file in $jsonldbase/*.jsonld
do
  echo "loading $file";
  $fusekibase/s-post http://localhost:3030/ds/data default $file
done
