package com.paasta.scwui.service.cf.security;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.web.RedirectStrategy;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * {@link RedirectStrategy} redirecting to the UAA logout page.
 * <p/>
 * When the UAA has performed the logout on its side, the page is
 * redirected again to the specified URL.
 *
 * @author Sebastien Gerard
 */
public class DashboardLogoutRedirectStrategy implements RedirectStrategy {

    private final String uaaLogoutUrl;
    protected Logger logger = LoggerFactory.getLogger(getClass());
    public DashboardLogoutRedirectStrategy(String uaaLogoutUrl) {
        this.uaaLogoutUrl = uaaLogoutUrl;
    }

    @Override
    public void sendRedirect(HttpServletRequest request, HttpServletResponse response, String url) throws IOException {
        final String redirectUrl = uaaLogoutUrl + "?redirect=" + url;

        response.sendRedirect(response.encodeRedirectURL(redirectUrl));
    }
}
