base="/Users/jcwitt/Projects/scta/scta-rdf/";
echo "Begin quotation extraction from custom lists";
for f in /Users/jcwitt/Projects/scta/scta-quotations/*.xml
do
  filename=$(basename "$f");
  extension="${filename##*.}";
  filename="${filename%.*}";
  echo "creating ${filename}"
  saxon "-warnings:silent" "-s:/Users/jcwitt/Projects/scta/scta-quotations/$filename.xml" "-xsl:$base/xsl_stylesheets/rdf_customquotes_conversion.xsl" "-o:$base/quotations/$filename.rdf";
done
