<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<jsp:useBean id="dateObject1" class="java.util.Date"/>
<jsp:useBean id="dateObject2" class="java.util.Date"/>
<%--
* 시 스 템 명 : 소스컨트롤러 웹 UI
* 업 무 명 : 사용자 목록
* 프로그램명permissionList.jsp.jsp.jsp(참여자 목록 리스트)
* 프로그램 개요 : 사용자 목록 리스트 화면
* 작 성 자 : 이인정
* 작 성 일 : 2017.07.10
* 화면 ID: UI-FDSC-8000
* 화면설계 ID: UI-SBSC-8000
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- contaniner :s -->
<div id="container">
    <!-- location :s -->
    <div class="location">
        <ul>
            <li><a href="/admin/serviceInstantList" title="형상관리신청목록" class="home">홈으로</a></li>
            <li><a href="/admin/serviceInstantList" title="형상관리신청목록">형상관리 신청목록</a></li>
            <li><a href="#" title="사용자 목록">사용자 목록</a></li>
        </ul>
    </div>
    <!--//location :e -->
    <!-- contents :s -->
    <div class="contents">
        <!-- 셀렉트(검색, 권한 선택, 사용여부 선택) :s -->
        <div class="rSearch_group">
            <form id="frm_search" method="get" action="/admin/user/${instanceId}">
                <input type="hidden" id="username" name="username"/>
                <input type="hidden" id="start" name="page"/>
                <input type="hidden" id="end" name="size"/>
                <div class="sel_group fr">
                <%--<div class="fl"><span id="RP_cnt"> <c:out value="${data.number*data.size+data.numberOfElements}"></c:out> / ${data.totalElements} 건</span></div>--%>
                    <div class="keyword_search fr">
                        <%--<input id="search_keyword" type="text" name="search_keyword" style="-ms-ime-mode: active;" value="<%=request.getParameter("search_keyword")%>"placeholder="아이디 또는 사용자 명 검색" autocomplete="on"/>--%>
                            <input id="search_keyword" type="text" name="search_keyword" style="-ms-ime-mode: active;" value=""placeholder="아이디 또는 사용자 명 검색" autocomplete="on"/>
                            <input type="button" class="btn_search" id="btn_search"  title="아이디 또는 사용자 명 검색"/>
                    </div>
                </div>
            </form>
        </div>
        <!--//셀렉트(검색, 권한 선택, 사용여부 선택) :e -->
        <!-- 사용자 목록(이미지없는) :s -->
        <ul class="product_list2" id="permissionList" name = "permissionList">
            <c:forEach var="repositories" items="${data.content}" varStatus="status">
                <c:set var="user" value="${repositories.user}"></c:set>
            <c:forEach var="permissions" items="${repositories.repositories.permissions}" varStatus="status">
            <li>
                <dl>
                    <dt>${repositories.repositories.name}</dt>
                    <dt>${permissions.name} : ${user[status.index].displayName}</dt>
                    <dd>
                        <ul>
                            <li class="sbj_txt">
                            </li>
                            <li class="stateArea">
                                    <jsp:setProperty name="dateObject1" property="time" value="${user[status.index].creationDate}"/>
                                    <jsp:setProperty name="dateObject2" property="time" value="${user[status.index].lastModified}"/>
                                <i class="ico_create"></i>추가일
                                : ${dateObject1}/ <%--<fmt:parseDate value="${user.creationDate}" pattern="yyyy MM dd"></fmt:parseDate>--%>
                                <span class="pr8"></span> <i class="ico_modify"></i>수정일
                                : ${dateObject2}<%--<fmt:formatDate value="${dateObject2}" pattern="yyyy MM dd HH:mm"></fmt:formatDate></li>--%>
                        </ul>
                    </dd>
                    <dd class="icon_wrap">
                        <ul class="ico_lst">
                            <li class="ico_area">
                                <c:choose>
                                    <c:when test="${permissions.type eq 'OWNER'}">
                                        <img src="/resources/images/process_ico_own.png" alt="소유자 이미지" border="0">
                                        <p class="tit">소유자</p>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="/resources/images/process_ico_normal.png" alt="일반 이미지" border="0">
                                        <p class="tit">일반</p>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                            <li class="ico_area">
                                <c:choose>
                                    <c:when test="${user[status.index].active eq 'true'}">
                                        <img src="/resources/images/process_ico_ownership.png" alt="사용 이미지" border="0">
                                        <p class="tit">사용</p>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="/resources/images/process_ico_stop.png" alt="정지 이미지" border="0">
                                        <p class="tit">정지</p>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                        </ul>
                    </dd>
                </dl>
            </li>
            </c:forEach>
            </c:forEach>
            <c:if test="${data.totalElements==0}">
                <li id="initRepoList" name="initRepoList"> 해당 데이터가 없습니다.</li></li>
            </c:if>
        </ul>
        <c:if test="${data.last eq 'false'}">
            <!-- 더보기 버튼 :s -->
            <div class="table_more" id="moreListButtonArea" style="display: inline;">
                <div class="btn_more" id="btnMore" name="btnMore">more</div>
            </div>
            <!--//더보기 버튼 :e -->
        </c:if>
        <!--//사용자 목록(이미지없는) :e -->
    </div>
