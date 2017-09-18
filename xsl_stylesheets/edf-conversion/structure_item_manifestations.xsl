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
    <xsl:param name="transcriptions"/>
    <xsl:param name="surfaces"/>
    
    <rdf:Description rdf:about="http://scta.info/resource/{$fs}/{$wit-slug}">
      <dc:title><xsl:value-of select="$title"/> [<xsl:value-of select="$wit-title"/>]</dc:title>
      <role:AUT rdf:resource="{$author-uri}"/>
      <rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
      <sctap:structureType rdf:resource="http://scta.info/resource/structureItem"/>
      <sctap:isPartOfTopLevelManifestation rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
      <!-- TODO: conditional should eventually be removed -->
      <xsl:choose>
        <xsl:when test="$item-level eq 2">
          <dcterms:isPartOf rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
        </xsl:when>
        <xsl:otherwise>
          <dcterms:isPartOf rdf:resource="http://scta.info/resource/{$expressionParentId}/{$wit-slug}"/>	
        </xsl:otherwise>
      </xsl:choose>
      <sctap:shortId><xsl:value-of select="concat($fs, '/', $wit-slug)"/></sctap:shortId>
      <sctap:hasSlug><xsl:value-of select="$wit-slug"></xsl:value-of></sctap:hasSlug>
      <xsl:for-each select="$surfaces">
        <xsl:variable name="folionumber" select="./text()"/>
        <!-- TODO: change here could cause break in IIIF range creation; make adjustments and then remove this comment once everything is working again -->
        <xsl:variable name="foliosideurl" select="concat('http://scta.info/resource/', $wit-slug, '/', $folionumber)"/>
        <sctap:hasSurface rdf:resource="{$foliosideurl}"/>
        <!-- <xsl:choose>
                <xsl:when test="./@canvasslug">
                  <xsl:variable name="canvas-slug" select="./@canvasslug"></xsl:variable>
                  <xsl:variable name="canvasid" select="concat($canvasBase, $canvas-slug)"></xsl:variable>
                  <sctap:isOnCanvas rdf:resource="{$canvasid}"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:variable name="canvas-slug" select="concat($wit-initial, $folionumber)"></xsl:variable>
                  <sctap:isOnCanvas rdf:resource="http://scta.info/iiif/{$iiif-ms-name}/canvas/{$canvas-slug}"/>
                </xsl:otherwise>
              </xsl:choose> -->
      </xsl:for-each>
      
      <sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$fs}"/>
      
      <xsl:for-each select="$transcriptions//transcription">
        <xsl:if test="document(./@transcription-text-path)">
          <sctap:hasTranscription rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}/{./@name}"/>
          <xsl:if test="./@canonical eq 'true'">
            <sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}/{./@name}"/>
          </xsl:if>
        </xsl:if>
      </xsl:for-each>
      <!-- could include isPartOf to manuscript identifier
               could also inclue folio numbers if these are included in main project file -->
      
      <!-- create ldn inbox -->
      <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$fs}/{$wit-slug}"/>
    </rdf:Description>
    
  </xsl:template>
  
</xsl:stylesheet>