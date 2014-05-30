#1 /bin/bash
echo "Creating projectfiles metadata";
base="/Users/JCWitt/Desktop/scta/";
for f in $base/projectfiles/*.xml
do
	filename=$(basename "$f");
	extension="${filename##*.}";
	filename="${filename%.*}";
	saxon "-warnings:silent -s:$base/projectfiles/$filename.xml" "-xsl:$base/xsl_stylesheets/rdf_conversion_one_file.xsl" "-o:$base/commentaries/$filename.rdf";
done

echo "Projectfiles meta data created";
echo "Being quotation extraction from auctoritates"
saxon "-s:$base/xsl_stylesheets/rdf_auctoritatesquotes_conversion.xsl" "-xsl:$base/xsl_stylesheets/rdf_auctoritatesquotes_conversion.xsl" "-o:$base/quotations/auctoritatesquotations.rdf";
echo "Being quotation extraction from vulgate";
saxon "-s:$base/xsl_stylesheets/rdf_vulgatequotes_conversion.xsl" "-xsl:$base/xsl_stylesheets/rdf_vulgatequotes_conversion.xsl" "-o:$base/quotations/vulgatequotations.rdf";
echo "Begin Workcited Metadata extraction";
saxon "-s:/Users/JCWitt/WebPages/lombardpress-lists/workscited.xml/" "-xsl:$base/xsl_stylesheets/rdf_works_conversion.xsl" "-o:$base/works/workscited.rdf";
echo "Begin Nameslist Metadata extraction";
saxon "-s:/Users/JCWitt/WebPages/lombardpress-lists/Prosopography.xml/" "-xsl:$base/xsl_stylesheets/rdf_names_conversion.xsl" "-o:$base/names/Prosopography.rdf";
echo "All finished";

