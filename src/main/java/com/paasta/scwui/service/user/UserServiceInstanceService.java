package com.paasta.scwui.service.user;

import com.paasta.scwui.model.InstanceUser;
import com.paasta.scwui.model.ServiceInstanceList;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceInstanceService extends CommonService{

    public List getAll(String name) throws Exception {

        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(null);

        String url = propertiesUtil.getApi_serviceInstances();

        ParameterizedTypeReference<ServiceInstanceList> responseType = new ParameterizedTypeReference<ServiceInstanceList>() {};

        ResponseEntity<List> response = restClientUtil.callRestApi(HttpMethod.GET, url+"/user?createUserId="+name, entity, List.class);

        logger.debug("response ::: " + response);

        List serviceInstancesList = response.getBody();

        return serviceInstancesList;
    }

    public List getAll(String instanceId, String userId) {

        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(null);

        String url = propertiesUtil.getApi_auth();

        ParameterizedTypeReference<ServiceInstanceList> responseType = new ParameterizedTypeReference<ServiceInstanceList>() {};

        ResponseEntity<List> response = restClientUtil.callRestApi(HttpMethod.GET, url+"?instanceId="+instanceId+"&userId="+userId, entity, List.class);

        logger.debug("response ::: " + response);

        List serviceInstancesList = response.getBody();

        return serviceInstancesList;
    }

    public InstanceUser createInstanceUser(InstanceUser instanceUser) {

        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(instanceUser);

        String url = propertiesUtil.getApi_auth();

        ResponseEntity<InstanceUser> response = restClientUtil.callRestApi(HttpMethod.POST, url, entity, InstanceUser.class);

        logger.debug("response ::: " + response);

        InstanceUser rtnInstanceUser = response.getBody();

        return rtnInstanceUser;
    }
}
