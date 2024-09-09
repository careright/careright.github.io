<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:hsqueue="xalan://com.healthsolve.xsl.MessageQueue"
                xmlns:hshtml="xalan://com.healthsolve.xsl.HTML2FO">
  <xsl:output method="xml" indent="yes"/>

  <xsl:variable name="result" select="document(concat('/results/', /request/id, '.xml?patient_id=', /request/patient_id, '&amp;type=', /request/type ))"/>
  <xsl:variable name="current_datetime" select="/request/current_datetime"/>

  <xsl:template match="/">

    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="simple" page-height="297mm" page-width="210mm" margin-top="10mm" margin-bottom="10mm" margin-left="10mm" margin-right="10mm">
          <fo:region-body region-name="xsl-region-body" margin-bottom="5mm" margin-top="78mm"/>
          <fo:region-before region-name="xsl-region-before" extent="78mm"/>
          <fo:region-after region-name="xsl-region-after" extent="5mm"/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      <fo:page-sequence master-reference="simple">
        <fo:static-content flow-name="xsl-region-before">
          <fo:block>
            <xsl:call-template name="layout-header-title"/>
            <xsl:call-template name="layout-header"/>
          </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="xsl-region-after">
          <fo:block>
            <xsl:call-template name="page_number"/>
            <xsl:call-template name="layout-footer"/>
          </fo:block>
        </fo:static-content>
        <fo:flow flow-name="xsl-region-body">
          <fo:block>
            <xsl:call-template name="layout-body"/>
          </fo:block>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <xsl:template name="layout-header-title">
    <fo:block text-align="center" font-weight="bold" font-size="larger" width="190mm" border-bottom-style="solid" padding-after="1mm">
      Results
      <!--Add a html source link to like a header graphic-->
      <!--<fo:external-graphic src="" />-->
    </fo:block>
  </xsl:template>

  <xsl:template name="layout-footer">
    <fo:block text-align="center" font-weight="bold" font-size="larger" width="190mm">
      <!--Add a html source link to like a footer graphic-->
      <!--<fo:external-graphic src="" />-->
    </fo:block>
  </xsl:template>


  <xsl:template name="layout-header">
      <fo:table padding-before="2mm">
        <fo:table-column font-weight="bold"/>
        <fo:table-column/>
        <fo:table-body>
          <fo:table-row>
            <!-- left column -->
            <fo:table-cell>
              <fo:table>
                <fo:table-column/>
                <fo:table-column/>
                <fo:table-body>

                  <xsl:call-template name="add-row">
                    <xsl:with-param name="title">Date</xsl:with-param>
                    <xsl:with-param name="value" select="$current_datetime"/>
                  </xsl:call-template>

                  <xsl:call-template name="add-row">
                    <xsl:with-param name="title"></xsl:with-param>
                  </xsl:call-template>

                  <xsl:call-template name="add-row">
                    <xsl:with-param name="title">Medical Provider</xsl:with-param>
                    <xsl:with-param name="value" select="$result/result/provider-name"/>
                  </xsl:call-template>

                  <xsl:call-template name="add-row">
                    <xsl:with-param name="title">Service Location</xsl:with-param>
                    <xsl:with-param name="value" select="$result/result/service-location-name"/>
                  </xsl:call-template>

                  <xsl:call-template name="add-row">
                    <xsl:with-param name="title"></xsl:with-param>
                  </xsl:call-template>

                  <fo:table-row>
                  <fo:table-cell font-weight="bold">
                  <fo:block>Patient:</fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                  <fo:block><xsl:value-of select="$result/result/patient-name"/></fo:block>
                  <fo:block>
                  <xsl:variable name="detail" select="$result/result/patient-address"/>
                  <xsl:copy-of select="hshtml:html2fo($detail, 0.60)"/>
                  </fo:block>
                  </fo:table-cell>
                  </fo:table-row>

                  <xsl:call-template name="add-row">
                    <xsl:with-param name="title">DOB</xsl:with-param>
                    <xsl:with-param name="value">
                      <xsl:call-template name="format-date-time"><xsl:with-param name="date" select="$result/result/patient-dob/text()"/></xsl:call-template>
                    </xsl:with-param>
                  </xsl:call-template>

                </fo:table-body>
              </fo:table>

            </fo:table-cell>
            <!-- right column -->
            <fo:table-cell>
              <fo:table>
                <fo:table-column/>
                <fo:table-column/>
                <fo:table-body>

                  <xsl:call-template name="add-row">
                    <xsl:with-param name="title">Service Provider</xsl:with-param>
                    <xsl:with-param name="value" select="$result/result/service-provider-name"/>
                  </xsl:call-template>

                  <xsl:call-template name="add-row">
                    <xsl:with-param name="title"></xsl:with-param>
                  </xsl:call-template>

                  <xsl:call-template name="add-row">
                    <xsl:with-param name="title">Result Title</xsl:with-param>
                    <xsl:with-param name="value" select="$result/result/result-title"/>
                  </xsl:call-template>

                  <xsl:call-template name="add-row">
                    <xsl:with-param name="title"></xsl:with-param>
                  </xsl:call-template>

                  <xsl:call-template name="add-row">
                    <xsl:with-param name="title">Request Date</xsl:with-param>
                    <xsl:with-param name="value">
                      <xsl:call-template name="format-date-time"><xsl:with-param name="date" select="$result/result/request-date/text()"/></xsl:call-template>
                    </xsl:with-param>
                  </xsl:call-template>

                  <xsl:call-template name="add-row">
                    <xsl:with-param name="title">Sample Date</xsl:with-param>
                    <xsl:with-param name="value">
                      <xsl:call-template name="format-date-time"><xsl:with-param name="date" select="$result/result/sample-date/text()"/></xsl:call-template>
                    </xsl:with-param>
                  </xsl:call-template>

                  <xsl:call-template name="add-row">
                    <xsl:with-param name="title">Reported Date</xsl:with-param>
                    <xsl:with-param name="value">
                      <xsl:call-template name="format-date-time"><xsl:with-param name="date" select="$result/result/reported-date/text()"/></xsl:call-template>
                    </xsl:with-param>
                  </xsl:call-template>

                </fo:table-body>
              </fo:table>
            </fo:table-cell>
          </fo:table-row>

        </fo:table-body>
      </fo:table>
    <fo:block-container position="absolute" top="70mm">
    <fo:block font-weight="bold" font-size="larger" width="190mm" border-bottom-style="solid" padding-after="1mm">
      Results
    </fo:block>
    </fo:block-container>

  </xsl:template>

  <xsl:template name="layout-body">
    <fo:block padding-before="2mm" font-family="Courier" background-color="#D3DFEE">
      <xsl:variable name="detail" select="$result/result/result-html"/>
      <xsl:copy-of select="hshtml:html2fo($detail, 0.60)"/>
    </fo:block>
  </xsl:template>

  <xsl:template name="page_number">
    <fo:block text-align="right" >
      Page <fo:page-number/>
    </fo:block>
  </xsl:template>

  <xsl:template name="format-date-time">
    <xsl:param name="date"/>

    <xsl:if test="$date">
      <!-- 2009-07-21T15:24:48+10:00 -->
      <xsl:value-of select="concat(substring($date, 9, 2), '/', substring($date, 6, 2), '/', substring($date, 1, 4), ' ', substring($date, 12, 5))"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="add-row">
    <xsl:param name="title"/>
    <xsl:param name="value"/>
    <fo:table-row >
      <fo:table-cell font-weight="bold">
        <fo:block>
          <xsl:choose>
            <xsl:when test="$title">
            <xsl:value-of select="$title"/>:
            </xsl:when>
          <xsl:otherwise>
            &#160;
          </xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block><xsl:value-of select="$value"/></fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>

</xsl:stylesheet>
