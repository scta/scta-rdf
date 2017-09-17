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
  <!-- BEGIN create resources for any sponors of top level expression -->
  <xsl:template name="sponsors">
    <xsl:param name="sponsors"/>
    <xsl:for-each select="$sponsors//sponsor">
      <rdf:Description rdf:about="http://scta.info/resource/{@id}">
        <dc:title><xsl:value-of select="./name"/></dc:title>
        <rdf:type rdf:resource="http://scta.info/resource/sponsor"/>
        <sctap:link rdf:resource="{./link}"></sctap:link>
        <sctap:logo rdf:resource="{./logo}"></sctap:logo>
      </rdf:Description>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>