package com.paasta.scwui.service.admin;

import com.paasta.scwui.common.util.Common;
import com.paasta.scwui.service.common.CommonService;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Created by lena on 2017-06-27.
 */
@Service
public class AdminUserService extends CommonService {

    public Map getAdminUsers(String instanceId, HttpServletRequest request) {
        Map map = new HashMap();
        try {
            // 모든 Repository 조회
            // GET : /repositories/admin
            HttpEntity<Object> entity = restClientUtil.restCommonHeaderNotJson(null);
            String url = propertiesUtil.getApi_permission_admin();
            String addUrl = instanceId + "?" + Common.requestParamByMap(Common.convertMapByRequest(request));

            logger.debug("addUrl::" + addUrl + "::url+addUrl::" + url + addUrl);
            ResponseEntity response = restClientUtil.callRestApi(HttpMethod.GET, url + addUrl, entity, LinkedHashMap.class);
            logger.debug("response.getBody ::: " + response.getBody());

            map = Common.convertMapByLinkedHashMap((LinkedHashMap) response.getBody());
        }catch (Exception e){
            e.printStackTrace();
        }

        return map;
    }

}
