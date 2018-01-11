<%--
  Created by IntelliJ IDEA.
  User: lena
  Date: 2017-06-26
  Time: 오후 3:30
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="input" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <!-- contaniner :s -->
    <div id="container">
        <!-- location :s -->
        <div class="location">
            <ul>
                <li><a href="/user/repositoryl/" class="home">홈으로</a></li>
                <li><a href="#" title="${title}">${title}</a></li><!--마지막 경로-->
            </ul>
            <div class="fr">
                <button type="button" id="btn_repoCreate" class="button btn_default" title="신규생성">신규생성</button>
            </div>
        </div>
        <!--//location :e -->
        <!-- contents :s -->
        <div class="contents">
            <!-- main_tab :s -->
            <div class="main_tab">
                <ul>
                    <li class="fst active"><a href="#;" onClick="main_tab(0);">전체(ALL)</a></li>
                    <li><a href="#;" onClick="main_tab(1);">공개(Public)</a></li>
                    <li><a href="#;" onClick="main_tab(2);">비공개(Private)</a></li>
                </ul>
            </div>
            <!--//main_tab :e -->
            <div class="rSearch_group">
                <div class="sel_group">
                    <%--<form id="frm_search" method="post" action="">--%>
                        <input type="hidden" name="username" value="scmadmin" />
                        <input type="hidden" name="username" value="scmadmin" />
                        <div class="keyword_search">
                            <input type="text" type="text" id="search_keyword" style="-ms-ime-mode: active;" value="" placeholder="레파지토리 명 검색" autocomplete="on"/>
                            <button type="button" class="btn_search" id="btn_search"/>
                        </div>
                        <div class="selectbox select1 ml5" style="width:135px;">
                            <div>
                                <strong>필터</strong><span class="bul"></span>
                            </div>
                            <ul class="select-list" id="type">
                                <li >형상관리 전체</li>
                                <li>Git</li>
                                <li>SVN</li>
                            </ul>
                        </div>
                        <div class="selectbox select2 ml5" style="width:135px;">
                            <div>
                                <strong>필터</strong><span class="bul"></span>
                            </div>
                            <ul class="select-list">
                                <li>전체 레파지토리</li>
                                <li>소유 레파지토리</li>
                                <li>참여 레파지토리</li>
                            </ul>
                        </div>
                        <div class="selectbox select3 ml5" style="width:135px;">
                            <div>
                                <strong>보기 정렬 선택</strong><span class="bul"></span>
                            </div>
                            <ul class="select-list">
                                <li>최신 업데이트 순</li>
                                <li>오래된 업데이트 순</li>
                                <li>최신 생성일 순</li>
                                <li>오래된 생성일 순</li>
                            </ul>
                        </div>
                    <%--</form>--%>
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
                                    <dt><a href="/user/repositoryDetail/${repositories.id}">${repositories.name}</a></dt>
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
            <!--//메인 탭 콘텐츠03 :e -->
        </div>
        <!--//contents :e -->
    </div>
    <!--//contaniner :e -->
    <!-- Top 가기 :s -->
    <div class="follow" title="Scroll Back to Top">
        <a href="#" title="top"><img src="/resources/images/a_top.gif"></a>
    </div>
    <!--//Top 가기 :e -->
    <%-- Java Script --%>
    <script type="text/javascript">
        $(document).ready(function () {
            searchList();
        });


        $("#btn_repoCreate").click (function() {

            console.log("레파지토리 신규 생성");
        });
        $("#btn_search").click (function() {
            $("#repositoryList").remove();
            searchList();
            console.log("조회");
        });
        $( "#search_keyword" ).keyup(function( event ) {
            if ( event.which === 13 ) {
                searchList();
            }
        });

        var searchList = function(){
            alert($("#search_keyword").val());
            var url = "/user/repository/";
//            var param = "username=scmadmin";
            var param = {
                "type":"git",
                "sort":"lastModified",
                "reposort":"lastModified",
                "repoName" : $("#search_keyword").val()};
            procCallAjax('get', url, param, callback);
        };
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

            li.click(function(){
                var txt = $(this).text();
                strong.html(txt);
                div.click();
            });
        };
        $(".select1").selectDesign();
        $(".select2").selectDesign();
        $(".select3").selectDesign();
        $(".select4").selectDesign();


        var callback = function(data){
            console.log("data callback : "+ data);
        }
    </script>
    <!--//select 스크립트-->
