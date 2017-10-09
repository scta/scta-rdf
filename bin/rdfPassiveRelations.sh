# /bin/bash
base="/Users/jcwitt/Projects/scta/scta-rdf/";
echo "Begin Passive Relationships Metadata extraction";

for f in $base/commentaries/*.rdf
do

	filename=$(basename "$f");
	extension="${filename##*.}";
	filename="${filename%.*}";
	echo "Creating passive metadata assertion for $filename"
	saxon "-warnings:silent" "-s:$base/commentaries/$filename.rdf" "-xsl:$base/xsl_stylesheets/rdf_relations2_conversion.xsl" "-o:$base/relations/$filename.rdf";

done
