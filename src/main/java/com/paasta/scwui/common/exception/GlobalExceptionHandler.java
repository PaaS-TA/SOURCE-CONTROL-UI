package com.paasta.scwui.common.exception;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;

/**
 * paastaDeliveryPipelineApi
 * paasta.delivery.pipeline.ui.exception
 *
 * @author REX
 * @version 1.0
 * @since 5 /11/2017
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger LOGGER = LoggerFactory.getLogger(GlobalExceptionHandler.class);


    /**
     * Handle http client error exception model and view.
     *
     * @param req the req
     * @param e   the e
     * @return the model and view
     */
    @ExceptionHandler({HttpClientErrorException.class})
    public ModelAndView handleHttpClientErrorException(HttpServletRequest req, Exception e) {
        return handleError(req, e);
    }


    /**
     * Handle http server error exception model and view.
     *
     * @param req the req
     * @param e   the e
     * @return the model and view
     */
    @ExceptionHandler({HttpServerErrorException.class})
    public ModelAndView handleHttpServerErrorException(HttpServletRequest req, Exception e) {
        return handleError(req, e);
    }


    /**
     * Handle runtime exception model and view.
     *
     * @param req the req
     * @param e   the e
     * @return the model and view
     */
    @ExceptionHandler({RuntimeException.class, ArithmeticException.class})
    public ModelAndView handleRuntimeException(HttpServletRequest req, Exception e) {
        return handleError(req, e);
    }


    /**
     * Handle any exception model and view.
     *
     * @param req the req
     * @param e   the e
     * @return the model and view
     */
    @ExceptionHandler({Exception.class})
    public ModelAndView handleAnyException(HttpServletRequest req, Exception e) {
        return handleError(req, e);
    }


    private ModelAndView handleError(HttpServletRequest req, Exception e) {
        if (AnnotationUtils.findAnnotation(e.getClass(), ResponseStatus.class) != null) {
            throw new ScWebUIexceptionException("ERROR :: handleError", e);
        }

        LOGGER.error("Request:: {} || Exception:: {}", req.getRequestURI(), e.getMessage());

        ModelAndView mav = new ModelAndView();
        mav.addObject("exception", e);
        mav.addObject("url", req.getRequestURL());
        mav.addObject("timestamp", new Date().toString());
        mav.addObject("status", 500);
        mav.setViewName("/error/error");
        return mav;
    }

}
