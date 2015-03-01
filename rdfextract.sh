#1 /bin/bash
echo "Creating projectfiles metadata";
base="/Users/JCWitt/Desktop/scta/";


for f in $base/projectfiles/*.xml
do
	filename=$(basename "$f");
	extension="${filename##*.}";
	filename="${filename%.*}";
	saxon "-warnings:silent -s:$base/projectfiles/$filename.xml" "-xsl:$base/xsl_stylesheets/rdf_projectdata_conversion.xsl" "-o:$base/commentaries/$filename.rdf";
done

echo "Projectfiles meta data created";

#echo "Being quotation extraction from auctoritates"
#saxon "-s:$base/xsl_stylesheets/rdf_auctoritatesquotes_conversion.xsl" "-xsl:$base/xsl_stylesheets/rdf_auctoritatesquotes_conversion.xsl" "-o:$base/quotations/auctoritatesquotations.rdf";

## run bible extraction here from separate file if desired

echo "Begin quotation extraction from custom lists";
for f in $base/quotationsraw/*.xml
do
	filename=$(basename "$f");
	extension="${filename##*.}";
	filename="${filename%.*}";
	echo "creating ${filename}"
	saxon "-warnings:silent -s:$base/quotationsraw/$filename.xml" "-xsl:$base/xsl_stylesheets/rdf_customquotes_conversion.xsl" "-o:$base/quotations/$filename.rdf";
done

echo "Begin Workcited Metadata extraction";
saxon "-s:/Users/JCWitt/WebPages/lombardpress-lists/workscited.xml/" "-xsl:$base/xsl_stylesheets/rdf_works_conversion.xsl" "-o:$base/works/workscited.rdf";
echo "Begin Nameslist Metadata extraction";
saxon "-s:/Users/JCWitt/WebPages/lombardpress-lists/Prosopography.xml/" "-xsl:$base/xsl_stylesheets/rdf_names_conversion.xsl" "-o:$base/names/Prosopography.rdf";
echo "Begin PersonGroupList Metadata extraction";
saxon "-s:/Users/JCWitt/WebPages/lombardpress-lists/persongroups.xml/" "-xsl:$base/xsl_stylesheets/rdf_persongroups_conversion.xsl" "-o:$base/names/persongroups.rdf";
echo "Begin Subjectlist Metadata extraction";
saxon "-s:/Users/JCWitt/WebPages/lombardpress-lists/subjectlist.xml/" "-xsl:$base/xsl_stylesheets/rdf_subjects_conversion.xsl" "-o:$base/subjects/subjectlist.rdf";
echo "All finished";

