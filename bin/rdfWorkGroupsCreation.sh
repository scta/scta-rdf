# /bin/bash

projectfilesbase="/Users/jcwitt/Projects/scta/scta-projectfiles/"
base="/Users/jcwitt/Projects/scta/scta-rdf/";

cd $projectfilesbase
projectfilesversion="$( git describe --tags --always)"


## begin top level creation
echo "Begin top level archive collection creation"
saxon "-warnings:silent" "-s:$base/xsl_stylesheets/rdf_archive_conversion.xsl" "-xsl:$base/xsl_stylesheets/rdf_archive_conversion.xsl" "-o:$base/scta.rdf" "projectfilesversion=$projectfilesversion";
