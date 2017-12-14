<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:sctar="http://scta.info/resource/" xmlns:sctap="http://scta.info/property/">
  
  <xsl:param name="projectfilesversion">null</xsl:param>
  <xsl:output method="xml" indent="yes"/>
  <xsl:variable name="rdfhome">/Users/jcwitt/Projects/scta/scta-rdf/commentaries/</xsl:variable>
	
  
  <xsl:template match="/">
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
      xmlns:sctap="http://scta.info/property/"
      xmlns:sctar="http://scta.info/resource/"
      xmlns:role="http://www.loc.gov/loc.terms/relators/" 
      xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
      xmlns:collex="http://www.collex.org/schema#" 
      xmlns:dcterms="http://purl.org/dc/terms/" 
      xmlns:dc="http://purl.org/dc/elements/1.1/"
      xmlns:owl="http://www.w3.org/2002/07/owl#">
      <xsl:call-template name="create-archive"/>
    	<xsl:call-template name="create-sententia-work-group"/>
    	<xsl:call-template name="create-deanima-work-group"/>
    	<xsl:call-template name="create-dionysius-work-group"/>
    	<xsl:call-template name="create-summulaelogicales-work-group"/>
      <xsl:call-template name="create-canonlaw-work-group"/>
      <xsl:call-template name="create-canonlaw-statutes-work-group"/>
      <xsl:call-template name="create-uncategorized-work-group"/>
    </rdf:RDF>
  </xsl:template>
  
  <xsl:template name="create-archive">
    <rdf:Description rdf:about="http://scta.info/resource/scta">
      <dc:title>Scholastic Commentaries and Texts Archive</dc:title>
    	<dc:description>A top level Work Group for all Work Groups in the archive</dc:description>
    	<rdf:type rdf:resource="http://scta.info/resource/workGroup"/>
      <sctap:dtsurn>urn:dts:latinLit:scta</sctap:dtsurn>
    	<sctap:shortId>scta</sctap:shortId>
      <sctap:projectfilesversion><xsl:value-of select="$projectfilesversion"/></sctap:projectfilesversion>
      <!-- This templates create the top level collection, containing all commentaries. -->
    	<dcterms:hasPart rdf:resource="http://scta.info/resource/sententia"/>
    	<dcterms:hasPart rdf:resource="http://scta.info/resource/deanima"/>
    	<dcterms:hasPart rdf:resource="http://scta.info/resource/summulaelogicales"/>
    	<dcterms:hasPart rdf:resource="http://scta.info/resource/dionysiuscommentarius"/>
      <dcterms:hasPart rdf:resource="http://scta.info/resource/canonlaw"/>
    	<dcterms:hasPart rdf:resource="http://scta.info/resource/uncategorized"/>
      
    	<!-- adding expressions -->
      <xsl:for-each select="collection(concat($rdfhome, '?select=[a-zA-Z]*.rdf'))/rdf:RDF/rdf:Description[./rdf:type/@rdf:resource = 'http://scta.info/resource/expression'][./sctap:level = '1']">
    		<xsl:variable name="commentaryid" select="./@rdf:about"/>
    		<sctap:hasExpression rdf:resource="{$commentaryid}"/>
    	</xsl:for-each>
    	
    	
    	<!-- temporary manually added expressions 
    	<sctap:hasExpression rdf:resource="http://scta.info/resource/hispanusdeanima"/>
    	<sctap:hasExpression rdf:resource="http://scta.info/resource/hispanusangelica"/>
    	<sctap:hasExpression rdf:resource="http://scta.info/resource/hispanusecclesiastica"/>
    	<sctap:hasExpression rdf:resource="http://scta.info/resource/hispanussummulaelogicales"/>
    	<sctap:hasExpression rdf:resource="http://scta.info/resource/hispanussyncategoreumata"/>
    	 end of manually added expressions -->
    </rdf:Description>
  </xsl:template>
	
	<xsl:template name="create-sententia-work-group">
		<rdf:Description rdf:about="http://scta.info/resource/sententia">
			<dc:title>Sentences Commentaries</dc:title>
			<dc:description>A Work Group for all commentaries on the Sentences of Peter Lombard</dc:description>
			<rdf:type rdf:resource="http://scta.info/resource/workGroup"/>
			<sctap:dtsurn>urn:dts:latinLit:sentences</sctap:dtsurn>
			<sctap:shortId>sententia</sctap:shortId>
			<!-- This templates create the top level collection, containing all commentaries. -->
			<xsl:for-each select="collection(concat($rdfhome, '?select=[a-zA-Z]*.rdf'))/rdf:RDF/rdf:Description[./dcterms:isPartOf/@rdf:resource = 'http://scta.info/resource/sententia']">
				<xsl:variable name="commentaryid" select="./@rdf:about"/>
				<!-- hasPart is for the moment functioning as hasExpression --> 
				<dcterms:hasPart rdf:resource="{$commentaryid}"/>
				<sctap:hasExpression rdf:resource="{$commentaryid}"/>
			</xsl:for-each>
		</rdf:Description>
	</xsl:template>
	
	<xsl:template name="create-deanima-work-group">
		<rdf:Description rdf:about="http://scta.info/resource/deanima">
			<dc:title>De Anima Commentaries</dc:title>
			<dc:description>A Work Group for all commentaries on Aristotle's De Anima</dc:description>
			<rdf:type rdf:resource="http://scta.info/resource/workGroup"/>
			<sctap:dtsurn>urn:dts:latinLit:deanima</sctap:dtsurn>
			<sctap:shortId>deanima</sctap:shortId>
			<!-- This templates create the top level collection, containing all commentaries. -->
			<xsl:for-each select="collection(concat($rdfhome, '?select=[a-zA-Z0-9]*.rdf'))/rdf:RDF/rdf:Description[./dcterms:isPartOf/@rdf:resource = 'http://scta.info/resource/deanima']">
				<xsl:variable name="commentaryid" select="./@rdf:about"/>
				<dcterms:hasPart rdf:resource="{$commentaryid}"/>
				<sctap:hasExpression rdf:resource="{$commentaryid}"/>
			</xsl:for-each>
			<!-- manually added deanima commentaries -->
			<!-- <dcterms:hasPart rdf:resource="http://scta.info/resource/hispanusdeanima"/> -->
		</rdf:Description>
	</xsl:template>
	
	<xsl:template name="create-dionysius-work-group">
		<rdf:Description rdf:about="http://scta.info/resource/dionysiuscommentarius">
			<dc:title>Commentaries on the corpus of Pseudo-Dionysius</dc:title>
			<dc:description>A Work Group for all commentaries on the corpus of Pseudo-Dionysius</dc:description>
			<rdf:type rdf:resource="http://scta.info/resource/workGroup"/>
			<sctap:dtsurn>urn:dts:latinLit:dionysiuscommentarius</sctap:dtsurn>
			<sctap:shortId>dionysiuscommentarius</sctap:shortId>
			
			<!-- This templates create the top level collection, containing all commentaries. -->
			<xsl:for-each select="collection(concat($rdfhome, '?select=[a-zA-Z0-9]*.rdf'))/rdf:RDF/rdf:Description[./dcterms:isPartOf/@rdf:resource = 'http://scta.info/resource/dionysiuscommentarius']">
				<xsl:variable name="commentaryid" select="./@rdf:about"/>
				<dcterms:hasPart rdf:resource="{$commentaryid}"/>
				<sctap:hasExpression rdf:resource="{$commentaryid}"/>
			</xsl:for-each>
			
			<!-- This templates create the top level collection, containing all commentaries. -->
			<!--xsl:for-each select="collection(concat($deanima-rdf-home, '?select=[a-zA-Z0-9]*.rdf'))/rdf:RDF/rdf:Description[./sctap:expressionType/@rdf:resource = 'http://scta.info/resource/commentary']">
				<xsl:variable name="commentaryid" select="./@rdf:about"/>
				<dcterms:hasPart rdf:resource="{$commentaryid}"/>
			</xsl:for-each>
			-->
			<!-- manually added deanima commentaries -
			<dcterms:hasPart rdf:resource="http://scta.info/resource/hispanusangelica"/>
			<sctap:hasExpression rdf:resource="http://scta.info/resource/hispanusangelica"/>
			<dcterms:hasPart rdf:resource="http://scta.info/resource/hispanusecclesiastica"/>
			<sctap:hasExpression rdf:resource="http://scta.info/resource/hispanusecclesiastica"/> -->
			
		</rdf:Description>
	</xsl:template>
	
	<xsl:template name="create-summulaelogicales-work-group">
		<rdf:Description rdf:about="http://scta.info/resource/summulaelogicales">
			<dc:title>Summulae logicales and commentaries</dc:title>
			<dc:description>A Work Group for the Summulae Logicales and the Commentary Tradition</dc:description>
			<rdf:type rdf:resource="http://scta.info/resource/workGroup"/>
			<sctap:dtsurn>urn:dts:latinLit:summulaelogicales</sctap:dtsurn>
			<sctap:shortId>summulaelogicales</sctap:shortId>
			<!-- This templates create the top level collection, containing all commentaries. -->
			<xsl:for-each select="collection(concat($rdfhome, '?select=[a-zA-Z0-9]*.rdf'))/rdf:RDF/rdf:Description[./dcterms:isPartOf/@rdf:resource = 'http://scta.info/resource/summulaelogicales']">
				<xsl:variable name="commentaryid" select="./@rdf:about"/>
				<dcterms:hasPart rdf:resource="{$commentaryid}"/>
				<sctap:hasExpression rdf:resource="{$commentaryid}"/>
			</xsl:for-each>
		</rdf:Description>
	</xsl:template>
  <xsl:template name="create-canonlaw-work-group">
    <rdf:Description rdf:about="http://scta.info/resource/canonlaw">
      <dc:title>Canon Law</dc:title>
      <dc:description>A Work Group for the Canon Law Tradition</dc:description>
      <rdf:type rdf:resource="http://scta.info/resource/workGroup"/>
      <sctap:dtsurn>urn:dts:latinLit:canonlaw</sctap:dtsurn>
      <sctap:shortId>canonlaw</sctap:shortId>
      <!-- This templates create the top level collection, containing all commentaries. -->
      <xsl:for-each select="collection(concat($rdfhome, '?select=[a-zA-Z0-9]*.rdf'))/rdf:RDF/rdf:Description[./dcterms:isPartOf/@rdf:resource = 'http://scta.info/resource/canonlaw']">
        <xsl:variable name="commentaryid" select="./@rdf:about"/>
        <dcterms:hasPart rdf:resource="{$commentaryid}"/>
        <sctap:hasExpression rdf:resource="{$commentaryid}"/>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($rdfhome, '?select=[a-zA-Z0-9]*.rdf'))/rdf:RDF/rdf:Description[./dcterms:isPartOf/@rdf:resource = 'http://scta.info/resource/statutes']">
        <xsl:variable name="commentaryid" select="./@rdf:about"/>
        <sctap:hasExpression rdf:resource="{$commentaryid}"/>
      </xsl:for-each>
      <dcterms:hasPart rdf:resource="http://scta.info/resource/statutes"/>
    </rdf:Description>
  </xsl:template>
  <xsl:template name="create-canonlaw-statutes-work-group">
    <rdf:Description rdf:about="http://scta.info/resource/statutes">
      <dc:title>Canon Law Statutes</dc:title>
      <dc:description>A Work Group for Statues in Canon Law Tradition</dc:description>
      <rdf:type rdf:resource="http://scta.info/resource/workGroup"/>
      <sctap:dtsurn>urn:dts:latinLit:statutes</sctap:dtsurn>
      <sctap:shortId>statutes</sctap:shortId>
      <dcterms:isPartOf rdf:resource="http://scta.info/resource/canonlaw"/>
      <!-- This templates create the top level collection, containing all commentaries. -->
      <xsl:for-each select="collection(concat($rdfhome, '?select=[a-zA-Z0-9]*.rdf'))/rdf:RDF/rdf:Description[./dcterms:isPartOf/@rdf:resource = 'http://scta.info/resource/statutes']">
        <xsl:variable name="commentaryid" select="./@rdf:about"/>
        <dcterms:hasPart rdf:resource="{$commentaryid}"/>
        <sctap:hasExpression rdf:resource="{$commentaryid}"/>
      </xsl:for-each>
    </rdf:Description>
  </xsl:template>
	<xsl:template name="create-uncategorized-work-group">
		<rdf:Description rdf:about="http://scta.info/resource/uncategorized">
			<dc:title>Uncategorized</dc:title>
			<dc:description>A Work Group for Uncategorized Texts</dc:description>
			<rdf:type rdf:resource="http://scta.info/resource/workGroup"/>
			<sctap:dtsurn>urn:dts:latinLit:uncategorized</sctap:dtsurn>
			<sctap:shortId>uncategorized</sctap:shortId>
			<!-- This templates create the top level collection, containing all commentaries. -->
			<xsl:for-each select="collection(concat($rdfhome, '?select=[a-zA-Z0-9]*.rdf'))/rdf:RDF/rdf:Description[./dcterms:isPartOf/@rdf:resource = 'http://scta.info/resource/uncategorized']">
				<xsl:variable name="commentaryid" select="./@rdf:about"/>
				<dcterms:hasPart rdf:resource="{$commentaryid}"/>
				<sctap:hasExpression rdf:resource="{$commentaryid}"/>
			</xsl:for-each>
			<xsl:for-each select="collection(concat($rdfhome, '?select=[a-zA-Z0-9]*.rdf'))/rdf:RDF/rdf:Description[./dcterms:isPartOf/@rdf:resource = '']">
				<xsl:variable name="commentaryid" select="./@rdf:about"/>
				<dcterms:hasPart rdf:resource="{$commentaryid}"/>
				<sctap:hasExpression rdf:resource="{$commentaryid}"/>
			</xsl:for-each>
		</rdf:Description>
	</xsl:template>
</xsl:stylesheet>