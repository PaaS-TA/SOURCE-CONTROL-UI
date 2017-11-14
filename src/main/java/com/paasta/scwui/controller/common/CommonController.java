package com.paasta.scwui.controller.common;

import com.paasta.scwui.service.cf.security.DashboardAuthenticationDetails;
import com.paasta.scwui.service.user.UserServiceInstanceService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.web.servlet.HandlerMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
public class CommonController {

    protected Logger logger = LoggerFactory.getLogger(getClass());
    @Autowired
    UserServiceInstanceService instanceUseService;

    /**
     * Sets path variables.
     *
     * @param httpServletRequest the http servlet request
     * @param viewName           the view name
     * @param mv                 the mv
     * @return the path variables
     */
    public ModelAndView setPathVariables(HttpServletRequest httpServletRequest, String viewName, ModelAndView mv) {
        Map pathVariablesMap = (Map) httpServletRequest.getAttribute(HandlerMapping.URI_TEMPLATE_VARIABLES_ATTRIBUTE);
        Object pathVariablesObject;
        String pathVariablesKey;

        Map<String, String[]> parametersMap = httpServletRequest.getParameterMap();
        String[] parametersObject;
        String parametersKey;

        for (int i = 0; i < PathVariablesList.values().length; i++) {
            pathVariablesKey = PathVariablesList.values()[i].actualValue;
            pathVariablesObject = pathVariablesMap.get(pathVariablesKey);

            if (pathVariablesObject != null) {
                mv.addObject(pathVariablesKey, String.valueOf(pathVariablesObject));
            }
        }

        for (int i = 0; i < ParametersList.values().length; i++) {
            parametersKey = ParametersList.values()[i].actualValue;
            parametersObject = parametersMap.get(parametersKey);

            if (parametersObject != null && !"".equals(parametersObject[0])) {
                mv.addObject(parametersKey, parametersObject[0]);
            }
        }

        mv.setViewName(viewName);

        logger.debug("ModelAndView :: {}", mv);

        return mv;
    }


    public String setParameters(HttpServletRequest httpServletRequest) {
        Map<String, String[]> parametersMap = httpServletRequest.getParameterMap();
        String[] parametersObject;
        String parametersKey;
        String resultString = "";

        StringBuilder stringBuilder = new StringBuilder();

        for (int i = 0; i < ParametersList.values().length; i++) {
            parametersKey = ParametersList.values()[i].actualValue;
            parametersObject = parametersMap.get(parametersKey);

            if (parametersObject != null && !"".equals(parametersObject[0])) {
                stringBuilder.append("&").append(parametersKey).append("=").append(parametersObject[0]);
            }
        }

        if (stringBuilder.length() > 0) {
            resultString = "?" + stringBuilder.substring(1);
        }

        logger.info("common setparameters :: {}" , resultString);
        return resultString;
    }


    enum PathVariablesList {
        PATH_VARIABLES_SERVICE_INSTANCE_ID("suid"),
        PATH_VARIABLES_ID("id");

        private String actualValue;

        PathVariablesList(String actualValue) {
            this.actualValue = actualValue;
        }
    }

    enum ParametersList {
        PARAMETERS_ID("id"),
        PARAMETERS_NAME("name"),
        PARAMETERS_PAGE("page"),
        PARAMETERS_SIZE("size"),
        PARAMETERS_SORT("sort"),
        PARAMETERS_ORG_NAME("organizationName"),
        PARAMETERS_REPONAME("repoName");
        private String actualValue;

        ParametersList(String actualValue) {
            this.actualValue = actualValue;
        }
    }

    /**
     * 사용자 접속을 위한 SSO로 들어오는 사용자만 허용되는 session 확인
     *
     * @return Authentication
     */
    public Authentication getAuthentication(){
        if(SecurityContextHolder.getContext()==null){
            throw new InternalAuthenticationServiceException("세션이 존재하지 않습니다." , new Exception("세션에러"));
        }
        return SecurityContextHolder.getContext().getAuthentication();
    }
    /**
     * SSO로 들어오는 사용자의 접속 session
     *
     * @return DashboardAuthenticationDetails
     */
    public DashboardAuthenticationDetails getDetail() {
        DashboardAuthenticationDetails user = (DashboardAuthenticationDetails) getAuthentication().getDetails();
        String instanceId = user.getInstanceId();
        /**
         * 도중에 로그아웃이 발생할경우 형상관리에서 로그아웃됨.
         */


        /**
         * 도중에 인스턴스 삭제시 세션을 끊고 Exception을 발생시킨다.
         */
        List instanceUse = instanceUseService.getAll(instanceId, user.getName());
        if(instanceUse.size()==0){
            throw new InternalAuthenticationServiceException("인스턴스 사용에 대한 권한이 만료하였습니다." , new Exception("권한에러"));
        }
        return user;
    }

    public void expireLogout(HttpServletRequest httpServletRequest
                                ,HttpServletResponse httpServletResponse
                                ,HttpSession session){
        if (session != null) {
            session.invalidate();
        }
        SecurityContextLogoutHandler ctxLogOut = new SecurityContextLogoutHandler(); // concern
        Authentication auth = getAuthentication(); // concern you
        ctxLogOut.logout(httpServletRequest, httpServletResponse, auth);
    }
}
