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
  
  <xsl:template name="manifestation_properties">
    <xsl:param name="shortId"/>
    <xsl:param name="topLevelShortId"/>
    <xsl:param name="isManifestationOfShortId"/>
    <xsl:param name="lang"/>
    <xsl:param name="transcriptions"/>
    <xsl:param name="structureType"/>
    <xsl:param name="canonical-transcription-name"/>
    
    <rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
    <xsl:if test="$lang">
      <dc:language><xsl:value-of select="$lang"/></dc:language>
    </xsl:if>
    <xsl:if test="$topLevelShortId">
      <sctap:isPartOfTopLevelManifestation rdf:resource="http://scta.info/resource/{$topLevelShortId}"/>
    </xsl:if>
    <sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$isManifestationOfShortId}"/>
    
    <!-- NOTE $transcriptions structure for structureCollections is a little bit different 
    than the structure from otherStructures, and thus the conditional switch. 
    TODO: over time we should work to make these structures identical so that the switch is no longer necessary-->
    <xsl:if test="$transcriptions">
    <xsl:choose>
      <xsl:when test="$structureType='structureCollection'">
        <xsl:for-each select="$transcriptions//transcription">
          <sctap:hasTranscription rdf:resource="http://scta.info/resource/{$shortId}/{./@name}"/>
          <xsl:if test="./@canonical eq 'true'">
            <sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$shortId}/{./@name}"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="$transcriptions//transcription">
          <xsl:if test="document(./@transcription-text-path)">
            <sctap:hasTranscription rdf:resource="http://scta.info/resource/{$shortId}/{./@name}"/>
            <xsl:if test="./@canonical eq 'true'">
              <sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$shortId}/{./@name}"/>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>