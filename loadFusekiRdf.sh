	
	#update build version file
	./logbuild.sh

	#move to Jena directory
	cd /Applications/apache-jena-fuseki-2.0.0/bin/

	

	#begin loading
	#load top level scta collection
	./s-post http://localhost:3030/ds/data default ~/Desktop/scta/scta.rdf

	#load commentaries.
	for f in ~/Desktop/scta/commentaries/* 
		do
			filename=$(basename "$f");
			extension="${filename##*.}";
			filename="${filename%.*}";
			echo "/Desktop/scta/commentaries/${filename}.rdf"
			./s-post http://localhost:3030/ds/data default ~/Desktop/scta/commentaries/${filename}.rdf
		done

	./s-post http://localhost:3030/ds/data default ~/Desktop/scta/names/persongroups.rdf
	./s-post http://localhost:3030/ds/data default ~/Desktop/scta/names/Prosopography.rdf
	./s-post http://localhost:3030/ds/data default ~/Desktop/scta/works/workscited.rdf
	./s-post http://localhost:3030/ds/data default ~/Desktop/scta/subjects/subjectlist.rdf
	./s-post http://localhost:3030/ds/data default ~/Desktop/scta/relations/relations.rdf
	./s-post http://localhost:3030/ds/data default ~/Desktop/scta/quotations/auctoritatesquotations.rdf
	#./s-post http://localhost:3030/ds/data default ~/Desktop/scta/quotations/bsaquotations.rdf
	
	for f in /Users/JCWitt/Desktop/scta/quotations/bsvquotations/*
	do
		filename=$(basename "$f");
		extension="${filename##*.}";
		filename="${filename%.*}";
		echo "/Desktop/scta/quotations/bsvquotations/${filename}.rdf"
		./s-post http://localhost:3030/ds/data default ~/Desktop/scta/quotations/bsvquotations/${filename}.rdf
	done

	#for f in /Users/JCWitt/Desktop/scta/quotations/vulgatequotations/*
	#do
	#	filename=$(basename "$f");
	#	extension="${filename##*.}";
	#	filename="${filename%.*}";
	#	echo "/Desktop/scta/quotations/vulgatequotations/${filename}.rdf"
	#	./s-post http://localhost:3030/ds/data default ~/Desktop/scta/quotations/vulgatequotations/${filename}.rdf
	#done
	./s-post http://localhost:3030/ds/data default ~/Desktop/scta/quotations/miscquotationslist.rdf
	./s-post http://localhost:3030/ds/data default ~/Desktop/scta/quotations/anselm_quotationslist.rdf
	./s-post http://localhost:3030/ds/data default ~/Desktop/scta/quotations/augustine_quotationslist.rdf
	./s-post http://localhost:3030/ds/data default ~/Desktop/scta/quotations/lombard_quotationslist.rdf
	./s-post http://localhost:3030/ds/data default ~/Desktop/scta/quotations/canonlaw_quotations.rdf
	./s-post http://localhost:3030/ds/data default ~/Desktop/scta/RDFSchemaNEW.ttl
	#./s-post http://localhost:3030/ds/data default ~/Desktop/scta/manualRdfList.ttl
	echo "trying jsonld"
	./s-post http://localhost:3030/ds/data default /Users/JCWitt/Scripts/WittManifestTool/output/scta-collection.jsonld

	./s-post http://localhost:3030/ds/data default /Users/JCWitt/Scripts/WittManifestTool/output/pg-lon.jsonld
	./s-post http://localhost:3030/ds/data default /Users/JCWitt/Scripts/WittManifestTool/output/pp-sorb.jsonld
	./s-post http://localhost:3030/ds/data default /Users/JCWitt/Scripts/WittManifestTool/output/pp-svict.jsonld
	./s-post http://localhost:3030/ds/data default /Users/JCWitt/Scripts/WittManifestTool/output/pp-vat.jsonld
	./s-post http://localhost:3030/ds/data default /Users/JCWitt/Scripts/WittManifestTool/output/pp-reims.jsonld
	./s-post http://localhost:3030/ds/data default /Users/JCWitt/Scripts/WittManifestTool/output/wdr-penn.jsonld
	./s-post http://localhost:3030/ds/data default /Users/JCWitt/Scripts/WittManifestTool/output/wdr-wettf15.jsonld
	./s-post http://localhost:3030/ds/data default /Users/JCWitt/Scripts/WittManifestTool/output/pl-penn1147.jsonld
	./s-post http://localhost:3030/ds/data default /Users/JCWitt/Scripts/WittManifestTool/output/anon1-penn727.jsonld
	./s-post http://localhost:3030/ds/data default /Users/JCWitt/Scripts/WittManifestTool/output/pdt-bnf14556.jsonld
	./s-post http://localhost:3030/ds/data default /Users/JCWitt/Scripts/WittManifestTool/output/pl-bnf15705.jsonld
	./s-post http://localhost:3030/ds/data default /Users/JCWitt/Scripts/WittManifestTool/output/wdr-gks1363.jsonld
	./s-post http://localhost:3030/ds/data default /Users/JCWitt/Scripts/WittManifestTool/output/pl-bda446.jsonld
	./s-post http://localhost:3030/ds/data default /Users/JCWitt/Scripts/WittManifestTool/output/nddm-bnf.jsonld
	./s-post http://localhost:3030/ds/data default /Users/JCWitt/Scripts/WittManifestTool/output/atv-Paris1490.jsonld
	./s-post http://localhost:3030/ds/data default /Users/JCWitt/WebPages/scta/public/pl-zbsSII72.jsonld

	echo "loading scta build"
	./s-post http://localhost:3030/ds/data default ~/Desktop/scta/buildversion.ttl



