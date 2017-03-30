<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:dcterms="http://purl.org/dc/terms/" xmlns:sctar="http://scta.info/resource/"
	xmlns:sctap="http://scta.info/property/">

	
	<xsl:output method="xml" indent="yes"/>

	<xsl:variable name="commentary-rdf-home"
		>/Users/jcwitt/Projects/scta/scta-rdf/commentaries/</xsl:variable>

	<xsl:template match="/">
		<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
			xmlns:sctap="http://scta.info/property/" xmlns:sctar="http://scta.info/resource/"
			xmlns:role="http://www.loc.gov/loc.terms/relators/"
			xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
			xmlns:collex="http://www.collex.org/schema#" xmlns:dcterms="http://purl.org/dc/terms/"
			xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#">
			<xsl:apply-templates/>
		</rdf:RDF>
	</xsl:template>
	<xsl:template match="head">
		<xsl:variable name="codexid" select="./shortid"/>
		<rdf:Description rdf:about="http://scta.info/resource/{$codexid}">
			<rdf:type rdf:resource="http://scta.info/resource/codex"/>
			<dc:title>
				<xsl:value-of select="./title"/>
			</dc:title>
			<xsl:for-each select="./hasItems//item">
				<xsl:variable name="codex-item-id" select="./shortid"/>
				<sctap:hasCodexItem rdf:resource="http://scta.info/resource/{$codex-item-id}"/>
			</xsl:for-each>
			<xsl:for-each select="//surface">
				<xsl:variable name="surfaceid" select="./shortid"/>
				<sctap:hasSurface rdf:resource="http://scta.info/resource/{$surfaceid}"/>
			</xsl:for-each>
		</rdf:Description>
		<xsl:for-each select="./hasItems//item">
			<xsl:variable name="icodexid" select="./shortid"/>
			<xsl:variable name="official-manifest" select="./manifestOfficial"/>
			<rdf:Description rdf:about="http://scta.info/resource/{$icodexid}">
				<rdf:type rdf:resource="http://scta.info/resource/icodex"/>
				<sctap:hasOfficialManifest rdf:resource="{$official-manifest}"/>
			  <sctap:canvasPagedType><xsl:value-of select="./canvasPagedType"/></sctap:canvasPagedType>
				<sctap:isCodexItemOf rdf:resource="http://scta.info/resource/{$codexid}"/>
			</rdf:Description>
			
		</xsl:for-each>
	</xsl:template>
	
	
	<xsl:template match="surface">
		<xsl:variable name="surfaceid" select="./shortid"/>
		<xsl:variable name="order-number"><xsl:number count="//surface"/></xsl:variable>
		<rdf:Description rdf:about="http://scta.info/resource/{$surfaceid}">
			<rdf:type rdf:resource="http://scta.info/resource/surface"/>
			<dc:title>
				<xsl:value-of select="./label"/>
			</dc:title>
			
			<sctap:order><xsl:value-of select="format-number($order-number, '000')"/></sctap:order>
			<xsl:if test="./preceding-sibling::surface[1]">
				<sctap:previous rdf:resource="http://scta.info/resource/{./preceding-sibling::surface[1]/shortid}"/>	
			</xsl:if>
			<xsl:if test="./following-sibling::surface[1]">
				<sctap:next rdf:resource="http://scta.info/resource/{./following-sibling::surface[1]/shortid}"/>	
			</xsl:if>
			<xsl:for-each select="./hasISurfaces//ISurface">
				<xsl:variable name="isurfaceid" select="./shortid"/>
				<xsl:variable name="canvasslug" select="./canvasslug"/>
				<sctap:hasISurface rdf:resource="http://scta.info/resource/{$isurfaceid}"/>
			</xsl:for-each>
		</rdf:Description>
		<xsl:for-each select="./hasISurfaces//ISurface">
			<xsl:variable name="isurfaceid" select="./shortid"/>
			<!-- TODO canvasslug should be different the isurface shortid; both should be specified in the msdescription file -->
			<xsl:variable name="canvasslug" select="./canvasslug"/>
			<!-- TODO this needs to be changed; this will only work as long as there is only one canvasbase -->
			<xsl:variable name="canvasbase" select="//canvasBase"/>
			<rdf:Description rdf:about="http://scta.info/resource/{$isurfaceid}">
				<rdf:type rdf:resource="http://scta.info/resource/isurface"/>
				<xsl:variable name="canvasid" select="concat($canvasbase, $canvasslug)"/>
				<sctap:hasCanvas rdf:resource="{$canvasid}"/>
			</rdf:Description>

		</xsl:for-each>
	</xsl:template>

	<xsl:template match="tei:teiHeader | tei:note | tei:personGrp"/>
</xsl:stylesheet>
