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
  
  <xsl:template name="structure_division_manifestations">
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
      <xsl:variable name="transcription-text-path" select="$transcriptions/transcription[@canonical='true']/@transcription-text-path"/>
      
      <xsl:for-each select="document($transcription-text-path)//tei:body/tei:div//tei:div">
        <!-- only creates division resource if that division has been assigned an id -->
        <xsl:if test="./@xml:id">
          <xsl:variable name="divisionId" select="./@xml:id"/>
          <xsl:variable name="divisionId_ref" select="concat('#', ./@xml:id)"/>
      
          <xsl:call-template name="structure_division_manifestations_entry">
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
            <!-- div level params -->
            <xsl:with-param name="divisionId" select="$divisionId"/>
            <xsl:with-param name="divisionId_ref" select="$divisionId_ref"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="structure_division_manifestations_entry">
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
    <!-- div level params -->
    <xsl:param name="divisionId"/>
    <xsl:param name="divisionId_ref"/>
    
    <rdf:Description rdf:about="http://scta.info/resource/{$divisionId}/{$wit-slug}">
      <dc:title>Division <xsl:value-of select="$divisionId"/></dc:title>
      
      <sctap:structureType rdf:resource="http://scta.info/resource/structureDivision"/>
      <sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}"/>
      <sctap:shortId><xsl:value-of select="concat($divisionId, '/', $wit-slug)"/></sctap:shortId>
      
      <xsl:choose>
        <xsl:when test="./@type='translation'">
          <rdf:type rdf:resource="http://scta.info/resource/translation"/>
          <sctap:isPartOfTopLevelTranslationn rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
          <sctap:isTranslationOf rdf:resource="http://scta.info/resource/{$divisionId}"/>
        </xsl:when>
        <xsl:otherwise>
          <rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
          <sctap:isPartOfTopLevelManifestation rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
          <sctap:isManifestationOf rdf:resource="http://scta.info/resource/{$divisionId}"/>
        </xsl:otherwise>
      </xsl:choose>
      
      <xsl:for-each select="$transcriptions//transcription">
        <xsl:if test="document(./@transcription-text-path)">
          <sctap:hasTranscription rdf:resource="http://scta.info/resource/{$divisionId}/{$wit-slug}/{./@name}"/>
          <xsl:if test="./@canonical eq 'true'">
            <sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$divisionId}/{$wit-slug}/{./@name}"/>
          </xsl:if>
        </xsl:if>
      </xsl:for-each>
      <!-- create ldn inbox -->
      <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$divisionId}/{$wit-slug}"/>
    </rdf:Description>
  </xsl:template>
</xsl:stylesheet>