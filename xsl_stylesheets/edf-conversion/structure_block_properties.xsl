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
  
  <xsl:template name="structure_block_properties">
    <xsl:param name="isPartOfStructureItemShortId"/>
    <xsl:param name="isPartOfShortId"/>
    <xsl:param name="finisher"/>
    <xsl:param name="ancestors"/>
    <xsl:param name="title"/>
    <sctap:structureType rdf:resource="http://scta.info/resource/structureBlock"/>
    <dcterms:isPartOf rdf:resource="http://scta.info/resource/{$isPartOfShortId}"/>
    <sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$isPartOfStructureItemShortId}"/>
    
    
    <!-- identify all ancestors as resource that current node is member of -->
    <xsl:if test="$ancestors">
      <xsl:for-each select="$ancestors//ancestor">
        <xsl:variable name="ancestorid">
          <xsl:choose>
            <xsl:when test="./@id='body'">
              <xsl:value-of select="$cid"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="./@id"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <sctap:isMemberOf rdf:resource="http://scta.info/resource/{$ancestorid}{$finisher}"/>
      </xsl:for-each>
      <xsl:variable name="longtitle" select="concat(string-join($ancestors//ancestor/head, ', '), ', ', $title)" />
      <sctap:longTitle><xsl:value-of select="$longtitle"/></sctap:longTitle>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>