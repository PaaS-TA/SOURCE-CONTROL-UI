package com.paasta.scwui.controller.user;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.paasta.scwui.common.util.Common;
import com.paasta.scwui.common.util.Constants;
import com.paasta.scwui.controller.common.CommonController;
import com.paasta.scwui.model.BrowserResult;
import com.paasta.scwui.model.Permission;
import com.paasta.scwui.model.Repository;
import com.paasta.scwui.service.cf.security.DashboardAuthenticationDetails;
import com.paasta.scwui.service.user.RepositoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import sonia.scm.NotSupportedFeatuerException;
import sonia.scm.repository.Branches;
import sonia.scm.repository.Changeset;
import sonia.scm.repository.Tags;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static java.util.stream.Collectors.toList;

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
        listPermissions.add(new Permission(userid, Constants.PERMISSION_OWNER));
        repository.setPermissions(listPermissions);

        //properties 추가
        Map propMap1 = new HashMap();
        Map propMap2 = new HashMap();
        propMap1.put("key", Constants.PRPOERTIE_INSTANCE_ID);
        propMap1.put("value", instanceid);
        propMap2.put("key", Constants.PRPOERTIE_CREATE_USER);
        propMap2.put("value", userid);
        List listProperties = new ArrayList();
        listProperties.add(propMap1);
        listProperties.add(propMap2);
        repository.setProperties(listProperties);

        logger.debug("repository:" + repository.toString());
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


    /*
     *  레파지토리 수정 페이지 ::: move
     */
    @RequestMapping(value = {"/update/{id}"}, method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView getRepositoryUpdate(@PathVariable("id") String id, HttpSession session) {
        logger.debug("session:" + session);
        Repository repository = repositoryService.getRepositoryDetail(id);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("repositoryMpdify", repository);
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
        return new ResponseEntity(new Repository(), HttpStatus.OK);
    }


    /*
     *  레파지토리 전체 목록
     * */
    @RequestMapping(value = "/repository/", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView repositoryListForUser(HttpServletRequest request) {

        DashboardAuthenticationDetails user = getDetail();
        String instanceid = Common.empty(user.getInstanceId()) ? "" : user.getInstanceId();
        String userid = Common.empty(user.getName()) ? "" : user.getName();
        logger.debug("instanceId :::" + instanceid + "::username :::" + userid);
        Map map = Common.convertMapByRequest(request);
        // Source Control Api Server 호출 - repository 목록 조회
        List<Repository> repositories = repositoryService.getUserRepositories(instanceid, userid, map);
        List<Repository> public_repositories = repositories.stream().filter(Repository::isPublic_).collect(toList());
        List<Repository> private_repositories = repositories.stream().filter(Repository -> !Repository.isPublic_()).collect(toList());
        ((DashboardAuthenticationDetails) getAuthentication().getDetails()).setPasswordSet(true);
        ModelAndView mv = new ModelAndView();
        mv.addObject("repoName", map.getOrDefault("repoName", ""));
        mv.addObject("page", map.getOrDefault("page", ""));
        mv.addObject("size", map.getOrDefault("size", ""));
        mv.addObject("type1", map.getOrDefault("type1", ""));
        mv.addObject("type2", map.getOrDefault("type2", ""));
        mv.addObject("reposort", map.getOrDefault("reposort", "lastModified_true"));
        mv.addObject("repositories", repositories);
        mv.addObject("public_repositories", public_repositories);
        mv.addObject("private_repositories", private_repositories);
        mv.addObject("repositoryCnt", repositories.size());
        //mv.addObject("auth", auth);
        mv.addObject("title", "레파지토리목록");
        mv.setViewName("/user/repository/repositoryList");
        return mv;
    }

    @RequestMapping(value = "/repositoryMore/")
    @ResponseBody
    public Map repositoryMoreListForUser(@RequestParam(value = "type", required = false) String type,
                                         @RequestParam(value = "reposort", required = false) String reposort,
                                         @RequestParam(value = "repoName", required = false) String repoName) {
        Map map = new HashMap();
        try {
            DashboardAuthenticationDetails user = getDetail();
            String instanceid = Common.empty(user.getInstanceId()) ? "" : user.getInstanceId();
            String userid = Common.empty(user.getName()) ? "" : user.getName();
            logger.debug("instanceId :::" + instanceid);
            logger.debug("username :::" + userid + ":::" + type + ":::" + reposort + ":::" + repoName);

            // Source Control Api Server 호출 - repository 목록 조회
            List<Repository> repositories = repositoryService.getUserRepositories(instanceid, userid);
            map.put("repositories", repositories);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    /*
     *  레파지토리 상세 조회 ::: move
     *a href="/user/repositoryDetail/'+repositories[i].id+'"
     * */
    //http://localhost:9092/user/repositoryDetail/FJQN2yN2sQ
    @RequestMapping(value = "/repositoryDetail/{repositoryId}", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView repositoryListForUser(@PathVariable("repositoryId") String repositoryId
//            ,
//                                              @RequestParam(value = "disableLastCommit", required = false) boolean disableLastCommit,
//                                              @RequestParam(value = "disableSubRepositoryDetection", required = false) boolean disableSubRepositoryDetection,
//                                              @RequestParam(value = "path", required = false, defaultValue = "") String path,
//                                              @RequestParam(value = "recursive", required = false) boolean recursive,
//                                              @RequestParam(value = "revision", required = false, defaultValue = "") String revision
    ) throws NotSupportedFeatuerException, IOException {
        ModelAndView modelAndView = new ModelAndView();
        try {
            logger.debug("repositoryId :::" + repositoryId);

            // Source Control Api Server 호출 - repository 상세 조회
            Repository repository = repositoryService.getRepositoryDetail(repositoryId);

            //브렌치 List
            Branches branches = repositoryService.getBranches(repositoryId);
            //Tag List
            Tags tags = repositoryService.getTags(repositoryId);

//            //파일 List
//            BrowserResult browserResult = repositoryService.getBrowseByParam(repositoryId,  disableLastCommit, disableSubRepositoryDetection, path,  recursive, revision);

            //커밋 List
            List<Changeset> changesetPagingResult = repositoryService.getChangesets(repositoryId).getChangesets();
            List<com.paasta.scwui.model.Changeset> rtnChangeset = new ArrayList<>();

            changesetPagingResult.forEach(changeset -> rtnChangeset.add(new com.paasta.scwui.model.Changeset(changeset)));

            modelAndView.addObject("tags", tags);
            modelAndView.addObject("branches", branches);
//            modelAndView.addObject("browserResult", browserResult);
            modelAndView.addObject("ChangesetPagingResult", rtnChangeset);

            modelAndView.addObject("repositorydetails", repository);
            modelAndView.addObject("title", repository.getName());
            modelAndView.setViewName("/user/repository/repositoryDetail");
        } catch (Exception e) {
            e.printStackTrace();
        }
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
        try {
            //파일 List
            BrowserResult browserResult = repositoryService.getBrowseByParam(repositoryId, disableLastCommit, disableSubRepositoryDetection, path, recursive, revision);
            List<sonia.scm.repository.FileObject> lstFiles = browserResult.getFiles();
            browserResult.setNewFiles(lstFiles);

            map.put("browserResult", browserResult);
            map.put("path", path);
        } catch (Exception e) {
            e.printStackTrace();
        }
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
//    @Produces({ MediaType.APPLICATION_OCTET_STREAM })
    public Map getContents(@PathVariable("repositoryId") String id
            , @RequestParam(value = "revision", required = false, defaultValue = "") String revision
            , @RequestParam(value = "path") String path) throws NotSupportedFeatuerException, IOException{
        // REX-TEST
        Object obj = repositoryService.getContent(id, revision, path);
        Map map = new HashMap();
        map.put("data", obj);
        return map;
    }
}