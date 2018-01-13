<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:sctar="http://scta.info/resource/" xmlns:sctap="http://scta.info/property/">
	
	<xsl:output method="xml" indent="yes"/>
	<xsl:param name="lbpworkname">gen</xsl:param>
	<xsl:variable name="bibleQuotesList">/Users/jcwitt/Projects/scta/scta-rdf/data/scta-quotations/bible_quotations.xml</xsl:variable>
	<xsl:template match="/">
		<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
			xmlns:tei="http://www.tei-c.org/ns/1.0"
			xmlns:sctap="http://scta.info/property/"
			xmlns:sctar="http://scta.info/resource/"
			xmlns:role="http://www.loc.gov/loc.terms/relators/" 
			xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
			xmlns:collex="http://www.collex.org/schema#" 
			xmlns:dcterms="http://purl.org/dc/terms/" 
			xmlns:dc="http://purl.org/dc/elements/1.1/"
			xmlns:owl="http://www.w3.org/2002/07/owl#">
			<xsl:for-each select="/XMLBIBLE/BIBLEBOOK[@lbp-name=$lbpworkname]//VERS">
				<xsl:call-template name="createQuotationEntry"/>
			</xsl:for-each>
		</rdf:RDF> 
	</xsl:template>
	
	<xsl:template name="createQuotationEntry">
		
		<xsl:variable name="workid" select="./ancestor::BIBLEBOOK/@lbp-name"/> <!-- should generate abbrev -->
		<xsl:variable name="worktitle" select="document(concat('/Users/jcwitt/Projects/scta/bible_text/nova-vulgata/', $lbpworkname, '.xml'))/romanliturgy/titulum"/> <!-- should generate title -->
		<xsl:variable name="chapterNumber" select="./ancestor::CHAPTER/@cnumber"/>
		<xsl:variable name="versenumber" select="./@vnumber"/>
		<xsl:variable name="verse" select="."/>
		<xsl:variable name="verseid" select="concat($workid, $chapterNumber, '_', $versenumber)"/>
		<xsl:for-each select="distinct-values(document($bibleQuotesList)//verse[@id=$verseid])">
			<rdf:Description rdf:about="http://scta.info/resource/{$verseid}">
				<rdf:type rdf:resource="http://scta.info/resource/quotation"/>
				<dc:title><xsl:value-of select="$verse"></xsl:value-of></dc:title>
				<sctap:quotation><xsl:value-of select="$verse"/></sctap:quotation>
				<sctap:citation><xsl:value-of select="$worktitle"/><xsl:text> </xsl:text><xsl:value-of select="$chapterNumber"/><xsl:text>:</xsl:text><xsl:value-of select="$versenumber"/></sctap:citation>
				<sctap:quotationType rdf:resource="http://scta.info/resource/biblical"/>
				<sctap:fromBiblicalBook rdf:resource="http://scta.info/resource/{$workid}"/>
				<sctap:fromBiblicalChapter><xsl:value-of select="$chapterNumber"/></sctap:fromBiblicalChapter>
				<sctap:fromBiblicalVerse><xsl:value-of select="$versenumber"/></sctap:fromBiblicalVerse>
				<!--<xsl:for-each select="collection(concat($commentary-rdf-home, '?select=[a-zA-Z0-9]*.rdf'))//sctap:isInstanceOf[@rdf:resource=concat('http://scta.info/resource/', $verseid)]">
					<xsl:variable name="itemid"><xsl:value-of select="./parent::rdf:Description/@rdf:about"/></xsl:variable>
					<sctap:hasInstance rdf:resource="{$itemid}"/>
				</xsl:for-each>-->
			  <sctap:source rdf:resource="{concat('http://scta.info/resource/bible-', $workid)}"></sctap:source>
			</rdf:Description>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="head">
		
	</xsl:template>
</xsl:stylesheet>