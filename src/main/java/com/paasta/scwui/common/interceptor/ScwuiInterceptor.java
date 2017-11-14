package com.paasta.scwui.common.interceptor;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by lena on 2017-06-28.
 */
@Component
public class ScwuiInterceptor extends HandlerInterceptorAdapter {

    protected Logger logger = LoggerFactory.getLogger(getClass());

    // 임시

    //TODO 임시 테스트용 Auth 정보
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)  {

        logger.debug("ScwuiInterceptor ::: preHandle");
        //TODO -- 임시 테스트용으로 Auth 정보 session 넣을까 고민중
//        Auth auth = new Auth(instanceId, userId, orgId);
        if(request.getServletPath().contains("/repositories/user")){
            request.getSession().invalidate();
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) {
        logger.debug("ScwuiInterceptor ::: postHandle");
    }

    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object object, Exception arg)  {
        logger.debug("ScwuiInterceptor ::: afterCompletion");
    }


}
