<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="2.0" 
  xmlns:utils="http://utility/functions"
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  
  <!-- location of text file for crawling -->
  <xsl:param name="textfilesbase">/Users/jcwitt/Projects/scta/scta-texts/</xsl:param>
  
  
  <xsl:variable name="commentaryname"><xsl:value-of select="//header/commentaryName"/></xsl:variable>
  <xsl:variable name="cid"><xsl:value-of select="//header/commentaryid"/></xsl:variable>
  <xsl:variable name="commentaryslug"><xsl:value-of select="//header/commentaryslug"/></xsl:variable>
  <xsl:variable name="author-uri"><xsl:value-of select="//header/authorUri"/></xsl:variable>
  <xsl:variable name="textfilesdir"><xsl:value-of select="$textfilesbase"/><xsl:value-of select="$cid"/>/</xsl:variable>
  
  <xsl:variable name="gitRepoBase">
    <xsl:choose>
      <xsl:when test="//header/gitRepoBase">
        <xsl:value-of select="//header/gitRepoBase"/>
      </xsl:when>
      <xsl:otherwise>https://bitbucket.org/jeffreycwitt/</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- git repo style records if there is a "toplevel" git repo for the entire work, or "single" for each item --> 
  <xsl:variable name="gitRepoStyle">
    <xsl:choose>
      <xsl:when test="//header/gitRepoBase/@type">
        <xsl:value-of select="//header/gitRepoBase/@type"/>
      </xsl:when>
      <xsl:otherwise>single</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="dtsurn"><xsl:value-of select="concat('urn:dts:latinLit:sentences', '.', $cid)"/></xsl:variable>
  
  <xsl:variable name="sponsors" select="//header/sponsors"/>
  <xsl:variable name="description" select="//header/description"/>
  <xsl:variable name="canoncial-top-level-manifestation" select="//header/canonical-top-level-manifestation"/>
  
  <xsl:variable name="parentWorkGroup">
    <xsl:choose>
      <xsl:when test="//header/parentWorkGroup">
        <xsl:value-of select="//header/parentWorkGroup"/>
      </xsl:when>
      <xsl:otherwise>http//scta.info/resource/sententia</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:include href="utility_functions.xsl"/>
  <xsl:output method="xml" indent="yes"/>
  
  <!-- root template -->
  <xsl:template match="/">
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
      xmlns:sctar="http://scta.info/resource/" 
      xmlns:sctap="http://scta.info/property/" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:role="http://www.loc.gov/loc.terms/relators/" 
      xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
      xmlns:collex="http://www.collex.org/schema#" 
      xmlns:dcterms="http://purl.org/dc/terms/" 
      xmlns:dc="http://purl.org/dc/elements/1.1/"
      xmlns:ldp="http://www.w3.org/ns/ldp#">
      <xsl:call-template name="top_level_expression">
        <xsl:with-param name="commentaryname" select="$commentaryname"/>
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="commentaryslug" select="$commentaryslug"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
        <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
        <xsl:with-param name="parentWorkGroup" select="$parentWorkGroup"/>
        <xsl:with-param name="description" select="$description"/>
        <xsl:with-param name="sponsors" select="$sponsors"/>
        <xsl:with-param name="canoncial-top-level-manifestation" select="$canoncial-top-level-manifestation"/>
      </xsl:call-template>
      <xsl:call-template name="top_level_manifestation">
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
      </xsl:call-template>
      <xsl:call-template name="top_level_transcription">
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
      </xsl:call-template>
      <xsl:call-template name="sponsors">
        <xsl:with-param name="sponsors" select="$sponsors"/>
      </xsl:call-template>
      <xsl:call-template name="structure_collection_expressions">
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
      </xsl:call-template>
      <xsl:call-template name="structure_collection_manifestations">
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
      </xsl:call-template>
      <xsl:call-template name="structure_item_expressions">
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
        <xsl:with-param name="dtsurn" select="$dtsurn"/>
        <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
        <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
        <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
      </xsl:call-template>
      <xsl:call-template name="structure_item_translations">
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
        <xsl:with-param name="dtsurn" select="$dtsurn"/>
        <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
        <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
        <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
      </xsl:call-template>
      <!--<xsl:apply-templates/>-->
    </rdf:RDF>
  </xsl:template>
  <xsl:include href="top_level_expression.xsl"/>
  <xsl:include href="top_level_manifestation.xsl"/>
  <xsl:include href="top_level_transcription.xsl"/>
  <xsl:include href="sponsors.xsl"/>
  <xsl:include href="structure_collection_expressions.xsl"/>
  <xsl:include href="structure_collection_manifestations.xsl"/>
  <xsl:include href="structure_item_expressions.xsl"/>
  <xsl:include href="structure_item_translations.xsl"/>
  
  
  
  
  <!-- templates to delete unwanted elements -->
  <!--<xsl:template match="header"></xsl:template>-->
  
  <!-- begin resource creation for top level expression -->  
  <!--<xsl:template match="//div[@id='body']">-->
    
  <!--</xsl:template>-->
</xsl:stylesheet>