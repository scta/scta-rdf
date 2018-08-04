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
  
  <xsl:template name="structure_block_transcriptions">
    <xsl:param name="cid"/>
    <xsl:param name="author-uri"/>
    <xsl:param name="dtsurn"/>
    <xsl:param name="textfilesdir"/>
    <xsl:param name="gitRepoStyle"/>
    <xsl:param name="gitRepoBase"/>
    <xsl:param name="repo-path"/>
    
    <!-- item level params -->
    <xsl:param name="fs"/>
    <xsl:param name="title"/>
    <xsl:param name="item-level"/>
    <xsl:param name="extraction-file"/>
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
      
      <xsl:for-each select="$transcriptions/transcription[@transcriptionDefault='true']/version[@versionDefault='true']">
        <xsl:variable name="this-transcription" select="."/>
        <xsl:variable name="url" select="./url"/>
        <xsl:variable name="transcription-text-path" select="concat($repo-path, ./url)"/>
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
            <xsl:variable name="docWebLink">
              <xsl:choose>
                <xsl:when test="./@hash eq 'head' or not(./@hash)">
                  <xsl:choose>
                    <xsl:when test="$gitRepoStyle = 'toplevel'">
                      <xsl:value-of select="concat($gitRepoBase, lower-case($cid), '/raw/master/', $fs, '/', $url, '#', $pid)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="concat($gitRepoBase, lower-case($fs), '/raw/master/', $url, '#', $pid)"/>
                    </xsl:otherwise>	
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat('https://gateway.ipfs.io/ipfs/', ./@hash, '#' , $pid)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
          
          <xsl:call-template name="structure_block_transcriptions_entry">
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
            <!-- item manifestation level parmaters -->
            <xsl:with-param name="wit-slug" select="$wit-slug"/>
            <xsl:with-param name="wit-title" select="$wit-title"/>
            <!-- block level transcription params -->
            <xsl:with-param name="pid" select="$pid"/>
            <xsl:with-param name="pid_ref" select="$pid_ref"/>
            <!-- transcription params -->
            <xsl:with-param name="transcription-text-path" select="$transcription-text-path"/>
            <xsl:with-param name="transcription-name" select="$this-transcription/hash"/>
            <xsl:with-param name="transcription-type" select="$this-transcription/parent::transcription/type"/>
            <xsl:with-param name="docWebLink" select="$docWebLink"/>
            
            
          </xsl:call-template>
        </xsl:if>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="structure_block_transcriptions_entry">
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
    <!-- manifestation params -->
    <xsl:param name="wit-slug"/>
    <xsl:param name="wit-title"/>
    <!-- block level params -->
    <xsl:param name="pid"/>
    <xsl:param name="pid_ref"/>
    <!-- transcription params -->
    <xsl:param name="transcription-text-path"/>
    <xsl:param name="transcription-name"/>
    <xsl:param name="transcription-type"/>
    <xsl:param name="docWebLink"/>
    
    <rdf:Description rdf:about="http://scta.info/resource/{$pid}/{$wit-slug}/{$transcription-name}">
      <!-- BEGIN global properties -->
      <xsl:call-template name="global_properties">
        <xsl:with-param name="title">Paragraph <xsl:value-of select="concat($pid, '/', $wit-slug, '/', $transcription-name)"/></xsl:with-param>
        <xsl:with-param name="description"/>
        <xsl:with-param name="shortId" select="concat($pid, '/', $wit-slug, '/', $transcription-name)"/>
      </xsl:call-template>
      <!-- END global properties -->
      <!-- BEGIN transcription properties -->
      <xsl:call-template name="transcription_properties">
        <!--<xsl:with-param name="lang" select="$lang"/>-->
        <xsl:with-param name="topLevelShortId" select="concat($cid, '/', $wit-slug, '/', $transcription-name)"/>
        <xsl:with-param name="isTranscriptionOfShortId" select="concat($pid, '/', $wit-slug)"/>
        <xsl:with-param name="shortId" select="concat($pid, '/', $wit-slug, '/', $transcription-name)"/>
        <xsl:with-param name="structureType">structureBlock</xsl:with-param>
        <xsl:with-param name="transcription-type" select="$transcription-type"/>
        <xsl:with-param name="docWebLink" select="$docWebLink"/>
        <xsl:with-param name="ipfsHash" select="./@hash"/>
        <xsl:with-param name="hasSuccessor" select="./@hasSuccessor"/>
        <xsl:with-param name="transcription-text-path" select="$transcription-text-path"/>
      </xsl:call-template>
      <!-- END transcription properties -->
      
      <!-- BEGIN structure block properties -->
      <xsl:call-template name="structure_block_properties">
        <xsl:with-param name="isPartOfStructureItemShortId" select="concat($fs, '/', $wit-slug, '/', $transcription-name)"/>
        <xsl:with-param name="isPartOfShortId" select="concat($ParentId, '/', $wit-slug, '/', $transcription-name)"/>
      </xsl:call-template>
      <!-- END structure block properties -->
      
    </rdf:Description>
    
  </xsl:template>
  
</xsl:stylesheet>