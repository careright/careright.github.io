<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:hsqueue="xalan://com.healthsolve.xsl.MessageQueue" xmlns:hshtml="xalan://com.healthsolve.xsl.HTML2FO">
  <xsl:output method="xml" indent="yes"/>

  <xsl:variable name="current_appointments" select="document(concat('/patients/', /request/patient_id, '/appointments.xml'))"/>
  <xsl:variable name="patient" select="document(concat('/patients/', /request/patient_id, '.xml'))"/>

  <xsl:attribute-set name="PaddedCell">
    <xsl:attribute name="padding">1mm</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="HeadingPaddedCell">
    <xsl:attribute name="padding-left">1mm</xsl:attribute>
    <xsl:attribute name="padding-top">2mm</xsl:attribute>
    <xsl:attribute name="padding-bottom">2mm</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="/">
    <fo:root>
      <fo:layout-master-set>
        <!-- Define the printing setup. In this case, we are targeting standard A4 - see https://en.wikipedia.org/wiki/Paper_size -->
        <fo:simple-page-master master-name="simple" page-height="210mm" page-width="297mm"
                               margin-top="5mm" margin-bottom="8mm" margin-left="10mm" margin-right="10mm">
          <fo:region-body region-name="xsl-region-body" margin-bottom="5mm" margin-top="50mm"/>
          <fo:region-before region-name="xsl-region-before" extent="50mm"/>
          <fo:region-after region-name="xsl-region-after" extent="5mm"/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      <fo:page-sequence master-reference="simple">
        <fo:static-content flow-name="xsl-region-before">
          <fo:block>
            <xsl:call-template name="layout-header"/>
          </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="xsl-region-after">
          <fo:block>
            <xsl:call-template name="page_number"/>
            <!--<xsl:call-template name="layout-footer"/> you will need to adjust extents above if adding footer  -->
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

  <xsl:template name="layout-header">
    <fo:block text-align="center" width="190mm">
      <!-- Link to a header image, uploaded via Admin > System Images. Define the width and height for the orientation of your paper -->
      <fo:external-graphic src="system_images/LH" content-width="190mm" content-height="30mm" />
    </fo:block>
    <fo:block text-align="center" font-size="16pt" font-weight="bold">APPOINTMENT SCHEDULE</fo:block>
    <fo:block text-align="center" font-size="14pt" font-weight="bold">Future Appointments</fo:block>
  </xsl:template>

  <xsl:template name="patient-address">
    <fo:block>
      <xsl:value-of select="$patient/patient/display-name"/>
    </fo:block>
    <xsl:for-each select="$patient/patient/person/addresses/address[address-type-code='Home']">
      <fo:block>
        <xsl:value-of select="address1"/>
      </fo:block>
      <fo:block>
        <xsl:value-of select="address2"/>
      </fo:block>
      <fo:block>
        <xsl:value-of select="suburb"/>&#160;<xsl:value-of select="post-code"/>&#160;<xsl:value-of select="state-code"/>
      </fo:block>
    </xsl:for-each>
    <fo:block>
      <xsl:value-of select="$patient/patient/addresses"/>
    </fo:block>
    <fo:block padding-bottom="3mm">
    </fo:block>
  </xsl:template>

  <xsl:template name="layout-body">
    <xsl:call-template name="patient-address"/>
    <fo:table border-style="none">
      <fo:table-column column-width="10%"/>
      <fo:table-column column-width="10%"/>
      <fo:table-column column-width="10%"/>
      <fo:table-column column-width="70%"/>
      <fo:table-header background-color="#D3DFEE">
        <fo:table-row border-style="none">
          <fo:table-cell number-columns-spanned="3" xsl:use-attribute-sets="HeadingPaddedCell">
            <fo:block>Appointment Date &amp; Time</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="HeadingPaddedCell">
            <fo:block>Appointment Type</fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-header>
      <fo:table-body>
        <xsl:for-each select="$current_appointments/appointments/appointment">
          <xsl:variable name="altColor">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 0">#D3DFEE</xsl:when>
              <xsl:otherwise>#FFFFFF</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="provider" select="document(concat('/providers/', provider-id,'.xml'))"/>

          <fo:table-row keep-together.within-page="always" background-color="{$altColor}" border-top-style="none">
            <fo:table-cell xsl:use-attribute-sets="PaddedCell">
              <fo:block><xsl:value-of select="start-date-day"/></fo:block>
            </fo:table-cell>
            <fo:table-cell  xsl:use-attribute-sets="PaddedCell">
              <fo:block><xsl:value-of select="date"/></fo:block>
            </fo:table-cell>
            <fo:table-cell  xsl:use-attribute-sets="PaddedCell">
              <fo:block><xsl:value-of select="start-time-meridian"/></fo:block>
            </fo:table-cell>
            <fo:table-cell  xsl:use-attribute-sets="PaddedCell">
              <fo:block><xsl:value-of select="appointment-type-description"/></fo:block>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <xsl:template name="page_number">
    <fo:block text-align="right" >
      Printed: <xsl:value-of select="/request/date"/>
      Page <fo:page-number/>
    </fo:block>
  </xsl:template>

</xsl:stylesheet>
