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
  
  <xsl:template name="structure_division_transcriptions">
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
      
      <xsl:for-each select="$transcriptions//transcription">
        <xsl:variable name="this-transcription" select="."/>
        <xsl:variable name="transcription-text-path" select="./@transcription-text-path"/>
        
        <xsl:for-each select="document($transcription-text-path)//tei:body/tei:div//tei:div">
          <!-- only creates division resource if that division has been assigned an id -->
        
          <xsl:if test="./@xml:id">
            <xsl:variable name="divisionId" select="./@xml:id"/>
            <xsl:variable name="divisionId_ref" select="concat('#', ./@xml:id)"/>
            
            <xsl:call-template name="structure_division_transcriptions_entry">
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
              <!-- div level params -->
              <xsl:with-param name="divisionId" select="$divisionId"/>
              <xsl:with-param name="divisionId_ref" select="$divisionId_ref"/>
              <!-- div level transcription params -->
              <xsl:with-param name="transcription-text-path" select="$transcription-text-path"/>
              <xsl:with-param name="transcription-name" select="$this-transcription/@name"/>
              <xsl:with-param name="transcription-type" select="$this-transcription/@type"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="structure_division_transcriptions_entry">
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
    <!-- div level params params -->
    <xsl:param name="divisionId"/>
    <xsl:param name="divisionId_ref"/>
    <!-- div level transcription params -->
    <!-- transcription params -->
    <xsl:param name="transcription-text-path"/>
    <xsl:param name="transcription-name"/>
    <xsl:param name="transcription-type"/>
    
      <rdf:Description rdf:about="http://scta.info/resource/{$divisionId}/{$wit-slug}/{$transcription-name}">
        <dc:title>Division <xsl:value-of select="$divisionId"/></dc:title>
        <rdf:type rdf:resource="http://scta.info/resource/transcription"/>
        <sctap:structureType rdf:resource="http://scta.info/resource/structureDivision"/>
        <sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$fs}/{$wit-slug}/{$transcription-name}"/>
        <sctap:isTranscriptionOf rdf:resource="http://scta.info/resource/{$divisionId}/{$wit-slug}"/>
        <!-- add transcription type -->
        <sctap:transcriptionType><xsl:value-of select="$transcription-type"/></sctap:transcriptionType>
        <sctap:plaintext rdf:resource="http://scta.lombardpress.org/text/plaintext/{$divisionId}/{$wit-slug}/{$transcription-name}"/>
        
        <xsl:for-each select="document($transcription-text-path)/tei:TEI/tei:facsimile//tei:zone[@start=$divisionId_ref]">
          <xsl:variable name="position" select="if (./@n) then ./@n else 1"/>
          <!-- TODO: simplifying name scheme for has Zone -->
          <sctap:hasZone rdf:resource="http://scta.info/text/{$cid}/zone/{$wit-slug}_{$fs}/division/{$divisionId}/{$position}"/>
        </xsl:for-each>
        
        <xsl:choose>
          <xsl:when test="$gitRepoStyle = 'toplevel'">
            <sctap:hasDocument rdf:resource="{$gitRepoBase}{lower-case($cid)}/raw/master/{$fs}/{tokenize($transcription-text-path, '/')[last()]}#{$divisionId}"/>
          </xsl:when>
          <xsl:otherwise>
            <sctap:hasDocument rdf:resource="{$gitRepoBase}{lower-case($fs)}/raw/master/{tokenize($transcription-text-path, '/')[last()]}#{$divisionId}"/>
          </xsl:otherwise>	
        </xsl:choose>
        
        <sctap:hasXML rdf:resource="http://exist.scta.info/exist/apps/scta-app/document/{$divisionId}/{$wit-slug}/{$transcription-name}"/>
        <sctap:shortId><xsl:value-of select="concat($divisionId, '/', $wit-slug, '/', 'transcription')"/></sctap:shortId>
        <sctap:isPartOfTopLevelTranscription rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}/{$transcription-name}"/>
        <!-- could add path to plain text version of paragraph -->
        
        
        <xsl:choose>
          <xsl:when test="document($transcription-text-path)//tei:revisionDesc/@status">
            <sctap:status><xsl:value-of select="document($text-path)//tei:revisionDesc/@status"></xsl:value-of></sctap:status>
          </xsl:when>
          <xsl:when test="document($transcription-text-path)">
            <sctap:status>In Progress</sctap:status>
          </xsl:when>
          <xsl:otherwise>
            <sctap:status>Not Started</sctap:status>
          </xsl:otherwise>
        </xsl:choose>
        <!-- end status Declaration block -->
        
        <!-- create ldn inbox -->
        <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$divisionId}/{$wit-slug}/{$transcription-name}"/>
      </rdf:Description>
    
    
    
  </xsl:template>
  
</xsl:stylesheet>