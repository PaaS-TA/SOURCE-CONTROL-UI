package com.paasta.scwui.controller.admin;

import com.paasta.scwui.controller.common.CommonController;
import com.paasta.scwui.model.ServiceInstanceList;
import com.paasta.scwui.service.admin.AdminServiceInstanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by lena on 2017-06-29.
 */

@Controller
@RequestMapping(value = "/admin")
public class AdminServiceInstanceController extends CommonController {

    private final AdminServiceInstanceService adminServiceInstanceService;

    @Autowired
    public AdminServiceInstanceController(AdminServiceInstanceService adminServiceInstanceService) {
        this.adminServiceInstanceService = adminServiceInstanceService;
    }

    // http://localhost:8080/admin/serviceInstantList
    @RequestMapping("/serviceInstantList")
    public ModelAndView serviceInstantList(HttpServletRequest httpServletRequest, @RequestParam(value = "organizationName", required = false) String organizationName) throws Exception {
        return setPathVariables(httpServletRequest,  "/admin/serviceInstance/serviceInstanceList", new ModelAndView());
    }

    @RequestMapping("/serviceInstantList.do")
    @ResponseBody
    // @RequestBody 어노테이션은 @RequestMapping에 의해 POST 방식으로 전송된 HTTP 요청 데이터를 String 타입의 body 파라미터로 전달된다.(수신)
    // @ResponseBody 어노테이션이 @RequestMapping 메서드에서 적용되면 해당 메서드의 리턴 값을 HTTP 응답 데이터로 사용
    public ServiceInstanceList getServiceInstantList(HttpServletRequest httpServletRequest, @RequestParam(value = "organizationName", required = false) String organizationName) throws Exception {
        return adminServiceInstanceService.getAll(setParameters(httpServletRequest));
    }

}