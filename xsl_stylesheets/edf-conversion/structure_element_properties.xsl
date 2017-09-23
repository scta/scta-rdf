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
  
  <xsl:template name="structure_element_properties">
    <xsl:param name="isPartOfStructureBlockShortId"/>
    <xsl:param name="isPartOfShortId"/>
    <xsl:param name="elementType"/>
    <xsl:param name="elementText"/>
    
    <sctap:structureType rdf:resource="http://scta.info/resource/structureElement"/>
    <dcterms:isPartOf rdf:resource="http://scta.info/resource/{$isPartOfShortId}"/>
    <sctap:isPartOfStructureBlock rdf:resource="http://scta.info/resource/{$isPartOfStructureBlockShortId}"/>
    <sctap:structureElementType rdf:resource="http://scta.info/resource/{$elementType}"/>
    <sctap:structureElementText><xsl:value-of select="$elementText"/></sctap:structureElementText>
  </xsl:template>
  
</xsl:stylesheet>