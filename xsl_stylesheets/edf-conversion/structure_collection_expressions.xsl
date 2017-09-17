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
  
  <xsl:template name="structure_collection_expressions">
    <xsl:param name="cid"/>
    <xsl:param name="author-uri"/>
    <!-- TODO: note if edf structured info the same ways sub divisions, 
      this template could be used for top level collections and specific top level scripts could be removed 
    for each would then change to /listofFileNames//div"
    -->
    <xsl:for-each select="/listofFileNames/div//div">
      <xsl:variable name="current-div" select="."/>
      <xsl:variable name="divid"><xsl:value-of select="./@id"/></xsl:variable>
      <xsl:variable name="title"><xsl:value-of select="./head"/></xsl:variable>
      <xsl:variable name="expressionType"><xsl:value-of select="./@type"/></xsl:variable>
      <xsl:variable name="expressionSubType"><xsl:value-of select="./@subtype"/></xsl:variable>
      <xsl:variable name="parentExpression"><xsl:value-of select="./parent::div/@id"/></xsl:variable>
      <xsl:variable name="divQuestionTitle"><xsl:value-of select="./questionTitle"/></xsl:variable>
      <xsl:variable name="current-div-level" select="count(ancestor::*)"/>
      <xsl:call-template name="structure_collection_expressions_entry">
        <xsl:with-param name="author-uri" select="$author-uri"/>
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="current-div" select="$current-div"/>
        <xsl:with-param name="divid" select="$divid"/>
        <xsl:with-param name="title" select="$title"/>
        <xsl:with-param name="expressionType" select="$expressionType"/>
        <xsl:with-param name="expressionSubType" select="$expressionSubType"/>
        <xsl:with-param name="parentExpression" select="$parentExpression"/>
        <xsl:with-param name="divQuestionTitle" select="$divQuestionTitle"/>
        <xsl:with-param name="current-div-level" select="$current-div-level"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="structure_collection_expressions_entry">
    <xsl:param name="author-uri"/>
    <xsl:param name="cid"/>
    <xsl:param name="current-div"/>
    <xsl:param name="divid"/>
    <xsl:param name="title"/>
    <xsl:param name="expressionType"/>
    <xsl:param name="expressionSubType"/>
    <xsl:param name="parentExpression"/>
    <xsl:param name="divQuestionTitle"/>
    <xsl:param name="current-div-level" />
    <rdf:Description rdf:about="http://scta.info/resource/{$divid}">
      
      <dc:title><xsl:value-of select="$title"></xsl:value-of></dc:title>
      <rdf:type rdf:resource="http://scta.info/resource/expression"/>
      <role:AUT rdf:resource="{$author-uri}"/>
      
      <sctap:questionTitle><xsl:value-of select="$divQuestionTitle"/></sctap:questionTitle>
      
      <!-- check if special expression type is given -->
      <xsl:choose>
        <xsl:when test="$expressionType">
          <sctap:expressionType rdf:resource="http://scta.info/resource/{$expressionType}"/>
        </xsl:when>
        <!-- if no special expression type is given default to generic division -->
        <xsl:otherwise>
          <sctap:expressionType rdf:resource="http://scta.info/resource/division"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- add expressionSubType as just another expressionType if there is one -->
      <xsl:if test="$expressionSubType">
        <sctap:expressionType rdf:resource="http://scta.info/resource/{$expressionSubType}"/>	
      </xsl:if>
      
      
      <sctap:structureType rdf:resource="http://scta.info/resource/structureCollection"/>
      <sctap:level><xsl:value-of select="$current-div-level"/></sctap:level>
      <sctap:shortId><xsl:value-of select="$divid"/></sctap:shortId>
      
      <!-- identify parent expression resource -->
      <xsl:choose>
        <!-- this condition is a temporary hack; when id=body is changed to id=commentaryid, this conditional will no longer be necessary -->
        <xsl:when test="$current-div-level eq 2">
          <dcterms:isPartOf rdf:resource="http://scta.info/resource/{$cid}"/>
        </xsl:when>
        <xsl:otherwise>
          <dcterms:isPartOf rdf:resource="http://scta.info/resource/{$parentExpression}"/>
        </xsl:otherwise>
      </xsl:choose>
      
      
      <!-- identify child expression part -->
      
      <xsl:for-each select="./div">
        <xsl:variable name="divid"><xsl:value-of select="./@id"/></xsl:variable>
        <dcterms:hasPart rdf:resource="http://scta.info/resource/{$divid}"/>
      </xsl:for-each>
      <xsl:for-each select="./item">
        <!-- TODO: ./fileName/@filestem should be removed and changed to @id when all items have ids and the fileName element is removed -->
        <xsl:variable name="direct-child-part"><xsl:value-of select="./fileName/@filestem"/></xsl:variable>
        <dcterms:hasPart rdf:resource="http://scta.info/resource/{$direct-child-part}"/>
      </xsl:for-each>
      
      <!-- TODO: decide if hasTopLevelExpression is necessary -->
      <sctap:isPartOfTopLevelExpression rdf:resource="http://scta.info/resource/{$cid}"/>
      
      <!-- get Order Number -->
      <xsl:variable name="totalnumber"><xsl:number count="div" level="any"/></xsl:variable>
      <xsl:variable name="sectionnumber"><xsl:number count="div"/></xsl:variable>
      <sctap:sectionOrderNumber><xsl:value-of select="format-number($sectionnumber, '0000')"/></sctap:sectionOrderNumber>
      <sctap:totalOrderNumber><xsl:value-of select="format-number($totalnumber, '0000')"/></sctap:totalOrderNumber>
      
      <!-- TODO: decide if dtsurn should be used 
          <xsl:variable name="divcount"><xsl:number count="div[not(@id='body')]" level="multiple" format="1"/></xsl:variable>
          <sctap:dtsurn><xsl:value-of select="concat($dtsurn, ':', $divcount)"/></sctap:dtsurn>
          -->      
      
      <!-- list manifestations of this div -->
      <xsl:for-each select="/listofFileNames/header/hasWitnesses/witness">
        <xsl:variable name="wit-slug"><xsl:value-of select="./slug"/></xsl:variable>
        <xsl:variable name="wit-initial"><xsl:value-of select="./initial"/></xsl:variable>
        <xsl:if test="$current-div//item/hasWitnesses/witness/@ref = concat('#', $wit-initial)">
          <sctap:hasManifestation rdf:resource="http://scta.info/resource/{$divid}/{$wit-slug}"/>
        </xsl:if>
      </xsl:for-each>
      <!--TODO list div manifestation for a critical editions; perhaps critical files should be listed at the top of the project file as well -->
      <sctap:hasManifestation rdf:resource="http://scta.info/resource/{$divid}/critical"/>
      
      
      <!-- list all items within this div -->
      <xsl:for-each select=".//item">
        <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
        <sctap:hasStructureItem rdf:resource="http://scta.info/resource/{$fs}"/>    
      </xsl:for-each>
      
      <!-- create ldn inbox -->
      <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$divid}"/>
    </rdf:Description>
    
  </xsl:template>
</xsl:stylesheet>