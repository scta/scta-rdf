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
  
  <xsl:template name="global_properties">
    <xsl:param name="title"/>
    <xsl:param name="description"/>
    <xsl:param name="shortId"/>
    
    <dc:title><xsl:value-of select="$title"/></dc:title>
    <xsl:if test="$description">
      <dc:description><xsl:value-of select="$description"/></dc:description>
    </xsl:if>
    <sctap:shortId><xsl:value-of select="$shortId"/></sctap:shortId>
    <!-- create ldn inbox -->
    <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$shortId}"/>
      
    
      
  </xsl:template>
  
</xsl:stylesheet>