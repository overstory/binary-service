<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xrl="http://netkernel.org/xrl"
	xmlns:e="http://overstory.co.uk/ns/errors">
    <xsl:output method="xml"/>

	<xsl:template match="/">
		<e:errors>
			<xsl:apply-templates/>
		</e:errors>
	</xsl:template>

	<xsl:template match="exception[type = 'UnacceptableContentType']">
		<e:unacceptable-content-type>
			<xsl:apply-templates select="message"/>
			<xsl:apply-templates select="*[not(name(.) = 'message')]"/>
		</e:unacceptable-content-type>
	</xsl:template>
	
	<xsl:template match="exception[type = 'BadContentType']">
		<e:bad-content-type>
			<xsl:apply-templates select="message"/>
			<xsl:apply-templates select="*[not(name(.) = 'message')]"/>
		</e:bad-content-type>
	</xsl:template>
	
	<xsl:template match="exception">
		<e:internal-error>
			<xsl:apply-templates select="message"/>
			<xsl:apply-templates select="*[not(name(.) = 'message')]"/>
		</e:internal-error>
	</xsl:template>

	<xsl:template match="cause">
		<e:cause>
			<xsl:apply-templates select="message"/>
			<xsl:apply-templates select="*[not(name(.) = 'message')]"/>
		</e:cause>
	</xsl:template>

	<xsl:template match="code|type|class|Content-Type"/>

	<xsl:template match="element()">
		<xsl:element name="{concat('e', ':', local-name(.))}" namespace="http://overstory.co.uk/ns/errors">
			<xsl:value-of select="text()"/>
			<xsl:apply-templates select="element()"/>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
