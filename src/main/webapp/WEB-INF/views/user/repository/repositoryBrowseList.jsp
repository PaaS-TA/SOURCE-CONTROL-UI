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
<button type="button" class="button btn_default" title="취소" id="btnContentCancel" onclick="contentViewCancel()">취소</button>

<script>
    $(document).ready(function () {
        $("#repositoryBrowseContent").hide();
        $("#btnContentCancel").hide();
    });
    function contentViewCancel(){
        $("#repositoryBrowseContent").hide();
        $("#repositoryBrowseList").show();
        $("#btnContentCancel").hide();
        $('#browserContent').children().remove();
    }
</script>