<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:dcterms="http://purl.org/dc/terms/" xmlns:sctar="http://scta.info/resource/"
	xmlns:sctap="http://scta.info/property/">

	
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">
		<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
			xmlns:sctap="http://scta.info/property/" xmlns:sctar="http://scta.info/resource/"
			xmlns:role="http://www.loc.gov/loc.terms/relators/"
			xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
			xmlns:collex="http://www.collex.org/schema#" xmlns:dcterms="http://purl.org/dc/terms/"
			xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#">
			<xsl:call-template name="institution"/>
		</rdf:RDF>
	</xsl:template>
	<xsl:template name="institution">
	  <xsl:variable name="id" select="/institution/@id"/>
	  <xsl:variable name="title" select="/institution/title"/>
	  <xsl:variable name="city" select="/institution/city"/>
	  <xsl:variable name="country" select="/institution/country"/>
		<rdf:Description rdf:about="http://scta.info/resource/{$id}">
			<rdf:type rdf:resource="http://scta.info/resource/institution"/>
			<dc:title>
				<xsl:value-of select="$title"/>
			</dc:title>
	    <sctap:city><xsl:value-of select="$city"/></sctap:city>
	    <sctap:country><xsl:value-of select="$country"/></sctap:country>
		</rdf:Description>
	</xsl:template>

	<xsl:template match="tei:teiHeader | tei:note | tei:personGrp"/>
</xsl:stylesheet>
