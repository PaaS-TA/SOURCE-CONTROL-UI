package com.paasta.scwui.common.util;

import com.paasta.scwui.common.exception.ScWebUIexceptionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;
import java.util.List;

/**
 * Created by lena on 2017-06-15.
 */
@Component
public class RestClientUtil {

    private static final Logger logger = LoggerFactory.getLogger(RestClientUtil.class);
    /**
     * The Properties util.
     */
    PropertiesUtil propertiesUtil;

    @Autowired
    public RestClientUtil(PropertiesUtil propertiesUtil) {
        this.propertiesUtil = propertiesUtil;
    }

    /**
     * Call rest api response entity.
     *
     * @param <T>          the type parameter
     * @param httpMethod   the http method
     * @param url          the url
     * @param entity       the entity
     * @param responseType the response type
     * @return the response entity
     */
    public <T> ResponseEntity<T> callRestApi(HttpMethod httpMethod, String url, HttpEntity<Object> entity, Class<T> responseType) {

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<T> response = null;

        logger.info("Type : {}, URL : {}, ResponseType : {}", httpMethod, propertiesUtil.base_url+url, responseType);

        try {

            response = restTemplate.exchange(propertiesUtil.base_url+url, httpMethod, entity, responseType);

        } catch (HttpServerErrorException he) {
            //TODO exception 처리
            //JsonNode error = JsonUtils.convertStringToJson(e.getResponseBodyAsString());
            he.printStackTrace();
            throw new ScWebUIexceptionException(he.getStatusCode()+he.getMessage());
        } catch (RestClientException e) {
            e.printStackTrace();
            throw new ScWebUIexceptionException(e.getMessage());
        }

        return response;
    }

    /**
     * Call rest api return obj list response entity.
     *
     * responseType is..
     *  : ParameterizedTypeReference<List<T>> responseType = new ParameterizedTypeReference<List<T>>() {};
     *
     * @param <T>          the type parameter
     * @param httpMethod   the http method
     * @param url          the url
     * @param entity       the entity
     * @param responseType the response type
     * @return the response entity
     * @throws Exception the exception
     */
    public <T> ResponseEntity<List<T>> callRestApiReturnObjList(HttpMethod httpMethod, String url, HttpEntity<Object> entity, ParameterizedTypeReference<List<T>> responseType) throws Exception{

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<List<T>> response = null;

        logger.debug("Type : {}, URL : {}, ResponseType : {}", httpMethod, propertiesUtil.base_url+url, responseType);

        response = restTemplate.exchange(propertiesUtil.base_url+url, httpMethod, entity, responseType);

        //TODO Exception 처리

        return response;

    }

    /**
     * Rest common headers http entity.
     *
     * @param param the param
     * @return the http entity
     */
    public HttpEntity<Object> restCommonHeaders(Object param) {

        HttpHeaders headers = new HttpHeaders();
//        headers.set("Authorization", propertiesUtil.getBasicAuth());
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));

        HttpEntity<Object> entity = new HttpEntity<>(param, headers);

        return entity;
    }

    /**
     * Rest common headers http entity.
     *
     * @param param the param
     * @return the http entity
     */
    public HttpEntity<Object> restCommonHeaderNotJson(Object param) {

        HttpHeaders headers = new HttpHeaders();
        HttpEntity<Object> entity = new HttpEntity<>(param, headers);

        return entity;
    }

}
