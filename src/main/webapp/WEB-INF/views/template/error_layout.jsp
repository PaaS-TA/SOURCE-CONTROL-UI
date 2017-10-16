<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%-- top --%>
<tiles:insertAttribute name="top"/>
<%-- 공통 tag lib --%>
<tiles:insertAttribute name="taglib"/>
<%-- 공통 javaScript --%>
<tiles:insertAttribute name="commonjs"/>
<div id="wrap" style="padding-top: 100px;">
    <body>
        <div >
            <tiles:insertAttribute name="body"/>
        </div>
        <div>
            <tiles:insertAttribute name="footer"/>
        </div>
    </body>
</div>
<%-- popup --%>
<tiles:insertAttribute name="popup"/>
