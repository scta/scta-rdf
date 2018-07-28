<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dcterms="http://purl.org/dc/terms/" xmlns:sctar="http://scta.info/resource/"
  xmlns:sctap="http://scta.info/property/" xmlns:rcs="http://rcs.philsem.unibas.ch/resource/">
  <xsl:output method="xml" indent="yes" xml:space="default"/>
  <xsl:template match="/">
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
      xmlns:sctap="http://scta.info/property/" xmlns:sctar="http://scta.info/resource/"
      xmlns:role="http://www.loc.gov/loc.terms/relators/"
      xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
      xmlns:collex="http://www.collex.org/schema#" xmlns:dcterms="http://purl.org/dc/terms/"
      xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#"
      xmlns:rcs="http://rcs.philsem.unibas.ch/resource/">
      <xsl:apply-templates/>
    </rdf:RDF>
  </xsl:template>
  <xsl:template match="article">
    <xsl:variable name="url">
      <xsl:choose>
        <xsl:when test="not(contains(./url, 'http'))">
          <xsl:value-of select="concat('https://raw.githubusercontent.com/scta/scta-articles/master/articles/', ./url)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="./url"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <rdf:Description rdf:about="http://scta.info/resource/{./name}">
      <rdf:type rdf:resource="http://scta.info/resource/article"/>
      <dc:title>
        <xsl:value-of select="./title"/>
      </dc:title>
      <sctap:articleType rdf:resource="http://scta.info/resource/{./type}"/>
      <sctap:shortId><xsl:value-of select="./name"/></sctap:shortId>
      <sctap:hasXML rdf:resource="{$url}"/>
      <sctap:hash><xsl:value-of select="./hash"/></sctap:hash>
      <xsl:if test="./hasSuccessor">
        <sctap:hasSuccessor rdf:resource="{./hasSuccessor}"/>
      </xsl:if>
      <xsl:for-each select="isArticleOf">
        <sctap:isArticleOf rdf:resource="{.}"/>
      </xsl:for-each>
    </rdf:Description>
  </xsl:template>
  <xsl:template match="tei:teiHeader | tei:note | tei:personGrp"/>
</xsl:stylesheet>
