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
              <xsl:value-of select="translate(concat('http://scta.info/resource/', $wit-slug, '/', ./preceding::tei:pb[1]/@n), '-', '')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="translate(concat('http://scta.info/resource/', $wit-slug, '/', translate(./preceding::tei:cb[1]/@n, 'ab', '')), '-', '')"/>
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
        <xsl:with-param name="title">Paragraph <xsl:value-of select="concat($pid, '/', $wit-slug)"/></xsl:with-param>
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
      <!-- create zone reference -->
      <xsl:for-each select="document($transcription-text-path)/tei:TEI/tei:facsimile//tei:zone[@start=$pid_ref]">
        <xsl:variable name="imagefilename" select="./preceding-sibling::tei:graphic/@url"/>
        <xsl:variable name="canvasname" select="substring-before($imagefilename, '.')"/>
        <!-- this is not a good way to do this; this whole section needs to be written -->
        <!-- right now I'm trying to just go the folio number without the preceding sigla -->
        <!-- not this will fail if there is Sigla that reads Ar15r; the first "r" will not be removed and the result will be r15r -->
        <xsl:variable name="folioname" select="translate($canvasname, 'ABCDEFGHIJKLMNOPQRSTUVabcdefghijklmnopqstuwxyz', '') "/>
        <!-- <xsl:variable name="foliosideurl" select="concat('http://scta.info/resource/material', $commentaryslug, '-', $wit-slug, '/', $folioname)"/> -->
        <!-- changed to... --> <!-- this will mess up anywhere were codex ids are identical such as "sorb" and "sorb" and "vat" and "vat" which I believe is only a problem with Wodeham and Plaoul -->
        <xsl:variable name="surfaceShortId" select="concat($wit-slug, '/', $folioname)"/>
        <xsl:variable name="foliosideurl" select="concat('http://scta.info/resource/', $wit-slug, '/', $folioname)"/>
        <xsl:variable name="pid" select="translate(./@start, '#', '')"/>
        <xsl:variable name="ulx" select="./@ulx"/>
        <xsl:variable name="uly" select="./@uly"/>
        <xsl:variable name="lrx" select="./@lrx"/>
        <xsl:variable name="lry" select="./@lry"/>
        <xsl:variable name="width"><xsl:value-of select="$lrx - $ulx"/></xsl:variable>
        <xsl:variable name="height"><xsl:value-of select="$lry - $uly"/></xsl:variable>
        <xsl:variable name="position" select="if (./@n) then ./@n else 1"/>
        <xsl:variable name="position" select="if (./@n) then ./@n else 1"/>
        
        <sctap:isOnZone rdf:resource="http://scta.info/resource/{$surfaceShortId}/{$ulx}{$uly}{$lrx}{$lry}"/>
      </xsl:for-each>
    </rdf:Description>
  </xsl:template>
</xsl:stylesheet>