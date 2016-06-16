<%@page import="java.text.DecimalFormat"%>
<%@page import="org.opencps.paymentmgt.search.PaymentFileDisplayTerms"%>
<%@page import="org.opencps.usermgt.service.WorkingUnitLocalServiceUtil"%>
<%@page import="org.opencps.usermgt.model.WorkingUnit"%>
<%@page import="com.liferay.portal.kernel.util.FastDateFormatFactoryUtil"%>
<%@page import="java.text.Format"%>
<%@page import="org.opencps.util.PortletUtil"%>
<%@page import="org.opencps.dossiermgt.service.DossierLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.HtmlUtil"%>
<%@page import="org.opencps.paymentmgt.model.impl.PaymentFileImpl"%>
<%@page import="org.opencps.paymentmgt.service.PaymentFileLocalServiceUtil"%>
<%@page import="org.opencps.paymentmgt.model.PaymentFile"%>
<%
/**
 * OpenCPS is the open source Core Public Services software
 * Copyright (C) 2016-present OpenCPS community
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
%>
<%@ include file="../init.jsp"%>

<%
    Format dateFormatDate = FastDateFormatFactoryUtil.getDate(locale, timeZone);
    String backRedirect = ParamUtil.getString(request, "redirect");
    long paymentFileId = ParamUtil.getLong(request, "paymentFileId");
    PaymentFile paymentFile = PaymentFileLocalServiceUtil.fetchPaymentFile(paymentFileId);
    String soHoSo = StringPool.BLANK;
    String coQuanQuanLyHoaDon = StringPool.BLANK;
    Dossier dossier = null;
    ServiceInfo serviceInfo = null;
    if(Validator.isNull(paymentFile)){
        paymentFile = new PaymentFileImpl();
    }else{
        soHoSo = DossierLocalServiceUtil.fetchDossier(paymentFile.getDossierId()).getReceptionNo();
        try {
             WorkingUnit wunit = WorkingUnitLocalServiceUtil.fetchByMappingOrganisationId(themeDisplay.getScopeGroupId(), paymentFile.getGovAgencyOrganizationId());
             if (wunit != null)
                 coQuanQuanLyHoaDon = wunit.getName();
        } catch (Exception e) {

        }
        dossier = DossierLocalServiceUtil.fetchDossier(paymentFile.getDossierId());
        serviceInfo = ServiceInfoLocalServiceUtil.fetchServiceInfo(dossier.getServiceInfoId());
    }
    DecimalFormat df2 = new DecimalFormat( "#,###,###,##0.00" );
%>
<liferay-ui:header
    backURL="<%= backRedirect %>"
    title="payment-cash"
    backLabel="back"
/>


<aui:form name="payForm" action="">
    <aui:input name="<%=PaymentFileDisplayTerms.PAYMENT_FILE_ID %>" value="<%= paymentFileId %>" type="hidden"></aui:input>
    <aui:input type="hidden" name="confirmHopLeHidden" value="1" />
    <div class="lookup-result">
       <table>
	        <tr style="background: rgb(250, 229, 211) none repeat scroll 0% 0%; text-align: left;">
	            <th style="padding: 6px; border: 1px solid lightgray;"><liferay-ui:message key="so-ho-so"/></th>
	            <th style="padding: 6px; border: 1px solid lightgray;"><%=HtmlUtil.escape(soHoSo) %></th>
	        </tr>
	        <tr>
	            <td class="col-left">
	                <liferay-ui:message key="thu-tuc-hanh-chinh"/>
	            </td>
	            <td class="col-right">
	                <%=HtmlUtil.escape(serviceInfo.getServiceName()) %>
	            </td>
	        </tr>       
	        <tr>
	            <td class="col-left">
	                <liferay-ui:message key="co-quan-thuc-hien"/>
	            </td>
	            <td class="col-right">
	                <%=HtmlUtil.escape(coQuanQuanLyHoaDon) %>
	            </td>
	        </tr>       
	        <tr>
	            <td class="col-left">
	                <liferay-ui:message key="ten-phi-thanh-toan"/>
	            </td>
	            <td class="col-right">
	                <%=HtmlUtil.escape(paymentFile.getPaymentName()) %>
	            </td>
	        </tr>     
            <tr>
                <td class="col-left">
                    <liferay-ui:message key="so-tien"/>
                </td>
                 <td class="col-right">
                <%=HtmlUtil.escape(df2.format(Double.valueOf(paymentFile.getAmount())).toString()) %>
            </td>
            </tr>       
            <tr>
                <td class="col-left">
                    <liferay-ui:message key="ghi-chu-kem-theo"/>
                </td>
                <td class="col-right">
                    <%=HtmlUtil.escape(paymentFile.getRequestNote()) %>
                </td>
            </tr>       
                
        </table>
    </div>
    <aui:button-row>
        <aui:input 
                name="termsOfUse"
                type="checkbox" 
                label="ban-da-thu-thu-so-tien-cua-nguoi-lam-thu-tuc"
        />
        <aui:button name="register" type="button" value="dong-y" disabled="true" />
        <aui:button name="back" value="back" href="<%=backRedirect.toString() %>" />
    </aui:button-row>
    
</aui:form>

<liferay-portlet:actionURL name="updateConfirmPayment" var="updateConfirmPaymentURL"></liferay-portlet:actionURL>

<aui:script>
    AUI().ready(function(A) {
        var termsOfUseCheckbox = A.one('#<portlet:namespace />termsOfUseCheckbox');
        if(termsOfUseCheckbox) {
            termsOfUseCheckbox.on('click',function() {
                
                var termsOfUse = A.one('#<portlet:namespace />termsOfUse');
                
                var register = A.one('#<portlet:namespace />register');
                
                if(termsOfUse.val() == 'true'){
                    register.removeClass('disabled');
                    register.removeAttribute('disabled');
                    register.setAttribute('onClick' , 'paymentFormSubmit();');
                }else{
                    register.addClass('disabled');
                    register.setAttribute('disabled' , 'true');
                    register.removeAttribute('onClick');
                }
            });
        }
    });
</aui:script>



<script type="text/javascript">
    function paymentFormSubmit() {
        document.<portlet:namespace />payForm.action = '<%= updateConfirmPaymentURL %>';
        
        submitForm(document.<portlet:namespace />payForm);
    }
</script>