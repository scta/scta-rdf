<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:sctar="http://scta.info/resource/" xmlns:sctap="http://scta.info/property/">
    
<xsl:output method="xml"/>
    
    <!--<xsl:param name="commentary-rdf-home"/>-->
    
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
    
    <xsl:template match="tei:bibl">         
        <xsl:variable name="id"><xsl:value-of select="./@xml:id"/></xsl:variable>
        <!--<xsl:variable name="dbpedia-url"><xsl:value-of select="./tei:note[@type='dbpedia-url']"/></xsl:variable>-->
        <xsl:variable name="work-type"><xsl:value-of select="./parent::tei:listBibl/@type"/></xsl:variable>
            <rdf:Description rdf:about="http://scta.info/resource/{$id}">
                <rdf:type rdf:resource="http://scta.info/resource/work"/>
                <dc:title><xsl:value-of select="./tei:title"></xsl:value-of></dc:title>
                <sctap:workTitle><xsl:value-of select="./tei:title"></xsl:value-of></sctap:workTitle>
                <xsl:variable name="authorid" select="translate(./tei:author/@ref, '#', '')"></xsl:variable>
                <sctap:workAuthor rdf:resource="http://scta.info/resource/{$authorid}"/>
            	<sctap:workType rdf:resource="http://scta.info/resource/{lower-case($work-type)}"/>
                <!--<owl:sameAs rdf:resource="{$dbpedia-url}"/>-->
                <!--<xsl:for-each select="collection(concat($commentary-rdf-home, '?select=[a-zA-Z]*.rdf'))//sctap:isInstanceOf[@rdf:resource=concat('http://scta.info/resource/', $id)]">
                    <xsl:variable name="itemid"><xsl:value-of select="./parent::rdf:Description/@rdf:about"/></xsl:variable>
                    <sctap:hasInstance rdf:resource="{$itemid}"/>
                </xsl:for-each> -->
                <!--<xsl:for-each select="collection('/Users/JCWitt/Desktop/scta/quotations/?select=[a-zA-Z]*.rdf')//sctap:fromWork[@rdf:resource=concat('http://scta.info/resource/Work/', $id)]">
                    <xsl:variable name="itemid"><xsl:value-of select="./parent::rdf:Description/@rdf:about"/></xsl:variable>
                    <sctap:quotationUsed rdf:resource="{$itemid}"/>
                </xsl:for-each>-->
                <!--<xsl:for-each select="collection('/Users/JCWitt/Desktop/scta/quotations/?select=[a-zA-Z]*.rdf')//sctap:fromBiblicalBook[@rdf:resource=concat('http://scta.info/resource/work/', $id)]">
                    <xsl:variable name="itemid"><xsl:value-of select="./parent::rdf:Description/@rdf:about"/></xsl:variable>
                    <sctap:quotationUsed rdf:resource="{$itemid}"/>
                </xsl:for-each>-->
                </rdf:Description>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader | tei:note | tei:personGrp"/>
</xsl:stylesheet>