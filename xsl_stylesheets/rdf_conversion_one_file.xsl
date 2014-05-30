<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:param name="author"><xsl:value-of select="//head/authorName"/></xsl:param>
    <xsl:param name="commentaryname"><xsl:value-of select="//head/commentaryName"/></xsl:param>
    <xsl:param name="author-uri"><xsl:value-of select="//head/authorUri"/></xsl:param>
    <xsl:param name="parent-uri"><xsl:value-of select="//head/parentUri"/></xsl:param>
    <xsl:param name="textfilesdir"><xsl:value-of select="//head/textfilesdir"/></xsl:param>
    <xsl:param name="webbase"><xsl:value-of select="//head/webbase"/></xsl:param>
    
    <xsl:output method="xml"/>
   
   <xsl:template match="/">
       <xsl:apply-templates></xsl:apply-templates>
   </xsl:template>
   
   <xsl:template match="div[@id='frontmatter']">
       
   </xsl:template>
   <xsl:template match="div[@id='backmatter']">
        
    </xsl:template>
    
    <xsl:template match="head">
        
    </xsl:template>
    
    <xsl:template match="//div[@id='body']">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:scta-rel="http://scta.info/relations/" xmlns:role="http://www.loc.gov/loc.terms/relators/" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:collex="http://www.collex.org/schema#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/">    
                <rdf:Description rdf:about="{$parent-uri}">
                <rdf:type rdf:resource="http://scta.info/commentary"/>
                <dc:title><xsl:value-of select="$commentaryname"/></dc:title>
                <dcterms:isPartOf rdf:resource="http://scta.info/scta"/>
                    <xsl:choose>
                        <xsl:when test=".//div[@type='book']">
                            <xsl:for-each select=".//div[@type='book']">
                                <xsl:variable name="bid"><xsl:value-of select="./@id"/></xsl:variable>
                                <dcterms:hasPart rdf:resource="http://scta.info/books/{$bid}"/>    
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test=".//div[@type='distinction']">
                            <xsl:for-each select=".//div[@type='distinction']">
                                <xsl:variable name="did"><xsl:value-of select="./@id"/></xsl:variable>
                                <dcterms:hasPart rdf:resource="http://scta.info/distinctions/{$did}"/>    
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select=".//item">
                                <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
                                <dcterms:hasPart rdf:resource="http://scta.info/items/{$fs}"/>    
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!--<xsl:for-each select="./div//item">
                    <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
                    <dcterms:hasPart rdf:resource="http://scta.info/items/{$fs}"/>
                </xsl:for-each>-->
                </rdf:Description>
            
            <xsl:if test=".//div[@type='book']">
                <xsl:for-each select=".//div[@type='book']">
                    <xsl:variable name="bid"><xsl:value-of select="./@id"/></xsl:variable>
                    <xsl:variable name="title"><xsl:value-of select="./head"/></xsl:variable>
                <rdf:Description rdf:about="http://scta.info/books/{$bid}">
                <dc:title><xsl:value-of select="$title"></xsl:value-of></dc:title>
                <rdf:type rdf:resource="http://scta.info/book"/>
                <dcterms:isPartOf rdf:resource="{$parent-uri}"/>
                
                <xsl:choose>
                    <xsl:when test=".//div[@type='distinction']">
                    <xsl:for-each select=".//div[@type='distinction']">
                        <xsl:variable name="did"><xsl:value-of select="./@id"/></xsl:variable>
                        <dcterms:hasPart rdf:resource="http://scta.info/distinctions/{$did}"/>    
                    </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select=".//item">
                            <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
                            <dcterms:hasPart rdf:resource="http://scta.info/items/{$fs}"/>    
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
                
            </rdf:Description>
        </xsl:for-each>
            </xsl:if>
        
            <xsl:if test=".//div[@type='distinction']">
            <xsl:for-each select=".//div[@type='distinction']">
                <xsl:variable name="did"><xsl:value-of select="./@id"/></xsl:variable>
                <xsl:variable name="title"><xsl:value-of select="./head"/></xsl:variable>
                <xsl:variable name="bookParent"><xsl:value-of select="./parent::div/@id"/></xsl:variable>
                <rdf:Description rdf:about="http://scta.info/distinctions/{$did}">
                    <dc:title><xsl:value-of select="$title"></xsl:value-of></dc:title>
                    <rdf:type rdf:resource="http://scta.info/distinction"/>
                    <!--<dcterms:isPartOf rdf:resource="{$parent-uri}"/>-->
                    <dcterms:isPartOf rdf:resource="http://scta.info/books/{$bookParent}"/>
                    <xsl:for-each select=".//item">
                        <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
                        <dcterms:hasPart rdf:resource="http://scta.info/items/{$fs}"/>    
                    </xsl:for-each>
                </rdf:Description>
            </xsl:for-each>
            </xsl:if>
            
            <xsl:for-each select="./div//item">
            <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
            <xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>
            <xsl:variable name="bookParent"><xsl:value-of select="./ancestor::div[@type='book']/@id"/></xsl:variable>
            <xsl:variable name="distinctionParent"><xsl:value-of select="./parent::div/@id"/></xsl:variable>

            <rdf:Description rdf:about="http://scta.info/items/{$fs}">
                <xsl:variable name="text-path" select="concat($textfilesdir, $fs, '/', $fs, '.xml')"/>
                <xsl:variable name="editor" select="document($text-path)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor"/>
                <dc:title><xsl:value-of select="$title"></xsl:value-of></dc:title>
                <role:AUT rdf:resource="{$author-uri}"/>
                <role:EDT><xsl:value-of select="$editor"/></role:EDT>
                        
                 <rdf:type rdf:resource="http://scta.info/item"/>
                 <!--       <dcterms:isPartOf rdf:resource="{$parent-uri}"/>-->
                <xsl:choose>
                    <xsl:when test="./ancestor::div[@type='distinction']">
                        <dcterms:isPartOf rdf:resource="http://scta.info/distinctions/{$distinctionParent}"/>
                    </xsl:when>
                    <xsl:when test="./ancestor::div[@type='distinction']">
                        <dcterms:isPartOf rdf:resource="http://scta.info/books/{$bookParent}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <dcterms:isPartOf rdf:resource="{$parent-uri}"/>
                    </xsl:otherwise>
                </xsl:choose>
                
                    <xsl:for-each select="./hasParts/part">
                            <xsl:variable name="slug"><xsl:value-of select="./slug"/></xsl:variable>
                            <dcterms:hasPart rdf:resource="http://scta.info/transcriptions/{$slug}_{$fs}"/>
                        </xsl:for-each>
                <xsl:if test="not($webbase eq 'null') and ./@live eq 'true'">
                    <xsl:variable name="fullurl" select="concat($webbase, 'text/textdisplay.php?fs=', $fs)"></xsl:variable>
                        <rdfs:seeAlso rdf:resource="{$fullurl}"/>
                </xsl:if>
                        
                        <xsl:choose>
                        <xsl:when test="document($text-path)">
                            <scta-rel:status>In Progress</scta-rel:status>
                            <xsl:for-each select="distinct-values(document($text-path)//tei:name/@ref)">
                                <xsl:variable name="nameID" select="substring-after(., '#')"></xsl:variable>
                                <scta-rel:mentions rdf:resource="http://scta.info/names/{$nameID}"/>
                            </xsl:for-each>
                            <xsl:for-each select="distinct-values(document($text-path)//tei:title/@ref)">
                                <xsl:variable name="titleID" select="substring-after(., '#')"></xsl:variable>
                                <scta-rel:mentions rdf:resource="http://scta.info/works/{$titleID}"/>
                            </xsl:for-each>
                            <xsl:for-each select="distinct-values(document($text-path)//tei:quote/@ana)">
                                <xsl:variable name="quoteID" select="substring-after(., '#')"></xsl:variable>
                                <scta-rel:quotes rdf:resource="http://scta.info/quotations/{$quoteID}"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <scta-rel:status>Not Started</scta-rel:status>
                        </xsl:otherwise>
                        </xsl:choose>
                <!-- check for an manual rdfs -->
                <xsl:for-each select="./manualRDFs/child::node()">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                
                    </rdf:Description>
            
                <xsl:for-each select="hasParts/part">
                    <xsl:variable name="slug"><xsl:value-of select="./slug"/></xsl:variable>
                    <xsl:variable name="partOf"><xsl:value-of select="./preceding::fileName[1]/@filestem"></xsl:value-of></xsl:variable>
                    <xsl:variable name="partOfTitle"><xsl:value-of select="./preceding::fileName[1]/following-sibling::tei:title"/></xsl:variable>
                    <!--<xsl:variable name="text-path" select="concat('/Users/JCWitt/Documents/PlaoulProjectFiles/Textfiles/', $fs, '/', $slug, '_', $fs, '.xml')"/>-->
                    <!--<xsl:variable name="editor" select="document($text-path)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor"/>-->
                    <!--<xsl:variable name="title" select="document($text-path)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>-->
                        <rdf:Description rdf:about="http://scta.info/transcriptions/{$slug}_{$fs}">
                            <dc:title><xsl:value-of select="$partOf"/> [<xsl:value-of select="$slug"/>]</dc:title>
                            <role:AUT rdf:resource="{$author-uri}"/>
                          <!--<role:EDT><xsl:value-of select="$editor"/></role:EDT>-->
                            <rdf:type rdf:resource="http://scta.info/transcription"/>
                            <dcterms:isPartOf rdf:resource="http://scta.info/items/{$partOf}"/>
                            <!--<rdfs:seeAlso rdf:resource="http://petrusplaoul.org/text/textdisplay.php?fs={$fs}/ms={$slug}"/>-->
                        </rdf:Description>
                    
                </xsl:for-each>
        
        </xsl:for-each>
        </rdf:RDF>
    </xsl:template> 
    
    
</xsl:stylesheet>