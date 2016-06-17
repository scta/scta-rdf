<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:sctar="http://scta.info/resource/" xmlns:sctap="http://scta.info/property/">
  
  <xsl:param name="projectfilesversion">null</xsl:param>
  <xsl:output method="xml" indent="yes"/>
  <xsl:variable name="sentences-rdf-home">/Users/jcwitt/Projects/scta/scta-rdf/commentaries/</xsl:variable>
	<xsl:variable name="deanima-rdf-home">/Users/jcwitt/Projects/scta/scta-rdf/deanima-commentaries/</xsl:variable>
	<xsl:variable name="summulaelogicales-rdf-home">/Users/jcwitt/Projects/scta/scta-rdf/summulaelogicales-commentaries/</xsl:variable>
  
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
    	<xsl:call-template name="create-summulaelogicales-work-group"/>
    </rdf:RDF>
  </xsl:template>
  
  <xsl:template name="create-archive">
    <rdf:Description rdf:about="http://scta.info/resource/scta">
      <dc:title>Sentences Commentary Text Archive</dc:title>
    	<dc:description>A top level Work Group for all Work Groups in the archive</dc:description>
    	<rdf:type rdf:resource="http://scta.info/resource/workGroup"/>
      <sctap:dtsurn>urn:dts:latinLit:scta</sctap:dtsurn>
    	<sctap:shortId>scta</sctap:shortId>
      <sctap:projectfilesversion><xsl:value-of select="$projectfilesversion"/></sctap:projectfilesversion>
      <!-- This templates create the top level collection, containing all commentaries. -->
    	<sctap:hasWorkGroup rdf:resource="http://scta.info/resource/sententia"/>
    	<sctap:hasWorkGroup rdf:resource="http://scta.info/resource/deanima"/>
    	<sctap:hasWorkGroup rdf:resource="http://scta.info/resource/summulaelogicales"/>
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
			<xsl:for-each select="collection(concat($sentences-rdf-home, '?select=[a-zA-Z]*.rdf'))/rdf:RDF/rdf:Description[./sctap:expressionType/@rdf:resource = 'http://scta.info/resource/commentary']">
				<xsl:variable name="commentaryid" select="./@rdf:about"/>
				<!-- hasPart is for the moment functioning as hasExpression --> 
				<dcterms:hasPart rdf:resource="{$commentaryid}"/>
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
			<xsl:for-each select="collection(concat($deanima-rdf-home, '?select=[a-zA-Z0-9]*.rdf'))/rdf:RDF/rdf:Description[./sctap:expressionType/@rdf:resource = 'http://scta.info/resource/commentary']">
				<xsl:variable name="commentaryid" select="./@rdf:about"/>
				<dcterms:hasPart rdf:resource="{$commentaryid}"/>
			</xsl:for-each>
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
			<!-- TODO: it should be looking of type=expression level=1 instead of expressionType=commentary --> 
			<xsl:for-each select="collection(concat($summulaelogicales-rdf-home, '?select=[a-zA-Z0-9]*.rdf'))/rdf:RDF/rdf:Description[./sctap:expressionType/@rdf:resource = 'http://scta.info/resource/commentary']">
				<xsl:variable name="commentaryid" select="./@rdf:about"/>
				<dcterms:hasPart rdf:resource="{$commentaryid}"/>
			</xsl:for-each>
		</rdf:Description>
	</xsl:template>
</xsl:stylesheet>