package com.paasta.scwui.service.cf.security;

import com.paasta.scwui.common.util.Common;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.AuthenticationDetailsSource;
import org.springframework.security.oauth2.provider.authentication.OAuth2AuthenticationDetails;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * {@link AuthenticationDetailsSource} providing extra details about the current
 * user and his grant to manage the current service instance.
 *
 * @author Sebastien Gerard
 */
public class DashboardAuthenticationDetailsSource
      implements AuthenticationDetailsSource<HttpServletRequest, OAuth2AuthenticationDetails> {

    /**
     * Token to use in {@link #getCheckUrl(String serviceInstanceId)} to specify the service instance id.
     */
    public static final String TOKEN_SUID = "[SUID]";

    /**
     * Key used in the JSON map returned by the call to {@link #getCheckUrl(String serviceInstanceId)} and associated
     * to the service instance id.
     */
    public static final String MANAGED_KEY = "manage";

    protected Logger logger = LoggerFactory.getLogger(getClass());

    private final RestTemplate restTemplate;
    private final String userInfoUrl;
    private final String apiUrl;

    /**
     * Returns the full name (first + last name) contains in the specified map.
     */
    protected static String getUserFullName(Map<String, String> map) {
        if (map.containsKey("name")) {
            return map.get("name");
        }
        if (map.containsKey("formattedName")) {
            return map.get("formattedName");
        }
        if (map.containsKey("fullName")) {
            return map.get("fullName");
        }
        String firstName = null;
        if (map.containsKey("firstName")) {
            firstName = map.get("firstName");
        }
        if (map.containsKey("givenName")) {
            firstName = map.get("givenName");
        }
        String lastName = null;
        if (map.containsKey("lastName")) {
            lastName = map.get("lastName");
        }
        if (map.containsKey("familyName")) {
            lastName = map.get("familyName");
        }
        if (firstName != null) {
            if (lastName != null) {
                return firstName + " " + lastName;
            }
        }
        return null;
    }

    /**
     * @param restTemplate the template to use to contact Cloud components
     * @param userInfoUrl the URL used to get the current OAuth user details
     * @param apiUrl the URL used to get the service instance permission
     */
    public DashboardAuthenticationDetailsSource(RestTemplate restTemplate,
                                                String userInfoUrl, String apiUrl) {
        this.restTemplate = restTemplate;
        this.userInfoUrl = userInfoUrl;
        this.apiUrl = apiUrl;
    }

    @SuppressWarnings("unchecked")
    @Override
    public DashboardAuthenticationDetails buildDetails(HttpServletRequest request) {

        logger.debug("DashboardAuthenticationDetails start ::::" + Common.convertMapByRequest(request) );
        String[] path = request.getServletPath().split("/");
        String serviceInstanceId = "";
        if(path.length>0){
            serviceInstanceId=path[path.length-1];
        }
        logger.debug("serviceInstanceId ::::" + serviceInstanceId );
        Map<String, String> uaaUserInfo = null;
        try {
            uaaUserInfo = restTemplate.getForObject(userInfoUrl, Map.class);
        } catch (RestClientException e) {
            logger.debug("Error while user full name from [" + userInfoUrl + "].", e);
        }
        String user_name = uaaUserInfo.get("user_name");
        String id = uaaUserInfo.get("user_id");
        String name = uaaUserInfo.get("name");

        boolean managingService = isManagingApp(serviceInstanceId);
        DashboardAuthenticationDetails authenticationDetails = new DashboardAuthenticationDetails(request, managingService, id, user_name,serviceInstanceId, this.restTemplate);
        authenticationDetails.setManagingServiceInstance(serviceInstanceId);
        logger.debug("DashboardAuthenticationDetails end ::::" +  authenticationDetails);
        return authenticationDetails;
    }

    /**
     * Checks whether the user is allowed to manage the current service instance.
     */
    private boolean isManagingApp(String serviceInstanceId) {
        logger.debug("isManagingApp :::"+serviceInstanceId);
        final String url = getCheckUrl(serviceInstanceId);
        try {
            final Map<?, ?> result = restTemplate.getForObject(url, Map.class);

            logger.debug("isManagingApp end:::"+Boolean.TRUE.toString()+"MANAGED_KEY end:::"+result.get(MANAGED_KEY).toString().toLowerCase());
            return Boolean.TRUE.toString().equals(result.get(MANAGED_KEY).toString().toLowerCase());
        } catch (RestClientException e) {
            logger.error("Error while retrieving authorization from [" + url + "].", e);
            logger.error("isManagingApp end:::"+false);
            return false;
        }

    }

    /**
     * Returns the URL used to check whether the current user is allowed
     * to access the current service instance.
     */
    private String getCheckUrl(String serviceInstanceId) {
        return apiUrl.replace(TOKEN_SUID, serviceInstanceId);
    }

}
