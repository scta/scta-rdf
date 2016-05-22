<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="2.0" 
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  xmlns:sctap="http://scta.info/properties/" 
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="sctap">
  
  <xsl:param name="author"><xsl:value-of select="//header/authorName"/></xsl:param>
  <xsl:param name="commentaryname"><xsl:value-of select="//header/commentaryName"/></xsl:param>
  <xsl:param name="cid"><xsl:value-of select="//header/commentaryid"/></xsl:param>
  <xsl:param name="commentaryslug"><xsl:value-of select="//header/commentaryslug"/></xsl:param>
  <xsl:param name="author-uri"><xsl:value-of select="//header/authorUri"/></xsl:param>
  <xsl:param name="parent-uri"><xsl:value-of select="//header/parentUri"/></xsl:param>
  <xsl:param name="textfilesdir"><xsl:value-of select="//header/textfilesdir"/></xsl:param>
  <xsl:param name="webbase"><xsl:value-of select="//header/webbase"/></xsl:param>
  <xsl:param name="gitRepoBase">https://bitbucket.org/jeffreycwitt/</xsl:param>
  
  <xsl:variable name="dtsurn"><xsl:value-of select="concat('urn:dts:latinLit:sentences', '.', $cid)"/></xsl:variable>

	<xsl:variable name="parentWorkGroup">
		<xsl:choose>
			<xsl:when test="//header/parentWorkGroup">
				<xsl:value-of select="//header/parentWorkGroup"/>
			</xsl:when>
			<xsl:otherwise>sententia</xsl:otherwise>
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
	<xsl:template match="div[@id='frontmatter']"></xsl:template>
	<xsl:template match="div[@id='backmatter']"></xsl:template>
  <xsl:template match="header"></xsl:template>
  <xsl:template match="head"></xsl:template>
  
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
      xmlns:dc="http://purl.org/dc/elements/1.1/">    
    	
    	<rdf:Description rdf:about="http://scta.info/resource/{$cid}">
			<rdf:type rdf:resource="http://scta.info/resource/expression"/>
			<dc:title><xsl:value-of select="$commentaryname"/></dc:title>
		    <!-- TODO: parent of expresion should be WORK, not WorkGroup -->
    		<dcterms:isPartOf rdf:resource="http://scta.info/text/{$parentWorkGroup}"/>
    		<role:AUT rdf:resource="{$author-uri}"/>
    		
    		<sctap:slug><xsl:value-of select="$commentaryslug"/></sctap:slug>
		    <sctap:shortId><xsl:value-of select="$cid"/></sctap:shortId>
		    <sctap:dtsurn><xsl:value-of select="$dtsurn"/></sctap:dtsurn>
				<sctap:level>1</sctap:level>
    		<sctap:structureType rdf:resource="http://scta.info/resource/structureCollection"/>
    		
    		<!-- TODO: Project file headers should indicate expressionType; I'm hard coding to the SentencesCommentary for now;
    			but this means De Anima commentaries are going to be erroneously marked -->
    			<sctap:expressionType rdf:resource="http://scta.info/resource/commentary"/>
		    
    		<!-- identify second level expression parts -->
				<xsl:for-each select="./div">
					<xsl:variable name="divid"><xsl:value-of select="./@id"/></xsl:variable>
					<dcterms:hasPart rdf:resource="http://scta.info/resource/{$divid}"/>
				</xsl:for-each>
	      
	      <!-- identify all resources with structureType=itemStructure -->
    		
    		<xsl:for-each select="./div//item">
            <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
            <sctap:hasStructureItem rdf:resource="http://scta.info/resource/{$fs}"/>
        </xsl:for-each>
		      
        <xsl:for-each select="/listofFileNames/header/hasWitnesses/witness">
          <xsl:variable name="wit-slug"><xsl:value-of select="./slug"/></xsl:variable>
        	<sctap:hasManifestation rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
        	<!-- TODO: add hasCanonicalManifestation; but this needs to be indicated in the project file header -->
        </xsl:for-each>
		  </rdf:Description>
    	
    	
      <!-- create manifestation entry for each manifestation corresponding to the top level expression -->
      <xsl:for-each select="/listofFileNames/header/hasWitnesses/witness">
        <xsl:variable name="wit-title"><xsl:value-of select="./title"/></xsl:variable>
        <xsl:variable name="wit-initial"><xsl:value-of select="./initial"/></xsl:variable>
        <xsl:variable name="wit-canvasbase"><xsl:value-of select="./cavnasBase"/></xsl:variable>
        <xsl:variable name="wit-slug"><xsl:value-of select="./slug"/></xsl:variable>
        
      	<rdf:Description rdf:about="http://scta.info/resource/{$cid}/{$wit-slug}">
          <dc:title><xsl:value-of select="$wit-title"/></dc:title>
      		<rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
          <role:AUT rdf:resource="{$author-uri}"/>
          <sctap:hasSlug><xsl:value-of select="$wit-slug"></xsl:value-of></sctap:hasSlug>
      		<sctap:shortId><xsl:value-of select="concat($cid, '/', $wit-slug)"/></sctap:shortId>
          <xsl:if test="./manifestOfficial">
            <xsl:variable name="wit-manifestofficial"><xsl:value-of select="./manifestOfficial"/></xsl:variable>
            <sctap:manifestOfficial><xsl:value-of select="$wit-manifestofficial"></xsl:value-of></sctap:manifestOfficial>
          </xsl:if>
        </rdf:Description>
      </xsl:for-each>
    	
    	<!-- TODO: another manifestation of the critical editions should be added; 
    		this is born digital manifestation, that doesn't have physical copy somewhere; 
    		but it is still a manifestation -->
    	
    	<!-- end of top level manifestation creation --> 
    		
    	<!-- begin creation of all structureType=structureCollections that are not topLevel Expressions -->
    	
    	<xsl:for-each select=".//div">
    		<xsl:variable name="divid"><xsl:value-of select="./@id"/></xsl:variable>
        <xsl:variable name="title"><xsl:value-of select="./head"/></xsl:variable>
    		<xsl:variable name="expressionType"><xsl:value-of select="./type"/></xsl:variable>
    		<xsl:variable name="expressionSubType"><xsl:value-of select="./subtype"/></xsl:variable>
    		<xsl:variable name="parentExpression"><xsl:value-of select="./parent::div/@id"/></xsl:variable>
    		
        
    		<rdf:Description rdf:about="http://scta.info/resource/{$divid}">
        	<dc:title><xsl:value-of select="$title"></xsl:value-of></dc:title>
        	<rdf:type rdf:resource="http://scta.info/resource/expression"/>
    			<role:AUT rdf:resource="{$author-uri}"/>
    			
    			<!-- TODO: create conditional to handle cases where no expression type is listed -->
    			<sctap:expressionType rdf:resource="http://scta.info/resource/{$expressionType}"/>
    			<!-- TODO create conditional to handle cases where not expressionSubtype is given;
    				decide if expressionSubType should just be a second expressionType -->
    			<sctap:expressionType rdf:resource="http://scta.info/resource/{$expressionSubType}"/>
    			
    			<sctap:structureType rdf:resource="http://scta.info/resource/structureCollection"/>
    			<sctap:level><xsl:value-of select="count(ancestor::*)"/></sctap:level>
    			
    			<!-- identify parent expression resource -->
    			<dcterms:isPartOf rdf:resource="http://scta.info/resource/{$parentExpression}"/>
    			
    			<!-- identify child expression part -->
    			
    			<xsl:for-each select="./div">
    				<xsl:variable name="divid"><xsl:value-of select="./@id"/></xsl:variable>
    				<dcterms:hasPart rdf:resource="http://scta.info/resource/{$divid}"/>
    			</xsl:for-each>
    			
    			
    			<!-- TODO: decide if hasTopLevelExpression is necessary -->
    			<sctap:hasTopLevelExpression rdf:resource="http://scta.info/resource/{$cid}"/>
          
          <!-- get Order Number -->
    			<xsl:variable name="totalnumber"><xsl:number count="div" level="any"/></xsl:variable>
    			<xsl:variable name="sectionnumber"><xsl:number count="div"/></xsl:variable>
	        <sctap:sectionOrderNumber><xsl:value-of select="format-number($sectionnumber, '000')"/></sctap:sectionOrderNumber>
	        <sctap:totalOrderNumber><xsl:value-of select="format-number($totalnumber, '000')"/></sctap:totalOrderNumber>
          
          <!-- TODO: decide if dtsurn should be used 
          <xsl:variable name="divcount"><xsl:number count="div[not(@id='body')]" level="multiple" format="1"/></xsl:variable>
          <sctap:dtsurn><xsl:value-of select="concat($dtsurn, ':', $divcount)"/></sctap:dtsurn>
          -->      
    			
    			<!-- list all items within this div -->
    			<xsl:for-each select=".//item">
    				<xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
    				<sctap:hasStructureItem rdf:resource="http://scta.info/resource/{$fs}"/>    
    			</xsl:for-each>
    		</rdf:Description>
    	</xsl:for-each>
    	
    	<!-- BEGIN structureType=structureItem expression resource creation -->
    	<xsl:for-each select="./div//item">
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
    		
    		<rdf:Description rdf:about="http://scta.info/resource/{$fs}">
    			<dc:title><xsl:value-of select="$title"></xsl:value-of></dc:title>
    			<rdf:type rdf:resource="http://scta.info/resource/expression"/>
    			<dcterms:isPartOf rdf:resource="http://scta.info/resource/{$expressionParentId}"/>
    			<role:AUT rdf:resource="{$author-uri}"/>
    			
    			<!-- record editors -->
    			<xsl:for-each select="document($extraction-file)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor">
    				<sctap:editedBy><xsl:value-of select="."/></sctap:editedBy>
    			</xsl:for-each>
    			
    			<sctap:expressionType rdf:resource="http://scta.info/resource/{$expressionType}"/>
    			<sctap:structureType rdf:resource="http://scta.info/resource/structureItem"/>
    			<sctap:hasTopLevelExpression rdf:resource="http://scta.info/resource/{$cid}"/>
    			<sctap:shortId><xsl:value-of select="$fs"/></sctap:shortId>
    			<sctap:level><xsl:value-of select="$item-level"/></sctap:level>
    			
    			<sctap:sectionOrderNumber><xsl:value-of select="format-number($sectionnumber, '000')"/></sctap:sectionOrderNumber>
	        <sctap:totalOrderNumber><xsl:value-of select="format-number($totalnumber, '000')"/></sctap:totalOrderNumber>
    			
    			<xsl:if test="./following::item[1]">
	           <xsl:variable name="next-item" select="./following::item[1]/fileName/@filestem"></xsl:variable>
	           <sctap:next rdf:resource="http://scta.info/text/{$cid}/item/{$next-item}"/>
    			</xsl:if>
    			<xsl:if test="./preceding::item[1]">
    				<xsl:variable name="previous-item" select="./preceding::item[1]/fileName/@filestem"></xsl:variable>
    				<sctap:previous rdf:resource="http://scta.info/text/{$cid}/item/{$previous-item}"/>
    			</xsl:if>
    			
    			<!-- TODO: consider adding questionTitle attribute to higher level divs as well -->
    			<xsl:if test="./questionTitle">
    				<sctap:questionTitle><xsl:value-of select="./questionTitle"></xsl:value-of></sctap:questionTitle>
    			</xsl:if>
    			
    			<!-- TODO review wither a dtsurn is desired 
    			<sctap:dtsurn><xsl:value-of select="$item-dtsurn"/></sctap:dtsurn>
    			-->
    			
    			<!-- record git repo -->
    			<sctap:gitRepository><xsl:value-of select="concat($gitRepoBase, $fs)"/></sctap:gitRepository>
    			
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
    				
    				<sctap:hasStructureDivision rdf:resource="http://scta.info/resource/{$divisionID}"/>
		    		
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
    			
    			<!-- Identify Canonical Manifestation and canonica  for Expression at the structureItem level -->
    				<!--TODO: it is not ideal to ripping this information from the file path; it would be better if the projectdata file or transcription.xml file indicated this information -->
    				
    			
    			<sctap:hasCanonicalManifestation rdf:resource="http://scta.info/resource/{$fs}/{$canonical-manifestation-id}"/>
    			<!-- end create canonical Manifestation and Transcription entires -->
    			
    			
    		
    		<!-- TODO: add link to first level structureType division found in the tei document; 
    			this level of div is captured by the following expath in the LombardPress schema //tei:body/tei:div/tei:div -->
    		</rdf:Description>
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
    				<rdf:type rdf:resource="http://scta.info/resource/expression"/>
    				<dcterms:isPartOf rdf:resource="http://scta.info/resource/{$fs}"/>
    				
    				<sctap:expressionType rdf:resource="http://scta.info/resource/{$divisionExpressionType}"/>
    				<sctap:structureType rdf:resource="http://scta.info/resource/structureDivision"/>
    				
    				<sctap:shortId><xsl:value-of select="$divisionID"/></sctap:shortId>
    				
    				<!-- TODO: decide if dts is desired
    					<xsl:variable name="div-urn" select="$div-number"/>
    					<sctap:dtsurn><xsl:value-of select="concat($item-dtsurn, '.', $div-urn)"/></sctap:dtsurn>
    				-->
    				
    				<!-- BEGIN collect questionTitles from division header -->
            <xsl:choose>
              <xsl:when test="./tei:head/@type='questionTitle'">
                <sctap:questionTitle><xsl:value-of select="./tei:head[@type='questionTitle']"/></sctap:questionTitle>
              </xsl:when>
              <xsl:when test="./tei:head/tei:seg/@type='questionTitle'">
                <sctap:questionTitle><xsl:value-of select="./tei:head/tei:seg[@type='questionTitle']"/></sctap:questionTitle>
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
    					<sctap:hasStructureDivision rdf:resource="http://scta.info/resource/{$divisionID}"/>
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
    				
    				<!-- create canonicalManifestation and Transcriptions references for structureType=structureDivision -->
    				<sctap:hasCanonicalManifestation rdf:resource="http://scta.info/resource/{$divisionID}/{$canonical-manifestation-id}"/>
    				
    				
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
              
              <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:name[@ref]">
                <xsl:variable name="nameRef" select="./@ref"></xsl:variable>
                <xsl:variable name="nameID" select="substring-after($nameRef, '#')"></xsl:variable>
                <xsl:variable name="totalNames" select="count(document($extraction-file)//tei:body//tei:name)"/>
                <xsl:variable name="totalFollowingNames" select="count(.//following::tei:name)"></xsl:variable>
                <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalNames - $totalFollowingNames)"/>
                <sctap:mentions rdf:resource="http://scta.info/resource/person/{$nameID}"/>
                <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$objectId}"/>
              </xsl:for-each>
              <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:title[@ref]">
                <xsl:variable name="titleRef" select="./@ref"></xsl:variable>
                <xsl:variable name="titleID" select="substring-after($titleRef, '#')"></xsl:variable>
                <xsl:variable name="totalTitles" select="count(document($extraction-file)//tei:body//tei:title)"/>
                <xsl:variable name="totalFollowingTitles" select="count(.//following::tei:title)"></xsl:variable>
                <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalTitles - $totalFollowingTitles)"/>
                <sctap:mentions rdf:resource="http://scta.info/resource/work/{$titleID}"/>
                <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$objectId}"/>
              </xsl:for-each>
              <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:quote[@type='commentary']">
                <xsl:variable name="commentarySectionUrl" select="./@source"></xsl:variable>
                <xsl:variable name="totalQuotes" select="count(document($extraction-file)//tei:body//tei:quote)"/>
                <xsl:variable name="totalFollowingQuotes" select="count(.//following::tei:quote)"></xsl:variable>
                <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalQuotes - $totalFollowingQuotes)"/>
                <sctap:quotes rdf:resource="{$commentarySectionUrl}"/>
                <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$objectId}"/>
              </xsl:for-each>
              <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:quote[@ana]">
                <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
                <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
                <xsl:variable name="totalQuotes" select="count(document($extraction-file)//tei:body//tei:quote)"/>
                <xsl:variable name="totalFollowingQuotes" select="count(.//following::tei:quote)"></xsl:variable>
                <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalQuotes - $totalFollowingQuotes)"/>
                <sctap:quotes rdf:resource="http://scta.info/resource/quotation/{$quoteID}"/>
                <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$objectId}"/>
              </xsl:for-each>
              <!-- three types of refs; default is "quotation" and does not need to be declared, 
                "passage" refers to passage that is not a sentences commentary section
                "commentary" refers to sentences commentary unit. If commentary unit requires target which is SCTA Url -->
              
              <!-- type="commentary" is not sentences commentary passage -->
              <!-- [not(ancestor::tei:bibl] excludes references made in bibl elements -->
              <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:ref[@type='commentary'][not(ancestor::tei:bibl)]">
                <xsl:variable name="commentarySectionUrl" select="./@target"></xsl:variable>
                <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
                <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
                <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalRefs - $totalFollowingRefs)"/>
                <sctap:references rdf:resource="{$commentarySectionUrl}"/>
                <sctap:hasStructureElement rdf:resource="http://scta.info/resource{$objectId}"/>
              </xsl:for-each>
              <!-- type="passage" is non sentences commentary passage -->
              <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:ref[@type='passage']">
                <xsl:variable name="passageRef" select="./@ana"></xsl:variable>
                <xsl:variable name="passageID" select="substring-after($passageRef, '#')"></xsl:variable>
                <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
                <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
                <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalRefs - $totalFollowingRefs)"/>
                <sctap:references rdf:resource="http://scta.info/resource/passage/{$passageID}"/>
                <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$objectId}"/>
              </xsl:for-each>
              <!-- default is ref referring to quotation resource or type="quotation" -->  
              <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:ref[@ana] | document($extraction-file)//tei:p[@xml:id=$pid]//tei:ref[@type='quotation']">
                <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
                <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
                <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
                <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
                <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalRefs - $totalFollowingRefs)"/>
                <sctap:references rdf:resource="http://scta.info/resource/quotation/{$quoteID}"/>
                <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$objectId}"/>
              </xsl:for-each>
              
              <!--- end of logging name, title, quote, and ref asserts for paragraph examplar -->
              
            </rdf:Description>
    			</xsl:if>
    		</xsl:for-each>
        
        <!-- end of expression structureType=structureBlock resource creation -->
        
          
        <!-- begin create expression structureType=structureElement resources creation -->
        <xsl:for-each select="document($extraction-file)//tei:body//tei:name[@ref]">
          <xsl:variable name="nameRef" select="@ref"/>
          <xsl:variable name="nameID" select="substring-after($nameRef, '#')"/>
          <xsl:variable name="totalNames" select="count(document($extraction-file)//tei:body//tei:name)"/>
          <xsl:variable name="totalFollowingNames" select="count(.//following::tei:name)"></xsl:variable>
          <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalNames - $totalFollowingNames)"/>
          <xsl:variable name="paragraphParent" select=".//preceding::tei:paragraph[@xml:id]"/>
          <rdf:Description rdf:about="http://scta.info/resource/{$objectId}">
            <rdf:type rdf:resource="http://scta.info/resource/expression"/>
            <sctap:expressionType rdf:resource="http://scta.info/resource/structureElement"/>
            <sctap:structureElementType rdf:resource="http://scta.info/resource/structureElementName"/>
            <sctap:isInstanceOf rdf:resource="http://scta.info/resource/person/{$nameID}"/>
            <sctap:structureElementText><xsl:value-of select="."/></sctap:structureElementText>
            <sctap:isPartOfStructureBlock rdf:resource="http://scta.info/resource/{$paragraphParent}"/>
          	
          	<!-- TODO addd manifestation identifcation create; use the block of code used above to make these assertsion at the item, div, and block level 
          	this will be block will repeated in each of the three following structureElements creation. Therefore it should be placed in separate function, 
          	so it can be resued 7 seven different times 
          	-->
          	
          </rdf:Description>
        </xsl:for-each>
        <xsl:for-each select="document($extraction-file)//tei:body//tei:title[@ref]">
          <xsl:variable name="titleRef" select="./@ref"></xsl:variable>
          <xsl:variable name="titleID" select="substring-after($titleRef, '#')"></xsl:variable>
          <xsl:variable name="totalTitles" select="count(document($extraction-file)//tei:body//tei:title)"/>
          <xsl:variable name="totalFollowingTitles" select="count(.//following::tei:title)"></xsl:variable>
          <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalTitles - $totalFollowingTitles)"/>
          <xsl:variable name="paragraphParent" select=".//preceding::tei:paragraph[@xml:id]"/>
          <rdf:Description rdf:about="http://scta.info/resource/{$objectId}">
            <rdf:type rdf:resource="http://scta.info/resource/expression"/>
            <sctap:expressionType rdf:resource="http://scta.info/resource/structureElement"/>
            <sctap:structureElementType rdf:resource="http://scta.info/resource/structureElementTitle"/>
            <sctap:isInstanceOf rdf:resource="http://scta.info/resource/work/{$titleID}"/>
            <sctap:structureElementText><xsl:value-of select="."/></sctap:structureElementText>
            <sctap:isPartOfStructureBlock rdf:resource="http://scta.info/resource/{$paragraphParent}"/>
          </rdf:Description>
        </xsl:for-each>
        <xsl:for-each select="document($extraction-file)//tei:body//tei:quote[@ana]">
          <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
          <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
          <xsl:variable name="totalQuotes" select="count(document($extraction-file)//tei:body//tei:quote)"/>
          <xsl:variable name="totalFollowingQuotes" select="count(.//following::tei:quote)"></xsl:variable>
          <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalQuotes - $totalFollowingQuotes)"/>
          <xsl:variable name="paragraphParent" select=".//preceding::tei:paragraph[@xml:id]"/>
          <rdf:Description rdf:about="http://scta.info/text/{$cid}/quote/{$objectId}">
            <rdf:type rdf:resource="http://scta.info/resource/expression"/>
            <sctap:expressionType rdf:resource="http://scta.info/resource/structureElement"/>
            <sctap:structureElementType rdf:resource="http://scta.info/resource/structureElementQuote"/>
            <sctap:isInstanceOf rdf:resource="http://scta.info/resource/quotation/{$quoteID}"/>
            <sctap:structureElementText><xsl:value-of select="."/></sctap:structureElementText>
            <sctap:isPartOfStructureBlock rdf:resource="http://scta.info/resource/{$paragraphParent}"/>
          </rdf:Description>
        </xsl:for-each>
        
        <!-- three types of refs; default is "quotation" and does not need to be declared, 
                "passage" refers to passage that is not a sentences commentary section
                "commentary" refers to sentences commentary unit. If commentary unit requires target which is SCTA Url -->
        <!-- first type="passage" -->
        <xsl:for-each select="document($extraction-file)//tei:body//tei:ref[@type='passage']">
          <xsl:variable name="refRef" select="./@ana"></xsl:variable>
          <xsl:variable name="refID" select="substring-after($refRef, '#')"></xsl:variable>
          <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
          <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
          <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalRefs - $totalFollowingRefs)"/>
          <xsl:variable name="paragraphParent" select=".//preceding::tei:paragraph[@xml:id]"/>
          <rdf:Description rdf:about="http://scta.info/text/{$cid}/ref/{$objectId}">
            <rdf:type rdf:resource="http://scta.info/resource/expression"/>
            <sctap:expressionType rdf:resource="http://scta.info/resource/structureElement"/>
            <sctap:structureElementType rdf:resource="http://scta.info/resource/structureElementRef"/>
            <sctap:isInstanceOf rdf:resource="http://scta.info/resource/passage/{$refID}"/>
            <sctap:structureElementText><xsl:value-of select="."/></sctap:structureElementText>
            <sctap:isPartOfStructureBlock rdf:resource="http://scta.info/resource/{$paragraphParent}"/>
          </rdf:Description>
        </xsl:for-each>
        <!-- default type="quotation" -->
        <xsl:for-each select="document($extraction-file)//tei:body//tei:ref[@ana] | document($extraction-file)//tei:body//tei:ref[@type='quotation']">
          <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
          <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
          <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
          <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
          <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalRefs - $totalFollowingRefs)"/>
          <xsl:variable name="paragraphParent" select=".//preceding::tei:paragraph[@xml:id]"/>
          <rdf:Description rdf:about="http://scta.info/text/{$cid}/ref/{$objectId}">
            <rdf:type rdf:resource="http://scta.info/resource/expression"/>
            <sctap:expressionType rdf:resource="http://scta.info/resource/structureElement"/>
            <sctap:structureElementType rdf:resource="http://scta.info/resource/structureElementRef"/>
            <sctap:isInstanceOf rdf:resource="http://scta.info/resource/quotation/{$quoteID}"/>
            <sctap:structureElementText><xsl:value-of select="."/></sctap:structureElementText>
            <sctap:isPartOfStructureBlock rdf:resource="http://scta.info/resource/{$paragraphParent}"/>
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
              <sctap:isTranscriptionOf rdf:resource="http://scta.info/resource/{$fs}/critical"/>
              <!-- TODO: infomration about nameing of critical edition and type should come from project data or transcription file rather 
                than being hard coded. It works as is, if there is only one critical transcription, but if there were more than one it 
                would cease to work -->
              <sctap:transcriptionType>Critical</sctap:transcriptionType>
              
              <xsl:for-each select="document($text-path)//tei:body//tei:p">
                <xsl:variable name="pid" select="./@xml:id"/>
                <xsl:variable name="pid_ref" select="concat('#', ./@xml:id)"/>
              	<sctap:hasStructureBlock rdf:resource="http://scta.info/resource/{$pid}/critical"/>
              </xsl:for-each>
              <sctap:plaintext rdf:resource="http://text.scta.info/plaintext/{$cid}/{$fs}/transcription/critical"/>
            	<!-- NOTE: so if there was more than one critical transcription or we were mapping multiple version 
            		the transcription for an earlier editions would point to a previous tagged point in the commit history like so:
            		"https://bitbucket.org/jeffreycwitt/{$fs}/raw/1.0/{$fs}.xml" -->
            	<!-- requirement to lower case is bitbucket oddity that changges repo to lower case;
            		this would need to be adjusted after a switch to gitbut if github did not force repo names to lower case --> 
            		
            	<sctap:hasXML rdf:resource="{$gitRepoBase}{lower-case($fs)}/raw/master/{$fs}.xml"/>
            </rdf:Description>
            
            <xsl:for-each select="document($text-path)//tei:body//tei:p">
              <!-- only creates paragraph resource if that paragraph has been assigned an id -->
              <xsl:if test="./@xml:id">
                <xsl:variable name="pid" select="./@xml:id"/>
                <xsl:variable name="pid_ref" select="concat('#', ./@xml:id)"/>
                
              	<!-- create manifestation for critical structureBlock -->
              	<rdf:Description rdf:about="http://scta.info/resource/{$pid}/critical">
              		<dc:title>Paragraph <xsl:value-of select="$pid"/></dc:title>
              		<rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
              		<sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$fs}/critical"/>
              		<sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$pid}"/>
              		<sctap:hasTranscription rdf:resource="http://scta.info/resource/{$pid}/critical/transcription"/>
              		<sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$pid}/critical/transcription"/>
              	</rdf:Description>
                
                <!-- create transcription for critical structureBlock -->
              	<rdf:Description rdf:about="http://scta.info/resource/{$pid}/critical/transcription">
                  <dc:title>Paragraph <xsl:value-of select="$pid"/> [critical transcription]</dc:title>
                  <rdf:type rdf:resource="http://scta.info/resource/transcription"/>
                  <sctap:plaintext rdf:resource="http://text.scta.info/plaintext/{$cid}/{$fs}/transcription/critical/paragraph/{$pid}"/>
              		<sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$fs}/critical/transcription"/>
              		<sctap:isTranscriptionOf rdf:resource="http://scta.info/resource/{$pid}/critical"/>
              		<!-- add transcription type
              			TODO: not ideal to be harding this; should be getting from projectdata file or transcription.xml file -->
              		<sctap:transcriptionType>Critical</sctap:transcriptionType>
              		<!-- TODO: this chould change to point to existDB that can actually return a new TEI file with just the paragraph -->
              		<sctap:hasXML rdf:resource="{$gitRepoBase}{lower-case($fs)}/raw/master/{$fs}.xml#{$pid}"/>
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
              		
                </rdf:Description>
              	
              </xsl:if>
            </xsl:for-each>
          </xsl:if>
    		
    		<!-- create manifestation of critical manifesation at structureItem level -->
    		<!-- get manifestation for critical edition -->
    		<xsl:if test="document($text-path)">
    			<rdf:Description rdf:about="http://scta.info/resource/{$fs}/critical">
    				<dc:title><xsl:value-of select="$fs"/> [Critical]</dc:title>
    				<role:AUT rdf:resource="{$author-uri}"/>
    				<rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
    				<sctap:hasTranscription rdf:resource="http://scta.info/resource/{$fs}/critical/transcription"/>
    				<sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$fs}/critical/transcription"/>
    				<sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$fs}"/>
    				<sctap:hasSlug><xsl:value-of>critical</xsl:value-of></sctap:hasSlug>
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
            <sctap:hasSlug><xsl:value-of select="$wit-slug"></xsl:value-of></sctap:hasSlug>
            <xsl:for-each select="./folio">
              <xsl:variable name="folionumber" select="./text()"/>
              <xsl:variable name="foliosideurl" select="concat('http://scta.info/resource/material/', $commentaryslug, '-', $wit-slug, '/', $folionumber)"/>
              <sctap:hasFolioSide rdf:resource="{$foliosideurl}"/>
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
            </xsl:for-each>
          	
          	<sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$fs}"/>
            
          	<xsl:if test="document($transcription-text-path)">
            	<sctap:hasTranscription rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}/transcription"/>
          		<sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}/transcription"/>
          	</xsl:if>
          	<!-- could include isPartOf to manuscript identifier
               could also inclue folio numbers if these are included in main project file -->
          </rdf:Description>
    			
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
              <!-- selection of next and previous is going to have erros because project file lists a folio twice when one item ends on a folio and then begins on another -->
              <xsl:variable name="nextFolionumber" select="./following-sibling::folio[1]/text()"/>
              <xsl:variable name="nextFoliosideurl" select="concat('http://scta.info/resource/material/', $commentaryslug, '-', $wit-slug, '/', $nextFolionumber)"/>
              <sctap:nextFolioSide rdf:resource="{$nextFoliosideurl}"/>
              <xsl:variable name="previousFolionumber" select="./preceding-sibling::folio[1]/text()"/>
              <xsl:variable name="previousFoliosideurl" select="concat('http://scta.info/resource/material/', $commentaryslug, '-', $wit-slug, '/', $previousFolionumber)"/>
              <sctap:previousFolioSide rdf:resource="{$previousFoliosideurl}"/>
            </rdf:Description>
    			</xsl:for-each>
    			
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
              <sctap:plaintext rdf:resource="http://text.scta.info/plaintext/{$cid}/{$fs}/transcription/{$wit-slug}"/>
    					<!-- requirement to lower case is bitbucket oddity that changges repo to lower case;
            		this would need to be adjusted after a switch to gitbut if github did not force repo names to lower case -->
    					<sctap:hasXML rdf:resource="{$gitRepoBase}{lower-case($fs)}/raw/master/{$wit-slug}_{$fs}.xml"/>
	          </rdf:Description>
    				
	          <!-- create paragraph resources for each paragraph in transcription -->
	          <xsl:for-each select="document($transcription-text-path)//tei:body//tei:p">
              <!-- only creates paragraph resource if that paragraph has been assigned an id -->
              <xsl:if test="./@xml:id">
	              <xsl:variable name="pid" select="./@xml:id"/>
	              <xsl:variable name="pid_ref" select="concat('#', ./@xml:id)"/>
	              
              	<!-- create manifestation for structureBlock -->
              	<rdf:Description rdf:about="http://scta.info/resource/{$pid}/{$wit-slug}">
              		<dc:title>Paragraph <xsl:value-of select="$pid"/></dc:title>
              		<rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
              		<sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}"/>
              		<sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$pid}"/>
              		<sctap:hasTranscription rdf:resource="http://scta.info/resource/{$pid}/{$wit-slug}/transcription"/>
              		<sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$pid}/{$wit-slug}/transcription"/>
              	</rdf:Description>
              	
              	<!-- create transcription for non-critical/documentary structureBlock -->
	              
	              
              	<rdf:Description rdf:about="http://scta.info/resource/{$pid}/{$wit-slug}/transcription">
	                <dc:title>Paragraph <xsl:value-of select="$pid"/></dc:title>
	                <rdf:type rdf:resource="http://scta.info/resource/transcription"/>
              		<sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}/transcription"/>
              		<sctap:isTranscriptionOf rdf:resource="http://scta.info/resource/{$pid}/{$wit-slug}"/>
              		<!-- add transcription type -->
              		<sctap:transcriptionType>Documentary</sctap:transcriptionType>
	                <sctap:plaintext rdf:resource="http://text.scta.info/plaintext/{$cid}/{$fs}/transcription/{$wit-slug}/paragraph/{$pid}"/>
	                <xsl:for-each select="document($transcription-text-path)/tei:TEI/tei:facsimile//tei:zone[@start=$pid_ref]">
                    <xsl:variable name="position" select="if (./@n) then ./@n else 1"/>
	                	<!-- TODO: simplifying name scheme for has Zone -->
                    <sctap:hasZone rdf:resource="http://scta.info/text/{$cid}/zone/{$wit-slug}_{$fs}/paragraph/{$pid}/{$position}"/>
                  </xsl:for-each>
	              	<sctap:hasXML rdf:resource="https://bitbucket.org/jeffreycwitt/{$fs}/raw/master/{$wit-slug}_{$fs}.xml#{$pid}"/>
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
	              </rdf:Description>
              	
              	<xsl:if test="document($transcription-text-path)/tei:TEI/tei:facsimile">
              		<xsl:for-each select="document($transcription-text-path)/tei:TEI/tei:facsimile//tei:zone[@start=$pid_ref]">
              			<xsl:variable name="imagefilename" select="./preceding-sibling::tei:graphic/@url"/>
              			<xsl:variable name="canvasname" select="substring-before($imagefilename, '.')"/>
              			<!-- this is not a good way to do this; this whole section needs to be written -->
              			<!-- right now I'm trying to just go the folio number without the preceding sigla -->
              			<!-- not this will fail if there is Sigla that reads Ar15r; the first "r" will not be removed and the result will be r15r -->
              			<xsl:variable name="folioname" select="translate($canvasname, 'ABCDEFGHIJKLMNOPQRSTUVabcdefghijklmnopqstuwxyz', '') "/>
              			<xsl:variable name="foliosideurl" select="concat('http://scta.info/resource/material/', $commentaryslug, '-', $wit-slug, '/', $folioname)"/>
                      
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
                      <sctap:isZoneOn rdf:resource="{$canvasid}"/>
                      <sctap:hasFolioSide rdf:resource="{$foliosideurl}"/>
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