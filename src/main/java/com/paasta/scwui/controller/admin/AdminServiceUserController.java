package com.paasta.scwui.controller.admin;

import com.paasta.scwui.common.util.Common;
import com.paasta.scwui.controller.common.CommonController;
import com.paasta.scwui.service.admin.AdminUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

@Controller
@RequestMapping(value = {"/admin/user"})
public class AdminServiceUserController extends CommonController {

    @Autowired
    AdminUserService adminUserService;

    @RequestMapping(value = "/{instanceId}", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView getUserDetail(@PathVariable("instanceId") String instanceId, HttpServletRequest request
                                            , HttpSession session){

        Map map = adminUserService.getAdminUsers(instanceId, request);
        String username = (String) Common.NotNullrtnByobj(session.getAttribute("name"),"");
        session.setAttribute("instanceId", instanceId);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("data",map);
        modelAndView.setViewName("/admin/user/permissionList");

        return modelAndView;
    }

    @RequestMapping(value="/{instanceId}",method = RequestMethod.POST)
    @ResponseBody
    public Map serviceInstantList(@PathVariable("instanceId") String instanceId, HttpServletRequest request) {

        Map map = adminUserService.getAdminUsers(instanceId, request);
        return map;
    }

}