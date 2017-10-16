package com.paasta.scwui.config;
import com.paasta.scwui.service.cf.security.*;
import com.paasta.scwui.service.user.UserService;
import com.paasta.scwui.service.user.UserServiceInstanceService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.security.authentication.AuthenticationDetailsSource;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.oauth2.client.DefaultOAuth2ClientContext;
import org.springframework.security.oauth2.client.OAuth2ClientContext;
import org.springframework.security.oauth2.client.OAuth2RestTemplate;
import org.springframework.security.oauth2.client.filter.OAuth2ClientContextFilter;
import org.springframework.security.oauth2.client.token.AccessTokenRequest;
import org.springframework.security.oauth2.client.token.DefaultAccessTokenRequest;
import org.springframework.security.oauth2.client.token.grant.code.AuthorizationCodeResourceDetails;
import org.springframework.security.oauth2.provider.token.*;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.web.util.matcher.RequestMatcher;
import org.springframework.web.context.WebApplicationContext;

import javax.servlet.http.HttpServletRequest;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;

import static com.paasta.scwui.config.FilterWrapper.wrap;
import static java.util.Arrays.asList;

/**
 * {@link Configuration} related to the dashboard security.
 *
 * @author Sebastien Gerard
 */
@Configuration
public class DashboardSecurityConfiguration {
    public static Logger logger = LoggerFactory.getLogger(DashboardSecurityConfiguration.class);
    /**
     * Returns the SPeL expression checking that the current user is authorized
     * to manage this service.
     */
    public static String isManagingApp() {
        logger.debug( "(authentication.details != null) " +
                "and (authentication.details instanceof T(" + DashboardAuthenticationDetails.class.getName() + ")) "
                + "and authentication.details.managingService "
                + "and hasRole('" + SecurityConfig.ROLE_OWNER + "')");
        return "(authentication.details != null) " +
              "and (authentication.details instanceof T(" + DashboardAuthenticationDetails.class.getName() + ")) "
              + "and authentication.details.managingService "
              + "and hasRole('" + SecurityConfig.ROLE_OWNER + "')";
    }

    @Value("${cf.uaa.oauth.client.id}")
    private String clientId;

    @Value("${cf.uaa.oauth.client.secret}")
    private String clientSecret;

    @Value("${cf.uaa.oauth.info.uri}")
    private String oauthInfoUrl;

    @Value("${cf.api.url}")
    private String apiUrl;

    @Value("${cf.uaa.oauth.token.check.uri}")
    private String checkTokenUri;

    @Value("${cf.uaa.oauth.authorization.uri}")
    private String authorizationUri;

    @Value("${cf.uaa.oauth.token.access.uri}")
    private String accessUri;

    @Value("${cf.uaa.oauth.logout.url}")
    private String logoutUrl;

    @Value("${api.base.url}")
    private String apiBaseUrl;

    @Value("${dashboard.requestMatcher.url}")
    private String dashboardRequestMatcherUrl;

    @Autowired
    @Qualifier("authenticationManager")
    private AuthenticationManager authenticationManager;

    @Autowired
    private HttpServletRequest httpServletRequest;

    @Bean(name = "dashboardEntryPointMatcher")
    public RequestMatcher dashboardEntryPointMatcher() {

        return new AntPathRequestMatcher(dashboardRequestMatcherUrl);
    }

    @Bean(name = "dashboardClientContextFilter")
    public FilterWrapper dashboardClientContextFilter() {
        // If it was a Filter bean it would be automatically added out of the Spring security filter chain.
        return wrap(new OAuth2ClientContextFilter());
    }

    @Bean(name = "dashboardSocialClientFilter")
    @Autowired
    public FilterWrapper dashboardSocialClientFilter() {
        // If it was a Filter bean it would be automatically added out of the Spring security filter chain.
        final DashboardAuthenticationProcessingFilter filter
              = new DashboardAuthenticationProcessingFilter();

        filter.setRestTemplate(dashboardRestOperations());
        filter.setTokenServices(dashboardResourceServerTokenServices());
        filter.setAuthenticationManager(authenticationManager);
        filter.setRequiresAuthenticationRequestMatcher(dashboardEntryPointMatcher());
        filter.setDetailsSource(dashboardAuthenticationDetailsSource());
        filter.setAuthenticationSuccessHandler(new DashboardAuthenticationSuccessHandler());

        return wrap(filter);
    }

