<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="2.0" 
  xmlns:utils="http://utility/functions"
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  
  <!-- location of text file for crawling -->
  <xsl:param name="textfilesbase">/Users/jcwitt/Projects/scta/scta-texts/</xsl:param>
  
  
  <xsl:variable name="commentaryname"><xsl:value-of select="//header/commentaryName"/></xsl:variable>
  <xsl:variable name="cid"><xsl:value-of select="//header/commentaryid"/></xsl:variable>
  <xsl:variable name="commentaryslug"><xsl:value-of select="//header/commentaryslug"/></xsl:variable>
  <xsl:variable name="author-uri"><xsl:value-of select="//header/authorUri"/></xsl:variable>
  
  <xsl:variable name="textfilesdir"><xsl:value-of select="$textfilesbase"/><xsl:value-of select="$cid"/>/</xsl:variable>
  
  <xsl:variable name="gitRepoBase">
    <xsl:choose>
      <xsl:when test="//header/gitRepoBase">
        <xsl:value-of select="//header/gitRepoBase"/>
      </xsl:when>
      <xsl:otherwise>https://bitbucket.org/jeffreycwitt/</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- git repo style records if there is a "toplevel" git repo for the entire work, or "single" for each item --> 
  <xsl:variable name="gitRepoStyle">
    <xsl:choose>
      <xsl:when test="//header/gitRepoBase/@type">
        <xsl:value-of select="//header/gitRepoBase/@type"/>
      </xsl:when>
      <xsl:otherwise>single</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="dtsurn"><xsl:value-of select="concat('urn:dts:latinLit:sentences', '.', $cid)"/></xsl:variable>
  
  <xsl:variable name="sponsors" select="//header/sponsors"/>
  <xsl:variable name="description" select="if (//header/description) then //header/description else 'No Description Available'"/>
  <xsl:variable name="canoncial-top-level-manifestation" select="//header/canonical-top-level-manifestation"/>
  
  <xsl:variable name="top-level-witnesses" select="/listofFileNames/header/hasWitnesses/witness"/>
  
  <xsl:variable name="parentWorkGroup">
    <xsl:choose>
      <xsl:when test="//header/parentWorkGroup">
        <xsl:value-of select="//header/parentWorkGroup"/>
      </xsl:when>
      <xsl:otherwise>http//scta.info/resource/sententia</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:include href="utility_functions.xsl"/>
  <xsl:output method="xml" indent="yes"/>
  
  <!-- root template -->
  <xsl:template match="/">
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
      xmlns:sctar="http://scta.info/resource/" 
      xmlns:sctap="http://scta.info/property/" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:role="http://www.loc.gov/loc.terms/relators/" 
      xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
      xmlns:collex="http://www.collex.org/schema#" 
      xmlns:dcterms="http://purl.org/dc/terms/" 
      xmlns:dc="http://purl.org/dc/elements/1.1/"
      xmlns:ldp="http://www.w3.org/ns/ldp#">
      <xsl:call-template name="top_level_expression">
        <xsl:with-param name="commentaryname" select="$commentaryname"/>
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="commentaryslug" select="$commentaryslug"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
        <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
        <xsl:with-param name="parentWorkGroup" select="$parentWorkGroup"/>
        <xsl:with-param name="description" select="$description"/>
        <xsl:with-param name="sponsors" select="$sponsors"/>
        <xsl:with-param name="canoncial-top-level-manifestation" select="$canoncial-top-level-manifestation"/>
      </xsl:call-template>
      <xsl:call-template name="top_level_manifestation">
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
        <xsl:with-param name="top-level-witnesses" select="$top-level-witnesses"/>
      </xsl:call-template>
      <xsl:call-template name="top_level_transcription">
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
      </xsl:call-template>
      <xsl:call-template name="sponsors">
        <xsl:with-param name="sponsors" select="$sponsors"/>
      </xsl:call-template>
      <xsl:call-template name="structure_collection_expressions">
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
        <xsl:with-param name="canoncial-top-level-manifestation" select="$canoncial-top-level-manifestation"/>
      </xsl:call-template>
      <xsl:call-template name="structure_collection_manifestations">
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
      </xsl:call-template>
      <xsl:call-template name="structure_collection_transcriptions">
        <xsl:with-param name="cid" select="$cid"/>
        <xsl:with-param name="author-uri" select="$author-uri"/>
      </xsl:call-template>
      
      <!-- begin item level param retrieve and template calls -->
      <!-- TODO some of the DIV calls could be consolidated in this way -->
      <!-- IT's ideal to be getting the required params once and then using them in many templates rather than re-retrieving params for each template -->
      <xsl:for-each select=".//item">
        <xsl:result-document method="xml" href="{fileName/@filestem}.rdf">
          
          <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:sctar="http://scta.info/resource/"
            xmlns:sctap="http://scta.info/property/"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:role="http://www.loc.gov/loc.terms/relators/"
            xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
            xmlns:collex="http://www.collex.org/schema#"
            xmlns:dcterms="http://purl.org/dc/terms/"
            xmlns:dc="http://purl.org/dc/elements/1.1/"
            xmlns:ldp="http://www.w3.org/ns/ldp#"
            xmlns:utils="http://utility/functions"
            xmlns:tei="http://www.tei-c.org/ns/1.0">
            
        <!-- TODO go through variable and see what is being used and delete what is not being used -->
        <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
        <xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>
        <xsl:variable name="expressionType"><xsl:value-of select="@type"/></xsl:variable>
        <xsl:variable name="bookParent"><xsl:value-of select="./ancestor::div[@type='librum']/@id"/></xsl:variable>
        <xsl:variable name="distinctionParent"><xsl:value-of select="./parent::div/@id"/></xsl:variable>
        <xsl:variable name="text-path" select="concat($textfilesdir, $fs, '/', $fs, '.xml')"/>
        <xsl:variable name="repo-path" select="concat($textfilesdir, $fs, '/')"/>
        <xsl:variable name="extraction-file">
          <xsl:choose>
            <xsl:when test="document(concat($repo-path, 'transcriptions.xml'))/manifestation[@manifestationDefault='true']/transcriptions/transcription[@transcriptionDefault='true']/version[@versionDefault='true']/url">
              <xsl:value-of select="concat($repo-path, document(concat($repo-path, 'transcriptionsNew.xml'))/manifestation[@manifestationDefault='true']/transcriptions/transcription[@transcriptionDefault='true']/version[@versionDefault='true']/url)"/>
            </xsl:when>
            <xsl:when test="document(concat($repo-path, 'transcriptions.xml'))/transcriptions/transcription[@use-for-extraction='true']">
              <xsl:value-of select="concat($repo-path, document(concat($repo-path, 'transcriptions.xml'))/transcriptions/transcription[@use-for-extraction='true'])"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$text-path"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
            
            
          
        <xsl:variable name="info-path" select="concat($repo-path, 'info.xml')"/>
        <xsl:variable name="totalnumber"><xsl:number count="item" level="any"/></xsl:variable>
        <xsl:variable name="sectionnumber"><xsl:number count="item"/></xsl:variable>
        <xsl:variable name="librum-number"><xsl:number count="div[@type='librum']"/></xsl:variable>
        <xsl:variable name="distinctio-number"><xsl:number count="div[@type='distinctio']"/></xsl:variable>
        <xsl:variable name="pars-number"><xsl:number count="div[@type='pars']"/></xsl:variable>
        <xsl:variable name="item-ancestors" select="ancestor::div"/>
        <xsl:variable name="item-level" select="count($item-ancestors) + 1"/>
        <!--<xsl:variable name="item-level" select="count(ancestor::*)"/>-->
        
        <xsl:variable name="expressionParentId" select="./parent::div/@id"/>
        <!-- TODO decideif item-dtsurn is desired -->
        <xsl:variable name="item-dtsurn">
          <xsl:variable name="divcount"><xsl:number count="div[not(@id='body')]" level="multiple" format="1"/></xsl:variable>
          <xsl:value-of select="concat($dtsurn, ':', $divcount, '.i', $totalnumber)"/>
        </xsl:variable>
        
        <xsl:variable name="canonical-filename-slug" select="substring-before(tokenize($extraction-file, '/')[last()], '.xml')"></xsl:variable>
        <xsl:variable name="canonical-manifestation-id">
          <xsl:choose>
            <xsl:when test="contains($canonical-filename-slug, '_')">
              <xsl:value-of select="substring-before($canonical-filename-slug, '_')"/>
            </xsl:when>
            <!-- TODO: not ideal to be hard coding critical here. what if there were more than on critical manifestation -->
            <xsl:otherwise>critical</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="itemWitnesses" select="./hasWitnesses/witness"/>
        
        <!-- create manifestation transcription alignment from combination of EDF and item level transcriptions.xml files -->
        <xsl:variable name="manifestations">
          <xsl:call-template name="structure_item_manifestation_transcription_alignment">
            <xsl:with-param name="repo-path" select="$repo-path"></xsl:with-param>
            <xsl:with-param name="itemWitnesses" select="$itemWitnesses"></xsl:with-param>
            <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"></xsl:with-param>
            <xsl:with-param name="canonical-filename-slug" select="$canonical-filename-slug"/>
            <xsl:with-param name="itemid" select="$fs"/>
          </xsl:call-template>
        </xsl:variable>
            
        <xsl:call-template name="structure_item_expressions">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="author-uri" select="$author-uri"/>
          <xsl:with-param name="dtsurn" select="$dtsurn"/>
          <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
          <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
          <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
          <!-- required item level params -->
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="title" select="$title"/>
          <xsl:with-param name="info-path" select="$info-path"/>
          <xsl:with-param name="item-ancestors" select="$item-ancestors"/>
          <xsl:with-param name="item-level" select="$item-level"/>
          <xsl:with-param name="expressionParentId" select="$expressionParentId"/>
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        </xsl:call-template>
        <xsl:call-template name="structure_division_expressions">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="author-uri" select="$author-uri"/>
          <xsl:with-param name="dtsurn" select="$dtsurn"/>
          <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
          <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
          <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
          <!-- required item level params -->
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="title" select="$title"/>
          <xsl:with-param name="info-path" select="$info-path"/>
          <xsl:with-param name="item-level" select="$item-level"/>
          <xsl:with-param name="item-ancestors" select="$item-ancestors"/>
          
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          
          <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        </xsl:call-template>
        <xsl:call-template name="structure_block_expressions">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="author-uri" select="$author-uri"/>
          <xsl:with-param name="dtsurn" select="$dtsurn"/>
          <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
          <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
          <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
          <!-- required item level params -->
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="title" select="$title"/>
          <xsl:with-param name="info-path" select="$info-path"/>
          <xsl:with-param name="item-level" select="$item-level"/>
          <xsl:with-param name="item-ancestors" select="$item-ancestors"/>
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        </xsl:call-template>
        <xsl:call-template name="structure_element_name_expressions">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="author-uri" select="$author-uri"/>
          <xsl:with-param name="dtsurn" select="$dtsurn"/>
          <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
          <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
          <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
          <!-- required item level params -->
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="title" select="$title"/>
          <xsl:with-param name="item-level" select="$item-level"/>
          <xsl:with-param name="expressionParentId" select="$expressionParentId"/>
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        </xsl:call-template>
        <xsl:call-template name="structure_element_title_expressions">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="author-uri" select="$author-uri"/>
          <xsl:with-param name="dtsurn" select="$dtsurn"/>
          <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
          <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
          <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
          <!-- required item level params -->
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="title" select="$title"/>
          <xsl:with-param name="item-level" select="$item-level"/>
          <xsl:with-param name="expressionParentId" select="$expressionParentId"/>
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        </xsl:call-template>
        <xsl:call-template name="structure_element_quote_expressions">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="author-uri" select="$author-uri"/>
          <xsl:with-param name="dtsurn" select="$dtsurn"/>
          <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
          <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
          <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
          <!-- required item level params -->
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="title" select="$title"/>
          <xsl:with-param name="item-level" select="$item-level"/>
          <xsl:with-param name="item-ancestors" select="$item-ancestors"/>
          <xsl:with-param name="expressionParentId" select="$expressionParentId"/>
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        </xsl:call-template>
        <xsl:call-template name="structure_element_ref_expressions">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="author-uri" select="$author-uri"/>
          <xsl:with-param name="dtsurn" select="$dtsurn"/>
          <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
          <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
          <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
          <!-- required item level params -->
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="title" select="$title"/>
          <xsl:with-param name="item-level" select="$item-level"/>
          <xsl:with-param name="expressionParentId" select="$expressionParentId"/>
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        </xsl:call-template>
        <xsl:call-template name="structure_item_manifestations">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="author-uri" select="$author-uri"/>
          <xsl:with-param name="dtsurn" select="$dtsurn"/>
          <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
          <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
          <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
          <!-- required item level params -->
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="title" select="$title"/>
          <xsl:with-param name="item-level" select="$item-level"/>
          <xsl:with-param name="expressionParentId" select="$expressionParentId"/>
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        </xsl:call-template>
        <xsl:call-template name="structure_item_transcriptions">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="author-uri" select="$author-uri"/>
          <xsl:with-param name="dtsurn" select="$dtsurn"/>
          <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
          <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
          <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
          <!-- required item level params -->
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="title" select="$title"/>
          <xsl:with-param name="item-level" select="$item-level"/>
          <xsl:with-param name="expressionParentId" select="$expressionParentId"/>
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="repo-path" select="$repo-path"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        </xsl:call-template>
        <xsl:call-template name="structure_division_manifestations">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="author-uri" select="$author-uri"/>
          <xsl:with-param name="dtsurn" select="$dtsurn"/>
          <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
          <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
          <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
          <!-- required item level params -->
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="title" select="$title"/>
          <xsl:with-param name="item-level" select="$item-level"/>
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="repo-path" select="$repo-path"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        </xsl:call-template>
        <xsl:call-template name="structure_division_transcriptions">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="author-uri" select="$author-uri"/>
          <xsl:with-param name="dtsurn" select="$dtsurn"/>
          <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
          <xsl:with-param name="repo-path" select="$repo-path"/>
          <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
          <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
          <!-- required item level params -->
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="title" select="$title"/>
          <xsl:with-param name="item-level" select="$item-level"/>
          
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        </xsl:call-template>
        <xsl:call-template name="structure_block_manifestations">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="author-uri" select="$author-uri"/>
          <xsl:with-param name="dtsurn" select="$dtsurn"/>
          <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
          <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
          <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
          <!-- required item level params -->
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="title" select="$title"/>
          <xsl:with-param name="item-level" select="$item-level"/>
          <xsl:with-param name="repo-path" select="$repo-path"/>
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        </xsl:call-template>
        <xsl:call-template name="structure_block_transcriptions">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="author-uri" select="$author-uri"/>
          <xsl:with-param name="dtsurn" select="$dtsurn"/>
          <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
          <xsl:with-param name="repo-path" select="$repo-path"/>
          <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
          <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
          <!-- required item level params -->
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="title" select="$title"/>
          <xsl:with-param name="item-level" select="$item-level"/>
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        </xsl:call-template>
        <xsl:call-template name="marginal_note_manifestations">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
        </xsl:call-template>
        <xsl:call-template name="structure_element_quote_manifestations">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
        </xsl:call-template>
        <xsl:call-template name="zones">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="repo-path" select="$repo-path"/>
        </xsl:call-template>
          </rdf:RDF>
        </xsl:result-document>
      </xsl:for-each>
      <!--<xsl:apply-templates/>-->
    </rdf:RDF>
  </xsl:template>
  <xsl:include href="top_level_expression.xsl"/>
  <xsl:include href="top_level_manifestation.xsl"/>
  <xsl:include href="top_level_transcription.xsl"/>
  <xsl:include href="sponsors.xsl"/>
  <xsl:include href="structure_collection_expressions.xsl"/>
  <xsl:include href="structure_collection_manifestations.xsl"/>
  <xsl:include href="structure_collection_transcriptions.xsl"/>
  <xsl:include href="structure_item_expressions.xsl"/>
  <xsl:include href="structure_item_manifestations.xsl"/>
  <xsl:include href="structure_item_manifestation_transcription_alignment.xsl"/>
  <xsl:include href="structure_item_transcriptions.xsl"/>
  <xsl:include href="structure_division_expressions.xsl"/>
  <xsl:include href="structure_division_manifestations.xsl"/>
  <xsl:include href="structure_division_transcriptions.xsl"/>
  <xsl:include href="structure_block_expressions.xsl"/>
  <xsl:include href="structure_block_manifestations.xsl"/>
  <xsl:include href="structure_block_transcriptions.xsl"/>
  <xsl:include href="marginal_note_manifestations.xsl"/>
  <xsl:include href="structure_element_name_expressions.xsl"/>
  <xsl:include href="structure_element_title_expressions.xsl"/>
  <xsl:include href="structure_element_quote_expressions.xsl"/>
  <xsl:include href="structure_element_ref_expressions.xsl"/>
  <xsl:include href="structure_element_quote_manifestations.xsl"/>
  <xsl:include href="zones.xsl"/>
  
  
  <xsl:include href="global_properties.xsl"/>
  <xsl:include href="expression_properties.xsl"/>
  <xsl:include href="manifestation_properties.xsl"/>
  <xsl:include href="transcription_properties.xsl"/>
  
  <xsl:include href="structure_collection_properties.xsl"/>
  <xsl:include href="structure_item_properties.xsl"/>
  <xsl:include href="structure_division_properties.xsl"/>
  <xsl:include href="structure_block_properties.xsl"/>
  <xsl:include href="structure_element_properties.xsl"/>
  
  <!--<xsl:include href="expression_properties.xsl"/>-->
  
  
  
  
  
  <!-- templates to delete unwanted elements -->
  <!--<xsl:template match="header"></xsl:template>-->
  
  <!-- begin resource creation for top level expression -->  
  <!--<xsl:template match="//div[@id='body']">-->
    
  <!--</xsl:template>-->
</xsl:stylesheet>