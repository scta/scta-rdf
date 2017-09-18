<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  xmlns:sctap="http://scta.info/property/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
  xmlns:sctar="http://scta.info/resource/" 
  xmlns:role="http://www.loc.gov/loc.terms/relators/" 
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
  xmlns:collex="http://www.collex.org/schema#" 
  xmlns:dcterms="http://purl.org/dc/terms/" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:ldp="http://www.w3.org/ns/ldp#"
  version="2.0">
  
  <xsl:template name="structure_block_expressions">
    <xsl:param name="cid"/>
    <xsl:param name="author-uri"/>
    <xsl:param name="dtsurn"/>
    <xsl:param name="textfilesdir"/>
    <xsl:param name="gitRepoStyle"/>
    <xsl:param name="gitRepoBase"/>
    <!-- item level params -->
    <xsl:param name="fs"/>
    <xsl:param name="title"/>
    <xsl:param name="item-level"/>
    <xsl:param name="expressionParentId"/>
    <xsl:param name="extraction-file"/>
    <xsl:param name="info-path"/>
    <xsl:param name="expressionType"/>
    <xsl:param name="sectionnumber"/>
    <xsl:param name="totalnumber"/>
    <xsl:param name="text-path"/>
    <xsl:param name="itemWitnesses"/>
    <xsl:param name="manifestations"/>
    <xsl:param name="translationManifestations"/>
    <xsl:param name="canonical-manifestation-id"/>
    
    
      
        <xsl:for-each select="document($extraction-file)//tei:body//tei:p">
          <!-- only creates paragraph resource if that paragraph has been assigned an id -->
          <xsl:if test="./@xml:id">
            <xsl:variable name="pid" select="./@xml:id"/>
            <xsl:variable name="pid_ref" select="concat('#', ./@xml:id)"/>
          
          <xsl:call-template name="structure_block_expressions_entry">
            <xsl:with-param name="fs" select="$fs"/>
            <xsl:with-param name="title" select="$title"/>
            <xsl:with-param name="item-level" select="$item-level"/>
            <xsl:with-param name="cid" select="$cid"/>
            <xsl:with-param name="expressionParentId" select="$expressionParentId"/>
            <xsl:with-param name="author-uri" select="$author-uri"/>
            <xsl:with-param name="extraction-file" select="$extraction-file"/>
            <xsl:with-param name="expressionType" select="$expressionType"/>
            <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
            <xsl:with-param name="totalnumber" select="$totalnumber"/>
            <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
            <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
            <xsl:with-param name="text-path" select="$text-path"/>
            <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
            <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
            <xsl:with-param name="manifestations" select="$manifestations"/>
            <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
            <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
            <xsl:with-param name="info-path" select="$info-path"/>
            <xsl:with-param name="pid" select="$pid"/>
            
          </xsl:call-template>
          </xsl:if>
        </xsl:for-each>
    
  </xsl:template>
  <xsl:template name="structure_block_expressions_entry">
    <xsl:param name="fs"/>
    <xsl:param name="title"/>
    <xsl:param name="item-level"/>
    <xsl:param name="cid"/>
    
    <xsl:param name="expressionParentId"/>
    <xsl:param name="author-uri"/>
    <xsl:param name="extraction-file"/>
    <xsl:param name="expressionType"/>
    <xsl:param name="sectionnumber"/>
    <xsl:param name="totalnumber"/>
    <xsl:param name="gitRepoStyle"/>
    <xsl:param name="gitRepoBase"/>
    <xsl:param name="text-path"/>
    <xsl:param name="itemWitnesses"/>
    <xsl:param name="textfilesdir"/>
    <xsl:param name="manifestations"/>
    <xsl:param name="translationManifestations"/>
    <xsl:param name="canonical-manifestation-id"/>
    <xsl:param name="info-path"/>
    <xsl:param name="pid"/>
    
    <rdf:Description rdf:about="http://scta.info/resource/{$pid}">
          <dc:title>Paragraph <xsl:value-of select="$pid"/></dc:title>
          <rdf:type rdf:resource="http://scta.info/resource/expression"/>
          
          <!-- TODO: had dcterms:isPartOf that points to the immediate parent resource, mostly likely structureType=structureDivision but could be structureType=structureItem -->
          
          <sctap:isPartOfStructureItem rdf:resource="http://scta.info/resource/{$fs}"/>
          <sctap:isPartOfTopLevelExpression rdf:resource="http://scta.info/resource/{$cid}"/>
          <sctap:structureType rdf:resource="http://scta.info/resource/structureBlock"/>
          <sctap:shortId><xsl:value-of select="$pid"/></sctap:shortId>
          
          <!-- indicate status of expression at structureBlock Level -->
          <!-- NOTE: this block is getting used several times; it should be refactored into a function -->
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
          <!-- end indicate status -->
          
          <!-- get manifestation for critical edition -->
          <!-- TODO Delete this comment out section which has been replaced by the three line block below -->
          
      <!--<xsl:if test="document($text-path)">
            <sctap:hasManifestation rdf:resource="http://scta.info/resource/{$pid}/critical"/>
          </xsl:if>
          <xsl:for-each select="$itemWitnesses">
            <xsl:variable name="wit-ref"><xsl:value-of select="substring-after(./@ref, '#')"/></xsl:variable>
            <xsl:variable name="wit-slug"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/slug"/></xsl:variable>
            <xsl:variable name="transcription-slug" select="concat($wit-slug, '_', $fs)"/>
            <sctap:hasManifestation rdf:resource="http://scta.info/resource/{$pid}/{$wit-slug}"/>
          </xsl:for-each>
      -->
      <xsl:for-each select="$manifestations//manifestation">
        <sctap:hasManifestation rdf:resource="http://scta.info/resource/{$pid}/{./@wit-slug}"/>
      </xsl:for-each>
      
      <xsl:for-each select="$translationManifestations">
        <sctap:hasTranslation rdf:resource="http://scta.info/resource/{$pid}/{.}"/>
      </xsl:for-each>
          
          <sctap:hasCanonicalManifestation rdf:resource="http://scta.info/resource/{$pid}/{$canonical-manifestation-id}"/>
          
          
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
              <xsl:when test="./@property eq 'isRelatedTo'">
                <xsl:variable name="target" select="./@target"></xsl:variable>
                <sctap:isRelatedTo rdf:resource="{$target}"/>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
          
          
          <!-- order -->
          <xsl:variable name="paragraphnumber"><xsl:value-of select="count(document($extraction-file)//tei:body//tei:p) - count(document($extraction-file)//tei:body//tei:p[preceding::tei:p[@xml:id=$pid]])"/></xsl:variable>
          <sctap:paragraphNumber><xsl:value-of select="$paragraphnumber"/></sctap:paragraphNumber>
          <!-- next -->
          <xsl:variable name="nextpid" select="document($extraction-file)//tei:p[@xml:id=$pid]/following::tei:p[1]/@xml:id"/>
          <sctap:next rdf:resource="http://scta.info/resource/{$nextpid}"/>
          
          <!-- previous -->
          <xsl:variable name="previouspid" select="document($extraction-file)//tei:p[@xml:id=$pid]/preceding::tei:p[1]/@xml:id"/>
          <sctap:previous rdf:resource="http://scta.info/resource/{$previouspid}"/>
          
          <!-- TODO: decide if dts urn is worth the trouble here
              <xsl:variable name="div-number"><xsl:number count="tei:div[parent::*[not(name()='body')]]" level="multiple" format="1"/></xsl:variable>
              <xsl:variable name="paragraph-dtsurn">
                <xsl:choose>
                  <xsl:when test="document($extraction-file)//tei:body/tei:div//tei:div">
                    <xsl:value-of select="concat($item-dtsurn, '.', $div-number, '.p', $paragraphnumber)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="concat($item-dtsurn, '.p', $paragraphnumber)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
                
              <sctap:dtsurn><xsl:value-of select="$paragraph-dtsurn"/></sctap:dtsurn>
              
              end of dts number creation 
              -->
          
          <!-- begin level creation -->
          <sctap:level><xsl:value-of select="$item-level + 1"/></sctap:level>
          <!-- end level creation -->
          
          <!-- references/referencedBy; loop over references in paragraph themselves.  -->
          <!-- quotes -->
          
          <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:name">
            <xsl:variable name="nameRef" select="./@ref"></xsl:variable>
            <xsl:variable name="nameID" select="substring-after($nameRef, '#')"></xsl:variable>
            <xsl:variable name="totalNames" select="count(document($extraction-file)//tei:body//tei:name)"/>
            <xsl:variable name="totalFollowingNames" select="count(.//following::tei:name)"></xsl:variable>
            <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-N-', $totalNames - $totalFollowingNames)"/>
            <xsl:if test="$nameRef">
              <sctap:mentions rdf:resource="http://scta.info/resource/{$nameID}"/>
            </xsl:if>
            <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$objectId}"/>
          </xsl:for-each>
          <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:title">
            <xsl:variable name="titleRef" select="./@ref"></xsl:variable>
            <xsl:variable name="titleID" select="substring-after($titleRef, '#')"></xsl:variable>
            <xsl:variable name="totalTitles" select="count(document($extraction-file)//tei:body//tei:title)"/>
            <xsl:variable name="totalFollowingTitles" select="count(.//following::tei:title)"></xsl:variable>
            <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-T-', $totalTitles - $totalFollowingTitles)"/>
            <xsl:if test="$titleRef">
              <sctap:mentions rdf:resource="http://scta.info/resource/{$titleID}"/>
            </xsl:if>
            <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$objectId}"/>
            
          </xsl:for-each>
          <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:quote[contains(./@source, 'http://scta.info/resource')]">
            <xsl:variable name="commentarySectionUrl" select="./@source"></xsl:variable>
            <xsl:variable name="totalQuotes" select="count(document($extraction-file)//tei:body//tei:quote)"/>
            <xsl:variable name="totalFollowingQuotes" select="count(.//following::tei:quote)"></xsl:variable>
            <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-Q-', $totalQuotes - $totalFollowingQuotes)"/>
            <sctap:quotes rdf:resource="{$commentarySectionUrl}"/>
            <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$objectId}"/>
          </xsl:for-each>
          <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:quote">
            <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
            <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
            <xsl:variable name="totalQuotes" select="count(document($extraction-file)//tei:body//tei:quote)"/>
            <xsl:variable name="totalFollowingQuotes" select="count(.//following::tei:quote)"></xsl:variable>
            <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-Q-', $totalQuotes - $totalFollowingQuotes)"/>
            <xsl:if test="$quoteRef">
              <sctap:quotes rdf:resource="http://scta.info/resource/{$quoteID}"/>
            </xsl:if>
            <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$objectId}"/>
          </xsl:for-each>
          
          <!-- [not(ancestor::tei:bibl] excludes references made in bibl elements -->
          <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:ref[contains(./@target,'http://scta.info/resource')][not(ancestor::tei:bibl)]">
            <xsl:variable name="commentarySectionUrl" select="./@target"></xsl:variable>
            <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
            <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
            <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-R-', $totalRefs - $totalFollowingRefs)"/>
            <sctap:references rdf:resource="{$commentarySectionUrl}"/>
            <sctap:hasStructureElement rdf:resource="http://scta.info/resource{$objectId}"/>
          </xsl:for-each>
          
          <!-- default is ref referring to quotation resource or type="quotation" -->  
          <xsl:for-each select="document($extraction-file)//tei:p[@xml:id=$pid]//tei:ref">
            <xsl:variable name="quoteRef" select="./@ana"></xsl:variable>
            <xsl:variable name="quoteID" select="substring-after($quoteRef, '#')"></xsl:variable>
            <xsl:variable name="totalRefs" select="count(document($extraction-file)//tei:body//tei:ref)"/>
            <xsl:variable name="totalFollowingRefs" select="count(.//following::tei:ref)"></xsl:variable>
            <xsl:variable name="objectId" select="if (./@xml:id) then ./@xml:id else concat($fs, '-R-', $totalRefs - $totalFollowingRefs)"/>
            <xsl:if test="$quoteRef">
              <sctap:references rdf:resource="http://scta.info/resource/{$quoteID}"/>
            </xsl:if>
            <sctap:hasStructureElement rdf:resource="http://scta.info/resource/{$objectId}"/>
          </xsl:for-each>
          
          <!--- end of logging name, title, quote, and ref asserts for paragraph examplar -->
          
          <!-- create ldn inbox -->
          <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/{$pid}"/>
        </rdf:Description>
  </xsl:template>
  
</xsl:stylesheet>