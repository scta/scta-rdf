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
  
  <xsl:template name="top_level_manifestation">
    <xsl:param name="cid"/>
    <xsl:param name="author-uri"/>
    
    <xsl:for-each select="/listofFileNames/header/hasWitnesses/witness">
      <xsl:variable name="wit-title"><xsl:value-of select="./title"/></xsl:variable>
      <xsl:variable name="wit-initial"><xsl:value-of select="./initial"/></xsl:variable>
      <xsl:variable name="wit-canvasbase"><xsl:value-of select="./canvasBase"/></xsl:variable>
      <xsl:variable name="wit-slug"><xsl:value-of select="./slug"/></xsl:variable>
      <!-- TODO: this info probably needs to come from somewhere else; each manifestation will have different transcriptions and different number available -->
      <xsl:variable name="transcriptions">
        <transcriptions>
          <transcription name="transcription"/>
        </transcriptions>
      </xsl:variable>
      <xsl:variable name="canonical-transcription-name">transcription</xsl:variable>
      <xsl:call-template name="top_level_manifestation_entry">
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
        <xsl:with-param name="wit-title" select="$wit-title"/>
        <xsl:with-param name="wit-initial" select="$wit-initial"/>
        <xsl:with-param name="wit-canvasbase" select="$wit-canvasbase"/>
        <xsl:with-param name="wit-slug" select="$wit-slug"/>
        <xsl:with-param name="transcriptions" select="$transcriptions"/>
        <xsl:with-param name="canonical-transcription-name" select="$canonical-transcription-name"/>
      </xsl:call-template>
      <!-- if critical manifestations (and all manifestations were listed in edf/projectfile this second call we be unnecessary -->
      <xsl:call-template name="top_level_manifestation_entry">
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
        <xsl:with-param name="wit-title">Critical Edition</xsl:with-param>
        <xsl:with-param name="wit-initial">CE</xsl:with-param>
        <xsl:with-param name="wit-canvasbase"></xsl:with-param>
        <xsl:with-param name="wit-slug">critical</xsl:with-param>
        <xsl:with-param name="transcriptions" select="$transcriptions"/>
        <xsl:with-param name="canonical-transcription-name" select="$canonical-transcription-name"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="top_level_manifestation_entry">
    <xsl:param name="cid"/>
    <xsl:param name="author-uri"/>
    <xsl:param name="wit-title"/>
    <xsl:param name="wit-initial"/>
    <xsl:param name="wit-canvasbase"/>
    <xsl:param name="wit-slug"/>
    <xsl:param name="transcriptions"/>
    <xsl:param name="canonical-transcription-name"/>
    
    <rdf:Description rdf:about="http://scta.info/resource/{$cid}/{$wit-slug}">
      <dc:title><xsl:value-of select="$wit-title"/></dc:title>
      <rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
      <role:AUT rdf:resource="{$author-uri}"/>
      <sctap:structureType rdf:resource="http://scta.info/resource/structureCollection"/>
      <sctap:level>1</sctap:level>
      <sctap:hasSlug><xsl:value-of select="$wit-slug"></xsl:value-of></sctap:hasSlug>
      <sctap:shortId><xsl:value-of select="concat($cid, '/', $wit-slug)"/></sctap:shortId>
      <xsl:if test="./manifestOfficial">
        <xsl:variable name="wit-manifestofficial"><xsl:value-of select="./manifestOfficial"/></xsl:variable>
        <sctap:manifestOfficial><xsl:value-of select="$wit-manifestofficial"></xsl:value-of></sctap:manifestOfficial>
      </xsl:if>
      <sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$cid}"/>
      <xsl:for-each select="$transcriptions//transcription">
        <sctap:hasTranscription rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}/{./@name}"/>  
      </xsl:for-each>
      <sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}/{$canonical-transcription-name}"/>
      
      <!-- Identify direct child parts -->
      <xsl:for-each select="//div[@id='body']/div">
        <xsl:variable name="divid"><xsl:value-of select="./@id"/></xsl:variable>
        <dcterms:hasPart rdf:resource="http://scta.info/resource/{$divid}/{$wit-slug}"/>
      </xsl:for-each>
      <xsl:for-each select="//div[@id='body']/item">
        <xsl:variable name="direct-child-part"><xsl:value-of select="./@id"/></xsl:variable>
        <dcterms:hasPart rdf:resource="http://scta.info/resource/{$direct-child-part}/{$wit-slug}"/>
      </xsl:for-each>
      <!-- END; Identify direct child parts -->
      
      <!-- identify all resources with structureType=itemStructure -->
      
      <xsl:for-each select="//div[@id='body']//item">
        <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
        <sctap:hasStructureItem rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}"/>
      </xsl:for-each>
      
      <!-- create ldn inbox -->
      <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$cid}/{$wit-slug}"/>
    </rdf:Description>
    
  </xsl:template>
  
</xsl:stylesheet>