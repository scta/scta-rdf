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
  
  
  
  <xsl:template name="structure_division_expressions">
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
    <xsl:param name="extraction-file"/>
    <xsl:param name="info-path"/>
    <xsl:param name="expressionType"/>
    <xsl:param name="sectionnumber"/>
    <xsl:param name="totalnumber"/>
    <xsl:param name="text-path"/>
    <xsl:param name="itemWitnesses"/>
    <xsl:param name="manifestations"/>
    
    <xsl:param name="canonical-manifestation-id"/>
    
      
      <xsl:for-each  select="document($extraction-file)//tei:body/tei:div//tei:div">
        
        <xsl:variable name="div-ancestors">
          <ancestors>
            <xsl:for-each select="$item-ancestors">
              <ancestor id="{./@id}">
                <head><xsl:value-of select="./head"/></head>
              </ancestor>
            </xsl:for-each>
            <xsl:for-each select="ancestor::tei:div">
              <ancestor id="{./@xml:id}">
                <head><xsl:value-of select="./tei:head[1]"/></head>
              </ancestor>
            </xsl:for-each>
          </ancestors>
        </xsl:variable>
        <xsl:variable name="div-level" select="count($div-ancestors//ancestor) + 1"/>
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
        
        <xsl:variable name="expressionType">
          <xsl:choose>
            <xsl:when test="./@type">
              <xsl:value-of select="./@type"/>
            </xsl:when>
            <xsl:otherwise>division</xsl:otherwise>
          </xsl:choose> 
        </xsl:variable>
        
        
        <xsl:variable name="ParentId" select="./parent::tei:div/@xml:id"/>
      
        <xsl:call-template name="structure_division_expressions_entry">
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="title" select="$title"/>
          <xsl:with-param name="item-level" select="$item-level"/>
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="ParentId" select="$ParentId"/>
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
          <xsl:with-param name="divisionID" select="$divisionID"/>
          <xsl:with-param name="div-level" select="$div-level"/>
          <xsl:with-param name="div-ancestors" select="$div-ancestors"/>
          
          <xsl:with-param name="info-path" select="$info-path"/>
          
        </xsl:call-template>
      </xsl:for-each>
  </xsl:template>
  <xsl:template name="structure_division_expressions_entry">
    <xsl:param name="fs"/>
    <xsl:param name="title"/>
    <xsl:param name="item-level"/>
    <xsl:param name="cid"/>
    
    <xsl:param name="ParentId"/>
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
    
    <xsl:param name="divisionID"/>
    <xsl:param name="divisionExpressionType"/>
    <xsl:param name="info-path"/>
    <xsl:param name="div-level"/>
    <xsl:param name="div-ancestors"/>
    
      
      <rdf:Description rdf:about="http://scta.info/resource/{$divisionID}">
        <!-- BEGIN global properties -->
        <xsl:call-template name="global_properties">
          <!-- title xpath is set to ./head[1] to ensure that it grabs the first head and not any subtitles -->
          <xsl:with-param name="title" select="./tei:head[1]"/>
          <xsl:with-param name="description"/>
          <xsl:with-param name="shortId" select="$divisionID"/>
        </xsl:call-template>
        <!-- END global properties -->
        <!-- BEGIN expression properties -->
        <xsl:call-template name="expression_properties">
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="structureType">structureDivision</xsl:with-param>
          <xsl:with-param name="topLevelShortId" select="$cid"/>
          <xsl:with-param name="shortId" select="$divisionID"/>
        </xsl:call-template>
        <!-- END expression properties -->
        <!-- BEGIN structure division properties -->
        <xsl:call-template name="structure_division_properties">
          <xsl:with-param name="blocks" select=".//tei:p"/>
          <xsl:with-param name="blockFinisher" select="''"/>
          <xsl:with-param name="isPartOfStructureItemShortId" select="$fs"/>
          <xsl:with-param name="isPartOfShortId" select="$ParentId"/>
          <xsl:with-param name="ancestors" select="$div-ancestors"/>
        </xsl:call-template>
        
        <sctap:level><xsl:value-of select="$div-level"/></sctap:level>
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
        
      </rdf:Description>
    
    
    
  </xsl:template>
  
</xsl:stylesheet>