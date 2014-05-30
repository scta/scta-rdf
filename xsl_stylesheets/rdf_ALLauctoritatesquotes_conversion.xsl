<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:scta-terms="http://scta.info/terms/" xmlns:scta-rel="http://scta.info/relations/">
    
    <xsl:output method="xml"/>
    <xsl:param name="metadatafile1">/Users/JCWitt/Desktop/scta/commentaries/pp-projectdata.rdf</xsl:param>
    <xsl:param name="metadatafile2">/Users/JCWitt/Desktop/scta/commentaries/aw-projectdata.rdf</xsl:param>
    
    
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
            <xsl:apply-templates/>
        </rdf:RDF>
    </xsl:template>
    
    <xsl:template match="div[@type='maintext']//item">         
        <xsl:variable name="id"><xsl:value-of select="./@xml:id"/></xsl:variable>
        <xsl:variable name="idhash"><xsl:value-of select="concat('#',./@xml:id)"/></xsl:variable>
            <rdf:Description rdf:about="http://scta.info/quotations/{$id}">
                <rdf:type rdf:resource="http://scta.info/quotation"/>
                <dc:title><xsl:value-of select="."></xsl:value-of></dc:title>
                <scta-terms:quotation><xsl:value-of select="."/></scta-terms:quotation>
                <scta-terms:citation><xsl:value-of select="//div[@type='footnotes']//item[@corresp=$idhash]"/></scta-terms:citation>
                <scta-terms:quotetype rdf:resource="http://scta.info/quotetypes/auctoritates"/>
                <!--<dcterms:isPartOf rdf:resource="http://scta.info/scta"/>-->
                <xsl:for-each select="collection('/Users/JCWitt/Desktop/scta/commentaries/?select=[a-zA-Z]*.rdf')//scta-rel:quotes[@rdf:resource=concat('http://scta.info/quotations/', $id)]">
                
                    <xsl:variable name="itemid"><xsl:value-of select="./parent::rdf:Description/@rdf:about"/></xsl:variable>
                    <scta-rel:quotedBy rdf:resource="{$itemid}"/>
                </xsl:for-each>
                
                
                    
                </rdf:Description>
    </xsl:template>
    
    <xsl:template match="teiHeader | note  | head | div[@type='footnotes']">
        
    </xsl:template>
</xsl:stylesheet>