base="/Users/jcwitt/Projects/scta/scta-rdf/";
codicesfilesbase="/Users/jcwitt/Projects/scta/scta-codices/"

filename=$1
echo "creating codex metadata for $filename";
saxon "-warnings:silent" "-s:$codicesfilesbase/$filename.xml" "-xsl:$base/xsl_stylesheets/rdf_codices_conversion.xsl" "-o:$base/codices/$filename.rdf";
