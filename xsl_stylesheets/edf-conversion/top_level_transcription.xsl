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
  
  <xsl:template name="top_level_transcription">
    <xsl:param name="cid"/>
    <xsl:param name="author-uri"/>
    <xsl:for-each select="/listofFileNames/header/hasWitnesses/witness">
      <xsl:variable name="wit-title"><xsl:value-of select="./title"/></xsl:variable>
      <xsl:variable name="wit-initial"><xsl:value-of select="./initial"/></xsl:variable>
      <xsl:variable name="wit-canvasbase"><xsl:value-of select="./canvasBase"/></xsl:variable>
      <xsl:variable name="wit-slug"><xsl:value-of select="./slug"/></xsl:variable>
      <xsl:call-template name="top_level_transcription_entry">
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
        <xsl:with-param name="wit-title" select="$wit-title"/>
        <xsl:with-param name="wit-initial" select="$wit-initial"/>
        <xsl:with-param name="wit-canvasbase" select="$wit-canvasbase"/>
        <xsl:with-param name="wit-slug" select="$wit-slug"/>
        <xsl:with-param name="transcription-type">Diplomatic</xsl:with-param>
        <xsl:with-param name="transcription-name">transcription</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="top_level_transcription_entry">
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
        <xsl:with-param name="wit-title">Critical Edition</xsl:with-param>
        <xsl:with-param name="wit-initial">CE</xsl:with-param>
        <xsl:with-param name="wit-canvasbase"></xsl:with-param>
        <xsl:with-param name="wit-slug">critical</xsl:with-param>
        <xsl:with-param name="transcription-type">Critical</xsl:with-param>
        <xsl:with-param name="transcription-name">transcription</xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="top_level_transcription_entry">
    <xsl:param name="cid"/>
    <xsl:param name="author-uri"/>
    <xsl:param name="wit-title"/>
    <xsl:param name="wit-initial"/>
    <xsl:param name="wit-canvasbase"/>
    <xsl:param name="wit-slug"/>
    <xsl:param name="transcription-type"/>
    <xsl:param name="transcription-name"/>
    
    <rdf:Description rdf:about="http://scta.info/resource/{$cid}/{$wit-slug}/{$transcription-name}">
      <dc:title><xsl:value-of select="$wit-title"/> transcription</dc:title>
      <rdf:type rdf:resource="http://scta.info/resource/transcription"/>
      <role:AUT rdf:resource="{$author-uri}"/>
      <sctap:level>1</sctap:level>
      <sctap:structureType rdf:resource="http://scta.info/resource/structureCollection"/>
      <sctap:transcriptionType><xsl:value-of select="$transcription-type"/></sctap:transcriptionType>
      <sctap:shortId><xsl:value-of select="concat($cid, '/', $wit-slug, '/', $transcription-name)"/></sctap:shortId>
      <sctap:isTranscriptionOf rdf:resource="http://scta.info/resource/{$cid}"/>
      <sctap:hasXML rdf:resource="http://exist.scta.info/exist/apps/scta-app/document/{$cid}/{$wit-slug}/{$transcription-name}"/>
      <!-- Begin identify all direct children parts -->
      <xsl:for-each select="//div[@id='body']/div">
        <xsl:variable name="divid"><xsl:value-of select="./@id"/></xsl:variable>
        <dcterms:hasPart rdf:resource="http://scta.info/resource/{$divid}/{$wit-slug}/{$transcription-name}"/>
      </xsl:for-each>
      <xsl:for-each select="//div[@id='body']/item">
        <xsl:variable name="direct-child-part"><xsl:value-of select="./@id"/></xsl:variable>
        <dcterms:hasPart rdf:resource="http://scta.info/resource/{$direct-child-part}/{$wit-slug}/{$transcription-name}"/>
      </xsl:for-each>
      <!-- END; Identify direct child parts -->
      
      <!-- identify all resources with structureType=itemStructure -->
      <xsl:for-each select="//div[@id='body']//item">
        <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
        <sctap:hasStructureItem rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}/{$transcription-name}"/>
      </xsl:for-each>
      <!-- create ldn inbox -->
      <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$cid}/{$wit-slug}/{$transcription-name}"/>
    </rdf:Description>  
  </xsl:template>
  
</xsl:stylesheet>