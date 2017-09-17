<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  xmlns:sctap="http://scta.info/property/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
  xmlns:sctar="http://scta.info/resource/" 
  xmlns:role="http://www.loc.gov/loc.terms/relators/" 
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
  xmlns:collex="http://www.collex.org/schema#" 
  xmlns:dcterms="http://purl.org/dc/terms/" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:ldp="http://www.w3.org/ns/ldp#"
  version="2.0">
  
  <xsl:template name="structure_item_expressions">
    <xsl:param name="cid"/>
    <xsl:param name="author-uri"/>
    <xsl:param name="dtsurn"/>
    <xsl:param name="textfilesdir"/>
    <xsl:param name="gitRepoStyle"/>
    <xsl:param name="gitRepoBase"/>
    
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
      <xsl:variable name="manifestations">
        <manifestations>
        <xsl:for-each select="$itemWitnesses">
          <xsl:variable name="wit-ref"><xsl:value-of select="substring-after(./@ref, '#')"/></xsl:variable>
          <xsl:variable name="wit-slug"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/slug"/></xsl:variable>
          <xsl:variable name="transcription-text-path" select="concat($textfilesdir, $fs, '/', $wit-slug, '_', $fs, '.xml')"/>
          <manifestation wit-ref="{$wit-ref}" wit-slug="{$wit-slug}" transcription-text-path="{$transcription-text-path}"/> 
        </xsl:for-each>
          <!-- Note: here is a way of combining item witnesses with one or more default manifestations such a 'critical' manifestation -->
          <!-- if a file without a prefix exist in directory, we assume this is a transcription of a manifestation called 'critical',
            therefore a manifestation called critical is added to the overall list -->
          <xsl:if test="document($text-path)">
            <manifestation wit-slug="critical" transcription-text-path="{$text-path}"/>
          </xsl:if>
        </manifestations>
      </xsl:variable>
      <xsl:variable name="translationTranscriptions" select="document(concat($repo-path, 'transcriptions.xml'))//transcription[@type='translation']"/>
      <xsl:variable name="translationManifestations" select="document(concat($repo-path, 'transcriptions.xml'))/transcriptions/translationManifestations//manifestation"/>
      
      <xsl:call-template name="structure_item_expressions_entry">
        <xsl:with-param name="fs" select="$fs"/>
        <xsl:with-param name="title" select="$title"/>
        <xsl:with-param name="item-level" select="$item-level"/>
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="expressionParentId" select="$expressionParentId"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
        <xsl:with-param name="extraction-file" select="$extraction-file"/>
        <xsl:with-param name="expressionType" select="$expressionType"/>
        <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
        <xsl:with-param name="totalnumber" select="$totalnumber"/>
        <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
        <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
        <xsl:with-param name="text-path" select="$text-path"/>
        <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
        <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
        <xsl:with-param name="manifestations" select="$manifestations"/>
        <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
        <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="structure_item_expressions_entry">
    <xsl:param name="fs"/>
    <xsl:param name="title"/>
    <xsl:param name="item-level"/>
    <xsl:param name="cid"/>
    <xsl:param name="expressionParentId"/>
    <xsl:param name="author-uri"/>
    <xsl:param name="extraction-file"/>
    <xsl:param name="expressionType"/>
    <xsl:param name="sectionnumber"/>
    <xsl:param name="totalnumber"/>
    <xsl:param name="gitRepoStyle"/>
    <xsl:param name="gitRepoBase"/>
    <xsl:param name="text-path"/>
    <xsl:param name="itemWitnesses"/>
    <xsl:param name="textfilesdir"/>
    <xsl:param name="manifestations"/>
    <xsl:param name="translationManifestations"/>
    <xsl:param name="canonical-manifestation-id"/>
    
    
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
      
      <!-- ============OLD WAY that required different loops for listed manifestations and default critical =========== -->
      <!-- get manifestation for critical edition -->
      <!-- TODO review hard coding of prefix for critical manifestation -->
      <!--<xsl:if test="document($text-path)">
      
        <sctap:hasManifestation rdf:resource="http://scta.info/resource/{$fs}/critical"/>
      </xsl:if>
      <xsl:for-each select="$itemWitnesses">
        <xsl:variable name="wit-ref"><xsl:value-of select="substring-after(./@ref, '#')"/></xsl:variable>
        <xsl:variable name="wit-slug"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/slug"/></xsl:variable>
        <xsl:variable name="transcription-text-path" select="concat($textfilesdir, $fs, '/', $wit-slug, '_', $fs, '.xml')"/>
        <sctap:hasManifestation rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}"/>
      </xsl:for-each>-->
      <!-- ============NEW WAY, once confirmed above can be deleted -->
      <xsl:for-each select="$manifestations//manifestation">
        <sctap:hasManifestation rdf:resource="http://scta.info/resource/{$fs}/{./@wit-slug}"/>
      </xsl:for-each>
      <!-- END maniftation recording -->
        
        
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
    
  </xsl:template>
  
</xsl:stylesheet>