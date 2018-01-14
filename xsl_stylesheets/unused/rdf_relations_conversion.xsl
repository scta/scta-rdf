<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:sctar="http://scta.info/resource/" xmlns:sctap="http://scta.info/property/">
    
<xsl:output method="xml" indent="yes"/>
  <xsl:param name="commentary-rdf-home"/>
	
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
          <xsl:call-template name="relation"/>
        </rdf:RDF>
    </xsl:template>
    
    <xsl:template name="relation">
      <!-- the collection references restrict queries to sentences commentary references using "item"  and passages using "passage" 
        quote reference relationships are taken care of in the quotation extraction script
        this way of doing thing is a little bit brittle since it will break if the url pattern changes -->
      
      <!-- item resources are excluded for the moment, to avoid redundancy for all subsections and paragraphs, since references and quotes are logged at the section/paragraph level 
        and at the item level -->
      
      <xsl:for-each select="collection(concat($commentary-rdf-home, '?select=[a-zA-Z]*.rdf'))//sctap:abbreviates | 
        collection(concat($commentary-rdf-home, '?select=[a-zA-Z0-9]*.rdf'))//sctap:references | 
        collection(concat($commentary-rdf-home, '?select=[a-zA-Z0-9]*.rdf'))//sctap:references[contains(@rdf:resource, 'passage')] |
        collection(concat($commentary-rdf-home, '?select=[a-zA-Z0-9]*.rdf'))//sctap:copies | 
        collection(concat($commentary-rdf-home, '?select=[a-zA-Z0-9]*.rdf'))//sctap:isInstanceOf |
      	collection(concat($commentary-rdf-home, '?select=[a-zA-Z0-9]*.rdf'))//sctap:isRelatedTo">
        <!-- below all resources are going to receive a passive relationship. The patient-resource-id is the subject that the action is being done to.
          The agent resource is the agent of the acting being done. It answers the question, doneBy whome? -->
        <xsl:variable name="patient-resource-id" select="./@rdf:resource"/>
        <xsl:variable name="agent-resource-id" select="./parent::rdf:Description/@rdf:about"/>
        <rdf:Description rdf:about="{$patient-resource-id}">
          <xsl:choose>
          	<xsl:when test="./name() = 'sctap:isRelatedTo'">
          		<sctap:isRelatedTo rdf:resource="{$agent-resource-id}"/>
          	</xsl:when>
            <xsl:when test="./name() = 'sctap:abbreviates'">
              <sctap:abbreviatedBy rdf:resource="{$agent-resource-id}"/>
            </xsl:when>
            <xsl:when test="./name() = 'sctap:copies'">
              <sctap:copiedBy rdf:resource="{$agent-resource-id}"/>
            </xsl:when>
            <xsl:when test="./name() = 'sctap:references'">
              <sctap:referencedBy rdf:resource="{$agent-resource-id}"/>
            </xsl:when>
            <xsl:when test="./name() = 'sctap:quotes'">
              <sctap:quotedBy rdf:resource="{$agent-resource-id}"/>
            </xsl:when>
          	<xsl:when test="./name() = 'sctap:isInstanceOf'">
          		<sctap:hasInstance rdf:resource="{$agent-resource-id}"/>
          	</xsl:when>
            <xsl:otherwise>
              <text>nothing matched</text>
            </xsl:otherwise>
          </xsl:choose>
        </rdf:Description>
      </xsl:for-each>
      <!-- this has been separated from above because it was causing a memory error. As collection grows, this memory error will 
        probably re-occurr, and this file needs to broken down into smaller operation parts -->
        
      <xsl:for-each select="collection(concat($commentary-rdf-home, '?select=[a-zA-Z0-9]*.rdf'))//sctap:quotes">
        <!-- below all resources are going to receive a passive relationship. The patient-resource-id is the subject that the action is being done to.
          The agent resource is the agent of the acting being done. It answers the question, doneBy whome? -->
        <xsl:variable name="patient-resource-id" select="./@rdf:resource"/>
        <xsl:variable name="agent-resource-id" select="./parent::rdf:Description/@rdf:about"/>
        <rdf:Description rdf:about="{$patient-resource-id}">
          <xsl:choose>
            <xsl:when test="./name() = 'sctap:isRelatedTo'">
              <sctap:isRelatedTo rdf:resource="{$agent-resource-id}"/>
            </xsl:when>
            <xsl:when test="./name() = 'sctap:abbreviates'">
              <sctap:abbreviatedBy rdf:resource="{$agent-resource-id}"/>
            </xsl:when>
            <xsl:when test="./name() = 'sctap:copies'">
              <sctap:copiedBy rdf:resource="{$agent-resource-id}"/>
            </xsl:when>
            <xsl:when test="./name() = 'sctap:references'">
              <sctap:referencedBy rdf:resource="{$agent-resource-id}"/>
            </xsl:when>
            <xsl:when test="./name() = 'sctap:quotes'">
              <sctap:quotedBy rdf:resource="{$agent-resource-id}"/>
            </xsl:when>
            <xsl:when test="./name() = 'sctap:isInstanceOf'">
              <sctap:hasInstance rdf:resource="{$agent-resource-id}"/>
            </xsl:when>
            <xsl:otherwise>
              <text>nothing matched</text>
            </xsl:otherwise>
          </xsl:choose>
        </rdf:Description>
      </xsl:for-each>
    	<!--
    	 
    	<xsl:for-each select="collection(concat($deanima-rdf-home, '?select=[a-zA-Z]*.rdf'))//sctap:abbreviates | 
    		collection(concat($deanima-rdf-home, '?select=[a-zA-Z0-9]*.rdf'))//sctap:references | 
    		collection(concat($deanima-rdf-home, '?select=[a-zA-Z0-9]*.rdf'))//sctap:references[contains(@rdf:resource, 'passage')] |
    		collection(concat($deanima-rdf-home, '?select=[a-zA-Z0-9]*.rdf'))//sctap:copies | 
    		collection(concat($deanima-rdf-home, '?select=[a-zA-Z0-9]*.rdf'))//sctap:quotes |
    		collection(concat($deanima-rdf-home, '?select=[a-zA-Z0-9]*.rdf'))//sctap:isInstanceOf">
    		
    		<xsl:variable name="patient-resource-id" select="./@rdf:resource"/>
    		<xsl:variable name="agent-resource-id" select="./parent::rdf:Description/@rdf:about"/>
    		<rdf:Description rdf:about="{$patient-resource-id}">
    			<xsl:choose>
    				<xsl:when test="./name() = 'sctap:abbreviates'">
    					<sctap:abbreviatedBy rdf:resource="{$agent-resource-id}"/>
    				</xsl:when>
    				<xsl:when test="./name() = 'sctap:copies'">
    					<sctap:copiedBy rdf:resource="{$agent-resource-id}"/>
    				</xsl:when>
    				<xsl:when test="./name() = 'sctap:references'">
    					<sctap:referencedBy rdf:resource="{$agent-resource-id}"/>
    				</xsl:when>
    				<xsl:when test="./name() = 'sctap:quotes'">
    					<sctap:quotedBy rdf:resource="{$agent-resource-id}"/>
    				</xsl:when>
    				<xsl:when test="./name() = 'sctap:isInstanceOf'">
    					<sctap:hasInstance rdf:resource="{$agent-resource-id}"/>
    				</xsl:when>
    				<xsl:otherwise>
    					<text>nothing matched</text>
    				</xsl:otherwise>
    			</xsl:choose>
    		</rdf:Description>
    	</xsl:for-each> -->
    </xsl:template>
</xsl:stylesheet>