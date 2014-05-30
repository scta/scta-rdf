<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:param name="author">Peter Plaoul</xsl:param>
    <xsl:param name="author-uri">http://jeffreycwitt.com/rdf/scta/names/peter-plaoul</xsl:param>
    <xsl:param name="parent-uri">http://jeffreycwitt.com/rdf/scta/plaoul.rdf</xsl:param>

    <xsl:output method="xml"/>
    <xsl:template match="//div[@id='body']">
        <xsl:result-document method="xml" href="/Users/JCWitt/Desktop/scta/plaoul.rdf">
            <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:role="http://www.loc.gov/loc.terms/relators/" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:collex="http://www.collex.org/schema#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/">
                <rdf:Description rdf:about="{$parent-uri}">
                <dc:title>Plaoul Commentary</dc:title>
                <dcterms:isPartOf rdf:resource="http://jeffreycwitt.com/rdf/scta/scta.rdf"/>
                <xsl:for-each select="./div/item">
                    <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
                    <dcterms:hasPart rdf:resource="http://jeffreycwitt.com/rdf/scta/{$fs}.rdf"/>
                </xsl:for-each>
                </rdf:Description>
            </rdf:RDF>
        </xsl:result-document>
        <xsl:for-each select="./div/item">
            <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
            <xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>
            <xsl:result-document method="xml" href="/Users/JCWitt/Desktop/scta/{$fs}.rdf">
                <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:role="http://www.loc.gov/loc.terms/relators/" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:scta="http://scta.org" xmlns:collex="http://www.collex.org/schema#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/">
                    <rdf:Description rdf:about="http://jeffreycwitt.com/rdf/scta/{$fs}.rdf">
                        <dc:title><xsl:value-of select="$title"></xsl:value-of></dc:title>
                        <role:AUT rdf:resource="{$author-uri}"/>
                        <dcterms:isPartOf rdf:resource="{$parent-uri}"/>
                        <xsl:for-each select="./hasParts/part">
                            <xsl:variable name="slug"><xsl:value-of select="./slug"/></xsl:variable>
                            <dcterms:hasPart rdf:resource="http://jeffreycwitt.com/rdf/scta/{$slug}_{$fs}.rdf"/>
                        </xsl:for-each>
                        <rdfs:seeAlso rdf:resource="http://petrusplaoul.org/text/textdisplay.php?fs={$fs}"/>
                        <xsl:variable name="text-path" select="concat('/Users/JCWitt/Documents/PlaoulProjectFiles/Textfiles/', $fs, '/', $fs, '.xml')"/>
                        <xsl:choose>
                        <xsl:when test="document($text-path)">
                            <xsl:for-each select="distinct-values(document($text-path)//tei:name/@ref)">
                                <xsl:variable name="nameID" select="substring-after(., '#')"></xsl:variable>
                                <scta:mentions rdf:resource="http://jeffreycwitt.com/rdf/scta/names/{$nameID}"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <p><xsl:value-of select="$text-path"/></p>
                        </xsl:otherwise>
                        </xsl:choose>
                    </rdf:Description>
                </rdf:RDF>
                <xsl:for-each select="hasParts/part">
                    <xsl:variable name="slug"><xsl:value-of select="./slug"/></xsl:variable>
                    <xsl:variable name="partOf"><xsl:value-of select="./preceding::fileName[1]/@filestem"></xsl:value-of></xsl:variable>
                    <xsl:variable name="partOfTitle"><xsl:value-of select="./preceding::title[1]"></xsl:value-of></xsl:variable>
                    <xsl:result-document method="xml" href="/Users/JCWitt/Desktop/scta/{$slug}_{$fs}.rdf">
                    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:role="http://www.loc.gov/loc.terms/relators/" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:scta="http://scta.org" xmlns:collex="http://www.collex.org/schema#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/">
                        <rdf:Description rdf:about="http://jeffreycwitt.com/rdf/scta/{$slug}_{$fs}.rdf">
                            <dc:title><xsl:value-of select="$partOfTitle"></xsl:value-of> [<xsl:value-of select="./title"/>]</dc:title>
                            <role:AUT rdf:resource="{$author-uri}"/>
                            <dcterms:isPartOf rdf:resource="http://jeffreycwitt.com/rdf/scta/{$partOf}"/>
                            <rdfs:seeAlso rdf:resource="http://petrusplaoul.org/text/textdisplay.php?fs={$fs}/ms={$slug}"/>
                        </rdf:Description>
                    </rdf:RDF>
                    </xsl:result-document>
                </xsl:for-each>
            
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template> 
    
    
</xsl:stylesheet>