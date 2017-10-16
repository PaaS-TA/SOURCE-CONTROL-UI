package com.paasta.scwui.common.exception;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.expression.ParseException;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

/**
 * Created by lena on 2017-06-16.
 */
@ControllerAdvice
@RestController
public class ScWebUIexceptionExceptionHandler {

    protected Logger logger = LoggerFactory.getLogger(getClass());

    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ExceptionHandler(value = ScWebUIexceptionException.class)
    public String handleRestClientException(ScWebUIexceptionException e) {
        return e.getMessage();
    }

    @ExceptionHandler({IOException.class, ParseException.class, JsonParseException.class, JsonMappingException.class})
    @ResponseBody
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public String handleParseException(Exception e) {
        return e.getMessage();
    }

    @ExceptionHandler({InternalAuthenticationServiceException.class})
    @ResponseBody
//    @ResponseStatus(HttpStatus.UNAUTHORIZEDBAD_REQUEST)
    public String authenticationServerException(Exception e) {
        e.printStackTrace();
        return e.getMessage();
    }

}