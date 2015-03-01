<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:sctar="http://scta.info/resource/" xmlns:sctap="http://scta.info/property/" xmlns:functx="http://www.functx.com">
    <xsl:import href="file:/Users/JCWitt/Desktop/scta/xsl_stylesheets/functx-1.0-doc-2007-01.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="workid" select="/romanliturgy/@elibro"/>
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
            <xsl:for-each select="collection('/Users/JCWitt/Desktop/scta/biblequotelist/?select=[a-zA-Z]*.xml')//item">
                <xsl:call-template name="createQuotationEntry"/>
            </xsl:for-each>
        </rdf:RDF> 
    </xsl:template>
    
    <xsl:template name="createQuotationEntry">
        
        <xsl:variable name="workid" select="substring-after(./text(), 'http://scta.info/resource/quotation/')"/> 
        <xsl:value-of select="$workid"></xsl:value-of>
        <xsl:variable name="worktitle" select="functx:substring-before-match($workid, '[0-12]')"></xsl:variable>
        <xsl:variable name="chapterverse" select="functx:substring-after-match($workid, '[0-12]')"></xsl:variable>
        <xsl:variable name="chapter" select="substring-before($chapterverse, '_')"/>
        <xsl:variable name="verse" select="substring-after($chapterverse, '_')"/>
        <xsl:variable name="verseid" select="concat($workid, $chapter, '_', $verse)"/>
        <xsl:for-each select="distinct-values(collection('/Users/JCWitt/Desktop/scta/biblequotelist/?select=[a-zA-Z]*.xml')//item)">
            <rdf:Description rdf:about="http://scta.info/resource/quotation/{$verse}">
                <rdf:type rdf:resource="http://scta.info/resource/quotation"/> 
                <dc:title><xsl:value-of select="$verse"></xsl:value-of></dc:title>
                <sctap:quotation><xsl:value-of select="$verse"/></sctap:quotation>
                <sctap:citation><xsl:value-of select="$worktitle"/><xsl:text> </xsl:text><xsl:value-of select="$chapter"/>:<xsl:value-of select="$verse"/></sctap:citation>
                <sctap:quotationType rdf:resource="http://scta.info/resource/quoteType/biblical"/>
                <sctap:fromBiblicalBook rdf:resource="http://scta.info/resource/biblicalWork/{$workid}"/>
                <sctap:fromBiblicalChapter><xsl:value-of select="$chapter"/></sctap:fromBiblicalChapter>
                <sctap:fromBiblicalVerse><xsl:value-of select="$verse"/></sctap:fromBiblicalVerse>
                <xsl:for-each select="collection('/Users/JCWitt/Desktop/scta/commentaries/?select=[a-zA-Z]*.rdf')//sctap:quotes[@rdf:resource=concat('http://scta.info/resource/quotation/', $verseid)]">
                    <xsl:variable name="itemid"><xsl:value-of select="./parent::rdf:Description/@rdf:about"/></xsl:variable>
                    <sctap:quotedBy rdf:resource="{$itemid}"/>
                </xsl:for-each>
            
            </rdf:Description>
         </xsl:for-each>
    </xsl:template>
    <xsl:template match="head">
        
    </xsl:template>
</xsl:stylesheet>