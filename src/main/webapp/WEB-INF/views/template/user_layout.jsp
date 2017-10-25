<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%-- top --%>
<tiles:insertAttribute name="top"/>
<%-- 공통 tag lib --%>
<tiles:insertAttribute name="taglib"/>
<%-- 공통 javaScript --%>
<tiles:insertAttribute name="commonjs"/>

<body>
<div id="wrap">
<%-- header :s  --%>
<tiles:insertAttribute name="header"/>
    <div>
        <tiles:insertAttribute name="body"/>
    </div>
    <div>
        <tiles:insertAttribute name="footer"/>
    </div>
<%-- popup --%>
<tiles:insertAttribute name="popup"/>
</div>
</body>


</html>
