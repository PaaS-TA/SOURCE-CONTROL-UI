<%--
  Created by IntelliJ IDEA.
  User: Injeong
  Date: 2017-07-13
  Time: 오후 2:33
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!-- contaniner :s -->
    <div id="container">
        <!-- location :s -->
        <div class="location">
            <ul>
                <li><a href="/user/serviceInstantList"  class="home">홈으로</a></li>
                <li><a href="#" title="">형상관리 신청 목록</a></li>
            </ul>
        </div>
        <!--//location :e -->
        <!-- contents :s -->
        <div class="contents">
            <!-- 검색 :s -->
            <div class="rSearch_group">
                <div class="sel_group">
                    <%--<form id="frm_search" method="get" action="serviceInstantList.jsp">--%>
                        <%--<div class="keyword_search fr">--%>
                            <%--<input id="search_keyword" type="text" name="search_keyword" value="" style="-ms-ime-mode: active;" placeholder="조직 명 검색" autocomplete="on" onkeypress="if(event.keyCode==13) {gCheckMore = false; search(''); }" value="${listRequest.organizationName}"/>--%>
                            <%--<input type="button" class="btn_search" onclick="search();" href="javascript:void(0);" title="검색" id="btnSearch">--%>
                        <%--</div>--%>
                    <%--</form>--%>
                </div>
            </div>
            <!--//검색 :e -->
            <!-- 메인 탭 콘텐츠01 :s : 형상관리 화면 목록 -->
            <div class="main_tab00">
                    <!-- 레파지토리 목록 :s -->
                    <ul class="product_list">
                        <c:forEach items="${data}" var="data" varStatus="status">
                            <li id ="repositoryList">
                                <dl>
                                    <dt style=" font-size:18px;"><a href="/user/repository/${data.instanceId}?username=${data.createUserId}">instanceId:${data.instanceId}</a></dt>
                                    <dd>
                                        <ul>
                                            <li class="sbj_txt">organizationGuid:${data.organizationGuid}/organizationName:${data.organizationName}</li>
                                            <li class="sbj_txt">planId:${data.planId}
                                            /seryiceId:${data.seryiceId}</li>
                                            <li class="sbj_txt">spaceGuid:${data.spaceGuid}
                                            /createUserId:${data.createUserId}
                                            <li class="sbj_txt">createdTime:${data.createdTime}</li>
                                        </ul>
                                    </dd>
                                </dl>
                            </li>
                        </c:forEach>
                    </ul>
                    <!--//레파지토리 목록 :e -->
            </div>
            <!--//메인 탭 콘텐츠01 :e -->
            <!--//contents :e -->
        </div>
    </div>
    <!--//contaniner :e -->

    <!-- Top 가기 :s -->
    <div class="follow" title="Scroll Back to Top">
        <a href="#" title="top"><img src="/resources/images/a_top.gif"></a>
    </div>
    <!--//Top 가기 :e -->
    <!-- togglemenu -->
    <script type="text/javascript">
        $(".wintoggle").click(function(){
            if( $(this).hasClass("active") ){
                $(this).removeClass("active");
                $(".togglemenu").hide();
            }else{
                $(".togglemenu").hide();
                $(".wintoggle").removeClass("active");
                $(this).addClass("active");
                $(this).next().slideDown();
            }
            return false;
        });

    </script>
    <!--//togglemenu -->
    <!--select 스크립트-->
    <script src="http://code.jquery.com/jquery-2.2.1.min.js">

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
    </script>

<script>

    function search() {
        var requestSearchKeyword = "";
        var url = "/user/serviceInstantList" ;

        if ("" !== requestSearchKeyword) {
            url += "?organizationName=" + requestSearchKeyword
        }

        procCallAjax('get', url, null, callback);
    }


    function callback() {

    }

</script>

<!--//select 스크립트-->
