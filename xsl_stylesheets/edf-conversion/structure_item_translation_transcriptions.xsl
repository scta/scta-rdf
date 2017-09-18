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
  
  <xsl:template name="structure_item_translation_transcriptions">
    <xsl:param name="cid"/>
    <xsl:param name="author-uri"/>
    <xsl:param name="dtsurn"/>
    <xsl:param name="textfilesdir"/>
    <xsl:param name="gitRepoStyle"/>
    <xsl:param name="gitRepoBase"/>
    <!-- required item level params -->
    <xsl:param name="fs"/>
    <xsl:param name="repo-path"/>
    <xsl:param name="translationTranscriptions"/>
    <xsl:param name="translationManifestations"/>
    
    <xsl:for-each select="$translationTranscriptions">
       <xsl:variable name="languague" select="./@language"/>
       <xsl:variable name="isTranslationOf" select="./@isTranslationOf"/>
       <xsl:variable name="hash" select="./@hash"/>
       <xsl:variable name="name" select="./@name"/>
       <xsl:variable name="type" select="./@type"/>
       <xsl:variable name="filename" select="./text()"/>
       <xsl:call-template name="structure_item_translation_transcriptions_entry">
         <xsl:with-param name="languague" select="$languague"/>
         <xsl:with-param name="isTranslationOf" select="$isTranslationOf"/>
         <xsl:with-param name="hash" select="$hash"/>
         <xsl:with-param name="name" select="$name"/>
         <xsl:with-param name="type" select="$type"/>
         <xsl:with-param name="filename" select="$filename"/>
         <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
         <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
       </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="structure_item_translation_transcriptions_entry">
    <xsl:param name="fs"/>
    <xsl:param name="cid"/>
    <xsl:param name="gitRepoStyle"/>
    <xsl:param name="gitRepoBase"/>
    <xsl:param name="languague"/>
    <xsl:param name="isTranslationOf"/>
    <xsl:param name="hash"/>
    <xsl:param name="name"/>
    <xsl:param name="type"/>
    <xsl:param name="filename"/>
    
    <rdf:Description rdf:about="http://scta.info/resource/{$fs}/{$isTranslationOf}/{$name}">
      <dc:title><xsl:value-of select="$fs"/> [Translation]</dc:title>
      <rdf:type rdf:resource="http://scta.info/resource/transcription"/>
      <sctap:structureType rdf:resource="http://scta.info/resource/structureItem"/>
      <sctap:plaintext rdf:resource="http://scta.lombardpress.org/text/plaintext/{$fs}/{$isTranslationOf}/{$name}"/>
      <sctap:isPartOfTopLevelTranscription rdf:resource="http://scta.info/resource/{$cid}/{$isTranslationOf}/{$name}"/>
      <sctap:shortId><xsl:value-of select="concat($fs, '/', $isTranslationOf, '/', $name)"/></sctap:shortId>
      <sctap:isTranscriptionOf rdf:resource="http://scta.info/resource/{$fs}/{$isTranslationOf}"/>
      <sctap:transcriptionType><xsl:value-of select="$type"/></sctap:transcriptionType>
      
      <xsl:choose>
        <xsl:when test="$hash eq 'head'">
          <xsl:choose>
            <xsl:when test="$gitRepoStyle = 'toplevel'">
              <sctap:hasDocument rdf:resource="{$gitRepoBase}{lower-case($cid)}/raw/master/{$fs}/{$filename}"/>
            </xsl:when>
            <xsl:otherwise>
              <sctap:hasDocument rdf:resource="{$gitRepoBase}{lower-case($fs)}/raw/master/{$filename}"/>
            </xsl:otherwise>	
          </xsl:choose>
          <sctap:ipfsHash></sctap:ipfsHash>
        </xsl:when>
        <xsl:otherwise>
          <sctap:hasDocument rdf:resource="https://gateway.ipfs.io/ipfs/{$hash}"/>
          <sctap:ipfsHash><xsl:value-of select="$hash"/></sctap:ipfsHash>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="./@hasSuccessor">
        <sctap:hasSuccessor rdf:resource="{./@hasSuccessor}"></sctap:hasSuccessor>
      </xsl:if>
      <!-- set location text part can be accessed as xml file without an intermediary processing -->
      <sctap:hasXML rdf:resource="http://exist.scta.info/exist/apps/scta-app/document/{$fs}/{$isTranslationOf}/{$name}"/>
      <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$fs}/{$isTranslationOf}/{$name}"/>
      
    </rdf:Description>
  </xsl:template>
</xsl:stylesheet>