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
  
  <xsl:template name="structure_element_quote_manifestations">
    <xsl:param name="cid"/>
    <xsl:param name="manifestations"/>
    
    <xsl:for-each select="$manifestations//manifestation">
      <!-- required item level manifestation params -->
      <xsl:variable name="wit-slug" select="./@wit-slug"/>
      <xsl:variable name="wit-title" select="./@wit-title"/>
      <xsl:variable name="transcriptions" select="./transcriptions"/>
      <xsl:variable name="transcription-text-path" select="$transcriptions/transcription[@canonical='true']/@transcription-text-path"/>
      
      <xsl:for-each select="document($transcription-text-path)//tei:body//tei:quote[@xml:id]">
        <xsl:variable name="this-quote-id" select="./@xml:id"/>
        <xsl:variable name="pid" select="./ancestor::tei:p[1]/@xml:id"/>
          <xsl:call-template name="structure_element_quote_manifestations_entry">
            <xsl:with-param name="cid" select="$cid"/>
            <xsl:with-param name="wit-slug" select="$wit-slug"/>
            <xsl:with-param name="pid" select="$pid"/>
            <xsl:with-param name="this-quote-id" select="$this-quote-id"/>
          </xsl:call-template>
        
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="structure_element_quote_manifestations_entry">
    <xsl:param name="cid"/>
    <xsl:param name="wit-slug"/>
    <!-- p level params -->
    <xsl:param name="pid"/>
    <xsl:param name="this-quote-id"/>
      <rdf:Description rdf:about="http://scta.info/resource/{$this-quote-id}/{$wit-slug}">
        <rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
        <sctap:structureType rdf:resource="http://scta.info/resource/structureElement"/>
        <sctap:structureElementType rdf:resource="http://scta.info/resource/structureElementQuote"/>
        <sctap:structureElementText><xsl:value-of select="."/></sctap:structureElementText>
        <sctap:isPartOfStructureBlock rdf:resource="http://scta.info/resource/{$pid}/{$wit-slug}"/>
        <sctap:shortId><xsl:value-of select="concat($this-quote-id, '/', $wit-slug)"/></sctap:shortId>
        
        <xsl:choose>
          <xsl:when test="./@type='translation'">
            <rdf:type rdf:resource="http://scta.info/resource/translation"/>
            <sctap:isPartOfTopLevelTranslation rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
            <sctap:isTranslationOf rdf:resource="http://scta.info/resource/{$this-quote-id}"/>
          </xsl:when>
          <xsl:otherwise>
            <rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
            <sctap:isPartOfTopLevelManifestation rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
            <sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$this-quote-id}"/>
          </xsl:otherwise>
        </xsl:choose>
      </rdf:Description>
    
    
    
  </xsl:template>
</xsl:stylesheet>