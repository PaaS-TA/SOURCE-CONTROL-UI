package com.paasta.scwui.service.user;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.paasta.scwui.common.util.Common;
import com.paasta.scwui.model.BrowserResult;
import com.paasta.scwui.model.Repository;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import sonia.scm.NotSupportedFeatuerException;
import sonia.scm.repository.Branches;
import sonia.scm.repository.ChangesetPagingResult;
import sonia.scm.repository.Tags;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by lena on 2017-06-27.
 */
@Service
public class RepositoryService extends CommonService{

    /*
    *  Repository 신규 생성 등록 페이지
    */
    
    public Repository setCreateRepository(Repository repository) {

        HttpEntity<Object> entity = restClientUtil.restCommonHeaderNotJson(repository);
        String url = propertiesUtil.getApi_repo();
        logger.debug("########## Service Confirm ##########");
        ResponseEntity<Repository> response = null; // ☜
        try{
            response = restClientUtil.callRestApi(HttpMethod.POST, url, entity, Repository.class); // ☜
        } catch (Exception e){
            e.printStackTrace();
        }
        return response.getBody();
    }

    /*
     *  Repository 수정 페이지
     */
    
    public ResponseEntity setUpdateRepository(String id,Repository repository) {
        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(repository);
        String url = propertiesUtil.getApi_repo_id().replace("{id}", id);
        logger.debug("########## Service Confirm ##########");
        ResponseEntity response = restClientUtil.callRestApi(HttpMethod.PUT, url, entity, String.class);
        return response;
    }


    
    public List<Repository> getUserRepositories(String instanceid, String userid) {

        // 모든 Repository 조회
        // GET : /repositories/user/{instanceid}?username={user}
        String url = propertiesUtil.getApi_repo_dashboard().replace("{instanceid}", instanceid);
        url = url.replace("{user}", userid);
        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(null);
        ResponseEntity<Map> response = restClientUtil.callRestApi(HttpMethod.GET, url, entity, Map.class);

        List<LinkedHashMap> repositoryList = (List<LinkedHashMap>) response.getBody().get("repositories");

        ObjectMapper objectMapper = new ObjectMapper();
        List<Repository> repositories = new ArrayList<Repository>();

        repositoryList.forEach(e -> repositories.add(objectMapper.convertValue(e, Repository.class)));

        return repositories;

    }

    public Repository getRepositoryDetail(String repositoryId) {

        // Repository 상세 조회
        // GET : /repositories/{repositoryId}
        String url = propertiesUtil.getApi_repo_id().replace("{id}", repositoryId);
        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(null);
        ResponseEntity<Repository> response = restClientUtil.callRestApi(HttpMethod.GET, url, entity, Repository.class);
        logger.debug("response.getStatusCode():"+"response.getStatusCode():");
        Repository repository = response.getBody();

        return repository;

    }

    /**
     * 생성여부확인
     * @param repositoryName the repository repositoryName
     * @return
     */
    
    public Map getRepositoryDetailByName(String type, String repositoryName) {

        // Repository 상세 조회
        // GET : /repositories/{repositoryId}
        String url = propertiesUtil.getApi_repo_type_name().replace("{type}",type).replace("{name}",repositoryName);
        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(null);
        ResponseEntity response = restClientUtil.callRestApi(HttpMethod.GET, url , entity, Object.class);
        Map map = (Map) response.getBody();

        return map;

    }
//    @RequestMapping(value ="/repositories/{instanceId}/{username}/" )
//    public ModelAndView repositoryListForUser(
//            @PathVariable("instanceId") String instanceid,
//            @PathVariable("username") String username, @RequestParam("branch") String branch , @RequestParam("tag") String tag) {
//
//        //http://localhost:9092/user/repositories/5b471cc8-03d8-4fa6-868f-3f0116801219/scmadmin/?branch={barnch}&tag={tag}
//        logger.debug("instanceId :::" + instanceid);
//        logger.debug("username :::" + username);
//        logger.debug("branch :::" + branch);
//        logger.debug("tag :::" + tag);
//
//        // Source Control Api Server 호출 - repository 목록 조회
//        List<Repository> repositories = repositoryService.getUserRepositories(instanceid, username, branch, tag);
//
//        List<Repository> public_repositories = repositories.stream().filter(e -> e.isPublic_()).collect(toList());
//        List<Repository> private_repositories = repositories.stream().filter(e -> !e.isPublic_()).collect(toList());
//
//        ModelAndView mv = new ModelAndView();
//        mv.addObject("repositories", repositories);
//        mv.addObject("public_repositories", public_repositories);
//        mv.addObject("private_repositories", private_repositories);
//
//        //TODO 공통 Header에 표현되는 Repository 총 Count로 공통 처리 필요
//        mv.addObject("repositoryCnt", repositories.size());
//        mv.addObject("auth", auth);
//        mv.addObject("title", "레파지토리목록");
//        mv.setViewName("/user/repository/repositoryView");
//        return mv;
//    }

    
    public List<Repository> getUserRepositories(String instanceid, String userid, Map map){
        // 모든 Repository 조회
        // GET : /repositories/user/{instanceid}?username={user}
        String params = Common.requestParamByMap(map);
        String url = propertiesUtil.getApi_repo_dashboard().replace("{instanceid}", instanceid);
        url = url.replace("{user}", userid);
        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(null);
        logger.debug("url+ params:::"+url+ params);
        ResponseEntity<Map> response = restClientUtil.callRestApi(HttpMethod.GET, url+ "&"+params, entity, Map.class);

        List<LinkedHashMap> repositoryList = (List<LinkedHashMap>) response.getBody().get("repositories");

        ObjectMapper objectMapper = new ObjectMapper();
        List<Repository> repositories = new ArrayList<Repository>();

        repositoryList.forEach(e -> repositories.add(objectMapper.convertValue(e, Repository.class)));

        return repositories;
    }
    
