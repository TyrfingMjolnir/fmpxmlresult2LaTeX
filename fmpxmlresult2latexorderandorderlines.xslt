<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fmp="http://www.filemaker.com/fmpxmlresult" version="1.0">
	<xsl:output method="text" version="1.0" encoding="UTF-8" indent="no"/>
	<xsl:template match="fmp:FMPXMLRESULT">
		<xsl:text>\documentclass[fontsize=12pt, paper=a4]{scrlttr2}</xsl:text>
		<xsl:text/>
		<xsl:text>\setkomavar{fromname}{}</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>\setkomavar{fromaddress}{</xsl:text>
		<xsl:value-of select="COL/DATA[1]"/>
		<xsl:text>}</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>\setkomavar{signature}{} </xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>\renewcommand{\raggedsignature}{\raggedright}</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>\setkomavar{subject}{}</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>\begin{document}</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>\begin{letter}{Name and \\ Address \\ of \\ Recipient}</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>\begin{tabular}{ </xsl:text>
		<xsl:for-each select="fmp:METADATA/fmp:FIELD">
			<xsl:if test="not( contains( @NAME, '::' ) )">
				<xsl:value-of select="concat(
			              substring( 'l', 1 div boolean( @TYPE  = 'TEXT'      ) ),
			              substring( 'l', 1 div boolean( @TYPE  = 'CONTAINER' ) ),
			              substring( 'c', 1 div boolean( @TYPE  = 'DATE'      ) ),
			              substring( 'c', 1 div boolean( @TYPE  = 'TIMESTAMP' ) ),
			              substring( 'r', 1 div boolean( @TYPE  = 'NUMBER'    ) ) )"/>
				<xsl:choose>
					<xsl:when test="position()=last()">
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text> | </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
		<xsl:text> }</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>\hline</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:for-each select="fmp:METADATA/fmp:FIELD">
			<xsl:if test="not( contains( @NAME, '::' ) )">
				<xsl:value-of select="@NAME"/>
				<xsl:choose>
					<xsl:when test="position()=last()">
						<xsl:value-of select="fmp:DATA"/>
						<xsl:text>\\ \hline</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="fmp:DATA"/>
						<xsl:value-of select="$delimiter"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>&#10;</xsl:text>
		<xsl:for-each select="fmp:RESULTSET/fmp:ROW">
			<xsl:for-each select="fmp:COL">
				<xsl:variable name="i" select="position()"/>
				<xsl:if test="not( contains( /fmp:FMPXMLRESULT/fmp:METADATA/fmp:FIELD[position()=$i]/@NAME, '::' ) )">
					<xsl:choose>
						<xsl:when test="position()=last()">
							<xsl:call-template name="replace-string">
								<xsl:with-param name="text" select="fmp:DATA"/>
								<xsl:with-param name="replace" select="'&#10;'"/>
								<xsl:with-param name="with" select="'\n'"/>
							</xsl:call-template>
							<xsl:text>\\ \hline</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="replace-string">
								<xsl:with-param name="text" select="fmp:DATA"/>
								<xsl:with-param name="replace" select="'&#10;'"/>
								<xsl:with-param name="with" select="'\n'"/>
							</xsl:call-template>
							<xsl:value-of select="$delimiter"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
			<xsl:text>&#10;</xsl:text>
		</xsl:for-each>
		<xsl:text>\end{tabular}</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>\closing{}</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>\end{letter}</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>\end{document}</xsl:text>
	</xsl:template>
	<xsl:variable name="databaseName">
		<xsl:value-of select="fmp:FMPXMLRESULT/fmp:DATABASE/@NAME"/>
	</xsl:variable>
	<xsl:variable name="tableName">
		<xsl:value-of select="fmp:FMPXMLRESULT/fmp:DATABASE/@LAYOUT"/>
	</xsl:variable>
	<xsl:variable name="timeformat">
		<xsl:value-of select="fmp:FMPXMLRESULT/fmp:DATABASE/@TIMEFORMAT"/>
	</xsl:variable>
	<xsl:template name="replace-string">
		<xsl:param name="text"/>
		<xsl:param name="replace"/>
		<xsl:param name="with"/>
		<xsl:choose>
			<xsl:when test="contains($text,$replace)">
				<xsl:value-of select="substring-before($text,$replace)"/>
				<xsl:value-of select="$with"/>
				<xsl:call-template name="replace-string">
					<xsl:with-param name="text" select="substring-after($text,$replace)"/>
					<xsl:with-param name="replace" select="$replace"/>
					<xsl:with-param name="with" select="$with"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:variable name="delimiter">
		<xsl:text> &amp; </xsl:text>
	</xsl:variable>
</xsl:stylesheet>
