<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <title>슈퍼어드민 로그인페이지</title>
        <%-- 공통 tag lib --%>
        <tiles:insertAttribute name="taglib"/>
        <%-- 공통 javaScript --%>
        <tiles:insertAttribute name="commonjs"/>
        <%-- Popup javaScript --%>
        <tiles:insertAttribute name="popup"/>
    </head>
    <body>
        <div>
            <tiles:insertAttribute name="body"/>
        </div>
        <div>
            <tiles:insertAttribute name="footer"/>
        </div>
    </body>
</html>
<script>
    $(document).ready(function () {
        $('#username').focus();
        $('#modal').hide();

    });
</script>
