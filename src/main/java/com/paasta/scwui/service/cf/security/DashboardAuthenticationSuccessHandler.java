package com.paasta.scwui.service.cf.security;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.access.ExceptionTranslationFilter;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Extension of {@link SavedRequestAwareAuthenticationSuccessHandler}
 * for the dashboard. In this case, {@link ExceptionTranslationFilter}
 * in charge of persisting the request is not called. So, this handler
 * is not able to recover the original request that was redirected
 * to the OAuth server. Once logged, the OAuth server redirects to the
 * original page, i.e., the current request. In order to continue
 * the filter chain, a refresh is performed.
 *
 * @author Sebastien Gerard
 */
public class DashboardAuthenticationSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {

    private final RequestCache requestCache = new HttpSessionRequestCache();
    protected Logger logger = LoggerFactory.getLogger(getClass());
    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws ServletException, IOException {
        requestCache.saveRequest(request, response);
        logger.debug("onAuthenticationSuccess start");
        super.onAuthenticationSuccess(request, response, authentication);
        logger.debug("onAuthenticationSuccess end");
    }
}
