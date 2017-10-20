package com.paasta.scwui.controller.admin;

import com.paasta.scwui.common.util.Common;
import com.paasta.scwui.controller.common.CommonController;
import com.paasta.scwui.model.AuthUser;
import com.paasta.scwui.model.User;
import com.paasta.scwui.service.admin.AdminLoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Created by lena on 2017-06-29.
 */
@Controller
@RequestMapping(value = {""})
public class LoginController extends CommonController {

    final
    AdminLoginService adminLoginService;

    @Autowired
    public LoginController(AdminLoginService adminLoginService) {
        this.adminLoginService = adminLoginService;
    }

    @RequestMapping(value="/login",method = RequestMethod.PUT)
    public ModelAndView repositoryListForAdmin() {

        ModelAndView mv = new ModelAndView();
        mv.addObject("title", "로그인");
        mv.setViewName("/admin/repositories/{instanceId}");
        return mv;
    }

    @RequestMapping(value = {"/c2NtYWRtaW46/"}, method = RequestMethod.GET)
    public ModelAndView loginPage(@RequestParam(value = "error", required = false) String error,
                                  @RequestParam(value = "logout", required = false) String logout,
                                  Locale locale, HttpServletRequest request) {

        ModelAndView model = new ModelAndView();
        if (error != null) {
            model.addObject("error", "Invalid login.");
        }
        if (logout != null) {
            model.addObject("message", "Logged out successfully.");
        }
        model.setViewName("login");
        return model;
    }

    @RequestMapping(value = {"/login"}, method = RequestMethod.POST)
    @ResponseBody
    public ModelAndView login (HttpServletRequest request, HttpSession session) {
        ModelAndView model = new ModelAndView();
        if(Common.empty(request.getParameter("username")) || Common.empty(request.getParameter("password"))) {
            model.setViewName("login");
            model.addObject("error", "아이디 또는 비밀번호가 입력되지 않았습니다.");
            return  model;
        }
        String username = (String) Common.NotNullrtnByobj(request.getParameter("username"), "");
        String password = (String) Common.NotNullrtnByobj(request.getParameter("password"), "");
        if(!"scmadmin".equals(username)){
            model.setViewName("login");
            model.addObject("error", "로그인 할수 없습니다.");
            return  model;
        }

        try {
            logger.debug("ROLE_ADMIN : " + request.isUserInRole("ROLE_ADMIN"));
            logger.debug("ROLE_USER : " + request.isUserInRole("ROLE_USER"));
            User user = new User(username);
            user.setPassword(password);
            Map map = adminLoginService.login(user);
            if(!Common.empty(map.getOrDefault("error",""))){
                model.setViewName("login");
                model.addObject("error", map.getOrDefault("error",""));
                return  model;
            }else{
                model.setViewName("login");
                String name = (String)map.getOrDefault("name","");
                session.setAttribute("name", name);

                //login 성공했다면
                if ("scmadmin".equals(name)) {
                    List role = new ArrayList();
                    role.add("ROLE_ADMIN");
                    role.add("CREATER_Y");
                    AuthUser authUser = new AuthUser(name, false, false,false,false,role);
                    Authentication authentication = new UsernamePasswordAuthenticationToken(authUser, authUser.getAuthorities());
                    SecurityContextHolder.getContext().setAuthentication(authentication);

                    return new ModelAndView("redirect:/admin/serviceInstantList");
                }
                else{
                    return new ModelAndView("redirect:/user/serviceInstantList");
                    /**
                    model.setViewName("login");
                    model.addObject("error", "Dashboard Url로 접속하세요.");
                    return  model;
                     */
                }
            }
            /**
             * 임시 롤 설정
             * scmadmin일경우
             * request.isUserInRole("ROLE_ADMIN"); ==true
             */
            /*
            model.setViewName("/login");
            if (!(request.isUserInRole("ROLE_USER"))) {
                model.setViewName("/login");
            }
            if (request.isUserInRole("ROLE_ADMIN")) {
                model.setViewName("/admin/repositories");
            }
            */

        }catch (Exception exception){
            exception.printStackTrace();
        }
        return model;
    }
    @RequestMapping(value = {"/logout"})
    @ResponseBody
    public AntPathRequestMatcher logout (HttpServletRequest request, HttpSession session) {
        session.invalidate();
        //TODO
        return new AntPathRequestMatcher("/login");
    }
}
