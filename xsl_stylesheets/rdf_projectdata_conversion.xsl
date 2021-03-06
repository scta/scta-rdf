<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="2.0" 
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  xmlns:sctap="http://scta.info/properties/" 
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="sctap">
  
  <!-- location of text file for crawling -->
  <xsl:param name="textfilesbase">/Users/jcwitt/Projects/scta/scta-texts/</xsl:param>
  
  
  <xsl:variable name="commentaryname"><xsl:value-of select="//header/commentaryName"/></xsl:variable>
  <xsl:variable name="cid"><xsl:value-of select="//header/commentaryid"/></xsl:variable>
  <xsl:variable name="commentaryslug"><xsl:value-of select="//header/commentaryslug"/></xsl:variable>
  <xsl:variable name="author-uri"><xsl:value-of select="//header/authorUri"/></xsl:variable>
  <xsl:variable name="textfilesdir"><xsl:value-of select="$textfilesbase"/><xsl:value-of select="$cid"/>/</xsl:variable>
  
  <xsl:variable name="gitRepoBase">
    <xsl:choose>
  		<xsl:when test="//header/gitRepoBase">
  			<xsl:value-of select="//header/gitRepoBase"/>
  		</xsl:when>
  		<xsl:otherwise>https://bitbucket.org/jeffreycwitt/</xsl:otherwise>
  	</xsl:choose>
  </xsl:variable>
  <!-- git repo style records if there is a "toplevel" git repo for the entire work, or "single" for each item --> 
  <xsl:variable name="gitRepoStyle">
    <xsl:choose>
      <xsl:when test="//header/gitRepoBase/@type">
        <xsl:value-of select="//header/gitRepoBase/@type"/>
      </xsl:when>
      <xsl:otherwise>single</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="dtsurn"><xsl:value-of select="concat('urn:dts:latinLit:sentences', '.', $cid)"/></xsl:variable>

	<xsl:variable name="sponsors" select="//header/sponsors"/>
	<xsl:variable name="description" select="//header/description"/>
	<xsl:variable name="canoncial-top-level-manifestation" select="//header/canonical-top-level-manifestation"/>
		
	<xsl:variable name="parentWorkGroup">
		<xsl:choose>
			<xsl:when test="//header/parentWorkGroup">
				<xsl:value-of select="//header/parentWorkGroup"/>
			</xsl:when>
			<xsl:otherwise>http//scta.info/resource/sententia</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:output method="xml" indent="yes"/>
    
  <!-- function templates below -->
  <!-- this are not being used; they should be moved to a separate library file
  <xsl:template name="status">
	    <xsl:param name="text-path"/>
      <xsl:choose>
          <xsl:when test="document($text-path)//tei:revisionDesc/@status">
              <sctap:status><xsl:value-of select="document($text-path)//tei:revisionDesc/@status"></xsl:value-of></sctap:status>
          </xsl:when>
          <xsl:when test="document($text-path)">
              <sctap:status>In Progress</sctap:status>
          </xsl:when>
          <xsl:otherwise>
              <sctap:status>Not Started</sctap:status>
          </xsl:otherwise>
      </xsl:choose>
  </xsl:template>
	
	end of function templates -->
	
	<!-- root template -->
  <xsl:template match="/">
     <xsl:apply-templates></xsl:apply-templates>
 	</xsl:template>
  
  <!-- templates to delete unwanted elements -->
	<xsl:template match="header"></xsl:template>
 
  
	<!-- begin resource creation for top level expression -->  
  <xsl:template match="//div[@id='body']">
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
      xmlns:sctar="http://scta.info/resource/" 
      xmlns:sctap="http://scta.info/property/" 
      xmlns:sctat="http://scta.info/text/" 
      xmlns:role="http://www.loc.gov/loc.terms/relators/" 
      xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
      xmlns:collex="http://www.collex.org/schema#" 
      xmlns:dcterms="http://purl.org/dc/terms/" 
      xmlns:dc="http://purl.org/dc/elements/1.1/"
      xmlns:ldp="http://www.w3.org/ns/ldp#">    
    	
    	<rdf:Description rdf:about="http://scta.info/resource/{$cid}">
			 <rdf:type rdf:resource="http://scta.info/resource/expression"/>
			 <dc:title><xsl:value-of select="$commentaryname"/></dc:title>
		    <!-- TODO: parent of expresion should be WORK, not WorkGroup -->
    		<dcterms:isPartOf rdf:resource="{$parentWorkGroup}"/>
    		<role:AUT rdf:resource="{$author-uri}"/>
    		<!-- log description -->
    		<xsl:choose>
    			<xsl:when test="$description">
    			  <dc:description><xsl:value-of select="$description"/></dc:description>
    			</xsl:when>
    			<xsl:otherwise>
    				<dc:description>No Description Available</dc:description>
    			</xsl:otherwise>
    		</xsl:choose>
    		<!-- end log description -->
    		
    		<sctap:slug><xsl:value-of select="$commentaryslug"/></sctap:slug>
		    <sctap:shortId><xsl:value-of select="$cid"/></sctap:shortId>
    		<xsl:if test="//header/rcsid">
    			<sctap:rcsid><xsl:value-of select="//header/rcsid"/></sctap:rcsid>
    			
    		</xsl:if>
		    <sctap:dtsurn><xsl:value-of select="$dtsurn"/></sctap:dtsurn>
				<sctap:level>1</sctap:level>
    		<sctap:structureType rdf:resource="http://scta.info/resource/structureCollection"/>
    		
    		<!-- TODO: Project file headers should indicate expressionType; I'm hard coding to the SentencesCommentary for now;
    			but this means De Anima commentaries are going to be erroneously marked -->
    	  <xsl:choose>
    	    <xsl:when test="$parentWorkGroup eq 'http://scta.info/resource/deanima'">
    	      <sctap:expressionType rdf:resource="http://scta.info/resource/deanima-commentary"/>
    	    </xsl:when>
    	    <xsl:when test="$parentWorkGroup eq 'http://scta.info/resource/sententia'">
    	     <sctap:expressionType rdf:resource="http://scta.info/resource/sentences-commentary"/>
    	    </xsl:when>
    	    <xsl:otherwise>
    	      <sctap:expressionType rdf:resource="http://scta.info/resource/text"/>
    	    </xsl:otherwise>
    	  </xsl:choose>
    			 
		    
		    <!--Log any sponsors of this top level expression -->
		    <xsl:for-each select="$sponsors//sponsor">
		    	<sctap:hasSponsor rdf:resource="http://scta.info/resource/{@id}"/>
		    </xsl:for-each>
    		
    		<!-- log questionlist source, editor, and encoder -->
    	  <xsl:if test="/listofFileNames/header[1]/questionListSource[1]">
    	    <sctap:questionListSource><xsl:value-of select="/listofFileNames/header[1]/questionListSource[1]"/></sctap:questionListSource>
    	  </xsl:if>
    	  <xsl:if test="/listofFileNames/header[1]/questionListOriginalEditor[1]">
    	    <sctap:questionListEditor><xsl:value-of select="/listofFileNames/header[1]/questionListOriginalEditor[1]"/></sctap:questionListEditor>
    	  </xsl:if>
    	  <xsl:if test="/listofFileNames/header[1]/questionListEncoder[1]">
    	    <sctap:questionListEncoder><xsl:value-of select="/listofFileNames/header[1]/questionListEncoder[1]"/></sctap:questionListEncoder>
    	  </xsl:if>
    	  
    		<!-- identify second level expression parts -->
				<xsl:for-each select="./div">
					<xsl:variable name="divid"><xsl:value-of select="./@id"/></xsl:variable>
					<dcterms:hasPart rdf:resource="http://scta.info/resource/{$divid}"/>
				</xsl:for-each>
    		<xsl:for-each select="./item">
    			<xsl:variable name="direct-child-part"><xsl:value-of select="./@id"/></xsl:variable>
    			<dcterms:hasPart rdf:resource="http://scta.info/resource/{$direct-child-part}"/>
    		</xsl:for-each>
	      
	      <!-- identify all resources with structureType=itemStructure -->
    		
    		<xsl:for-each select=".//item">
            <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
            <sctap:hasStructureItem rdf:resource="http://scta.info/resource/{$fs}"/>
        </xsl:for-each>
		      
        <xsl:for-each select="/listofFileNames/header/hasWitnesses/witness">
          <xsl:variable name="wit-slug"><xsl:value-of select="./slug"/></xsl:variable>
        	<sctap:hasManifestation rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
        </xsl:for-each>
    		<sctap:hasManifestation rdf:resource="http://scta.info/resource/{$cid}/critical"/>
    		<xsl:choose>
    			<xsl:when test="$canoncial-top-level-manifestation">
    			</xsl:when>
    			<xsl:otherwise>
    				<sctap:hasCanonicalManifestation rdf:resource="http://scta.info/resource/{$cid}/critical"/>
    			</xsl:otherwise>
    		</xsl:choose>
    		
    		<!-- create ldn inbox -->
    	  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$cid}"/>
		  </rdf:Description>
    	
    	<!-- create manifestation entry for each manifestation corresponding to the top level expression -->
      <xsl:for-each select="/listofFileNames/header/hasWitnesses/witness">
        <xsl:variable name="wit-title"><xsl:value-of select="./title"/></xsl:variable>
        <xsl:variable name="wit-initial"><xsl:value-of select="./initial"/></xsl:variable>
        <xsl:variable name="wit-canvasbase"><xsl:value-of select="./canvasBase"/></xsl:variable>
        <xsl:variable name="wit-slug"><xsl:value-of select="./slug"/></xsl:variable>
        
      	<rdf:Description rdf:about="http://scta.info/resource/{$cid}/{$wit-slug}">
          <dc:title><xsl:value-of select="$wit-title"/></dc:title>
      		<rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
          <role:AUT rdf:resource="{$author-uri}"/>
      		<sctap:structureType rdf:resource="http://scta.info/resource/structureCollection"/>
      		<sctap:level>1</sctap:level>
          <sctap:hasSlug><xsl:value-of select="$wit-slug"></xsl:value-of></sctap:hasSlug>
      		<sctap:shortId><xsl:value-of select="concat($cid, '/', $wit-slug)"/></sctap:shortId>
          <xsl:if test="./manifestOfficial">
            <xsl:variable name="wit-manifestofficial"><xsl:value-of select="./manifestOfficial"/></xsl:variable>
            <sctap:manifestOfficial><xsl:value-of select="$wit-manifestofficial"></xsl:value-of></sctap:manifestOfficial>
          </xsl:if>
      		<sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$cid}"/>
      		<sctap:hasTranscription rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}/transcription"/>
      		<sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}/transcription"/>
      		
      		<!-- Identify direct child parts -->
      		<xsl:for-each select="//div[@id='body']/div">
      			<xsl:variable name="divid"><xsl:value-of select="./@id"/></xsl:variable>
      			<dcterms:hasPart rdf:resource="http://scta.info/resource/{$divid}/{$wit-slug}"/>
      		</xsl:for-each>
      		<xsl:for-each select="//div[@id='body']/item">
      			<xsl:variable name="direct-child-part"><xsl:value-of select="./@id"/></xsl:variable>
      			<dcterms:hasPart rdf:resource="http://scta.info/resource/{$direct-child-part}/{$wit-slug}"/>
      		</xsl:for-each>
      		<!-- END; Identify direct child parts -->
      		
      		<!-- identify all resources with structureType=itemStructure -->
      		
      		<xsl:for-each select="//div[@id='body']//item">
      			<xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
      			<sctap:hasStructureItem rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}"/>
      		</xsl:for-each>
      	  
      	  <!-- create ldn inbox -->
      	  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$cid}/{$wit-slug}"/>
        </rdf:Description>
      </xsl:for-each>
    	
    	<rdf:Description rdf:about="http://scta.info/resource/{$cid}/critical">
    			<dc:title>Critical Manifestation</dc:title>
    			<rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
    			<role:AUT rdf:resource="{$author-uri}"/>
    			<sctap:hasSlug>critical</sctap:hasSlug>
    			<sctap:structureType rdf:resource="http://scta.info/resource/structureCollection"/>
    			<sctap:level>1</sctap:level>
    			<sctap:shortId><xsl:value-of select="concat($cid, '/critical')"/></sctap:shortId>
    			<sctap:hasTranscription rdf:resource="http://scta.info/resource/{$cid}/critical/transcription"/>
    			<sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$cid}/critical/transcription"/>
	    		<xsl:for-each select="./div">
	    			<xsl:variable name="divid"><xsl:value-of select="./@id"/></xsl:variable>
	    			<dcterms:hasPart rdf:resource="http://scta.info/resource/{$divid}/critical"/>
	    		</xsl:for-each>
	    		
	    		<!-- identify all resources with structureType=itemStructure -->
	    		
	    		<xsl:for-each select=".//item">
	    			<xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
	    			<sctap:hasStructureItem rdf:resource="http://scta.info/resource/{$fs}/critical"/>
	    		</xsl:for-each>
    			
    	   <!-- create ldn inbox -->
    	   <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$cid}/critical"/>
    		</rdf:Description>
    	<!-- end of top level manifestation creation -->
    	
    	<!-- create transcription entry for each transcription corresponding to the top level expression -->
    	<xsl:for-each select="/listofFileNames/header/hasWitnesses/witness">
    		<xsl:variable name="wit-title"><xsl:value-of select="./title"/></xsl:variable>
    		<xsl:variable name="wit-initial"><xsl:value-of select="./initial"/></xsl:variable>
    		<xsl:variable name="wit-canvasbase"><xsl:value-of select="./canvasBase"/></xsl:variable>
    		<xsl:variable name="wit-slug"><xsl:value-of select="./slug"/></xsl:variable>
    		
    		<rdf:Description rdf:about="http://scta.info/resource/{$cid}/{$wit-slug}/transcription">
    			<dc:title><xsl:value-of select="$wit-title"/> transcription</dc:title>
    			<rdf:type rdf:resource="http://scta.info/resource/transcription"/>
    			<role:AUT rdf:resource="{$author-uri}"/>
    			<sctap:level>1</sctap:level>
    			<sctap:structureType rdf:resource="http://scta.info/resource/structureCollection"/>
    			<sctap:transcriptionType>Diplomatic</sctap:transcriptionType>
    			<sctap:shortId><xsl:value-of select="concat($cid, '/', $wit-slug, '/transcription')"/></sctap:shortId>
    			<xsl:if test="./manifestOfficial">
    				<xsl:variable name="wit-manifestofficial"><xsl:value-of select="./manifestOfficial"/></xsl:variable>
    				<sctap:manifestOfficial><xsl:value-of select="$wit-manifestofficial"></xsl:value-of></sctap:manifestOfficial>
    			</xsl:if>
    			<sctap:hasXML rdf:resource="http://exist.scta.info/exist/apps/scta-app/document/{$cid}/{$wit-slug}/transcription"/>
    			
    			<xsl:for-each select="//div[@id='body']/div">
    				<xsl:variable name="divid"><xsl:value-of select="./@id"/></xsl:variable>
    				<dcterms:hasPart rdf:resource="http://scta.info/resource/{$divid}/{$wit-slug}/transcription"/>
    			</xsl:for-each>
    			<!-- identify all resources with structureType=itemStructure -->
    			<xsl:for-each select="//div[@id='body']//item">
    				<xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
    				<sctap:hasStructureItem rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}/transcription"/>
    			</xsl:for-each>
    		  
    		  <!-- create ldn inbox -->
    		  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$cid}/{$wit-slug}/transcription"/>
    		</rdf:Description>
    		
    	</xsl:for-each>
    	
    		<rdf:Description rdf:about="http://scta.info/resource/{$cid}/critical/transcription">
    			<dc:title>Critical Transcription</dc:title>
    			<rdf:type rdf:resource="http://scta.info/resource/transcription"/>
    			<role:AUT rdf:resource="{$author-uri}"/>
    			<sctap:hasSlug>critical</sctap:hasSlug>
    			<sctap:level>1</sctap:level>
    			<sctap:structureType rdf:resource="http://scta.info/resource/structureCollection"/>
    			<sctap:transcriptionType>Critical</sctap:transcriptionType>
    			<sctap:shortId><xsl:value-of select="concat($cid, '/critical/transcription')"/></sctap:shortId>
    			<sctap:hasXML rdf:resource="http://exist.scta.info/exist/apps/scta-app/document/{$cid}/critical/transcription"/>
		    	<xsl:for-each select="./div">
		    		<xsl:variable name="divid"><xsl:value-of select="./@id"/></xsl:variable>
		    		<dcterms:hasPart rdf:resource="http://scta.info/resource/{$divid}/critical/transcription"/>
		    	</xsl:for-each>
		    	<!-- identify all resources with structureType=itemStructure -->
		    	<xsl:for-each select=".//item">
		    		<xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
		    		<sctap:hasStructureItem rdf:resource="http://scta.info/resource/{$fs}/critical/transcription"/>
		    	</xsl:for-each>
    		  
    		  <!-- create ldn inbox -->
    		  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$cid}/critical/transcription"/>
		    </rdf:Description>
		    <!-- end of top level transcription creation -->
    	
    	<!-- BEGIN create resources for any sponors of top level expression -->
    	<xsl:for-each select="$sponsors//sponsor">
    		<rdf:Description rdf:about="http://scta.info/resource/{@id}">
    			<dc:title><xsl:value-of select="./name"/></dc:title>
    			<rdf:type rdf:resource="http://scta.info/resource/sponsor"/>
    			<sctap:link rdf:resource="{./link}"></sctap:link>
    			<sctap:logo rdf:resource="{./logo}"></sctap:logo>
    		</rdf:Description>
    	</xsl:for-each>
    	<!-- END resource createion for sponsors -->
    	
    	<!-- begin creation of all structureType=structureCollections that are not topLevel Expressions -->
    	
    	<xsl:for-each select=".//div">
    		<xsl:variable name="current-div" select="."/>
    		<xsl:variable name="divid"><xsl:value-of select="./@id"/></xsl:variable>
    	  <xsl:variable name="title"><xsl:value-of select="./head"/></xsl:variable>
    		<xsl:variable name="expressionType"><xsl:value-of select="./@type"/></xsl:variable>
    		<xsl:variable name="expressionSubType"><xsl:value-of select="./@subtype"/></xsl:variable>
    		<xsl:variable name="parentExpression"><xsl:value-of select="./parent::div/@id"/></xsl:variable>
    	  <xsl:variable name="divQuestionTitle"><xsl:value-of select="./questionTitle"/></xsl:variable>
    		<xsl:variable name="current-div-level" select="count(ancestor::*)"/>
    		
        
    		<rdf:Description rdf:about="http://scta.info/resource/{$divid}">
    			
        	<dc:title><xsl:value-of select="$title"></xsl:value-of></dc:title>
        	<rdf:type rdf:resource="http://scta.info/resource/expression"/>
    			<role:AUT rdf:resource="{$author-uri}"/>
    		  
    		  <sctap:questionTitle><xsl:value-of select="$divQuestionTitle"/></sctap:questionTitle>
    			
    			<!-- check if special expression type is given -->
    			<xsl:choose>
    				<xsl:when test="$expressionType">
    					<sctap:expressionType rdf:resource="http://scta.info/resource/{$expressionType}"/>
    				</xsl:when>
    			<!-- if no special expression type is given default to generic division -->
    				<xsl:otherwise>
    					<sctap:expressionType rdf:resource="http://scta.info/resource/division"/>
    				</xsl:otherwise>
    			</xsl:choose>
    			<!-- add expressionSubType as just another expressionType if there is one -->
    			<xsl:if test="$expressionSubType">
    				<sctap:expressionType rdf:resource="http://scta.info/resource/{$expressionSubType}"/>	
    			</xsl:if>
    			
    			
    			<sctap:structureType rdf:resource="http://scta.info/resource/structureCollection"/>
    			<sctap:level><xsl:value-of select="$current-div-level"/></sctap:level>
    		  <sctap:shortId><xsl:value-of select="$divid"/></sctap:shortId>
    			
    			<!-- identify parent expression resource -->
    			<xsl:choose>
    				<!-- this condition is a temporary hack; when id=body is changed to id=commentaryid, this conditional will no longer be necessary -->
    				<xsl:when test="$current-div-level eq 2">
    					<dcterms:isPartOf rdf:resource="http://scta.info/resource/{$cid}"/>
    				</xsl:when>
    				<xsl:otherwise>
    					<dcterms:isPartOf rdf:resource="http://scta.info/resource/{$parentExpression}"/>
    				</xsl:otherwise>
    			</xsl:choose>
    			
    			
    			<!-- identify child expression part -->
    			
    			<xsl:for-each select="./div">
    				<xsl:variable name="divid"><xsl:value-of select="./@id"/></xsl:variable>
    				<dcterms:hasPart rdf:resource="http://scta.info/resource/{$divid}"/>
    			</xsl:for-each>
    			<xsl:for-each select="./item">
    				<!-- TODO: ./fileName/@filestem should be removed and changed to @id when all items have ids and the fileName element is removed -->
    				<xsl:variable name="direct-child-part"><xsl:value-of select="./fileName/@filestem"/></xsl:variable>
    				<dcterms:hasPart rdf:resource="http://scta.info/resource/{$direct-child-part}"/>
    			</xsl:for-each>
    			
    			<!-- TODO: decide if hasTopLevelExpression is necessary -->
    			<sctap:isPartOfTopLevelExpression rdf:resource="http://scta.info/resource/{$cid}"/>
          
          <!-- get Order Number -->
    			<xsl:variable name="totalnumber"><xsl:number count="div" level="any"/></xsl:variable>
    			<xsl:variable name="sectionnumber"><xsl:number count="div"/></xsl:variable>
	        <sctap:sectionOrderNumber><xsl:value-of select="format-number($sectionnumber, '0000')"/></sctap:sectionOrderNumber>
	        <sctap:totalOrderNumber><xsl:value-of select="format-number($totalnumber, '0000')"/></sctap:totalOrderNumber>
          
          <!-- TODO: decide if dtsurn should be used 
          <xsl:variable name="divcount"><xsl:number count="div[not(@id='body')]" level="multiple" format="1"/></xsl:variable>
          <sctap:dtsurn><xsl:value-of select="concat($dtsurn, ':', $divcount)"/></sctap:dtsurn>
          -->      
    			
    			<!-- list manifestations of this div -->
    			<xsl:for-each select="/listofFileNames/header/hasWitnesses/witness">
    				<xsl:variable name="wit-slug"><xsl:value-of select="./slug"/></xsl:variable>
    				<xsl:variable name="wit-initial"><xsl:value-of select="./initial"/></xsl:variable>
    				<xsl:if test="$current-div//item/hasWitnesses/witness/@ref = concat('#', $wit-initial)">
    					<sctap:hasManifestation rdf:resource="http://scta.info/resource/{$divid}/{$wit-slug}"/>
    				</xsl:if>
    				
    			</xsl:for-each>
    			<!--TODO list div manifestation for a critical editions; perhaps critical files should be listed at the top of the project file as well -->
    				<!-- <sctap:hasManifestation rdf:resource="http://scta.info/resource/{$divid}/critical"/>-->
    			
    			
    			<!-- list all items within this div -->
    			<xsl:for-each select=".//item">
    				<xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
    				<sctap:hasStructureItem rdf:resource="http://scta.info/resource/{$fs}"/>    
    			</xsl:for-each>
    		  
    		  <!-- create ldn inbox -->
    		  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$divid}"/>
    		</rdf:Description>
    		
    		<!-- create manifestation for each non-top-level div -->
    		
    		<xsl:for-each select="/listofFileNames/header/hasWitnesses/witness">
    			<xsl:variable name="wit-title"><xsl:value-of select="./title"/></xsl:variable>
    			<xsl:variable name="wit-slug"><xsl:value-of select="./slug"/></xsl:variable>
    			<xsl:variable name="wit-initial"><xsl:value-of select="./initial"/></xsl:variable>
    			<xsl:variable name="wit-canvasbase"><xsl:value-of select="./canvasBase"/></xsl:variable>
    			<xsl:if test="$current-div//item/hasWitnesses/witness/@ref = concat('#', $wit-initial)">
    				<rdf:Description rdf:about="http://scta.info/resource/{$divid}/{$wit-slug}">
    					<dc:title><xsl:value-of select="$wit-title"/></dc:title>
    					<rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
    					<role:AUT rdf:resource="{$author-uri}"/>
    					<sctap:structureType rdf:resource="http://scta.info/resource/structureCollection"/>
    					<sctap:level><xsl:value-of select="$current-div/count(ancestor::*)"/></sctap:level>
    						<sctap:hasSlug><xsl:value-of select="$wit-slug"></xsl:value-of></sctap:hasSlug>
    						<sctap:shortId><xsl:value-of select="concat($divid, '/', $wit-slug)"/></sctap:shortId>
    						<sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$divid}"/>
    						<sctap:hasTranscription rdf:resource="http://scta.info/resource/{$divid}/{$wit-slug}/transcription"/>
    						<sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$divid}/{$wit-slug}/transcription"/>
    						
    						<xsl:for-each select="$current-div/div">
    							<xsl:variable name="newdivid"><xsl:value-of select="./@id"/></xsl:variable>
    							<dcterms:hasPart rdf:resource="http://scta.info/resource/{$newdivid}/{$wit-slug}"/>
    						</xsl:for-each>
	    					<!-- identify all direct children items -->
	    					<xsl:for-each select="$current-div/item">
	    						<xsl:variable name="direct-child"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
	    						<dcterms:hasPart rdf:resource="http://scta.info/resource/{$direct-child}/{$wit-slug}"/>
	    					</xsl:for-each>
    					
    					<xsl:choose>
    						<!-- this condition is a temporary hack; when id=body is changed to id=commentaryid, this conditional will no longer be necessary -->
    						<xsl:when test="$current-div-level eq 2">
    							<dcterms:isPartOf rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
    						</xsl:when>
    						<xsl:otherwise>
    							<dcterms:isPartOf rdf:resource="http://scta.info/resource/{$parentExpression}/{$wit-slug}"/>
    						</xsl:otherwise>
    						
    					</xsl:choose>
    					
    						
    						<!-- identify all resources with structureType=itemStructure -->
    						
    						<xsl:for-each select="$current-div//item">
    							<xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
    							<sctap:hasStructureItem rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}"/>
    						</xsl:for-each>
    				  
      				  <!-- create ldn inbox -->
      				  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$divid}/{$wit-slug}"/>
    					</rdf:Description>
    				
    			</xsl:if>
    		</xsl:for-each>
    	</xsl:for-each>
    	
    	
    	
    	<!-- BEGIN structureType=structureItem expression resource creation -->
    	<!-- NOTE: changed ./div//item to .//item. This should be better, but keep your eye out for unanticipated consequences -->
    	<xsl:for-each select=".//item">
    		<!-- TODO go through variable and see what is being used and delete what is not being used -->
	      <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
	      <xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>
	      <xsl:variable name="expressionType"><xsl:value-of select="@type"/></xsl:variable>
	      <xsl:variable name="bookParent"><xsl:value-of select="./ancestor::div[@type='librum']/@id"/></xsl:variable>
	      <xsl:variable name="distinctionParent"><xsl:value-of select="./parent::div/@id"/></xsl:variable>
	      <xsl:variable name="text-path" select="concat($textfilesdir, $fs, '/', $fs, '.xml')"/>
	      <xsl:variable name="repo-path" select="concat($textfilesdir, $fs, '/')"/>
	      <xsl:variable name="extraction-file" select="if (document(concat($repo-path, 'transcriptions.xml'))) then concat($repo-path, document(concat($repo-path, 'transcriptions.xml'))/transcriptions/transcription[@use-for-extraction='true']) else $text-path"></xsl:variable>
	      <xsl:variable name="info-path" select="concat($repo-path, 'info.xml')"/>
	      <xsl:variable name="totalnumber"><xsl:number count="item" level="any"/></xsl:variable>
	      <xsl:variable name="sectionnumber"><xsl:number count="item"/></xsl:variable>
	      <xsl:variable name="librum-number"><xsl:number count="div[@type='librum']"/></xsl:variable>
	      <xsl:variable name="distinctio-number"><xsl:number count="div[@type='distinctio']"/></xsl:variable>
	      <xsl:variable name="pars-number"><xsl:number count="div[@type='pars']"/></xsl:variable>
	      <xsl:variable name="item-level" select="count(ancestor::*)"/>
    		<xsl:variable name="expressionParentId" select="./parent::div/@id"/>
    		<!-- TODO decideif item-dtsurn is desired -->
	      <xsl:variable name="item-dtsurn">
	      	<xsl:variable name="divcount"><xsl:number count="div[not(@id='body')]" level="multiple" format="1"/></xsl:variable>
	      	<xsl:value-of select="concat($dtsurn, ':', $divcount, '.i', $totalnumber)"/>
	      </xsl:variable>
    		
    		<xsl:variable name="canonical-filename-slug" select="substring-before(tokenize($extraction-file, '/')[last()], '.xml')"></xsl:variable>
    		<xsl:variable name="canonical-manifestation-id">
    			<xsl:choose>
    				<xsl:when test="contains($canonical-filename-slug, '_')">
    					<xsl:value-of select="substring-before($canonical-filename-slug, '_')"/>
    				</xsl:when>
    				<!-- TODO: not ideal to be hard coding critical here. what if there were more than on critical manifestation -->
    				<xsl:otherwise>critical</xsl:otherwise>
    			</xsl:choose>
    		</xsl:variable>
    		
    		<xsl:variable name="itemWitnesses" select="./hasWitnesses/witness"/>
    	  <xsl:variable name="translationTranscriptions" select="document(concat($repo-path, 'transcriptions.xml'))//transcription[@type='translation']"/>
    	  <xsl:variable name="translationManifestations" select="document(concat($repo-path, 'transcriptions.xml'))/transcriptions/translationManifestations//manifestation"/>
    		
    		<rdf:Description rdf:about="http://scta.info/resource/{$fs}">
    			<dc:title><xsl:value-of select="$title"></xsl:value-of></dc:title>
    			<rdf:type rdf:resource="http://scta.info/resource/expression"/>
    			<!-- TODO; condition should be removed with <div id=body> is changed to <div id=commentaryid> -->
    			<xsl:choose>
    				<xsl:when test="$item-level eq 2">
    					<dcterms:isPartOf rdf:resource="http://scta.info/resource/{$cid}"/>
    				</xsl:when>
    				<xsl:otherwise>
    					<dcterms:isPartOf rdf:resource="http://scta.info/resource/{$expressionParentId}"/>	
    				</xsl:otherwise>
    			</xsl:choose>
    			<role:AUT rdf:resource="{$author-uri}"/>
    			
    			<!-- record editors -->
    			<xsl:for-each select="document($extraction-file)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor">
    				<sctap:editedBy><xsl:value-of select="."/></sctap:editedBy>
    			</xsl:for-each>
    			
    			<sctap:expressionType rdf:resource="http://scta.info/resource/{$expressionType}"/>
    			<sctap:structureType rdf:resource="http://scta.info/resource/structureItem"/>
    			<sctap:isPartOfTopLevelExpression rdf:resource="http://scta.info/resource/{$cid}"/>
    			<sctap:shortId><xsl:value-of select="$fs"/></sctap:shortId>
    			<sctap:level><xsl:value-of select="$item-level"/></sctap:level>
    			
    			<sctap:sectionOrderNumber><xsl:value-of select="format-number($sectionnumber, '0000')"/></sctap:sectionOrderNumber>
	        <sctap:totalOrderNumber><xsl:value-of select="format-number($totalnumber, '0000')"/></sctap:totalOrderNumber>
    			
    			<xsl:if test="./following::item[1]">
	           <xsl:variable name="next-item" select="./following::item[1]/fileName/@filestem"></xsl:variable>
	           <sctap:next rdf:resource="http://scta.info/resource/{$next-item}"/>
    			</xsl:if>
    			<xsl:if test="./preceding::item[1]">
    				<xsl:variable name="previous-item" select="./preceding::item[1]/fileName/@filestem"></xsl:variable>
    				<sctap:previous rdf:resource="http://scta.info/resource/{$previous-item}"/>
    			</xsl:if>
    			
    			<!-- TODO: consider adding questionTitle attribute to higher level divs as well -->
    			<xsl:if test="./questionTitle">
    				<sctap:questionTitle><xsl:value-of select="./questionTitle"></xsl:value-of></sctap:questionTitle>
    			</xsl:if>
    			
    			<!-- TODO review wither a dtsurn is desired 
    			<sctap:dtsurn><xsl:value-of select="$item-dtsurn"/></sctap:dtsurn>
    			-->
    			
    			<!-- record git repo -->
    		  <xsl:choose>
    		    <xsl:when test="$gitRepoStyle = 'toplevel'">
    		      <sctap:gitRepository><xsl:value-of select="concat($gitRepoBase, $cid)"/></sctap:gitRepository>
    		    </xsl:when>
    		    <xsl:otherwise>
    		      <sctap:gitRepository><xsl:value-of select="concat($gitRepoBase, $fs)"/></sctap:gitRepository>
    		    </xsl:otherwise>
    		  </xsl:choose>
    		  
    			
    			<!-- BEGIN record status -->
    			<xsl:choose>
	        	<xsl:when test="document($extraction-file)//tei:revisionDesc/@status">
	          	<sctap:status><xsl:value-of select="document($extraction-file)//tei:revisionDesc/@status"></xsl:value-of></sctap:status>
	         	</xsl:when>
    				<xsl:when test="document($extraction-file)">
	             <sctap:status>In Progress</sctap:status>
    				</xsl:when>
    				<xsl:otherwise>
    					<sctap:status>Not Started</sctap:status>
    				</xsl:otherwise>
    			</xsl:choose>
          <!-- END record status -->
    			
    			<!-- BEGIN identify strcutreBlock expressions contained by structureItem -->
    			<xsl:for-each select="document($extraction-file)//tei:body//tei:p">
    				<xsl:if test="./@xml:id">
    					<sctap:hasStructureBlock rdf:resource="http://scta.info/resource/{@xml:id}"/>
    				</xsl:if>
    			</xsl:for-each>
          <!-- END record paragraph per item -->
    			
    			<!-- BEGIN identifying all child structureDivision expressions contained by structureItem -->
    			<xsl:for-each select="document($extraction-file)//tei:body/tei:div/tei:div">
    				<xsl:variable name="divisionID">
    					<xsl:choose>
    						<xsl:when test="./@xml:id">
    							<xsl:value-of select="./@xml:id"/>
    						</xsl:when>
    						<xsl:otherwise>
    							<!-- TODO: this block will be used again; best to refactor and create as a separate function -->
    							<xsl:variable name="totalDivs" select="count(document($extraction-file)//tei:body/tei:div//tei:div)"/>
    							<xsl:variable name="totalFollowingDivs" select="count(.//following::tei:div)"></xsl:variable>
    							<xsl:variable name="divId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalDivs - $totalFollowingDivs)"/>
    							<xsl:value-of select="concat('div-', $divId)"/>
    						</xsl:otherwise>
    					</xsl:choose> 
    				</xsl:variable>
    			  <dcterms:hasPart rdf:resource="http://scta.info/resource/{$divisionID}"/>
    			  <!-- below is replaced by hasPart which is the correct way to walk down the tree from top level collection to lowest block element -->
    				<!-- TODO: this should be deleted in light of above hasPart replacement <sctap:hasStructureDivision rdf:resource="http://scta.info/resource/{$divisionID}"/> -->
		    		
    			</xsl:for-each>
    			<!-- END structureDivision identifications -->
    			
    			<!-- get manifestation for critical edition -->
    			<xsl:if test="document($text-path)">
    				<!-- TODO review hard coding of prefix for critical manifestation -->
    				<sctap:hasManifestation rdf:resource="http://scta.info/resource/{$fs}/critical"/>
    			</xsl:if>
    			
    			<!-- Identify Manifestations corresponding to Expressions at the structureItem level -->
    			<!-- this block is repeated 4 times. here, in the division creation, the block creation, and element creation -->
    			<xsl:for-each select="$itemWitnesses">
    				<xsl:variable name="wit-ref"><xsl:value-of select="substring-after(./@ref, '#')"/></xsl:variable>
    				<xsl:variable name="wit-slug"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/slug"/></xsl:variable>
    				<xsl:variable name="transcription-text-path" select="concat($textfilesdir, $fs, '/', $wit-slug, '_', $fs, '.xml')"/>
    				
    				<sctap:hasManifestation rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}"/>
    			</xsl:for-each>
    		  
    		  <xsl:for-each select="$translationManifestations">
    		    <sctap:hasTranslation rdf:resource="http://scta.info/resource/{$fs}/{.}"/>
    		  </xsl:for-each>
    			
    			<!-- Identify Canonical Manifestation and canonical for Expression at the structureItem level -->
    				<!--TODO: it is not ideal to ripping this information from the file path; it would be better if the projectdata file or transcription.xml file indicated this information -->
    				
    			
    			<sctap:hasCanonicalManifestation rdf:resource="http://scta.info/resource/{$fs}/{$canonical-manifestation-id}"/>
    			<!-- end create canonical Manifestation and Transcription entires -->
    			
    			
    		
    		<!-- TODO: add link to first level structureType division found in the tei document; 
    			this level of div is captured by the following expath in the LombardPress schema //tei:body/tei:div/tei:div -->
    		  
    		  <!-- create ldn inbox -->
    		  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$fs}"/>
    		</rdf:Description>
    	  
    	  <!-- Begin create translation manifestation for structureType=structureItem -->
    	  <xsl:for-each select="$translationManifestations">
    	    <xsl:variable name="trans-manifestation-slug" select="."/>
    	    <rdf:Description rdf:about="http://scta.info/resource/{$fs}/{$trans-manifestation-slug}">
    	      <dc:title> <xsl:value-of select="$fs"/> [translation]</dc:title>
    	      <dc:language><xsl:value-of select="./@language"/></dc:language>
    	      <rdf:type rdf:resource="http://scta.info/resource/translation"/>
    	      <sctap:structureType rdf:resource="http://scta.info/resource/structureItem"/>
    	      <sctap:isPartOfTopLevelManifestation rdf:resource="http://scta.info/resource/{$cid}/{$trans-manifestation-slug}"/>
    	      <sctap:shortId><xsl:value-of select="concat($fs, '/', $trans-manifestation-slug)"/></sctap:shortId>
    	      <sctap:isTranslationOf rdf:resource="http://scta.info/resource/{$fs}"/>
    	      
    	      <xsl:for-each select="$translationTranscriptions">
    	        <xsl:if test="./@canonical eq 'true'">
    	          <sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$fs}/{$trans-manifestation-slug}/{./@name}"/>
    	        </xsl:if>
    	        <xsl:if test="./@isTranslationOf eq $trans-manifestation-slug">
    	          <sctap:hasTranscription rdf:resource="http://scta.info/resource/{$fs}/{$trans-manifestation-slug}/{./@name}"/>
    	        </xsl:if>
    	      </xsl:for-each>
    	      <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$fs}/{.}"/>
    	    </rdf:Description>
    	  </xsl:for-each>
    	  <!-- END create translation manifestation for structureType=structureBlock -->
    	  
    	  <!-- Begin translation transcription for structureType=structureItem -->
    	  <xsl:for-each select="$translationTranscriptions">
    	    <xsl:variable name="languague" select="./@language"/>
    	    <xsl:variable name="isTranslationOf" select="./@isTranslationOf"/>
    	    <xsl:variable name="hash" select="./@hash"/>
    	    <xsl:variable name="name" select="./@name"/>
    	    <xsl:variable name="type" select="./@type"/>
    	    <xsl:variable name="filename" select="./text()"/>
    	    <rdf:Description rdf:about="http://scta.info/resource/{$fs}/{$isTranslationOf}/{$name}">
    	      <dc:title><xsl:value-of select="$fs"/> [Translation]</dc:title>
    	      <rdf:type rdf:resource="http://scta.info/resource/transcription"/>
    	      <sctap:structureType rdf:resource="http://scta.info/resource/structureItem"/>
    	      <sctap:plaintext rdf:resource="http://scta.lombardpress.org/text/plaintext/{$fs}/{$isTranslationOf}/{$name}"/>
    	      <sctap:isPartOfTopLevelTranscription rdf:resource="http://scta.info/resource/{$cid}/{$isTranslationOf}/{$name}"/>
    	      <sctap:shortId><xsl:value-of select="concat($fs, '/', $isTranslationOf, '/', $name)"/></sctap:shortId>
    	      <sctap:isTranscriptionOf rdf:resource="http://scta.info/resource/{$fs}/{$isTranslationOf}"/>
    	      <sctap:transcriptionType><xsl:value-of select="$type"/></sctap:transcriptionType>
    	      
    	      <xsl:choose>
    	        <xsl:when test="$hash eq 'head'">
    	          <xsl:choose>
    	            <xsl:when test="$gitRepoStyle = 'toplevel'">
    	              <sctap:hasDocument rdf:resource="{$gitRepoBase}{lower-case($cid)}/raw/master/{$fs}/{$filename}"/>
    	            </xsl:when>
    	            <xsl:otherwise>
    	              <sctap:hasDocument rdf:resource="{$gitRepoBase}{lower-case($fs)}/raw/master/{$filename}"/>
    	            </xsl:otherwise>	
    	          </xsl:choose>
    	          <sctap:ipfsHash></sctap:ipfsHash>
    	        </xsl:when>
    	        <xsl:otherwise>
    	          <sctap:hasDocument rdf:resource="https://gateway.ipfs.io/ipfs/{$hash}"/>
    	          <sctap:ipfsHash><xsl:value-of select="$hash"/></sctap:ipfsHash>
    	        </xsl:otherwise>
    	      </xsl:choose>
    	      <xsl:if test="./@hasSuccessor">
    	        <sctap:hasSuccessor rdf:resource="{./@hasSuccessor}"></sctap:hasSuccessor>
    	      </xsl:if>
    	      <!-- set location text part can be accessed as xml file without an intermediary processing -->
    	      <sctap:hasXML rdf:resource="http://exist.scta.info/exist/apps/scta-app/document/{$fs}/{$isTranslationOf}/{$name}"/>
    	      <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$fs}/{$isTranslationOf}/{$name}"/>
    	      
    	    </rdf:Description>
    	  </xsl:for-each>
    	  
    		<!-- END Item resource creation -->
    		
    		<!-- BEGIN expression creation with structureType=structureDivision resource creation -->
    		<xsl:for-each  select="document($extraction-file)//tei:body/tei:div//tei:div">
    			
    			<xsl:variable name="div-number"><xsl:number count="tei:div[parent::*[not(name()='body')]]" level="multiple" format="1"/></xsl:variable>
    			<xsl:variable name="divisionID">
             <xsl:choose>
               <xsl:when test="./@xml:id">
                 <xsl:value-of select="./@xml:id"/>
               </xsl:when>
               <xsl:otherwise>
               		<!-- TODO: this procedure is used above to create refering ids for divs; it be a refactored into a generic function for the 
               			auto creation of ids for all resources that do not include an @xml:id 
               			
               		TODO: lots of confusion can occur when generating new ids, might best to skip creation of resources that do not have an xml:id 
               		as I do for paragraphs
               		-->
               		<xsl:variable name="totalDivs" select="count(document($extraction-file)//tei:body/tei:div//tei:div)"/>
    							<xsl:variable name="totalFollowingDivs" select="count(.//following::tei:div)"></xsl:variable>
    							<xsl:variable name="divId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalDivs - $totalFollowingDivs)"/>
    							<xsl:value-of select="concat('div-', $divId)"/>
               </xsl:otherwise>
             </xsl:choose> 
            </xsl:variable> 
            
    			<xsl:variable name="divisionExpressionType">
              <xsl:choose>
                <xsl:when test="./@type">
                  <xsl:value-of select="./@type"/>
                </xsl:when>
                <xsl:otherwise>division</xsl:otherwise>
              </xsl:choose> 
            </xsl:variable>
    			
    			<rdf:Description rdf:about="http://scta.info/resource/{$divisionID}">
    			  <!-- title xpath is set to ./head[1] to ensure that it grabs the first head and not any subtitles -->
    				<dc:title><xsl:value-of select="./tei:head[1]"/></dc:title>
    				<rdf:type rdf:resource="http://scta.info/resource/expression"/>
    				<dcterms:isPartOf rdf:resource="http://scta.info/resource/{$fs}"/>
    				
    				<sctap:expressionType rdf:resource="http://scta.info/resource/{$divisionExpressionType}"/>
    				<sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$fs}"/>
    				<sctap:isPartOfTopLevelExpression rdf:resource="http://scta.info/resource/{$cid}"/>
    				<sctap:structureType rdf:resource="http://scta.info/resource/structureDivision"/>
    				
    				<sctap:shortId><xsl:value-of select="$divisionID"/></sctap:shortId>
    				
    				<!-- TODO: decide if dts is desired
    					<xsl:variable name="div-urn" select="$div-number"/>
    					<sctap:dtsurn><xsl:value-of select="concat($item-dtsurn, '.', $div-urn)"/></sctap:dtsurn>
    				-->
    				
    				<!-- BEGIN collect questionTitles from division header -->
    			  <!-- "questionTitle" attribute value is depreciated. It should be "question-title" -->
            <xsl:choose>
              <xsl:when test="./tei:head/@type='questionTitle'">
                <sctap:questionTitle><xsl:value-of select="./tei:head[@type='questionTitle']"/></sctap:questionTitle>
              </xsl:when>
              <xsl:when test="./tei:head/@type='question-title'">
                <sctap:questionTitle><xsl:value-of select="./tei:head[@type='question-title']"/></sctap:questionTitle>
              </xsl:when>
              <xsl:when test="./tei:head/tei:seg/@type='questionTitle'">
                <sctap:questionTitle><xsl:value-of select="./tei:head/tei:seg[@type='questionTitle']"/></sctap:questionTitle>
              </xsl:when>
              <xsl:when test="./tei:head/tei:seg/@type='question-title'">
                <sctap:questionTitle><xsl:value-of select="./tei:head/tei:seg[@type='question-title']"/></sctap:questionTitle>
              </xsl:when>
            </xsl:choose>
            <!-- END collect questionTitles from divisions headers -->
    				
    				<!-- BEGINS child structureDivision identifications -->
    				<xsl:for-each select="./tei:div">
    					<xsl:variable name="divisionID">
    						<xsl:choose>
    							<xsl:when test="./@xml:id">
    								<xsl:value-of select="./@xml:id"/>
    							</xsl:when>
    							<xsl:otherwise>
    								<!-- TODO: this block will be used again; best to refactor and create as a separate function -->
    								<xsl:variable name="totalDivs" select="count(document($extraction-file)//tei:body/tei:div//tei:div)"/>
    								<xsl:variable name="totalFollowingDivs" select="count(.//following::tei:div)"></xsl:variable>
    								<xsl:variable name="divId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalDivs - $totalFollowingDivs)"/>
    								<xsl:value-of select="concat('div-', $divId)"/>
    							</xsl:otherwise>
    						</xsl:choose> 
    					</xsl:variable>
    				  <dcterms:hasPart rdf:resource="http://scta.info/resource/{$divisionID}"/>
    				  <!-- below is replaced by hasPart which is the correct way to walk down the tree from top level collection to lowest block element -->
    					<!-- TODO: this should be deleted <sctap:hasStructureDivision rdf:resource="http://scta.info/resource/{$divisionID}"/> -->
    				</xsl:for-each>
    				<!-- END child structureDivision identifications -->
    				
    				<!-- BEGIN structureBlock identifications -->
              <xsl:for-each select=".//tei:p">
                <xsl:if test="./@xml:id">
                  <sctap:hasStructureBlock rdf:resource="http://scta.info/resource/{@xml:id}"/>
                </xsl:if>
              </xsl:for-each>
    				<!-- END structureBlock collections -->
                  
            <!-- Begins connection assertions collection -->      
            <xsl:for-each select="document($info-path)//div[@xml:id=$divisionID]/assertions//assertion">
              <!-- this ideal is to include the full rdf stament int he info file and then coppy it
                but not working because namespace is still added-->
              <!-- <xsl:copy-of copy-namespaces="no" select="."/> -->
              <!-- below is an unappy substitute for the time being -->
              <xsl:choose>
                <xsl:when test="./@property eq 'abbreviates'">
                  <xsl:variable name="target" select="./@target"></xsl:variable>
                  <sctap:abbreviates rdf:resource="{$target}"/>
                </xsl:when>
                <xsl:when test="./@property eq 'abbreviatedBy'">
                  <xsl:variable name="target" select="./@target"></xsl:variable>
                  <sctap:abbreviatedBy rdf:resource="{$target}"/>
                </xsl:when>
                <xsl:when test="./@property eq 'referencedBy'">
                  <xsl:variable name="target" select="./@target"></xsl:variable>
                  <sctap:referencedBy rdf:resource="{$target}"/>
                </xsl:when>
              </xsl:choose>
            </xsl:for-each>
    				
    				<!-- get manifestation for critical edition -->
    				<xsl:if test="document($text-path)">
    					<!-- TODO review hard coding of prefix for critical manifestation -->
    					<sctap:hasManifestation rdf:resource="http://scta.info/resource/{$divisionID}/critical"/>
    				</xsl:if>
    				
    				<xsl:for-each select="$itemWitnesses">
    					<xsl:variable name="wit-ref"><xsl:value-of select="substring-after(./@ref, '#')"/></xsl:variable>
    					<xsl:variable name="wit-slug"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/slug"/></xsl:variable>
    					<xsl:variable name="transcription-slug" select="concat($wit-slug, '_', $fs)"/>
    					<sctap:hasManifestation rdf:resource="http://scta.info/resource/{$divisionID}/{$wit-slug}"/>
    				</xsl:for-each>
    			  
    			  <xsl:for-each select="$translationManifestations">
    			    <sctap:hasTranslation rdf:resource="http://scta.info/resource/{$divisionID}/{.}"/>
    			  </xsl:for-each>
    				
    				<!-- create canonicalManifestation and Transcriptions references for structureType=structureDivision -->
    				<sctap:hasCanonicalManifestation rdf:resource="http://scta.info/resource/{$divisionID}/{$canonical-manifestation-id}"/>
    				
    			  <!-- create ldn inbox -->
    			  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$divisionID}"/>
    			  
    			</rdf:Description>
    		</xsl:for-each>
    		<!-- END Div resource creation -->
    		
    		<!-- BEGIN expression create for structureType=structureBlock resources -->
    		
    		
    		<xsl:for-each select="document($extraction-file)//tei:body//tei:p">
    			<!-- only creates paragraph resource if that paragraph has been assigned an id -->
    			<xsl:if test="./@xml:id">
    				<xsl:variable name="pid" select="./@xml:id"/>
    				<xsl:variable name="pid_ref" select="concat('#', ./@xml:id)"/>
    				
    				<rdf:Description rdf:about="http://scta.info/resource/{$pid}">
    					<dc:title>Paragraph <xsl:value-of select="$pid"/></dc:title>
    					<rdf:type rdf:resource="http://scta.info/resource/expression"/>
    					
    					<!-- TODO: had dcterms:isPartOf that points to the immediate parent resource, mostly likely structureType=structureDivision but could be structureType=structureItem -->
    					
    					<sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$fs}"/>
    					<sctap:isPartOfTopLevelExpression rdf:resource="http://scta.info/resource/{$cid}"/>
    					<sctap:structureType rdf:resource="http://scta.info/resource/structureBlock"/>
    					<sctap:shortId><xsl:value-of select="$pid"/></sctap:shortId>
    					
    					<!-- indicate status of expression at structureBlock Level -->
    					<!-- NOTE: this block is getting used several times; it should be refactored into a function -->
    					<xsl:choose>
    						<xsl:when test="document($extraction-file)//tei:revisionDesc/@status">
    							<sctap:status><xsl:value-of select="document($extraction-file)//tei:revisionDesc/@status"></xsl:value-of></sctap:status>
    						</xsl:when>
    						<xsl:when test="document($extraction-file)">
    							<sctap:status>In Progress</sctap:status>
    						</xsl:when>
    						<xsl:otherwise>
    							<sctap:status>Not Started</sctap:status>
    						</xsl:otherwise>
    					</xsl:choose>
    					<!-- end indicate status -->
    					
    					<!-- get manifestation for critical edition -->
    					<xsl:if test="document($text-path)">
    						<!-- TODO review hard coding of prefix for critical manifestation -->
    						<sctap:hasManifestation rdf:resource="http://scta.info/resource/{$pid}/critical"/>
    					</xsl:if>
    					<xsl:for-each select="$itemWitnesses">
                <xsl:variable name="wit-ref"><xsl:value-of select="substring-after(./@ref, '#')"/></xsl:variable>
                <xsl:variable name="wit-slug"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/slug"/></xsl:variable>
                <xsl:variable name="transcription-slug" select="concat($wit-slug, '_', $fs)"/>
    						<sctap:hasManifestation rdf:resource="http://scta.info/resource/{$pid}/{$wit-slug}"/>
              </xsl:for-each>
    					
    				  <xsl:for-each select="$translationManifestations">
    				    <sctap:hasTranslation rdf:resource="http://scta.info/resource/{$pid}/{.}"/>
    				  </xsl:for-each>
    				  
    					<sctap:hasCanonicalManifestation rdf:resource="http://scta.info/resource/{$pid}/{$canonical-manifestation-id}"/>
    					
    					
    					<!-- BEGIN collection of info assertions -->
    					<!--  note info.xml is not in Tei namespace -->
    					<xsl:for-each select="document($info-path)//p[@xml:id=$pid]/assertions//assertion">
                <!-- this ideal is to include the full rdf stament int he info file and then coppy it
	              but not working because namespace is still added-->
	              <!-- <xsl:copy-of copy-namespaces="no" select="."/> -->
	              <!-- below is an unappy substitute for the time being -->
    						<xsl:choose>
	                <xsl:when test="./@property eq 'abbreviates'">
	                  <xsl:variable name="target" select="./@target"></xsl:variable>
	                  <sctap:abbreviates rdf:resource="{$target}"/>
	                </xsl:when>
	                <xsl:when test="./@property eq 'abbreviatedBy'">
	                  <xsl:variable name="target" select="./@target"></xsl:variable>
	                  <sctap:abbreviatedBy rdf:resource="{$target}"/>
	                </xsl:when>
    							<xsl:when test="./@property eq 'isRelatedTo'">
    								<xsl:variable name="target" select="./@target"></xsl:variable>
    								<sctap:isRelatedTo rdf:resource="{$target}"/>
    							</xsl:when>
    						</xsl:choose>
    					</xsl:for-each>
                   
                    
              <!-- order -->
              <xsl:variable name="paragraphnumber"><xsl:value-of select="count(document($extraction-file)//tei:body//tei:p) - count(document($extraction-file)//tei:body//tei:p[preceding::tei:p[@xml:id=$pid]])"/></xsl:variable>
              <sctap:paragraphNumber><xsl:value-of select="$paragraphnumber"/></sctap:paragraphNumber>
              <!-- next -->
              <xsl:variable name="nextpid" select="document($extraction-file)//tei:p[@xml:id=$pid]/following::tei:p[1]/@xml:id"/>
              <sctap:next rdf:resource="http://scta.info/resource/{$nextpid}"/>
    					
    					<!-- previous -->
    					<xsl:variable name="previouspid" select="document($extraction-file)//tei:p[@xml:id=$pid]/preceding::tei:p[1]/@xml:id"/>
    					<sctap:previous rdf:resource="http://scta.info/resource/{$previouspid}"/>
                    
              <!-- TODO: decide if dts urn is worth the trouble here
              <xsl:variable name="div-number"><xsl:number count="tei:div[parent::*[not(name()='body')]]" level="multiple" format="1"/></xsl:variable>
              <xsl:variable name="paragraph-dtsurn">
                <xsl:choose>
                  <xsl:when test="document($extraction-file)//tei:body/tei:div//tei:div">
                    <xsl:value-of select="concat($item-dtsurn, '.', $div-number, '.p', $paragraphnumber)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="concat($item-dtsurn, '.p', $paragraphnumber)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
                
              <sctap:dtsurn><xsl:value-of select="$paragraph-dtsurn"/></sctap:dtsurn>
              
              end of dts number creation 
              -->
                    
              <!-- begin level creation -->
              <sctap:level><xsl:value-of select="$item-level + 1"/></sctap:level>
              <!-- end level creation -->
                    
              <!-- references/referencedBy; loop over references in paragraph themselves.  -->
              <!-- quotes -->
              
              <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:name">
                <xsl:variable name="nameRef" select="./@ref"></xsl:variable>
                <xsl:variable name="nameID" select="substring-after($nameRef, '#')"></xsl:variable>
                <xsl:variable name="totalNames" select="count(document($extraction-file)//tei:body//tei:name)"/>
                <xsl:variable name="totalFollowingNames" select="count(.//following::tei:name)"></xsl:variable>
                <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-N-', $totalNames - $totalFollowingNames)"/>
                <xsl:if test="$nameRef">
                  <sctap:mentions rdf:resource="http://scta.info/resource/{$nameID}"/>
                </xsl:if>
                <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$objectId}"/>
              </xsl:for-each>
              <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:title">
                <xsl:variable name="titleRef" select="./@ref"></xsl:variable>
                <xsl:variable name="titleID" select="substring-after($titleRef, '#')"></xsl:variable>
                <xsl:variable name="totalTitles" select="count(document($extraction-file)//tei:body//tei:title)"/>
                <xsl:variable name="totalFollowingTitles" select="count(.//following::tei:title)"></xsl:variable>
                <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-T-', $totalTitles - $totalFollowingTitles)"/>
                <xsl:if test="$titleRef">
                  <sctap:mentions rdf:resource="http://scta.info/resource/{$titleID}"/>
                </xsl:if>
                  <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$objectId}"/>
                
              </xsl:for-each>
    					<xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:quote[contains(./@source, 'http://scta.info/resource')]">
                <xsl:variable name="commentarySectionUrl" select="./@source"></xsl:variable>
                <xsl:variable name="totalQuotes" select="count(document($extraction-file)//tei:body//tei:quote)"/>
                <xsl:variable name="totalFollowingQuotes" select="count(.//following::tei:quote)"></xsl:variable>
                <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-Q-', $totalQuotes - $totalFollowingQuotes)"/>
                <sctap:quotes rdf:resource="{$commentarySectionUrl}"/>
                <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$objectId}"/>
              </xsl:for-each>
              <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:quote">
                <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
                <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
                <xsl:variable name="totalQuotes" select="count(document($extraction-file)//tei:body//tei:quote)"/>
                <xsl:variable name="totalFollowingQuotes" select="count(.//following::tei:quote)"></xsl:variable>
                <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-Q-', $totalQuotes - $totalFollowingQuotes)"/>
                <xsl:if test="$quoteRef">
                  <sctap:quotes rdf:resource="http://scta.info/resource/{$quoteID}"/>
                </xsl:if>
                <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$objectId}"/>
              </xsl:for-each>
              
              <!-- [not(ancestor::tei:bibl] excludes references made in bibl elements -->
              <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:ref[contains(./@target,'http://scta.info/resource')][not(ancestor::tei:bibl)]">
                <xsl:variable name="commentarySectionUrl" select="./@target"></xsl:variable>
                <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
                <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
                <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-R-', $totalRefs - $totalFollowingRefs)"/>
                <sctap:references rdf:resource="{$commentarySectionUrl}"/>
                <sctap:hasStructureElement rdf:resource="http://scta.info/resource{$objectId}"/>
              </xsl:for-each>
              
              <!-- default is ref referring to quotation resource or type="quotation" -->  
              <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:ref">
                <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
                <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
                <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
                <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
                <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-R-', $totalRefs - $totalFollowingRefs)"/>
                <xsl:if test="$quoteRef">
                  <sctap:references rdf:resource="http://scta.info/resource/{$quoteID}"/>
                </xsl:if>
                <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$objectId}"/>
              </xsl:for-each>
              
              <!--- end of logging name, title, quote, and ref asserts for paragraph examplar -->
              
    				  <!-- create ldn inbox -->
    				  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$pid}"/>
    				  
            </rdf:Description>
    			</xsl:if>
    		</xsl:for-each>
        
        <!-- end of expression structureType=structureBlock resource creation -->
        
          
        <!-- begin create expression structureType=structureElement resources creation -->
        <xsl:for-each select="document($extraction-file)//tei:body//tei:name">
          <xsl:variable name="nameRef" select="@ref"/>
          <xsl:variable name="nameID" select="substring-after($nameRef, '#')"/>
          <xsl:variable name="totalNames" select="count(document($extraction-file)//tei:body//tei:name)"/>
          <xsl:variable name="totalFollowingNames" select="count(.//following::tei:name)"></xsl:variable>
          <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-N-', $totalNames - $totalFollowingNames)"/>
        	<xsl:variable name="paragraphParent" select=".//ancestor::tei:p/@xml:id"/>
          <rdf:Description rdf:about="http://scta.info/resource/{$objectId}">
            <rdf:type rdf:resource="http://scta.info/resource/expression"/>
            <sctap:structureType rdf:resource="http://scta.info/resource/structureElement"/>
            <sctap:structureElementType rdf:resource="http://scta.info/resource/structureElementName"/>
            <xsl:if test="$nameRef">
              <sctap:isInstanceOf rdf:resource="http://scta.info/resource/{$nameID}"/>
            </xsl:if>
            <sctap:structureElementText><xsl:value-of select="."/></sctap:structureElementText>
            <sctap:isPartOfStructureBlock rdf:resource="http://scta.info/resource/{$paragraphParent}"/>
          	<sctap:shortId><xsl:value-of select="$objectId"/></sctap:shortId>
          	<sctap:isPartOfTopLevelExpression rdf:resource="http://scta.info/resource/{$cid}"/>
          	<!-- TODO addd manifestation identifcation create; use the block of code used above to make these assertsion at the item, div, and block level 
          	this will be block will repeated in each of the three following structureElements creation. Therefore it should be placed in separate function, 
          	so it can be resued 7 seven different times 
          	-->
          	
          </rdf:Description>
        </xsl:for-each>
        <xsl:for-each select="document($extraction-file)//tei:body//tei:title">
          <xsl:variable name="titleRef" select="./@ref"></xsl:variable>
          <xsl:variable name="titleID" select="substring-after($titleRef, '#')"></xsl:variable>
          <xsl:variable name="totalTitles" select="count(document($extraction-file)//tei:body//tei:title)"/>
          <xsl:variable name="totalFollowingTitles" select="count(.//following::tei:title)"></xsl:variable>
          <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-T-', $totalTitles - $totalFollowingTitles)"/>
        	<xsl:variable name="paragraphParent" select=".//ancestor::tei:p/@xml:id"/>
          <rdf:Description rdf:about="http://scta.info/resource/{$objectId}">
            <rdf:type rdf:resource="http://scta.info/resource/expression"/>
            <sctap:structureType rdf:resource="http://scta.info/resource/structureElement"/>
            <sctap:structureElementType rdf:resource="http://scta.info/resource/structureElementTitle"/>
            <xsl:if test="$titleRef">
              <sctap:isInstanceOf rdf:resource="http://scta.info/resource/{$titleID}"/>
            </xsl:if>
            <sctap:structureElementText><xsl:value-of select="."/></sctap:structureElementText>
            <sctap:isPartOfStructureBlock rdf:resource="http://scta.info/resource/{$paragraphParent}"/>
          	<sctap:shortId><xsl:value-of select="$objectId"/></sctap:shortId>
          	<sctap:isPartOfTopLevelExpression rdf:resource="http://scta.info/resource/{$cid}"/>
          </rdf:Description>
        </xsl:for-each>
        <xsl:for-each select="document($extraction-file)//tei:body//tei:quote">
          <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
          <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
          <xsl:variable name="totalQuotes" select="count(document($extraction-file)//tei:body//tei:quote)"/>
          <xsl:variable name="totalFollowingQuotes" select="count(.//following::tei:quote)"></xsl:variable>
          <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-Q-', $totalQuotes - $totalFollowingQuotes)"/>
          <xsl:variable name="paragraphParent" select=".//ancestor::tei:p/@xml:id"/>
          <rdf:Description rdf:about="http://scta.info/resource/{$objectId}">
            <rdf:type rdf:resource="http://scta.info/resource/expression"/>
          	<sctap:structureType rdf:resource="http://scta.info/resource/structureElement"/>
            <sctap:structureElementType rdf:resource="http://scta.info/resource/structureElementQuote"/>
            <xsl:if test="$quoteRef">
              <sctap:isInstanceOf rdf:resource="http://scta.info/resource/{$quoteID}"/>
            </xsl:if>
            <sctap:structureElementText><xsl:value-of select="."/></sctap:structureElementText>
            <sctap:isPartOfStructureBlock rdf:resource="http://scta.info/resource/{$paragraphParent}"/>
          	<sctap:shortId><xsl:value-of select="$objectId"/></sctap:shortId>
          	<sctap:isPartOfTopLevelExpression rdf:resource="http://scta.info/resource/{$cid}"/>
            <!-- begin assert all manifestation Quotes -->
            <xsl:if test="document($text-path)">
              <!-- TODO review hard coding of prefix for critical manifestation -->
              <sctap:hasManifestation rdf:resource="http://scta.info/resource/{$objectId}/critical"/>
            </xsl:if>
            <xsl:for-each select="$itemWitnesses">
              <xsl:variable name="wit-ref"><xsl:value-of select="substring-after(./@ref, '#')"/></xsl:variable>
              <xsl:variable name="wit-slug"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/slug"/></xsl:variable>
              <sctap:hasManifestation rdf:resource="http://scta.info/resource/{$objectId}/{$wit-slug}"/>
            </xsl:for-each>
            <!-- end log all manifesetaiton quotes -->
          </rdf:Description>
        </xsl:for-each>
        
        <xsl:for-each select="document($extraction-file)//tei:body//tei:ref">
          <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
          <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
          <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
          <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
          <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-R-', $totalRefs - $totalFollowingRefs)"/>
        	<xsl:variable name="paragraphParent" select=".//ancestor::tei:p/@xml:id"/>
          <rdf:Description rdf:about="http://scta.info/resource/{$objectId}">
            <rdf:type rdf:resource="http://scta.info/resource/expression"/>
          	<sctap:structureType rdf:resource="http://scta.info/resource/structureElement"/>
            <sctap:structureElementType rdf:resource="http://scta.info/resource/structureElementRef"/>
            <xsl:if test="$quoteRef">
              <sctap:isInstanceOf rdf:resource="http://scta.info/resource/{$quoteID}"/>
            </xsl:if>
            <sctap:structureElementText><xsl:value-of select="."/></sctap:structureElementText>
            <sctap:isPartOfStructureBlock rdf:resource="http://scta.info/resource/{$paragraphParent}"/>
          	<sctap:shortId><xsl:value-of select="$objectId"/></sctap:shortId>
          	<sctap:isPartOfTopLevelExpression rdf:resource="http://scta.info/resource/{$cid}"/>
          </rdf:Description>
        </xsl:for-each>
        <!-- resource creation for Sentences Commentary passage is not needed -->        
        <!-- end create element resources -->
        
        <!-- begin create critical transcription resource for structureItem Level -->
          <xsl:if test="document($text-path)">
            <xsl:variable name="critical-transcript-title" select="document($text-path)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
            <xsl:variable name="critical-transcript-editor" select="document($text-path)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor"/>
            
            <!-- NOTE: if there were more than one transcription for a given manifestation, it could be named "critical-$fs-transcription2" -->
            <!-- NOTE: if a resource were neede for the material Item that the transcription is made of it could "critical-$fs-item" -->
            <rdf:Description rdf:about="http://scta.info/resource/{$fs}/critical/transcription">
              <dc:title><xsl:value-of select="$critical-transcript-title"/></dc:title>
              <role:AUT rdf:resource="{$author-uri}"/>
              <role:EDT><xsl:value-of select="$critical-transcript-editor"/></role:EDT>
              <!-- <xsl:call-template name="status">
                  <xsl:with-param name="text-path" select="$text-path"/>
              </xsl:call-template> -->
              <xsl:choose>
                  <xsl:when test="document($text-path)//tei:revisionDesc/@status">
                      <sctap:status><xsl:value-of select="document($text-path)//tei:revisionDesc/@status"></xsl:value-of></sctap:status>
                  </xsl:when>
                  <xsl:when test="document($text-path)">
                      <sctap:status>In Progress</sctap:status>
                  </xsl:when>
                  <xsl:otherwise>
                      <sctap:status>Not Started</sctap:status>
                  </xsl:otherwise>
              </xsl:choose>
              
              <rdf:type rdf:resource="http://scta.info/resource/transcription"/>
            	<sctap:structureType rdf:resource="http://scta.info/resource/structureItem"/>
              <sctap:isTranscriptionOf rdf:resource="http://scta.info/resource/{$fs}/critical"/>
              <!-- TODO: infomration about nameing of critical edition and type should come from project data or transcription file rather 
                than being hard coded. It works as is, if there is only one critical transcription, but if there were more than one it 
                would cease to work -->
              <sctap:transcriptionType>Critical</sctap:transcriptionType>
              
              <xsl:for-each select="document($text-path)//tei:body//tei:p">
                <xsl:variable name="pid" select="./@xml:id"/>
                <xsl:variable name="pid_ref" select="concat('#', ./@xml:id)"/>
              	<sctap:hasStructureBlock rdf:resource="http://scta.info/resource/{$pid}/critical/transcription"/>
              </xsl:for-each>
              <sctap:plaintext rdf:resource="http://scta.lombardpress.org/text/plaintext/{$fs}/critical/transcription"/>
            	<!-- NOTE: so if there was more than one critical transcription or we were mapping multiple version 
            		the transcription for an earlier editions would point to a previous tagged point in the commit history like so:
            		"https://bitbucket.org/jeffreycwitt/{$fs}/raw/1.0/{$fs}.xml" -->
            	<!-- requirement to lower case is bitbucket oddity that changges repo to lower case;
            		this would need to be adjusted after a switch to gitbut if github did not force repo names to lower case -->
              <xsl:choose>
                <xsl:when test="$gitRepoStyle = 'toplevel'">
                  <sctap:hasDocument rdf:resource="{$gitRepoBase}{lower-case($cid)}/raw/master/{$fs}/{$fs}.xml"/>
                </xsl:when>
                <xsl:otherwise>
                  <sctap:hasDocument rdf:resource="{$gitRepoBase}{lower-case($fs)}/raw/master/{$fs}.xml"/>
                </xsl:otherwise>	
              </xsl:choose>
            	
            	<sctap:hasXML rdf:resource="http://exist.scta.info/exist/apps/scta-app/document/{$fs}/critical/transcription"/>
            	<sctap:shortId><xsl:value-of select="concat($fs, '/', 'critical', '/', 'transcription')"/></sctap:shortId>
            	<sctap:isPartOfTopLevelTranscription rdf:resource="http://scta.info/resource/{$cid}/critical/transcription"/>
            	
              <!-- create ldn inbox -->
              <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$fs}/critical/transcription"/>
            </rdf:Description>
          	
          	<!-- BEGIN manifestation and transcription resource creation for structureDivision for critical manifestation -->
          	<xsl:for-each select="document($text-path)//tei:body/tei:div//tei:div">
          		<!-- only creates division resource if that division has been assigned an id -->
          		<xsl:if test="./@xml:id">
          			<xsl:variable name="divisionId" select="./@xml:id"/>
          			<xsl:variable name="divisionId_ref" select="concat('#', ./@xml:id)"/>
          			
          			<!-- create manifestation for critical structureDivision -->
          			<rdf:Description rdf:about="http://scta.info/resource/{$divisionId}/critical">
          				<dc:title>Division <xsl:value-of select="$divisionId"/></dc:title>
          				<rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
          				<sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$fs}/critical"/>
          				<sctap:isPartOfTopLevelManifestation rdf:resource="http://scta.info/resource/{$cid}/critical"/>
          				<sctap:shortId><xsl:value-of select="concat($divisionId, '/critical')"/></sctap:shortId>
          				<sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$divisionId}"/>
          				<sctap:hasTranscription rdf:resource="http://scta.info/resource/{$divisionId}/critical/transcription"/>
          				<sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$divisionId}/critical/transcription"/>
          			  <!-- create ldn inbox -->
          			  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$divisionId}/critical"/>
          			</rdf:Description>
          			
          			<!-- create transcription for critical structureDivision -->
          			<rdf:Description rdf:about="http://scta.info/resource/{$divisionId}/critical/transcription">
          				<dc:title>Division <xsl:value-of select="$divisionId"/> [critical transcription]</dc:title>
          				<rdf:type rdf:resource="http://scta.info/resource/transcription"/>
          				<sctap:plaintext rdf:resource="http://scta.lombardpress.org/text/plaintext/{$divisionId}/critical/transcription"/>
          				<sctap:structureType rdf:resource="http://scta.info/resource/structureDivision"/>
          				<sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$divisionId}/critical/transcription"/>
          				<sctap:isTranscriptionOf rdf:resource="http://scta.info/resource/{$divisionId}/critical"/>
          				<!-- add transcription type
              			TODO: not ideal to be harding this; should be getting from projectdata file or transcription.xml file -->
          				<sctap:transcriptionType>Critical</sctap:transcriptionType>
          			  
          			  <xsl:choose>
          			    <xsl:when test="$gitRepoStyle = 'toplevel'">
          			      <sctap:hasDocument rdf:resource="{$gitRepoBase}{lower-case($cid)}/raw/master/{$fs}/{$fs}.xml#{$divisionId}"/>
          			    </xsl:when>
          			    <xsl:otherwise>
          			      <sctap:hasDocument rdf:resource="{$gitRepoBase}{lower-case($fs)}/raw/master/{$fs}.xml#{$divisionId}"/>
          			    </xsl:otherwise>	
          			  </xsl:choose>
          			  
          			  
          				
          				<sctap:hasXML rdf:resource="http://exist.scta.info/exist/apps/scta-app/document/{$divisionId}/critical/transcription"/>
          				<sctap:shortId><xsl:value-of select="concat($divisionId, '/', 'critical', '/', 'transcription')"/></sctap:shortId>
          				<sctap:isPartOfTopLevelTranscription rdf:resource="http://scta.info/resource/{$cid}/critical/transcription"/>
          				
          				<!-- could add path to plain text version of paragraph -->
          				
          				<!-- begin status Declaration Block -->
          				<!-- TODO: refactor this into a reusable function -->
          				<xsl:choose>
          					<xsl:when test="document($text-path)//tei:revisionDesc/@status">
          						<sctap:status><xsl:value-of select="document($text-path)//tei:revisionDesc/@status"></xsl:value-of></sctap:status>
          					</xsl:when>
          					<xsl:when test="document($text-path)">
          						<sctap:status>In Progress</sctap:status>
          					</xsl:when>
          					<xsl:otherwise>
          						<sctap:status>Not Started</sctap:status>
          					</xsl:otherwise>
          				</xsl:choose>
          				<sctap:transcriptionType>Critical</sctap:transcriptionType>
          			  
          			  <!-- create ldn inbox -->
          			  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$divisionId}/critical/transcription"/>
          			</rdf:Description>
          			
          		</xsl:if>
          	</xsl:for-each>
          	<!-- END manifestation and transcription resource creation for structureDivision for critical manifestation -->
           
           <!-- BEGIN manifestation and transcription resource creation for structureBlock for critical manifestation -->
            <xsl:for-each select="document($text-path)//tei:body//tei:p">
              <!-- only creates paragraph resource if that paragraph has been assigned an id -->
              <xsl:if test="./@xml:id">
                <xsl:variable name="pid" select="./@xml:id"/>
                <xsl:variable name="pid_ref" select="concat('#', ./@xml:id)"/>
                
              	<!-- create manifestation for critical structureBlock -->
              	<rdf:Description rdf:about="http://scta.info/resource/{$pid}/critical">
              		<dc:title>Paragraph <xsl:value-of select="$pid"/></dc:title>
              		<rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
              		<sctap:structureType rdf:resource="http://scta.info/resource/structureBlock"/>
              		<sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$fs}/critical"/>
              		<sctap:isPartOfTopLevelManifestation rdf:resource="http://scta.info/resource/{$cid}/critical"/>
              		<sctap:shortId><xsl:value-of select="concat($pid, '/critical')"/></sctap:shortId>
              		<sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$pid}"/>
              		<sctap:hasTranscription rdf:resource="http://scta.info/resource/{$pid}/critical/transcription"/>
              		<sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$pid}/critical/transcription"/>
              	  
              	  <!-- create hasStructureElement assertion for quotations -->
              	  <!-- only creates if quotes have an xml:id -->
              	  <xsl:for-each select=".//tei:quote[@xml:id]">
              	    <xsl:variable name="this-quote-id" select="./@xml:id"/>
              	    <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$this-quote-id}/critical"/>
              	  </xsl:for-each>
              	  
              	  <!-- create ldn inbox -->
              	  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$pid}/critical"/>
              	</rdf:Description>
                
                <!-- BEGIN create translation manifestation for structureType=structureBlock -->
                <xsl:for-each select="$translationManifestations">
                  <rdf:Description rdf:about="http://scta.info/resource/{$pid}/{.}">
                    <dc:title>Paragraph <xsl:value-of select="$pid"/></dc:title>
                    <rdf:type rdf:resource="http://scta.info/resource/translation"/>
                    <sctap:structureType rdf:resource="http://scta.info/resource/structureBlock"/>
                    <sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$fs}/{.}"/>
                    <sctap:isPartOfTopLevelManifestation rdf:resource="http://scta.info/resource/{$cid}/{.}"/>
                    <sctap:shortId><xsl:value-of select="concat($pid, '/', .)"/></sctap:shortId>
                    <sctap:isTranslationOf rdf:resource="http://scta.info/resource/{$pid}"/>
                    <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$pid}/{.}"/>
                  </rdf:Description>
                </xsl:for-each>
                <!-- END create translation manifestation for structureType=structureBlock -->
                
                <!-- create translation transcription for structureType=structureBlock -->
                <xsl:for-each select="$translationTranscriptions">
                  <xsl:variable name="languague" select="./@language"/>
                  <xsl:variable name="isTranslationOf" select="./@isTranslationOf"/>
                  <xsl:variable name="hash" select="./@hash"/>
                  <xsl:variable name="name" select="./@name"/>
                  <xsl:variable name="type" select="./@hash"/>
                  <xsl:variable name="filename" select="./text()"/>
                  <rdf:Description rdf:about="http://scta.info/resource/{$pid}/{$isTranslationOf}/{$name}">
                    <dc:title>Paragraph <xsl:value-of select="$pid"/> [Translation]</dc:title>
                    <rdf:type rdf:resource="http://scta.info/resource/transcription"/>
                    <sctap:structureType rdf:resource="http://scta.info/resource/structureBlock"/>
                    <sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$fs}/{$isTranslationOf}/{$name}"/>
                    <sctap:plaintext rdf:resource="http://scta.lombardpress.org/text/plaintext/{$pid}/{$isTranslationOf}/{$name}"/>
                    <sctap:isPartOfTopLevelTranscription rdf:resource="http://scta.info/resource/{$cid}/{$isTranslationOf}/{$name}"/>
                    <sctap:shortId><xsl:value-of select="concat($pid, '/', $isTranslationOf, '/', $name)"/></sctap:shortId>
                    <sctap:isTranscriptionOf rdf:resource="http://scta.info/resource/{$pid}/{$isTranslationOf}"/>
                    <sctap:transcriptionType><xsl:value-of select="$type"/></sctap:transcriptionType>
                    
                    <xsl:choose>
                      <xsl:when test="$hash eq 'head'">
                        <xsl:choose>
                          <xsl:when test="$gitRepoStyle = 'toplevel'">
                            <sctap:hasDocument rdf:resource="{$gitRepoBase}{lower-case($cid)}/raw/master/{$fs}/{$filename}#{$pid}"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <sctap:hasDocument rdf:resource="{$gitRepoBase}{lower-case($fs)}/raw/master/{$filename}#{$pid}"/>
                          </xsl:otherwise>	
                        </xsl:choose>
                        <sctap:ipfsHash></sctap:ipfsHash>
                      </xsl:when>
                      <xsl:otherwise>
                        <sctap:hasDocument rdf:resource="https://gateway.ipfs.io/ipfs/{$hash}#{$pid}"/>
                        <sctap:ipfsHash><xsl:value-of select="$hash"/></sctap:ipfsHash>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="./@hasSuccessor">
                      <sctap:hasSuccessor><xsl:value-of select="./@hasSuccessor"/></sctap:hasSuccessor>
                    </xsl:if>
                    <!-- set location text part can be accessed as xml file without an intermediary processing -->
                    <sctap:hasXML rdf:resource="http://exist.scta.info/exist/apps/scta-app/document/{$pid}/{$isTranslationOf}/{$name}"/>
                    <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$pid}/{$isTranslationOf}/{$name}"/>
                    
                  </rdf:Description>
                </xsl:for-each>
                
                <!-- create structureElement for structure elements with critical structureBlock -->
                <!-- only creates for quotes if quote has an xml:id; refs, titles and names could be added here -->
                <xsl:for-each select=".//tei:quote[@xml:id]">
                  <xsl:variable name="this-quote-id" select="./@xml:id"/>
                  <rdf:Description rdf:about="http://scta.info/resource/{$this-quote-id}/critical">
                    <rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
                    <sctap:structureType rdf:resource="http://scta.info/resource/structureElement"/>
                    <sctap:structureElementType rdf:resource="http://scta.info/resource/structureElementQuote"/>
                    <sctap:structureElementText><xsl:value-of select="."/></sctap:structureElementText>
                    <sctap:isPartOfStructureBlock rdf:resource="http://scta.info/resource/{$pid}/critical"/>
                    <sctap:shortId><xsl:value-of select="concat($this-quote-id, '/', 'critical')"/></sctap:shortId>
                    <sctap:isPartOfTopLevelManifestation rdf:resource="http://scta.info/resource/{$cid}/critical"/>
                    <sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$this-quote-id}"/>
                  </rdf:Description>
                </xsl:for-each>
                
                
                <!-- create transcription for critical structureBlock -->
              	<rdf:Description rdf:about="http://scta.info/resource/{$pid}/critical/transcription">
                  <dc:title>Paragraph <xsl:value-of select="$pid"/> [critical transcription]</dc:title>
                  <rdf:type rdf:resource="http://scta.info/resource/transcription"/>
              		<sctap:structureType rdf:resource="http://scta.info/resource/structureBlock"/>
                  <sctap:plaintext rdf:resource="http://scta.lombardpress.org/text/plaintext/{$pid}/critical/transcription"/>
              		<sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$fs}/critical/transcription"/>
              		<sctap:isTranscriptionOf rdf:resource="http://scta.info/resource/{$pid}/critical"/>
              		<!-- add transcription type
              			TODO: not ideal to be harding this; should be getting from projectdata file or transcription.xml file -->
              		<sctap:transcriptionType>Critical</sctap:transcriptionType>
              		<!-- set document location, the location the text file that text part can be extracted from -->
              	  <xsl:choose>
              	    <xsl:when test="$gitRepoStyle = 'toplevel'">
              	      <sctap:hasDocument rdf:resource="{$gitRepoBase}{lower-case($cid)}/raw/master/{$fs}/{$fs}.xml#{$pid}"/>
              	    </xsl:when>
              	    <xsl:otherwise>
              	      <sctap:hasDocument rdf:resource="{$gitRepoBase}{lower-case($fs)}/raw/master/{$fs}.xml#{$pid}"/>
              	    </xsl:otherwise>	
              	  </xsl:choose>
              		<!-- set location text part can be accessed as xml file without an intermediary processing -->
              		<sctap:hasXML rdf:resource="http://exist.scta.info/exist/apps/scta-app/document/{$pid}/critical/transcription"/>
              		<sctap:shortId><xsl:value-of select="concat($pid, '/', 'critical', '/', 'transcription')"/></sctap:shortId>
              		<sctap:isPartOfTopLevelTranscription rdf:resource="http://scta.info/resource/{$cid}/critical/transcription"/>
              		
                  <!-- could add path to plain text version of paragraph -->
              		
              		<!-- begin status Declaration Block -->
              		<!-- TODO: refactor this into a reusable function -->
              		<xsl:choose>
              			<xsl:when test="document($text-path)//tei:revisionDesc/@status">
              				<sctap:status><xsl:value-of select="document($text-path)//tei:revisionDesc/@status"></xsl:value-of></sctap:status>
              			</xsl:when>
              			<xsl:when test="document($text-path)">
              				<sctap:status>In Progress</sctap:status>
              			</xsl:when>
              			<xsl:otherwise>
              				<sctap:status>Not Started</sctap:status>
              			</xsl:otherwise>
              		</xsl:choose>
              		
              	  <!-- create ldn inbox -->
              	  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$pid}/critical/transcription"/>
                </rdf:Description>
              	
              </xsl:if>
            </xsl:for-each>
          	<!-- END manifestation and transcription resource creation for structureBlock for critical manifestation -->
          </xsl:if>
    		 
    		 
    		<!-- create manifestation of critical manifesation at structureItem level -->
    		<!-- get manifestation for critical edition -->
    		<xsl:if test="document($text-path)">
    			<rdf:Description rdf:about="http://scta.info/resource/{$fs}/critical">
    				<dc:title><xsl:value-of select="$fs"/> [Critical]</dc:title>
    				<role:AUT rdf:resource="{$author-uri}"/>
    				<rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
    				<sctap:structureType rdf:resource="http://scta.info/resource/structureItem"/>
    				<sctap:hasTranscription rdf:resource="http://scta.info/resource/{$fs}/critical/transcription"/>
    				<sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$fs}/critical/transcription"/>
    				<sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$fs}"/>
    				<!-- TODO: conditional should eventually be removed -->
    				<xsl:choose>
    					<xsl:when test="$item-level eq 2">
    						<dcterms:isPartOf rdf:resource="http://scta.info/resource/{$cid}/critical"/>
    					</xsl:when>
    					<xsl:otherwise>
    						<dcterms:isPartOf rdf:resource="http://scta.info/resource/{$expressionParentId}/critical"/>	
    					</xsl:otherwise>
    				</xsl:choose>
    				<sctap:isPartOfTopLevelManifestation rdf:resource="http://scta.info/resource/{$cid}/critical"/>
    				<sctap:shortId><xsl:value-of select="concat($fs, '/critical')"/></sctap:shortId>
    				<sctap:hasSlug><xsl:value-of>critical</xsl:value-of></sctap:hasSlug>
    			  <!-- create ldn inbox -->
    			  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$fs}/critical"/>
    			</rdf:Description>
    		</xsl:if>
    		
    		<!-- create manifestation resources corresponding to expresions at the structureItem level -->
    		<xsl:for-each select="hasWitnesses/witness">
	        <xsl:variable name="wit-ref"><xsl:value-of select="substring-after(./@ref, '#')"/></xsl:variable>
	        <xsl:variable name="wit-slug"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/slug"/></xsl:variable>
	        <xsl:variable name="wit-initial"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/initial"/></xsl:variable>
	        <xsl:variable name="wit-title"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/title"/></xsl:variable>
	        <xsl:variable name="partOf"><xsl:value-of select="./preceding::fileName[1]/@filestem"></xsl:value-of></xsl:variable>
	        <xsl:variable name="partOfTitle"><xsl:value-of select="./preceding::fileName[1]/following-sibling::tei:title"/></xsl:variable>
	        <xsl:variable name="transcription-text-path" select="concat($textfilesdir, $fs, '/', $wit-slug, '_', $fs, '.xml')"/>
	        <xsl:variable name="iiif-ms-name" select="concat($commentaryslug, '-', $wit-slug)"/>
	        <xsl:variable name="canvasBase"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/canvasBase"/></xsl:variable>
                  
          <rdf:Description rdf:about="http://scta.info/resource/{$fs}/{$wit-slug}">
          	<dc:title><xsl:value-of select="$partOf"/> [<xsl:value-of select="$wit-title"/>]</dc:title>
            <role:AUT rdf:resource="{$author-uri}"/>
            <rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
          	<sctap:structureType rdf:resource="http://scta.info/resource/structureItem"/>
          	<sctap:isPartOfTopLevelManifestation rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
          	<!-- TODO: conditional should eventually be removed -->
          	<xsl:choose>
          		<xsl:when test="$item-level eq 2">
          			<dcterms:isPartOf rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
          		</xsl:when>
          		<xsl:otherwise>
          			<dcterms:isPartOf rdf:resource="http://scta.info/resource/{$expressionParentId}/{$wit-slug}"/>	
          		</xsl:otherwise>
          	</xsl:choose>
          	<sctap:shortId><xsl:value-of select="concat($fs, '/', $wit-slug)"/></sctap:shortId>
            <sctap:hasSlug><xsl:value-of select="$wit-slug"></xsl:value-of></sctap:hasSlug>
            <xsl:for-each select="./folio">
              <xsl:variable name="folionumber" select="./text()"/>
            	<!-- TODO: change here could cause break in IIIF range creation; make adjustments and then remove this comment once everything is working again -->
              <xsl:variable name="foliosideurl" select="concat('http://scta.info/resource/', $wit-slug, '/', $folionumber)"/>
              <sctap:hasSurface rdf:resource="{$foliosideurl}"/>
             <!-- <xsl:choose>
                <xsl:when test="./@canvasslug">
                  <xsl:variable name="canvas-slug" select="./@canvasslug"></xsl:variable>
                  <xsl:variable name="canvasid" select="concat($canvasBase, $canvas-slug)"></xsl:variable>
                  <sctap:isOnCanvas rdf:resource="{$canvasid}"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:variable name="canvas-slug" select="concat($wit-initial, $folionumber)"></xsl:variable>
                  <sctap:isOnCanvas rdf:resource="http://scta.info/iiif/{$iiif-ms-name}/canvas/{$canvas-slug}"/>
                </xsl:otherwise>
              </xsl:choose> -->
            </xsl:for-each>
          	
          	<sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$fs}"/>
            
          	<xsl:if test="document($transcription-text-path)">
            	<sctap:hasTranscription rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}/transcription"/>
          		<sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}/transcription"/>
          	</xsl:if>
          	<!-- could include isPartOf to manuscript identifier
               could also inclue folio numbers if these are included in main project file -->
            
            <!-- create ldn inbox -->
            <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$fs}/{$wit-slug}"/>
          </rdf:Description>
    			
    			<!-- should be removed 
    				<xsl:for-each select="folio">
            <xsl:variable name="folionumber" select="./text()"/>
            <xsl:variable name="foliosideurl" select="concat('http://scta.info/resource/material/', $commentaryslug, '-', $wit-slug, '/', $folionumber)"/>
            <rdf:Description rdf:about="{$foliosideurl}">
              <dc:title><xsl:value-of select="$folionumber"/></dc:title>
              <xsl:choose>
                <xsl:when test="./@canvasslug">
                  <xsl:variable name="canvas-slug" select="./@canvasslug"></xsl:variable>
                  <xsl:variable name="canvasid" select="concat($canvasBase, $canvas-slug)"></xsl:variable>
                  <sctap:isOnCanvas rdf:resource="{$canvasid}"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:variable name="canvas-slug" select="concat($wit-initial, $folionumber)"></xsl:variable>
                  <sctap:isOnCanvas rdf:resource="http://scta.info/iiif/{$iiif-ms-name}/canvas/{$canvas-slug}"/>
                </xsl:otherwise>
              </xsl:choose>
              <sctap:hasAnnotationList rdf:resource="http://scta.info/iiif/{$commentaryslug}-{$wit-slug}/list/{$folionumber}"/>
             
              <xsl:variable name="nextFolionumber" select="./following-sibling::folio[1]/text()"/>
              <xsl:variable name="nextFoliosideurl" select="concat('http://scta.info/resource/material/', $commentaryslug, '-', $wit-slug, '/', $nextFolionumber)"/>
              <sctap:nextFolioSide rdf:resource="{$nextFoliosideurl}"/>
              <xsl:variable name="previousFolionumber" select="./preceding-sibling::folio[1]/text()"/>
              <xsl:variable name="previousFoliosideurl" select="concat('http://scta.info/resource/material/', $commentaryslug, '-', $wit-slug, '/', $previousFolionumber)"/>
              <sctap:previousFolioSide rdf:resource="{$previousFoliosideurl}"/>
            </rdf:Description>
    			</xsl:for-each>
    		-->
    			
    			<xsl:if test="document($transcription-text-path)">
	          <xsl:variable name="transcript-title" select="document($transcription-text-path)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
	          <xsl:variable name="transcript-editor" select="document($transcription-text-path)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor"/>
	          
    				<rdf:Description rdf:about="http://scta.info/resource/{$fs}/{$wit-slug}/transcription">
	          	<dc:title><xsl:value-of select="$transcript-title"/></dc:title>
	          	<role:AUT rdf:resource="{$author-uri}"/>
	          	<role:EDT><xsl:value-of select="$transcript-editor"/></role:EDT>
	          	
	          	<!-- <xsl:call-template name="status">
	          		<xsl:with-param name="text-path" select="$transcription-text-path"/>
	              </xsl:call-template> -->
	          	
	          	<xsl:choose>
                <xsl:when test="document($transcription-text-path)//tei:revisionDesc/@status">
                    <sctap:status><xsl:value-of select="document($transcription-text-path)//tei:revisionDesc/@status"></xsl:value-of></sctap:status>
                </xsl:when>
                <xsl:when test="document($transcription-text-path)">
                    <sctap:status>In Progress</sctap:status>
                </xsl:when>
                <xsl:otherwise>
                    <sctap:status>Not Started</sctap:status>
                </xsl:otherwise>
	          	</xsl:choose>
	              
	              
              <rdf:type rdf:resource="http://scta.info/resource/transcription"/>
    					<sctap:structureType rdf:resource="http://scta.info/resource/structureItem"/>
    					<sctap:isTranscriptionOf rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}"/>
	          	<sctap:transcriptionType>Documentary</sctap:transcriptionType>
              <xsl:for-each select="document($transcription-text-path)//tei:body//tei:p">
	              <xsl:variable name="pid" select="./@xml:id"/>
	              <xsl:variable name="pid_ref" select="concat('#', ./@xml:id)"/>
	              <!-- only creates paragraph resource if that paragraph has been assigned an id -->
	              <xsl:if test="./@xml:id">
	              	<sctap:hasStructureBlock rdf:resource="http://scta.info/resource/{$pid}/{$wit-slug}/transcription"/>
	              </xsl:if>
              </xsl:for-each>
              <sctap:plaintext rdf:resource="http://scta.lombardpress.org/text/plaintext/{$fs}/{$wit-slug}/transcription"/>
    					<!-- requirement to lower case is bitbucket oddity that changges repo to lower case;
            		this would need to be adjusted after a switch to gitbut if github did not force repo names to lower case -->
    				  <xsl:choose>
    				    <xsl:when test="$gitRepoStyle = 'toplevel'">
    				      <sctap:hasDocument rdf:resource="{$gitRepoBase}{lower-case($cid)}/raw/master/{$fs}/{$wit-slug}_{$fs}.xml"/>
    				    </xsl:when>
    				    <xsl:otherwise>
    				      <sctap:hasDocument rdf:resource="{$gitRepoBase}{lower-case($fs)}/raw/master/{$wit-slug}_{$fs}.xml"/>
    				    </xsl:otherwise>	
    				  </xsl:choose>
    					
    					<sctap:hasXML rdf:resource="http://exist.scta.info/exist/apps/scta-app/document/{$fs}/{$wit-slug}/transcription"/>
    					<sctap:shortId><xsl:value-of select="concat($fs, '/', $wit-slug, '/', 'transcription')"/></sctap:shortId>
    					<sctap:isPartOfTopLevelTranscription rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}/transcription"/>
    				  
    				  <!-- create ldn inbox -->
    				  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$fs}/{$wit-slug}/transcription"/>
	          </rdf:Description>
    				
    				
    				<!-- BEGIN create structureDivision manifesation and transcription resources from each diplomatic manifestation -->
    				
    				<xsl:for-each select="document($transcription-text-path)//tei:body/tei:div//tei:div">
    					<!-- only creates division resource if that division has been assigned an id -->
    					<xsl:if test="./@xml:id">
    						<xsl:variable name="divisionId" select="./@xml:id"/>
    						<xsl:variable name="divisionId_ref" select="concat('#', ./@xml:id)"/>
    						
    						<!-- create manifestation for structureDivision -->
    						<rdf:Description rdf:about="http://scta.info/resource/{$divisionId}/{$wit-slug}">
    							<dc:title>Paragraph <xsl:value-of select="$divisionId"/></dc:title>
    							<rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
    							<sctap:structureType rdf:resource="http://scta.info/resource/structureDivision"/>
    							<sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}"/>
    							<sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$divisionId}"/>
    							<sctap:isPartOfTopLevelManifestation rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
    							<sctap:shortId><xsl:value-of select="concat($divisionId, '/', $wit-slug)"/></sctap:shortId>
    							<sctap:hasTranscription rdf:resource="http://scta.info/resource/{$divisionId}/{$wit-slug}/transcription"/>
    							<sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$divisionId}/{$wit-slug}/transcription"/>
    						  <!-- create ldn inbox -->
    						  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$divisionId}/{$wit-slug}"/>
    						</rdf:Description>
    						
    						<!-- create transcription for non-critical/documentary structureDivision -->
    						
    						
    						<rdf:Description rdf:about="http://scta.info/resource/{$divisionId}/{$wit-slug}/transcription">
    							<dc:title>Division <xsl:value-of select="$divisionId"/></dc:title>
    							<rdf:type rdf:resource="http://scta.info/resource/transcription"/>
    							<sctap:structureType rdf:resource="http://scta.info/resource/structureDivision"/>
    							<sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}/transcription"/>
    							<sctap:isTranscriptionOf rdf:resource="http://scta.info/resource/{$divisionId}/{$wit-slug}"/>
    							<!-- add transcription type -->
    							<sctap:transcriptionType>Documentary</sctap:transcriptionType>
    							<sctap:plaintext rdf:resource="http://scta.lombardpress.org/text/plaintext/{$divisionId}/{$wit-slug}/transcription"/>
    							
    							<xsl:for-each select="document($transcription-text-path)/tei:TEI/tei:facsimile//tei:zone[@start=$divisionId_ref]">
    								<xsl:variable name="position" select="if (./@n) then ./@n else 1"/>
    								<!-- TODO: simplifying name scheme for has Zone -->
    								<sctap:hasZone rdf:resource="http://scta.info/text/{$cid}/zone/{$wit-slug}_{$fs}/division/{$divisionId}/{$position}"/>
    							</xsl:for-each>
    							<sctap:hasDocument rdf:resource="https://bitbucket.org/jeffreycwitt/{$fs}/raw/master/{$wit-slug}_{$fs}.xml#{$divisionId}"/>
    							<sctap:hasXML rdf:resource="http://exist.scta.info/exist/apps/scta-app/document/{$divisionId}/{$wit-slug}/transcription"/>
    							<sctap:shortId><xsl:value-of select="concat($divisionId, '/', $wit-slug, '/', 'transcription')"/></sctap:shortId>
    							<sctap:isPartOfTopLevelTranscription rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}/transcription"/>
    							<!-- could add path to plain text version of paragraph -->
    							
    							<!-- begin status Declaration Block -->
    							<!-- TODO: refactor this into a reusable function -->
    							<xsl:choose>
    								<xsl:when test="document($transcription-text-path)//tei:revisionDesc/@status">
    									<sctap:status><xsl:value-of select="document($text-path)//tei:revisionDesc/@status"></xsl:value-of></sctap:status>
    								</xsl:when>
    								<xsl:when test="document($transcription-text-path)">
    									<sctap:status>In Progress</sctap:status>
    								</xsl:when>
    								<xsl:otherwise>
    									<sctap:status>Not Started</sctap:status>
    								</xsl:otherwise>
    							</xsl:choose>
    							<!-- end status Declaration block -->
    						  
    						  <!-- create ldn inbox -->
    						  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$divisionId}/{$wit-slug}/transcription"/>
    						</rdf:Description>
    					</xsl:if>
    				</xsl:for-each>
    						<!-- END manifestation and Transcription resource creation for structureDivisions -->
    				
    				
	          <!-- create structureBlock manifestation and transcription resources for each expression structureBlock -->
	          <xsl:for-each select="document($transcription-text-path)//tei:body//tei:p">
              <!-- only creates paragraph resource if that paragraph has been assigned an id -->
	            <xsl:variable name="this-paragraph" select="."/>
              <xsl:if test="./@xml:id">
	              <xsl:variable name="pid" select="./@xml:id"/>
	              <xsl:variable name="pid_ref" select="concat('#', ./@xml:id)"/>
              	<xsl:variable name="surface">
              		<xsl:choose>
              		<xsl:when test="doc($transcription-text-path)//tei:pb">
              			<xsl:value-of select="translate(concat('http://scta.info/resource/', $wit-slug, '/', ./preceding::tei:pb[1]/@n), '-', '')"/>
              		</xsl:when>
              		<xsl:otherwise>
              		  <xsl:value-of select="translate(concat('http://scta.info/resource/', $wit-slug, '/', translate(./preceding::tei:cb[1]/@n, 'ab', '')), '-', '')"/>
              		</xsl:otherwise>
              		</xsl:choose>
              			
              	</xsl:variable>
              		
	              
              	<!-- create manifestation for structureBlock -->
              	<rdf:Description rdf:about="http://scta.info/resource/{$pid}/{$wit-slug}">
              		<dc:title>Paragraph <xsl:value-of select="$pid"/></dc:title>
              		<rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
              		<sctap:structureType rdf:resource="http://scta.info/resource/structureBlock"/>
              		<sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}"/>
              		<sctap:isPartOfTopLevelManifestation rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
              		<sctap:shortId><xsl:value-of select="concat($pid, '/', $wit-slug)"/></sctap:shortId>
              		<sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$pid}"/>
              		<sctap:hasTranscription rdf:resource="http://scta.info/resource/{$pid}/{$wit-slug}/transcription"/>
              		<sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$pid}/{$wit-slug}/transcription"/>
              		<sctap:hasSurface rdf:resource="{$surface}"/>
              	  <!-- create ldn inbox -->
              	  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$pid}/{$wit-slug}"/>
              	  <!-- create hasMarginalNote assertion-->
              	  <xsl:for-each select=".//tei:note[@type='marginal-note']">
              	    <xsl:variable name="marginal-note-id">
              	      <xsl:choose>
              	        <xsl:when test="./@xml:id">
              	          <xsl:value-of select="./@xml:id"/>
              	        </xsl:when>
              	        <xsl:otherwise>
              	          <xsl:value-of select="concat('mn-', generate-id())"/>
              	        </xsl:otherwise>
              	      </xsl:choose> 
              	    </xsl:variable>
              	    <sctap:hasMarginalNote rdf:resource="http://scta.info/resource/{$marginal-note-id}"/>
              	  </xsl:for-each>
              	  <!-- create hasStructureElement assertion -->
              	  <xsl:for-each select=".//tei:quote[@xml:id]">
              	    <xsl:variable name="this-quote-id" select="./@xml:id"/>
              	    <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$this-quote-id}/{$wit-slug}"/>
              	  </xsl:for-each>
              	</rdf:Description>
                
                <!-- begin quote structureElement manifestation creation -->
                <!-- only creates quote structureElement if an @xml:id attribute is present-->
                <!-- could be repeated for ref, name, and title -->
                <xsl:for-each select=".//tei:quote[@xml:id]">
                  <xsl:variable name="this-quote-id" select="./@xml:id"/>
                  <rdf:Description rdf:about="http://scta.info/resource/{$this-quote-id}/{$wit-slug}">
                    <rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
                    <sctap:structureType rdf:resource="http://scta.info/resource/structureElement"/>
                    <sctap:structureElementType rdf:resource="http://scta.info/resource/structureElementQuote"/>
                    <sctap:structureElementText><xsl:value-of select="."/></sctap:structureElementText>
                    <sctap:isPartOfStructureBlock rdf:resource="http://scta.info/resource/{$pid}/{$wit-slug}"/>
                    <sctap:shortId><xsl:value-of select="concat($this-quote-id, '/', $wit-slug)"/></sctap:shortId>
                    <sctap:isPartOfTopLevelManifestation rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
                    <sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$this-quote-id}"/>
                  </rdf:Description>
                </xsl:for-each>
                <!-- 
                  BEGIN Create Mariginal Note Manifestation Resource; like translation this is a special instance Manifestation, 
                which would have similar proprties to other manifestations like, hasTranscription and hasSurface, etc. 
                The structureType should perhaps be structureNote and only structureBlocks shouls take this property 
                The behaviour is similar to a structureElement. But they are slighlty different because there is 
                no corresponding "expression type for a marginal note.
                -->
                <xsl:for-each select=".//tei:note[@type='marginal-note']">
                  <xsl:variable name="marginal-note-id">
                    <xsl:choose>
                      <xsl:when test="./@xml:id">
                        <xsl:value-of select="./@xml:id"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="concat('mn-', generate-id())"/>
                      </xsl:otherwise>
                    </xsl:choose> 
                  </xsl:variable>
                  <rdf:Description rdf:about="http://scta.info/resource/{$marginal-note-id}">
                    <dc:title>Marginal Note <xsl:value-of select="$marginal-note-id"/></dc:title>
                    <!--TODO: confirm: marginalNote type, is kind of a sub classs of Manifestation, similar to the way Translation is a subclass of Manifestation -->
                    <rdf:type rdf:resource="http://scta.info/resource/marginalNote"/> 
                    <sctap:structureType rdf:resource="http://scta.info/resource/structureElement"/>
                    <sctap:structureElementType rdf:resource="http://scta.info/resource/structureElementMarginalNote"/>
                    <!-- marginal note is at the manifest level, so it the target of isPartOfStructureBlock should be the corresponding manifestation of the structureBlock in question -->
                    <sctap:isPartOfStructureBlock rdf:resource="http://scta.info/resource/{$pid}/{$wit-slug}"/>
                    <sctap:structureElementText><xsl:value-of select="."/></sctap:structureElementText>
                    <sctap:isPartOfTopLevelManifestation rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
                    <sctap:shortId><xsl:value-of select="$marginal-note-id"/></sctap:shortId>
                    <!--<sctap:hasTranscription rdf:resource=""/>
                    <sctap:hasCanonicalTranscription rdf:resource=""/> -->
                    <sctap:hasSurface rdf:resource="{$surface}"/>
                  </rdf:Description>
                </xsl:for-each>
                <!-- end MarginalNote Manifestation Level Resource Creation -->
              	
              	<!-- create transcription for non-critical/documentary structureBlock -->
	              <rdf:Description rdf:about="http://scta.info/resource/{$pid}/{$wit-slug}/transcription">
	                <dc:title>Paragraph <xsl:value-of select="$pid"/></dc:title>
	                <rdf:type rdf:resource="http://scta.info/resource/transcription"/>
              		<sctap:structureType rdf:resource="http://scta.info/resource/structureBlock"/>
              		<sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}/transcription"/>
              		<sctap:isTranscriptionOf rdf:resource="http://scta.info/resource/{$pid}/{$wit-slug}"/>
              		<!-- add transcription type -->
              		<sctap:transcriptionType>Documentary</sctap:transcriptionType>
              		<sctap:plaintext rdf:resource="http://scta.lombardpress.org/text/plaintext/{$pid}/{$wit-slug}/transcription"/>
	                <xsl:for-each select="document($transcription-text-path)/tei:TEI/tei:facsimile//tei:zone[@start=$pid_ref]">
                    <xsl:variable name="position" select="if (./@n) then ./@n else 1"/>
	                	<!-- TODO: simplifying name scheme for has Zone -->
                    <sctap:hasZone rdf:resource="http://scta.info/text/{$cid}/zone/{$wit-slug}_{$fs}/paragraph/{$pid}/{$position}"/>
                  </xsl:for-each>
	              	<sctap:hasDocument rdf:resource="https://bitbucket.org/jeffreycwitt/{$fs}/raw/master/{$wit-slug}_{$fs}.xml#{$pid}"/>
              		<sctap:hasXML rdf:resource="http://exist.scta.info/exist/apps/scta-app/document/{$pid}/{$wit-slug}/transcription"/>
              		<sctap:shortId><xsl:value-of select="concat($pid, '/', $wit-slug, '/', 'transcription')"/></sctap:shortId>
              		<sctap:isPartOfTopLevelTranscription rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}/transcription"/>
	                  <!-- could add path to plain text version of paragraph -->
              		
              		<!-- begin status Declaration Block -->
              		<!-- TODO: refactor this into a reusable function -->
              		<xsl:choose>
              			<xsl:when test="document($transcription-text-path)//tei:revisionDesc/@status">
              				<sctap:status><xsl:value-of select="document($text-path)//tei:revisionDesc/@status"></xsl:value-of></sctap:status>
              			</xsl:when>
              			<xsl:when test="document($transcription-text-path)">
              				<sctap:status>In Progress</sctap:status>
              			</xsl:when>
              			<xsl:otherwise>
              				<sctap:status>Not Started</sctap:status>
              			</xsl:otherwise>
              		</xsl:choose>
              		<!-- end status Declaration block -->
              	  <!-- create ldn inbox -->
              	  <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$pid}/{$wit-slug}/transcription"/>
	              </rdf:Description>
              	
              	<xsl:if test="document($transcription-text-path)/tei:TEI/tei:facsimile">
              		<xsl:for-each select="document($transcription-text-path)/tei:TEI/tei:facsimile//tei:zone[@start=$pid_ref]">
              			<xsl:variable name="imagefilename" select="./preceding-sibling::tei:graphic/@url"/>
              			<xsl:variable name="canvasname" select="substring-before($imagefilename, '.')"/>
              			<!-- this is not a good way to do this; this whole section needs to be written -->
              			<!-- right now I'm trying to just go the folio number without the preceding sigla -->
              			<!-- not this will fail if there is Sigla that reads Ar15r; the first "r" will not be removed and the result will be r15r -->
              			<xsl:variable name="folioname" select="translate($canvasname, 'ABCDEFGHIJKLMNOPQRSTUVabcdefghijklmnopqstuwxyz', '') "/>
              			
              			<!-- <xsl:variable name="foliosideurl" select="concat('http://scta.info/resource/material', $commentaryslug, '-', $wit-slug, '/', $folioname)"/> -->
              			<!-- changed to... --> <!-- this will mess up anywhere were codex ids are identical such as "sorb" and "sorb" and "vat" and "vat" which I believe is only a problem with Wodeham and Plaoul -->
              			<xsl:variable name="foliosideurl" select="concat('http://scta.info/resource/', $wit-slug, '/', $folioname)"/>
                      
                    <xsl:variable name="canvasid">
                    <xsl:choose>
                      <xsl:when test="./ancestor::tei:surface/@select">
                        <xsl:variable name="witessid" select="translate(./ancestor::tei:surface/@ana, '#', '')"></xsl:variable>
                        <xsl:variable name="canvasbase" select="//witness[@xml:id=$witessid]/@xml:base"></xsl:variable>
                        <xsl:variable name="canvas-slug" select="./ancestor::tei:surface/@select"></xsl:variable>
                        <xsl:value-of select="concat($canvasBase, $canvas-slug)"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="concat('http://scta.info/iiif/', $commentaryslug, '-', $wit-slug, '/canvas/', $canvasname)"/>
                      </xsl:otherwise>
                    </xsl:choose>
                    </xsl:variable>
              			<xsl:variable name="ulx" select="./@ulx"/>
                    <xsl:variable name="uly" select="./@uly"/>
                    <xsl:variable name="lrx" select="./@lrx"/>
                    <xsl:variable name="lry" select="./@lry"/>
                    <xsl:variable name="width"><xsl:value-of select="$lrx - $ulx"/></xsl:variable>
                    <xsl:variable name="height"><xsl:value-of select="$lry - $uly"/></xsl:variable>
              			<xsl:variable name="position" select="if (./@n) then ./@n else 1"/>
              			
              			<!-- TODO: simplify zone url -->
                    <rdf:Description rdf:about="http://scta.info/text/{$cid}/zone/{$wit-slug}_{$fs}/paragraph/{$pid}/{$position}">
                      <dc:title>Canvas zone for <xsl:value-of select="$wit-slug"/>_<xsl:value-of select="$fs"/> paragraph <xsl:value-of select="$pid"/></dc:title>
                      <rdf:type rdf:resource="http://scta.info/resource/zone"/>
                      <!-- problem here with slug since iiif slug is prefaced with pg or pp etc -->
                    	<sctap:isZoneOf rdf:resource="http://scta.info/resource/{$pid}/{$wit-slug}/transcription"/>
                      <!-- to be deleted <sctap:isZoneOn rdf:resource="{$canvasid}"/> -->
                      <sctap:hasSurface rdf:resource="{$foliosideurl}"/>
                      <sctap:ulx><xsl:value-of select="$ulx"/></sctap:ulx>
                      <sctap:uly><xsl:value-of select="$uly"/></sctap:uly>
                      <sctap:lrx><xsl:value-of select="$lrx"/></sctap:lrx>
                      <sctap:lry><xsl:value-of select="$lry"/></sctap:lry>
                      <sctap:width><xsl:value-of select="$width"/></sctap:width>
                      <sctap:height><xsl:value-of select="$height"/></sctap:height>
                      <sctap:position><xsl:value-of select="$position"/></sctap:position>
                    </rdf:Description>
                  </xsl:for-each>
              	</xsl:if>
              </xsl:if>
	          </xsl:for-each>
    			</xsl:if>
    		</xsl:for-each>
    	</xsl:for-each>
    </rdf:RDF>
  </xsl:template>
</xsl:stylesheet>