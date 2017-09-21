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
      
      <!-- begin item level param retrieve and template calls -->
      <!-- TODO some of the DIV calls could be consolidated in this way -->
      <!-- IT's ideal to be getting the required params once and then using them in many templates rather than re-retrieving params for each template -->
      <xsl:for-each select=".//item">
        <!-- TODO go through variable and see what is being used and delete what is not being used -->
        <xsl:variable name="fs"><xsl:value-of select="fileName/@filestem"/></xsl:variable>
        <xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>
        <xsl:variable name="expressionType"><xsl:value-of select="@type"/></xsl:variable>
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
        
        <xsl:variable name="AllTranscriptions" select="document(concat($repo-path, 'transcriptions.xml'))//transcription"/>
        <xsl:variable name="nonTranslationTranscriptions" select="document(concat($repo-path, 'transcriptions.xml'))//transcription[not(@type='translation')]"/>
        <xsl:variable name="translationTranscriptions" select="document(concat($repo-path, 'transcriptions.xml'))//transcription[@type='translation']"/>
        <xsl:variable name="translationManifestations" select="document(concat($repo-path, 'transcriptions.xml'))/transcriptions/translationManifestations//manifestation"/>
        
        <xsl:variable name="possibleManifestations">
          <manifestations>
            <xsl:for-each select="$itemWitnesses">
              <xsl:variable name="wit-ref"><xsl:value-of select="substring-after(./@ref, '#')"/></xsl:variable>
              <xsl:variable name="wit-slug"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/slug"/></xsl:variable>
              <xsl:variable name="wit-title"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/title"/></xsl:variable>
              
              <manifestation wit-ref="{$wit-ref}" wit-slug="{$wit-slug}" wit-title="{$wit-title}" lang="la" canonical="{$wit-slug eq $canonical-manifestation-id}">
                <xsl:for-each select="./folio">
                  <folio><xsl:value-of select="."/></folio>
                </xsl:for-each>
              </manifestation>
            </xsl:for-each>
            
            <manifestation wit-ref="CE" wit-slug="critical" wit-title="Critical" lang="la" canonical="{$canonical-manifestation-id eq 'critical'}"/>
            <xsl:for-each select="$translationManifestations">
              <xsl:variable name="translationManifestationSlug" select="./@name"/>
              <manifestation wit-slug="{$translationManifestationSlug}" wit-title="{./@title}" type="translation" lang="{./@lang}" canonical="false"/>
            </xsl:for-each>
          </manifestations>
        </xsl:variable>
        
        <xsl:variable name="manifestations">
          <manifestations>
          <xsl:for-each select="$possibleManifestations//manifestation">
            <manifestation wit-ref="{./@wit-ref}" wit-slug="{./@wit-slug}" wit-title="{./@wit-title}" lang="{./@lang}" canonical="{./@canonical}">
              <xsl:variable name="wit-slug" select="./@wit-slug"/>
             <transcriptions>
                <!--- logging all transcriptions that are listed in transcriptions.xml file that match a witness slug-->
                <xsl:for-each select="$AllTranscriptions[@isTranscriptionOf=$wit-slug]">
                  <xsl:variable name="transcription-text-path2" select="concat($textfilesdir, $fs, '/', .)"/>
                  <transcription hash="{./@hash}" name="{./@name}" canonical="{./@canonical}" type="{./@type}" transcription-text-path="{$transcription-text-path2}" hasSuccessor="{./@hasSuccessor}"/>
                </xsl:for-each>
                <!-- logging default diplomatic when file exists and no entry in transcription file exists -->
                <xsl:variable name="diplomatic-transcription-text-path" select="concat($textfilesdir, $fs, '/', ./@wit-slug, '_', $fs, '.xml')"/>
               
               <!-- Below this are trying to see if a default file exists that has not be overwrited by a transcripition element
                 the editional predicate @isTranscriptionOf is added because some transcription files exists that only indicate the extraction file
                 but should not be used as an override -->
                <xsl:if test="document($diplomatic-transcription-text-path) and not($AllTranscriptions[@isTranscriptionOf][text()=concat($wit-slug, '_', $fs, '.xml')])">
                  
                  <xsl:variable name="canonical">
                    <!-- check if a transcription for this manifestation has already been set as canonical -->
                    <xsl:choose>
                      <xsl:when test="$AllTranscriptions[@isTranscriptionOf=$wit-slug][@canonical='true']">false</xsl:when>
                      <xsl:otherwise>true</xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <transcription hash="head" name="transcription" canonical="{$canonical}" type="diplomatic" transcription-text-path="{$diplomatic-transcription-text-path}"/>  
                </xsl:if>
               
               <!-- Below this are trying to see if a default file exists that has not be overwrited by a transcripition element
                 the editional predicate @isTranscriptionOf is added because some transcription files exists that only indicate the extraction file
                 but should not be used as an override -->
               
               <!-- logging default critical when file exists and no entry in transcription file exists -->
                <xsl:variable name="critical-transcription-text-path" select="concat($textfilesdir, $fs, '/', $fs, '.xml')"/>
                <xsl:if test="$wit-slug='critical' and document($critical-transcription-text-path) and not($AllTranscriptions[@isTranscriptionOf][text()=concat($fs, '.xml')])">
                  <xsl:variable name="canonical">
                    <!-- check if a transcription for this manifestation has already been set as canonical -->
                    <xsl:choose>
                      <xsl:when test="$AllTranscriptions[@isTranscriptionOf=$wit-slug][@canonical='true']">false</xsl:when>
                      <xsl:otherwise>true</xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <transcription hash="head" name="transcription" canonical="{$canonical}" type="critical" transcription-text-path="{$critical-transcription-text-path}"/>  
                </xsl:if>
              </transcriptions>
              <xsl:for-each select="./folio">
                <folio><xsl:value-of select="."/></folio>
              </xsl:for-each>
            </manifestation>
          </xsl:for-each>
          </manifestations>
          
          <!-- below has been replaced by above -->
          <!--<manifestations>
            <xsl:for-each select="$itemWitnesses">
              <xsl:variable name="wit-ref"><xsl:value-of select="substring-after(./@ref, '#')"/></xsl:variable>
              <xsl:variable name="wit-slug"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/slug"/></xsl:variable>
              <xsl:variable name="wit-title"><xsl:value-of select="/listofFileNames/header/hasWitnesses/witness[@id=$wit-ref]/title"/></xsl:variable>
              <xsl:variable name="transcription-text-path" select="concat($textfilesdir, $fs, '/', $wit-slug, '_', $fs, '.xml')"/>
              <manifestation wit-ref="{$wit-ref}" wit-slug="{$wit-slug}" wit-title="{$wit-title}" lang="la">
                <transcriptions>
                  <!-\-\- logging all transcriptions that are listed in transcriptions.xml file that match a witness slug-\->
                  <xsl:for-each select="$nonTranslationTranscriptions">
                    <xsl:if test="./@isTranscriptionOf=$wit-slug">
                      <xsl:variable name="transcription-text-path2" select="concat($textfilesdir, $fs, '/', .)"/>
                      <transcription hash="{./@hash}" name="{./@name}" canonical="{./@canonical}" type="{./@type}" transcription-text-path="{$transcription-text-path2}" hasSuccessor="{./@hasSuccessor}"/>
                    </xsl:if>
                  </xsl:for-each>
                  <!-\- checking for default transcriptions based on file names in repo and that are not listed in transcription file-\->
                  <xsl:if test="document($transcription-text-path) and not($nonTranslationTranscriptions//transcription[text()=concat($wit-slug, '_', $fs, '.xml')])">
                    <transcription hash="head" name="transcription" canonical="true" type="diplomatic" transcription-text-path="{$transcription-text-path}"/>  
                  </xsl:if>
                </transcriptions>
                <xsl:for-each select="./folio">
                  <folio><xsl:value-of select="."/></folio>
                </xsl:for-each>
              </manifestation> 
            </xsl:for-each>
            <!-\- Note: here is a way of combining item witnesses with one or more default manifestations such a 'critical' manifestation -\->
            <!-\- if a file without a prefix exist in directory, we assume this is a transcription of a manifestation called 'critical',
            therefore a manifestation called critical is added to the overall list -\->
            <xsl:if test="document($text-path)">
              <manifestation wit-ref="CE" wit-slug="critical" wit-title="Critical" lang="la">
                <transcriptions>
                  <!-\-\- logging all transcriptions that are listed in transcriptions.xml file that match 'critical' slug -\->
                  <xsl:for-each select="$nonTranslationTranscriptions">
                    <xsl:if test="./@isTranscriptionOf='critical'">
                      <xsl:variable name="transcription-text-path2" select="concat($textfilesdir, $fs, '/', .)"/>
                      <transcription hash="{./@hash}" name="{./@name}" canonical="{./@canonical}" type="{./@type}" transcription-text-path="{$transcription-text-path2}" hasSuccessor="{./@hasSuccessor}"/>
                    </xsl:if>
                  </xsl:for-each>
                  <!-\- checking for default transcriptions based on file names in repo-\->
                  <xsl:if test="document($text-path) and not($nonTranslationTranscriptions//transcription[text()=concat($fs, '.xml')])">
                    <transcription hash="head" name="transcription" canonical="true" type="critical" transcription-text-path="{$text-path}"/>  
                  </xsl:if>
                </transcriptions>
              </manifestation>
            </xsl:if>
            <xsl:for-each select="$translationManifestations">
              <xsl:variable name="translationManifestationSlug" select="./@name"/>
              <manifestation wit-slug="{$translationManifestationSlug}" wit-title="{./@title}" type="translation" lang="{./@lang}">
                <transcriptions>
                  <xsl:for-each select="$translationTranscriptions">
                    <xsl:if test="./@isTranslationOf eq $translationManifestationSlug">
                      <xsl:variable name="translation-text-path" select="concat($textfilesdir, $fs, '/', .)"/>
                      <transcription hash="{./@hash}" name="{./@name}" canonical="{./@canonical}" type="translation" transcription-text-path="{$translation-text-path}" hasSuccessor="{./@hasSuccessor}"/>
                    </xsl:if>
                  </xsl:for-each>
                </transcriptions>
              </manifestation>
            </xsl:for-each>
          </manifestations>-->
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
          <xsl:with-param name="item-level" select="$item-level"/>
          <xsl:with-param name="expressionParentId" select="$expressionParentId"/>
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
          <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        </xsl:call-template>
        
       <!-- <xsl:call-template name="structure_item_translations">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="author-uri" select="$author-uri"/>
          <xsl:with-param name="dtsurn" select="$dtsurn"/>
          <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
          <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
          <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
          <!-\- required item level params -\->
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="repo-path" select="$repo-path"/>
          <xsl:with-param name="translationTranscriptions" select="$translationTranscriptions"/>
          <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
        </xsl:call-template>
        
        <xsl:call-template name="structure_item_translation_transcriptions">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="author-uri" select="$author-uri"/>
          <xsl:with-param name="dtsurn" select="$dtsurn"/>
          <xsl:with-param name="textfilesdir" select="$textfilesdir"/>
          <xsl:with-param name="gitRepoStyle" select="$gitRepoStyle"/>
          <xsl:with-param name="gitRepoBase" select="$gitRepoBase"/>
          <!-\- required item level params -\->
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="repo-path" select="$repo-path"/>
          <xsl:with-param name="translationTranscriptions" select="$translationTranscriptions"/>
          <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
        </xsl:call-template>-->
        
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
          <xsl:with-param name="expressionParentId" select="$expressionParentId"/>
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
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
          <xsl:with-param name="expressionParentId" select="$expressionParentId"/>
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
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
          <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
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
          <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
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
          <xsl:with-param name="expressionParentId" select="$expressionParentId"/>
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
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
          <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
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
          <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
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
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
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
          <xsl:with-param name="expressionParentId" select="$expressionParentId"/>
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
          <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        </xsl:call-template>
        <xsl:call-template name="structure_division_transcriptions">
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
          <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
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
          <xsl:with-param name="expressionParentId" select="$expressionParentId"/>
          <xsl:with-param name="extraction-file" select="$extraction-file"/>
          <xsl:with-param name="expressionType" select="$expressionType"/>
          <xsl:with-param name="sectionnumber" select="$sectionnumber"/>
          <xsl:with-param name="totalnumber" select="$totalnumber"/>
          <xsl:with-param name="text-path" select="$text-path"/>
          <xsl:with-param name="itemWitnesses" select="$itemWitnesses"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
          <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
          <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        </xsl:call-template>
        <xsl:call-template name="structure_block_transcriptions">
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
          <xsl:with-param name="translationManifestations" select="$translationManifestations"/>
          <xsl:with-param name="canonical-manifestation-id" select="$canonical-manifestation-id"/>
        </xsl:call-template>
        <xsl:call-template name="structure_element_quote_manifestations">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
        </xsl:call-template>
        <xsl:call-template name="zones">
          <xsl:with-param name="cid" select="$cid"/>
          <xsl:with-param name="fs" select="$fs"/>
          <xsl:with-param name="manifestations" select="$manifestations"/>
        </xsl:call-template>
      
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
  <xsl:include href="structure_item_expressions.xsl"/>
  <xsl:include href="structure_item_manifestations.xsl"/>
  <xsl:include href="structure_item_transcriptions.xsl"/>
  <xsl:include href="structure_division_expressions.xsl"/>
  <xsl:include href="structure_division_manifestations.xsl"/>
  <xsl:include href="structure_division_transcriptions.xsl"/>
  <xsl:include href="structure_block_expressions.xsl"/>
  <xsl:include href="structure_block_manifestations.xsl"/>
  <xsl:include href="structure_block_transcriptions.xsl"/>
  <xsl:include href="structure_element_name_expressions.xsl"/>
  <xsl:include href="structure_element_title_expressions.xsl"/>
  <xsl:include href="structure_element_quote_expressions.xsl"/>
  <xsl:include href="structure_element_ref_expressions.xsl"/>
  <xsl:include href="structure_element_quote_manifestations.xsl"/>
  <xsl:include href="zones.xsl"/>
  
  
  <xsl:include href="global_properties.xsl"/>
  <xsl:include href="expression_properties.xsl"/>
  <xsl:include href="manifestation_properties.xsl"/>
  
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