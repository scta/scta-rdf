#1 /bin/bash
scope=$1;

echo "Creating bible quote metadata metadata";
base="/Users/jcwitt/Projects/scta";
date

if [ "$scope" == 'all' ]; then
	echo "scope for all has not yet been set up"
else
	echo "Being quotation extraction from Biblia Sacra Vulgate for $scope";
	date
	bookid=$scope
	saxon "-s:/$base/bible_text/Biblia_Sacra_Vulgata/Biblia_Sacra_Vulgata.xml" "-xsl:$base/scta-rdf/xsl_stylesheets/rdf_bsv_quotes_conversion.xsl" "-o:$base/scta-rdf/quotations/bsvquotations/$bookid.rdf" lbpworkname=$bookid;
	date
fi



: <<'END'
echo "Being quotation extraction from Nova Vulgate";

for f in $base/bible_text/nova-vulgata/*.xml
do
	filename=$(basename "$f");
	extension="${filename##*.}";
	filename="${filename%.*}";
	echo "creating ${filename}"
	date
	echo "Begin extraction from $filename";
	saxon "-s:$base/bible_text/nova-vulgata/$filename.xml" "-xsl:$base/scta-rdf/xsl_stylesheets/rdf_vulgatequotes_conversion.xsl" "-o:$base/scta-rdf/quotations/vulgatequotations/$filename.rdf";
	date
done
END
: <<'END'
date
bookid="Iio"
echo "Begin extraction from $bookid";
	saxon "-s:$base/bible_text/nova-vulgata/$bookid.xml" "-xsl:$base/scta-rdf/xsl_stylesheets/rdf_vulgatequotes_conversion.xsl" "-o:$base/scta-rdf/quotations/vulgatequotations/$bookid.rdf";
date
END


date

