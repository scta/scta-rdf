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
  
  <xsl:import href="expression_properties.xsl"/>
  <xsl:template name="structure_item_expressions">
    <xsl:param name="cid"/>
    <xsl:param name="author-uri"/>
    <xsl:param name="dtsurn"/>
    <xsl:param name="textfilesdir"/>
    <xsl:param name="gitRepoStyle"/>
    <xsl:param name="gitRepoBase"/>
    
    <!-- item level params -->
    <xsl:param name="fs"/>
    <xsl:param name="title"/>
    <xsl:param name="item-level"/>
    <xsl:param name="expressionParentId"/>
    <xsl:param name="extraction-file"/>
    <xsl:param name="info-path"/>
    <xsl:param name="expressionType"/>
    <xsl:param name="sectionnumber"/>
    <xsl:param name="totalnumber"/>
    <xsl:param name="text-path"/>
    <xsl:param name="itemWitnesses"/>
    <xsl:param name="manifestations"/>
    <xsl:param name="translationManifestations"/>
    <xsl:param name="canonical-manifestation-id"/>
    
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
        <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        
      </xsl:call-template>
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
    <xsl:param name="canonical-manifestation-id"/>
    
    
    <rdf:Description rdf:about="http://scta.info/resource/{$fs}">
      <!-- global properties -->
      <dc:title><xsl:value-of select="$title"></xsl:value-of></dc:title>
      
      <!-- BEGIN text global properties -->
      
      <!-- TODO; condition should be removed with <div id=body> is changed to <div id=commentaryid> -->
      <xsl:choose>
        <xsl:when test="$item-level eq 2">
          <dcterms:isPartOf rdf:resource="http://scta.info/resource/{$cid}"/>
        </xsl:when>
        <xsl:otherwise>
          <dcterms:isPartOf rdf:resource="http://scta.info/resource/{$expressionParentId}"/>	
        </xsl:otherwise>
      </xsl:choose>
      <!-- END text global properties -->
      
      <!-- expression properties -->
      <!--<rdf:type rdf:resource="http://scta.info/resource/expression"/>-->
      <xsl:call-template name="expression_properties"/>
      <!-- end expression properties -->
      
      <!-- structureItem properties -->
      
      <!-- misc properites-->
      
      <role:AUT rdf:resource="{$author-uri}"/>
      
      <!-- record editors -->
      <!-- editors at the expression level doesn't seem accurate -->
      <!--<xsl:for-each select="document($extraction-file)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor">
        <sctap:editedBy><xsl:value-of select="."/></sctap:editedBy>
      </xsl:for-each>-->
      
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
        <xsl:choose>
          <!-- all manifestations are being treated the same
            so no type 'translation is set'
            TODO: if we wanted translations recorded as "hasTranslation" than the type attribute should be set, 
            but right now I think they should be treated the same and this conditional can be deleted in all expression 
            creation files -->
            
          <xsl:when test="./@type='translation'">
            <sctap:hasTranslation rdf:resource="http://scta.info/resource/{$fs}/{./@wit-slug}"/>
          </xsl:when>
          <xsl:otherwise>
            <sctap:hasManifestation rdf:resource="http://scta.info/resource/{$fs}/{./@wit-slug}"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <sctap:hasCanonicalManifestation rdf:resource="http://scta.info/resource/{$fs}/{$canonical-manifestation-id}"/>
      
      <!-- Identify Canonical Manifestation and canonical for Expression at the structureItem level -->
      <!--TODO: it is not ideal to ripping this information from the file path; it would be better if the projectdata file or transcription.xml file indicated this information -->
      
      
      <!-- TODO: add link to first level structureType division found in the tei document; 
    			this level of div is captured by the following expath in the LombardPress schema //tei:body/tei:div/tei:div -->
      
      <!-- create ldn inbox -->
      <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$fs}"/>
    </rdf:Description>
    
  </xsl:template>
  
  
</xsl:stylesheet>