#1 /bin/bash
scope=$1;
base=$2;
echo "Creating bible quote metadata metadata";

date

if [ "$scope" == 'all' ]; then
	for f in $base/data/bible-text/nova-vulgata/*.xml
	do
		filename=$(basename "$f");
		extension="${filename##*.}";
		bookid="${filename%.*}";
		echo "Being quotation extraction from Biblia Sacra Vulgate for $bookid";
		saxon "-s:/$base/data/bible-text/Biblia_Sacra_Vulgata.xml" "-xsl:$base/xsl_stylesheets/rdf_bsvQUICK_quotes_conversion.xsl" "-o:$base/build/quotations/bsvquotations/$bookid.rdf" lbpworkname=$bookid;
	done
else
	echo "Begin quotation extraction from Biblia Sacra Vulgate for $scope";
	date
	bookid=$scope
	saxon "-s:/$base/data/bible-text/Biblia_Sacra_Vulgata.xml" "-xsl:$base/xsl_stylesheets/rdf_bsvQUICK_quotes_conversion.xsl" "-o:$base/build/quotations/bsvquotations/$bookid.rdf" lbpworkname=$bookid;
	date
fi
date
