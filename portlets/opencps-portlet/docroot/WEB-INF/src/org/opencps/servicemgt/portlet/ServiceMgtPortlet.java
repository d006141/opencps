/**
 * OpenCPS is the open source Core Public Services software Copyright (C)
 * 2016-present OpenCPS community This program is free software: you can
 * redistribute it and/or modify it under the terms of the GNU Affero General
 * Public License as published by the Free Software Foundation, either version 3
 * of the License, or any later version. This program is distributed in the hope
 * that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Affero General Public License for more details. You should have received a
 * copy of the GNU Affero General Public License along with this program. If
 * not, see <http://www.gnu.org/licenses/>
 */

package org.opencps.servicemgt.portlet;

import java.io.IOException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.opencps.servicemgt.model.ServiceInfo;
import org.opencps.servicemgt.search.ServiceDisplyTerms;
import org.opencps.servicemgt.service.ServiceInfoLocalServiceUtil;
import org.opencps.util.WebKeys;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;

/**
 * @author khoavd
 */
public class ServiceMgtPortlet extends MVCPortlet {
	
	/**
	 * @param renderRequest
	 * @param renderResponse
	 * @return
	 * @throws PortalException
	 * @throws SystemException
	 */
	public ServiceInfo updateService(
		ActionRequest actionRequest, ActionResponse actionResponse)
						throws PortalException, SystemException {

		ServiceDisplyTerms displayTerms = new ServiceDisplyTerms(actionRequest);
		
		_log.debug(displayTerms.getServiceProcess());
		
		return null;
	}

	/*
	 * (non-Javadoc)
	 * @see javax.portlet.GenericPortlet#render(javax.portlet.RenderRequest,
	 * javax.portlet.RenderResponse)
	 */
	@Override
	public void render(
	    RenderRequest renderRequest, RenderResponse renderResponse)
	    throws PortletException, IOException {

		long serviceinfoId = ParamUtil.getLong(renderRequest, "serviceinfoId");

		ServiceInfo serviceInfo = null;

		try {
			serviceInfo =
			    ServiceInfoLocalServiceUtil.fetchServiceInfo(serviceinfoId);
		}
		catch (Exception e) {
			_log.error(e);
		}

		renderRequest.setAttribute(WebKeys.SERVICE_ENTRY, serviceInfo);

		super.render(renderRequest, renderResponse);

	}

	private static final Log _log =
	    LogFactoryUtil.getLog(ServiceMgtPortlet.class);
}
