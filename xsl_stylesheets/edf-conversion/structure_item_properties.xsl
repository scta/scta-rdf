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
  
  <xsl:template name="structure_item_properties">
    <xsl:param name="level"/>
    <xsl:param name="blocks"/>
    <xsl:param name="blockFinisher"/>
    <xsl:param name="ancestors"/>
    <xsl:param name="defaultTranscriptionAndVersion"/>
    
    <sctap:structureType rdf:resource="http://scta.info/resource/structureItem"/>
    <xsl:if test="$level">
      <sctap:level><xsl:value-of select="$level"/></sctap:level>
    </xsl:if>
    
    <xsl:if test="$defaultTranscriptionAndVersion eq 'true'">
      <xsl:for-each select="$blocks">
        <xsl:variable name="pid" select="./@xml:id"/>
        <xsl:variable name="pid_ref" select="concat('#', ./@xml:id)"/>
        <!-- only creates paragraph resource if that paragraph has been assigned an id -->
        <xsl:if test="./@xml:id">
          <sctap:hasStructureBlock rdf:resource="http://scta.info/resource/{$pid}{$blockFinisher}"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
    
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
        <sctap:isMemberOf rdf:resource="http://scta.info/resource/{$ancestorid}{$blockFinisher}"/>
      </xsl:for-each>
      
      <!-- create concatenated long title from ancestor titles -->
      <xsl:variable name="longtitle" select="string-join($ancestors/head|title, ', ')" />
      <sctap:longTitle><xsl:value-of select="$longtitle"/></sctap:longTitle>
    </xsl:if>
    
      
    
    
  </xsl:template>
  
</xsl:stylesheet>