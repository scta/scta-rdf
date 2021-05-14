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
  
  
    <!--uncomment for tests to work--> 
    <!--<xsl:import href="global_properties.xsl"/>
    <xsl:import href="manifestation_properties.xsl"/>
    <xsl:import href="structure_collection_properties.xsl"/>-->
  
  <xsl:template name="top_level_manifestation">
    <xsl:param name="cid"/>
    <xsl:param name="author-uri"/>
    <xsl:param name="manifestations"/>
    
    <!--<xsl:for-each select="/listofFileNames/header/hasWitnesses/witness">-->
    <xsl:for-each select="$manifestations//witness">
      <xsl:variable name="wit-title"><xsl:value-of select="./title"/></xsl:variable>
      <xsl:variable name="wit-initial"><xsl:value-of select="./initial"/></xsl:variable>
      <xsl:variable name="wit-canvasbase"><xsl:value-of select="./canvasBase"/></xsl:variable>
      <xsl:variable name="wit-slug"><xsl:value-of select="./slug"/></xsl:variable>
      <xsl:variable name="editor"><xsl:value-of select="./editor"/></xsl:variable>
      <!-- TODO: this info probably needs to come from somewhere else; each manifestation will have different transcriptions and different number available -->
      <xsl:variable name="transcriptions">
        <transcriptions>
          <transcription name="transcription" canonical="true"/>
        </transcriptions>
      </xsl:variable>
      <!--<xsl:variable name="canonical-transcription-name">transcription</xsl:variable>-->
      <xsl:call-template name="top_level_manifestation_entry">
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
        <xsl:with-param name="wit-title" select="$wit-title"/>
        <xsl:with-param name="wit-initial" select="$wit-initial"/>
        <xsl:with-param name="wit-canvasbase" select="$wit-canvasbase"/>
        <xsl:with-param name="wit-slug" select="$wit-slug"/>
        <xsl:with-param name="editor" select="$editor"/>
        <xsl:with-param name="transcriptions" select="$transcriptions"/>
      </xsl:call-template>
    </xsl:for-each>
    <!-- if critical manifestations (and all manifestations were listed in edf/projectfile this second call we be unnecessary -->
    <!-- TODO: this info probably needs to come from somewhere else; each manifestation will have different transcriptions and different number available -->
    <!--<xsl:for-each select="$top-level-witnesses[1]">
    <xsl:variable name="transcriptions">
      <transcriptions>
        <transcription name="transcription" canonical="true"/>
      </transcriptions>
    </xsl:variable>
    <xsl:call-template name="top_level_manifestation_entry">
      <xsl:with-param name="cid" select="$cid"/>
      <xsl:with-param name="author-uri" select="$author-uri"/>
      <xsl:with-param name="wit-title">Critical Edition</xsl:with-param>
      <xsl:with-param name="wit-initial">CE</xsl:with-param>
      <xsl:with-param name="wit-canvasbase"></xsl:with-param>
      <xsl:with-param name="wit-slug">critical</xsl:with-param>
      <!-\-<xsl:with-param name="editor" select="$editor"/>-\->
      <xsl:with-param name="transcriptions" select="$transcriptions"/>
    </xsl:call-template>
    </xsl:for-each>-->
  </xsl:template>
  <xsl:template name="top_level_manifestation_entry">
    <xsl:param name="cid"/>
    <xsl:param name="author-uri"/>
    <xsl:param name="wit-title"/>
    <xsl:param name="wit-initial"/>
    <xsl:param name="wit-canvasbase"/>
    <xsl:param name="wit-slug"/>
    <xsl:param name="editor"/>
    <xsl:param name="transcriptions"/>
    <!--<xsl:param name="canonical-transcription-name"/>-->
    
    <rdf:Description rdf:about="http://scta.info/resource/{$cid}/{$wit-slug}">
      <!-- BEGIN global properties -->
      <xsl:call-template name="global_properties">
        <xsl:with-param name="title"><xsl:value-of select="$wit-title"/></xsl:with-param>
        <xsl:with-param name="description"/>
        <xsl:with-param name="shortId" select="concat($cid, '/', $wit-slug)"/>
      </xsl:call-template>
      <!-- END global properties -->
      
      <!-- BEGIN manifestation properties -->
      
      <xsl:call-template name="manifestation_properties">
        <!--<xsl:with-param name="lang" select="$lang"/>-->
        <xsl:with-param name="isManifestationOfShortId" select="$cid"/>
        <xsl:with-param name="shortId" select="concat($cid, '/', $wit-slug)"/>
        <xsl:with-param name="transcriptions" select="$transcriptions"/>
        <xsl:with-param name="structureType">structureCollection</xsl:with-param>
      </xsl:call-template>
      <!-- END manifstation properties -->
      <!-- BEGIN structure collection properties -->
      <xsl:call-template name="structure_collection_properties">
        <xsl:with-param name="level">1</xsl:with-param>
        <xsl:with-param name="items" select="//div[@id='body']//item"/>
        <xsl:with-param name="itemFinisher" select="concat('/', $wit-slug)"/>
      </xsl:call-template>
      <!-- END structure collection properties -->
      
      <!-- BEGIN role attribution -->
        <!-- TODO; candidate for depreciation; under role improvement; AUT becomes appropriate only for expressions 
          authors would be replaced by "editor" at the manifestation level" 
          TODO consider removing AUT after existing queries are checked to see if they rely on this property -->
        <role:AUT rdf:resource="{$author-uri}"/>
        <xsl:if test="$editor != ''">
          <sctap:editor rdf:resource="{$editor}"/>
        </xsl:if>
      <!-- END role attribution -->
      <sctap:hasSlug><xsl:value-of select="$wit-slug"></xsl:value-of></sctap:hasSlug>
      
      <xsl:if test="./manifestOfficial">
        <xsl:variable name="wit-manifestofficial"><xsl:value-of select="./manifestOfficial"/></xsl:variable>
        <sctap:manifestOfficial><xsl:value-of select="$wit-manifestofficial"></xsl:value-of></sctap:manifestOfficial>
      </xsl:if>
      
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
      
    </rdf:Description>
    
  </xsl:template>
  
</xsl:stylesheet>