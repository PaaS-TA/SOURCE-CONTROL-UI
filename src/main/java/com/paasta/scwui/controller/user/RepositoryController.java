package com.paasta.scwui.controller.user;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.paasta.scwui.common.util.Common;
import com.paasta.scwui.common.util.Constants;
import com.paasta.scwui.controller.common.CommonController;
import com.paasta.scwui.model.BrowserResult;
import com.paasta.scwui.service.cf.security.DashboardAuthenticationDetails;
import com.paasta.scwui.service.user.RepositoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import sonia.scm.NotSupportedFeatuerException;
import sonia.scm.repository.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

@Controller
@RequestMapping(value = {"/user"})
public class RepositoryController extends CommonController {

    RepositoryService repositoryService;

    @Autowired
    public RepositoryController(RepositoryService repositoryService) {
        this.repositoryService = repositoryService;
    }

    /*
    *  레파지토리 신규 생성 등록 페이지 ::: move
    *
    * */
    @RequestMapping(value = {"/createRepository"}, method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView getRepositoryCreatePage(HttpServletRequest httpServletRequest) {

        return setPathVariables(httpServletRequest, "/user/repository/repositoryCreate", new ModelAndView());
    }

    /*
    *  레파지토리 신규 생성 등록 페이지 ::: Execute
    *
    * */
    @RequestMapping(value = {"/createRepository.do"}, method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity setCreateRepository(@RequestBody Repository repository) {
        Map map = new HashMap();
        DashboardAuthenticationDetails user = getDetail();
        String instanceid = Common.empty(user.getInstanceId()) ? "" : user.getInstanceId();
        String userid = Common.empty(user.getName()) ? "" : user.getName();
        //permission 추가
        List listPermissions = new ArrayList();
        listPermissions.add(new Permission(userid, PermissionType.OWNER));
        repository.setPermissions(listPermissions);
        //properties 추가
        Map propMap1 = new HashMap();
        propMap1.put(Constants.PRPOERTIE_INSTANCE_ID, instanceid);
        propMap1.put(Constants.PRPOERTIE_CREATE_USER, userid);
        // TODO 배포후 삭제예정
        repository.setLastModified(new Date().getTime());
        repository.setProperties(propMap1);
        Map map1 = repositoryService.getRepositoryDetailByName(repository.getType(), repository.getName());
        if (Common.empty(map1.get("repository"))) {
            Repository rtnRepository = repositoryService.setCreateRepository(repository);
            map.put("repository", rtnRepository);
            return new ResponseEntity(map, HttpStatus.OK);
        } else {
            map.put("error", "이미 사용된 레파지토리 명 입니다.");
            return new ResponseEntity(map, HttpStatus.OK);
        }

    }

    /**
     *  레파지토리 수정 페이지 ::: move
     */
    @RequestMapping(value = {"/update/{id}"}, method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView getRepositoryUpdate(@PathVariable("id") String id,
                                            @RequestParam(value = "type", required = false) String type
            , HttpSession session) {
        logger.debug("session:" + session);
        Repository repository = repositoryService.getRepositoryDetail(id, type);
        com.paasta.scwui.model.Repository repository1 = convertObject(repository);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("repositoryMpdify", repository1);
        modelAndView.setViewName("/user/repository/repositoryModify");
        return modelAndView;
    }

    /*
     *  레파지토리 수정 페이지 ::: Execute
     *
     * */
    @RequestMapping(value = {"/update/{id}"}, method = RequestMethod.PUT)
    @ResponseBody
    public ResponseEntity setRepositoryUpdate(@PathVariable("id") String id, @RequestBody Repository repository) throws JsonProcessingException {
        return repositoryService.setUpdateRepository(id, repository);
    }

    @RequestMapping(value = "/repository/{repositoryId}", method = RequestMethod.DELETE)
    @ResponseBody
    public ResponseEntity delleteByRepositoryId(@PathVariable("repositoryId") String repositoryId) {
        repositoryService.deleteByRepositoryId(repositoryId);
        return new ResponseEntity(new HashMap<>(),HttpStatus.OK);
    }

    /**
     *  레파지토리 전체 목록 초기화면
     *  리스트 페이지마다 파라메터를 제각각 가져옴.
     *  Page 객체로 가져오는것으로 통일함.
     *
     */
    @RequestMapping(value = "/repository/", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView repositoryListForUser(HttpServletRequest request) {
        Map map = Common.convertMapByRequest(request);
        // Source Control Api Server 호출 - repository 목록 조회
        Map modelRepository = repositoryListForUserMore(request);
        ModelAndView mv = new ModelAndView();
        mv.addObject("repoName", map.getOrDefault("repoName", ""));
        mv.addObject("type1", map.getOrDefault("type1", ""));
        mv.addObject("type2", map.getOrDefault("type2", ""));
        mv.addObject("reposort", map.getOrDefault("reposort", "lastModified_true"));
        mv.addObject("rtnList", modelRepository);
        mv.addObject("title", "레파지토리목록");
        mv.setViewName("/user/repository/repositoryList");
        return mv;
    }
    /**
     *  레파지토리 전체 목록 더보기 구현
     */

    @RequestMapping(value = "/repositoryUserMore/", method = RequestMethod.GET)
    @ResponseBody
    public Map repositoryListForUserMore(HttpServletRequest request) {
        DashboardAuthenticationDetails user = getDetail();
        ((DashboardAuthenticationDetails) getAuthentication().getDetails()).setPasswordSet(true);
        String instanceid = Common.empty(user.getInstanceId()) ? "" : user.getInstanceId();
        String userid = Common.empty(user.getName()) ? "" : user.getName();
        logger.debug("instanceId :::" + instanceid + "::username :::" + userid);
        Map map = Common.convertMapByRequest(request);
        // Source Control Api Server 호출 - repository 목록 조회
        Map repositories = repositoryService.getUserRepositories(instanceid, userid, map);
        List<Repository> lstRepositories = (List) repositories.get("content");
        List<com.paasta.scwui.model.Repository> modelRepository = new ArrayList<>();
        lstRepositories.forEach((Object repository) -> {
            modelRepository.add(convertObject(repository));
        });
        repositories.replace("content", modelRepository);
        return repositories;
    }


    //TODO repositoryUserMore 와 controller 가같음. 삭제 예정.
    @RequestMapping(value = "/repositoryMore/")
    @ResponseBody
    public Map repositoryMoreListForUser(HttpServletRequest request) {
        Map rssMap = new HashMap();
        DashboardAuthenticationDetails user = getDetail();
        String instanceid = Common.empty(user.getInstanceId()) ? "" : user.getInstanceId();
        String userid = Common.empty(user.getName()) ? "" : user.getName();
        logger.debug("instanceId :::" + instanceid);
        Map map = Common.convertMapByRequest(request);
        // Source Control Api Server 호출 - repository 목록 조회
        Map repositories = repositoryService.getUserRepositories(instanceid, userid, map);
        List<Repository> lstRrepositories = (List) repositories.get("content");
        List<com.paasta.scwui.model.Repository> modelRepository = new ArrayList<>();
        lstRrepositories.forEach((Object repository) -> {
            modelRepository.add(convertObject(repository));
        });
        rssMap.put("repositories", modelRepository );
        return rssMap;
    }

    /*
     *  레파지토리 상세 조회 ::: move
     *a href="/user/repositoryDetail/'+repositories[i].id+'"
     * */
    //http://localhost:9092/user/repositoryDetail/FJQN2yN2sQ
    @RequestMapping(value = "/repositoryDetail/{repositoryId}", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView repositoryListForUser(@PathVariable("repositoryId") String repositoryId,
                                              @RequestParam(value = "type", required = false) String type
    ) {
        ModelAndView modelAndView = new ModelAndView();
        logger.debug("repositoryId :::" + repositoryId);
        Branches branches = new Branches();
        Tags tags = new Tags();
                // Source Control Api Server 호출 - repository 상세 조회
        Repository repository = repositoryService.getRepositoryDetail(repositoryId, type);
        if("git".equals(type)) {
            //브렌치 List
            branches = repositoryService.getBranches(repositoryId);
            //Tag List
            tags = repositoryService.getTags(repositoryId);
        }

        //커밋 List
        List<Changeset> changesetPagingResult = repositoryService.getChangesets(repositoryId).getChangesets();

        modelAndView.addObject("type", type);
        modelAndView.addObject("tags", tags);
        modelAndView.addObject("branches", branches);
        modelAndView.addObject("ChangesetPagingResult", changesetPagingResult);
        modelAndView.addObject("repositorydetails", repository);
        modelAndView.addObject("title", repository.getName());
        modelAndView.setViewName("/user/repository/repositoryDetail");
        return modelAndView;
    }

    /*
     *  파일 상세 조회 ::: move
     *a href="/user/repositoryDetail/'+repositories[i].id+'"
     * */
    //http://localhost:9092/user/repositoryDetail/FJQN2yN2sQ/browse
    @RequestMapping(value = "/repositoryDetail/{repositoryId}/browse/", method = RequestMethod.GET)
    @ResponseBody
    public Map repositoryBrowse(@PathVariable("repositoryId") String repositoryId,
                                @RequestParam(value = "disableLastCommit", required = false) boolean disableLastCommit,
                                @RequestParam(value = "disableSubRepositoryDetection", required = false) boolean disableSubRepositoryDetection,
                                @RequestParam(value = "path", required = false, defaultValue = "") String path,
                                @RequestParam(value = "recursive", required = false) boolean recursive,
                                @RequestParam(value = "revision", required = false, defaultValue = "") String revision
    ) throws NotSupportedFeatuerException, IOException {
        Map map = new HashMap();
        //파일 List
        BrowserResult browserResult = repositoryService.getBrowseByParam(repositoryId, disableLastCommit, disableSubRepositoryDetection, path, recursive, revision);
        List<sonia.scm.repository.FileObject> lstFiles = browserResult.getFiles();
        browserResult.setNewFiles(lstFiles);

        map.put("browserResult", browserResult);
        map.put("path", path);
        return map;
    }


    /**
     * Repository changesets Inquery
     *
     * curl 'http://localhost:9091/repositories/{id}/contents?path=.gitignore&_dc=1506392871640' -i -X GET \
     * @apiParam {String} id repository 아이디
     */
    @GetMapping("/repositoryDetail/{repositoryId}/content/")
    @ResponseBody
    public Map getContents(@PathVariable("repositoryId") String id
            , @RequestParam(value = "revision", required = false, defaultValue = "") String revision
            , @RequestParam(value = "path") String path) throws NotSupportedFeatuerException, IOException{
        String obj = repositoryService.getContent(id, revision, path);
        String[] lobj = obj.split("\n");
        List data = new ArrayList();
        List intData = new ArrayList();
        for (int i =0 ; i< lobj.length ; i++) {
            intData.add(Integer.toString(i+1));
            data.add(lobj[i]);
        }
        Map map = new HashMap();
        map.put("data", data);
        map.put("intData", intData);
        map.put("path", path);
        map.put("revision", revision);
        return map;
    }

    private com.paasta.scwui.model.Repository convertObject(Object requestRepository){
        String jsonStr = null;
        com.paasta.scwui.model.Repository repository = null;
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            jsonStr = objectMapper.writeValueAsString(requestRepository);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        try {
            repository = objectMapper.readValue(jsonStr, com.paasta.scwui.model.Repository.class);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return repository;
    }

}