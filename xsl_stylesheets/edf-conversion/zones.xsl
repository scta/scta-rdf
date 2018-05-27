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
  
  <xsl:template name="zones">
    <xsl:param name="cid"/>
    <xsl:param name="manifestations"/>
    <xsl:param name="fs"/>
    
    <xsl:for-each select="$manifestations//manifestation">
      <!-- required item level manifestation params -->
      <xsl:variable name="wit-slug" select="./@wit-slug"/>
      <xsl:variable name="wit-title" select="./@wit-title"/>
      <xsl:variable name="transcriptions" select="./transcriptions"/>
      <xsl:variable name="transcription-text-path" select="$transcriptions/transcription[@canonical='true']/@transcription-text-path"/>
      
      
        
        <xsl:if test="document($transcription-text-path)/tei:TEI/tei:facsimile">
          <xsl:for-each select="document($transcription-text-path)/tei:TEI/tei:facsimile//tei:zone">
            <xsl:variable name="imagefilename" select="./preceding-sibling::tei:graphic/@url"/>
            <xsl:variable name="canvasname" select="substring-before($imagefilename, '.')"/>
            <!-- this is not a good way to do this; this whole section needs to be written -->
            <!-- right now I'm trying to just go the folio number without the preceding sigla -->
            <!-- not this will fail if there is Sigla that reads Ar15r; the first "r" will not be removed and the result will be r15r -->
            <xsl:variable name="folioname" select="translate($canvasname, 'ABCDEFGHIJKLMNOPQRSTUVabcdefghijklmnopqstuwxyz', '') "/>
            
            <!-- <xsl:variable name="foliosideurl" select="concat('http://scta.info/resource/material', $commentaryslug, '-', $wit-slug, '/', $folioname)"/> -->
            <!-- changed to... --> <!-- this will mess up anywhere were codex ids are identical such as "sorb" and "sorb" and "vat" and "vat" which I believe is only a problem with Wodeham and Plaoul -->
            <xsl:variable name="surfaceShortId" select="concat($wit-slug, '/', $folioname)"/>
            <xsl:variable name="foliosideurl" select="concat('http://scta.info/resource/', $wit-slug, '/', $folioname)"/>
            
            <xsl:variable name="pid" select="translate(./@start, '#', '')"/>
            <!--<xsl:variable name="canvasid">
              <xsl:choose>
                <xsl:when test="./ancestor::tei:surface/@select">
                  <xsl:variable name="witessid" select="translate(./ancestor::tei:surface/@ana, '#', '')"></xsl:variable>
                  <xsl:variable name="canvasbase" select="//witness[@xml:id=$witessid]/@xml:base"></xsl:variable>
                  <xsl:variable name="canvas-slug" select="./ancestor::tei:surface/@select"></xsl:variable>
                  <xsl:value-of select="concat($canvasBase, $canvas-slug)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat('http://scta.info/iiif/', $commentaryslug, '-', $wit-slug, '/canvas/', $canvasname)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>-->
            
            <xsl:variable name="ulx" select="./@ulx"/>
            <xsl:variable name="uly" select="./@uly"/>
            <xsl:variable name="lrx" select="./@lrx"/>
            <xsl:variable name="lry" select="./@lry"/>
            <xsl:variable name="width"><xsl:value-of select="$lrx - $ulx"/></xsl:variable>
            <xsl:variable name="height"><xsl:value-of select="$lry - $uly"/></xsl:variable>
            <xsl:variable name="position" select="if (./@n) then ./@n else 1"/>
        
        
        
        
        <xsl:call-template name="zones_entry">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="wit-slug" select="$wit-slug"/>
          
          <xsl:with-param name="pid" select="$pid"/>
          <xsl:with-param name="foliosideurl" select="$foliosideurl"/>
          <xsl:with-param name="ulx" select="$ulx"/>
          <xsl:with-param name="uly" select="$uly"/>
          <xsl:with-param name="lrx" select="$lrx"/>
          <xsl:with-param name="lry" select="$lry"/>
          <xsl:with-param name="width" select="$width"/>
          <xsl:with-param name="height" select="$height"/>
          <xsl:with-param name="position" select="$position"/>
          <xsl:with-param name="surfaceShortId" select="$surfaceShortId"/>
          
          
        </xsl:call-template>
          </xsl:for-each>
        </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="zones_entry">
    <xsl:param name="cid"/>
    <xsl:param name="wit-slug"/>
    
    <xsl:param name="fs"/>
    <!-- p level params -->
    <xsl:param name="pid"/>
    <xsl:param name="marginal-note-id"/>
    <xsl:param name="surface"/>
    
    <xsl:param name="foliosideurl"/>
    <xsl:param name="ulx"/>
    <xsl:param name="uly"/>
    <xsl:param name="lrx"/>
    <xsl:param name="lry"/>
    <xsl:param name="width"/>
    <xsl:param name="height"/>
    <xsl:param name="position"/>
    <xsl:param name="surfaceShortId"/>
    
    
        
        <!-- TODO: simplify zone url -->
    <rdf:Description rdf:about="http://scta.info/resource/{$surfaceShortId}/{$ulx}{$uly}{$lrx}{$lry}">
          <dc:title>Canvas zone for <xsl:value-of select="$wit-slug"/>_<xsl:value-of select="$fs"/> paragraph <xsl:value-of select="$pid"/></dc:title>
          <rdf:type rdf:resource="http://scta.info/resource/zone"/>
          <sctar:zoneType>general</sctar:zoneType>
          <!-- problem here with slug since iiif slug is prefaced with pg or pp etc -->
          <!--<sctap:isZoneOf rdf:resource="http://scta.info/resource/{$pid}/{$wit-slug}/transcription"/>-->
          <!-- to be deleted <sctap:isZoneOn rdf:resource="{$canvasid}"/> -->
          <sctap:isPartOfSurface rdf:resource="{$foliosideurl}"/>
          <dc:isPartOf rdf:resource="{$foliosideurl}"/>
          <sctap:ulx><xsl:value-of select="$ulx"/></sctap:ulx>
          <sctap:uly><xsl:value-of select="$uly"/></sctap:uly>
          <sctap:lrx><xsl:value-of select="$lrx"/></sctap:lrx>
          <sctap:lry><xsl:value-of select="$lry"/></sctap:lry>
          <sctap:width><xsl:value-of select="$width"/></sctap:width>
          <sctap:height><xsl:value-of select="$height"/></sctap:height>
          <sctap:position><xsl:value-of select="$position"/></sctap:position>
        </rdf:Description>
      
    
  </xsl:template>
</xsl:stylesheet>