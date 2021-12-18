if ENV['DOCKER'] == "true"
  $base="/home/scta-rdf"
  $fuseki="/home/fuseki/apache-jena-fuseki-4.3.1"
  $fuseki_builds="/home/scta-rdf/fuseki-builds"
  $textfilesbase="/home/scta-rdf/data/scta-texts/"
  $shacommand="sha1sum"
  $saxoncommand="saxon"
else
  $base="/Users/jcwitt/Projects/scta/scta-rdf"
  #$fuseki="/Users/jcwitt/Applications/fuseki/apache-jena-fuseki-2.3.1"
  #$fuseki="/Users/jcwitt/Applications/fuseki/apache-jena-fuseki-3.14.0"
  $fuseki="/Users/jcwitt/Applications/fuseki/apache-jena-fuseki-4.3.1"
  $fuseki_builds="/Users/jcwitt/Projects/scta/scta-builds"
  $textfilesbase="/Users/jcwitt/Projects/scta/scta-texts/"
  $shacommand="shasum"
  $saxoncommand="/Users/jcwitt/Projects/scta/scta-rdf/saxon9.6/bin/saxon"
  #revert back to 9.6 because of this issue https://saxonica.plan.io/issues/4752
  #$saxoncommand="saxon"
end
