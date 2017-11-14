package com.paasta.scwui.controller.user;

import com.paasta.scwui.common.util.Common;
import com.paasta.scwui.common.util.Constants;
import com.paasta.scwui.controller.common.CommonController;
import com.paasta.scwui.service.cf.security.DashboardAuthenticationDetails;
import com.paasta.scwui.service.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping(value = {"/repositories"})
public class DashboardController extends CommonController {


    UserService userService;

    @Autowired
    DashboardController(UserService userService) {
        super();
        this.userService = userService;
    }

    /*
     *  레파지토리 목록 조회 ::: move
     *
     * */
    @RequestMapping(value = "/user/{instanceId}", method = RequestMethod.GET)
    //@ResponseBody
    public ModelAndView repositoryDashboard(@PathVariable("instanceId") String instanceId, HttpSession session) {
        try {

            DashboardAuthenticationDetails user = getDetail();
            String rtnUserId = Common.empty(user.getName()) ? "" : user.getName();
            boolean bCreate = getAuthentication().getAuthorities().contains(new SimpleGrantedAuthority(Constants.CHECK_YN_Y));
            boolean bActive = user.isActive();
            boolean bPasswordSet = user.isPasswordSet();
            logger.debug("bCreate:::"+bCreate + "::bActive::"+bActive+":::");
            session.setAttribute("name", rtnUserId);
            if(!bPasswordSet){
                return new ModelAndView("redirect:/user/userMyModifyPassword");
            }

            //최초 들어왔을 경우에는 passwordSet이 null, bCreate = Y, bActive = false임
            //초대되어 들어올경우 자동으로 사용자를 등록시킬경우이므로 bPasswordSet = false 로 입력할것.
//            ((DashboardAuthenticationDetails) getAuthentication().getDetails()).setPasswordSet(true);
            //OAuth2Authentication oAuth2Authentication = (OAuth2Authentication) ((DashboardAuthenticationDetails) getAuthentication().getDetails()).setPasswordSet(true);

            logger.debug("username :::" + rtnUserId + "::rtnInstanceid:" + user.getInstanceId() + "::instanceId:" + instanceId + "::rtnIsActive:" + user.isActive() + "::rtnCreateYN:" + getAuthentication().getAuthorities());
            return new ModelAndView("redirect:/user/repository/");

        } catch (Exception e) {
            e.printStackTrace();
            throw new InternalAuthenticationServiceException("Error while creating repositoryDashboard instanceId on [" + instanceId + "]", e);
        }

    }

    /**
     * 레파지토리 목록 조회 ::: move
     */
    //@ResponseBody
    public ModelAndView redirectSession(String instanceid) {
        try {
            return new ModelAndView("redirect:repositories/user/?" + instanceid);
        } catch (Exception e) {
            e.printStackTrace();
            throw new InternalAuthenticationServiceException("Error while creating repositoryDashboard instanceId on [" + instanceid + "]", e);
        }

    }
}






