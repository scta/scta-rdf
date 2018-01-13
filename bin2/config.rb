if ENV['DOCKER'] == "true"
  $base="/home/scta-rdf"
  $fuseki="/home/fuseki/apache-jena-fuseki-2.3.1"
  $fuseki_builds="/home/scta-builds"
  $textfilesbase="/home/scta-texts/"
else
  $base="/Users/jcwitt/Projects/scta/scta-rdf"
  $fuseki="/Users/jcwitt/Applications/fuseki/apache-jena-fuseki-2.3.1"
  $fuseki_builds="/Users/jcwitt/Projects/scta/scta-builds"
  $textfilesbase="/Users/jcwitt/Projects/scta/scta-texts/"
end
