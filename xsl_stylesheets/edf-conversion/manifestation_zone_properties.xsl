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
  <xsl:template name="manifestation_zone_properties">
    <xsl:param name="wit-slug"></xsl:param>
    <xsl:variable name="pid" select="./@xml:id"/>
    <!-- conditional texts to see if document somewhere contains line breaks 
        it assumes that a line break is present this is a diplomatic transcription 
        this should help exclude critical and born digital transcriptions -->
    <xsl:if test="//tei:lb">
      <!-- creates on or two zones based on presence of column break or line break -->
      <!-- TODO: this doesn't handle a case where three or more breaks might appear in a paragraph; (an unusual case, but it sometimes happens) -->
      <xsl:choose>
        <xsl:when test="./descendant::tei:cb and not(./descendant::tei:pb)">
          <xsl:variable name="firstPbWithDash" select="./preceding::tei:pb[1]/@n"/>
          <xsl:variable name="firstPb" select="replace($firstPbWithDash, '-', '')"/>
          <xsl:variable name="secondPbWithDash" select="./preceding::tei:pb[1]/@n"/>
          <xsl:variable name="secondPb" select="replace($secondPbWithDash, '-', '')"/>
          <xsl:variable name="column" select="./descendant::tei:cb[1]/@n"/>
          <xsl:variable name="firstSurfaceShortId" select="concat($wit-slug, '/', $firstPb)"/>
          <xsl:variable name="secondSurfaceShortId" select="concat($wit-slug, '/', $secondPb)"/>
          
          <sctap:isOnZone>
            <rdf:Description>
              <sctap:isOnZone rdf:resource="http://scta.info/resource/{$firstSurfaceShortId}/{$pid}/1"/>
              <sctap:isOnZoneOrder>1</sctap:isOnZoneOrder>
            </rdf:Description>
          </sctap:isOnZone>
          
          <sctap:isOnZone>
            <rdf:Description>
              <sctap:isOnZone rdf:resource="http://scta.info/resource/{$secondSurfaceShortId}/{$pid}/2"/>
              <sctap:isOnZoneOrder>2</sctap:isOnZoneOrder>
            </rdf:Description>
          </sctap:isOnZone>
        </xsl:when>
        <xsl:when test="./descendant::tei:pb">
          <xsl:variable name="firstPbWithDash" select="./preceding::tei:pb[1]/@n"/>
          <xsl:variable name="firstPb" select="replace($firstPbWithDash, '-', '')"/>
          <xsl:variable name="secondPbWithDash" select="./descendant::tei:pb[1]/@n"/>
          <xsl:variable name="secondPb" select="replace($secondPbWithDash, '-', '')"/>
          <xsl:variable name="firstSurfaceShortId" select="concat($wit-slug, '/', $firstPb)"/>
          <xsl:variable name="secondSurfaceShortId" select="concat($wit-slug, '/', $secondPb)"/>
          
          <sctap:isOnZone>
            <rdf:Description>
              <sctap:isOnZone rdf:resource="http://scta.info/resource/{$firstSurfaceShortId}/{$pid}/1"/>
              <sctap:isOnZoneOrder>1</sctap:isOnZoneOrder>
            </rdf:Description>
          </sctap:isOnZone>
          
          <sctap:isOnZone>
            <rdf:Description>
              <sctap:isOnZone rdf:resource="http://scta.info/resource/{$secondSurfaceShortId}/{$pid}/2"/>
              <sctap:isOnZoneOrder>2</sctap:isOnZoneOrder>
            </rdf:Description>
          </sctap:isOnZone>
          
        </xsl:when>
        <xsl:otherwise>
          
          <xsl:variable name="firstPbWithDash" select="./preceding::tei:pb[1]/@n"/>
          <xsl:variable name="firstPb" select="replace($firstPbWithDash, '-', '')"/>
          <xsl:variable name="zoneOnelines" select="./descendant::tei:lb[not(parent::tei:reg)]"/>
          <xsl:variable name="firstSurfaceShortId" select="concat($wit-slug, '/', $firstPb)"/>
          <!--<xsl:variable name="previousRegion">A</xsl:variable>
              <xsl:variable name="newPb" select="./preceding::tei:pb[1]/@n"/>
              <xsl:variable name="surfaceShortId" select="concat($wit-slug, '/', 'folionameAsVariable')"/>-->
          <sctap:isOnZone>
            <rdf:Description >
              <sctap:isOnZone rdf:resource="http://scta.info/resource/{$firstSurfaceShortId}/{$pid}/1"/>
              <sctap:isOnZoneOrder>1</sctap:isOnZoneOrder>
            </rdf:Description>
          </sctap:isOnZone>
          
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    
  </xsl:template>
</xsl:stylesheet>
