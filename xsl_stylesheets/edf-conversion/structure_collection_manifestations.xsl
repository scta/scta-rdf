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
  
  <xsl:template name="structure_collection_manifestations">
    <xsl:param name="cid"/>
    <xsl:param name="author-uri"/>
    <!-- TODO: note if edf structured info the same ways sub divisions, 
      this template could be used for top level collections and specific top level scripts could be removed 
    for each would then change to /listofFileNames//div"
    -->
    <xsl:for-each select="/listofFileNames/div//div">
      <xsl:variable name="current-div" select="."/>
      <xsl:variable name="divid"><xsl:value-of select="./@id"/></xsl:variable>
      <xsl:variable name="title"><xsl:value-of select="./head"/></xsl:variable>
      <xsl:variable name="expressionType"><xsl:value-of select="./@type"/></xsl:variable>
      <xsl:variable name="expressionSubType"><xsl:value-of select="./@subtype"/></xsl:variable>
      <xsl:variable name="parentExpression"><xsl:value-of select="./parent::div/@id"/></xsl:variable>
      <xsl:variable name="divQuestionTitle"><xsl:value-of select="./questionTitle"/></xsl:variable>
      <xsl:variable name="current-div-level" select="count(ancestor::*)"/>
      <xsl:for-each select="/listofFileNames/header/hasWitnesses/witness">
        <xsl:variable name="wit-title"><xsl:value-of select="./title"/></xsl:variable>
        <xsl:variable name="wit-slug"><xsl:value-of select="./slug"/></xsl:variable>
        <xsl:variable name="wit-initial"><xsl:value-of select="./initial"/></xsl:variable>
        <xsl:variable name="wit-canvasbase"><xsl:value-of select="./canvasBase"/></xsl:variable>
        <!-- this variable could be replaced by a provided parameter whereever available transcriptions 
          per manifestation are listed -->
        <xsl:variable name="transcriptions">
          <transcriptions>
            <transcription name="transcription"/>
          </transcriptions>
        </xsl:variable>
        <xsl:variable name="canonical-transcription-name">transcription</xsl:variable>
        
        <xsl:if test="$current-div//item/hasWitnesses/witness/@ref = concat('#', $wit-initial)">
          <xsl:call-template name="structure_collection_manifestations_entry">
            <xsl:with-param name="author-uri" select="$author-uri"/>
            <xsl:with-param name="cid" select="$cid"/>
            <xsl:with-param name="current-div" select="$current-div"/>
            <xsl:with-param name="divid" select="$divid"/>
            <xsl:with-param name="title" select="$title"/>
            <xsl:with-param name="expressionType" select="$expressionType"/>
            <xsl:with-param name="expressionSubType" select="$expressionSubType"/>
            <xsl:with-param name="parentExpression" select="$parentExpression"/>
            <xsl:with-param name="divQuestionTitle" select="$divQuestionTitle"/>
            <xsl:with-param name="current-div-level" select="$current-div-level"/>
            <xsl:with-param name="wit-title" select="$wit-title"/>
            <xsl:with-param name="wit-slug" select="$wit-slug"/>
            <xsl:with-param name="wit-initial" select="$wit-initial"/>
            <xsl:with-param name="wit-canvasbase" select="$wit-canvasbase"/>
            <xsl:with-param name="transcriptions" select="$transcriptions"/>
            <xsl:with-param name="canonical-transcription-name" select="$canonical-transcription-name"/>
            
          </xsl:call-template>
        </xsl:if>
        <!-- a second call for a critical edition; again this would not be necessary if all manifestation were required to be declared in edf/projectdata file -->
        <xsl:call-template name="structure_collection_manifestations_entry">
          <xsl:with-param name="author-uri" select="$author-uri"/>
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="current-div" select="$current-div"/>
          <xsl:with-param name="divid" select="$divid"/>
          <xsl:with-param name="title" select="$title"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="expressionSubType" select="$expressionSubType"/>
          <xsl:with-param name="parentExpression" select="$parentExpression"/>
          <xsl:with-param name="divQuestionTitle" select="$divQuestionTitle"/>
          <xsl:with-param name="current-div-level" select="$current-div-level"/>
          <xsl:with-param name="wit-title">Critial Edition</xsl:with-param>
          <xsl:with-param name="wit-slug">critical</xsl:with-param>
          <xsl:with-param name="wit-initial">CE</xsl:with-param>
          <xsl:with-param name="wit-canvasbase"/>
          <xsl:with-param name="transcriptions" select="$transcriptions"/>
          <xsl:with-param name="canonical-transcription-name" select="$canonical-transcription-name"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="structure_collection_manifestations_entry">
    <xsl:param name="author-uri"/>
    <xsl:param name="cid"/>
    <xsl:param name="current-div"/>
    <xsl:param name="divid"/>
    <xsl:param name="title"/>
    <xsl:param name="expressionType"/>
    <xsl:param name="expressionSubType"/>
    <xsl:param name="parentExpression"/>
    <xsl:param name="divQuestionTitle"/>
    <xsl:param name="current-div-level" />
    <xsl:param name="wit-title"/>
    <xsl:param name="wit-slug"/>
    <xsl:param name="wit-initial"/>
    <xsl:param name="wit-canvasbase"/>
    <xsl:param name="transcriptions"/>
    <xsl:param name="canonical-transcription-name"/>
    <rdf:Description rdf:about="http://scta.info/resource/{$divid}/{$wit-slug}">
      <dc:title><xsl:value-of select="$wit-title"/></dc:title>
      <rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
      <role:AUT rdf:resource="{$author-uri}"/>
      <sctap:structureType rdf:resource="http://scta.info/resource/structureCollection"/>
      <sctap:level><xsl:value-of select="$current-div/count(ancestor::*)"/></sctap:level>
      <sctap:hasSlug><xsl:value-of select="$wit-slug"></xsl:value-of></sctap:hasSlug>
      <sctap:shortId><xsl:value-of select="concat($divid, '/', $wit-slug)"/></sctap:shortId>
      <sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$divid}"/>
      <xsl:for-each select="$transcriptions//transcription">
        <sctap:hasTranscription rdf:resource="http://scta.info/resource/{$divid}/{$wit-slug}/{./@name}"/>
      </xsl:for-each>
      <sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$divid}/{$wit-slug}/{$canonical-transcription-name}"/>
      
      <xsl:for-each select="$current-div/div">
        <xsl:variable name="newdivid"><xsl:value-of select="./@id"/></xsl:variable>
        <dcterms:hasPart rdf:resource="http://scta.info/resource/{$newdivid}/{$wit-slug}"/>
      </xsl:for-each>
      <!-- identify all direct children items -->
      <xsl:for-each select="$current-div/item">
        <xsl:variable name="direct-child"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
        <dcterms:hasPart rdf:resource="http://scta.info/resource/{$direct-child}/{$wit-slug}"/>
      </xsl:for-each>
      
      <xsl:choose>
        <!-- this condition is a temporary hack; when id=body is changed to id=commentaryid, this conditional will no longer be necessary -->
        <xsl:when test="$current-div-level eq 2">
          <dcterms:isPartOf rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
        </xsl:when>
        <xsl:otherwise>
          <dcterms:isPartOf rdf:resource="http://scta.info/resource/{$parentExpression}/{$wit-slug}"/>
        </xsl:otherwise>
        
      </xsl:choose>
      
      
      <!-- identify all resources with structureType=itemStructure -->
      
      <xsl:for-each select="$current-div//item">
        <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
        <sctap:hasStructureItem rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}"/>
      </xsl:for-each>
      
      <!-- create ldn inbox -->
      <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$divid}/{$wit-slug}"/>
    </rdf:Description>
    
    
  </xsl:template>
</xsl:stylesheet>