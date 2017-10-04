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
                version="2.0"
                exclude-result-prefixes="pkg impl">
   <xsl:import href="file:/Users/jcwitt/Projects/scta/scta-rdf/xsl_stylesheets/edf-conversion/sponsors.xsl"/>
   <xsl:import href="file:/Users/jcwitt/Projects/xspec/src/compiler/generate-tests-utils.xsl"/>
   <xsl:import href="file:/Users/jcwitt/Projects/xspec/src/schematron/sch-location-compare.xsl"/>
   <xsl:namespace-alias stylesheet-prefix="__x" result-prefix="xsl"/>
   <xsl:variable name="x:stylesheet-uri"
                 as="xs:string"
                 select="'file:/Users/jcwitt/Projects/scta/scta-rdf/xsl_stylesheets/edf-conversion/sponsors.xsl'"/>
   <xsl:output name="x:report" method="xml" indent="yes"/>
   <xsl:template name="x:main">
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('xsl:product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:message>
      <xsl:result-document format="x:report">
         <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="file:/Users/jcwitt/Projects/xspec/src/compiler/format-xspec-report.xsl"</xsl:processing-instruction>
         <x:report stylesheet="{$x:stylesheet-uri}" date="{current-dateTime()}">
            <xsl:call-template name="x:d5e2"/>
         </x:report>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="x:d5e2">
      <xsl:message>Getting sponsors</xsl:message>
      <x:scenario>
         <x:label>Getting sponsors</x:label>
         <x:call template="sponsors">
            <x:param name="sponsors">
               <sponsors>
                  <sponsor>
                     <name>
                        <xsl:text>First sponsor name</xsl:text>
                     </name>
                     <link>
                        <xsl:text>https://first-sponsor.org</xsl:text>
                     </link>
                     <logo>
                        <xsl:text>https://first-sponsor.org/logo.png</xsl:text>
                     </logo>
                  </sponsor>
                  <sponsor>
                     <name>
                        <xsl:text>Second sponsor name</xsl:text>
                     </name>
                     <link>
                        <xsl:text>https://second-sponsor.org</xsl:text>
                     </link>
                     <logo>
                        <xsl:text>https://second-sponsor.org/logo.png</xsl:text>
                     </logo>
                  </sponsor>
               </sponsors>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="sponsors-doc" as="document-node()">
               <xsl:document>
                  <sponsors>
                     <sponsor>
                        <name>
                           <xsl:text>First sponsor name</xsl:text>
                        </name>
                        <link>
                           <xsl:text>https://first-sponsor.org</xsl:text>
                        </link>
                        <logo>
                           <xsl:text>https://first-sponsor.org/logo.png</xsl:text>
                        </logo>
                     </sponsor>
                     <sponsor>
                        <name>
                           <xsl:text>Second sponsor name</xsl:text>
                        </name>
                        <link>
                           <xsl:text>https://second-sponsor.org</xsl:text>
                        </link>
                        <logo>
                           <xsl:text>https://second-sponsor.org/logo.png</xsl:text>
                        </logo>
                     </sponsor>
                  </sponsors>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="sponsors" select="$sponsors-doc/node()"/>
            <xsl:call-template name="sponsors">
               <xsl:with-param name="sponsors" select="$sponsors"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e20">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e20">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>should return content of any level sponsor elements</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <rdf:Description rdf:about="http://scta.info/resource/{@id}">
               <dc:title>
                  <xsl:text>First sponsor name</xsl:text>
               </dc:title>
               <rdf:type rdf:resource="http://scta.info/resource/sponsor"/>
               <sctap:link rdf:resource="https://first-sponsor.org"/>
               <sctap:logo rdf:resource="https://first-sponsor.org/logo.png"/>
            </rdf:Description>
            <rdf:Description rdf:about="http://scta.info/resource/{@id}">
               <dc:title>
                  <xsl:text>Second sponsor name</xsl:text>
               </dc:title>
               <rdf:type rdf:resource="http://scta.info/resource/sponsor"/>
               <sctap:link rdf:resource="https://second-sponsor.org"/>
               <sctap:logo rdf:resource="https://second-sponsor.org/logo.png"/>
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
         <x:label>should return content of any level sponsor elements</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>
