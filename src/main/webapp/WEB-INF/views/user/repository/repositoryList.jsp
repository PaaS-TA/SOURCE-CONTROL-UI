<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- contaniner :s -->
<div id="container">
    <!-- location :s -->
    <div class="location">
        <div class="fl">
        <ul>
            <li><a href="/user/repository"  class="home">홈으로</a></li>
            <li><a href="/user/repository/" title="${title}">${title}</a></li><!--마지막 경로-->
        </ul>
        </div>
        <div class="fr" style="padding-top: 15px;">

            <a href="/user/createRepository" >
                <jsp:include page="../common/buttonCreateAhref.jsp"></jsp:include><%--<button type="button" id="btn_repoCreate" class="button btn_default" title="신규생성" style="display: block">신규생성</button>--%>
            </a>
        </div>
    </div>
    <!--//location :e -->
    <!-- contents :s -->
    <div class="contents">
        <!-- 셀렉트(검색, 보기 선택, 사용자여부 선택, 레파지토리 클론) :s -->
        <div class="rSearch_group">
            <div class="sel_group">
                <form id="frm_search" method="get" action="/user/repository/">
                    <input type="hidden" id="requestPage" name="page" value="<c:out value='${page}' default='0' />" />
                    <input type="hidden" id="requestSize" name="size" value="<c:out value='${size}' default='0' />" />
                    <input type="hidden" id="type1" name="type1" value="<c:out value='${type1}' default='' />" />
                    <input type="hidden" id="type2" name="type2" value="<c:out value='${type2}' default='' />" />
                    <input type="hidden" id="reposort" name="reposort" value="<c:out value='${reposort}' default='' />" />
                    <div class="keyword_search">
                        <input type="text" name="repoName" id="repoSearch_keyword" style="-ms-ime-mode: active;" value="<c:out value='${repoName}' default=''/>" placeholder="레파지토리 명 검색" autocomplete="on"/>
                        <button type="button" class="btn_search" name="btn_repoSearch" id="btn_repoSearch"/>
                    </div>
                    <div class="selectbox select1 ml5" style="width:135px;">
                        <div>
                            <c:if test="${type1==''}"><strong id="repoListType">형상관리 전체</strong><span class="bul"></span></c:if>
                            <c:if test="${type1=='git'}"><strong id="repoListType">Git</strong><span class="bul"></span></c:if>
                            <c:if test="${type1=='svn'}"><strong id="repoListType">SVN</strong><span class="bul"></span></c:if>
                        </div>
                        <ul class="select-list" onclick="repoSearchList()">
                            <li>형상관리 전체</li>
                            <li>Git</li>
                            <li>SVN</li>
                        </ul>
                    </div>
                    <div class="selectbox select2 ml5" style="width:135px;">
                        <div>
                            <c:if test="${type2==''}"><strong id="repoListPermission">전체 레파지토리</strong><span class="bul"></span></c:if>
                            <c:if test="${type2=='READ_WRITE_OWNER'}"><strong id="repoListPermission">참여 레파지토리</strong><span class="bul"></span></c:if>
                        </div>
                        <ul class="select-list" onclick="repoSearchList()">
                            <li class="selected" value="" id="allRepository" name ="repo_role" class="selectSortType">전체 레파지토리</li>
                            <li value="READ_WRITE_OWNER" id="read_Repository" name ="repo_role" class="selectSortType">참여 레파지토리</li>
                        </ul>
                    </div>
                    <div class="selectbox select5 ml5" style="width:135px;">
                        <div>
                            <c:if test="${reposort=='lastModified_true' || reposort==''}"><strong id="repoListreposort">최신 업데이트 순</strong><span class="bul"></span></c:if>
                            <c:if test="${reposort=='lastModified_false'}"><strong id="repoListreposort">오래된 업데이트 순</strong><span class="bul"></span></c:if>
                            <c:if test="${reposort=='creationDate_true'}"><strong id="repoListreposort">최신 생성일 순</strong><span class="bul"></span></c:if>
                            <c:if test="${reposort=='creationDate_false'}"><strong id="repoListreposort">오래된 생성일 순</strong><span class="bul"></span></c:if>
                        </div>
                        <ul class="select-list" onclick="repoSearchList()">
                            <li id="lastModified_desc" class="selectSortType">최신 업데이트 순</li>
                            <li id="lastModified_asc" class="selectSortType">오래된 업데이트 순</li>
                            <li id="created_desc" class="selectSortType">최신 생성일 순</li>
                            <li id="created_asc" class="selectSortType">오래된 생성일 순</li>
                        </ul>
                    </div>
                </form>
            </div>
        </div>
        <!--//셀렉트(검색, 보기 선택, 사용자여부 선택, 레파지토리 클론) :e -->
        <!-- 메인 탭 콘텐츠01 :s -->
        <div class="main_tab00">
            <div class="tab_content">
                <!-- 레파지토리 목록 :s -->
                <ul class="product_list">
                    <c:forEach items="${repositories}" var="repositories" varStatus="status">
                        <li id ="repositoryList">
                            <dl>

                         <%--#수정작업필요--%>
                            <c:forEach items="${repositories.permissions}" var="permissions" varStatus="sts">
                                <c:out value="${userid}"/>
                                <%--<c:choose>--%>
                                <%--[1-1]--%>
                                <c:if test="${permissions.name eq name}">
                                 <%--//권한이 있을때 표출--%>
                                 <dt><a href="/user/repositoryDetail/${repositories.id}">${repositories.name}</a></dt>
                                </c:if>
                            </c:forEach>
                                 <%--[1-2]--%>
                             <c:if test="${permissions.name eq name}">
                                 <%--권한이 없을때 표출--%>
                                 <dt>${repositories.name}</dt>
                             </c:if>
                             <%--</c:choose>--%>
                        <%--#수정작업필요--%>

                                <dd>
                                    <ul>
                                        <li class="sbj_txt">${repositories.description}</li>
                                        <li class="stateArea"><i class="ico_update"></i>마지막 업데이트 : ${repositories.lastModified}<span class="pr10"></span> <i class="ico_create"></i>생성일 : ${repositories.creationDate}</li>
                                    </ul>
                                </dd>
                                <c:choose>
                                    <c:when test="${repositories.type eq 'git'}">
                                        <dd class="thmb_img"><img src="/resources/images/img_git.png" alt="GIT 이미지" border="0"></dd>
                                    </c:when>
                                    <c:when test="${repositories.type eq 'svn'}">
                                        <dd class="thmb_img"><img src="/resources/images/img_svn.png" alt="SVN 이미지" border="0"></dd>
                                    </c:when>
                                </c:choose>
                                <dd class="icon_wrap">
                                    <ul class="ico_lst">
                                        <li class="ico_area">
                                            <c:forEach items="${repositories.permissions}" var="permissions" varStatus="sts">
                                                <c:out value="${userid}"/>
                                                <c:if test="${permissions.name eq name}">
                                                    <c:choose>
                                                        <c:when test="${permissions.type eq 'OWNER'}">
                                                            <img src="/resources/images/process_ico_own.png" alt="소유자 이미지" border="0"><p class="tit">소유자</p>
                                                        </c:when>
                                                        <c:when test="${permissions.type eq 'WRITE'}">
                                                            <a href="#"><img src="/resources/images/process_ico_modify.png" alt="수정권한 이미지" border="0">
                                                                <p class="tit">수정권한</p></a>
                                                        </c:when>
                                                        <c:when test="${permissions.type eq 'READ'}">
                                                            <a href="#"><img src="/resources/images/process_ico_contribute.png" alt="보기권한 이미지" border="0">
                                                                <p class="tit">보기권한</p></a>
                                                        </c:when>
                                                    </c:choose>
                                                </c:if>
                                            </c:forEach>
                                        </li>
                                        <%--
                                        <li class="ico_area">
                                            <c:choose>
                                                <c:when test="${repositories.public_}">
                                                    <img src="/resources/images/process_ico_public.png" alt="공개 이미지" border="0"><p class="tit">공개</p>
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="/resources/images/process_ico_private.png" alt="비공개 이미지" border="0"><p class="tit">비공개</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                        --%>
                                    </ul>
                                </dd>
                            </dl>
                        </li>
                    </c:forEach>
                    <%--${pageInfo.totalCnt}${repositoryCnt}--%>
                    <c:if test="${repositoryCnt==0}">
                        <li id ="repositoryList">
                            <dl>
                                <dt>조회된 데이터가 없습니다.</dt>
                            </dl>
                        </li>
                    </c:if>
                </ul>
                <!--//레파지토리 목록 :e -->
            </div>
        </div>
        <!--//메인 탭 콘텐츠01 :e -->
        <!-- 메인 탭 콘텐츠02 :s -->
        <div class="main_tab01 mTs" style="display:none;">
            <div class="tab_content">
                <!-- 레파지토리 목록 :s -->
                <ul class="product_list">
                    <c:forEach items="${public_repositories}" var="repositories" varStatus="status">
                        <li>
                            <dl>
                                <dt><a href="/user/repositoryDetail/${repositories.id}">${repositories.name}</a></dt>
                                <dd>
                                    <ul>
                                        <li class="sbj_txt"><a href="#">${repositories.description}</a></li>
                                        <li class="stateArea"><i class="ico_update"></i>마지막 업데이트 : ${repositories.lastModified}<span class="pr10"></span> <i class="ico_create"></i>생성일 : ${repositories.creationDate}</li>
                                    </ul>
                                </dd>
                                <c:choose>
                                    <c:when test="${repositories.type eq 'git'}">
                                        <dd class="thmb_img"><img src="/resources/images/img_git.png" alt="GIT 이미지" border="0"></dd>
                                    </c:when>
                                    <c:when test="${repositories.type eq 'svn'}">
                                        <dd class="thmb_img"><img src="/resources/images/img_svn.png" alt="SVN 이미지" border="0"></dd>
                                    </c:when>
                                </c:choose>
                                <dd class="icon_wrap">
                                    <ul class="ico_lst">
                                        <li class="ico_area">
                                            <c:forEach items="${repositories.permissions}" var="permissions" varStatus="sts">
                                                <c:if test="${permissions.name eq userid}">
                                                    <c:choose>
                                                        <c:when test="${permissions.type eq 'OWNER'}">
                                                            <img src="/resources/images/process_ico_own.png" alt="소유자 이미지" border="0"><p class="tit">소유자</p>
                                                        </c:when>
                                                        <c:when test="${permissions.type eq 'WRITE'}">
                                                            <a href="#"><img src="/resources/images/process_ico_modify.png" alt="수정권한 이미지" border="0">
                                                                <p class="tit">수정권한</p></a>
                                                        </c:when>
                                                        <c:when test="${permissions.type eq 'READ'}">
                                                            <a href="#"><img src="/resources/images/process_ico_contribute.png" alt="보기권한 이미지" border="0">
                                                                <p class="tit">보기권한</p></a>
                                                        </c:when>
                                                    </c:choose>
                                                </c:if>
                                            </c:forEach>
                                        </li>
                                        <li class="ico_area">
                                            <c:choose>
                                                <c:when test="${repositories.public_}">
                                                    <img src="/resources/images/process_ico_public.png" alt="공개 이미지" border="0"><p class="tit">공개</p>
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="/resources/images/process_ico_private.png" alt="비공개 이미지" border="0"><p class="tit">비공개</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </ul>
                                </dd>
                            </dl>
                        </li>
                    </c:forEach>
                </ul>
                <!--//레파지토리 목록 :e -->
            </div>
        </div>
        <!--//메인 탭 콘텐츠02 :e -->
        <!-- 메인 탭 콘텐츠03 :s -->
        <div class="main_tab02 mTs" style="display:none;">
            <div class="tab_content">
                <!-- 레파지토리 목록 :s -->
                <ul class="product_list">
                    <c:forEach items="${private_repositories}" var="repositories" varStatus="status">
                        <li>
                            <dl>//권한이있을때 표출

                                <dt><a href="/user/repositoryDetail/${repositories.id}">${repositories.name}</a></dt>
                                //권한이 없을때 표출
                                <dt>${repositories.name}</dt>

                                <dd>
                                    <ul>
                                        <li class="sbj_txt"><a href="#">${repositories.description}</a></li>
                                        <li class="stateArea"><i class="ico_update"></i>마지막 업데이트 : ${repositories.lastModified}<span class="pr10"></span> <i class="ico_create"></i>생성일 : ${repositories.creationDate}</li>
                                    </ul>
                                </dd>
                                <c:choose>
                                    <c:when test="${repositories.type eq 'git'}">
                                        <dd class="thmb_img"><img src="/resources/images/img_git.png" alt="GIT 이미지" border="0"></dd>
                                    </c:when>
                                    <c:when test="${repositories.type eq 'svn'}">
                                        <dd class="thmb_img"><img src="/resources/images/img_svn.png" alt="SVN 이미지" border="0"></dd>
                                    </c:when>
                                </c:choose>
                                <dd class="icon_wrap">
                                    <ul class="ico_lst">
                                        <li class="ico_area">
                                            <c:forEach items="${repositories.permissions}" var="permissions" varStatus="sts">
                                                <c:if test="${permissions.name eq userid}">
                                                    <c:choose>
                                                        <c:when test="${permissions.type eq 'OWNER'}">
                                                            <img src="/resources/images/process_ico_own.png" alt="소유자 이미지" border="0"><p class="tit">소유자</p>
                                                        </c:when>
                                                        <c:when test="${permissions.type eq 'WRITE'}">
                                                            <a href="#"><img src="/resources/images/process_ico_modify.png" alt="수정권한 이미지" border="0">
                                                                <p class="tit">수정권한</p></a>
                                                        </c:when>
                                                        <c:when test="${permissions.type eq 'READ'}">
                                                            <a href="#"><img src="/resources/images/process_ico_contribute.png" alt="보기권한 이미지" border="0">
                                                                <p class="tit">보기권한</p></a>
                                                        </c:when>
                                                    </c:choose>
                                                </c:if>
                                            </c:forEach>
                                        </li>
                                        <li class="ico_area">
                                            <c:choose>
                                                <c:when test="${repositories.public_}">
                                                    <img src="/resources/images/process_ico_public.png" alt="공개 이미지" border="0"><p class="tit">공개</p>
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="/resources/images/process_ico_private.png" alt="비공개 이미지" border="0"><p class="tit">비공개</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </ul>
                                </dd>
                            </dl>
                        </li>
                    </c:forEach>
                </ul>
                <!--//레파지토리 목록 :e -->
            </div>
        </div>
        <!--//메인 탭 콘텐츠03 :e -->
    </div>
    <!--//contents :e -->
