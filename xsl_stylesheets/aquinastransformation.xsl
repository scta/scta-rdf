<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:param name="idstem">consolatio</xsl:param>
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
        <listofFileNames>
            <xsl:apply-templates/>
        </listofFileNames>
    </xsl:template>
    
    <xsl:template match="header">
        <header>
            <xsl:copy-of select="node()"></xsl:copy-of>
        </header>
    </xsl:template>
    
    <xsl:template match="div[@id='body']">
        <div type='body'><xsl:apply-templates/></div>
    </xsl:template>
    
    <xsl:template match="div[@id='body']/div">
        <div type='librum'><xsl:apply-templates/></div>
    </xsl:template>
    
    <xsl:template match="div[@id='body']/div/div">
        <div type='distinctio'><xsl:apply-templates/></div>
    </xsl:template>
    
    <xsl:template match="head">
        <head><xsl:apply-templates/></head>
    </xsl:template>
    
    <xsl:template match="item">
        <xsl:variable name="type" select="./@type"/>
        <xsl:variable name="title" select="./title"/>
        <xsl:variable name="questionTitle" select="./questionTitle"/>
        <xsl:analyze-string select="./title" regex="([0-9]+)[^0-9]+([0-9]+)[^0-9]+([0-9]+)[^0-9]+([0-9]+)">
             
            <xsl:matching-substring>
                <xsl:variable name="fs"><xsl:value-of select="concat('ta-l', regex-group(1) ,'d', regex-group(2) ,'q', regex-group(3),'a',regex-group(4))"></xsl:value-of></xsl:variable>
                <item xml:id="{$fs}" type="{$type}">
                <fileName filestem='{$fs}'><xsl:value-of select="concat($fs, '.xml')"/></fileName>
                    <title><xsl:value-of select="$title"/></title>
                    <questionTitle><xsl:value-of select="$questionTitle"/></questionTitle>
                </item>
            </xsl:matching-substring>
            </xsl:analyze-string>
        
    </xsl:template>
</xsl:stylesheet>