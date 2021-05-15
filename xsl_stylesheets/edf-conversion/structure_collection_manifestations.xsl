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
    <xsl:param name="manifestations"/>
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
      <xsl:for-each select="$manifestations//witness">
        <xsl:variable name="wit-title"><xsl:value-of select="./title"/></xsl:variable>
        <xsl:variable name="wit-slug"><xsl:value-of select="./slug"/></xsl:variable>
        <xsl:variable name="wit-initial"><xsl:value-of select="./initial"/></xsl:variable>
        <!-- this variable could be replaced by a provided parameter whereever available transcriptions 
          per manifestation are listed -->
        <xsl:variable name="transcriptions">
          <transcriptions>
            <transcription name="transcription" canonical="true"/>
          </transcriptions>
        </xsl:variable>
        
        <xsl:if test="$current-div//item/hasWitnesses/witness/@ref = concat('#', $wit-initial) or $wit-slug eq 'critical'">
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
            <xsl:with-param name="transcriptions" select="$transcriptions"/>
          </xsl:call-template>
        </xsl:if>
        <!--<!-\- a second call for a critical edition; again this would not be necessary if all manifestation were required to be declared in edf/projectdata file -\->
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
          <xsl:with-param name="transcriptions" select="$transcriptions"/>
        </xsl:call-template>-->
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
    <xsl:param name="transcriptions"/>
    <rdf:Description rdf:about="http://scta.info/resource/{$divid}/{$wit-slug}">
      <!-- BEGIN global properties -->
      <xsl:call-template name="global_properties">
        <xsl:with-param name="title"><xsl:value-of select="concat($title, ' ', $wit-title)"/></xsl:with-param>
        <xsl:with-param name="description"/>
        <xsl:with-param name="shortId" select="concat($divid, '/', $wit-slug)"/>
      </xsl:call-template>
      <!-- END global properties -->
      <!-- BEGIN manifestation properties -->
      <xsl:call-template name="manifestation_properties">
        <!--<xsl:with-param name="lang" select="$lang"/>-->
        <xsl:with-param name="topLevelShortId" select="concat($cid, '/', $wit-slug)"/>
        <xsl:with-param name="isManifestationOfShortId" select="$divid"/>
        <xsl:with-param name="shortId" select="concat($divid, '/', $wit-slug)"/>
        <xsl:with-param name="transcriptions" select="$transcriptions"/>
        <xsl:with-param name="structureType">structureCollection</xsl:with-param>
      </xsl:call-template>
      <!-- END manifstation properties -->
      <!-- BEGIN structure collection properties -->
      <xsl:call-template name="structure_collection_properties">
        <xsl:with-param name="level" select="$current-div/count(ancestor::*)"/>
        <xsl:with-param name="items" select="$current-div//item"/>
        <xsl:with-param name="itemFinisher" select="concat('/', $wit-slug)"/>
      </xsl:call-template>
      <!-- END structure collection properties -->
      
      <role:AUT rdf:resource="{$author-uri}"/>
      
      
      <sctap:hasSlug><xsl:value-of select="$wit-slug"></xsl:value-of></sctap:hasSlug>
      
      
      
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
      
    </rdf:Description>
    
    
  </xsl:template>
</xsl:stylesheet>