</div>
<!--//contaniner :e -->
<!-- Top 가기 :s -->
<div class="follow" title="Scroll Back to Top">
    <a href="#" title="top"><img src="/resources/images/a_top.gif"></a>
</div>
<input type="hidden" id="requestSearchKeyword" name="requestSearchKeyword" value="<c:out value='${name}' default='' />" />

<input type="hidden" id="requestSort" name="requestSort" value="<c:out value='${reposort}' default='' />" />
<input type="hidden" id="role" name="role" value="<c:out value='${role}' />" />

<!--//Top 가기 :e -->
<%-- Java Script --%>
<script type="text/javascript">
    var page = 0;
    var size = 10;
    var repoSearchList = function(){
        var param1 = $("#repoListType").text();

        switch (param1) {
            case "Git" :
                param1 = "git";
                break;
            case "SVN" :
                param1 = "svn";
                break;
            default:
                param1 = "";
        }
        $("#type1").val(param1);
        var param2 = $("#repoListPermission").text();
        switch (param2) {
            case "소유 레파지토리" :
                param2 = "OWNER";
                break;
            case "읽기 레파지토리" :
                param2 = "READ";
                break;
            case "수정 레파지토리" :
                param2 = "WRITE";
                break;
            case "참여 레파지토리" :
                param2 = "READ_WRITE_OWNER";
                break;
            default:
                param2 = "";
        }
        $("#type2").val(param2);

        var param3 = $("#repoListreposort").text();
        switch (param3) {
            case "최신 업데이트 순" :
                param3 = "lastModified_true";
                break;
            case "오래된 업데이트 순" :
                param3 = "lastModified_false";
                break;
            case "최신 생성일 순" :
                param3 = "creationDate_true";
                break;
            case "오래된 생성일 순" :
                param3 = "creationDate_false";
                break;
            default:
                param3 = "";
        }
        $("#reposort").val(param3);
        $("#frm_search").submit();
    };


    // CALLBACK
    function callback(data){
        console.log("======================================================================================================================");
        console.log(":::sendCALLBACK 콘솔 로그:::");
        console.log("data : " + JSON.stringify(data));
        console.log("=======================================================================================================================");
    };

    $(document).ready(function () {

//        procPopupConfirm("승인", "승인메세지", "승인버튼메세지");
        // BIND :: repoSearch_keyword
        $( "#repoSearch_keyword" ).keyup(function( event ) {
            if (event.which == 13) {
                repoSearchList();
            }
        });

        // BIND :: [돋보기] btn_repoSearch
        $("#btn_repoSearch").click(function() {
            //procPopupConfirm("승인", "승인메세지", "승인버튼메세지");
            //repoSearchList();
            console.log(":::(end)btn_repoSearch || 돋보기 콘솔 로그:::");
        });

        // BIND :: Select(1) git or svn
        $("#type").on("click", function () {
            $("#git").removeClass('selected');
            $("#svn").attr('class', 'selected');
        });

        // BIND :: slsect(3) "select-list"
        $(".selectSortType").on("click", function(){
            var requestSort = $(this).attr('id');

            $("#requestSort").val($(this).attr('id').replace("_", ","));
            repoSearchList();
        });
    });

    $("#btn_repoCreate").click (function() {
        console.log("레파지토리 신규 생성");
    });

    $.fn.selectDesign = function(){
        var t = $(this);
        var div = t.children("div");
        var strong = div.children("strong");
        var ul = t.children("ul");
        var li = ul.children("li");
        var door = false;

        div.click(function(){
            if(door){
                ul.hide();
            }else{
                ul.show();
            }
            door = !door;
        });
        ul.mouseleave(function () {
            ul.hide();
            door = false;
        });

        li.click(function(){
            var txt = $(this).text();
            strong.html(txt);

        });

    };
    $(".select1").selectDesign();
    $(".select2").selectDesign();
    $(".select5").selectDesign();

    $('#comboBox').bind('focusout', function () {
        $('#comboBoxData').hide();
    });

    //loding bar
    $(window).scroll(function() {
        if ($(window).scrollTop() >= $(document).height() - $(window).height()) {
        }
    });

    var RepositoryList = function(){
        var url = "/user/repository/?repoName="+$("#repoSearch_keyword").val()+ "&reposort=" + $("#requestSort").val();
        var param = {
            "type":"",
            "sort":"lastModified",
            "reposort": "lastModified"};
        procCallAjax('get', url, param, callbackGetRepositoryList);
    }


    var callbackGetRepositoryList = function(data) {



        var listLength = data.repositories.length;
        console.log("DATA " + data.repositories.length);

//        var page = data.page;
//        var size = data.size;
//        var totalPages = data.totalPages;
        var isLast = data.last;


        var htmlString = [];

        if (0 === listLength) {
            htmlString = "<li><dl><dt>NO SEARCH RESULTS</dt><dd></li>";
        } else {

            for (var i = 0; i < listLength; i++) {
                console.log("DATA " + data.repositories[i].id);
                //htmlString.push(''<li id ="repositoryList">'
            }

        }

    };

</script>
<!--//select 스크립트-->
