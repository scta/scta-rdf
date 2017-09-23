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
  
  <xsl:template name="structure_item_manifestations">
    <xsl:param name="cid"/>
    <xsl:param name="author-uri"/>
    <xsl:param name="dtsurn"/>
    <xsl:param name="textfilesdir"/>
    <xsl:param name="gitRepoStyle"/>
    <xsl:param name="gitRepoBase"/>
    
    <!-- item level params -->
    <xsl:param name="fs"/>
    <xsl:param name="title"/>
    <xsl:param name="item-level"/>
    <xsl:param name="expressionParentId"/>
    <xsl:param name="extraction-file"/>
    <xsl:param name="info-path"/>
    <xsl:param name="expressionType"/>
    <xsl:param name="sectionnumber"/>
    <xsl:param name="totalnumber"/>
    <xsl:param name="text-path"/>
    <xsl:param name="itemWitnesses"/>
    <xsl:param name="manifestations"/>
    <xsl:param name="translationManifestations"/>
    <xsl:param name="canonical-manifestation-id"/>
    
    <xsl:for-each select="$manifestations//manifestation">
      <!-- required item level manifestation params -->
      <xsl:variable name="wit-slug" select="./@wit-slug"/>
      <xsl:variable name="wit-title" select="./@wit-title"/>
      <xsl:variable name="lang" select="./@lang"/>
      <xsl:variable name="transcriptions" select="./transcriptions"/>
      <xsl:variable name="surfaces" select=".//folio"/>
    
      <xsl:call-template name="structure_item_manifestations_entry">
        <xsl:with-param name="fs" select="$fs"/>
        <xsl:with-param name="title" select="$title"/>
        <xsl:with-param name="item-level" select="$item-level"/>
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="expressionParentId" select="$expressionParentId"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
        <xsl:with-param name="extraction-file" select="$extraction-file"/>
        <xsl:with-param name="expressionType" select="$expressionType"/>
        <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
        <xsl:with-param name="totalnumber" select="$totalnumber"/>
        <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
        <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
        <xsl:with-param name="text-path" select="$text-path"/>
        <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
        <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
        <xsl:with-param name="manifestations" select="$manifestations"/>
        <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
        <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        <xsl:with-param name="lang" select="$lang"/>
        <!-- item manifestation level parmaters -->
        <xsl:with-param name="wit-slug" select="$wit-slug"/>
        <xsl:with-param name="wit-title" select="$wit-title"/>
        <xsl:with-param name="transcriptions" select="$transcriptions"/>
        <xsl:with-param name="surfaces" select="$surfaces"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="structure_item_manifestations_entry">
    <xsl:param name="fs"/>
    <xsl:param name="title"/>
    <xsl:param name="item-level"/>
    <xsl:param name="cid"/>
    <xsl:param name="expressionParentId"/>
    <xsl:param name="author-uri"/>
    <xsl:param name="extraction-file"/>
    <xsl:param name="expressionType"/>
    <xsl:param name="sectionnumber"/>
    <xsl:param name="totalnumber"/>
    <xsl:param name="gitRepoStyle"/>
    <xsl:param name="gitRepoBase"/>
    <xsl:param name="text-path"/>
    <xsl:param name="itemWitnesses"/>
    <xsl:param name="textfilesdir"/>
    <xsl:param name="manifestations"/>
    <xsl:param name="translationManifestations"/>
    <xsl:param name="canonical-manifestation-id"/>
    <!-- manifestation params -->
    <xsl:param name="wit-slug"/>
    <xsl:param name="wit-title"/>
    <xsl:param name="lang"/>
    <xsl:param name="transcriptions"/>
    <xsl:param name="surfaces"/>
    
    <rdf:Description rdf:about="http://scta.info/resource/{$fs}/{$wit-slug}">
      <!-- BEGIN global properties -->
      <xsl:call-template name="global_properties">
        <xsl:with-param name="title"><xsl:value-of select="$title"/> [<xsl:value-of select="$wit-title"/>]</xsl:with-param>
        <xsl:with-param name="description"/>
        <xsl:with-param name="shortId" select="concat($fs, '/', $wit-slug)"/>
      </xsl:call-template>
      <!-- END global properties -->
      
      <!-- BEGIN manifestation properties -->
      <xsl:call-template name="manifestation_properties">
        <xsl:with-param name="lang" select="$lang"/>
        <xsl:with-param name="topLevelShortId" select="concat($cid, '/', $wit-slug)"/>
        <xsl:with-param name="isManifestationOfShortId" select="$fs"/>
        <xsl:with-param name="shortId" select="concat($fs, '/', $wit-slug)"/>
        <xsl:with-param name="transcriptions" select="$transcriptions"/>
        <xsl:with-param name="structureType">structureItem</xsl:with-param>
      </xsl:call-template>
      <sctap:hasSlug><xsl:value-of select="$wit-slug"></xsl:value-of></sctap:hasSlug>
      <xsl:for-each select="$surfaces">
        <xsl:variable name="folionumber" select="./text()"/>
        <!-- TODO: change here could cause break in IIIF range creation; make adjustments and then remove this comment once everything is working again -->
        <xsl:variable name="foliosideurl" select="concat('http://scta.info/resource/', $wit-slug, '/', $folionumber)"/>
        <sctap:hasSurface rdf:resource="{$foliosideurl}"/>
      </xsl:for-each>
      <!-- END manifestation properties -->
      
      <!-- BEGIN structure item properties -->
      <xsl:call-template name="structure_item_properties">
        <xsl:with-param name="level" select="$item-level"></xsl:with-param>
        <xsl:with-param name="blocks" select="document($extraction-file)//tei:body//tei:p"/>
        <xsl:with-param name="blockFinisher" select="concat('/', $wit-slug)"/>
      </xsl:call-template>
      <!-- END structure item properties -->
      
      
      <role:AUT rdf:resource="{$author-uri}"/>
      
      <!-- TODO: conditional should eventually be removed -->
      <xsl:choose>
        <xsl:when test="$item-level eq 2">
          <dcterms:isPartOf rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
        </xsl:when>
        <xsl:otherwise>
          <dcterms:isPartOf rdf:resource="http://scta.info/resource/{$expressionParentId}/{$wit-slug}"/>	
        </xsl:otherwise>
      </xsl:choose>
    </rdf:Description>
    
  </xsl:template>
  
</xsl:stylesheet>