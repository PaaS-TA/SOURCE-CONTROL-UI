<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/xml" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--<c:out value="${repositorydetails}"></c:out><br>--%>
<div>
    <div id="repositoryBrowseList" style="display: block;">
        <%@ include file="/WEB-INF/views/user/repository/repositoryBrowse.jsp" %>
    </div>
    <div id="repositoryBrowseContent" style="display: block;">
        <%@ include file="/WEB-INF/views/user/repository/repositoryContent.jsp" %>
    </div>
</div>


<script>
    $(document).ready(function () {
        $("#repositoryBrowseContent").hide();
    });
</script>