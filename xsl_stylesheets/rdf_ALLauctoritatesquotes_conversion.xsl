<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:sctar="http://scta.info/resource/" xmlns:sctap="http://scta.info/property/">
    
    <xsl:output method="xml"/>
    <xsl:param name="metadatafile1">/Users/JCWitt/Desktop/scta/commentaries/pp-projectdata.rdf</xsl:param>
    <xsl:param name="metadatafile2">/Users/JCWitt/Desktop/scta/commentaries/aw-projectdata.rdf</xsl:param>
    
    
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
            <xsl:apply-templates/>
        </rdf:RDF>
    </xsl:template>
    
    <xsl:template match="div[@type='maintext']//item">         
        <xsl:variable name="id"><xsl:value-of select="./@xml:id"/></xsl:variable>
        <xsl:variable name="idhash"><xsl:value-of select="concat('#',./@xml:id)"/></xsl:variable>
            <rdf:Description rdf:about="http://scta.info/resource/quotation/{$id}">
                <rdf:type rdf:resource="http://scta.info/resource/quotation"/>
                <dc:title><xsl:value-of select="."></xsl:value-of></dc:title>
                <sctar:quotation><xsl:value-of select="."/></sctar:quotation>
                <sctar:citation><xsl:value-of select="//div[@type='footnotes']//item[@corresp=$idhash]"/></sctar:citation>
                <sctar:quotationSource rdf:resource="http://scta.info/quotationSource/auctoritates"/>
                <!--<dcterms:isPartOf rdf:resource="http://scta.info/scta"/>-->
                <xsl:for-each select="collection('/Users/JCWitt/Desktop/scta/commentaries/?select=[a-zA-Z]*.rdf')//sctap:quotes[@rdf:resource=concat('http://scta.info/resource/quotation/', $id)]">
                
                    <xsl:variable name="itemid"><xsl:value-of select="./parent::rdf:Description/@rdf:about"/></xsl:variable>
                    <sctap:quotedBy rdf:resource="{$itemid}"/>
                </xsl:for-each>
                
                
                    
                </rdf:Description>
    </xsl:template>
    
    <xsl:template match="teiHeader | note  | head | div[@type='footnotes']">
        
    </xsl:template>
</xsl:stylesheet>