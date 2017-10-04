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
                xmlns:utils="http://utility/functions"
                version="2.0"
                exclude-result-prefixes="pkg impl">
   <xsl:import href="file:/Users/jcwitt/Projects/scta/scta-rdf/xsl_stylesheets/edf-conversion/utility_functions.xsl"/>
   <xsl:import href="file:/Users/jcwitt/Projects/xspec/src/compiler/generate-tests-utils.xsl"/>
   <xsl:import href="file:/Users/jcwitt/Projects/xspec/src/schematron/sch-location-compare.xsl"/>
   <xsl:namespace-alias stylesheet-prefix="__x" result-prefix="xsl"/>
   <xsl:variable name="x:stylesheet-uri"
                 as="xs:string"
                 select="'file:/Users/jcwitt/Projects/scta/scta-rdf/xsl_stylesheets/edf-conversion/utility_functions.xsl'"/>
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
      <xsl:message>Comparing two strings</xsl:message>
      <x:scenario>
         <x:label>Comparing two strings</x:label>
         <xsl:call-template name="x:d5e3"/>
         <xsl:call-template name="x:d5e9"/>
         <xsl:call-template name="x:d5e15"/>
         <xsl:call-template name="x:d5e21"/>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e3">
      <xsl:message>..Comparing two equal strings</xsl:message>
      <x:scenario>
         <x:label>Comparing two equal strings</x:label>
         <x:call function="utils:compareCI">
            <x:param select="'string'"/>
            <x:param select="'string'"/>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable select="'string'" name="d7e1"/>
            <xsl:variable select="'string'" name="d7e2"/>
            <xsl:sequence select="utils:compareCI($d7e1, $d7e2)"/>
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
      <xsl:message>should return 0</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>0</xsl:text>
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
         <x:label>should return 0</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d5e9">
      <xsl:message>..Comparing two strings where first is 'higher' than second</xsl:message>
      <x:scenario>
         <x:label>Comparing two strings where first is 'higher' than second</x:label>
         <x:call function="utils:compareCI">
            <x:param select="'string1234'"/>
            <x:param select="'string'"/>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable select="'string1234'" name="d12e1"/>
            <xsl:variable select="'string'" name="d12e2"/>
            <xsl:sequence select="utils:compareCI($d12e1, $d12e2)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e13">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e13">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>should return 1</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>1</xsl:text>
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
         <x:label>should return 1</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d5e15">
      <xsl:message>..Comparing two strings where second is 'higher' than second</xsl:message>
      <x:scenario>
         <x:label>Comparing two strings where second is 'higher' than second</x:label>
         <x:call function="utils:compareCI">
            <x:param select="'string1234'"/>
            <x:param select="'string2345'"/>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable select="'string1234'" name="d17e1"/>
            <xsl:variable select="'string2345'" name="d17e2"/>
            <xsl:sequence select="utils:compareCI($d17e1, $d17e2)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e19">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e19">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>should return -1</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>-1</xsl:text>
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
         <x:label>should return -1</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d5e21">
      <xsl:message>..Comparing case different only strings</xsl:message>
      <x:scenario>
         <x:label>Comparing case different only strings</x:label>
         <x:call function="utils:compareCI">
            <x:param select="'string'"/>
            <x:param select="'STRING'"/>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable select="'string'" name="d22e1"/>
            <xsl:variable select="'STRING'" name="d22e2"/>
            <xsl:sequence select="utils:compareCI($d22e1, $d22e2)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e25">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e25">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>should return 0</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>0</xsl:text>
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
         <x:label>should return 0</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>
