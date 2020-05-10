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
  
  <xsl:template name="manifestation_zones">
    <xsl:param name="wit-slug"></xsl:param>
    <xsl:variable name="pid" select="./@xml:id"/>
    <!-- conditional texts to see if document somewhere contains line breaks 
        it assumes that a line break is present this is a diplomatic transcription 
        this should help exclude critical and born digital transcriptions -->
    <xsl:if test="//tei:lb">
      <xsl:choose>
        <xsl:when test="./descendant::tei:cb and not(./descendant::tei:pb)">
          
          <xsl:variable name="firstPbWithDash" select="./preceding::tei:pb[1]/@n"/>
          <xsl:variable name="firstPb" select="replace($firstPbWithDash, '-', '')"/>
          <xsl:variable name="secondPbWithDash" select="./preceding::tei:pb[1]/@n"/>
          <xsl:variable name="secondPb" select="replace($secondPbWithDash, '-', '')"/>
          <xsl:variable name="column" select="./descendant::tei:cb[1]/@n"/>
          <xsl:variable name="firstSurfaceShortId" select="concat($wit-slug, '/', $firstPb)"/>
          <xsl:variable name="secondSurfaceShortId" select="concat($wit-slug, '/', $secondPb)"/>
          <xsl:variable name="zoneOnelines" select="./descendant::tei:lb[not(parent::tei:reg)][following::tei:cb[1][@n=$column]]"/>
          <xsl:variable name="zoneTwolines" select="./descendant::tei:lb[not(parent::tei:reg)][preceding::tei:cb[1][@n=$column]]"/>
          
          <rdf:Description rdf:about="http://scta.info/resource/{$firstSurfaceShortId}/{$pid}/1">
            <sctap:isPartOfSurface rdf:resource="http://scta.info/resource/{$firstSurfaceShortId}"/>
            <!-- 
                test tries checks if paragraph starts on a new line by 
                by checking for text node that is not blank that precedes the first line break -->
            
            <xsl:variable name="precedingLine">
              <xsl:choose>
                <xsl:when test="normalize-space(./descendant::tei:lb[1]/preceding-sibling::node()[1]) != ''">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:for-each select="$zoneOnelines">
              <xsl:call-template name="line-creation">
                <!--<xsl:with-param name="previousRegion" select="$previousRegion"/>-->
                <xsl:with-param name="surfaceShortId" select="$firstSurfaceShortId"/>
                <xsl:with-param name="precedingLine" select="$precedingLine"/>
              </xsl:call-template>
            </xsl:for-each>
          </rdf:Description>
          
          <rdf:Description rdf:about="http://scta.info/resource/{$secondSurfaceShortId}/{$pid}/2">
            <sctap:isPartOfSurface rdf:resource="http://scta.info/resource/{$secondSurfaceShortId}"/>
            <xsl:for-each select="$zoneTwolines">
              <xsl:call-template name="line-creation">
                <!--<xsl:with-param name="previousRegion" select="$previousRegion"/>-->
                <xsl:with-param name="surfaceShortId" select="$secondSurfaceShortId"/>
              </xsl:call-template>
            </xsl:for-each>
          </rdf:Description>
        </xsl:when>
        <xsl:when test="./descendant::tei:pb">
          
          <xsl:variable name="firstPbWithDash" select="./preceding::tei:pb[1]/@n"/>
          <xsl:variable name="firstPb" select="replace($firstPbWithDash, '-', '')"/>
          <xsl:variable name="secondPbWithDash" select="./descendant::tei:pb[1]/@n"/>
          <xsl:variable name="secondPb" select="replace($secondPbWithDash, '-', '')"/>
          <xsl:variable name="firstSurfaceShortId" select="concat($wit-slug, '/', $firstPb)"/>
          <xsl:variable name="secondSurfaceShortId" select="concat($wit-slug, '/', $secondPb)"/>
          <xsl:variable name="zoneOnelines" select="./descendant::tei:lb[not(parent::tei:reg)][following::tei:pb[@n=$secondPbWithDash]]"/>
          <xsl:variable name="zoneTwolines" select="./descendant::tei:lb[not(parent::tei:reg)][preceding::tei:pb[@n=$secondPbWithDash]]"/>
          
          <rdf:Description rdf:about="http://scta.info/resource/{$firstSurfaceShortId}/{$pid}/1">
            <sctap:isPartOfSurface rdf:resource="http://scta.info/resource/{$firstSurfaceShortId}"/>
            <!-- 
                test tries checks if paragraph starts on a new line by 
                by checking for text node that is not blank that precedes the first line break -->
            
            <xsl:variable name="precedingLine">
              <xsl:choose>
                <xsl:when test="normalize-space(./descendant::tei:lb[1]/preceding-sibling::node()[1]) != ''">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:for-each select="$zoneOnelines">
              <xsl:call-template name="line-creation">
                <!--<xsl:with-param name="previousRegion" select="$previousRegion"/>-->
                <xsl:with-param name="surfaceShortId" select="$firstSurfaceShortId"/>
                <xsl:with-param name="precedingLine" select="$precedingLine"/>
              </xsl:call-template>
            </xsl:for-each>
          </rdf:Description>
          
          <rdf:Description rdf:about="http://scta.info/resource/{$secondSurfaceShortId}/{$pid}/2">
            <sctap:isPartOfSurface rdf:resource="http://scta.info/resource/{$secondSurfaceShortId}"/>
            <xsl:for-each select="$zoneTwolines">
              <xsl:call-template name="line-creation">
                <!--<xsl:with-param name="previousRegion" select="$previousRegion"/>-->
                <xsl:with-param name="surfaceShortId" select="$secondSurfaceShortId"/>
              </xsl:call-template>
            </xsl:for-each>
          </rdf:Description>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="firstPbWithDash" select="./preceding::tei:pb[1]/@n"/>
          <xsl:variable name="firstPb" select="replace($firstPbWithDash, '-', '')"/>
          
          <!-- xpath condition handles case where no line break is contained within element and then looks for last preceding line
            or looks for all lines within the target element -->
          
          <!-- CHECK/TODO there is a slightly different end result here.
            when there is no line, it is NOT treated as a partial line (though it seems like it should be) 
            thus we get: 
          
              <rdf:Description rdf:about="http://scta.info/resource/vat/5v/l1-Qssrsdh/1">
                <sctap:isPartOfSurface rdf:resource="http://scta.info/resource/vat/5v"/>
                <sctap:firstLine>7</sctap:firstLine>
                <sctap:hasZone rdf:resource="http://scta.info/resource/vat/5v/7"/>
                <sctap:lastLine>7</sctap:lastLine>
             </rdf:Description>
           
           Here firstLine matches the hasZone.
           
           But when the parent zone has with a partial line, at present it doesn't contain it as a zone. 
           
           For example: 
           
           <rdf:Description rdf:about="http://scta.info/resource/vat/5v/l1-Qlsedlt/1">
              <sctap:isPartOfSurface rdf:resource="http://scta.info/resource/vat/5v"/>
              <sctap:hasZone rdf:resource="http://scta.info/resource/vat/5v/8"/>
              <sctap:firstLine>8</sctap:firstLine>
              <sctap:hasPartialFirstLine>true</sctap:hasPartialFirstLine>
              <sctap:hasZone rdf:resource="http://scta.info/resource/vat/5v/9"/>
              <sctap:lastLine>9</sctap:lastLine>
           </rdf:Description>
           
          At present it doesn't seem to be cause to many problems, but it is an inconsistency that could cause problems
          --> 
            
          <xsl:variable name="zoneOnelines" select="if (not(./descendant::tei:lb)) 
            then ./preceding::tei:lb[1]
            else ./descendant::tei:lb[not(parent::tei:reg)]"/>
          
          <xsl:variable name="firstSurfaceShortId" select="concat($wit-slug, '/', $firstPb)"/>
          
          <rdf:Description rdf:about="http://scta.info/resource/{$firstSurfaceShortId}/{$pid}/1">
            <sctap:isPartOfSurface rdf:resource="http://scta.info/resource/{$firstSurfaceShortId}"/>
            <!-- 
                test tries checks if paragraph starts on a new line by 
                by checking for text node that is not blank that precedes the first line break -->
            
            <xsl:variable name="precedingLine">
              <xsl:choose>
                <xsl:when test="normalize-space(./descendant::tei:lb[1]/preceding-sibling::node()[1]) != ''">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:for-each select="$zoneOnelines">
              <xsl:call-template name="line-creation">
                <!--<xsl:with-param name="previousRegion" select="$previousRegion"/>-->
                <xsl:with-param name="surfaceShortId" select="$firstSurfaceShortId"/>
                <xsl:with-param name="precedingLine" select="$precedingLine"/>
              </xsl:call-template>
            </xsl:for-each>
          </rdf:Description>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="line-creation">
    <xsl:param name="surfaceShortId"/>
    <xsl:param name="precedingLine"/>
    <!-- gets lines following the current page break -->
    <xsl:variable name="followingPageBreak" select="count(./preceding::tei:pb[1]//following::tei:lb[not(parent::tei:reg)])"/>
    <!-- gets line following the current line break  -->
    <xsl:variable name="followingLineBreak" select="count(.//following::tei:lb[not(parent::tei:reg)])"/>
    <xsl:variable name="pbNumber" select="./preceding::tei:pb[1]/@n"/>
    <xsl:variable name="lineNumber">
      <xsl:choose>
        <xsl:when test="not(./preceding::tei:pb[1][ancestor::tei:body])">
          <xsl:variable name="lineCount" select="$followingPageBreak - $followingLineBreak"/>
          <xsl:variable name="startline">
            <xsl:choose>
              <xsl:when test="//tei:body//following::tei:lb[1]/@n">
                <!-- get all line that have a number and are in the first position -->
                <xsl:variable name="firstLineNumbers" select="//tei:body//following::tei:lb[1]/@n"/>
                <!-- gets the first line in new list which should be the first line in the document -->
                <xsl:value-of select="$firstLineNumbers[1]"/>
              </xsl:when>
              <!-- if it can't find a number it defaults to first line or 1 -->
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:value-of select="$lineCount + $startline - 1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$followingPageBreak - $followingLineBreak"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="position() = 1">
      <xsl:choose>
        <xsl:when test="$precedingLine eq 'true'">
          <sctap:hasZone rdf:resource="http://scta.info/resource/{$surfaceShortId}/{$lineNumber - 1}"/>
          <sctap:firstLine><xsl:value-of select="$lineNumber - 1"/></sctap:firstLine>
          <sctap:hasPartialFirstLine>true</sctap:hasPartialFirstLine>
        </xsl:when>
        <xsl:otherwise>
          <sctap:firstLine><xsl:value-of select="$lineNumber"/></sctap:firstLine>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <sctap:hasZone rdf:resource="http://scta.info/resource/{$surfaceShortId}/{$lineNumber}"/>
    
    <xsl:if test="position() = last()">
      <sctap:lastLine><xsl:value-of select="$lineNumber"/></sctap:lastLine>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>