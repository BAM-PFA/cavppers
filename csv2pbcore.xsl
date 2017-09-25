<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.pbcore.org/PBCore/PBCoreNamespace.html" xmlns:p="http://www.pbcore.org/PBCore/PBCoreNamespace.html" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:str="http://exslt.org/strings" version="1.0" extension-element-prefixes="xsi str p">
  <xsl:output encoding="UTF-8" method="xml" version="1.0" indent="yes"/>
  <xsl:template match="/csv">
    <pbcoreCollection xmlns="http://www.pbcore.org/PBCore/PBCoreNamespace.html"
                      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                      xsi:schemaLocation="http://www.pbcore.org/PBCore/PBCoreNamespace.html https://raw.githubusercontent.com/WGBH/PBCore_2.1/master/pbcore-2.1.xsd"
                      collectionDate="for institutional reference"
                      collectionTitle=""
                      collectionRef="">
      <xsl:attribute name="collectionSource">
        <xsl:value-of select="row[starts-with(col2,$select)]/col6"/>
      </xsl:attribute>
      <xsl:attribute name="collectionSourceAGAIN">
        <xsl:value-of select="row[starts-with(col2,$select)]/col65"/>
      </xsl:attribute>
      <xsl:apply-templates select="row[starts-with(col2,$select)]"/>
    </pbcoreCollection>
  </xsl:template>
  <xsl:template match="row">
    <pbcoreDescriptionDocument>
      <!-- the columns to map are listed below. They should be in the right order as expected in the output. I grouped them by pbcore element.
      All values listed below must also be referenced by a function below.-->
      <xsl:apply-templates select="col7"/><!-- Asset Type -->
      <xsl:apply-templates select="col22|col23"/><!-- Dates -->
      <xsl:apply-templates select="col1|col2|col3|col4|col67|col68|col69"/><!-- identifiers -->
      <xsl:apply-templates select="col10|col11|col12"/><!-- titles -->
      <xsl:apply-templates select="col42|col43"/><!-- subjects -->
      <xsl:apply-templates select="col13"/><!-- descriptions -->
      <xsl:apply-templates select="col45"/><!-- genre -->
      <xsl:apply-templates select="col15|col16|col17|col18|col19|col20"/><!-- creator -->
      <xsl:apply-templates select="col30|col31|col32|col33|col34|col35|col36|col37|col38"/><!-- contributor -->
      <xsl:apply-templates select="col39|col40"/><!-- publisher -->
      <xsl:apply-templates select="col24|col60|col61|col62|col63|col64"/><!-- rights -->

      <pbcoreInstantiation>
        <xsl:apply-templates select="XXX" mode="instantiation"/><!-- id -->
        <xsl:apply-templates select="XXX" mode="instantiation"/><!-- date -->
        <xsl:apply-templates select="col25"/><!-- physical -->
        <xsl:apply-templates select="XXX"/><!-- location -->
        <xsl:apply-templates select="col8"/><!-- mediatype -->
        <xsl:apply-templates select="col9"/><!-- generations -->
        <xsl:apply-templates select="col29"/><!-- colors -->
        <xsl:apply-templates select="col28"/><!-- tracks -->
        <xsl:apply-templates select="col41"/><!-- langauge -->
        <xsl:apply-templates select="col26"/><!-- annotation extent -->
      </pbcoreInstantiation>
      <xsl:for-each select="str:tokenize($instantiations,'+')">
        <pbcoreInstantiation>
          <xsl:copy-of select="document(normalize-space(.))/p:pbcoreInstantiationDocument/node()"/>
        </pbcoreInstantiation>
      </xsl:for-each>
      <!-- extensions -->
      <xsl:apply-templates select="col5|col21"/><!-- extension -->

    </pbcoreDescriptionDocument>
  </xsl:template>
  
  <!-- PBCORE TEMPLATES -->
  <!-- Asset Type -->
  <xsl:template match="col7">
    <xsl:if test="string-length(.)>0">
      <pbcoreAssetType>
        <xsl:value-of select="."/>
      </pbcoreAssetType>
    </xsl:if>
  </xsl:template>
  <!-- Dates -->
  <xsl:template name="date_created" match="col23">
    <xsl:if test="string-length(substring(.,3,string-length(.)-3))>0">
      <pbcoreAssetDate>
        <xsl:attribute name="dateType">Created</xsl:attribute>
        <xsl:value-of select="substring(.,3,string-length(.)-3)"/>
      </pbcoreAssetDate>
    </xsl:if>
  </xsl:template>
  <xsl:template name="date_published" match="col22">
    <xsl:if test="string-length(substring(.,3,string-length(.)-3))>0">
      <pbcoreAssetDate>
        <xsl:attribute name="dateType">Published</xsl:attribute>
        <xsl:value-of select="substring(.,3,string-length(.)-3)"/>
      </pbcoreAssetDate>
    </xsl:if>
  </xsl:template>
  <xsl:template name="date-instantiation" match="XXX" mode="instantiation">
    <xsl:if test="string-length(.)>0">
      <instantiationDate>
        <xsl:attribute name="dateType">Created</xsl:attribute>
        <xsl:value-of select="."/>
      </instantiationDate>
    </xsl:if>
  </xsl:template>
  <xsl:template name="color-instantiation" match="col29">
    <xsl:if test="string-length(.)>0">
      <instantiationColors>
        <xsl:value-of select="."/>
      </instantiationColors>
    </xsl:if>
  </xsl:template>
  <xsl:template name="tracks-instantiation" match="col28">
    <xsl:if test="string-length(.)>0">
      <instantiationTracks>
        <xsl:value-of select="."/>
      </instantiationTracks>
    </xsl:if>
  </xsl:template>
  <xsl:template name="language-instantiation" match="col41">
    <xsl:if test="string-length(.)>0">
      <instantiationLanguage>
        <xsl:value-of select="."/>
      </instantiationLanguage>
    </xsl:if>
  </xsl:template>
  <!-- identifiers -->
  <xsl:template name="identifier-cavpp" match="col2|col3|col4">
    <xsl:if test="string-length(.)>0">
      <pbcoreIdentifier>
        <xsl:variable name="column" select="count(preceding-sibling::*)+1"/>
        <xsl:attribute name="annotation">CAVPP</xsl:attribute>
        <xsl:attribute name="source">
          <xsl:value-of select="../../row[1]/*[$column]"/>
        </xsl:attribute>
        <xsl:value-of select="."/>
      </pbcoreIdentifier>
    </xsl:if>
  </xsl:template>
  <xsl:template name="identifier-ia" match="col1">
    <xsl:if test="string-length(.)>0">
      <pbcoreIdentifier>
        <xsl:variable name="column" select="count(preceding-sibling::*)+1"/>
        <xsl:attribute name="source">Object URL</xsl:attribute>
        <xsl:attribute name="annotation">
          <xsl:value-of select="../../row[1]/*[$column]"/>
        </xsl:attribute>
        <xsl:value-of select="."/>
      </pbcoreIdentifier>
    </xsl:if>
  </xsl:template>
  <xsl:template name="identifier-cdl" match="col67|col68|col69">
    <xsl:if test="string-length(.)>0">
      <pbcoreIdentifier>
        <xsl:variable name="column" select="count(preceding-sibling::*)+1"/>
        <xsl:attribute name="source">CDL</xsl:attribute>
        <xsl:attribute name="annotation">
          <xsl:value-of select="../../row[1]/*[$column]"/>
        </xsl:attribute>
        <xsl:value-of select="."/>
      </pbcoreIdentifier>
    </xsl:if>
  </xsl:template>
  <xsl:template name="inst-identifier-cavpp" match="XXX" mode="instantiation">
    <xsl:if test="string-length(.)>0">
      <instantiationIdentifier>
        <xsl:variable name="column" select="count(preceding-sibling::*)+1"/>
        <xsl:attribute name="source">CAVPP</xsl:attribute>
        <xsl:attribute name="annotation">
          <xsl:value-of select="../../row[1]/*[$column]"/>
        </xsl:attribute>
        <xsl:value-of select="."/>
      </instantiationIdentifier>
    </xsl:if>
  </xsl:template>
  <!-- titles -->
  <xsl:template name="title" match="col10|col11|col12">
    <xsl:if test="string-length(.)>0">
      <pbcoreTitle>
        <xsl:variable name="column" select="count(preceding-sibling::*)+1"/>
        <xsl:attribute name="titleType">
          <xsl:value-of select="../../row[1]/*[$column]"/>
        </xsl:attribute>
        <xsl:value-of select="."/>
      </pbcoreTitle>
    </xsl:if>
  </xsl:template>
  <!-- subjects -->
  <xsl:template name="subject" match="col42|col43">
    <xsl:if test="string-length(.)>0">
      <pbcoreSubject>
        <xsl:variable name="column" select="count(preceding-sibling::*)+1"/>
        <xsl:attribute name="subjectType">
          <xsl:value-of select="../../row[1]/*[$column]"/>
        </xsl:attribute>
        <xsl:value-of select="."/>
      </pbcoreSubject>
    </xsl:if>
  </xsl:template>
  <!-- descriptions -->
  <xsl:template name="description" match="col13">
    <xsl:if test="string-length(.)>0">
      <pbcoreDescription>
        <xsl:variable name="column" select="count(preceding-sibling::*)+1"/>
        <xsl:attribute name="descriptionType">
          <xsl:value-of select="../../row[1]/*[$column]"/>
        </xsl:attribute>
        <xsl:value-of select="."/>
      </pbcoreDescription>
    </xsl:if>
  </xsl:template>
  <!-- genres -->
  <xsl:template name="genre" match="col45">
    <xsl:if test="string-length(.)>0">
      <pbcoreGenre>
        <xsl:attribute name="source">The Moving Image Genre-form Guide</xsl:attribute>
        <xsl:value-of select="."/>
      </pbcoreGenre>
    </xsl:if>
  </xsl:template>
  <!-- coverage -->
  <xsl:template name="coverage" match="col45|col46">
    <xsl:if test="string-length(.)>0">
      <pbcoreCoverage>
        <xsl:variable name="column" select="count(preceding-sibling::*)+1"/>
        <xsl:attribute name="coverageType">
          <xsl:value-of select="../../row[1]/*[$column]"/>
        </xsl:attribute>
        <xsl:value-of select="."/>
      </pbcoreCoverage>
    </xsl:if>
  </xsl:template>
  <!-- creators -->
  <xsl:template name="creator" match="col15|col16|col17|col18|col19|col20">
    <xsl:if test="string-length(.)>0">
      <xsl:variable name="column" select="count(preceding-sibling::*)+1"/>
      <pbcoreCreator>
        <creator>
          <xsl:value-of select="."/>
        </creator>
        <creatorRole>
          <xsl:value-of select="../../row[1]/*[$column]"/>
        </creatorRole>
      </pbcoreCreator>
    </xsl:if>
  </xsl:template>
  <!-- contributors -->
  <xsl:template name="contributor" match="col30|col31|col32|col33|col34|col35|col36|col37|col38">
    <xsl:if test="string-length(.)>0">
      <xsl:variable name="column" select="count(preceding-sibling::*)+1"/>
      <pbcoreContributor>
        <contributor>
          <xsl:value-of select="."/>
        </contributor>
        <contributorRole>
          <xsl:value-of select="../../row[1]/*[$column]"/>
        </contributorRole>
      </pbcoreContributor>
    </xsl:if>
  </xsl:template>
  <!-- publishers -->
  <xsl:template name="publisher" match="col39|col40">
    <xsl:if test="string-length(.)>0">
      <xsl:variable name="column" select="count(preceding-sibling::*)+1"/>
      <pbcorePublisher>
        <publisher>
          <xsl:value-of select="."/>
        </publisher>
        <publisherRole>
          <xsl:value-of select="../../row[1]/*[$column]"/>
        </publisherRole>
      </pbcorePublisher>
    </xsl:if>
  </xsl:template>
  <!-- rights -->
  <xsl:template name="rights" match="col24|col60|col61|col63|col64">
    <xsl:if test="string-length(.)>0">
      <xsl:variable name="column" select="count(preceding-sibling::*)+1"/>
      <pbcoreRightsSummary>
        <rightsSummary>
          <xsl:attribute name="annotation">
            <xsl:value-of select="../../row[1]/*[$column]"/>
          </xsl:attribute>
          <xsl:value-of select="."/>
        </rightsSummary>
      </pbcoreRightsSummary>
    </xsl:if>
  </xsl:template>
  <!-- rights with date cleanup thing -->
  <xsl:template name="rights-date" match="col62">
    <xsl:if test="string-length(substring(.,3,string-length(.)-3))>0">
      <xsl:variable name="column" select="count(preceding-sibling::*)+1"/>
      <pbcoreRightsSummary>
        <rightsSummary>
          <xsl:attribute name="annotation">
            <xsl:value-of select="../../row[1]/*[$column]"/>
          </xsl:attribute>
          <xsl:value-of select="substring(.,3,string-length(.)-3)"/>
        </rightsSummary>
      </pbcoreRightsSummary>
    </xsl:if>
  </xsl:template>
  <!-- instantiation stuff -->
  <xsl:template name="instantiationPhysical" match="col25">
    <xsl:if test="string-length(.)>0">
      <instantiationPhysical>
        <xsl:value-of select="."/>
      </instantiationPhysical>
    </xsl:if>
  </xsl:template>
  <xsl:template name="instantiationLocation" match="XXX">
    <xsl:if test="string-length(.)>0">
      <instantiationLocation>
        <xsl:value-of select="."/>
      </instantiationLocation>
    </xsl:if>
  </xsl:template>
  <xsl:template name="instantiationMediaType" match="col8">
    <xsl:if test="string-length(.)>0">
      <instantiationMediaType>
        <xsl:value-of select="."/>
      </instantiationMediaType>
    </xsl:if>
  </xsl:template>
  <xsl:template name="instantiationGenerations" match="col9">
    <xsl:if test="string-length(.)>0">
      <instantiationGenerations>
        <xsl:value-of select="."/>
      </instantiationGenerations>
    </xsl:if>
  </xsl:template>
  <!-- extension templates -->
  <xsl:template name="extension-country" match="col21">
    <xsl:if test="string-length(.)>0">
      <xsl:variable name="column" select="count(preceding-sibling::*)+1"/>
      <pbcoreExtension>
        <extensionWrap>
          <extensionElement>
            <xsl:value-of select="../../row[1]/*[$column]"/>
          </extensionElement>
          <extensionValue>
            <xsl:value-of select="."/>
          </extensionValue>
          <extensionAuthorityUsed>ISO 3166.1</extensionAuthorityUsed>
        </extensionWrap>
      </pbcoreExtension>
    </xsl:if>
  </xsl:template>
  <xsl:template name="extension-cavpp" match="col5">
    <xsl:if test="string-length(.)>0">
      <xsl:variable name="column" select="count(preceding-sibling::*)+1"/>
      <pbcoreExtension>
        <extensionWrap>
          <extensionElement>
            <xsl:value-of select="../../row[1]/*[$column]"/>
          </extensionElement>
          <extensionValue>
            <xsl:value-of select="."/>
          </extensionValue>
          <extensionAuthorityUsed>CAVPP</extensionAuthorityUsed>
        </extensionWrap>
      </pbcoreExtension>
    </xsl:if>
  </xsl:template>
  <xsl:template name="extension" match="XXX">
    <xsl:if test="string-length(.)>0">
      <xsl:variable name="column" select="count(preceding-sibling::*)+1"/>
      <pbcoreExtension>
        <extensionWrap>
          <extensionElement>
            <xsl:value-of select="../../row[1]/*[$column]"/>
          </extensionElement>
          <extensionValue>
            <xsl:value-of select="substring-before(concat(., '('), '(')"/><!-- remove the parenthetical comment -->
          </extensionValue>
          <extensionAuthorityUsed>
            <xsl:value-of select="substring-before(substring-after(., '('), ')')"/><!-- take what is inside the parenthesis -->
          </extensionAuthorityUsed>
        </extensionWrap>
      </pbcoreExtension>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>