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
    
    <!-- item level params -->
    <xsl:param name="fs"/>
    <xsl:param name="title"/>
    <xsl:param name="item-level"/>
    <xsl:param name="item-ancestors"/>
    <xsl:param name="expressionParentId"/>
    <xsl:param name="extraction-file"/>
    <xsl:param name="info-path"/>
    <xsl:param name="expressionType"/>
    <xsl:param name="sectionnumber"/>
    <xsl:param name="totalnumber"/>
    <xsl:param name="text-path"/>
    <xsl:param name="itemWitnesses"/>
    <xsl:param name="manifestations"/>
    <xsl:param name="canonical-manifestation-id"/>
    
      <xsl:call-template name="structure_item_expressions_entry">
        <xsl:with-param name="fs" select="$fs"/>
        <xsl:with-param name="title" select="$title"/>
        <xsl:with-param name="item-ancestors" select="$item-ancestors"/>
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
    <xsl:param name="item-ancestors"/>
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
      <!-- BEGIN global properties -->
        <xsl:call-template name="global_properties">
          <xsl:with-param name="title" select="$title"/>
          <xsl:with-param name="description"/>
          <xsl:with-param name="shortId" select="$fs"/>
        </xsl:call-template>
      <!-- END global properties -->
      <!-- BEGIN expression properties -->
        <xsl:call-template name="expression_properties">
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="structureType">structureItem</xsl:with-param>
          <xsl:with-param name="topLevelShortId" select="$cid"/>
          <xsl:with-param name="shortId" select="$fs"/>
        </xsl:call-template>
      <!-- END expression properties -->
      
      
      <!-- BEGIN structure item properties -->

      <xsl:call-template name="structure_item_properties">
        <xsl:with-param name="level" select="$item-level"></xsl:with-param>
        <xsl:with-param name="blocks" select="document($extraction-file)//tei:body//tei:p"/>
        <xsl:with-param name="blockFinisher" select="''"/>
        <xsl:with-param name="ancestors" select="$item-ancestors"/>
        <xsl:with-param name="defaultTranscriptionAndVersion" select="'true'"/>
      </xsl:call-template>
      <role:AUT rdf:resource="{$author-uri}"/>
     
      <xsl:choose>
        <xsl:when test="$item-level eq 2">
          <dcterms:isPartOf rdf:resource="http://scta.info/resource/{$cid}"/>
        </xsl:when>
        <xsl:otherwise>
          <dcterms:isPartOf rdf:resource="http://scta.info/resource/{$expressionParentId}"/>	
        </xsl:otherwise>
      </xsl:choose>
      
      <!-- record git repo -->
        <xsl:choose>
          <xsl:when test="$gitRepoStyle = 'toplevel'">
            <sctap:gitRepository><xsl:value-of select="concat($gitRepoBase, $cid)"/></sctap:gitRepository>
          </xsl:when>
          <xsl:otherwise>
            <sctap:gitRepository><xsl:value-of select="concat($gitRepoBase, $fs)"/></sctap:gitRepository>
          </xsl:otherwise>
        </xsl:choose>
      <!-- END structureItem properties -->
      
      <!-- BEGIN misc properties-->
        
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
        
        <!-- BEGIN record status -->
        <!-- TODO: not sure this applies to expression; sounds like it better applies to transcriptions -->
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
        
        <!-- BEGIN identifying hasPart expressions contained by structureItem , either div or paragraph-->
      <xsl:for-each select="document($extraction-file)//tei:body/tei:div/tei:div|document($extraction-file)//tei:body/tei:div/tei:p">
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
        <!-- END hasPart identifications -->
      <!-- END misc properties -->
      
      
    </rdf:Description>
    
  </xsl:template>
  
  
</xsl:stylesheet>