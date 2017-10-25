package com.paasta.scwui.service.admin;

import com.paasta.scwui.model.User;
import com.paasta.scwui.service.common.CommonService;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
@Service
public class AdminLoginService extends CommonService {


    @SuppressWarnings("unchecked")
    public Map login(User user){
        String url = propertiesUtil.getApi_login();
        logger.debug("url >>>>>>>>>>>>"+ url);
        Map map = new HashMap();
        HttpEntity<Object> entity = restClientUtil.restCommonHeaderNotJson(user);

        try {
            ResponseEntity<Map> response = restClientUtil.callRestApi(HttpMethod.POST, url, entity, Map.class);
            map = response.getBody();
            map.put("user",  map);

        }catch(Exception exception){
            map.put("user",  map);
            map.put("error", exception.getMessage());
            exception.printStackTrace();
            return map;
        }
        return map;

    }
}
