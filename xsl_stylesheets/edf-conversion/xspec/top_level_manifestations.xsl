<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:test="http://www.jenitennison.com/xslt/unit-test"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                xmlns:__x="http://www.w3.org/1999/XSL/TransformAliasAlias"
                xmlns:pkg="http://expath.org/ns/pkg"
                xmlns:impl="urn:x-xspec:compile:xslt:impl"
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
                version="2"
                exclude-result-prefixes="pkg impl">
   <xsl:import href="file:/Users/jcwitt/Projects/scta/scta-rdf/xsl_stylesheets/edf-conversion/top_level_manifestation.xsl"/>
   <xsl:import href="file:/Applications/Oxygen%20XML%20Editor/frameworks/xspec/src/compiler/generate-tests-utils.xsl"/>
   <xsl:import href="file:/Applications/Oxygen%20XML%20Editor/frameworks/xspec/src/schematron/sch-location-compare.xsl"/>
   <xsl:namespace-alias stylesheet-prefix="__x" result-prefix="xsl"/>
   <xsl:variable name="x:stylesheet-uri"
                 as="xs:string"
                 select="'file:/Users/jcwitt/Projects/scta/scta-rdf/xsl_stylesheets/edf-conversion/top_level_manifestation.xsl'"/>
   <xsl:output name="x:report" method="xml" indent="yes"/>
   <xsl:template name="x:main">
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('xsl:product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:message>
      <xsl:result-document format="x:report">
         <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="file:/Applications/Oxygen%20XML%20Editor/frameworks/xspec/src/compiler/format-xspec-report.xsl"</xsl:processing-instruction>
         <x:report stylesheet="{$x:stylesheet-uri}"
                   date="{current-dateTime()}"
                   xspec="file:/Users/jcwitt/Projects/scta/scta-rdf/xsl_stylesheets/edf-conversion/top_level_manifestations.xspec">
            <xsl:call-template name="x:d5e2"/>
         </x:report>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="x:d5e2">
      <xsl:message>Creating top level manifestations</xsl:message>
      <x:scenario>
         <x:label>Creating top level manifestations</x:label>
         <x:call template="top_level_manifestation">
            <x:param name="cid"
                     href="file:/Users/jcwitt/Projects/scta/scta-projectfiles/pg-projectdata.xml"
                     select="//header/commentaryid"/>
            <x:param name="author-uri"
                     href="file:/Users/jcwitt/Projects/scta/scta-projectfiles/pg-projectdata.xml"
                     select="//header/authorUri"/>
            <x:param name="top-level-witnesses"
                     href="file:/Users/jcwitt/Projects/scta/scta-projectfiles/pg-projectdata.xml"
                     select="/listofFileNames/header/hasWitnesses//witness"/>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="cid-doc"
                          as="document-node()"
                          select="doc('file:/Users/jcwitt/Projects/scta/scta-projectfiles/pg-projectdata.xml')"/>
            <xsl:variable name="cid" select="$cid-doc/(//header/commentaryid)"/>
            <xsl:variable name="author-uri-doc"
                          as="document-node()"
                          select="doc('file:/Users/jcwitt/Projects/scta/scta-projectfiles/pg-projectdata.xml')"/>
            <xsl:variable name="author-uri" select="$author-uri-doc/(//header/authorUri)"/>
            <xsl:variable name="top-level-witnesses-doc"
                          as="document-node()"
                          select="doc('file:/Users/jcwitt/Projects/scta/scta-projectfiles/pg-projectdata.xml')"/>
            <xsl:variable name="top-level-witnesses"
                          select="$top-level-witnesses-doc/(/listofFileNames/header/hasWitnesses//witness)"/>
            <xsl:call-template name="top_level_manifestation">
               <xsl:with-param name="cid" select="$cid"/>
               <xsl:with-param name="author-uri" select="$author-uri"/>
               <xsl:with-param name="top-level-witnesses" select="$top-level-witnesses"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e7">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e7">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>should return assertions for top level manifestations</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <rdf:Description rdf:about="http://scta.info/resource/augustinedecivitatedei/critical">
               <dc:title>
                  <xsl:text>Augustine's De Civitate Dei</xsl:text>
               </dc:title>
               <dc:description>
                  <xsl:text>test</xsl:text>
               </dc:description>
               <sctap:shortId>
                  <xsl:text>augustinedecivitatedei/critical</xsl:text>
               </sctap:shortId>
               <ldp:inbox rdf:resource="http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/augustinedecivitatedei/critical"/>
               <rdf:type rdf:resource="http://scta.info/resource/manifestation"/>
               <dc:language>
                  <xsl:text>la</xsl:text>
               </dc:language>
               <sctap:isManifestationOf rdf:resource="http://scta.info/resource/augustinedecivitatedei"/>
               <sctap:hasTranscription rdf:resource="http://scta.info/resource/augustinedecivitatedei/critical/transcription"/>
               <sctap:hasCanonicalTranscription rdf:resource="http://scta.info/resource/augustinedecivitatedei/critical/transcription"/>
               <sctap:structureType rdf:resource="http://scta.info/resource/structureCollection"/>
               <sctap:level>
                  <xsl:text>1</xsl:text>
               </sctap:level>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l1/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l2/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l3/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l4/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l5/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l6/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l7/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l8/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l9/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l10/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l11/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l12/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l13/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l14/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l15/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l16/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l17/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l18/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l19/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l20/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l21/critical"/>
               <sctap:hasStructureItem rdf:resource="http://scta.info/resource/adcd-l22/critical"/>
               <role:AUT rdf:resource="http://scta.info/resource/Augustine"/>
               <sctap:hasSlug>
                  <xsl:text>critical</xsl:text>
               </sctap:hasSlug>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l1/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l2/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l3/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l4/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l5/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l6/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l7/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l8/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l9/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l10/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l11/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l12/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l13/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l14/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l15/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l16/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l17/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l18/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l19/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l20/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l21/critical"/>
               <dcterms:hasPart rdf:resource="http://scta.info/resource/adcd-l22/critical"/>
            </rdf:Description>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" select="$impl:expected-doc/node()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>should return assertions for top level manifestations</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>
