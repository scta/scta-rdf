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
  
  <xsl:template name="transcription_properties">
    <xsl:param name="shortId"/>
    <xsl:param name="topLevelShortId"/>
    <xsl:param name="isTranscriptionOfShortId"/>
    <xsl:param name="lang"/>
    <xsl:param name="transcriptions"/>
    <xsl:param name="structureType"/>
    <xsl:param name="canonical-transcription-name"/>
    <xsl:param name="transcription-type"/>
    <xsl:param name="docWebLink"/>
    <xsl:param name="ipfsHash"/>
    <xsl:param name="hasSuccessor"/>
    <xsl:param name="transcription-text-path"/>
    <xsl:param name="wit-slug"/>
    
    
    <rdf:type rdf:resource="http://scta.info/resource/transcription"/>
    <xsl:if test="$lang">
      <dc:language><xsl:value-of select="$lang"/></dc:language>
    </xsl:if>
    <xsl:if test="$topLevelShortId">
      <sctap:isPartOfTopLevelTranscription rdf:resource="http://scta.info/resource/{$topLevelShortId}"/>
    </xsl:if>
    <sctap:isTranscriptionOf rdf:resource="http://scta.info/resource/{$isTranscriptionOfShortId}"/>
    <sctap:transcriptionType><xsl:value-of select="$transcription-type"/></sctap:transcriptionType>
    <sctap:isPartOfTopLevelTranscription rdf:resource="http://scta.info/resource/{$topLevelShortId}"/>
    <sctap:hasXML rdf:resource="http://exist.scta.info/exist/apps/scta-app/document/{$shortId}"/>
    
    <sctap:plaintext rdf:resource="http://scta.lombardpress.org/text/plaintext/{$shortId}"/>
    <xsl:if test="not($structureType='structureCollection')">
      <sctap:hasDocument rdf:resource="{$docWebLink}"/>
      <!--<xsl:if test="$hasSuccessor">
        <sctap:hasSuccessor rdf:resource="{$hasSuccessor}"></sctap:hasSuccessor>
      </xsl:if>-->
      <!--<xsl:if test="not($ipfsHash='head')">
        <sctap:ipfsHash><xsl:value-of select="$ipfsHash"/></sctap:ipfsHash>
      </xsl:if>-->
      <xsl:choose>
        <xsl:when test="document($transcription-text-path)//tei:revisionDesc/@status">
          <sctap:status><xsl:value-of select="document($transcription-text-path)//tei:revisionDesc/@status"></xsl:value-of></sctap:status>
        </xsl:when>
        <xsl:when test="document($transcription-text-path)">
          <sctap:status>In Progress</sctap:status>
        </xsl:when>
        <xsl:otherwise>
          <sctap:status>Not Started</sctap:status>
        </xsl:otherwise>
      </xsl:choose>
      
      
      <!-- version info -->
      <xsl:if test="$structureType='structureItem'">
      <sctap:hash><xsl:value-of select="./hash"/></sctap:hash>
      <xsl:if test="./@versionDefault='true'">
        <sctap:isVersionDefault>true</sctap:isVersionDefault>
      </xsl:if>
      <xsl:for-each select="preceding-sibling::version[1]">
        <sctap:hasSuccessor rdf:resource="http://scta.info/resource/{$isTranscriptionOfShortId}/{./hash}"/>
      </xsl:for-each>
      <xsl:for-each select="following-sibling::version[1]">
        <sctap:hasPredecessor rdf:resource="http://scta.info/resource/{$isTranscriptionOfShortId}/{./hash}"/>
      </xsl:for-each>
      <xsl:for-each select="preceding-sibling::version">
        <sctap:hasDescendant rdf:resource="http://scta.info/resource/{$isTranscriptionOfShortId}/{./hash}"/>
      </xsl:for-each>
      <xsl:for-each select="following-sibling::version">
        <sctap:hasAncestor rdf:resource="http://scta.info/resource/{$isTranscriptionOfShortId}/{./hash}"/>
      </xsl:for-each>
      <xsl:variable name="ordernumber"><xsl:number count="version" /></xsl:variable>
      
      
      <xsl:if test="$ordernumber eq '1'">
        <sctap:isHeadTranscription>true</sctap:isHeadTranscription>
      </xsl:if>
      <xsl:if test="./@reviewed='true'">
        <sctap:hasReview>true</sctap:hasReview>
      </xsl:if>
      <xsl:if test="$ordernumber">
        <!-- calculates reverse order number, so that the earliest version in the version chain is 0001 
          and the version head is the highest number in the version chain -->
        <xsl:variable name="reverseOrderNumber" select="((count(./preceding-sibling::version) + count(./following-sibling::version)) + 2)  - $ordernumber"/>
        <sctap:versionOrderNumber><xsl:value-of select="format-number($reverseOrderNumber, '0000')"/></sctap:versionOrderNumber>
      </xsl:if>
      </xsl:if>
    </xsl:if>
    
    
  </xsl:template>
</xsl:stylesheet>