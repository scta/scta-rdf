# /bin/bash
base="/Users/jcwitt/Projects/scta/scta-rdf/";
echo "Begin Passive Relationships Metadata extraction";
saxon "-s:$base/xsl_stylesheets/rdf_relations_conversion.xsl" "-xsl:$base/xsl_stylesheets/rdf_relations_conversion.xsl" "-o:$base/relations/relations.rdf";
