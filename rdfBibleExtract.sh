#1 /bin/bash
echo "Creating bible quote metadata metadata";
base="/Users/JCWitt/Desktop/scta/";
date


echo "Being quotation extraction from Biblia Sacra Vulgate";
date
bookid="ps"
saxon "-s:/Users/JCWitt/Documents/BibleQuotes/Biblia_Sacra_Vulgata/Biblia_Sacra_Vulgata.xml" "-xsl:$base/xsl_stylesheets/rdf_bsv_quotes_conversion.xsl" "-o:$base/quotations/bsvquotations/$bookid.rdf" lbpworkname=$bookid;
date


: <<'END'
echo "Being quotation extraction from Nova Vulgate";

for f in /Users/JCWitt/Documents/BibleQuotes/nova-vulgata/*.xml
do
	filename=$(basename "$f");
	extension="${filename##*.}";
	filename="${filename%.*}";
	echo "creating ${filename}"
	date
	echo "Begin extraction from $filename";
	saxon "-s:/Users/JCWitt/Documents/BibleQuotes/nova-vulgata/$filename.xml" "-xsl:$base/xsl_stylesheets/rdf_vulgatequotes_conversion.xsl" "-o:$base/quotations/vulgatequotations/$filename.rdf";
	date
done
END
: <<'END'
date
bookid="Iio"
echo "Begin extraction from $bookid";
	saxon "-s:/Users/JCWitt/Documents/BibleQuotes/nova-vulgata/$bookid.xml" "-xsl:$base/xsl_stylesheets/rdf_vulgatequotes_conversion.xsl" "-o:$base/quotations/vulgatequotations/$bookid.rdf";
date
END


date

