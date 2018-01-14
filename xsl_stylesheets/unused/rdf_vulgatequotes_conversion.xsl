<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:sctar="http://scta.info/resource/" xmlns:sctap="http://scta.info/property/">
    
    <xsl:variable name="commentary-rdf-home"/>
    
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
            <!-- <xsl:for-each select="collection('/Users/JCWitt/Documents/BibleQuotes/nova-vulgata/?select=[a-zA-Z]*.xml')//vers">
                <xsl:call-template name="createQuotationEntry"/>
            </xsl:for-each> -->
            <!-- use below for testing - much faster -->
            <xsl:for-each select="document(concat('/Users/JCWitt/Documents/BibleQuotes/nova-vulgata/', $workid, '.xml'))//vers">
                <xsl:call-template name="createQuotationEntry"/>
            </xsl:for-each>
        </rdf:RDF> 
    </xsl:template>
    
    <xsl:template name="createQuotationEntry">
        
        <xsl:variable name="workid" select="/romanliturgy/@elibro"/> <!-- should generate abbrev -->
        <xsl:variable name="worktitle" select="/romanliturgy/titulum"/> <!-- should generate title -->
        <xsl:variable name="chapterNumber" select="./ancestor::cap/@num"/>
        <xsl:variable name="versenumber" select="./@num"/>
        <xsl:variable name="verse" select="."/>
        <xsl:variable name="verseid" select="concat($workid, $chapterNumber, '_', $versenumber)"/>
        <xsl:for-each select="distinct-values(collection(concat($commentary-rdf-home, '?select=[a-zA-Z0-9]*.rdf'))//isInstanceOf[@rdf:resource=concat('http://scta.info/resource/', $verseid)])">
        <!-- <xsl:for-each select="distinct-values(document('/Users/JCWitt/Desktop/scta/commentaries/pp-projectdata.rdf')//rdf:Description[rdf:type[@rdf:resource='http://scta.info/resource/item']]//sctap:quotes[@rdf:resource=concat('http://scta.info/resource/quotation/', $verseid)])"> -->
            <rdf:Description rdf:about="http://scta.info/resource/{$verseid}">
                <rdf:type rdf:resource="http://scta.info/resource/quotation"/> 
                <dc:title><xsl:value-of select="$verse"></xsl:value-of></dc:title>
                <sctap:quotation><xsl:value-of select="$verse"/></sctap:quotation>
                <sctap:citation><xsl:value-of select="$worktitle"/><xsl:text> </xsl:text><xsl:value-of select="$chapterNumber"/>:<xsl:value-of select="$versenumber"/></sctap:citation>
                <sctap:quotationType rdf:resource="http://scta.info/resource/biblical"/>
                <sctap:fromBiblicalBook rdf:resource="http://scta.info/resource/{$workid}"/>
                <sctap:fromBiblicalChapter><xsl:value-of select="$chapterNumber"/></sctap:fromBiblicalChapter>
                <sctap:fromBiblicalVerse><xsl:value-of select="$versenumber"/></sctap:fromBiblicalVerse>
                <xsl:for-each select="collection(concat($commentary-rdf-home, '?select=[a-zA-Z0-9]*.rdf'))//sctap:isInstanceOf[@rdf:resource=concat('http://scta.info/resource/', $verseid)]">
                    <xsl:variable name="itemid"><xsl:value-of select="./parent::rdf:Description/@rdf:about"/></xsl:variable>
                    <sctap:quotedBy rdf:resource="{$itemid}"/>
                </xsl:for-each>
            
            </rdf:Description>
         </xsl:for-each>
    </xsl:template>
    <xsl:template match="head">
        
    </xsl:template>
</xsl:stylesheet>