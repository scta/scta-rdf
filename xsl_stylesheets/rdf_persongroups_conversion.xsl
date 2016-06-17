<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:sctar="http://scta.info/resource/" xmlns:sctap="http://scta.info/property/">
    
    <xsl:param name="workscitedrdf">/Users/JCWitt/Desktop/scta/works/workscited.rdf</xsl:param>
    <xsl:variable name="commentary-rdf-home">/Users/jcwitt/Projects/scta/scta-rdf/commentaries/</xsl:variable>
    
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
    
    <xsl:template match="tei:personGrp">         
        <xsl:variable name="id"><xsl:value-of select="./@xml:id"/></xsl:variable>
        <!-- ideally this would be resource/persongroup; but righ tnow the projectfile extraction doesn't have a way of separating names and groups names -->
            <rdf:Description rdf:about="http://scta.info/resource/{$id}">
                <rdf:type rdf:resource="http://scta.info/resource/persongroup"/>
                <dc:title><xsl:value-of select="./tei:persName"></xsl:value-of></dc:title>
                <!--<xsl:variable name="persongroup-type"><xsl:value-of select="./parent::tei:listPerson/@type"/></xsl:variable> -->
                <!--<sctar:type rdf:resource="http://scta.info/resource/persongrouptype/{$person-type}"/>-->
                <xsl:if test="./tei:note[@type='dbpedia-url']">
                    <xsl:variable name="dbpedia-url"><xsl:value-of select="./tei:note[@type='dbpedia-url']"/></xsl:variable>
                    <owl:sameAs rdf:resource="{$dbpedia-url}"/>
                </xsl:if>
                <!-- <xsl:for-each select="document($workscitedrdf)//sctap:workAuthor[@rdf:resource=concat('http://scta.info/resources/person/', $id)]">
                    <xsl:variable name="itemid"><xsl:value-of select="./parent::rdf:Description/@rdf:about"/></xsl:variable>
                    <sctap:hasWork rdf:resource="{$itemid}"/>
                </xsl:for-each> -->
                <!--<xsl:for-each select="collection(concat($commentary-rdf-home, '?select=[a-zA-Z]*.rdf'))//sctap:mentions[@rdf:resource=concat('http://scta.info/resource/', $id)]">
                    <xsl:variable name="itemid"><xsl:value-of select="./parent::rdf:Description/@rdf:about"/></xsl:variable>
                    <sctap:mentionedBy rdf:resource="{$itemid}"/>
                </xsl:for-each>-->
                
                </rdf:Description>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader | tei:note"/>
</xsl:stylesheet>