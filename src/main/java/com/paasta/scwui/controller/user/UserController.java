package com.paasta.scwui.controller.user;

import com.paasta.scwui.common.util.Common;
import com.paasta.scwui.controller.common.CommonController;
import com.paasta.scwui.service.cf.security.DashboardAuthenticationDetails;
import com.paasta.scwui.service.user.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by lena on 2017-06-29.
 */

@Controller
@RequestMapping(value = "/user")
public class UserController extends CommonController{

    UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping(value = "/userMyInfoModify")
    @ResponseBody
    public ModelAndView getUserInfo() {
        String name = getDetail().getName();
        Map map = (Map) userService.getUser(name).getBody();
        ModelAndView modelAndView = addModel(map);
        modelAndView.setViewName("/user/user/userMyInfoModify");
        return modelAndView;
    }

    @PutMapping(value = "/userMyInfoModify/{name}")
    @ResponseBody
    public Map putUserInfo(@PathVariable("name") String name,@RequestBody Map map)  {
        DashboardAuthenticationDetails user = getDetail();
        logger.debug("name :::+"+ name);
        String userid = Common.empty(user.getName())?"":user.getName();
        map.put("name",userid);
        Map map1 = (Map) userService.modifyUser(userid, map).getBody();
        return map1;
    }

    /*  레파지토리 사용자 추가*/
    @RequestMapping(value ={"/addUser.do"}, method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity CreateUser(@RequestBody Map map) {
        ResponseEntity responseEntity = userService.createUser(map);
        return responseEntity;
    }

    /*  인스턴스 사용자 추가*/
    @RequestMapping(value ={"/instanceAddUser.do"}, method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity instanceCreateUser(@RequestBody Map map) {
        //common Common.convertMapByLinkedHashMap(map)
        DashboardAuthenticationDetails user = getDetail();
        String instanceid = Common.empty(user.getInstanceId())?"":user.getInstanceId();
        String createUserId = (String) map.getOrDefault("userId","");
        map.put("instanceId", instanceid);
        Map searhExsistUser = (Map) userService.getUser(createUserId).getBody();
        if(Common.notEmpty(searhExsistUser.get("rtnUser"))||Common.notEmpty(searhExsistUser.get("ScUser"))){
            Map rtnMap = new HashMap();
            rtnMap.put("message", "이미 존재하는 사용자 입니다.");
            return new ResponseEntity(rtnMap, HttpStatus.OK);
        }
        ResponseEntity rtnResponseEntity = userService.createInstanceUser(map);
        return rtnResponseEntity;
    }

    /*  인스턴스 사용자 수정*/
    @RequestMapping(value ={"/instanceModifyUser.do"}, method = RequestMethod.PUT)
    @ResponseBody
    public Map instanceModifyUser(@RequestBody Map map) {
        String userid = (String) map.getOrDefault("name","");
        map.put("name",userid);
        Map map1 = (Map) userService.modifyUser(userid, map).getBody();
        return map1;
    }

    /**
     * @return
     * @throws Exception
     */
    @GetMapping("/create/")
    public ModelAndView serviceInstanceCreateUser() {
        DashboardAuthenticationDetails user = getDetail();
        String instanceid = Common.empty(user.getInstanceId())?"":user.getInstanceId();
        logger.info("i:::instanceid" + instanceid);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("/user/permissions/permissionCreate");
        return modelAndView;
    }
    /**
     * @return
     * @throws Exception
     */
    @GetMapping("/permissionList/")
    public ModelAndView serviceInstanceUserList() {
        DashboardAuthenticationDetails user = getDetail();
        String instanceid = Common.empty(user.getInstanceId())?"":user.getInstanceId();
        logger.info("i:::instanceid" + instanceid);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("/user/permissions/permissionList");
        return modelAndView;
    }

    @GetMapping(value = "/setFirstUserInfoModify/")
    @ResponseBody

    public ModelAndView setFirstUserInfoModify() {
        DashboardAuthenticationDetails user = getDetail();
        String instanceid = Common.empty(user.getInstanceId())?"":user.getInstanceId();
        logger.info("i:::instanceid" + instanceid);
        String name = getDetail().getId();
        Map map = (Map) userService.getUser(name).getBody();
        ModelAndView modelAndView = addModel(map);
        modelAndView.setViewName("/user/user/setFirstUserInfoModify");
        return modelAndView;
    }

    @GetMapping(value = "/instanceUserModify/{name}")
    @ResponseBody
    public ModelAndView getUserInfo(@PathVariable("name") String name)  {
        Map map = (Map) userService.getUser(name).getBody();
        ModelAndView modelAndView = addModel(map);
        modelAndView.addObject("name",name);
        modelAndView.setViewName("/user/user/instanceUserModify");
        return modelAndView;
    }

    /**
     * @return
     * @throws Exception
     */
    @DeleteMapping("/instanceUserDelete.do/{name}")
    public Map serviceInstanceDeleteUser(@PathVariable("name") String name) {
        DashboardAuthenticationDetails user = getDetail();
        String instanceid = Common.empty(user.getInstanceId())?"":user.getInstanceId();
        Map map = (Map) userService.deleteInstanceUser(instanceid, name).getBody();
        return map;
    }
    @GetMapping(value = "/userMyModifyPassword")
    @ResponseBody
    public ModelAndView userMyModifyPassword()  {
        String name = getDetail().getName();
        Map map = (Map) userService.getUser(name).getBody();
        ModelAndView modelAndView = addModel(map);
        modelAndView.setViewName("/user/userMyModifyPassword");
        return modelAndView;
    }

    @GetMapping(value = "/getInstanceUser/{name}")
    @ResponseBody
    public Map getInstanceUserInfo(@PathVariable("name") String name)  {
        return (Map) userService.getUser(name).getBody();
    }

    /**
     * 일정한 형식으로 사용자 정보를 리턴해준다.
     * @param map
     * @return
     */
    private ModelAndView addModel(Map map){
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("message",map.getOrDefault("message",""));
        modelAndView.addObject("status",map.getOrDefault("status",0));
        modelAndView.addObject("ScUser",map.getOrDefault("ScUser",""));
        modelAndView.addObject("rtnUser",map.getOrDefault("rtnUser",""));
        return modelAndView;
    }
}
