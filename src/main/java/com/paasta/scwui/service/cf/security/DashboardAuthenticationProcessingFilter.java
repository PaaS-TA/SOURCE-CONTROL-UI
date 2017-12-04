package com.paasta.scwui.service.cf.security;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.AuthenticationDetailsSource;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.client.filter.OAuth2ClientAuthenticationProcessingFilter;
import org.springframework.security.oauth2.provider.OAuth2Authentication;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Extension of {@link OAuth2ClientAuthenticationProcessingFilter} that uses the
 * {@link org.springframework.security.authentication.AuthenticationManager}.
 * This implementation also starts authentication if there is no authentication and
 * if the current request requires authentication.
 *
 * @author Sebastien Gerard
 */
public class DashboardAuthenticationProcessingFilter extends OAuth2ClientAuthenticationProcessingFilter {


    private AuthenticationDetailsSource<HttpServletRequest, ?> detailsSource;
    public DashboardAuthenticationProcessingFilter() {
        super("/");
    }
    protected Logger logger = LoggerFactory.getLogger(getClass());

    @Override
    protected boolean requiresAuthentication(HttpServletRequest request, HttpServletResponse response) {
        logger.debug("requiresAuthentication start");
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String[] path = request.getServletPath().split("/");
        String serviceInstanceId = "";
        if(path.length>0){
            serviceInstanceId=path[path.length-1];
        }
        logger.debug("requiresAuthentication ::: serviceInstanceId ::: " +serviceInstanceId+"::start" );
        return (authentication == null
                || !(((DashboardAuthenticationDetails)authentication.getDetails()).isManagedServiceInstance(serviceInstanceId)))
                && super.requiresAuthentication(request, response);
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response)
            throws AuthenticationException, IOException, ServletException {
        logger.debug("attemptAuthentication start");
        final Authentication authentication = super.attemptAuthentication(request, response);

        if (detailsSource != null) {
            request.getSession().invalidate();
            ((OAuth2Authentication) authentication).setDetails(detailsSource.buildDetails(request));
        }
        logger.debug("attemptAuthentication end");
        return getAuthenticationManager().authenticate(authentication);
    }

    /**
     * Sets the optional source providing {@link Authentication#getDetails() authentication details}.
     */
    public void setDetailsSource(AuthenticationDetailsSource<HttpServletRequest, ?> detailsSource) {
        logger.debug("setDetailsSource start");
        this.detailsSource = detailsSource;
        logger.debug("setDetailsSource end");
    }
}
