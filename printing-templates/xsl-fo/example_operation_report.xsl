<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:hsqueue="xalan://com.healthsolve.xsl.MessageQueue"
                xmlns:hshtml="xalan://com.healthsolve.xsl.HTML2FO">
  <xsl:output method="xml" indent="yes"/>

  <xsl:variable name="appointment_id" select="/request/appointment_id"/>
  <xsl:variable name="current_datetime" select="/request/current_datetime"/>
  <xsl:variable name="calendar_session" select="document(concat('/theatre_lists/', /request/id, '/print_operation.xml?appointment_id=',$appointment_id))"/>

  <xsl:template match="/">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="singlePage" page-height="297mm" page-width="210mm" margin-top="10mm" margin-bottom="8mm" margin-left="10mm" margin-right="10mm">
          <fo:region-body region-name="xsl-region-body" margin-bottom="10mm" margin-top="45mm"/>
          <fo:region-before region-name="xsl-region-before" extent="10mm"/>
          <fo:region-after region-name="xsl-region-after" extent="8mm"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="firstPage" page-height="297mm" page-width="210mm" margin-top="10mm" margin-bottom="8mm" margin-left="10mm" margin-right="10mm">
          <fo:region-body region-name="xsl-region-body" margin-bottom="10mm" margin-top="45mm"/>
          <fo:region-before region-name="xsl-region-before" extent="10mm"/>
          <fo:region-after region-name="xsl-region-after" extent="8mm"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="otherPage" page-height="297mm" page-width="210mm" margin-top="10mm" margin-bottom="8mm" margin-left="10mm" margin-right="10mm">
          <fo:region-body region-name="xsl-region-body" margin-bottom="10mm" margin-top="45mm"/>
          <fo:region-before region-name="xsl-region-before-heading" extent="20mm"/>
          <fo:region-after region-name="xsl-region-after" extent="8mm"/>
        </fo:simple-page-master>
        <fo:page-sequence-master master-name="allPages">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference page-position="only" master-reference="singlePage"/>
            <fo:conditional-page-master-reference page-position="first" master-reference="firstPage"/>
            <fo:conditional-page-master-reference page-position="rest" master-reference="otherPage"/>
            <fo:conditional-page-master-reference page-position="last" master-reference="otherPage"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>
      </fo:layout-master-set>
      <xsl:for-each select="$calendar_session/CalendarSession">
        <xsl:for-each select="theatre_list">
          <fo:page-sequence master-reference="allPages" force-page-count="no-force" initial-page-number="1">
            <fo:static-content flow-name="xsl-region-before">
              <fo:block>
                <xsl:call-template name="layout-header"/>
              </fo:block>
            </fo:static-content>
            <fo:static-content flow-name="xsl-region-before-heading">
              <fo:block>
                <xsl:call-template name="layout-header"/>
              </fo:block>
            </fo:static-content>
            <fo:static-content flow-name="xsl-region-after">
              <fo:block>
                <xsl:call-template name="layout-footer"/>
              </fo:block>
            </fo:static-content>
            <fo:flow flow-name="xsl-region-body">
              <fo:block>
                <xsl:call-template name="layout-body"/>
              </fo:block>
            </fo:flow>
          </fo:page-sequence>
        </xsl:for-each>
      </xsl:for-each>
    </fo:root>
  </xsl:template>

  <xsl:template name="layout-header">
  <fo:block font-family="Helvetica" font-size="10pt">
    <fo:table border-bottom-style="solid">
      <fo:table-column/>
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell>
            <fo:block padding-after="4mm">
              <fo:block text-align="center" font-size="12pt" font-weight="bold">OPERATION RECORD</fo:block>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <fo:table-row>
          <fo:table-cell>
            <fo:block padding-after="4mm">
              <fo:block text-align="left"><fo:inline font-weight="bold">Procedure:</fo:inline>&#160;<xsl:value-of select="procedure"/></fo:block>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <fo:table-row>
          <fo:table-cell>
            <fo:table>
              <fo:table-column/>
              <fo:table-column/>
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block text-align="left"><fo:inline font-weight="bold">Date:</fo:inline>&#160;<xsl:value-of select="date"/></fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block text-align="left"><fo:inline font-weight="bold">Patient:</fo:inline>&#160;<xsl:value-of select="patient/title"/>&#160;<xsl:value-of select="patient/given_name"/>&#160;<xsl:value-of select="patient/family_name"/></fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block text-align="left"><fo:inline font-weight="bold">Surgeon:</fo:inline>&#160;<xsl:value-of select="../provider/person/title"/>&#160;<xsl:value-of select="../provider/person/given_name"/>&#160;<xsl:value-of select="../provider/person/family_name"/></fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block text-align="left"><fo:inline font-weight="bold">Address:</fo:inline>&#160;<xsl:value-of select="patient/home_address/address1"/></fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block text-align="left"><fo:inline font-weight="bold">Assistant:</fo:inline>&#160;<xsl:value-of select="assistant/title"/>&#160;<xsl:value-of select="assistant/first_name"/>&#160;<xsl:value-of select="assistant/last_name"/></fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block text-align="left">
                      <xsl:if test="patient/home_address/address2 !=''">
                          <xsl:value-of select="patient/home_address/address2"/>&#160;
                      </xsl:if>
                      <xsl:value-of select="patient/home_address/suburb"/>&#160;<xsl:value-of select="patient/home_address/post_code"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block text-align="left"><fo:inline font-weight="bold">Anaesthetist:</fo:inline>&#160;<xsl:value-of select="anaesthetist/title"/>&#160;<xsl:value-of select="anaesthetist/first_name"/>&#160;<xsl:value-of select="anaesthetist/last_name"/></fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block text-align="left"><fo:inline font-weight="bold">GP:</fo:inline>&#160;<xsl:value-of select="lmo/practitioner/title"/>&#160;<xsl:value-of select="lmo/practitioner/first_name"/>&#160;<xsl:value-of select="lmo/practitioner/last_name"/></fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block text-align="left"><fo:inline font-weight="bold">Hospital:</fo:inline>&#160;<xsl:value-of select="../calendar_session_type/active_service_location/name"/></fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block text-align="left"><fo:inline font-weight="bold">MRN:</fo:inline>&#160;<xsl:value-of select="patient/mrn"/>&#160;<fo:inline font-weight="bold">DOB:</fo:inline>&#160;<xsl:value-of select="patient/dob"/></fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </fo:block>
  </xsl:template>

  <xsl:template name="layout-body">
    <fo:block font-family="Helvetica" font-size="10pt">
        <fo:block>
          <fo:block padding-before="2mm" padding-after="2mm"><fo:inline font-weight="bold" border-after-style="solid">FINDINGS</fo:inline></fo:block>
          <fo:block>
            <xsl:variable name="findings" select="findings_html"/>
            <xsl:copy-of select="hshtml:html2fo($findings, 0.60)"/>
          </fo:block>
          <fo:block padding-before="2mm" padding-after="2mm"><fo:inline font-weight="bold" border-after-style="solid">TECHNIQUE</fo:inline></fo:block>
          <fo:block>
            <xsl:variable name="technique" select="technique_html"/>
            <xsl:copy-of select="hshtml:html2fo($technique, 0.60)"/>
          </fo:block>
          <fo:block padding-before="2mm" padding-after="2mm"><fo:inline font-weight="bold" border-after-style="solid">POST-OP ORDERS</fo:inline></fo:block>
          <fo:block>
            <xsl:variable name="post_op" select="post_op_html"/>
            <xsl:copy-of select="hshtml:html2fo($post_op, 0.60)"/>
          </fo:block>
        </fo:block>
    </fo:block>
    <fo:block page-break-after="always" ></fo:block>
  </xsl:template>

  <xsl:template name="layout-footer">
    <fo:block padding-before="2mm" font-family="Helvetica" font-size="10pt" text-align="right">Page <fo:page-number/></fo:block>
  </xsl:template>

</xsl:stylesheet>
