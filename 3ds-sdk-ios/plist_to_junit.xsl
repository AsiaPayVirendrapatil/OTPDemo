<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
version="1.0">
  <xsl:output omit-xml-declaration="no" indent="yes" />
  <xsl:strip-space elements="*" />
  
  <xsl:template match="/*">
    <testsuites>
      <testsuite name="All Unit Tests">
        <xsl:apply-templates select="//dict[key = 'TestStatus']"/>
      </testsuite>
    </testsuites>
  </xsl:template>

  <xsl:template match="//dict[key = 'TestStatus']">
    <testcase classname="{../../string[1]}" name="{string[1]}" time="{real[1]}">
    </testcase>
  </xsl:template>  
</xsl:stylesheet>