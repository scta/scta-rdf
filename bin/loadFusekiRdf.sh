
	#set file bases
	fusekibase="/Users/jcwitt/Applications/fuseki/apache-jena-fuseki-2.3.1/bin/"
	rdfbase="/Users/jcwitt/Projects/scta/scta-rdf"
	## this is a temporary place for jsonld manifest to load from
	## they should load from the scta-site/public folder;
	## but right now fuseki is having a problem loading any manifest with a search blocks
	jsonldbase="/Users/jcwitt/Projects/scta/scta-codices/canvases"

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

	# #load de anima commentaries.
	# for f in $rdfbase/deanima-commentaries/*
	# 	do
	# 		filename=$(basename "$f");
	# 		extension="${filename##*.}";
	# 		filename="${filename%.*}";
	# 		echo "$rdfbase/deanima-commentaries/${filename}.rdf"
	# 		./s-post http://localhost:3030/ds/data default $rdfbase/deanima-commentaries/${filename}.rdf
	# 	done
	#
	# #load summulaelogicales commentaries.
	# for f in $rdfbase/petrushispanus-texts/*
	# 	do
	# 		filename=$(basename "$f");
	# 		extension="${filename##*.}";
	# 		filename="${filename%.*}";
	# 		echo "$rdfbase/petrushispanus-texts/${filename}.rdf"
	# 		./s-post http://localhost:3030/ds/data default $rdfbase/petrushispanus-texts/${filename}.rdf
	# 	done

	./s-post http://localhost:3030/ds/data default $rdfbase/names/persongroups.rdf
	./s-post http://localhost:3030/ds/data default $rdfbase/names/Prosopography.rdf
	./s-post http://localhost:3030/ds/data default $rdfbase/works/workscited.rdf
	./s-post http://localhost:3030/ds/data default $rdfbase/subjects/subjectlist.rdf
	./s-post http://localhost:3030/ds/data default $rdfbase/relations/relations.rdf
	./s-post http://localhost:3030/ds/data default $rdfbase/quotations/auctoritatesquotations.rdf
	#./s-post http://localhost:3030/ds/data default $rdfbase/quotations/bsaquotations.rdf

	#load codices
	echo "begin loading codices data"
	for f in $rdfbase/codices/*
		do
			filename=$(basename "$f");
			extension="${filename##*.}";
			filename="${filename%.*}";
			echo "$rdfbase/codices/${filename}.rdf"
			./s-post http://localhost:3030/ds/data default $rdfbase/codices/${filename}.rdf
		done

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

	#load rdfs schema
	echo "loading scta rdfs schema"
	./s-post http://localhost:3030/ds/data default $rdfbase/scta-rdfs-schema.ttl
	#load scta expression types

	echo "loading scta expression types"
	./s-post http://localhost:3030/ds/data default $rdfbase/scta_expression_types.ttl


	# echo "loading jsonld"
	# for file in $jsonldbase/*.jsonld
	# do
	# 	echo "loading $file";
	# 	./s-post http://localhost:3030/ds/data default $file
	# done

	echo "loading scta articles"
	./s-post http://localhost:3030/ds/data default $rdfbase/articles.ttl

	## temporary load
	echo "loading translation ttl file"
	./s-post http://localhost:3030/ds/data default $rdfbase/translations-manual-list.ttl

	echo "loading scta build"
	./s-post http://localhost:3030/ds/data default $rdfbase/buildversion.ttl
