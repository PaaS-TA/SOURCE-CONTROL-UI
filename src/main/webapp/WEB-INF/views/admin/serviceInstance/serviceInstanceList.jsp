<%--
  Created by IntelliJ IDEA.
  User: lena
  Date: 2017-06-29
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
            <li><a href="javascript:void(0);" onclick="procMovePage('/');" class="home">home</a></li>
            <li><a href="javascript:void(0);" onclick="procMovePage('/');" title="">Configuration management application list</a></li>
        </ul>
    </div>
    <!--//location :e -->
    <!-- contents :s -->
    <div class="contents">
        <!-- 검색 :s -->
        <div class="rSearch_group">
            <div class="sel_group">
                <%--<form id="frm_search" method="get" action="serviceInstanceList.jsp">--%>
                    <div class="keyword_search fr">
                        <input id="search_keyword" type="text" name="search_keyword" value="" style="-ms-ime-mode: active;" placeholder="Organization name search"  value="${listRequest.organizationName}"/>
                        <input type="button" class="btn_search" title="Search" id="btnSearch">
                    </div>
                <%--</form>--%>
            </div>
        </div>
        <!--//검색 :e -->
        <!-- 메인 탭 콘텐츠01 :s : 형상관리 화면 목록 -->
        <div class="main_tab00">
            <div class="tab_content">
                <ul class="product_list2" id="listArea"></ul>
                <!-- 더보기 버튼 :s -->
                <div class="table_more" id="moreListButtonArea" style="display: none;">
                    <div class="btn_more" id="btnMore">more</div>
                </div>
                <!--//더보기 버튼 :e -->
            </div>
        </div>
    </div>
</div>
<!--//contaniner :e -->

<input type="hidden" id="requestSearchKeyword" name="requestSearchKeyword" value="<c:out value='${organizationName}' default='' />" />
<input type="hidden" id="requestSort" name="requestSort" value="<c:out value='${sort}' default='' />" />

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

        var gPage = 0;
        var gCheckMore = false;

        //GET LIST
        function myFunction(val) {
            var url = "/admin/serviceInstantList";
            var param = {"organizationName":val + "&page=" + gPage};

            if (!gCheckMore) {
                gPage = 0;
            }
            procCallAjax('get', url, param, callback);
        }

        //CALLBACK
        function callback(data){
            var serviceInstances = data.serviceInstances;
            var listLength = serviceInstances.length;
            var isLast = data.last;
            var htmlString = [];

            for (var i = 0; i < listLength; i++) {
                console.log(i + ". createUserId :: " + serviceInstances[i].createUserId);
                console.log(i + ". createdTime :: " + serviceInstances[i].createdTime);
                console.log(i + ". instanceId :: " + serviceInstances[i].instanceId);
                console.log(i + ". organizationGuid :: " + serviceInstances[i].organizationGuid);
                console.log(i + ". organizationName :: " + serviceInstances[i].organizationName);
                console.log(i + ". planId :: " + serviceInstances[i].planId);
                console.log(i + ". seryiceId :: " + serviceInstances[i].seryiceId);
                console.log(i + ". spaceGuid :: " + serviceInstances[i].spaceGuid);
                console.log(":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::");

                htmlString.push("<li><dl><dt>"
                    + "<onclick='moveDetailPage(\"" + data.serviceInstances[i].organizationName +  "\");'> "
                    + serviceInstances[i].organizationName + '/' + serviceInstances[i].instanceId + '</dt><dd><ul>' +
                    '<li class="sbj_txt"><span id="instanceId">' + serviceInstances[i].createUserId + '</li>' +
                    '<li class="stateArea"><i class="ico_app"></i>Application Date : <a href="#">' + serviceInstances[i].createdTime + '</a></li></ul></dd><dd class="btn_wrap">' +
                    '<a href=\"/admin/repository/'+serviceInstances[i].instanceId+'\"><button type="button" class="button tbl_in_btn_lg" title="Repository view">Repository View </button></a>' +
                    '<a href=\"/admin/user/'+serviceInstances[i].instanceId+'\">&nbsp;<button type="button" class="button tbl_in_btn_lg" title="user view">User view</button></a></dd></dl></li>');
            }

            // 더보기 기능 : moreListButtonArea
            var moreListButtonArea = $('#moreListButtonArea');

            if (isLast) {
                moreListButtonArea.hide();
            } else {
                moreListButtonArea.show();
            }

            var listArea = $('#listArea');

            if (gCheckMore) {
                listArea.append(htmlString);
            } else {
                listArea.html(htmlString);
            }
        };

        // MOVE DETAIL PAGE
        var moveDetailPage = function(organizationName) {
            procMovePage("/serviceInstant/" + organizationName);
        };

        //BIND : '조직명' 검색하는 BLOCK

        function search() {
            var requestSearchKeyword = $("#search_keyword").val() + "&page=" + gPage + "&size=" + 10;

            var url = "/admin/serviceInstantList.do" ;

            if ("" !== requestSearchKeyword) {
                url += "?organizationName=" + requestSearchKeyword
            }

            if (!gCheckMore) {
                gPage = 0;
            }
            procCallAjax('get', url, null, callback);
        }

        //BIND : 검색 (돋보기) BUTTON
        $("#btnSearch").click(function() {
            gCheckMore = false;
            gPage = 0;
            search();
        });

        $( "#search_keyword" ).keyup(function( event ) {
            if (event.which === 13) {
                gCheckMore = false;
                gPage = 0;
                search();
            }
        });

        //BIND : 더보기 기능 BUTTON
        $("#btnMore").on("click", function(){
            gCheckMore = true;
            gPage++;
            search();
        });

        // BIND
        $("#btnReset").on("click", function() {
            $('#resultArea').html("");
        });

        // ON LOAD
        $(document.body).ready(function () {
        search();
        });

    </script>
<!--//select 스크립트-->

