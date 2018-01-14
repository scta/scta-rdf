<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:sctar="http://scta.info/resource/" xmlns:sctap="http://scta.info/property/">
  
  
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="projectfileshome">/Users/jcwitt/Projects/scta/scta-projectfiles/</xsl:param>
	
  
  <xsl:template match="/">
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
      xmlns:sctap="http://scta.info/property/"
      xmlns:sctar="http://scta.info/resource/"
      xmlns:role="http://www.loc.gov/loc.terms/relators/" 
      xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
      xmlns:collex="http://www.collex.org/schema#" 
      xmlns:dcterms="http://purl.org/dc/terms/" 
      xmlns:dc="http://purl.org/dc/elements/1.1/"
      xmlns:owl="http://www.w3.org/2002/07/owl#">
      <xsl:for-each select="//workGroup">
      <xsl:call-template name="work-group"/>
      </xsl:for-each>
    </rdf:RDF>
  </xsl:template>
  
  <xsl:template name="work-group">
    <xsl:variable name="id" select="./@id"/>
    <xsl:variable name="title" select="./title"/>
    <xsl:variable name="description" select="./description"/>
    <xsl:variable name="parts" select="./workGroups//workGroup"/>
    <rdf:Description rdf:about="http://scta.info/resource/{$id}">
      <dc:title><xsl:value-of select="$title"/></dc:title>
      <dc:description><xsl:value-of select="$description"/></dc:description>
      <rdf:type rdf:resource="http://scta.info/resource/workGroup"/>
      <sctap:dtsurn>urn:dts:latinLit:<xsl:value-of select="$id"/></sctap:dtsurn>
      <sctap:shortId><xsl:value-of select="$id"/></sctap:shortId>
      <!--<sctap:projectfilesversion><xsl:value-of select="$projectfilesversion"/></sctap:projectfilesversion>-->
      <xsl:for-each select="$parts">
        <xsl:variable name="partid" select="./@id"/>
        <dcterms:hasPart rdf:resource="http://scta.info/resource/{$partid}"/>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($projectfileshome, '?select=[a-zA-Z0-9]*.xml'))//listofFileNames">
        <xsl:variable name="parentWorkGroup" select="./header[1]/parentWorkGroup[1]"/>
        <xsl:variable name="expression" select="./header[1]/commentaryid[1]"/>
        <xsl:variable name="fullurlid">http://scta.info/resource/<xsl:value-of select="$id"/></xsl:variable>
        <xsl:if test="$parentWorkGroup = $fullurlid">
          <dcterms:hasPart rdf:resource="http://scta.info/resource/{$expression}"/>
          <sctap:hasExpression rdf:resource="http://scta.info/resource/{$expression}"/>
        </xsl:if>
        <xsl:for-each select="$parts">
          <xsl:variable name="partfullurlid">http://scta.info/resource/<xsl:value-of select="./@id"/></xsl:variable>
          <xsl:if test="$partfullurlid = $parentWorkGroup">
            <sctap:hasExpression rdf:resource="http://scta.info/resource/{$expression}"/>
          </xsl:if>
          
        </xsl:for-each>
        
      </xsl:for-each>
    </rdf:Description>
  </xsl:template>
</xsl:stylesheet>