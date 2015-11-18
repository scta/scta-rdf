<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:sctap="http://scta.info/properties/" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="sctap">
    
    <xsl:param name="author"><xsl:value-of select="//header/authorName"/></xsl:param>
    <xsl:param name="commentaryname"><xsl:value-of select="//header/commentaryName"/></xsl:param>
    <xsl:param name="cid"><xsl:value-of select="//header/commentaryid"/></xsl:param>
    <xsl:param name="commentaryslug"><xsl:value-of select="//header/commentaryslug"/></xsl:param>
    <xsl:param name="author-uri"><xsl:value-of select="//header/authorUri"/></xsl:param>
    <xsl:param name="parent-uri"><xsl:value-of select="//header/parentUri"/></xsl:param>
    <xsl:param name="textfilesdir"><xsl:value-of select="//header/textfilesdir"/></xsl:param>
    <xsl:param name="webbase"><xsl:value-of select="//header/webbase"/></xsl:param>
    <xsl:param name="gitRepoBase">http://bitbucket.org/jeffreycwitt/</xsl:param>
    
    <xsl:variable name="dtsurn"><xsl:value-of select="concat('urn:cts:latinLit:sentences', '.', $cid)"/></xsl:variable>
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
                <sctap:dtsurn rdf:about="{$dtsurn}"></sctap:dtsurn>
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
                  
                  
                  <xsl:variable name="librum-dtsurn" select="concat($dtsurn, ':', $sectionnumber)"/>  
                  <sctap:dtsurn rdf:about="{$librum-dtsurn}"></sctap:dtsurn>
                  <sctap:level><xsl:value-of select="count(ancestor::*)"/></sctap:level>
                
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
                    
                    <xsl:variable name="librum-number"><xsl:number count="div[@type='librum']"/></xsl:variable>
                    <xsl:variable name="distinctio-dtsurn" select="concat($dtsurn, ':', $librum-number, '.', $sectionnumber)"/>
                    <sctap:dtsurn rdf:about="{$distinctio-dtsurn}"></sctap:dtsurn>
                    <sctap:level><xsl:value-of select="count(ancestor::*)"/></sctap:level>
                    
                    <xsl:for-each select=".//item">
                        <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
                        <dcterms:hasPart rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                        <sctap:hasItem rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                    </xsl:for-each>
                </rdf:Description>
            </xsl:for-each>
            </xsl:if>
          
          <xsl:if test=".//div[@type='pars']">
            <xsl:for-each select=".//div[@type='pars']">
              <xsl:variable name="did"><xsl:value-of select="./@id"/></xsl:variable>
              <xsl:variable name="title"><xsl:value-of select="./head"/></xsl:variable>
              <xsl:variable name="bookParent"><xsl:value-of select="./ancestor::div[@type='librum']/@id"/></xsl:variable>
              <xsl:variable name="distinctioParent"><xsl:value-of select="./ancestor::div[@type='distinctio']/@id"/></xsl:variable>
              <rdf:Description rdf:about="http://scta.info/text/{$cid}/pars/{$did}">
                <dc:title><xsl:value-of select="$title"></xsl:value-of></dc:title>
                <rdf:type rdf:resource="http://scta.info/resource/pars"/>
                <!--<dcterms:isPartOf rdf:resource="{$parent-uri}"/>-->
                <dcterms:isPartOf rdf:resource="http://scta.info/text/{$cid}/librum/{$distinctioParent}"/>
                <sctap:isPartOfCommentary rdf:resource="{$parent-uri}"/>
                <sctap:isPartOfBook rdf:resource="http://scta.info/text/{$cid}/librum/{$bookParent}"/>
                
                <xsl:variable name="totalnumber"><xsl:number count="div[@type='pars']" level="any"/></xsl:variable>
                <xsl:variable name="sectionnumber"><xsl:number count="div[@type='pars']"/></xsl:variable>
                <sctap:sectionOrderNumber><xsl:value-of select="format-number($sectionnumber, '000')"/></sctap:sectionOrderNumber>
                <sctap:totalOrderNumber><xsl:value-of select="format-number($totalnumber, '000')"/></sctap:totalOrderNumber>
                
                <xsl:variable name="librum-number"><xsl:number count="div[@type='librum']"/></xsl:variable>
                <xsl:variable name="distinctio-number"><xsl:number count="div[@type='librum']"/></xsl:variable>
                <xsl:variable name="pars-dtsurn" select="concat($dtsurn, ':', $librum-number, '.', $distinctio-number, '.', $sectionnumber)"/>
                <sctap:dtsurn rdf:about="{$pars-dtsurn}"></sctap:dtsurn>
                <sctap:level><xsl:value-of select="count(ancestor::*)"/></sctap:level>
                
                <xsl:for-each select=".//item">
                  <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
                  <dcterms:hasPart rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                  <sctap:hasItem rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                </xsl:for-each>
              </rdf:Description>
            </xsl:for-each>
          </xsl:if>
          
          
          
           <!-- BEGIN item resource creation --> 
            <xsl:for-each select="./div//item">
                <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
                <xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>
                <xsl:variable name="structureType"><xsl:value-of select="@type"/></xsl:variable>
                <xsl:variable name="bookParent"><xsl:value-of select="./ancestor::div[@type='librum']/@id"/></xsl:variable>
                <xsl:variable name="distinctionParent"><xsl:value-of select="./parent::div/@id"/></xsl:variable>
                <xsl:variable name="text-path" select="concat($textfilesdir, $fs, '/', $fs, '.xml')"/>
                <xsl:variable name="repo-path" select="concat($textfilesdir, $fs, '/')"/>
                <xsl:variable name="extraction-file" select="if (document(concat($repo-path, 'transcriptions.xml'))) then concat($repo-path, document(concat($repo-path, 'transcriptions.xml'))/transcriptions/transcription[@use-for-extraction='true']) else $text-path"></xsl:variable>
                <xsl:variable name="info-path" select="concat($repo-path, 'info.xml')"/>
                <xsl:variable name="totalnumber"><xsl:number count="item" level="any"/></xsl:variable>
                <xsl:variable name="sectionnumber"><xsl:number count="item"/></xsl:variable>
                <xsl:variable name="librum-number"><xsl:number count="div[@type='librum']"/></xsl:variable>
                <xsl:variable name="distinctio-number"><xsl:number count="div[@type='distinctio']"/></xsl:variable>
                <xsl:variable name="pars-number"><xsl:number count="div[@type='pars']"/></xsl:variable>
                <xsl:variable name="item-level" select="count(ancestor::*)"/>
                <xsl:variable name="item-dtsurn">
                  <xsl:choose>
                    <xsl:when test="./parent::div[@type='pars']">
                      <xsl:value-of select="concat($dtsurn, ':', $librum-number, '.', $distinctio-number, '.', $pars-number, '.', $sectionnumber)"/>
                    </xsl:when>
                    <xsl:when test="./parent::div[@type='distinctio']">
                      <xsl:value-of select="concat($dtsurn, ':', $librum-number, '.', $distinctio-number, '.', $sectionnumber)"/>
                    </xsl:when>
                    <xsl:when test="./parent::div[@type='librum']">
                      <xsl:value-of select="concat($dtsurn, ':', $librum-number, '.', $sectionnumber)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="concat($dtsurn, ':', $sectionnumber)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
           
                <rdf:Description rdf:about="http://scta.info/text/{$cid}/item/{$fs}">
                   
                        
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
                  
                  
                    
                    
                    <sctap:dtsurn rdf:about="{$item-dtsurn}"/>
                   <sctap:level><xsl:value-of select="$item-level"/></sctap:level>
                  
                  
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
                  
                  <!-- record editors -->
                  <xsl:for-each select="document($extraction-file)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor">
                    <sctap:editedBy><xsl:value-of select="."/></sctap:editedBy>
                  </xsl:for-each>
                  
                  <!-- record git repo -->
                  <sctap:gitRepository><xsl:value-of select="concat($gitRepoBase, $fs)"/></sctap:gitRepository>
                  
                  <!-- BEGIN name, title, quotation, ref resource creation for item level-->
                    
                    <xsl:for-each select="document($extraction-file)//tei:body//tei:name[@ref]">
                        <xsl:variable name="nameRef" select="./@ref"></xsl:variable>
                        <xsl:variable name="nameID" select="substring-after($nameRef, '#')"></xsl:variable>
                        <xsl:variable name="totalNames" select="count(document($extraction-file)//tei:body//tei:name)"/>
                        <xsl:variable name="totalFollowingNames" select="count(.//following::tei:name)"></xsl:variable>
                        <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalNames - $totalFollowingNames)"/>
                        <sctap:mentions rdf:resource="http://scta.info/resource/person/{$nameID}"/>
                        <sctap:hasName rdf:resource="http://scta.info/text/{$cid}/name/{$objectId}"/>
                    </xsl:for-each>
                    <xsl:for-each select="document($extraction-file)//tei:body//tei:title[@ref]">
                        <xsl:variable name="titleRef" select="./@ref"></xsl:variable>
                        <xsl:variable name="titleID" select="substring-after($titleRef, '#')"></xsl:variable>
                        <xsl:variable name="totalTitles" select="count(document($extraction-file)//tei:body//tei:title)"/>
                        <xsl:variable name="totalFollowingTitles" select="count(.//following::tei:title)"></xsl:variable>
                        <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalTitles - $totalFollowingTitles)"/>
                        <sctap:mentions rdf:resource="http://scta.info/resource/work/{$titleID}"/>
                        <sctap:hasTitle rdf:resource="http://scta.info/text/{$cid}/title/{$objectId}"/>
                     </xsl:for-each>
                    <xsl:for-each select="document($extraction-file)//tei:body//tei:quote[@ana]">
                        <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
                        <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
                        <xsl:variable name="totalQuotes" select="count(document($extraction-file)//tei:body//tei:quote)"/>
                        <xsl:variable name="totalFollowingQuotes" select="count(.//following::tei:quote)"></xsl:variable>
                        <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalQuotes - $totalFollowingQuotes)"/>
                        <sctap:quotes rdf:resource="http://scta.info/resource/quotation/{$quoteID}"/>
                        <sctap:hasQuote rdf:resource="http://scta.info/text/{$cid}/quote/{$objectId}"/>
                     </xsl:for-each>
                  
                  <!-- three types of refs; default is "quotation" and does not need to be declared, 
                      "passage" refers to passage that is not a sentences commentary section
                      "commentary" refers to sentences commentary unit. If commentary unit requires target which is SCTA Url -->
                  
                  <!-- type="commentary" is non sentences commentary passage -->
                  <xsl:for-each select="document($extraction-file)//tei:body//tei:ref[@type='commentary']">
                    <xsl:variable name="commentarySectionUrl" select="./@target"></xsl:variable>
                    <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
                    <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
                    <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalRefs - $totalFollowingRefs)"/>
                    <sctap:references rdf:resource="{$commentarySectionUrl}"/>
                    <sctap:hasRef rdf:resource="http://scta.info/text/{$cid}/ref/{$objectId}"/>
                  </xsl:for-each>
                  <!-- type="passage" is non sentences commentary passage -->
                  <xsl:for-each select="document($extraction-file)//tei:body//tei:ref[@type='passage']">
                    <xsl:variable name="passageRef" select="./@ana"></xsl:variable>
                    <xsl:variable name="passageID" select="substring-after($passageRef, '#')"></xsl:variable>
                    <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
                    <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
                    <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalRefs - $totalFollowingRefs)"/>
                    <sctap:references rdf:resource="http://scta.info/resource/passage/{$passageID}"/>
                    <sctap:hasRef rdf:resource="http://scta.info/text/{$cid}/ref/{$objectId}"/>
                  </xsl:for-each>
                  <!-- default is ref referring to quotation resource or type="quotation" -->  
                  <xsl:for-each select="document($extraction-file)//tei:body//tei:ref[@ana] | document($extraction-file)//tei:body//tei:ref[@type='quotation']">
                    <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
                    <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
                    <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
                    <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
                    <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalRefs - $totalFollowingRefs)"/>
                    <sctap:references rdf:resource="http://scta.info/resource/quotation/{$quoteID}"/>
                    <sctap:hasRef rdf:resource="http://scta.info/text/{$cid}/ref/{$objectId}"/>
                  </xsl:for-each>
                  <!-- END of name, title, quotation, ref resource reference for item level-->
                   
                  <!-- BEGIN record status -->
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
                  <!-- END record status -->
                  
                  <!-- BEGIN recording exmeplar paragraphs per item -->
                  <xsl:for-each select="document($extraction-file)//tei:body//tei:p">
                    <xsl:if test="./@xml:id">
                      <sctap:hasParagraphExemplar rdf:resource="http://scta.info/text/{$cid}/paragraph/{@xml:id}"/>
                    </xsl:if>
                  </xsl:for-each>
                  <!-- END record paragraph per item -->
                   
                  <!-- BEGIN test for witnesses and transcriptions -->
                  
                  <xsl:variable name="canonical-slug" select="substring-before(tokenize($extraction-file, '/')[last()], '.xml')"></xsl:variable>
                  <sctap:hasCanonicalTranscription rdf:resource="http://scta.info/text/{$cid}/transcription/{$canonical-slug}"/>     
                  
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
              
              <!-- END Item resource creation -->
              <!-- BEGIN Div resource creation -->
              
              <xsl:for-each  select="document($extraction-file)//tei:body/tei:div//tei:div">
                <xsl:if test="./@xml:id">
                <xsl:variable name="divisionID" select="./@xml:id"/>
                <xsl:variable name="divisionType" select="./@type"/>
                <rdf:Description rdf:about="http://scta.info/text/{$cid}/{$divisionType}/{$divisionID}">
                  <rdf:type rdf:resource="http://scta.info/resource/{$divisionType}"/>
                  <dcterms:isPartOf rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                  
                  <!-- BEGIN collect questionTitles from division heaer -->
                  <xsl:choose>
                    <xsl:when test="./tei:head/@type='questionTitle'">
                      <sctap:questionTitle><xsl:value-of select="./tei:head[@type='questionTitle']"/></sctap:questionTitle>
                    </xsl:when>
                    <xsl:when test="./tei:head/tei:seg/@type='questionTitle'">
                      <sctap:questionTitle><xsl:value-of select="./tei:head/tei:seg[@type='questionTitle']"/></sctap:questionTitle>
                    </xsl:when>
                  </xsl:choose>
                  <!-- END collect questionTitles from divisions headers -->
                  
                  <!-- BEGIN collect paragraph exemplars -->
                  <xsl:for-each select=".//tei:p">
                    <xsl:if test="./@xml:id">
                      <sctap:hasParagraphExemplar rdf:resource="http://scta.info/text/{$cid}/paragraph/{@xml:id}"/>
                    </xsl:if>
                  </xsl:for-each>
                  <!-- END collect paragraph exemplars -->
                  
                  <xsl:for-each select="document($info-path)//div[@xml:id=$divisionID]/assertions//assertion">
                    <!-- this ideal is to include the full rdf stament int he info file and then coppy it
                      but not working because namespace is still added-->
                    <!-- <xsl:copy-of copy-namespaces="no" select="."/> -->
                    <!-- below is an unappy substitute for the time being -->
                    <xsl:choose>
                      <xsl:when test="./@property eq 'abbreviates'">
                        <xsl:variable name="target" select="./@target"></xsl:variable>
                        <sctap:abbreviates rdf:resource="{$target}"/>
                      </xsl:when>
                      <xsl:when test="./@property eq 'abbreviatedBy'">
                        <xsl:variable name="target" select="./@target"></xsl:variable>
                        <sctap:abbreviatedBy rdf:resource="{$target}"/>
                      </xsl:when>
                      <xsl:when test="./@property eq 'referencedBy'">
                        <xsl:variable name="target" select="./@target"></xsl:variable>
                        <sctap:referencedBy rdf:resource="{$target}"/>
                      </xsl:when>
                    </xsl:choose>
                    
                  </xsl:for-each>
                  
                </rdf:Description>
                </xsl:if>
              </xsl:for-each>
              <!-- END Div resource creation -->
              
              <!-- BEGIN exemplar paragraph resource creation -->
                <!-- note that exemplar paragraph paragraph relationship should be analogous the Item/Transcription relationship -->
              <xsl:variable name="itemWitnesses" select="./hasWitnesses/witness"/>
              <xsl:for-each select="document($extraction-file)//tei:body//tei:p">
                <!-- only creates paragraph resource if that paragraph has been assigned an id -->
                <xsl:if test="./@xml:id">
                  <xsl:variable name="pid" select="./@xml:id"/>
                  <xsl:variable name="pid_ref" select="concat('#', ./@xml:id)"/>
                  <rdf:Description rdf:about="http://scta.info/text/{$cid}/paragraph/{$pid}">
                    <dc:title>Paragraph <xsl:value-of select="$pid"/></dc:title>
                    <rdf:type rdf:resource="http://scta.info/resource/paragraphExemplar"/>
                    <dcterms:isPartOf rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                    <xsl:if test="document($text-path)">
                      <sctap:hasTranscription rdf:resource="http://scta.info/text/{$cid}/transcription/{$fs}/paragraph/{$pid}"/>
                    </xsl:if>
                    <xsl:for-each select="$itemWitnesses">
                      <xsl:variable name="wit-ref"><xsl:value-of select="substring-after(./@ref, '#')"/></xsl:variable>
                      <xsl:variable name="wit-slug"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/slug"/></xsl:variable>
                      <xsl:variable name="transcription-slug" select="concat($wit-slug, '_', $fs)"/>
                      <sctap:hasTranscription rdf:resource="http://scta.info/text/{$cid}/transcription/{$transcription-slug}/paragraph/{$pid}"/>
                    </xsl:for-each>
                   
                    <!-- BEGIN collection of info assertions -->
                    <!--  note info.xml is not in Tei namespace -->
                    <xsl:for-each select="document($info-path)//p[@xml:id=$pid]/assertions//assertion">
                      <!-- this ideal is to include the full rdf stament int he info file and then coppy it
                      but not working because namespace is still added-->
                      <!-- <xsl:copy-of copy-namespaces="no" select="."/> -->
                      <!-- below is an unappy substitute for the time being -->
                      <xsl:choose>
                        <xsl:when test="./@property eq 'abbreviates'">
                          <xsl:variable name="target" select="./@target"></xsl:variable>
                          <sctap:abbreviates rdf:resource="{$target}"/>
                        </xsl:when>
                        <xsl:when test="./@property eq 'abbreviatedBy'">
                          <xsl:variable name="target" select="./@target"></xsl:variable>
                          <sctap:abbreviatedBy rdf:resource="{$target}"/>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:for-each>
                   
                    
                    <!-- order -->
                    <xsl:variable name="paragraphnumber"><xsl:value-of select="count(document($extraction-file)//tei:body//tei:p) - count(document($extraction-file)//tei:body//tei:p[preceding::tei:p[@xml:id=$pid]])"/></xsl:variable>
                    <sctap:paragraphNumber><xsl:value-of select="$paragraphnumber"/></sctap:paragraphNumber>
                    <!-- next -->
                    <xsl:variable name="nextpid" select="document($extraction-file)//tei:p[@xml:id=$pid]/following::tei:p[1]/@xml:id"/>
                    <sctap:next rdf:resource="http://scta.info/text/{$cid}/paragraph/{$nextpid}"/>
                    
                    <!-- previous -->
                    <xsl:variable name="previouspid" select="document($extraction-file)//tei:p[@xml:id=$pid]/preceding::tei:p[1]/@xml:id"/>
                    <sctap:previous rdf:resource="http://scta.info/text/{$cid}/paragraph/{$previouspid}"/>
                    
                    <!-- cts urn creation for paragraphs -->
                    <xsl:variable name="paragraph-dtsurn"><xsl:value-of select="concat($item-dtsurn, '.', $paragraphnumber)"/></xsl:variable>
                    <sctap:dtsurn rdf:about="{$paragraph-dtsurn}"></sctap:dtsurn>
                    <!-- end of dts number creation -->
                    
                    <!-- begin level creation -->
                    <sctap:level><xsl:value-of select="$item-level + 1"/></sctap:level>
                    <!-- end level creation -->
                    
                    <!-- references/referencedBy; loop over references in paragraph themselves.  -->
                    <!-- quotes -->
                    <!-- note this is fairly redundant. I believe this is the third time this block of code is used. Needs to be called as a template, but I can't quite figure out how -->
                    <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:name[@ref]">
                      <xsl:variable name="nameRef" select="./@ref"></xsl:variable>
                      <xsl:variable name="nameID" select="substring-after($nameRef, '#')"></xsl:variable>
                      <xsl:variable name="totalNames" select="count(document($extraction-file)//tei:body//tei:name)"/>
                      <xsl:variable name="totalFollowingNames" select="count(.//following::tei:name)"></xsl:variable>
                      <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalNames - $totalFollowingNames)"/>
                      <sctap:mentions rdf:resource="http://scta.info/resource/person/{$nameID}"/>
                      <sctap:hasName rdf:resource="http://scta.info/text/{$cid}/name/{$objectId}"/>
                    </xsl:for-each>
                    <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:title[@ref]">
                      <xsl:variable name="titleRef" select="./@ref"></xsl:variable>
                      <xsl:variable name="titleID" select="substring-after($titleRef, '#')"></xsl:variable>
                      <xsl:variable name="totalTitles" select="count(document($extraction-file)//tei:body//tei:title)"/>
                      <xsl:variable name="totalFollowingTitles" select="count(.//following::tei:title)"></xsl:variable>
                      <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalTitles - $totalFollowingTitles)"/>
                      <sctap:mentions rdf:resource="http://scta.info/resource/work/{$titleID}"/>
                      <sctap:hasTitle rdf:resource="http://scta.info/text/{$cid}/title/{$objectId}"/>
                    </xsl:for-each>
                    <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:quote[@ana]">
                      <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
                      <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
                      <xsl:variable name="totalQuotes" select="count(document($extraction-file)//tei:body//tei:quote)"/>
                      <xsl:variable name="totalFollowingQuotes" select="count(.//following::tei:quote)"></xsl:variable>
                      <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalQuotes - $totalFollowingQuotes)"/>
                      <sctap:quotes rdf:resource="http://scta.info/resource/quotation/{$quoteID}"/>
                      <sctap:hasQuote rdf:resource="http://scta.info/text/{$cid}/quote/{$objectId}"/>
                    </xsl:for-each>
                    <!-- three types of refs; default is "quotation" and does not need to be declared, 
                      "passage" refers to passage that is not a sentences commentary section
                      "commentary" refers to sentences commentary unit. If commentary unit requires target which is SCTA Url -->
                    
                    <!-- type="commentary" is non sentences commentary passage -->
                    <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:ref[@type='commentary']">
                      <xsl:variable name="commentarySectionUrl" select="./@target"></xsl:variable>
                      <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
                      <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
                      <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalRefs - $totalFollowingRefs)"/>
                      <sctap:references rdf:resource="{$commentarySectionUrl}"/>
                      <sctap:hasRef rdf:resource="http://scta.info/text/{$cid}/ref/{$objectId}"/>
                    </xsl:for-each>
                    <!-- type="passage" is non sentences commentary passage -->
                    <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:ref[@type='passage']">
                      <xsl:variable name="passageRef" select="./@ana"></xsl:variable>
                      <xsl:variable name="passageID" select="substring-after($passageRef, '#')"></xsl:variable>
                      <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
                      <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
                      <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalRefs - $totalFollowingRefs)"/>
                      <sctap:references rdf:resource="http://scta.info/resource/passage/{$passageID}"/>
                      <sctap:hasRef rdf:resource="http://scta.info/text/{$cid}/ref/{$objectId}"/>
                    </xsl:for-each>
                    <!-- default is ref referring to quotation resource or type="quotation" -->  
                    <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:ref[@ana] | document($extraction-file)//tei:p[@xml:id=$pid]//tei:ref[@type='quotation']">
                      <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
                      <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
                      <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
                      <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
                      <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalRefs - $totalFollowingRefs)"/>
                      <sctap:references rdf:resource="http://scta.info/resource/quotation/{$quoteID}"/>
                      <sctap:hasRef rdf:resource="http://scta.info/text/{$cid}/ref/{$objectId}"/>
                    </xsl:for-each>
                    
                    <!--- end of logging name, title, quote, and ref asserts for paragraph examplar -->
                    
                  </rdf:Description>
                </xsl:if>
              </xsl:for-each>
              
              <!-- end exemplar paragraph resource creation -->
              
                
              <!-- begin create element resources creation -->
                <xsl:for-each select="document($extraction-file)//tei:body//tei:name[@ref]">
                    <xsl:variable name="nameRef" select="@ref"/>
                    <xsl:variable name="nameID" select="substring-after($nameRef, '#')"/>
                    <xsl:variable name="totalNames" select="count(document($extraction-file)//tei:body//tei:name)"/>
                    <xsl:variable name="totalFollowingNames" select="count(.//following::tei:name)"></xsl:variable>
                    <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalNames - $totalFollowingNames)"/>
                    <xsl:variable name="paragraphParent" select=".//preceding::tei:paragraph[@xml:id]"/>
                    <rdf:Description rdf:about="http://scta.info/text/{$cid}/name/{$objectId}">
                        <rdf:type rdf:resource="http://scta.info/resource/nameElement"/>
                        <sctap:isInstanceOf rdf:resource="http://scta.info/resource/person/{$nameID}"/>
                        <sctap:elementText><xsl:value-of select="."/></sctap:elementText>
                        <sctap:isPartOfItem rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                        <sctap:isPartOfParagraph rdf:resource="http://scta.info/text/{$cid}/paragraph/{$paragraphParent}"/>
                    </rdf:Description>
                </xsl:for-each>
                <xsl:for-each select="document($extraction-file)//tei:body//tei:title[@ref]">
                    <xsl:variable name="titleRef" select="./@ref"></xsl:variable>
                    <xsl:variable name="titleID" select="substring-after($titleRef, '#')"></xsl:variable>
                    <xsl:variable name="totalTitles" select="count(document($extraction-file)//tei:body//tei:title)"/>
                    <xsl:variable name="totalFollowingTitles" select="count(.//following::tei:title)"></xsl:variable>
                    <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalTitles - $totalFollowingTitles)"/>
                    <xsl:variable name="paragraphParent" select=".//preceding::tei:paragraph[@xml:id]"/>
                    <rdf:Description rdf:about="http://scta.info/text/{$cid}/title/{$objectId}">
                        <rdf:type rdf:resource="http://scta.info/resource/titleElement"/>
                        <sctap:isInstanceOf rdf:resource="http://scta.info/resource/work/{$titleID}"/>
                        <sctap:elementText><xsl:value-of select="."/></sctap:elementText>
                        <sctap:isPartOfItem rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                        <sctap:isPartOfParagraph rdf:resource="http://scta.info/text/{$cid}/paragraph/{$paragraphParent}"/>
                    </rdf:Description>
                </xsl:for-each>
                <xsl:for-each select="document($extraction-file)//tei:body//tei:quote[@ana]">
                    <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
                    <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
                    <xsl:variable name="totalQuotes" select="count(document($extraction-file)//tei:body//tei:quote)"/>
                    <xsl:variable name="totalFollowingQuotes" select="count(.//following::tei:quote)"></xsl:variable>
                    <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalQuotes - $totalFollowingQuotes)"/>
                    <xsl:variable name="paragraphParent" select=".//preceding::tei:paragraph[@xml:id]"/>
                    <rdf:Description rdf:about="http://scta.info/text/{$cid}/quote/{$objectId}">
                        <rdf:type rdf:resource="http://scta.info/resource/quoteElement"/>
                        <sctap:isInstanceOf rdf:resource="http://scta.info/resource/quotation/{$quoteID}"/>
                        <sctap:elementText><xsl:value-of select="."/></sctap:elementText>
                        <sctap:isPartOfItem rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                        <sctap:isPartOfParagraph rdf:resource="http://scta.info/text/{$cid}/paragraph/{$paragraphParent}"/>
                    </rdf:Description>
                </xsl:for-each>
              
              <!-- three types of refs; default is "quotation" and does not need to be declared, 
                      "passage" refers to passage that is not a sentences commentary section
                      "commentary" refers to sentences commentary unit. If commentary unit requires target which is SCTA Url -->
              <!-- first type="passage" -->
              <xsl:for-each select="document($extraction-file)//tei:body//tei:ref[@type='passage']">
                    <xsl:variable name="refRef" select="./@ana"></xsl:variable>
                    <xsl:variable name="refID" select="substring-after($refRef, '#')"></xsl:variable>
                    <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
                    <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
                    <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalRefs - $totalFollowingRefs)"/>
                    <xsl:variable name="paragraphParent" select=".//preceding::tei:paragraph[@xml:id]"/>
                    <rdf:Description rdf:about="http://scta.info/text/{$cid}/ref/{$objectId}">
                        <rdf:type rdf:resource="http://scta.info/resource/refElement"/>
                        <sctap:isInstanceOf rdf:resource="http://scta.info/resource/passage/{$refID}"/>
                        <sctap:elementText><xsl:value-of select="."/></sctap:elementText>
                        <sctap:isPartOfItem rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                        <sctap:isPartOfParagraph rdf:resource="http://scta.info/text/{$cid}/paragraph/{$paragraphParent}"/>
                    </rdf:Description>
              </xsl:for-each>
              <!-- default type="quotation" -->
              <xsl:for-each select="document($extraction-file)//tei:body//tei:ref[@ana] | document($extraction-file)//tei:body//tei:ref[@type='quotation']">
                <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
                <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
                <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
                <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
                <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-', $totalRefs - $totalFollowingRefs)"/>
                <xsl:variable name="paragraphParent" select=".//preceding::tei:paragraph[@xml:id]"/>
                <rdf:Description rdf:about="http://scta.info/text/{$cid}/ref/{$objectId}">
                  <rdf:type rdf:resource="http://scta.info/resource/refElement"/>
                  <sctap:isInstanceOf rdf:resource="http://scta.info/resource/quotation/{$quoteID}"/>
                  <sctap:elementText><xsl:value-of select="."/></sctap:elementText>
                  <sctap:isPartOfItem rdf:resource="http://scta.info/text/{$cid}/item/{$fs}"/>
                  <sctap:isPartOfParagraph rdf:resource="http://scta.info/text/{$cid}/paragraph/{$paragraphParent}"/>
                </rdf:Description>
              </xsl:for-each>
              <!-- resource creation for Sentences Commentary passage is not needed -->        
              <!-- end create element resources -->
              
              <!-- begin create critical transcription resource -->
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
                          <!-- note distinction between has Paragraph which belongs to "transcriptions" and "hasParagraphExemplar" which is proper to the conceptual hierarchy, items in particular-->
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
                                <sctap:isParagraphTranscriptionOf rdf:resource="http://scta.info/text/{$cid}/paragraph/{$pid}"/>
                                <sctap:xmltext rdf:resource="https://bitbucket.org/jeffreycwitt/{$fs}/raw/master/{$fs}.xml#{$pid}"/>
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
                                    <sctap:isParagraphTranscriptionOf rdf:resource="http://scta.info/text/{$cid}/paragraph/{$pid}"/>
                                    <sctap:plaintext rdf:resource="http://text.scta.info/plaintext/{$cid}/{$fs}/transcription/{$wit-slug}/paragraph/{$pid}"/>
                                    <xsl:for-each select="document($transcription-text-path)/tei:TEI/tei:facsimile//tei:zone[@start=$pid_ref]">
                                        <xsl:variable name="position" select="if (./@n) then ./@n else 1"/>
                                        <sctap:hasZone rdf:resource="http://scta.info/text/{$cid}/zone/{$wit-slug}_{$fs}/paragraph/{$pid}/{$position}"/>
                                    </xsl:for-each>
                                  <sctap:xmltext rdf:resource="https://bitbucket.org/jeffreycwitt/{$fs}/raw/master/{$wit-slug}_{$fs}.xml#{$pid}"/>
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