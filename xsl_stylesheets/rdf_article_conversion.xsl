<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dcterms="http://purl.org/dc/terms/" xmlns:sctar="http://scta.info/resource/"
  xmlns:sctap="http://scta.info/property/" xmlns:rcs="http://rcs.philsem.unibas.ch/resource/">
  <xsl:output method="xml" indent="yes" xml:space="default"/>
  <xsl:template match="/">
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
      xmlns:sctap="http://scta.info/property/" xmlns:sctar="http://scta.info/resource/"
      xmlns:role="http://www.loc.gov/loc.terms/relators/"
      xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
      xmlns:collex="http://www.collex.org/schema#" xmlns:dcterms="http://purl.org/dc/terms/"
      xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#"
      xmlns:rcs="http://rcs.philsem.unibas.ch/resource/">
      <xsl:call-template name="article"/>
      <xsl:call-template name="transcription"/>
      
    </rdf:RDF>
  </xsl:template>
  <xsl:template name="article">
    <xsl:for-each select="//manifestation">
    <xsl:variable name="title" select="./title"/>
    <xsl:variable name="type" select="./type"/>
    <rdf:Description rdf:about="http://scta.info/resource/{./name}">
      <rdf:type rdf:resource="http://scta.info/resource/article"/>
      <dc:title>
        <xsl:value-of select="$title"/>
      </dc:title>
      <sctap:articleType rdf:resource="http://scta.info/resource/{$type}"/>
      <sctap:shortId><xsl:value-of select="./name"/></sctap:shortId>
      <xsl:variable name="hasTranscriptionShortId" select="concat(./name, '/', ./transcriptions/transcription[@transcriptionDefault='true']/version[@versionDefault='true']/hash)"/>
      <xsl:for-each select="./isArticleOf">
        <sctap:isArticleOf rdf:resource="{.}"/>
      </xsl:for-each>
      <sctap:hasTranscription rdf:resource="http://scta.info/resource/{$hasTranscriptionShortId}"/>
      <sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$hasTranscriptionShortId}"/>
    </rdf:Description>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="transcription">
    <xsl:for-each select="//version">
    <xsl:variable name="url">
      <xsl:choose>
        <xsl:when test="not(contains(./url, 'http'))">
          <xsl:value-of select="concat('https://raw.githubusercontent.com/scta/scta-articles/master/articles/', ./url)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="./url"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="title" select="concat('Transcription of ', ./ancestor::manifestation[1]/title)"/>
    <xsl:variable name="articleName" select="./ancestor::manifestation[1]/name"/>
    <xsl:variable name="shortId" select="concat($articleName, '/', ./hash)"/>
    <rdf:Description rdf:about="http://scta.info/resource/{$shortId}">
      <rdf:type rdf:resource="http://scta.info/resource/transcription"/>
      <dc:title>
        <xsl:value-of select="$title"/>
      </dc:title>
      <sctap:transcriptionType rdf:resource="http://scta.info/resource/article"/>
      <sctap:shortId><xsl:value-of select="$shortId"/></sctap:shortId>
      <sctap:hasXML rdf:resource="{$url}"/>
      <sctap:hash><xsl:value-of select="./hash"/></sctap:hash>
      <sctap:isTranscriptionOf resource="http://scta.info/resource/{$articleName}"></sctap:isTranscriptionOf>
      <sctap:versionNo><xsl:value-of select="./versionNo/@n"/></sctap:versionNo>
      <sctap:versionLabel><xsl:value-of select="./versionNo"/></sctap:versionLabel>
      
      <xsl:if test="./@versionDefault='true'">
        <sctap:isVersionDefault>true</sctap:isVersionDefault>
      </xsl:if>
      <xsl:for-each select="preceding-sibling::version[1]">
        <sctap:hasSuccessor rdf:resource="http://scta.info/resource/{$articleName}/{./hash}"/>
      </xsl:for-each>
      <xsl:for-each select="following-sibling::version[1]">
        <sctap:hasPredecessor rdf:resource="http://scta.info/resource/{$articleName}/{./hash}"/>
      </xsl:for-each>
      <xsl:for-each select="preceding-sibling::version">
        <sctap:hasDescendant rdf:resource="http://scta.info/resource/{$articleName}/{./hash}"/>
      </xsl:for-each>
      <xsl:for-each select="following-sibling::version">
        <sctap:hasAncestor rdf:resource="http://scta.info/resource/{$articleName}/{./hash}"/>
      </xsl:for-each>
      <xsl:variable name="ordernumber"><xsl:number count="version"/></xsl:variable>
      <xsl:if test="$ordernumber eq '1'">
        <sctap:isHeadTranscription>true</sctap:isHeadTranscription>
      </xsl:if>
      <xsl:if test="./@reviewed='true'">
        <sctap:hasReview>true</sctap:hasReview>
      </xsl:if>
      <xsl:variable name="reverseOrderNumber" select="((count(./preceding-sibling::version) + count(./following-sibling::version)) + 2)  - $ordernumber"/>
      <sctap:versionOrderNumber><xsl:value-of select="format-number($reverseOrderNumber, '0000')"/></sctap:versionOrderNumber>
    </rdf:Description>
    </xsl:for-each>
  </xsl:template>
  
  
  
</xsl:stylesheet>
