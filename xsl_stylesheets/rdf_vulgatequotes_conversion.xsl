<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:scta-terms="http://scta.info/terms/" xmlns:scta-rel="http://scta.info/relations/">
    
    <xsl:template match="/">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:scta-rel="http://scta.info/relations/"
            xmlns:scta-terms="http://scta.info/terms/"
            xmlns:role="http://www.loc.gov/loc.terms/relators/" 
            xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
            xmlns:collex="http://www.collex.org/schema#" 
            xmlns:dcterms="http://purl.org/dc/terms/" 
            xmlns:dc="http://purl.org/dc/elements/1.1/"
            xmlns:owl="http://www.w3.org/2002/07/owl#">
            <xsl:for-each select="collection('/Users/JCWitt/Documents/BibleQuotes/nova-vulgata/?select=[a-zA-Z]*.xml')//vers">
                <xsl:call-template name="createQuotationEntry"/>
            </xsl:for-each>
            <!-- use below for testing - much faster -->
            <!--<xsl:for-each select="document('/Users/JCWitt/Documents/BibleQuotes/nova-vulgata/mt.xml')//vers">
                <xsl:call-template name="createQuotationEntry"/>
            </xsl:for-each>-->
        </rdf:RDF> 
    </xsl:template>
    
    <xsl:template name="createQuotationEntry">
        
        <xsl:variable name="workid" select="/romanliturgy/@elibro"/> <!-- should generate abbrev -->
        <xsl:variable name="worktitle" select="/titulum"/> <!-- should generate title -->
        <xsl:variable name="chapterNumber" select="./ancestor::cap/@num"/>
        <xsl:variable name="versenumber" select="./@num"/>
        <xsl:variable name="verse" select="."/>
        <xsl:variable name="verseid" select="concat($workid, $chapterNumber, '_', $versenumber)"/>
        <xsl:for-each select="distinct-values(collection('/Users/JCWitt/Desktop/scta/commentaries/?select=[a-zA-Z]*.rdf')//scta-rel:quotes[@rdf:resource=concat('http://scta.info/quotations/', $verseid)])">
            <rdf:Description rdf:about="http://scta.info/quotations/{$verseid}">
                <rdf:type rdf:resource="http://scta.info/quotation"/>
                <dc:title><xsl:value-of select="$verse"></xsl:value-of></dc:title>
                <scta-terms:quotation><xsl:value-of select="$verse"/></scta-terms:quotation>
                <scta-terms:citation><xsl:value-of select="$verseid"/></scta-terms:citation>
                <scta-terms:quotetype rdf:resource="http://scta.info/quotetypes/biblical"/>
                <scta-terms:fromBiblicalBook rdf:resource="http://scta.info/works/{$workid}"/>
                <scta-terms:fromBiblicalChapter><xsl:value-of select="$chapterNumber"/></scta-terms:fromBiblicalChapter>
                <scta-terms:fromBiblicalVerse><xsl:value-of select="$versenumber"/></scta-terms:fromBiblicalVerse>
                <xsl:for-each select="collection('/Users/JCWitt/Desktop/scta/commentaries/?select=[a-zA-Z]*.rdf')//scta-rel:quotes[@rdf:resource=concat('http://scta.info/quotations/', $verseid)]">
                    <xsl:variable name="itemid"><xsl:value-of select="./parent::rdf:Description/@rdf:about"/></xsl:variable>
                    <scta-rel:quotedBy rdf:resource="{$itemid}"/>
                </xsl:for-each>
            
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="head">
        
    </xsl:template>
</xsl:stylesheet>