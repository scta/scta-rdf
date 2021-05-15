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
  
  <xsl:template name="structure_collection_properties">
    <xsl:param name="cid"/>
    <xsl:param name="level"/>
    <xsl:param name="items"/>
    <xsl:param name="itemFinisher"/>
    <xsl:param name="ancestors"/>
    <xsl:param name="title"/>
    
    <sctap:structureType rdf:resource="http://scta.info/resource/structureCollection"/>
    
    <xsl:if test="$level">
      <sctap:level><xsl:value-of select="$level"/></sctap:level>
    </xsl:if>
    
    <!-- identify all resources with structureType=itemStructure -->
    <xsl:for-each select="$items">
      <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
      <sctap:hasStructureItem rdf:resource="http://scta.info/resource/{$fs}{$itemFinisher}"/>
    </xsl:for-each>
    <!-- identify all ancestors as resource that current node is member of -->
    <xsl:if test="$ancestors">
      <xsl:for-each select="$ancestors">
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
        <sctap:isMemberOf rdf:resource="http://scta.info/resource/{$ancestorid}{$itemFinisher}"/>
      </xsl:for-each>
      <xsl:variable name="longtitle" select="concat(string-join($ancestors/head, ', '), ', ', $title)" />
      <sctap:longTitle><xsl:value-of select="$longtitle"/></sctap:longTitle>
    </xsl:if>
    <xsl:if test="$level eq '1'">
      <sctap:longTitle><xsl:value-of select="$title"/></sctap:longTitle>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>