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
  
  <xsl:template name="expression_properties">
    <xsl:param name="expressionType"/>
    <xsl:param name="expressionSubType"/>
    <xsl:param name="manifestations"/>
    <xsl:param name="structureType"/>
    <xsl:param name="topLevelShortId"/>
    <xsl:param name="shortId"/>
    
    <rdf:type rdf:resource="http://scta.info/resource/expression"/>
    
    <xsl:if test="$topLevelShortId">
      <sctap:isPartOfTopLevelExpression rdf:resource="http://scta.info/resource/{$topLevelShortId}"/>
    </xsl:if>
    
    <xsl:if test="$expressionType">
      <sctap:expressionType rdf:resource="http://scta.info/resource/{$expressionType}"/>
    </xsl:if>
    <xsl:if test="$expressionSubType">
      <sctap:expressionType rdf:resource="http://scta.info/resource/{$expressionSubType}"/>
    </xsl:if>
    
    <xsl:choose>
      <xsl:when test="$structureType='structureCollection'"/>
      <xsl:otherwise>
        <xsl:for-each select="$manifestations//manifestation">
          <sctap:hasManifestation rdf:resource="http://scta.info/resource/{$shortId}/{./@wit-slug}"/>
          <xsl:if test="./@canonical='true'">
            <sctap:hasCanonicalManifestation rdf:resource="http://scta.info/resource/{$shortId}/{./@wit-slug}"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
    
    
  </xsl:template>
  
</xsl:stylesheet>