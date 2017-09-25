# /bin/bash
base="/Users/jcwitt/Projects/scta/scta-rdf/";
echo "Begin Passive Relationships Metadata extraction";

filename=$1
saxon "-warnings:silent" "-s:$base/commentaries/$filename.rdf" "-xsl:$base/xsl_stylesheets/rdf_relations2_conversion.xsl" "-o:$base/relations/$filename.rdf";
