<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:sctar="http://scta.info/resource/" xmlns:sctap="http://scta.info/property/">
    
<xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
            xmlns:sctap="http://scta.info/property/"
            xmlns:sctar="http://scta.info/resource/"
            xmlns:role="http://www.loc.gov/loc.terms/relators/" 
            xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
            xmlns:collex="http://www.collex.org/schema#" 
            xmlns:dcterms="http://purl.org/dc/terms/" 
            xmlns:dc="http://purl.org/dc/elements/1.1/"
            xmlns:owl="http://www.w3.org/2002/07/owl#">
        <xsl:apply-templates/>
        </rdf:RDF>
    </xsl:template>
    <xsl:template match="tei:category">
        <xsl:call-template name="category"/>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template name="category">
        <xsl:variable name="id"><xsl:value-of select="./@xml:id"/></xsl:variable>
        <!--<xsl:variable name="dbpedia-url"><xsl:value-of select="./tei:note[@type='dbpedia-url']"/></xsl:variable>-->
            <rdf:Description rdf:about="http://scta.info/resource/subject/{$id}">
                <rdf:type rdf:resource="http://scta.info/resource/subject"/>
                <dc:title><xsl:value-of select="./tei:catDesc"></xsl:value-of></dc:title>
                <!-- since subject identifications are going to be external to mark up this should run a separate set of files that match item ids to subjectids -->
                    <!-- <xsl:for-each select="collection('/Users/JCWitt/Desktop/scta/commentaries/?select=[a-zA-Z]*.rdf')//sctap:mentiones[@rdf:resource=concat('http://scta.info/resource/subject/', $id)]">
                        <xsl:variable name="itemid"><xsl:value-of select="./parent::rdf:Description/@rdf:about"/></xsl:variable>
                        <sctap:mentionedBy rdf:resource="{$itemid}"/>
                    </xsl:for-each> -->
                <xsl:choose> <!-- right now these presumes that subjects lists only allow one level deep of sub categories; that is it does not go beyond the first child level to grandchildren -->
                    <xsl:when test="./child::tei:category">
                        <xsl:for-each select="./child::tei:category">
                            <xsl:variable name="childid" select="./@xml:id"></xsl:variable>
                            <dcterms:hasPart rdf:resource="http://scta.info/resource/subject/{$childid}"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="./parent::tei:category">
                        <xsl:variable name="parentid" select="./parent::tei:category/@xml:id"></xsl:variable>
                        <dcterms:isPartOf rdf:resource="http://scta.info/resource/subject/{$parentid}"/>
                    </xsl:when>
                </xsl:choose>
            </rdf:Description>
    </xsl:template>
    <xsl:template match="tei:text | tei:note | tei:fileDesc | tei:catDesc"/>
</xsl:stylesheet>