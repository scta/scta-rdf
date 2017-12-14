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
  
  <xsl:template name="marginal_note_manifestations">
    <xsl:param name="cid"/>
    <xsl:param name="manifestations"/>
    
    <xsl:for-each select="$manifestations//manifestation">
      <!-- required item level manifestation params -->
      <xsl:variable name="wit-slug" select="./@wit-slug"/>
      <xsl:variable name="wit-title" select="./@wit-title"/>
      <xsl:variable name="transcriptions" select="./transcriptions"/>
      <xsl:variable name="transcription-text-path" select="$transcriptions/transcription[@canonical='true']/@transcription-text-path"/>
      
      <xsl:for-each select="document($transcription-text-path)//tei:body//tei:note[@type='marginal-note']">
        <xsl:variable name="marginal-note-id">
          <xsl:choose>
            <xsl:when test="./@xml:id">
              <xsl:value-of select="./@xml:id"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('mn-', generate-id())"/>
            </xsl:otherwise>
          </xsl:choose> 
        </xsl:variable>
        <xsl:variable name="pid" select="./ancestor::tei:p[1]/@xml:id"/>
        
        <xsl:variable name="surface">
          <xsl:choose>
            <xsl:when test="document($transcription-text-path)//tei:pb">
              <xsl:value-of select="translate(concat('http://scta.info/resource/', $wit-slug, '/', ./preceding::tei:pb[1]/@n), '-', '')"/>
            </xsl:when>
            <!-- TODO: as all texts become compliant with lbp-1.0.0, this otherwise condition should become obsolete, as all texts will include pb elements -->
            <xsl:otherwise>
              <xsl:value-of select="translate(concat('http://scta.info/resource/', $wit-slug, '/', translate(./preceding::tei:cb[1]/@n, 'ab', '')), '-', '')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="marginal_note_manifestations_entry">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="wit-slug" select="$wit-slug"/>
          <xsl:with-param name="pid" select="$pid"/>
          <xsl:with-param name="marginal-note-id" select="$marginal-note-id"/>
          <xsl:with-param name="surface" select="$surface"/>
        </xsl:call-template>
        
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="marginal_note_manifestations_entry">
    <xsl:param name="cid"/>
    <xsl:param name="wit-slug"/>
    <!-- p level params -->
    <xsl:param name="pid"/>
    <xsl:param name="marginal-note-id"/>
    <xsl:param name="surface"/>
    
    <!-- create hasMarginalNote for parent block --> 
    <rdf:Description rdf:about="http://scta.info/resource/{$pid}/{$wit-slug}">
      <sctap:hasMarginalNote rdf:resource="http://scta.info/resource/{$marginal-note-id}"/>
    </rdf:Description>
    
    <!-- create hasMarginalNote assertion-->
    <rdf:Description rdf:about="http://scta.info/resource/{$marginal-note-id}">
      <dc:title>Marginal Note <xsl:value-of select="$marginal-note-id"/></dc:title>
      <!--TODO: confirm: marginalNote type, is kind of a sub classs of Manifestation, similar to the way Translation is a subclass of Manifestation -->
      <rdf:type rdf:resource="http://scta.info/resource/marginalNote"/> 
      <sctap:structureType rdf:resource="http://scta.info/resource/structureElement"/>
      <sctap:structureElementType rdf:resource="http://scta.info/resource/structureElementMarginalNote"/>
      <!-- marginal note is at the manifest level, so it the target of isPartOfStructureBlock should be the corresponding manifestation of the structureBlock in question -->
      <sctap:isPartOfStructureBlock rdf:resource="http://scta.info/resource/{$pid}/{$wit-slug}"/>
      <sctap:structureElementText><xsl:value-of select="."/></sctap:structureElementText>
      <sctap:isPartOfTopLevelManifestation rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
      <sctap:shortId><xsl:value-of select="$marginal-note-id"/></sctap:shortId>
      <!--<sctap:hasTranscription rdf:resource=""/>
       <sctap:hasCanonicalTranscription rdf:resource=""/> -->
      <sctap:hasSurface rdf:resource="{$surface}"/>
    </rdf:Description>
    
    
    
  </xsl:template>
</xsl:stylesheet>