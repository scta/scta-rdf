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
  
  <xsl:template name="structure_element_manifestations">
    <xsl:param name="cid"/>
    <xsl:param name="manifestations"/>
    <xsl:param name="repo-path"/>
    
    <xsl:for-each select="$manifestations//manifestation">
      <xsl:variable name="wit-slug" select="./@wit-slug"/>
      <xsl:variable name="wit-title" select="./@wit-title"/>
      <!-- only create block level manifestations if a transcription file has been started -->
      <xsl:if test="./transcriptions">
        <!-- required item level manifestation params -->
        
        <xsl:variable name="transcriptions" select="./transcriptions"/>
        <xsl:variable name="url" select="$transcriptions/transcription[@transcriptionDefault='true']/version[@versionDefault='true']/url"/>
        <xsl:variable name="transcription-text-path" select="concat($repo-path, $url)"/>
        <xsl:variable name="lang" select="./@lang"/>
        
        <xsl:for-each select="document($transcription-text-path)//tei:body//tei:quote[@xml:id] |
          document($transcription-text-path)//tei:body//tei:ref[@xml:id]">
          <!-- get elementname and capitalize it -->
          <xsl:variable name="elementName">
            <xsl:value-of select="concat(
            translate(
            substring(./name(), 1, 1),
            'abcdefghijklmnopqrstuvwxyz',
            'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
            ),
            substring(./name(),2,string-length(./name())-1)
            )"/>
          </xsl:variable>
          <xsl:message><xsl:value-of select="$elementName"/></xsl:message>
          <xsl:variable name="this-quote-id" select="./@xml:id"/>
          <xsl:variable name="pid" select="./ancestor::tei:p[1]/@xml:id"/>
            <xsl:call-template name="structure_element_manifestations_entry">
              <xsl:with-param name="cid" select="$cid"/>
              <xsl:with-param name="transcriptions" select="$transcriptions"/>
              <xsl:with-param name="wit-slug" select="$wit-slug"/>
              <xsl:with-param name="lang" select="$lang"/>
              <xsl:with-param name="pid" select="$pid"/>
              <xsl:with-param name="this-quote-id" select="$this-quote-id"/>
              <xsl:with-param name="elementName" select="$elementName"/>
            </xsl:call-template>
          
        </xsl:for-each>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="structure_element_manifestations_entry">
    <xsl:param name="cid"/>
    <xsl:param name="transcriptions"/>
    <xsl:param name="wit-slug"/>
    <xsl:param name="lang"/>
    <xsl:param name="elementName"/>
    <!-- p level params -->
    <xsl:param name="pid"/>
    <xsl:param name="this-quote-id"/>
    
      <rdf:Description rdf:about="http://scta.info/resource/{$this-quote-id}/{$wit-slug}">
        
        <!-- BEGIN global properties -->
        <xsl:call-template name="global_properties">
          <xsl:with-param name="title"><xsl:value-of select="$elementName"/> <xsl:value-of select="$this-quote-id"/></xsl:with-param>
          <xsl:with-param name="description"/>
          <xsl:with-param name="shortId" select="concat($this-quote-id, '/', $wit-slug)"/>
        </xsl:call-template>
        <!-- END global properties -->
        
        <!-- BEGIN manifestation properties -->
        <xsl:call-template name="manifestation_properties">
          <xsl:with-param name="lang" select="$lang"/>
          <xsl:with-param name="topLevelShortId" select="concat($cid, '/', $wit-slug)"/>
          <xsl:with-param name="isManifestationOfShortId" select="$this-quote-id"/>
          <xsl:with-param name="shortId" select="concat($this-quote-id, '/', $wit-slug)"/>
          <xsl:with-param name="transcriptions" select="$transcriptions"/>
          <!-- TODO; shouldn't this be deleted; or at least changed to structreElement -->
          <xsl:with-param name="structureType">structureDivision</xsl:with-param>
        </xsl:call-template>
        <!-- END manifestation properties -->
        <!-- BEGIN structure type properties -->
        <xsl:call-template name="structure_element_properties">
          <xsl:with-param name="isPartOfStructureBlockShortId" select="concat($pid, '/', $wit-slug)"/>
          <xsl:with-param name="isPartOfShortId" select="concat($pid, '/', $wit-slug)"/>
          <xsl:with-param name="elementType">structureElement<xsl:value-of select="$elementName"/></xsl:with-param>
          <xsl:with-param name="elementText" select="."/>
        </xsl:call-template>
        <!-- END structure type properties -->
      </rdf:Description>
    
    
    
  </xsl:template>
</xsl:stylesheet>