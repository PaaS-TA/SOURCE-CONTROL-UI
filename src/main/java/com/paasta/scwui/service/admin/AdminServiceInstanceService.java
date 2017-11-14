package com.paasta.scwui.service.admin;

import com.paasta.scwui.model.ServiceInstanceList;
import com.paasta.scwui.service.common.CommonService;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
/**
 * Created by user on 2017-06-29.
 */
@Service
public class AdminServiceInstanceService extends CommonService {

    public ServiceInstanceList getAll(String queryString) {

        HttpEntity<Object> entity = restClientUtil.restCommonHeaders(null);

        String url = propertiesUtil.getApiServiceInstances();

        ResponseEntity<ServiceInstanceList> response = restClientUtil.callRestApi(HttpMethod.GET, url + queryString, entity, ServiceInstanceList.class);

        logger.debug("response ::: " + response);

        ServiceInstanceList serviceInstancesList = response.getBody();

        return serviceInstancesList;
    }
}
