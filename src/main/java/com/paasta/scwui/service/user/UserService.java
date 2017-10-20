package com.paasta.scwui.service.user;

import com.paasta.scwui.common.util.PropertiesUtil;
import com.paasta.scwui.common.util.RestClientUtil;
import com.paasta.scwui.service.common.CommonService;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * Created by lena on 2017-06-27.
 */
@Service
public class UserService extends CommonService {

    public ResponseEntity getUser(String name){
        String url = propertiesUtil.getApi_users_user();
        logger.debug("url >>>>>>>>>>>>"+ url+name);
        HttpEntity<Object> entity = restClientUtil.restCommonHeaders("");
        return restClientUtil.callRestApi(HttpMethod.GET, url+name+".json", entity, Object.class);

    }
    
    public ResponseEntity createUser(Map map){
        String url = propertiesUtil.getApi_users();
        logger.debug("url >>>>>>>>>>>>"+ url);
        HttpEntity<Object> entity = restClientUtil.restCommonHeaderNotJson(map);
        return restClientUtil.callRestApi(HttpMethod.POST, url, entity, Map.class);
    }

    public ResponseEntity createInstanceUser(Map map) {
        String url = propertiesUtil.getApi_serviceInstances();
        logger.debug("url >>>>>>>>>>>>"+ url);
        HttpEntity<Object> entity = restClientUtil.restCommonHeaderNotJson(map);
        return restClientUtil.callRestApi(HttpMethod.POST, url, entity, Map.class);
    }

    public ResponseEntity modifyUser(String name, Map map){
        try {
            String url = propertiesUtil.getApi_users();
            logger.debug("url >>>>>>>>>>>>" + url);
            HttpEntity<Object> entity = restClientUtil.restCommonHeaders(map);

            return restClientUtil.callRestApi(HttpMethod.PUT, url + name + ".json", entity, Map.class);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity(e.toString(), HttpStatus.EXPECTATION_FAILED);
        }
    }

    public ResponseEntity deleteUser(String name){
        String url = propertiesUtil.getApi_users();
        logger.debug("url >>>>>>>>>>>>"+ url);
        HttpEntity<Object> entity = restClientUtil.restCommonHeaderNotJson("");

        return restClientUtil.callRestApi(HttpMethod.DELETE, url+name, entity, Map.class);
    }

    public ResponseEntity deleteInstanceUser(String instanceid, String name){
        String url = propertiesUtil.getApi_users();
        logger.debug("url >>>>>>>>>>>>"+ url);
        HttpEntity<Object> entity = restClientUtil.restCommonHeaderNotJson("");
        ResponseEntity rss= restClientUtil.callRestApi(HttpMethod.DELETE, url+name+"/"+instanceid+"/", entity, Map.class);
        return new ResponseEntity(rss.toString(), HttpStatus.OK);
    }
}
