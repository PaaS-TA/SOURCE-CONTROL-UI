<!--
=================================================================
* 시  스  템  명 : 슈퍼어드민 레파지토리 리스트 웹 UI
* 업    무    명 : 레파지토리 목록
* 프로그램명     : repositoryList.jsp(레파지토리 목록 )
* 프로그램  개요 : 레파지토리 목록 화면
* 작    성    자 : 이인정
* 작    성    일 : 2018.07.10
* 화면 ID: UI-FDSC-
* 화면설계 ID: UI-SBSC-
=================================================================
수정자 / 수정일 :
수정사유 / 내역 :
=================================================================
-->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- contaniner :s -->
<div id="container">
    <!-- location :s -->
    <div class="location">
        <ul>
            <li><a href="/admin/serviceInstantList" class="home">home</a></li>
            <li><a href="/admin/serviceInstantList" title="">Configuration management application list</a></li>
            <li><a href="/admin/repository/${instanceId}" title="${title}">${title}</a></li>
        </ul>
    </div>
    <!--//location :e -->
    <!-- contents :s -->
    <div class="contents">
        <!-- 검색 :s -->
        <div class="rSearch_group">
            <div class="sel_group">
                <%--<div class="fl">총 <span id="RP_cnt"></span></div>--%>
                <div class="keyword_search fr">
                    <input id="search_keyword" type="text" style="-ms-ime-mode: active;" value=""
                           placeholder="Repository name search" autocomplete="on" name="search_keyword" />
                    <input type="button" class="btn_search" id="btn_search" name="btn_search" title="Search">
                </div>
            </div>
        </div>
        <!--//검색 :e -->
        <!-- 메인 탭 콘텐츠01 :s -->
        <div class="main_tab00">
            <div class="tab_content">
                <!-- 레파지토리 목록 :s -->
                <ul class="product_list" id="repositoryList" name="repositoryList"></ul>
                <!--//레파지토리 목록 :e -->
            </div>
                <!-- 더보기 버튼 :s -->
            <div class="table_more" id="moreListButtonArea" style="display: block;">
                <div class="btn_more" id="btnMore" name="btnMore">more</div>
            </div>
        </div>
        <!--//메인 탭 콘텐츠01 :e -->
    </div>
    <!--//contents :e -->
</div>
<!--//contaniner :e -->
<!-- Top 가기 :s -->
<div class="follow" title="Scroll Back to Top">
    <a href="#" title="top"><img src="/resources/images/a_top.gif"></a>
</div>
<!--//Top 가기 :e -->
<!-- togglemenu -->
<script type="text/javascript">
    $(".wintoggle").click(function () {
        if ($(this).hasClass("active")) {
            $(this).removeClass("active");
            $(".togglemenu").hide();
        } else {
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
<script src="http://code.jquery.com/jquery-2.2.1.min.js"></script>
<script>
    $.fn.selectDesign = function () {
        var t = $(this);
        var div = t.children("div");
        var strong = div.children("strong");
        var ul = t.children("ul");
        var li = ul.children("li");
        var door = false;

        div.click(function () {
            if (door) {
                ul.hide();
            } else {
                ul.show();
            }
            door = !door;
        });

        li.click(function () {
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
<!--//select 스크립트-->

<%-- Page Event javaScript start--%>
<script>
    var pageSize = 10;
    var searchList = function(start, end){
        var url = "/admin/repository/repositoryList" ;
        var requestUrl ="?repoName="+$("#search_keyword").val()+"&start="+start+"&end="+end;
        url = url+requestUrl;
        console.log("requestUrl::::::::"+requestUrl);
        procCallAjax('get', url, null, callbackSearch);
    };

    $(document).ready(function () {
        searchList(1,pageSize);
    });

    $("#btn_search").click (function() {
        removeRepositoryList();
        searchList(1,pageSize);
    });
    $( "#search_keyword" ).keyup(function( event ) {
        if ( event.which === 13 ) {
            //데이터 삭제
            removeRepositoryList();
            searchList(1,pageSize);
        }
    });

    var callbackSearch = function(data) {

        $("#RP_cnt").text(data.pageInfo.endCnt+' / '+ data.pageInfo.totalCnt + 'total');
        if(data.repositories===null || data.repositories.length===0){
            initialList();
        }else{
            var repositories = data.repositories;

            for (var i = 0; i < repositories.length; i++) {
                var varHeadHtml ='<li>'+repositories[i].name+'</li>';
                var varHtml =
                    '<li>'
                    + '  <dl>'
                    + '    <dt>';
                    for (var j = 0; j < repositories[i].permissions.length; j++) {
                        if (repositories[i].permissions[j].name === name && repositories[i].permissions[j].type === 'OWNER') {
                            +  + repositories[i].permissions[j].name
                        }
                        varHtml += repositories[i].name;
                    }
                varHtml +=  '   </dt>'

                + ' <dd>'
                + '    <ul>'
                + '       <li class="sbj_txt">' ;
                if(repositories[i].description===null){
                    varHtml = varHtml+'';
                }else{
                    varHtml = varHtml+repositories[i].description;
                }
                varHtml = varHtml + '</li>'
                + '       <li class="stateArea">'
                + '           <i class="ico_update"></i>last update: ';
                if(repositories[i].lastModified===0){
                    varHtml = varHtml+"";
                }else{
                    varHtml = varHtml+new Date(repositories[i].lastModified);
                }varHtml = varHtml + '<span class="pr10"></span>'
//                    + new Date(repositories[i].lastModified)
//                    + '<span class="pr10"></span>'
                + '           <i class="ico_create"></i>creation date : ' +  new Date(repositories[i].creationDate) + '</li>'
                + '   </ul>'
                + '</dd>';
                if (repositories[i].type === 'git') {
                    varHtml += '<dd class="thmb_img"><img src="/resources/images/img_git.png" alt="GIT images" border="0"></dd>';
                }
                if (repositories[i].type === 'svn') {
                    varHtml += '<dd class="thmb_img"><img src="/resources/images/img_svn.png" alt="SVN image" border="0"></dd>';
                }
                varHtml += '<dd class="icon_wrap">'
                + '<ul class="ico_lst">'
                + '<li class="ico_area">';
                if (repositories[i].public) {
                    varHtml += '<img src="/resources/images/process_ico_public.png" alt="public image" border="0">'
                                + '<p class="tit">open</p>';
                } else {
                    varHtml += '<img src="/resources/images/process_ico_private.png" alt="private images" border="0">'
                            + '<p class="tit">Private</p>';
                }
                varHtml += '</li>'
                + '    </ul>'
                + '    </dd>'
                + '    </dl>'
                + '    </li>';
                $('#repositoryList').append(varHtml);

            }
        }
        if(data.pageInfo.totalCnt === data.pageInfo.endCnt){
            $("#moreListButtonArea").hide();
        }

    };

    var initialList = function(){
        $("#RP_cnt").text(0);
        var varHtml ='<li id="initRepoList" name="initRepoList"> <dl>No data was retrieved.</dl>            </li>';

    };
    var removeRepositoryList = function(){
        $("#repositoryList").children().remove();
    };
    $("#btnMore").click(function () {
        //page 추가
        var start =  $("#repositoryList").children().length+1;
        var end = start + pageSize;
       searchList(start,end);
    });


    <!-- togglemenu 스크립트 -->
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
<%-- Page Event javaScript end--%>