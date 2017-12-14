base="/Users/jcwitt/Projects/scta/scta-rdf/";
codicesfilesbase="/Users/jcwitt/Projects/scta/scta-codices/"

echo "Begin codices meta data creation"
for f in $codicesfilesbase/*.xml
do
	filename=$(basename "$f");
	extension="${filename##*.}";
	filename="${filename%.*}";
	echo "Creating metadata assertion for $filename"
	saxon "-warnings:silent" "-s:$codicesfilesbase/$filename.xml" "-xsl:$base/xsl_stylesheets/rdf_codices_conversion.xsl" "-o:$base/codices/$filename.rdf";
done
echo "Codices Metadata completed";
