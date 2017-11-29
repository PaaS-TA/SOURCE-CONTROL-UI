package com.paasta.scwui.service.cf.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.paasta.scwui.common.util.Common;
import com.paasta.scwui.model.InstanceUser;
import com.paasta.scwui.service.user.UserService;
import com.paasta.scwui.service.user.UserServiceInstanceService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.provider.OAuth2Authentication;

import java.util.*;

/**
 * {@link AuthenticationProvider} used to make the link between an OAuth user
 * and an internal user.
 *
 * @author Sebastien Gerard
 */
public class DashboardAuthenticationProvider implements AuthenticationProvider {

    private final UserService userService;
    private final UserServiceInstanceService instanceUseService;
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    public DashboardAuthenticationProvider( UserService userService, UserServiceInstanceService instanceUseService) {
        logger.debug("DashboardAuthenticationProvider start");
        this.userService = userService;
        this.instanceUseService = instanceUseService;
    }

    /**
     * instance user 와 scm user 를 비교하여 instance user에는 권한이 있으나 scm 사용자로 등록 되어있지 않을 경우
     * 사용자 등록 및 instance user에 owner 로 등록하여 사용할 수 있도록 한다.'
     * 사용자 등록 및 instance user에 owner 로 등록하여 사용할 수 있도록 한다.'
     * 1. ismanage =true -->
     * 2. instance user owner로 등록 -  scm user 는 dash board 등록 이후에 넘어가도록 조치함.
     * @param authentication
     * @return
     * @throws AuthenticationException
     */
    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        final String name = authentication.getName();
        final Object details = authentication.getDetails();
        logger.info("authenticate start ::: name"+name);
        Authentication rtnAuthentication ;
        if (!(details instanceof DashboardAuthenticationDetails)) {
            logger.debug(" authentication details [" + details.getClass().getName()  + "] are not an instance of  start");
            throw new InternalAuthenticationServiceException("The authentication details [" + details
                  + "] are not an instance of " + DashboardAuthenticationDetails.class.getSimpleName());
        }

        DashboardAuthenticationDetails dashboardAuthenticationDetails = (DashboardAuthenticationDetails) details;
        //instance manage service false 일경우 권한없음 발생
        if(!dashboardAuthenticationDetails.isManagingService()) {
            throw new InternalAuthenticationServiceException("instance authentication not exist by user based on [" + name + "]");
        }
        try {
            /**사용자와 instanceId에대한 권한은 체크 */
            List instanceUse = instanceUseService.getAll(dashboardAuthenticationDetails.getManagingServicesInstance(), name);
            List<InstanceUser> lstInstanceUser = new ArrayList<InstanceUser>();
            ObjectMapper objectMapper = new ObjectMapper();
            List role = new ArrayList();
            // 외부 인증으로 로그인한 사용자에 대한 정보가 내부에 있는지 확인.
            ResponseEntity<Map> rss = userService.getUser(name);
            //인스턴스 사용자가 없을경우 생성한다.
            if (instanceUse.size() == 0) {
                /**
                 * 다른 조직의 사용자일 경우 인스턴스 정보만 추가되고 사용자는 추가 되지 않아야함.
                 */
                LinkedHashMap requestInstanceUser = new LinkedHashMap();
                requestInstanceUser.put("instanceId", dashboardAuthenticationDetails.getManagingServicesInstance());
                requestInstanceUser.put("userId",name);
                requestInstanceUser.put("repoRole","owner");
                requestInstanceUser.put("createrYn","N");
                requestInstanceUser.put("displayName",name);
                requestInstanceUser.put("acitve",true);
                ResponseEntity rtnInstanceUser = userService.createInstanceUser(requestInstanceUser);
                if (200 == rtnInstanceUser.getStatusCodeValue()) {
                    instanceUse= instanceUseService.getAll(dashboardAuthenticationDetails.getManagingServicesInstance(), name);
                }
            }
            //사용자가 없을 경우 생성하는 자동으로 사용자 추가하는 로직 추가함
            Map rtnUser = rss.getBody();
            if(Common.empty(rtnUser.get("ScUser"))||Common.empty(rtnUser.get("rtnUser"))){
                Map createUser = new HashMap();
                createUser.put("name",name);
                if(Common.empty(rtnUser.get("rtnUser"))){
                    createUser.put("PasswordSet","false");
                }
                userService.createUser(createUser);
            }

            if (instanceUse.size() >0){
                instanceUse.forEach(e -> lstInstanceUser.add(objectMapper.convertValue(e, InstanceUser.class)));
                lstInstanceUser.forEach(e -> {
                        role.add(new SimpleGrantedAuthority("ROLE_"+e.getRepoRole().toUpperCase()));
                        role.add(new SimpleGrantedAuthority("ROLE_CREATE_"+e.getCreaterYn().toUpperCase()));
                });
            }

            // 사용자 정보조회
            ResponseEntity<Map> rsltRss = userService.getUser(name);
            Map map = rsltRss.getBody();
            if(Common.empty(map.get("rtnUser"))|| Common.empty(map.get("ScUser"))){
                throw new InternalAuthenticationServiceException("Error while creating a user based on [" + name + "]");
            }

            Map scUserMap = (Map) map.get("ScUser");
            Map rtnUserAfter = (Map) map.get("rtnUser");
            String mail = (String) scUserMap.getOrDefault("userMail", "");
            String desc = (String) scUserMap.getOrDefault("userDesc", "");
            boolean admin = (boolean) rtnUserAfter.getOrDefault("admin", false);
            boolean active = (boolean) rtnUserAfter.getOrDefault("active", false);
            boolean password = false;
            if(rtnUserAfter.getOrDefault("properties", null)!=null){
                password = Boolean.parseBoolean((String)((LinkedHashMap)rtnUserAfter.get("properties")).getOrDefault("PasswordSet","false"));
            }
            // 로그인한 사람의 권한은 OWNER
            dashboardAuthenticationDetails.setActive(active);
            dashboardAuthenticationDetails.setAdmin(admin);
            dashboardAuthenticationDetails.setUserDesc(desc);
            dashboardAuthenticationDetails.setEmail(mail);
            dashboardAuthenticationDetails.setActive(active);
            dashboardAuthenticationDetails.setAdmin(admin);
            dashboardAuthenticationDetails.setPermissions(role);
            dashboardAuthenticationDetails.setPasswordSet(password);
            rtnAuthentication = new OAuth2Authentication(((OAuth2Authentication) authentication).getOAuth2Request()
                    , new UsernamePasswordAuthenticationToken(authentication.getPrincipal(), "N/A", role));
            ((OAuth2Authentication) rtnAuthentication).setDetails(dashboardAuthenticationDetails );
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("Error while creating a user based on ",e);
            throw new InternalAuthenticationServiceException("Error while creating a user based on [" + name + "]", e);
        }

        logger.debug("authenticate end");
        return rtnAuthentication;
    }

    @Override
    public boolean supports(Class<?> authentication){
        logger.debug("support start");
        try {
            return OAuth2Authentication.class.isAssignableFrom(authentication);
        }catch (Exception e){
            logger.error("supports::::::::::",e);
            return false;
        }
    }
}

