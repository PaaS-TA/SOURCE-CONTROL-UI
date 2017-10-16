package com.paasta.scwui.controller.error;

import com.paasta.scwui.controller.common.CommonController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Created by lena on 2017-06-29.
 */
@Controller
@RequestMapping(value = {"/error/"})
public class ErrorController extends CommonController {

    @RequestMapping(value="/{status}")
    @ResponseBody
    public ModelAndView forbiddenError(@PathVariable("status") String status
            ,HttpServletRequest httpServletRequest
            ,HttpServletResponse httpServletResponse
            ,HttpSession session
            ) {
        ModelAndView modelAndView = new ModelAndView();
        if("403".equals(status)||"401".equals(status)){
            expireLogout(httpServletRequest, httpServletResponse, session);

        }
        modelAndView.addObject("error", "서버에러");
        modelAndView.addObject("status", status);
        modelAndView.addObject("url", httpServletRequest.getRequestURL());
        modelAndView.addObject("exception.message", "서버에러");
        modelAndView.addObject("title", "로그인");
        modelAndView.setViewName("/error/error");
        return modelAndView;
    }
}