</div>
<!--//contents :e -->
</div>
<!--//contaniner :e -->
<input type="hidden" id="requestSearchKeyword" name="requestSearchKeyword" value="<c:out value='${name}' default='' />" />

<!-- Top 가기 :s -->
<div class="follow" title="Scroll Back to Top">
    <a href="#" title="top"><img src="/resources/images/a_top.gif"></a>
</div>
<!--//Top 가기 :e -->
<script>
    var pageSize = 10;
    var page = 0;
    $("#btnMore").click(function () {
        //page 추가
        page ++;
        console.log("$().click(function()");
        var url = "/admin/user/";
        var requestUrl = instanceId + "?username=" + $("#search_keyword").val() + "&page=" + page + "&size=" + pageSize;
        url = url + requestUrl;
        console.log("requestUrl::::::::" + requestUrl);
        procCallAjax('post', url, null, moreCallback);

    });

     var searchList = function(){
         page = 0;
         $("#username").val($("#search_keyword").val());
         $("#page").val(page);
         $("#size").val(pageSize);
         $("#frm_search").submit();
     }
    var callback = function() {

    }
    $(document).ready(function () {
    });

    $("#btn_search").click(function () {
        searchList();
    });
    $("#search_keyword").keyup(function (event) {
        if (event.which == 13) {
            searchList();
        }
    });

    var moreCallback = function (data) {
        if (data.last){
            $("#moreListButtonArea").hide();
        }
        $("#RP_cnt").text('총 ' + (data.number * data.size + data.numberOfElements)+' / ' + data.totalElements + ' 건');
        if (data.totalElements == 0) {
            initialList();
        }
        else {
            initData(data);
        }
    }

    var searchCallback = function (data) {
        console.log('searchCallback start');
        if (data.last){
            $("#moreListButtonArea").hide();
        }
        if (data.totalElements == 0) {
            initialList();
        }else{
            $("#RP_cnt").text('총 ' + (data.number * data.size + data.numberOfElements)+' / ' + data.totalElements + ' 건');
            initData(data);
        }
    }
    var initData = function(data){
        var repositories = data.content;
        for (var i= 0; i < repositories.length; i++) {
            var permissions = repositories[i].repositories.permissions;
            for (var j = 0; j < permissions.length; j++) {
                var user = repositories[i].user;
                var creationDate = user[j].creationDate;
                var lastModified =  user[j].lastModified;
                var varHtml = "<li>";
                varHtml = varHtml +'<dl>' +
                    ' <dt>'
                    + repositories[i].repositories.name
                    + '</dt>   '
                    +' <dt>'
                    + permissions[j].name + '/' + user[j].displayName
                    + '</dt>   '
                    +'  <dd>                    <ul>                    <li class="sbj_txt">                        </li>'
                    + '<li class="stateArea">'

                    + '<i class="ico_create"></i>추가일 : ' + user[j].creationDate + '/'
                    + '<span class="pr8"></span> <i class="ico_modify"></i>수정일 :' + new Date(user[j].lastModified)<%--<fmt:formatDate value="${dateObject2}" pattern="yyyy MM dd HH:mm"></fmt:formatDate></li>--%>
                    + '</ul>        </dd>       <dd class="icon_wrap">       <ul class="ico_lst">    <li class="ico_area">';
                if (permissions[j].type == 'OWNER') {
                    varHtml = varHtml + '<img src="/resources/images/process_ico_own.png" alt="소유자 이미지" border="0">'
                        + '<p class="tit">소유자</p>';
                } else {
                    varHtml = varHtml + '<img src="/resources/images/process_ico_normal.png" alt="일반 이미지" border="0">'
                        + '<p class="tit">일반</p>';
                }
                varHtml = varHtml + '</li>  <li class="ico_area">';
                if (user[j].active == 'true') {
                    varHtml = varHtml + '<img src="/resources/images/process_ico_ownership.png" alt="사용 이미지" border="0">                        <p class="tit">사용</p>';
                } else {
                    varHtml = varHtml +'<img src="/resources/images/process_ico_stop.png" alt="정지 이미지" border="0">                            <p class="tit">정지</p>';
                }
                varHtml = varHtml +'</li>                        </ul>                        </dd>                        </dl>                        </li>';
                $('#permissionList').append(varHtml);
            }
        }
    }

//    var initialList = function(){
//        $("#RP_cnt").text(0);
//        var varHtml ='<li > <dl>조회된 데이터가 없습니다.</dl>            </li>';
//        $('#permissionList').append(varHtml);
//    }

</script>