    @Bean(name = "dashboardProtectedResourceDetails")
    @Scope(value = WebApplicationContext.SCOPE_SESSION)
    @Autowired
    public AuthorizationCodeResourceDetails dashboardProtectedResourceDetails() {
        final AuthorizationCodeResourceDetails resourceDetails = new AuthorizationCodeResourceDetails() {
            @Override
            public boolean isClientOnly() {
                return true;
            }
        };

        resourceDetails.setClientId(clientId);
        resourceDetails.setClientSecret(clientSecret);
        resourceDetails.setUserAuthorizationUri(authorizationUri);
        resourceDetails.setAccessTokenUri(accessUri);
        resourceDetails.setUseCurrentUri(true);
        resourceDetails.setScope(asList("openid", "cloud_controller_service_permissions.read"));

        return resourceDetails;
    }

    @Bean(name = "dashboardClientContext")
    @Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.TARGET_CLASS)
    @Autowired
    public OAuth2ClientContext dashboardClientContext() {
        return new DefaultOAuth2ClientContext(dashboardAccessTokenRequest());
    }

    @Bean(name = "dashboardAccessTokenRequest")
    @Scope(value = WebApplicationContext.SCOPE_REQUEST, proxyMode = ScopedProxyMode.TARGET_CLASS)
    @Autowired
    public AccessTokenRequest dashboardAccessTokenRequest() {
        final DefaultAccessTokenRequest request = new DefaultAccessTokenRequest(httpServletRequest.getParameterMap());

        final Object currentUri = httpServletRequest.getAttribute(OAuth2ClientContextFilter.CURRENT_URI);
        if (currentUri != null) {
            request.setCurrentUri(currentUri.toString());
        }

        return request;
    }

    @Bean(name = "dashboardRestOperations")
    @Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.TARGET_CLASS)
    @Autowired
    public OAuth2RestTemplate dashboardRestOperations() {


        try {
            SSLUtils.turnOffSslChecking();
        } catch (NoSuchAlgorithmException | KeyManagementException e) {
            e.printStackTrace();
        }

        OAuth2RestTemplate oAuth2RestTemplate =
                new OAuth2RestTemplate(dashboardProtectedResourceDetails(), dashboardClientContext());

        return oAuth2RestTemplate;
    }

    @Bean(name = "dashboardAccessTokenConverter")
    public AccessTokenConverter dashboardAccessTokenConverter() {
        final DefaultAccessTokenConverter defaultAccessTokenConverter = new DefaultAccessTokenConverter();

        final DefaultUserAuthenticationConverter userTokenConverter = new DefaultUserAuthenticationConverter();
        userTokenConverter.setDefaultAuthorities(new String[]{SecurityConfig.ROLE_OWNER});

        defaultAccessTokenConverter.setUserTokenConverter(userTokenConverter);

        return defaultAccessTokenConverter;
    }

    @Bean(name = "dashboardResourceServerTokenServices")
    @Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.TARGET_CLASS)
    @Autowired
    public ResourceServerTokenServices dashboardResourceServerTokenServices() {
        final RemoteTokenServices remoteTokenServices = new RemoteTokenServices();

        remoteTokenServices.setClientId(clientId);
        remoteTokenServices.setClientSecret(clientSecret);
        remoteTokenServices.setCheckTokenEndpointUrl(checkTokenUri);
        remoteTokenServices.setAccessTokenConverter(dashboardAccessTokenConverter());

        return remoteTokenServices;
    }

    @Bean(name = "dashboardAuthenticationDetailsSource")
    @Autowired
    public AuthenticationDetailsSource<HttpServletRequest, ?> dashboardAuthenticationDetailsSource() {
        return new DashboardAuthenticationDetailsSource(dashboardRestOperations(), oauthInfoUrl, apiUrl);
    }

    @Bean(name = "dashboardAuthenticationProvider")
    @Autowired
    public DashboardAuthenticationProvider dashboardAuthenticationProvider(UserService userService, UserServiceInstanceService instanceUseService) {
        return new DashboardAuthenticationProvider(userService, instanceUseService);
    }

    @Bean(name = "dashboardLogoutSuccessHandler")
    public LogoutSuccessHandler dashboardLogoutSuccessHandler() {
        final SimpleUrlLogoutSuccessHandler logoutSuccessHandler = new SimpleUrlLogoutSuccessHandler();

        logoutSuccessHandler.setRedirectStrategy(new DashboardLogoutRedirectStrategy(logoutUrl));

        return logoutSuccessHandler;
    }

    @Bean(name = "dashboardLogoutUrlMatcher")
    public RequestMatcher dashboardLogoutUrlMatcher() {
        return new AntPathRequestMatcher("/user/logout");
    }
}
