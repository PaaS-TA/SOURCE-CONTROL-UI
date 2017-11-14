package com.paasta.scwui.controller.user;

import com.paasta.scwui.common.util.Common;
import com.paasta.scwui.controller.common.CommonController;
import com.paasta.scwui.service.cf.security.DashboardAuthenticationDetails;
import com.paasta.scwui.service.user.UserServiceInstanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
@RequestMapping(value = "/user")
public class UserServiceInstanceController extends CommonController{

    UserServiceInstanceService userServiceInstanceService;

    @Autowired
    public UserServiceInstanceController(UserServiceInstanceService userServiceInstanceService) {
        this.userServiceInstanceService = userServiceInstanceService;
    }

    @RequestMapping("/serviceInstantList")
    public ModelAndView getServiceInstantList() {
        DashboardAuthenticationDetails user = getDetail();
        String instanceId = Common.empty(user.getInstanceId())?"":user.getInstanceId();
        logger.debug("instanceId:::"+instanceId);
        String name = Common.empty(user.getName())?"":user.getName();
        ModelAndView modelAndView = new ModelAndView();
        List list = userServiceInstanceService.getAll(name);
        modelAndView.addObject("data",list);
        modelAndView.setViewName("/user/repository/serviceInstantList");
        return modelAndView;
    }


}