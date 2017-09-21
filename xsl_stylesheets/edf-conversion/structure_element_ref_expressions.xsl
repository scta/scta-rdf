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
  
  
  
  <xsl:template name="structure_element_ref_expressions">
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
    <xsl:param name="expressionParentId"/>
    <xsl:param name="extraction-file"/>
    <xsl:param name="expressionType"/>
    <xsl:param name="sectionnumber"/>
    <xsl:param name="totalnumber"/>
    <xsl:param name="text-path"/>
    <xsl:param name="itemWitnesses"/>
    <xsl:param name="manifestations"/>
    <xsl:param name="translationManifestations"/>
    <xsl:param name="canonical-manifestation-id"/>
    
    <xsl:for-each select="document($extraction-file)//tei:body//tei:ref">
      <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
      <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
      <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
      <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
      <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-R-', $totalRefs - $totalFollowingRefs)"/>
      <xsl:variable name="paragraphParent" select=".//ancestor::tei:p/@xml:id"/>
      
      <xsl:call-template name="structure_element_ref_expressions_entry">
        <xsl:with-param name="fs" select="$fs"/>
        <xsl:with-param name="title" select="$title"/>
        <xsl:with-param name="item-level" select="$item-level"/>
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="expressionParentId" select="$expressionParentId"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
        <xsl:with-param name="extraction-file" select="$extraction-file"/>
        <xsl:with-param name="expressionType" select="if (./@type) then ./@type else 'reference'"/>
        <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
        <xsl:with-param name="totalnumber" select="$totalnumber"/>
        <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
        <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
        <xsl:with-param name="text-path" select="$text-path"/>
        <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
        <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
        <xsl:with-param name="manifestations" select="$manifestations"/>
        <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
        <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        
        <xsl:with-param name="quoteRef" select="$quoteRef"/>
        <xsl:with-param name="quoteID" select="$quoteID"/>
        <xsl:with-param name="totalRefs" select="$totalRefs"/>
        <xsl:with-param name="totalFollowingRefs" select="$totalFollowingRefs"></xsl:with-param>
        <xsl:with-param name="objectId" select="$objectId"/>
        <xsl:with-param name="paragraphParent" select="$paragraphParent"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="structure_element_ref_expressions_entry">
    <xsl:param name="fs"/>
    <xsl:param name="title"/>
    <xsl:param name="item-level"/>
    <xsl:param name="cid"/>
    <xsl:param name="expressionParentId"/>
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
    <xsl:param name="translationManifestations"/>
    <xsl:param name="canonical-manifestation-id"/>
    
    <xsl:param name="quoteRef"/>
    <xsl:param name="quoteID"/>
    <xsl:param name="totalRefs"/>
    <xsl:param name="totalFollowingRefs"></xsl:param>
    <xsl:param name="objectId"/>
    <xsl:param name="paragraphParent"/>
    
    
    
      <rdf:Description rdf:about="http://scta.info/resource/{$objectId}">
        <!-- BEGIN global properties -->
        <xsl:call-template name="global_properties">
          <xsl:with-param name="title">Structure Element <xsl:value-of select="$objectId"/></xsl:with-param>
          <xsl:with-param name="description"/>
          <xsl:with-param name="shortId" select="$objectId"/>
        </xsl:call-template>
        <!-- END global properties -->
        
<!-- BEGIN expression properties -->
        <xsl:call-template name="expression_properties">
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="structureType">structureElement</xsl:with-param>
          <xsl:with-param name="topLevelShortId" select="$cid"/>
          <xsl:with-param name="shortId" select="$objectId"/>
        </xsl:call-template>
<!-- END expression properties -->
<!-- BEGIN structure type properties -->
        <xsl:call-template name="structure_element_properties"/>
        <sctap:structureElementType rdf:resource="http://scta.info/resource/structureElementRef"/>
        <xsl:if test="$quoteRef">
          <sctap:isInstanceOf rdf:resource="http://scta.info/resource/{$quoteID}"/>
        </xsl:if>
        <sctap:structureElementText><xsl:value-of select="."/></sctap:structureElementText>
        <sctap:isPartOfStructureBlock rdf:resource="http://scta.info/resource/{$paragraphParent}"/>
<!-- END structure type properties -->
        
        
      </rdf:Description>
    
    
  </xsl:template>
  
</xsl:stylesheet>