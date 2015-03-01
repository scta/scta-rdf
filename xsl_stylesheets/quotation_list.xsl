<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:sctar="http://scta.info/resource/" xmlns:sctap="http://scta.info/property/">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <xsl:variable name="workid" select="/romanliturgy/@elibro"/>
        
        <list>    
            <xsl:for-each select="document('/Users/JCWitt/Desktop/scta/commentaries/pp-projectdata.rdf')//rdf:Description[rdf:type[@rdf:resource='http://scta.info/resource/item']]//sctap:quotes">
                <xsl:variable name="resource" select="./@rdf:resource"></xsl:variable>
                <xsl:for-each select="distinct-values(document('/Users/JCWitt/Desktop/scta/commentaries/pl-projectdata.rdf')//rdf:Description[rdf:type[@rdf:resource='http://scta.info/resource/item']]//sctap:quotes)">
                    <item><xsl:value-of select="$resource"/></item>
                </xsl:for-each>
            </xsl:for-each>
        </list>
    </xsl:template>
    
    <xsl:template name="createQuotationEntry">
        
        
    </xsl:template>
    <xsl:template match="head">
        
    </xsl:template>
</xsl:stylesheet>