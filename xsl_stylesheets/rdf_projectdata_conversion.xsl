<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:sctap="http://scta.info/properties/" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    
    <xsl:param name="author"><xsl:value-of select="//header/authorName"/></xsl:param>
    <xsl:param name="commentaryname"><xsl:value-of select="//header/commentaryName"/></xsl:param>
    <xsl:param name="cid"><xsl:value-of select="//header/commentaryid"/></xsl:param>
    <xsl:param name="commentaryslug"><xsl:value-of select="//header/commentaryslug"/></xsl:param>
    <xsl:param name="author-uri"><xsl:value-of select="//header/authorUri"/></xsl:param>
    <xsl:param name="parent-uri"><xsl:value-of select="//header/parentUri"/></xsl:param>
    <xsl:param name="textfilesdir"><xsl:value-of select="//header/textfilesdir"/></xsl:param>
    <xsl:param name="webbase"><xsl:value-of select="//header/webbase"/></xsl:param>
    
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- function templates below -->
    
    <xsl:template name="status">
        <xsl:param name="text-path"/>
        <xsl:choose>
            <xsl:when test="document($text-path)//tei:revisionDesc/@status">
                <sctap:status><xsl:value-of select="document($text-path)//tei:revisionDesc/@status"></xsl:value-of></sctap:status>
            </xsl:when>
            <xsl:when test="document($text-path)">
                <sctap:status>In Progress</sctap:status>
            </xsl:when>
            <xsl:otherwise>
                <sctap:status>Not Started</sctap:status>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="/">
       <xsl:apply-templates></xsl:apply-templates>
   </xsl:template>
   
   <xsl:template match="div[@id='frontmatter']">
       
   </xsl:template>
   <xsl:template match="div[@id='backmatter']">
        
    </xsl:template>
    
    <xsl:template match="header">
        
    </xsl:template>
    
    <xsl:template match="head">
        
    </xsl:template>
    
    <xsl:template match="//div[@id='body']">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:sctar="http://scta.info/resource/" xmlns:sctap="http://scta.info/property/" xmlns:sctat="http://scta.info/text/" xmlns:role="http://www.loc.gov/loc.terms/relators/" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:collex="http://www.collex.org/schema#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/">    
                <rdf:Description rdf:about="{$parent-uri}">
                <rdf:type rdf:resource="http://scta.info/resource/commentarius"/>
                <dc:title><xsl:value-of select="$commentaryname"/></dc:title>
                <dcterms:isPartOf rdf:resource="http://scta.info/resource/scta"/>
                <sctap:slug><xsl:value-of select="$commentaryslug"/></sctap:slug>
                    <xsl:choose>
                        <xsl:when test=".//div[@type='librum']">
                            <xsl:for-each select=".//div[@type='librum']">
                                <xsl:variable name="bid"><xsl:value-of select="./@id"/></xsl:variable>
                                <dcterms:hasPart rdf:resource="http://scta.info/text/{$cid}/librum/{$bid}"/>    
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test=".//div[@type='distinctio']">
                            <xsl:for-each select=".//div[@type='distinctio']">
                                <xsl:variable name="did"><xsl:value-of select="./@id"/></xsl:variable>
                                <dcterms:hasPart rdf:resource="http://scta.info/text/{$cid}/distinctio/{$did}"/>    
                            </xsl:for-each>
                        </xsl:when>
                        <!-- think about removing this since i have added sctap:hasItem for all commentaries regardless of structure -->
                        <xsl:otherwise>
                            <xsl:for-each select=".//item">
                                <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
                                <dcterms:hasPart rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>    
                            </xsl:for-each>
                        </xsl:otherwise>
                        <!-- think about removing the above "oterwise" option since i have added sctap:hasItem for all commentaries regardless of structure -->
                    </xsl:choose>
                    <xsl:for-each select="./div//item">
                        <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
                        <sctap:hasItem rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                    </xsl:for-each>
                </rdf:Description>
            
            <xsl:if test=".//div[@type='librum']">
                <xsl:for-each select=".//div[@type='librum']">
                    <xsl:variable name="bid"><xsl:value-of select="./@id"/></xsl:variable>
                    <xsl:variable name="title"><xsl:value-of select="./head"/></xsl:variable>
                <rdf:Description rdf:about="http://scta.info/text/{$cid}/librum/{$bid}">
                <dc:title><xsl:value-of select="$title"></xsl:value-of></dc:title>
                <rdf:type rdf:resource="http://scta.info/resource/librum"/>
                <dcterms:isPartOf rdf:resource="{$parent-uri}"/>
                <sctap:isPartOfCommentary rdf:resource="{$parent-uri}"/>
                    <xsl:variable name="totalnumber"><xsl:number count="div[@type='librum']" level="any"/></xsl:variable>
                    <xsl:variable name="sectionnumber"><xsl:number count="div[@type='librum']"/></xsl:variable>
                    <sctap:sectionOrderNumber><xsl:value-of select="format-number($sectionnumber, '000')"/></sctap:sectionOrderNumber>
                    <sctap:totalOrderNumber><xsl:value-of select="format-number($totalnumber, '000')"/></sctap:totalOrderNumber>
                <xsl:choose>
                    <xsl:when test=".//div[@type='distinctio']">
                    <xsl:for-each select=".//div[@type='distinctio']">
                        <xsl:variable name="did"><xsl:value-of select="./@id"/></xsl:variable>
                        <dcterms:hasPart rdf:resource="http://scta.info/text/{$cid}/distinctio/{$did}"/>    
                    </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select=".//item">
                            <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
                            <dcterms:hasPart rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>    
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:for-each select=".//item">
                    <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
                    <sctap:hasItem rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                </xsl:for-each>
                
            </rdf:Description>
        </xsl:for-each>
            </xsl:if>
        
            <xsl:if test=".//div[@type='distinctio']">
            <xsl:for-each select=".//div[@type='distinctio']">
                <xsl:variable name="did"><xsl:value-of select="./@id"/></xsl:variable>
                <xsl:variable name="title"><xsl:value-of select="./head"/></xsl:variable>
                <xsl:variable name="bookParent"><xsl:value-of select="./parent::div/@id"/></xsl:variable>
                <rdf:Description rdf:about="http://scta.info/text/{$cid}/distinctio/{$did}">
                    <dc:title><xsl:value-of select="$title"></xsl:value-of></dc:title>
                    <rdf:type rdf:resource="http://scta.info/resource/distinctio"/>
                    <!--<dcterms:isPartOf rdf:resource="{$parent-uri}"/>-->
                    <dcterms:isPartOf rdf:resource="http://scta.info/text/{$cid}/librum/{$bookParent}"/>
                    <sctap:isPartOfCommentary rdf:resource="{$parent-uri}"/>
                    <sctap:isPartOfBook rdf:resource="http://scta.info/text/{$cid}/librum/{$bookParent}"/>
                    
                    <xsl:variable name="totalnumber"><xsl:number count="div[@type='distinctio']" level="any"/></xsl:variable>
                        <xsl:variable name="sectionnumber"><xsl:number count="div[@type='distinctio']"/></xsl:variable>
                    <sctap:sectionOrderNumber><xsl:value-of select="format-number($sectionnumber, '000')"/></sctap:sectionOrderNumber>
                    <sctap:totalOrderNumber><xsl:value-of select="format-number($totalnumber, '000')"/></sctap:totalOrderNumber>
                    
                    <xsl:for-each select=".//item">
                        <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
                        <dcterms:hasPart rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                        <sctap:hasItem rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                    </xsl:for-each>
                </rdf:Description>
            </xsl:for-each>
            </xsl:if>
            
            <xsl:for-each select="./div//item">
                <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
                <xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>
                <xsl:variable name="structureType"><xsl:value-of select="@type"/></xsl:variable>
                <xsl:variable name="bookParent"><xsl:value-of select="./ancestor::div[@type='librum']/@id"/></xsl:variable>
                <xsl:variable name="distinctionParent"><xsl:value-of select="./parent::div/@id"/></xsl:variable>
                <xsl:variable name="text-path" select="concat($textfilesdir, $fs, '/', $fs, '.xml')"/>
                <xsl:variable name="repo-path" select="concat($textfilesdir, $fs, '/')"/>
                <xsl:variable name="extraction-file" select="if (document(concat($repo-path, 'transcriptions.xml'))) then concat($repo-path, document(concat($repo-path, 'transcriptions.xml'))/transcriptions/transcription[@use-for-extraction='true']) else $text-path"></xsl:variable>
                
           
                <rdf:Description rdf:about="http://scta.info/text/{$cid}/item/{$fs}">
                   <xsl:variable name="totalnumber"><xsl:number count="item" level="any"/></xsl:variable>
                   <xsl:variable name="sectionnumber"><xsl:number count="item"/></xsl:variable>
                        
                   <dc:title><xsl:value-of select="$title"></xsl:value-of></dc:title>
                   <role:AUT rdf:resource="{$author-uri}"/>
                   <sctap:sectionOrderNumber><xsl:value-of select="format-number($sectionnumber, '000')"/></sctap:sectionOrderNumber>
                   <sctap:totalOrderNumber><xsl:value-of select="format-number($totalnumber, '000')"/></sctap:totalOrderNumber>
                   <xsl:if test="./following::item[1]">
                     <xsl:variable name="next-item" select="./following::item[1]/fileName/@filestem"></xsl:variable>
                     <sctap:next rdf:resource="http://scta.info/text/{$cid}/item/{$next-item}"/>
                   </xsl:if>
                   <xsl:if test="./preceding::item[1]">
                     <xsl:variable name="previous-item" select="./preceding::item[1]/fileName/@filestem"></xsl:variable>
                    <sctap:previous rdf:resource="http://scta.info/text/{$cid}/item/{$previous-item}"/>
                   </xsl:if>
                        
                   <xsl:if test="./questionTitle">
                       <sctap:questionTitle><xsl:value-of select="./questionTitle"></xsl:value-of></sctap:questionTitle>
                   </xsl:if>
                        
                   <rdf:type rdf:resource="http://scta.info/resource/item"/>
                   <rdf:type rdf:resource="http://scta.info/resource/{$structureType}"/>
                   <sctap:isPartOfCommentary rdf:resource="{$parent-uri}"/>
                   <xsl:choose>
                        <xsl:when test="./ancestor::div[@type='distinctio']">
                            <dcterms:isPartOf rdf:resource="http://scta.info/text/{$cid}/distinctio/{$distinctionParent}"/>
                        </xsl:when>
                        <xsl:when test="./ancestor::div[@type='distinctio']">
                            <dcterms:isPartOf rdf:resource="http://scta.info/text/{$cid}/librum/{$bookParent}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <dcterms:isPartOf rdf:resource="{$parent-uri}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                  
                  <!-- need to change this to point to new lombardpress locations or scta viewer -->
                   <!-- <xsl:if test="not($webbase eq 'null') and ./@live eq 'true'">
                       <xsl:variable name="fullurl" select="concat($webbase, 'text/textdisplay.php?fs=', $fs)"></xsl:variable>
                       <rdfs:seeAlso rdf:resource="{$fullurl}"/>
                   </xsl:if> -->
                    
                    <xsl:for-each select="document($extraction-file)//tei:body//tei:name">
                        <xsl:variable name="nameRef" select="./@ref"></xsl:variable>
                        <xsl:variable name="nameID" select="substring-after($nameRef, '#')"></xsl:variable>
                        <xsl:variable name="totalNames" select="count(document($extraction-file)//tei:body//tei:name)"/>
                        <xsl:variable name="totalFollowingNames" select="count(.//following::tei:name)"></xsl:variable>
                        <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalNames - $totalFollowingNames)"/>
                        <sctap:mentions rdf:resource="http://scta.info/resource/person/{$nameID}"/>
                        <sctap:hasName rdf:resource="http://scta.info/text/{$cid}/name/{$objectId}"/>
                    </xsl:for-each>
                    <xsl:for-each select="document($extraction-file)//tei:body//tei:title">
                        <xsl:variable name="titleRef" select="./@ref"></xsl:variable>
                        <xsl:variable name="titleID" select="substring-after($titleRef, '#')"></xsl:variable>
                        <xsl:variable name="totalTitles" select="count(document($extraction-file)//tei:body//tei:title)"/>
                        <xsl:variable name="totalFollowingTitles" select="count(.//following::tei:title)"></xsl:variable>
                        <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalTitles - $totalFollowingTitles)"/>
                        <sctap:mentions rdf:resource="http://scta.info/resource/work/{$titleID}"/>
                        <sctap:hasTitle rdf:resource="http://scta.info/text/{$cid}/title/{$objectId}"/>
                     </xsl:for-each>
                    <xsl:for-each select="document($extraction-file)//tei:body//tei:quote">
                        <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
                        <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
                        <xsl:variable name="totalQuotes" select="count(document($extraction-file)//tei:body//tei:quote)"/>
                        <xsl:variable name="totalFollowingQuotes" select="count(.//following::tei:quote)"></xsl:variable>
                        <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalQuotes - $totalFollowingQuotes)"/>
                        <sctap:quotes rdf:resource="http://scta.info/resource/quotation/{$quoteID}"/>
                        <sctap:hasQuote rdf:resource="http://scta.info/text/{$cid}/quote/{$objectId}"/>
                     </xsl:for-each>
                   <xsl:for-each select="document($extraction-file)//tei:body/tei:ref">
                       <xsl:variable name="refRef" select="./@ana"></xsl:variable>
                       <xsl:variable name="refID" select="substring-after($refRef, '#')"></xsl:variable>
                       <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:refs)"/>
                       <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
                       <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalRefs - $totalFollowingRefs)"/>
                       <sctap:references rdf:resource="http://scta.info/resource/passage/{$refID}"/>
                       <sctap:hasRef rdf:resource="http://scta.info/text/{$cid}/ref/{$objectId}"/>
                   </xsl:for-each>
            
                     <xsl:choose>
                         <xsl:when test="document($extraction-file)//tei:revisionDesc/@status">
                             <sctap:status><xsl:value-of select="document($extraction-file)//tei:revisionDesc/@status"></xsl:value-of></sctap:status>
                         </xsl:when>
                         <xsl:when test="document($extraction-file)">
                             <sctap:status>In Progress</sctap:status>
                         </xsl:when>
                         <xsl:otherwise>
                             <sctap:status>Not Started</sctap:status>
                         </xsl:otherwise>
                     </xsl:choose>
                   
                  <!-- begin test for witnesses and transcriptions -->
                       
                    <xsl:if test="document($text-path)">
                       <sctap:hasTranscription rdf:resource="http://scta.info/text/{$cid}/transcription/{$fs}"/>
                    </xsl:if>
                    
                  <xsl:for-each select="./hasWitnesses/witness">
                    
                        <xsl:variable name="wit-ref"><xsl:value-of select="substring-after(./@ref, '#')"/></xsl:variable>
                    
                        <xsl:variable name="wit-slug"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/slug"/></xsl:variable>
                        <xsl:variable name="transcription-text-path" select="concat($textfilesdir, $fs, '/', $wit-slug, '_', $fs, '.xml')"/>
                        
                        <sctap:hasWitness rdf:resource="http://scta.info/text/{$cid}/witness/{$wit-slug}_{$fs}"/>
                        <xsl:if test="document($transcription-text-path)">
                            <sctap:hasTranscription rdf:resource="http://scta.info/text/{$cid}/transcription/{$wit-slug}_{$fs}"/>
                        </xsl:if>
                    </xsl:for-each>
                   
                    <!-- check for an manual rdfs -->
                    <xsl:for-each select="./manualRDFs/child::node()">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </rdf:Description>
                
                <xsl:for-each select="document($extraction-file)//tei:body//tei:name">
                    <xsl:variable name="nameRef" select="@ref"/>
                    <xsl:variable name="nameID" select="substring-after($nameRef, '#')"/>
                    <xsl:variable name="totalNames" select="count(document($extraction-file)//tei:body//tei:name)"/>
                    <xsl:variable name="totalFollowingNames" select="count(.//following::tei:name)"></xsl:variable>
                    <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalNames - $totalFollowingNames)"/>
                    <rdf:Description rdf:about="http://scta.info/text/{$cid}/name/{$objectId}">
                        <rdf:type rdf:resource="http://scta.info/resource/nameElement"/>
                        <sctap:isInstanceOf rdf:resource="http://scta.info/resource/person/{$nameID}"/>
                        <sctap:elementText><xsl:value-of select="."/></sctap:elementText>
                        <sctap:isPartOfItem rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                    </rdf:Description>
                </xsl:for-each>
                <xsl:for-each select="document($extraction-file)//tei:body//tei:title">
                    <xsl:variable name="titleRef" select="./@ref"></xsl:variable>
                    <xsl:variable name="titleID" select="substring-after($titleRef, '#')"></xsl:variable>
                    <xsl:variable name="totalTitles" select="count(document($extraction-file)//tei:body//tei:title)"/>
                    <xsl:variable name="totalFollowingTitles" select="count(.//following::tei:title)"></xsl:variable>
                    <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalTitles - $totalFollowingTitles)"/>
                    <rdf:Description rdf:about="http://scta.info/text/{$cid}/title/{$objectId}">
                        <rdf:type rdf:resource="http://scta.info/resource/titleElement"/>
                        <sctap:isInstanceOf rdf:resource="http://scta.info/resource/work/{$titleID}"/>
                        <sctap:elementText><xsl:value-of select="."/></sctap:elementText>
                        <sctap:isPartOfItem rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                    </rdf:Description>
                </xsl:for-each>
                <xsl:for-each select="document($extraction-file)//tei:body//tei:quote">
                    <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
                    <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
                    <xsl:variable name="totalQuotes" select="count(document($extraction-file)//tei:body//tei:quotes)"/>
                    <xsl:variable name="totalFollowingQuotes" select="count(.//following::tei:quote)"></xsl:variable>
                    <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalQuotes - $totalFollowingQuotes)"/>
                    <rdf:Description rdf:about="http://scta.info/text/{$cid}/quote/{$objectId}">
                        <rdf:type rdf:resource="http://scta.info/resource/quoteElement"/>
                        <sctap:isInstanceOf rdf:resource="http://scta.info/resource/quotation/{$quoteID}"/>
                        <sctap:elementText><xsl:value-of select="."/></sctap:elementText>
                        <sctap:isPartOfItem rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                    </rdf:Description>
                </xsl:for-each>
                <xsl:for-each select="document($extraction-file)//tei:body/tei:ref">
                    <xsl:variable name="refRef" select="./@ana"></xsl:variable>
                    <xsl:variable name="refID" select="substring-after($refRef, '#')"></xsl:variable>
                    <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:refs)"/>
                    <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
                    <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalRefs - $totalFollowingRefs)"/>
                    <rdf:Description rdf:about="http://scta.info/text/{$cid}/ref/{$objectId}">
                        <rdf:type rdf:resource="http://scta.info/resource/refElement"/>
                        <!-- problem currently this is a problem if the ref is to a quote rather than a passage -->
                        <!-- could keep passage a default, and then if ref points to quote add type attribute "quotation" -->
                        <sctap:isInstanceOf rdf:resource="http://scta.info/resource/passage/{$refID}"/>
                        <sctap:elementText><xsl:value-of select="."/></sctap:elementText>
                        <sctap:isPartOfItem rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                    </rdf:Description>
                </xsl:for-each>
                
                <xsl:if test="document($text-path)">
                    <xsl:variable name="critical-transcript-title" select="document($text-path)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                    <xsl:variable name="critical-transcript-editor" select="document($text-path)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor"/>
                    <rdf:Description rdf:about="http://scta.info/text/{$cid}/transcription/{$fs}">
                        <dc:title><xsl:value-of select="$critical-transcript-title"/></dc:title>
                        <role:AUT rdf:resource="{$author-uri}"/>
                        <role:EDT><xsl:value-of select="$critical-transcript-editor"/></role:EDT>
                        <!-- <xsl:call-template name="status">
                            <xsl:with-param name="text-path" select="$text-path"/>
                        </xsl:call-template> -->
                                <xsl:choose>
                                    <xsl:when test="document($text-path)//tei:revisionDesc/@status">
                                        <sctap:status><xsl:value-of select="document($text-path)//tei:revisionDesc/@status"></xsl:value-of></sctap:status>
                                    </xsl:when>
                                    <xsl:when test="document($text-path)">
                                        <sctap:status>In Progress</sctap:status>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <sctap:status>Not Started</sctap:status>
                                    </xsl:otherwise>
                                </xsl:choose>
                        
                        <rdf:type rdf:resource="http://scta.info/resource/transcription"/>
                        <sctap:isTranscriptionOf rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                        <sctap:transcriptionType>Critical</sctap:transcriptionType>
                        
                        <xsl:for-each select="document($text-path)//tei:body//tei:p">
                            <xsl:variable name="pid" select="./@xml:id"/>
                            <xsl:variable name="pid_ref" select="concat('#', ./@xml:id)"/>
                            <sctap:hasParagraph rdf:resource="http://scta.info/text/{$cid}/transcription/{$fs}/paragraph/{$pid}"/>
                        </xsl:for-each>
                        <sctap:plaintext rdf:resource="http://text.scta.info/plaintext/{$cid}/{$fs}/transcription/critical"/>
                    </rdf:Description>
                    
                    <xsl:for-each select="document($text-path)//tei:body//tei:p">
                        <!-- only creates paragraph resource if that paragraph has been assigned an id -->
                        <xsl:if test="./@xml:id">
                            <xsl:variable name="pid" select="./@xml:id"/>
                            <xsl:variable name="pid_ref" select="concat('#', ./@xml:id)"/>
                            <rdf:Description rdf:about="http://scta.info/text/{$cid}/transcription/{$fs}/paragraph/{$pid}">
                                <dc:title>Paragraph <xsl:value-of select="$pid"/></dc:title>
                                <rdf:type rdf:resource="http://scta.info/resource/paragraph"/>
                                <sctap:plaintext rdf:resource="http://text.scta.info/plaintext/{$cid}/{$fs}/transcription/critical/paragraph/{$pid}"/>
                                <sctap:isParagraphOf rdf:resource="http://scta.info/text/{$cid}/transcription/{$fs}"/>
                                <!-- could add path to plain text version of paragraph -->
                            </rdf:Description>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                
                <xsl:for-each select="hasWitnesses/witness">
                    <xsl:variable name="wit-ref"><xsl:value-of select="substring-after(./@ref, '#')"/></xsl:variable>
                    <xsl:variable name="wit-slug"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/slug"/></xsl:variable>
                    <xsl:variable name="wit-initial"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/initial"/></xsl:variable>
                    <xsl:variable name="wit-title"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/title"/></xsl:variable>
                    <xsl:variable name="partOf"><xsl:value-of select="./preceding::fileName[1]/@filestem"></xsl:value-of></xsl:variable>
                    <xsl:variable name="partOfTitle"><xsl:value-of select="./preceding::fileName[1]/following-sibling::tei:title"/></xsl:variable>
                    <xsl:variable name="transcription-text-path" select="concat($textfilesdir, $fs, '/', $wit-slug, '_', $fs, '.xml')"/>
                    <xsl:variable name="iiif-ms-name" select="concat($commentaryslug, '-', $wit-slug)"/>
                    
                  
                    
                  <rdf:Description rdf:about="http://scta.info/text/{$cid}/witness/{$wit-slug}_{$fs}">
                    
                    <dc:title><xsl:value-of select="$partOf"/> [<xsl:value-of select="$wit-title"/>]</dc:title>
                    <role:AUT rdf:resource="{$author-uri}"/>
                    <rdf:type rdf:resource="http://scta.info/resource/witness"/>
                    <sctap:hasSlug><xsl:value-of select="$wit-slug"></xsl:value-of></sctap:hasSlug>
                    <xsl:for-each select="./folio">
                      <xsl:variable name="folionumber" select="./text()"/>
                      <xsl:variable name="canvas-slug" select="concat($wit-initial, $folionumber)"></xsl:variable>
                      
                      <sctap:hasFolio><xsl:value-of select="$folionumber"></xsl:value-of></sctap:hasFolio>
                      <sctap:isOnCanvas rdf:resource="http://scta.info/iiif/{$iiif-ms-name}/canvas/{$canvas-slug}"/>
                      
                    </xsl:for-each>
                      
                    
                    
                    <xsl:if test="document($transcription-text-path)">
                        <sctap:hasTranscription rdf:resource="http://scta.info/text/{$cid}/transcription/{$wit-slug}_{$fs}"/>
                    </xsl:if>
                   <!-- could include isPartOf to manuscript identifier
                       could also inclue folio numbers if these are included in main project file -->
                   </rdf:Description>
                    
                    
                    
                    <xsl:if test="document($transcription-text-path)">
                        <xsl:variable name="transcript-title" select="document($transcription-text-path)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                        <xsl:variable name="transcript-editor" select="document($transcription-text-path)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor"/>
                        
                        <rdf:Description rdf:about="http://scta.info/text/{$cid}/transcription/{$wit-slug}_{$fs}">
                            
                            <dc:title><xsl:value-of select="$transcript-title"/></dc:title>
                            <role:AUT rdf:resource="{$author-uri}"/>
                            <role:EDT><xsl:value-of select="$transcript-editor"/></role:EDT>
                            
                            <!-- <xsl:call-template name="status">
                                <xsl:with-param name="text-path" select="$transcription-text-path"/>
                            </xsl:call-template> -->
                                <xsl:choose>
                                    <xsl:when test="document($transcription-text-path)//tei:revisionDesc/@status">
                                        <sctap:status><xsl:value-of select="document($transcription-text-path)//tei:revisionDesc/@status"></xsl:value-of></sctap:status>
                                    </xsl:when>
                                    <xsl:when test="document($transcription-text-path)">
                                        <sctap:status>In Progress</sctap:status>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <sctap:status>Not Started</sctap:status>
                                    </xsl:otherwise>
                                </xsl:choose>
                            
                            
                            <rdf:type rdf:resource="http://scta.info/resource/transcription"/>
                            <sctap:isTranscriptionOf rdf:resource="http://scta.info/text/{$cid}/item/{$partOf}"/>
                            <sctap:transcriptionType>Documentary</sctap:transcriptionType>
                            <xsl:for-each select="document($transcription-text-path)//tei:body//tei:p">
                                <xsl:variable name="pid" select="./@xml:id"/>
                                <xsl:variable name="pid_ref" select="concat('#', ./@xml:id)"/>
                                <!-- only creates paragraph resource if that paragraph has been assigned an id -->
                                <xsl:if test="./@xml:id">
                                  <sctap:hasParagraph rdf:resource="http://scta.info/text/{$cid}/transcription/{$wit-slug}_{$fs}/paragraph/{$pid}"/>
                                </xsl:if>
                            </xsl:for-each>
                            <sctap:plaintext rdf:resource="http://text.scta.info/plaintext/{$cid}/{$fs}/transcription/{$wit-slug}"/>
                        </rdf:Description>
                        <!-- will create paragraph resources for each paragraph in transcription -->
                        <xsl:for-each select="document($transcription-text-path)//tei:body//tei:p">
                            <!-- only creates paragraph resource if that paragraph has been assigned an id -->
                            <xsl:if test="./@xml:id">
                                <xsl:variable name="pid" select="./@xml:id"/>
                                <xsl:variable name="pid_ref" select="concat('#', ./@xml:id)"/>
                                <rdf:Description rdf:about="http://scta.info/text/{$cid}/transcription/{$wit-slug}_{$fs}/paragraph/{$pid}">
                                    <dc:title>Paragraph <xsl:value-of select="$pid"/></dc:title>
                                    <rdf:type rdf:resource="http://scta.info/resource/paragraph"/>
                                    <sctap:isParagraphOf rdf:resource="http://scta.info/text/{$cid}/transcription/{$wit-slug}_{$fs}"/>
                                    <sctap:plaintext rdf:resource="http://text.scta.info/plaintext/{$cid}/{$fs}/transcription/{$wit-slug}/paragraph/{$pid}"/>
                                    <xsl:for-each select="document($transcription-text-path)/tei:TEI/tei:facsimile//tei:zone[@start=$pid_ref]">
                                        <xsl:variable name="position" select="if (./@n) then ./@n else 1"/>
                                        <sctap:hasZone rdf:resource="http://scta.info/text/{$cid}/zone/{$wit-slug}_{$fs}/paragraph/{$pid}/{$position}"/>
                                    </xsl:for-each>
                                    <!-- could add path to plain text version of paragraph -->
                                </rdf:Description>
                                    <xsl:if test="document($transcription-text-path)/tei:TEI/tei:facsimile">
                                        
                                        <xsl:for-each select="document($transcription-text-path)/tei:TEI/tei:facsimile//tei:zone[@start=$pid_ref]">
                                            <xsl:variable name="imagefilename" select="./preceding-sibling::tei:graphic/@url"/>
                                            <xsl:variable name="canvasname" select="substring-before($imagefilename, '.')"/>
                                            <xsl:variable name="ulx" select="./@ulx"/>
                                            <xsl:variable name="uly" select="./@uly"/>
                                            <xsl:variable name="lrx" select="./@lrx"/>
                                            <xsl:variable name="lry" select="./@lry"/>
                                            <xsl:variable name="width"><xsl:value-of select="$lrx - $ulx"/></xsl:variable>
                                            <xsl:variable name="height"><xsl:value-of select="$lry - $uly"/></xsl:variable>
                                            <xsl:variable name="position" select="if (./@n) then ./@n else 1"/>
                                            <rdf:Description rdf:about="http://scta.info/text/{$cid}/zone/{$wit-slug}_{$fs}/paragraph/{$pid}/{$position}">
                                                <dc:title>Canvas zone for <xsl:value-of select="$wit-slug"/>_<xsl:value-of select="$fs"/> paragraph <xsl:value-of select="$pid"/></dc:title>
                                                <rdf:type rdf:resource="http://scta.info/resource/zone"/>
                                                <!-- problem here with slug since iiif slug is prefaced with pg or pp etc -->
                                                <sctap:isZoneOf rdf:resource="http://scta.info/text/{$cid}/transcription/{$wit-slug}_{$fs}/paragraph/{$pid}"/>
                                                <sctap:isZoneOn rdf:resource="http://scta.info/iiif/{$commentaryslug}-{$wit-slug}/canvas/{$canvasname}"/>
                                                <sctap:ulx><xsl:value-of select="$ulx"/></sctap:ulx>
                                                <sctap:uly><xsl:value-of select="$uly"/></sctap:uly>
                                                <sctap:lrx><xsl:value-of select="$lrx"/></sctap:lrx>
                                                <sctap:lry><xsl:value-of select="$lry"/></sctap:lry>
                                                <sctap:width><xsl:value-of select="$width"/></sctap:width>
                                                <sctap:height><xsl:value-of select="$height"/></sctap:height>
                                                <sctap:position><xsl:value-of select="$position"/></sctap:position>
                                            </rdf:Description>
                                        </xsl:for-each>
                                    </xsl:if>
                                    
                                
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:for-each>
        
        </xsl:for-each>
        </rdf:RDF>
    </xsl:template> 
    
    
</xsl:stylesheet>