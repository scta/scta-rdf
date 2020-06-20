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
  
  <xsl:template name="structure_block_manifestations">
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
    <xsl:param name="extraction-file"/>
    <xsl:param name="repo-path"/>
    <xsl:param name="info-path"/>
    <xsl:param name="expressionType"/>
    <xsl:param name="sectionnumber"/>
    <xsl:param name="totalnumber"/>
    <xsl:param name="text-path"/>
    <xsl:param name="itemWitnesses"/>
    <xsl:param name="manifestations"/>
    <xsl:param name="canonical-manifestation-id"/>
    
    <xsl:for-each select="$manifestations//manifestation">
      <!-- only create block level manifestations if a transcription file has been started -->
      <xsl:if test="./transcriptions">
        <!-- required item level manifestation params -->
        <xsl:variable name="wit-slug" select="./@wit-slug"/>
        <xsl:variable name="wit-title" select="./@wit-title"/>
        <xsl:variable name="transcriptions" select="./transcriptions"/>
        <xsl:variable name="url" select="$transcriptions/transcription[@transcriptionDefault='true']/version[@versionDefault='true']/url"/>
        <xsl:variable name="transcription-text-path" select="concat($repo-path, $url)"/>
        <xsl:variable name="lang" select="./@lang"/>
        
        <xsl:for-each select="document($transcription-text-path)//tei:body//tei:p">
          <xsl:variable name="this-paragraph" select="."/>
          <!-- only creates paragraph resource if that paragraph has been assigned an id -->
          <xsl:if test="./@xml:id">
          <xsl:variable name="pid" select="./@xml:id"/>
          <xsl:variable name="pid_ref" select="concat('#', ./@xml:id)"/>
          <xsl:variable name="ParentId" select="./parent::tei:div/@xml:id"/>
          <!-- TODO: paragraph-surface is only getting one surface, but a paragraph can fall on more than one surface -->
          <xsl:variable name="paragraph-surface">
            <xsl:choose>
              <xsl:when test="document($transcription-text-path)//tei:pb">
                <xsl:value-of select="concat('http://scta.info/resource/', $wit-slug, '/', translate(./preceding::tei:pb[1]/@n, '-', ''))"/>
              </xsl:when>
              <xsl:otherwise>
                <!-- TODO: This is problematic; this is removing the "-" in IDs like "cod-dfdf"
                  it shouldn't be necessary when everything is 1.0.0 compliant 
                -->
                <xsl:value-of select="concat('http://scta.info/resource/', $wit-slug, '/', translate(translate(./preceding::tei:cb[1]/@n, 'ab', ''), '-', ''))"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
            
          
          
          <xsl:call-template name="structure_block_manifestations_entry">
            <xsl:with-param name="fs" select="$fs"/>
            <xsl:with-param name="title" select="$title"/>
            <xsl:with-param name="item-level" select="$item-level"/>
            <xsl:with-param name="cid" select="$cid"/>
            <xsl:with-param name="ParentId" select="$ParentId"/>
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
            <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
            <xsl:with-param name="transcription-text-path" select="$transcription-text-path"/>
            <!-- item manifestation level parmaters -->
            <xsl:with-param name="wit-slug" select="$wit-slug"/>
            <xsl:with-param name="wit-title" select="$wit-title"/>
            <xsl:with-param name="transcriptions" select="$transcriptions"/>
            <xsl:with-param name="paragraph-surface" select="$paragraph-surface"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="pid" select="$pid"/>
            <xsl:with-param name="pid_ref" select="$pid_ref"/>
           
          </xsl:call-template>
          </xsl:if>
        </xsl:for-each>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="structure_block_manifestations_entry">
    <xsl:param name="fs"/>
    <xsl:param name="title"/>
    <xsl:param name="item-level"/>
    <xsl:param name="cid"/>
    <xsl:param name="ParentId"/>
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
    <xsl:param name="canonical-manifestation-id"/>
    <xsl:param name="transcription-text-path"/>
    <!-- manifestation params -->
    <xsl:param name="wit-slug"/>
    <xsl:param name="wit-title"/>
    <xsl:param name="transcriptions"/>
    <xsl:param name="lang"/>
    <xsl:param name="paragraph-surface"/>
    <!-- p level params -->
    <xsl:param name="pid"/>
    <xsl:param name="pid_ref"/>
    
    
    
    <rdf:Description rdf:about="http://scta.info/resource/{$pid}/{$wit-slug}">
      <!-- BEGIN global properties -->
      <xsl:call-template name="global_properties">
        <xsl:with-param name="title">Resource <xsl:value-of select="$pid"/> in <xsl:value-of select="$wit-title"/></xsl:with-param>
        <xsl:with-param name="description"/>
        <xsl:with-param name="shortId" select="concat($pid, '/', $wit-slug)"/>
      </xsl:call-template>
      <!-- END global properties -->
      
      <!-- BEGIN manifestation properties -->
      <xsl:call-template name="manifestation_properties">
        <xsl:with-param name="lang" select="$lang"/>
        <xsl:with-param name="topLevelShortId" select="concat($cid, '/', $wit-slug)"/>
        <xsl:with-param name="isManifestationOfShortId" select="$pid"/>
        <xsl:with-param name="shortId" select="concat($pid, '/', $wit-slug)"/>
        <xsl:with-param name="transcriptions" select="$transcriptions"/>
        <xsl:with-param name="structureType">structureBlock</xsl:with-param>
      </xsl:call-template>
      <sctap:isOnSurface rdf:resource="{$paragraph-surface}"/>
      
      
      <!-- create hasStructureElement assertion -->
      <xsl:for-each select=".//tei:quote[@xml:id]">
        <xsl:variable name="this-quote-id" select="./@xml:id"/>
        <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$this-quote-id}/{$wit-slug}"/>
      </xsl:for-each>
      
      <!-- END manifestation properties -->
      
      <!-- BEGIN structure block properties -->
      <xsl:call-template name="structure_block_properties">
        <xsl:with-param name="isPartOfStructureItemShortId" select="concat($fs, '/', $wit-slug)"/>
        <xsl:with-param name="isPartOfShortId" select="concat($ParentId, '/', $wit-slug)"/>
      </xsl:call-template>
      <!-- END structure block properties -->
      
      <!-- Begin manifestation zone properties creation -->
      <!-- TODO: this is firing for every mannifestation including critical/born digital files which do not have line breaks or zones
        needs a switch to exclude certain manifestations based on manifestation type -->
      <xsl:call-template name="manifestation_zone_properties">
        <xsl:with-param name="wit-slug" select="$wit-slug"/>
      </xsl:call-template>
      
    </rdf:Description>
    
    <!-- BEGIN create zones containing lines as zones -->
    <!-- TODO: this is firing for every mannifestation including critical/born digital files which do not have line breaks or zones
        needs a switch to exclude certain manifestations based on manifestation type -->
    <xsl:call-template name="manifestation_zones">
      <xsl:with-param name="wit-slug" select="$wit-slug"/>
    </xsl:call-template>
    <!-- END create zones containing lines as zones -->
  </xsl:template>
  
  
</xsl:stylesheet>