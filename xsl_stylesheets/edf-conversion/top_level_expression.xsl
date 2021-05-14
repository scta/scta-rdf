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
  
  <xsl:template name="top_level_expression">
    <xsl:param name="commentaryname"/>
    <xsl:param name="cid"/>
    <xsl:param name="commentaryslug"/>
    <xsl:param name="author-uri"/>
    <xsl:param name="textfilesdir"/>
    <xsl:param name="parentWorkGroup"/>
    <xsl:param name="description"/>
    <xsl:param name="sponsors"/>
    <xsl:param name="dtsurn"/>
    <xsl:param name="manifestations"/>
    
    <xsl:variable name="expressionType">
      <xsl:choose>
        <xsl:when test="$parentWorkGroup eq 'http://scta.info/resource/deanima'">
          <sctap:expressionType rdf:resource="http://scta.info/resource/deanima-commentary"/>
        </xsl:when>
        <xsl:when test="$parentWorkGroup eq 'http://scta.info/resource/sententia'">
          <sctap:expressionType rdf:resource="http://scta.info/resource/sentences-commentary"/>
        </xsl:when>
        <xsl:otherwise>
          <sctap:expressionType rdf:resource="http://scta.info/resource/text"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <rdf:Description rdf:about="http://scta.info/resource/{$cid}">
      
      <!-- BEGIN global properties -->
        <xsl:call-template name="global_properties">
          <xsl:with-param name="title" select="$commentaryname"/>
          <xsl:with-param name="description" select="$description"/>
          <xsl:with-param name="shortId" select="$cid"/>
        </xsl:call-template>
      <!-- END global properties -->
      
      <!-- BEGIN expression properties -->
      <xsl:call-template name="expression_properties">
        <xsl:with-param name="expressionType" select="$expressionType"/>
        <xsl:with-param name="structureType">structureCollection</xsl:with-param>
        <xsl:with-param name="shortId" select="$cid"/>
        
      </xsl:call-template>
      
      <!-- TODO: this should be moved into expression properties template -->
        <xsl:for-each select="$manifestations//witness">
          <xsl:variable name="wit-slug"><xsl:value-of select="./slug"/></xsl:variable>
          <sctap:hasManifestation rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
          <xsl:if test="./@canonical='true'">
            <sctap:hasCanonicalManifestation rdf:resource="http://scta.info/resource/{$cid}/{$wit-slug}"/>
          </xsl:if>
        </xsl:for-each>
      <!-- END expression properties -->
      
      <!-- BEGIN structure collection properties -->
      <xsl:call-template name="structure_collection_properties">
        <xsl:with-param name="level">1</xsl:with-param>
        <xsl:with-param name="items" select="//div[@id='body']//item"/>
        <xsl:with-param name="itemFinisher" select="''"/>
      </xsl:call-template>
      <!-- END structure collection properties -->
    
      
    <!-- TODO: parent of expresion should be WORK, not WorkGroup -->
    <dcterms:isPartOf rdf:resource="{$parentWorkGroup}"/>
    <role:AUT rdf:resource="{$author-uri}"/>
   
    
    <sctap:slug><xsl:value-of select="$commentaryslug"/></sctap:slug>
    
    <xsl:if test="//header/rcsid">
      <sctap:rcsid><xsl:value-of select="//header/rcsid"/></sctap:rcsid>
      
    </xsl:if>
    <sctap:dtsurn><xsl:value-of select="$dtsurn"/></sctap:dtsurn>
    
    <!-- TODO: Project file headers should indicate expressionType; I'm hard coding to the SentencesCommentary for now;
    			but this means De Anima commentaries are going to be erroneously marked -->
    
      <!--Log any sponsors of this top level expression -->
    <xsl:for-each select="$sponsors//sponsor">
      <sctap:hasSponsor rdf:resource="http://scta.info/resource/{@id}"/>
    </xsl:for-each>
    
    <!-- log questionlist source, editor, and encoder -->
    <xsl:if test="/listofFileNames/header[1]/questionListSource[1]">
      <sctap:questionListSource><xsl:value-of select="/listofFileNames/header[1]/questionListSource[1]"/></sctap:questionListSource>
    </xsl:if>
    <xsl:if test="/listofFileNames/header[1]/questionListOriginalEditor[1]">
      <sctap:questionListEditor><xsl:value-of select="/listofFileNames/header[1]/questionListOriginalEditor[1]"/></sctap:questionListEditor>
    </xsl:if>
    <xsl:if test="/listofFileNames/header[1]/questionListEncoder[1]">
      <sctap:questionListEncoder><xsl:value-of select="/listofFileNames/header[1]/questionListEncoder[1]"/></sctap:questionListEncoder>
    </xsl:if>
    
    <!-- identify second level expression parts -->
      <xsl:for-each select="//div[@id='body']/div">
      <xsl:variable name="divid"><xsl:value-of select="./@id"/></xsl:variable>
      <dcterms:hasPart rdf:resource="http://scta.info/resource/{$divid}"/>
    </xsl:for-each>
    <xsl:for-each select="//div[@id='body']/item">
      <xsl:variable name="direct-child-part"><xsl:value-of select="./@id"/></xsl:variable>
      <dcterms:hasPart rdf:resource="http://scta.info/resource/{$direct-child-part}"/>
    </xsl:for-each>
    
    <!-- identify all resources with structureType=itemStructure -->
    
    <!--<xsl:for-each select=".//item">
      <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
      <sctap:hasStructureItem rdf:resource="http://scta.info/resource/{$fs}"/>
    </xsl:for-each>-->
    
  </rdf:Description>
  </xsl:template>
</xsl:stylesheet>