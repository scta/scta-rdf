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
  
  
  
  <xsl:template name="structure_element_figure_expressions">
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
    <xsl:param name="expressionType"/>
    <xsl:param name="sectionnumber"/>
    <xsl:param name="totalnumber"/>
    <xsl:param name="text-path"/>
    <xsl:param name="itemWitnesses"/>
    <xsl:param name="manifestations"/>
    
    <xsl:param name="canonical-manifestation-id"/>
    
    <xsl:for-each select="document($extraction-file)//tei:body//tei:figure[@xml:id]">
      <xsl:variable name="figureId" select="./@xml:id"/>
      <xsl:variable name="figureParent" select=".//ancestor::tei:p/@xml:id"/>
      
      <xsl:variable name="element-ancestors">
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
          <xsl:for-each select="ancestor::tei:p[1]">
            <ancestor id="{./@xml:id}">
              <head><xsl:value-of select="./@xml:id"/></head>
            </ancestor>
          </xsl:for-each>
        </ancestors>
      </xsl:variable>
      <xsl:variable name="element-level" select="count($element-ancestors//ancestor) + 1"/>
      
      <xsl:call-template name="structure_element_figure_expressions_entry">
        <xsl:with-param name="fs" select="$fs"/>
        <xsl:with-param name="title" select="$title"/>
        <xsl:with-param name="item-level" select="$item-level"/>
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="expressionParentId" select="$expressionParentId"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
        <xsl:with-param name="extraction-file" select="$extraction-file"/>
        <xsl:with-param name="expressionType" select="if (./@type) then ./@type else 'figure'"/>
        <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
        <xsl:with-param name="totalnumber" select="$totalnumber"/>
        <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
        <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
        <xsl:with-param name="text-path" select="$text-path"/>
        <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
        <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
        <xsl:with-param name="manifestations" select="$manifestations"/>
        <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        
        <!--<xsl:with-param name="quoteRef" select="$quoteRef"/>-->
        <!--<xsl:with-param name="quoteID" select="$quoteID"/>-->
        <xsl:with-param name="figureId" select="$figureId"/>
        <xsl:with-param name="figureParent" select="$figureParent"/>
        <xsl:with-param name="element-ancestors" select="$element-ancestors"/>
        <xsl:with-param name="element-level" select="$element-level"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="structure_element_figure_expressions_entry">
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
    
    <!--<xsl:param name="quoteRef"/>-->
    <!--<xsl:param name="quoteID"/>-->
    <xsl:param name="figureId"/>
    <xsl:param name="figureParent"/>
    <xsl:param name="element-ancestors"/>
    <xsl:param name="element-level"/>
    
    <rdf:Description rdf:about="http://scta.info/resource/{$figureId}">
      <!-- BEGIN global properties -->
      <xsl:call-template name="global_properties">
        <xsl:with-param name="title">Structure Element <xsl:value-of select="$figureId"/></xsl:with-param>
        <xsl:with-param name="description"/>
        <xsl:with-param name="shortId" select="$figureId"/>
      </xsl:call-template>
      <!-- END global properties -->
      <!-- BEGIN expression properties -->
      <xsl:call-template name="expression_properties">
        <xsl:with-param name="expressionType" select="$expressionType"/>
        <xsl:with-param name="manifestations" select="$manifestations"/>
        <xsl:with-param name="structureType">structureElement</xsl:with-param>
        <xsl:with-param name="topLevelShortId" select="$cid"/>
        <xsl:with-param name="shortId" select="$figureId"/>
      </xsl:call-template>
      <!-- END expression properties -->
      <!-- BEGIN structure type properties -->
      <xsl:call-template name="structure_element_properties">
        <xsl:with-param name="isPartOfStructureBlockShortId" select="$figureParent"/>
        <xsl:with-param name="isPartOfShortId" select="$figureParent"/>
        <xsl:with-param name="elementType">structureElementFigure</xsl:with-param>
        <xsl:with-param name="elementText" select="."/>
        <xsl:with-param name="ancestors" select="$element-ancestors"/>
        <xsl:with-param name="finisher" select="''"/>
      </xsl:call-template>
      <sctap:level><xsl:value-of select="$element-level"/></sctap:level>
      <!-- END structure type properties -->
    </rdf:Description>
    
  </xsl:template>
  
</xsl:stylesheet>