    public Map getPermissionByRepositoryId(String repositoryId, Map mapByRequest){
        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(mapByRequest);
        String param = Common.requestParamByMap(mapByRequest);
        return restClientUtil.callRestApi(HttpMethod.GET, "/users/repository/"+repositoryId+"?"+param, entity, Map.class).getBody();
    }

    
    public Branches getBranches(String repositoryId) {
        try{
            HttpEntity<Object> entity = restClientUtil.restCommonHeaders(null);
            String url = propertiesUtil.getApi_repo_branches().replace("{id}", repositoryId);

            ResponseEntity<Branches> responseEntity = restClientUtil.callRestApi(HttpMethod.GET,url, entity, Branches.class);

            Branches branches =  (Branches)responseEntity.getBody();

            return branches;
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }

    }

    
    public Tags getTags(String repositoryId) {
        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(null);
        String url = propertiesUtil.getApi_repo_tags().replace("{id}", repositoryId);

        ResponseEntity<Tags> response = restClientUtil.callRestApi(HttpMethod.GET,url, entity, Tags.class);

        Tags tags =  (Tags)response.getBody();

        return tags;

    }

    
    public BrowserResult getBrowse(String repositoryId) {
        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(null);
        String url = propertiesUtil.getApi_repo_browse().replace("{id}", repositoryId);

        ResponseEntity<BrowserResult> response = restClientUtil.callRestApi(HttpMethod.GET,url, entity, BrowserResult.class);

        BrowserResult browserResult =  (BrowserResult)response.getBody();

        return browserResult;

    }

    
    public ChangesetPagingResult getChangesets(String repositoryId) {
        try {
            HttpEntity<Object> entity = restClientUtil.restCommonHeaders(null);
            String url = propertiesUtil.getApi_repo_changesets().replace("{id}", repositoryId);

            ResponseEntity<ChangesetPagingResult> responseEntity = restClientUtil.callRestApi(HttpMethod.GET, url, entity, ChangesetPagingResult.class);

            ChangesetPagingResult changesets = (ChangesetPagingResult) responseEntity.getBody();
            return changesets;
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }

    }

    /**
     * Gets delete repositories.
     *
     * @param id the repository ID
     * @return the delete repositories
     */
    
    public ResponseEntity deleteByRepositoryId(String id){
        try {
            HttpEntity<Object> entity = restClientUtil.restCommonHeaders(null);
            String url = propertiesUtil.getApi_repo_id().replace("{id}", id);
            ResponseEntity responseEntity = restClientUtil.callRestApi(HttpMethod.DELETE, url, entity, String.class);
            return responseEntity;
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity(HttpStatus.FORBIDDEN);
        }
    }

    /**
     *
     * @param id the id
     * @param disableLastCommit
     * @param disableSubRepositoryDetection
     * @param path
     * @param recursive
     * @param revision
     * @return
     * @throws NotSupportedFeatuerException
     * @throws IOException
     */
    
    public BrowserResult getBrowseByParam(String id, boolean disableLastCommit, boolean disableSubRepositoryDetection, String path, boolean recursive, String revision)
            throws NotSupportedFeatuerException, IOException {

        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(null);
        String url = propertiesUtil.getApi_repo_browse().replace("{id}", id);
        String param = "?disableLastCommit="+disableLastCommit+"&disableSubRepositoryDetection="+disableSubRepositoryDetection+"&path="+path+"&recursive="+recursive+"&revision="+revision;
        url=url+param;
        logger.debug("url:::"+url);
        ResponseEntity<BrowserResult> response = restClientUtil.callRestApi(HttpMethod.GET, url, entity, BrowserResult.class);
        BrowserResult repositories = (BrowserResult) response.getBody();
//        List<sonia.scm.repository.FileObject> lstFile = repositories.getFiles();
//        repositories.setNewFiles(lstFile);
        logger.debug(repositories.toString());
        return repositories ;
    }
}
