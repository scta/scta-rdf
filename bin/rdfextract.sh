# /bin/bash
echo "Creating projectfiles metadata";
projectfilesbase="/Users/jcwitt/Projects/scta/scta-projectfiles/"
deanimaprojectfilesbase="/Users/jcwitt/Projects/scta/scta-projectfiles-deanima/"
base="/Users/jcwitt/Projects/scta/scta-rdf/";

echo "getting projectfiles version for $projectfilesbase"

cd $projectfilesbase
projectfilesversion="$( git describe --tags --always)"
cd $base
echo $projectfilesversion

# begin creation of sentences commentaries

for f in $projectfilesbase/*.xml
do

	filename=$(basename "$f");
	extension="${filename##*.}";
	filename="${filename%.*}";
	echo "Creating metadata assertion for $filename"
	saxon "-warnings:silent" "-s:$projectfilesbase/$filename.xml" "-xsl:$base/xsl_stylesheets/rdf_projectdata_conversion.xsl" "-o:$base/commentaries/$filename.rdf";
done
echo "Projectfiles meta data created for sentences commentaries";

## begin creation of de anima commentaries

for f in $deanimaprojectfilesbase/*.xml
do

	filename=$(basename "$f");
	extension="${filename##*.}";
	filename="${filename%.*}";
	echo "Creating metadata assertion for $filename"
	saxon "-warnings:silent" "-s:$deanimaprojectfilesbase/$filename.xml" "-xsl:$base/xsl_stylesheets/rdf_projectdata_conversion.xsl" "-o:$base/deanima-commentaries/$filename.rdf";
done
echo "Projectfiles meta data created for de anima commentaries";

## begin top level creation

echo "Begin top level archive collection creation"
saxon "-warnings:silent" "-s:$base/xsl_stylesheets/rdf_archive_conversion.xsl" "-xsl:$base/xsl_stylesheets/rdf_archive_conversion.xsl" "-o:$base/scta.rdf" "projectfilesversion=$projectfilesversion";


# echo "Being quotation extraction from auctoritates"
# saxon "-s:$base/xsl_stylesheets/rdf_auctoritatesquotes_conversion.xsl" "-xsl:$base/xsl_stylesheets/rdf_auctoritatesquotes_conversion.xsl" "-o:$base/quotations/auctoritatesquotations.rdf";

# # run bible extraction here from separate file if desired

# 	echo "Begin quotation extraction from custom lists";
# 	for f in /Users/jcwitt/Projects/scta/scta-quotations/*.xml
# 	do
# 		filename=$(basename "$f");
# 		extension="${filename##*.}";
# 		filename="${filename%.*}";
# 		echo "creating ${filename}"
# 		saxon "-warnings:silent" "-s:/Users/jcwitt/Projects/scta/scta-quotations/$filename.xml" "-xsl:$base/xsl_stylesheets/rdf_customquotes_conversion.xsl" "-o:$base/quotations/$filename.rdf";
# 	done

# 	echo "Begin Workcited Metadata extraction";
# 	saxon "-s:/Users/jcwitt/Projects/lombardpress/lombardpress-lists/workscited.xml/" "-xsl:$base/xsl_stylesheets/rdf_works_conversion.xsl" "-o:$base/works/workscited.rdf";
# 	echo "Begin Nameslist Metadata extraction";
# 	saxon "-s:/Users/jcwitt/Projects/lombardpress/lombardpress-lists/Prosopography.xml/" "-xsl:$base/xsl_stylesheets/rdf_names_conversion.xsl" "-o:$base/names/Prosopography.rdf";
# 	echo "Begin PersonGroupList Metadata extraction";
# 	saxon "-s:/Users/jcwitt/Projects/lombardpress/lombardpress-lists/persongroups.xml/" "-xsl:$base/xsl_stylesheets/rdf_persongroups_conversion.xsl" "-o:$base/names/persongroups.rdf";
# 	echo "Begin Subjectlist Metadata extraction";
# 	saxon "-s:/Users/jcwitt/Projects/lombardpress/lombardpress-lists/subjectlist.xml/" "-xsl:$base/xsl_stylesheets/rdf_subjects_conversion.xsl" "-o:$base/subjects/subjectlist.rdf";
# 	echo "Begin Passive Relationships Metadata extraction";
# 	saxon "-s:$base/xsl_stylesheets/rdf_relations_conversion.xsl" "-xsl:$base/xsl_stylesheets/rdf_relations_conversion.xsl" "-o:$base/relations/relations.rdf";
# 	echo "All finished";

# Code for individual project file extraction
# saxon -warnings:silent "-s:/Users/jcwitt/Projects/scta/scta-projectfiles/wdr-projectdata.xml" "-xsl:/Users/jcwitt/Projects/scta/scta-rdf/xsl_stylesheets/rdf_projectdata_conversion.xsl" "-o:/Users/jcwitt/Projects/scta/scta-rdf/commentaries/wdr-projectdata.rdf";



