package com.paasta.scwui.service.cf.security;

import lombok.Getter;
import lombok.Setter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.oauth2.provider.authentication.OAuth2AuthenticationDetails;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Extension of {@link OAuth2AuthenticationDetails} providing extra details about the current
 * user and his grant to manage the current service instance.
 *
 * @author Sebastien Gerard
 */
@SuppressWarnings("serial")
@Getter
@Setter
public class DashboardAuthenticationDetails extends OAuth2AuthenticationDetails {

    private String managingServiceInstance;
    private final boolean managingService;
    private final String id;
    private final String instanceId;
    private String userDesc;
    private String email;
    private boolean active;
    private boolean admin;
    private final String name;
    private List permissions;
    private boolean isPasswordSet=false;

    private final RestTemplate restTemplate;
    protected Logger logger = LoggerFactory.getLogger(getClass());

    /**
     * Records the access token value and remote address and will also set the session Id if a session already exists
     * (it won't create one).
     * @param request that the authentication request was received from
     * @param managingService
     * @param id
     * @param userName
     * @param restTemplate 사용자의 권한이 포함되어 있는 RestTemplate
     */
    public DashboardAuthenticationDetails(HttpServletRequest request, boolean managingService, String id, String userName, String instanceId, RestTemplate restTemplate) {
        super(request);
        logger.debug("DashboardAuthenticationDetails start");
        this.managingService = managingService;
        this.id = id;
        this.instanceId = instanceId;
        this.name = userName;
        this.email = userName;
        this.restTemplate = restTemplate;
        logger.debug("DashboardAuthenticationDetails end");

    }

    /**
     * 관리 권한이 있는 serviceInstanceId를 입력한다.
     * @param serviceInstanceId
     */
    public void setManagingServiceInstance(String serviceInstanceId) {
        logger.debug("setManagingServiceInstance start");
        this.managingServiceInstance = serviceInstanceId;
        logger.debug("setManagingServiceInstance end");
    }

    public String getManagingServicesInstance() {
        return managingServiceInstance;
    }

    /**
     * Returns the flag indicating whether the current user is allowed to manage
     * the current service instance.
     */
    public boolean isManagingService() {
        return managingService;
    }

    /**
     * 입력 받은 Service Instance Id가 일치하는지 여부를 체크한다.
     * @param serviceInstanceId
     * @return
     */
    public boolean isManagedServiceInstance(String serviceInstanceId) {
        logger.debug("isManagedServiceInstance start");
        return serviceInstanceId.equals(this.managingServiceInstance);

    }
}
