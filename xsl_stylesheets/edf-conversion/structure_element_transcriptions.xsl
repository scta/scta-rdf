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
  
  <xsl:template name="structure_element_transcriptions">
    <xsl:param name="cid"/>
    <xsl:param name="manifestations"/>
    <xsl:param name="repo-path"/>
    <xsl:param name="fs"/>
    
    <xsl:for-each select="$manifestations//manifestation">
      <xsl:variable name="wit-slug" select="./@wit-slug"/>
      <xsl:variable name="wit-title" select="./@wit-title"/>
      <xsl:variable name="transcriptions" select="./transcriptions"/>
      <xsl:for-each select="$transcriptions//transcription/version[@versionDefault='true']">
        <xsl:variable name="this-transcription" select="."/>
        <xsl:variable name="url" select="./url"/>
        <xsl:variable name="transcription-text-path" select="concat($repo-path, ./url)"/>
        <!--<xsl:message>Test: <xsl:value-of select="$transcription-text-path"/></xsl:message>-->
        <xsl:for-each select="document($transcription-text-path)//tei:body//tei:quote[@xml:id] | 
          document($transcription-text-path)//tei:body//tei:ref[@xml:id]">
          <xsl:variable name="this-quote-id" select="./@xml:id"/>
          <xsl:variable name="pid" select="./ancestor::tei:p[1]/@xml:id"/>
          <!-- required item level manifestation params -->
          
          <xsl:variable name="lang" select="./@lang"/>
          
          <xsl:variable name="docWebLink">
            <xsl:choose>
              <xsl:when test="./@hash eq 'head' or not(./@hash)">
                <xsl:choose>
                  <xsl:when test="$gitRepoStyle = 'toplevel'">
                    <xsl:value-of select="concat($gitRepoBase, lower-case($cid), '/raw/master/', $fs, '/', $url, '#', $this-quote-id)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="concat($gitRepoBase, lower-case($fs), '/raw/master/', $url, '#', $this-quote-id)"/>
                  </xsl:otherwise>	
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('https://gateway.ipfs.io/ipfs/', ./@hash, '#' , $this-quote-id)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          
          
            <!-- get elementname and capitalize it -->
            <xsl:variable name="elementName">
              <xsl:value-of select="concat(
                translate(
                substring(./name(), 1, 1),
                'abcdefghijklmnopqrstuvwxyz',
                'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
                ),
                substring(./name(),2,string-length(./name())-1)
                )"/>
            </xsl:variable>
            <xsl:variable name="this-quote-id" select="./@xml:id"/>
            <xsl:variable name="pid" select="./ancestor::tei:p[1]/@xml:id"/>
            <xsl:call-template name="structure_element_transcriptions_entry">
              <xsl:with-param name="cid" select="$cid"/>
              <xsl:with-param name="wit-slug" select="$wit-slug"/>
              <xsl:with-param name="lang" select="$lang"/>
              <xsl:with-param name="pid" select="$pid"/>
              <xsl:with-param name="this-quote-id" select="$this-quote-id"/>
              <xsl:with-param name="elementName" select="$elementName"/>
              <!-- transcription params --> 
              <xsl:with-param name="transcription-text-path" select="$transcription-text-path"/>
              <xsl:with-param name="transcription-name" select="$this-transcription/hash"/>
              <xsl:with-param name="transcription-type" select="$this-transcription/parent::transcription/type"/>
              <xsl:with-param name="docWebLink" select="$docWebLink"/>
            </xsl:call-template>
            
          </xsl:for-each>
        </xsl:for-each>
      </xsl:for-each>
  </xsl:template>
  <xsl:template name="structure_element_transcriptions_entry">
    <xsl:param name="cid"/>
    <xsl:param name="wit-slug"/>
    <xsl:param name="lang"/>
    <xsl:param name="elementName"/>
    <!-- element level params -->
    <xsl:param name="pid"/>
    <xsl:param name="this-quote-id"/>
    <!-- transcription params -->
    <xsl:param name="transcription-text-path"/>
    <xsl:param name="transcription-name"/>
    <xsl:param name="transcription-type"/>
    <xsl:param name="docWebLink"/>
    <rdf:Description rdf:about="http://scta.info/resource/{$this-quote-id}/{$wit-slug}/{$transcription-name}">
      <!-- BEGIN global properties -->
      <xsl:call-template name="global_properties">
        <xsl:with-param name="title"><xsl:value-of select="$elementName"/> <xsl:value-of select="$this-quote-id"/>/<xsl:value-of select="$transcription-name"/></xsl:with-param>
        <xsl:with-param name="description"/>
        <xsl:with-param name="shortId" select="concat($this-quote-id, '/', $wit-slug, '/', $transcription-name)"/>
      </xsl:call-template>
      <!-- END global properties -->
      
      <!-- BEGIN transcription properties -->
      <xsl:call-template name="transcription_properties">
        <!--<xsl:with-param name="lang" select="$lang"/>-->
        <xsl:with-param name="topLevelShortId" select="concat($cid, '/', $wit-slug, '/', $transcription-name)"/>
        <xsl:with-param name="isTranscriptionOfShortId" select="concat($this-quote-id, '/', $wit-slug)"/>
        <xsl:with-param name="shortId" select="concat($this-quote-id, '/', $wit-slug, '/', $transcription-name)"/>
        <xsl:with-param name="structureType">structureElement</xsl:with-param>
        <xsl:with-param name="transcription-type" select="$transcription-type"/>
        <xsl:with-param name="docWebLink" select="$docWebLink"/>
        <!--<xsl:with-param name="ipfsHash" select="./@hash"/>
        <xsl:with-param name="hasSuccessor" select="./@hasSuccessor"/>-->
        <xsl:with-param name="transcription-text-path" select="$transcription-text-path"/>
      </xsl:call-template>
      <!-- END transcription properties -->
      <!-- BEGIN structure type properties -->
      <xsl:call-template name="structure_element_properties">
        <xsl:with-param name="isPartOfStructureBlockShortId" select="concat($pid, '/', $wit-slug, '/', $transcription-name)"/>
        <xsl:with-param name="isPartOfShortId" select="concat($pid, '/', $wit-slug, '/', $transcription-name)"/>
        <xsl:with-param name="elementType">structureElement<xsl:value-of select="$elementName"/></xsl:with-param>
        <!-- TODO: Delete, no need to add text here, manifestation already has representation
          and transcription should be pointing to data source
          <xsl:with-param name="elementText" select="."/>-->
      </xsl:call-template>
      <!-- END structure type properties -->
    </rdf:Description>
    
    
    
  </xsl:template>
</xsl:stylesheet>