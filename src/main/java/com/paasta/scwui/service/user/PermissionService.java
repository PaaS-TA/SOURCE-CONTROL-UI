package com.paasta.scwui.service.user;

import com.paasta.scwui.common.util.Common;
import com.paasta.scwui.common.util.PropertiesUtil;
import com.paasta.scwui.common.util.RestClientUtil;
import com.paasta.scwui.service.common.CommonService;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by lena on 2017-06-27.
 */
@Service
public class PermissionService extends CommonService {

    public List getPermissionsByRepoId(int repoId) {

        // 모든 Repository 조회
        // GET : /repositories/admin
        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(null);
        String url = propertiesUtil.getApi_permission();

        ResponseEntity<List> response = restClientUtil.callRestApi(HttpMethod.GET, url + "/" + repoId, entity, List.class);
        logger.debug("response ::: " + response);

        List lstPermissions = response.getBody();


        return lstPermissions;
    }

    public ResponseEntity getUserDetail(String name) {

        String url = propertiesUtil.getApi_users().replace("{name}", name);
        logger.debug("name >>>>>>>>>>>>" + name);
        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(null);
        ResponseEntity<ResponseEntity> response = restClientUtil.callRestApi(HttpMethod.GET, url, entity, ResponseEntity.class);
        logger.debug("response ::: " + response);
        return response;
    }

    /**
     * 참여자 권한 추가
     * @param id
     * @param map
     * @return
     */
    public ResponseEntity putPermission(String id, Map map){
        try{
            String url = propertiesUtil.getApi_permission();
            logger.debug("id >>>>>>>>>>>>" + id);
            List lst = new ArrayList();
            HttpEntity<Object> entity = restClientUtil.restCommonHeaders(map);
            ResponseEntity response = restClientUtil.callRestApi(HttpMethod.PUT, url+"/"+id, entity, Object.class);
            logger.debug("response ::: " + response);
            return response;
        }catch (Exception exception){
            exception.printStackTrace();
            return new ResponseEntity(exception.getMessage(), HttpStatus.EXPECTATION_FAILED);

        }
    }

    /**
     *
     * @param searchUserId
     * @param repositoryId
     * @return
     */
    public ResponseEntity getUserBySearchUserIdAndRepositoryId(String searchUserId, String repositoryId){
        String url = propertiesUtil.getApi_permission_search_repositoryId()+"?searchUserId="+ searchUserId+"&repositoryId="+repositoryId;
        logger.debug("url >>>>>>>>>>>>" + url);
        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(null);
        ResponseEntity response = restClientUtil.callRestApi(HttpMethod.GET, url, entity, Object.class);
        logger.debug("response ::: " + response);
        return response;
    }
    /**
     *
     * @param searchUserId
     * @param instanceId
     * @return
     */
    public ResponseEntity getUserBySearchUserIdAndInstanceId(String searchUserId, String instanceId, String repositoryId){
        String url = propertiesUtil.getApi_permission_search_instanceId()+searchUserId+"?"+ "instanceId="+instanceId+"&repositoryId="+repositoryId;
        logger.debug("url >>>>>>>>>>>>" + url);
        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(null);
        ResponseEntity response = restClientUtil.callRestApi(HttpMethod.GET, url, entity, Object.class);
        logger.debug("response ::: " + response);
        return response;
    }
    /**
     *
     * @param instanceId
     * @return
     */
    public ResponseEntity getUserByInstanceId(String instanceId, Map map){
        String params = Common.requestParamByMap(map);
        String url = propertiesUtil.getApi_permission_user()+instanceId+ "?"+params;
        logger.debug("url >>>>>>>>>>>>" + url);
        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(map);
        ResponseEntity response = restClientUtil.callRestApi(HttpMethod.GET, url, entity, Object.class);
        logger.debug("response ::: " + response);
        return response;
    }

    /**
     * 참여자 삭제
     * @param no
     * @return status
     */
    public ResponseEntity deletePermissionsByNo(int no) {

        // 모든 Repository 조회
        // GET : /repositories/admin
        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(null);
        String url = propertiesUtil.getApi_permission();

        ResponseEntity<Object> response = restClientUtil.callRestApi(HttpMethod.DELETE, url + "/" + no, entity, Object.class);
        logger.debug("response ::: " + response);

        return response;
    }
}
