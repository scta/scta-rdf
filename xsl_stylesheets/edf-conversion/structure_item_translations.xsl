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
  
  <xsl:template name="structure_item_translations">
    <xsl:param name="cid"/>
    <xsl:param name="author-uri"/>
    <xsl:param name="dtsurn"/>
    <xsl:param name="textfilesdir"/>
    <xsl:param name="gitRepoStyle"/>
    <xsl:param name="gitRepoBase"/>
    
    
    <!-- Begin create translation manifestation for structureType=structureItem -->
    <xsl:for-each select=".//item">
      <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
      <xsl:variable name="repo-path" select="concat($textfilesdir, $fs, '/')"/>
      <xsl:variable name="translationTranscriptions" select="document(concat($repo-path, 'transcriptions.xml'))//transcription[@type='translation']"/>
      <xsl:variable name="translationManifestations" select="document(concat($repo-path, 'transcriptions.xml'))/transcriptions/translationManifestations//manifestation"/>
      <xsl:for-each select="$translationManifestations">
        <xsl:variable name="trans-manifestation-slug" select="."/>
       <xsl:call-template name="structure_item_translations_entry">
         <xsl:with-param name="fs" select="$fs"/>
         <xsl:with-param name="trans-manifestation-slug" select="$trans-manifestation-slug"/>
         <xsl:with-param name="cid" select="$cid"/>
         <xsl:with-param name="translationTranscriptions" select="$translationTranscriptions"/>
       </xsl:call-template>
      </xsl:for-each>
    </xsl:for-each>
      
  </xsl:template>
  <xsl:template name="structure_item_translations_entry">
    <xsl:param name="fs"/>
    <xsl:param name="trans-manifestation-slug"/>
    <xsl:param name="cid"/>
    <xsl:param name="translationTranscriptions"/>
    <rdf:Description rdf:about="http://scta.info/resource/{$fs}/{$trans-manifestation-slug}">
      <dc:title> <xsl:value-of select="$fs"/> [translation]</dc:title>
      <dc:language><xsl:value-of select="./@language"/></dc:language>
      <rdf:type rdf:resource="http://scta.info/resource/translation"/>
      <sctap:structureType rdf:resource="http://scta.info/resource/structureItem"/>
      <sctap:isPartOfTopLevelManifestation rdf:resource="http://scta.info/resource/{$cid}/{$trans-manifestation-slug}"/>
      <sctap:shortId><xsl:value-of select="concat($fs, '/', $trans-manifestation-slug)"/></sctap:shortId>
      <sctap:isTranslationOf rdf:resource="http://scta.info/resource/{$fs}"/>
      
      <xsl:for-each select="$translationTranscriptions">
        <xsl:if test="./@canonical eq 'true'">
          <sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/{$fs}/{$trans-manifestation-slug}/{./@name}"/>
        </xsl:if>
        <xsl:if test="./@isTranslationOf eq $trans-manifestation-slug">
          <sctap:hasTranscription rdf:resource="http://scta.info/resource/{$fs}/{$trans-manifestation-slug}/{./@name}"/>
        </xsl:if>
      </xsl:for-each>
      <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$fs}/{.}"/>
    </rdf:Description>
  </xsl:template>
</xsl:stylesheet>