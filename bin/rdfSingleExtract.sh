filename=$1
#saxon -warnings:silent "-s:/Users/jcwitt/Projects/scta/scta-projectfiles/$filename.xml" "-xsl:/Users/jcwitt/Projects/scta/scta-rdf/xsl_stylesheets/rdf_projectdata_conversion.xsl" "-o:/Users/jcwitt/Projects/scta/scta-rdf/commentaries/$filename.rdf";
saxon -warnings:silent "-s:/Users/jcwitt/Projects/scta/scta-projectfiles/$filename.xml" "-xsl:/Users/jcwitt/Projects/scta/scta-rdf/xsl_stylesheets/edf-conversion/main.xsl" "-o:/Users/jcwitt/Projects/scta/scta-rdf/commentaries/$filename.rdf";
