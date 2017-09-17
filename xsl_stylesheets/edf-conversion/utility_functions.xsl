<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:utils="http://utility/functions"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xsl:function name="utils:compareCI">
    <xsl:param name="string1"/>
    <xsl:param name="string2"/>
    <xsl:value-of select="compare(upper-case($string1),upper-case($string2))"/>
  </xsl:function>
  
</xsl:stylesheet>