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
  
  
  
  
  <xsl:template name="structure_item_manifestation_transcription_alignment">
    <xsl:param name="repo-path"/>
    <xsl:param name="itemWitnesses"/>
    <xsl:param name="canonical-manifestation-id"/>
    <xsl:param name="canonical-filename-slug"/>
    <xsl:param name="itemid"/>
    <xsl:variable name="transcription-file" select="concat($repo-path, 'transcriptions.xml')"/>
    <xsl:variable name="listedManifestations" select="document($transcription-file)/list//manifestation"/>
    
    <manifestations>
      <!-- check if default value is in list; if not added it to possible manifestations -->
      <xsl:for-each select="$itemWitnesses">
        
        <xsl:variable name="wit-ref"><xsl:value-of select="substring-after(./@ref, '#')"/></xsl:variable>
        <xsl:variable name="wit-slug"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/slug"/></xsl:variable>
        <xsl:variable name="wit-title"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/title"/></xsl:variable>
        <xsl:if test="not($listedManifestations//name=$wit-slug)">
          <manifestation wit-ref="{$wit-ref}" wit-slug="{$wit-slug}" wit-title="{$wit-title}" lang="la" canonical="{$wit-slug eq $canonical-manifestation-id}">
            <xsl:if test="document(concat($repo-path, $wit-slug, '_', $itemid, '.xml'))">
              <transcriptions>
                <transcription transcriptionDefault="true">
                  <type>diplomatic</type>
                  <version versionDefault="true">
                    <hash>transcription</hash>
                    <versionNo n="dev">head-dev</versionNo>
                    <url><xsl:value-of select="concat($wit-slug, '_', $itemid , '.xml')"/></url>                    
                  </version>
                </transcription>
              </transcriptions>
            </xsl:if>
            <xsl:for-each select="./folio">
              <folio><xsl:value-of select="."/></folio>
            </xsl:for-each>
          </manifestation>
        </xsl:if>
      </xsl:for-each>
      <!-- check if default value is in list; if not added it to possible manifestations -->
      <xsl:if test="not($listedManifestations//name='critical') and document(concat($repo-path, $itemid, '.xml'))">
        <manifestation wit-ref="CE" wit-slug="critical" wit-title="Critical" lang="la" canonical="{$canonical-manifestation-id eq 'critical'}">
          <name>critical</name>
          <title>Critical</title>
          <transcriptions>
            <transcription transcriptionDefault="true">
              <type>critical</type>
              <version versionDefault="true">
                <hash>transcription</hash>
                <versionNo n="dev">head-dev</versionNo>
                <url><xsl:value-of select="concat($itemid , '.xml')"/></url>                
              </version>
            </transcription>
          </transcriptions>
        </manifestation>
      </xsl:if>
      <!-- add all manifestations from transcription file to possible manifestations list-->
      <xsl:for-each select="$listedManifestations">
        <xsl:variable name="language" select="if (./language) then ./language else 'la'">
          
        </xsl:variable>
        <manifestation wit-ref="XX" wit-slug="{./name}" wit-title="{./title}" lang="{$language}" canonical="{./@manifestationDefault eq 'true'}">
          <xsl:copy-of select="./transcriptions"/>
          <!-- get initial for manifestation in EDF in order to extract folios if they exist -->
          <xsl:variable name="witnessInitial">
            <xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[slug=./name]/@id"/>
          </xsl:variable>
          <xsl:for-each select="$itemWitnesses/witness[@ref=$witnessInitial]//folio">
            <folio><xsl:value-of select="."/></folio>
          </xsl:for-each>
        </manifestation>
      </xsl:for-each>
    </manifestations>
  </xsl:template>
</xsl:stylesheet>