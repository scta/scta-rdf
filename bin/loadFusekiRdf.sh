	
	#set file bases
	fusekibase="/Users/jcwitt/Applications/fuseki/apache-jena-fuseki-2.3.1/bin/"
	rdfbase="/Users/jcwitt/Projects/scta/scta-rdf"
	jsonldbase="/Users/jcwitt/Projects/WittManifestTool/output"

	#update build version file
	$rdfbase/bin/logbuild.sh

	#move to Jena directory
	cd $fusekibase

	#begin loading
	#load top level scta collection
	./s-post http://localhost:3030/ds/data default $rdfbase/scta.rdf

	#load commentaries.
	for f in $rdfbase/commentaries/* 
		do
			filename=$(basename "$f");
			extension="${filename##*.}";
			filename="${filename%.*}";
			echo "$rdfbase/commentaries/${filename}.rdf"
			./s-post http://localhost:3030/ds/data default $rdfbase/commentaries/${filename}.rdf
		done

	./s-post http://localhost:3030/ds/data default $rdfbase/names/persongroups.rdf
	./s-post http://localhost:3030/ds/data default $rdfbase/names/Prosopography.rdf
	./s-post http://localhost:3030/ds/data default $rdfbase/works/workscited.rdf
	./s-post http://localhost:3030/ds/data default $rdfbase/subjects/subjectlist.rdf
	./s-post http://localhost:3030/ds/data default $rdfbase/relations/relations.rdf
	./s-post http://localhost:3030/ds/data default $rdfbase/quotations/auctoritatesquotations.rdf
	#./s-post http://localhost:3030/ds/data default $rdfbase/quotations/bsaquotations.rdf
	
	for f in $rdfbase/quotations/bsvquotations/*
	do
		filename=$(basename "$f");
		extension="${filename##*.}";
		filename="${filename%.*}";
		echo "$rdfbase/quotations/bsvquotations/${filename}.rdf"
		./s-post http://localhost:3030/ds/data default $rdfbase/quotations/bsvquotations/${filename}.rdf
	done

	#for f in /Users/JCWitt/Desktop/scta/quotations/vulgatequotations/*
	#do
	#	filename=$(basename "$f");
	#	extension="${filename##*.}";
	#	filename="${filename%.*}";
	#	echo "/Desktop/scta/quotations/vulgatequotations/${filename}.rdf"
	#	./s-post http://localhost:3030/ds/data default $rdfbase/quotations/vulgatequotations/${filename}.rdf
	#done
	./s-post http://localhost:3030/ds/data default $rdfbase/quotations/miscquotationslist.rdf
	./s-post http://localhost:3030/ds/data default $rdfbase/quotations/anselm_quotationslist.rdf
	./s-post http://localhost:3030/ds/data default $rdfbase/quotations/augustine_quotationslist.rdf
	./s-post http://localhost:3030/ds/data default $rdfbase/quotations/lombard_quotationslist.rdf
	./s-post http://localhost:3030/ds/data default $rdfbase/quotations/canonlaw_quotations.rdf
	./s-post http://localhost:3030/ds/data default $rdfbase/RDFSchemaNEW.ttl
	#./s-post http://localhost:3030/ds/data default $rdfbase/manualRdfList.ttl
	echo "trying jsonld"
	./s-post http://localhost:3030/ds/data default $jsonldbase/scta-collection.jsonld

	./s-post http://localhost:3030/ds/data default $jsonldbase/pg-lon.jsonld
	./s-post http://localhost:3030/ds/data default $jsonldbase/pp-sorb.jsonld
	./s-post http://localhost:3030/ds/data default $jsonldbase/pp-svict.jsonld
	./s-post http://localhost:3030/ds/data default $jsonldbase/pp-vat.jsonld
	./s-post http://localhost:3030/ds/data default $jsonldbase/pp-reims.jsonld
	./s-post http://localhost:3030/ds/data default $jsonldbase/wdr-penn.jsonld
	./s-post http://localhost:3030/ds/data default $jsonldbase/wdr-wettf15.jsonld
	./s-post http://localhost:3030/ds/data default $jsonldbase/pl-penn1147.jsonld
	./s-post http://localhost:3030/ds/data default $jsonldbase/anon1-penn727.jsonld
	./s-post http://localhost:3030/ds/data default $jsonldbase/pdt-bnf14556.jsonld
	./s-post http://localhost:3030/ds/data default $jsonldbase/pl-bnf15705.jsonld
	./s-post http://localhost:3030/ds/data default $jsonldbase/wdr-gks1363.jsonld
	./s-post http://localhost:3030/ds/data default $jsonldbase/pl-bda446.jsonld
	./s-post http://localhost:3030/ds/data default $jsonldbase/nddm-bnf.jsonld
	./s-post http://localhost:3030/ds/data default $jsonldbase/atv-Paris1490.jsonld
	./s-post http://localhost:3030/ds/data default /Users/jcwitt/Projects/scta/scta-site/public/pl-zbsSII72.jsonld
	./s-post http://localhost:3030/ds/data default /Users/jcwitt/Projects/scta/scta-site/public/ta-harv245.jsonld

	echo "loading scta build"
	./s-post http://localhost:3030/ds/data default $rdfbase/buildversion.ttl



