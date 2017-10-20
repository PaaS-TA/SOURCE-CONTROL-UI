package com.paasta.scwui.controller.user;

import com.paasta.scwui.common.util.Common;
import com.paasta.scwui.controller.common.CommonController;
import com.paasta.scwui.service.cf.security.DashboardAuthenticationDetails;
import com.paasta.scwui.service.user.PermissionService;
import com.paasta.scwui.service.user.RepositoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = {"/user"})
public class PermissionController extends CommonController{

    final
    PermissionService permissionService;
    final
    RepositoryService repositoryService;

    @Autowired
    public PermissionController(PermissionService permissionService, RepositoryService repositoryService) {
        this.permissionService = permissionService;
        this.repositoryService = repositoryService;
    }

    /**
     * ex)http://localhost:9092/user/permission/1
     * @param repoId
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/permission/{repoId}", method = RequestMethod.GET)
    public ModelAndView servicePermissionList(@PathVariable String repoId, HttpServletRequest request) throws Exception {
        logger.debug(""+Common.convertMapByRequest(request));
        List<Map> lstPermission = permissionService.getPermissionsByRepoId(Integer.parseInt(repoId));
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("lstPermission", lstPermission);
        modelAndView.addObject("title", "사용자 목록");
        modelAndView.setViewName("/user/permission/permissionList");

        return modelAndView;
    }

    /**
     * 참여자 추가
     * @param repoId
     * @param map
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/permission/{repoId}", method = RequestMethod.PUT)
    @ResponseBody
    public Map invitePermission(@PathVariable("repoId") String repoId,  @RequestBody Map map) throws Exception {

        ResponseEntity responseEntity = permissionService.putPermission(repoId, map);
        Map map1 = new HashMap();
        map1.put("status", responseEntity.getStatusCodeValue());
        map1.put("response", responseEntity);
        return map1;
    }

    /**
     * 참여자 삭제
     * @param no
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/permission/{no}", method = RequestMethod.DELETE)
    @ResponseBody
    public ResponseEntity deletePermission(@PathVariable("no") String no) throws Exception {

        ResponseEntity responseEntity = permissionService.deletePermissionsByNo(Integer.parseInt(no));
        return new ResponseEntity("{}",responseEntity.getStatusCode());
    }

    @GetMapping("/permissions/{repositoryId}")
    @ResponseBody
    public Map getPermissionByRepositoryId(@PathVariable("repositoryId") String repositoryId, HttpServletRequest request) {
        Map mapByRequest = Common.convertMapByRequest(request);
        Map map = repositoryService.getPermissionByRepositoryId(repositoryId, mapByRequest);
        return map;
    }

    /**
     * instanceId에 대한 사용자와 repository 참여 정보를 가져를 검색하여 가져온다.
     * @param searchUserId
     * @param repositoryId
     * @return
     */
    @GetMapping("/searchPermissions/")
    @ResponseBody
    public Map getPermissionByRepositoryIdAndSearchUserId(@RequestParam(value = "searchUserId") String searchUserId
               ,@RequestParam(value = "repositoryId") String repositoryId) {
        try {
            ResponseEntity responseEntity = null;
            responseEntity = permissionService.getUserBySearchUserIdAndRepositoryId(searchUserId,repositoryId);
            if (responseEntity==null || responseEntity.getBody() != null) {
                return (Map) responseEntity.getBody();
            } else {
                Map map = new HashMap();
                map.put("error", "NoBody");
                return (Map) new ResponseEntity(map, HttpStatus.EXPECTATION_FAILED);
            }
        }catch(Exception e){
            e.printStackTrace();
            Map map = new HashMap();
            map.put("error", "NoBody");
            return (Map) new ResponseEntity(map, HttpStatus.EXPECTATION_FAILED);
        }

    }

    @GetMapping("/instanceUser/")
    @ResponseBody
    public ResponseEntity getPermissionByInstanceId(HttpServletRequest request) {
        DashboardAuthenticationDetails user = ((DashboardAuthenticationDetails) SecurityContextHolder.getContext().getAuthentication().getDetails());
        String rtnInstanceid = user.getInstanceId();
        Map mapByRequest = Common.convertMapByRequest(request);
        ResponseEntity responseEntity = permissionService.getUserByInstanceId(rtnInstanceid, mapByRequest);
        return responseEntity;
    }
    /**
     * instanceId에 대한 사용자와 repository 참여 정보를 가져를 검색하여 가져온다.
     * @param searchUserId
     * @return
     */
    @GetMapping("/searchInstanceId/{searchUserId}")
    @ResponseBody
    public Map getPermissionByInstanceIdAndSearchUserId(@PathVariable("searchUserId") String searchUserId, @RequestParam(value = "repositoryId") String repositoryId){
        try {
            DashboardAuthenticationDetails user = ((DashboardAuthenticationDetails) SecurityContextHolder.getContext().getAuthentication().getDetails());
            String rtnInstanceid = user.getInstanceId();
            ResponseEntity responseEntity = null;
            responseEntity = permissionService.getUserBySearchUserIdAndInstanceId(searchUserId, rtnInstanceid, repositoryId);
            if (responseEntity.getBody() != null) {
                return (Map) responseEntity.getBody();
            } else {
                Map map = new HashMap();
                map.put("error", "NoBody");
                return (Map) new ResponseEntity(map, HttpStatus.EXPECTATION_FAILED);
            }
        }catch(Exception e){
            e.printStackTrace();
            Map map = new HashMap();
            map.put("error", "NoBody");
            return (Map) new ResponseEntity(map, HttpStatus.EXPECTATION_FAILED);
        }

    }
    /**
     * instanceId에 대한 사용자와 repository 참여 정보를 가져를 검색하여 가져온다.
     * @return
     */
    /*@GetMapping("/permissions/instanceId/")
    @ResponseBody
    public Map getPermissionByInstanceId() {
        try {
            DashboardAuthenticationDetails user = ((DashboardAuthenticationDetails) SecurityContextHolder.getContext().getAuthentication().getDetails());
            String rtnInstanceid = user.getInstanceId();
            ResponseEntity responseEntity = null;
            responseEntity = permissionService.getUserByInstanceId(rtnInstanceid);
            if (responseEntity.getBody() != null) {
                return (Map) responseEntity.getBody();
            } else {
                Map map = new HashMap();
                map.put("error", "NoBody");
                return (Map) new ResponseEntity(map, HttpStatus.EXPECTATION_FAILED);
            }
        }catch(Exception e){
            e.printStackTrace();
            Map map = new HashMap();
            map.put("error", "NoBody");
            return (Map) new ResponseEntity(map, HttpStatus.EXPECTATION_FAILED);
        }

    }*/
}