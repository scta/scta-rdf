<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:sctar="http://scta.info/resource/" xmlns:sctap="http://scta.info/property/">
    <xsl:output method="xml" indent="yes"/>
    
    <!--<xsl:param name="commentary-rdf-home"/>-->
    
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
            <xsl:for-each select="//item">
                <xsl:choose>
                  <!-- if there is a text in the quote element then we are making a quote entry; if there is no text then we are making a passage entry -->
                    <xsl:when test="./quote/text()">
                        <xsl:call-template name="createQuotationEntry"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="createPassageEntry"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </rdf:RDF> 
    </xsl:template>
    
    <xsl:template name="createQuotationEntry">
        <xsl:variable name="quote" select="./quote"/>
        <xsl:variable name="quoteType" select="./quote/@type"/>
        <xsl:variable name="citation" select="./note[@type='citation']"/>
        <xsl:variable name="quoteid" select="./@xml:id"/>
        <xsl:variable name="authorid" select="translate(./bibl/author/@ref, '#', '')"/>
        <xsl:variable name="workid" select="translate(./bibl/title/@ref, '#', '')"/>
        <xsl:variable name="worktitle" select="/bibl/title"/>
        <xsl:variable name="source" select="./note[@type='source']"/>
            <rdf:Description rdf:about="http://scta.info/resource/{$quoteid}">
                <rdf:type rdf:resource="http://scta.info/resource/quotation"/>
                <dc:title><xsl:value-of select="$quote"></xsl:value-of></dc:title>
                <sctap:quotation><xsl:value-of select="$quote"/></sctap:quotation>
                <sctap:fromWork rdf:resource="http://scta.info/resource/{$workid}"/>
                <sctap:quoteAuthor rdf:resource="http://scta.info/resource/{$authorid}"/>
                <sctap:citation><xsl:value-of select="$citation"/></sctap:citation>
                <sctap:quotationType rdf:resource="http://scta.info/resource/{$quoteType}"/>
                <xsl:if test="$source">
                  <sctap:source rdf:resource="{$source}"/>
                </xsl:if>
                <xsl:for-each select="./bibl/biblScope">
                    <xsl:choose>
                        <xsl:when test="./@type = 'librum'">
                            <sctap:fromBook><xsl:value-of select="."/></sctap:fromBook>
                        </xsl:when>
                        <xsl:when test="./@type = 'capitulus'">
                            <sctap:fromChapter><xsl:value-of select="."/></sctap:fromChapter>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
              <!-- this for each intends to go through every xml/rdf file and check and see if ther eis a quote that matches the current node. If so, it creates a quotation entry -->  
              <!--  <xsl:for-each select="collection(concat($commentary-rdf-home, '?select=[a-zA-Z]*.rdf'))//sctap:isIstanceOf[@rdf:resource=concat('http://scta.info/resource/', $quoteid)]|sctap:references[@rdf:resource=concat('http://scta.info/resource/', $quoteid)]">
                    <xsl:variable name="itemid"><xsl:value-of select="./parent::rdf:Description/@rdf:about"/></xsl:variable>
                    <xsl:choose>
                        <xsl:when test="./name() eq 'quotes'">
                            <sctap:hasInstance rdf:resource="{$itemid}"/>
                        </xsl:when>
                        <xsl:when test="./name() eq 'references'">
                            <sctap:hasInstance rdf:resource="{$itemid}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <sctap:hasInstance rdf:resource="{$itemid}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                -->
            
            </rdf:Description>
        
    </xsl:template>
    <xsl:template name="createPassageEntry">
        <xsl:variable name="passageType" select="./quote/@type"/>
        <xsl:variable name="citation" select="./note[@type='citation']"/>
        <xsl:variable name="passageid" select="./@xml:id"/>
        <xsl:variable name="authorid" select="translate(./bibl/author/@ref, '#', '')"/>
        <xsl:variable name="workid" select="translate(./bibl/title/@ref, '#', '')"/>
        <xsl:variable name="worktitle" select="/bibl/title"/>
        <rdf:Description rdf:about="http://scta.info/resource/{$passageid}">
            <rdf:type rdf:resource="http://scta.info/resource/passage"/>
            <dc:title><xsl:value-of select="$citation"></xsl:value-of></dc:title>
            <sctap:fromWork rdf:resource="http://scta.info/resource/{$workid}"/>
            <sctap:passageAuthor rdf:resource="http://scta.info/resource/{$authorid}"/>
            <sctap:citation><xsl:value-of select="$citation"/></sctap:citation>
            <sctap:passageType rdf:resource="http://scta.info/resource/{$passageType}"/>
            
            <xsl:for-each select="./bibl/biblScope">
                <xsl:choose>
                    <xsl:when test="./@type = 'librum'">
                        <sctap:fromBook><xsl:value-of select="."/></sctap:fromBook>
                    </xsl:when>
                    <xsl:when test="./@type = 'capitulus'">
                        <sctap:fromChapter><xsl:value-of select="."/></sctap:fromChapter>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
            
            <!-- <xsl:for-each select="collection(concat($commentary-rdf-home, '?select=[a-zA-Z0-9]*.rdf'))//sctap:isInstanceOf[@rdf:resource=concat('http://scta.info/resource/', $passageid)]">
                <xsl:variable name="itemid"><xsl:value-of select="./parent::rdf:Description/@rdf:about"/></xsl:variable>
                <sctap:hasInstance rdf:resource="{$itemid}"/>
            </xsl:for-each> -->
            
        </rdf:Description>
    </xsl:template>
    
    <xsl:template match="head">
        
    </xsl:template>
</xsl:stylesheet>