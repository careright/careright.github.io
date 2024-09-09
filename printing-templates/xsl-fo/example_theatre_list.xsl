<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:hsqueue="xalan://com.healthsolve.xsl.MessageQueue"
                xmlns:hshtml="xalan://com.healthsolve.xsl.HTML2FO">
  <xsl:output method="xml" indent="yes"/>

  <xsl:variable name="calendar_session" select="document(concat('/theatre_lists/', /request/id, '/print.xml'))"/>
  <xsl:variable name="current_datetime" select="/request/current_datetime"/>

  <xsl:attribute-set name="PaddedCell">
    <xsl:attribute name="padding">1mm</xsl:attribute>
    <xsl:attribute name="border-style">solid</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="/">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="singlePage" page-height="210mm" page-width="297mm" margin-top="10mm" margin-bottom="8mm" margin-left="10mm" margin-right="10mm">
          <fo:region-body region-name="xsl-region-body" margin-bottom="10mm" margin-top="25mm"/>
          <fo:region-before region-name="xsl-region-before" extent="10mm"/>
          <fo:region-after region-name="xsl-region-after" extent="8mm"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="firstPage" page-height="210mm" page-width="297mm" margin-top="10mm" margin-bottom="8mm" margin-left="10mm" margin-right="10mm">
          <fo:region-body region-name="xsl-region-body" margin-bottom="10mm" margin-top="25mm"/>
          <fo:region-before region-name="xsl-region-before" extent="10mm"/>
          <fo:region-after region-name="xsl-region-after" extent="8mm"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="otherPage" page-height="210mm" page-width="297mm" margin-top="10mm" margin-bottom="8mm" margin-left="10mm" margin-right="10mm">
          <fo:region-body region-name="xsl-region-body" margin-bottom="10mm" margin-top="25mm"/>
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
        <fo:page-sequence master-reference="allPages">
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
              <xsl:call-template name="page_number"/>
            </fo:block>
          </fo:static-content>
          <fo:flow flow-name="xsl-region-body">
            <fo:block>
              <xsl:call-template name="layout-body">
                <xsl:with-param name="scope" select="theatre_list"></xsl:with-param>
              </xsl:call-template>
            </fo:block>

            <xsl:variable name="recordCount" select="count(cancelled_appointments_list)"/>
            <xsl:if test="$recordCount &gt; 0">
              <fo:block>
                <fo:block font-family="Helvetica" padding-before="4mm" padding-after="1mm">
                  <fo:block font-size="12pt" font-weight="bold">Cancelled Appointments</fo:block>
                </fo:block>
                <xsl:call-template name="layout-body">
                  <xsl:with-param name="scope" select="cancelled_appointments_list"></xsl:with-param>
                </xsl:call-template>
              </fo:block>
            </xsl:if>

          </fo:flow>
        </fo:page-sequence>
      </xsl:for-each>
    </fo:root>
  </xsl:template>

  <xsl:template name="layout-header">
  <fo:block font-family="Helvetica">
    <fo:table>
      <fo:table-column/>
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell>
            <fo:block padding-after="2mm">
            <fo:block text-align="center" font-size="12pt" font-weight="bold"><xsl:value-of select="calendar_session_type/active_service_location/description"/> Theatre List <xsl:value-of select="date"/> - <xsl:value-of select="provider/person/title"/>&#160;<xsl:value-of select="provider/person/given_name"/>&#160;<xsl:value-of select="provider/person/family_name"/> - Start <xsl:value-of select="substring-after(start_time, ' ')"/> End <xsl:value-of select="substring-after(end_time, ' ')"/></fo:block>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <fo:table-row>
          <fo:table-cell>
            <fo:block padding-after="2mm">
            <fo:block text-align="left" font-size="10pt"><fo:inline font-weight="bold">Private and Confidential Notice:</fo:inline> The information contained in this report is intended for the named recipients only. It may contain privileged and confidential information and if you are not the intended recipient you must not copy, distribute or take any reliance on it. If you have received this information in error please notify the sender.</fo:block>
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
                  <fo:block text-align="left" font-size="10pt">Ph: <fo:inline font-weight="bold"><xsl:value-of select="calendar_session_type/location/phone"/></fo:inline> Email: <fo:inline font-weight="bold"><xsl:value-of select="calendar_session_type/location/email_from"/></fo:inline></fo:block>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block text-align="right" font-size="10pt">Printed: <fo:inline font-weight="bold"><xsl:value-of  select="$current_datetime"/></fo:inline></fo:block>
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
    <xsl:param name="scope"/>
    <fo:block font-family="Helvetica" font-size="10pt">
    <fo:table border-style="solid">
      <fo:table-column column-width="30pt" />
      <fo:table-column column-width="130pt"/>
      <fo:table-column column-width="120pt"/>
      <fo:table-column/>
      <fo:table-column  column-width="120pt"/>
      <fo:table-column  column-width="110pt" />
      <fo:table-header>
        <fo:table-row border-style="solid">
          <fo:table-cell>
            <fo:block></fo:block>
          </fo:table-cell>
          <fo:table-cell number-columns-spanned="2">
            <fo:block font-weight="bold">Patient Details</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-weight="bold">Procedure</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-weight="bold">Insurance</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-weight="bold">Other</fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-header>
      <fo:table-body>
        <xsl:for-each select="$scope">
          <xsl:variable name="altColor">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 0">#FFFFFF</xsl:when>
              <xsl:otherwise>#D3DFEE</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <fo:table-row background-color="{$altColor}" keep-together.within-page="always" keep-with-next.within-page="always">
            <fo:table-cell border-style="solid" number-rows-spanned="2">
              <fo:block font-weight="bold"><xsl:value-of select="substring-after(start_time, ' ')"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-weight="bold">
                <xsl:value-of select="patient/family_name"/>, <xsl:value-of select="patient/given_name"/>, <xsl:value-of select="patient/title"/>
                (<xsl:choose>
                  <xsl:when test="patient/gender = 1">M</xsl:when>
                  <xsl:when test="patient/gender = 2">F</xsl:when>
                  <xsl:otherwise>U</xsl:otherwise>
                </xsl:choose>)
              </fo:block>
              <fo:block>
                DOB: <xsl:value-of select="patient/dob"/>
              </fo:block>
              <fo:block>
                <xsl:value-of select="patient/home_address/address1"/>
              </fo:block>
              <xsl:if test="patient/home_address/address2 !=''">
                <fo:block>
                  <xsl:value-of select="patient/home_address/address2"/>
                </fo:block>
              </xsl:if>
              <fo:block>
                <xsl:value-of select="patient/home_address/suburb"/>&#160;<xsl:value-of select="patient/home_address/post_code"/>
              </fo:block>
              <fo:block>
                <xsl:value-of select="patient/home_address/state_code"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block >
                <xsl:if test="patient/mobile_phone !=''">
                <fo:block>
                  M: <xsl:value-of select="patient/mobile_phone"/>
                </fo:block>
                </xsl:if>
                <xsl:if test="patient/home_phone !=''">
                  <fo:block>
                    H: <xsl:value-of select="patient/home_phone"/>
                  </fo:block>
                </xsl:if>
                <xsl:if test="patient/work_phone !=''">
                  <fo:block>
                    W: <xsl:value-of select="patient/work_phone"/>
                  </fo:block>
                </xsl:if>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell number-rows-spanned="2" border-style="solid">
              <fo:block font-weight="bold"><xsl:value-of select="procedure"/>&#160;<xsl:value-of select="anaesthetic_choice/name"/>&#160;<xsl:value-of select="duration"/> mins</fo:block>
              <fo:block>
                <xsl:choose>
                  <xsl:when test="planned_admission_days = 1">DAY SURGERY</xsl:when>
                  <xsl:otherwise>INPATIENT (<xsl:value-of select="planned_admission_days"/> days)</xsl:otherwise>
                </xsl:choose>
                &#160;Admit <xsl:value-of select="planned_admission_date"/> at <xsl:value-of select="substring-after(planned_admission_time, ' ')"/>
                <xsl:if test="planned_discharge_date != ''">
                  <fo:block>
                    Planned Discharge Date <xsl:value-of select="planned_discharge_date" />
                  </fo:block>
                </xsl:if>
                <xsl:if test="assistant/last_name !=''">
                  <fo:block>
                    Assist: <xsl:value-of select="assistant/title"/>&#160;<xsl:value-of select="assistant/first_name"/>&#160;<xsl:value-of select="assistant/last_name"/>&#160;<xsl:value-of select="assistant/city"/> (<xsl:value-of select="assistant/phone"/>)
                  </fo:block>
                </xsl:if>
                <xsl:if test="referral/referral_date !=''">
                  <fo:block>
                    Ref: <xsl:value-of select="referral/practitioner/title"/>&#160;<xsl:value-of select="referral/practitioner/first_name"/>&#160;<xsl:value-of select="referral/practitioner/last_name"/>&#160;<xsl:value-of select="referral/practitioner/city"/> (<xsl:value-of select="referral/practitioner/phone"/>)
                  </fo:block>
                </xsl:if>
                <xsl:if test="lmo/referral_date !=''">
                  <fo:block>
                    Usual GP: <xsl:value-of select="lmo/practitioner/title"/>&#160;<xsl:value-of select="lmo/practitioner/first_name"/>&#160;<xsl:value-of select="lmo/practitioner/last_name"/>&#160;<xsl:value-of select="lmo/practitioner/city"/> (<xsl:value-of select="lmo/practitioner/phone"/>)
                  </fo:block>
                </xsl:if>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell number-rows-spanned="2" border-style="solid">
              <fo:block>
                <fo:block>
                  <xsl:choose>
                    <xsl:when test="patient/guarantor/name">
                      <xsl:value-of select="patient/guarantor/name"/>&#160;<xsl:value-of select="patient/healthcare_fund_member_number"/>
                      <xsl:if test="patient/healthcare_fund_irn > 0">-<xsl:value-of select="patient/healthcare_fund_irn"/></xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      Uninsured
                    </xsl:otherwise>
                  </xsl:choose>
                </fo:block>
                <xsl:if test="patient/dva_number !=''">
                  <fo:block>
                    DVA: <xsl:value-of select="patient/dva_number"/> Card: <xsl:value-of select="patient/dva_card_type"/>
                  </fo:block>
                </xsl:if>
                <xsl:if test="patient/medicare_number !=''">
                  <fo:block>
                    Medicare: <xsl:value-of select="patient/medicare_number"/>-<xsl:value-of select="patient/medicare_irn"/>
                  </fo:block>
                </xsl:if>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell number-rows-spanned="2" border-style="solid">
              <fo:block>
                <xsl:if test="anaesthetist/first_name">
                  <fo:block>
                  Anaes. <xsl:value-of select="anaesthetist/title"/>&#160;<xsl:value-of select="anaesthetist/first_name"/>&#160;<xsl:value-of select="anaesthetist/last_name"/>
                  </fo:block>
                  <xsl:if test="anaesthetist/phone">
                    <fo:block>
                      (T: <xsl:value-of select="anaesthetist/phone"/>)
                    </fo:block>
                  </xsl:if>
                  <xsl:if test="anaesthetist/fax">
                    <fo:block>
                      (F: <xsl:value-of select="anaesthetist/fax"/>)
                    </fo:block>
                  </xsl:if>
                </xsl:if>
              </fo:block>
              <fo:block>
                Anaes. Type: <xsl:value-of select="anaesthetic_choice/name"/>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
          <fo:table-row background-color="{$altColor}" keep-together.within-page="always" border-bottom="1pt solid black">
            <fo:table-cell number-columns-spanned="2">
              <xsl:choose>
                <xsl:when test="patient/email !=''">
                  <fo:block>
                    E: <xsl:value-of select="patient/email"/>
                  </fo:block>
                </xsl:when>
                <xsl:otherwise>
                  <fo:block>
                  </fo:block>
                </xsl:otherwise>
              </xsl:choose>
            </fo:table-cell>
          </fo:table-row>
          <fo:table-row background-color="{$altColor}" keep-together.within-page="always">
            <fo:table-cell border-style="solid">
              <fo:block></fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="PaddedCell" number-columns-spanned="3">
              <fo:block border-after-style="solid">
                <fo:inline font-weight="bold">Appointment Type</fo:inline>&#160;<xsl:value-of select="appointment_type_description"/>
                <xsl:if test="room_description != ''">
                  &#160;<fo:inline font-weight="bold">Room</fo:inline>&#160;<xsl:value-of select="room_description"/>
                </xsl:if>
              </fo:block>
              <fo:block font-weight="bold">Notes</fo:block>
              <fo:block>
                <xsl:if test="pre_op_hospital_note !=''">
                  <fo:block>
                    <xsl:value-of select="pre_op_hospital_note"/>
                  </fo:block>
                </xsl:if>
                <xsl:if test="pre_op_patient_and_hospital_note !=''">
                  <fo:block>
                    <xsl:value-of select="pre_op_patient_and_hospital_note"/>
                  </fo:block>
                </xsl:if>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="PaddedCell" number-columns-spanned="2">
              <fo:block>
                <fo:table>
                  <fo:table-column column-width="40pt"/>
                  <fo:table-column/>
                  <fo:table-column column-width="55pt"/>
                  <fo:table-header font-weight="bold">
                    <fo:table-row border-bottom-style="solid">
                      <fo:table-cell>
                        <fo:block>Alert</fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block>Description</fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block>Identified</fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                  </fo:table-header>
                  <fo:table-body>
                    <xsl:call-template name="display_allergies"/>
                    <xsl:call-template name="display_alerts"/>
                  </fo:table-body>
                </fo:table>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>
    </fo:block>
  </xsl:template>

  <xsl:template name="page_number">
    <fo:block padding-before="2mm" font-family="Helvetica" font-size="10pt" text-align="right">Page <fo:page-number/></fo:block>
  </xsl:template>

  <xsl:template name="display_allergies">
    <xsl:choose>
      <xsl:when test="patient/active_allergies">
        <xsl:for-each select="patient/active_allergies">
          <fo:table-row>
            <fo:table-cell>
              <fo:block>Allergy</fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block><xsl:value-of select="description"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block><xsl:value-of select="substring-before(identified, ' ')"/></fo:block>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <fo:table-row>
          <fo:table-cell>
            <fo:block>Allergy</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block>No Allergies</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block></fo:block>
          </fo:table-cell>
        </fo:table-row>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="display_alerts">
    <xsl:choose>
      <xsl:when test="patient/active_alerts">
        <xsl:for-each select="patient/active_alerts">
          <fo:table-row>
            <fo:table-cell>
              <fo:block>Alert</fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block><xsl:value-of select="description"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block><xsl:value-of select="substring-before(start_date, ' ')"/></fo:block>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <fo:table-row>
          <fo:table-cell>
            <fo:block>Alert</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block>No Alert</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block></fo:block>
          </fo:table-cell>
        </fo:table-row>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
