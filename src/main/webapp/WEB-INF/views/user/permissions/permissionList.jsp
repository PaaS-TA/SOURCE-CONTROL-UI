<!--
=================================================================
* 시 스 템 명 : 소스컨트롤러 웹 UI
* 업 무 명 : 사용자 인스턴스 참여자 목록
* 프로그램명 : permissionList.jsp(참여자 목록 리스트)
* 프로그램 개요 : 사용자 목록 리스트 화면
* 작 성 자 : 이인정
* 작 성 일 : 2017.07.10
* 화면 ID: UI-FDSC-8000
* 화면설계 ID: UI-SBSC-8000
=================================================================
수정자 / 수정일 :
수정사유 / 내역 :
=================================================================
-->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/xml" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="container">
    <!-- location :s -->
    <div class="location">
        <div class="fl">
            <ul>
                <li><a href="/user/repository/" class="home">Home</a></li>
                <li><a href="/user/permissionList/" title="user list">사용자 목록</a></li>
                <!--마지막 경로-->
            </ul>
        </div>
        <%--<div class="fr">--%>
            <%--<a href="/user/create/" ><button type="button" id="btn_repoCreate" class="button btn_default" title="사용자 생성" >사용자 생성</button></a>--%>
        <%--</div>--%>
    </div>
    <!-- location :end -->
    <!-- contents :s -->
    <div class="contents">
        <div class="rSearch_group">
            <div class="sel_group">
                <div class="keyword_search">
                    <input id="search_keyword2" type="text" name="search_keyword2" style="-ms-ime-mode: active;"
                           value="" placeholder="Search ID or name" autocomplete="on"></input>
                    <a class="btn_search" title="Search by participant ID or name" onclick="searchPermissions();"></a>
                </div>
                <div class="selectbox select1 ml5" style="width:95px;">
                    <div>
                        <strong id="permissionSelect1">all</strong><span class="bul"></span>
                    </div>
                    <ul class="select-list" onclick="searchPermissions();">
                        <li>all</li>
                        <li>Administrator</li>
                        <li>user</li>
                    </ul>
                </div>
                <div class="selectbox select2 ml5" style="width:115px;">
                    <div>
                        <strong id="permissionSelect2">all</strong><span class="bul"></span>
                    </div>
                    <ul class="select-list" onclick="searchPermissions();">
                        <li>all</li>
                        <li>use</li>
                        <li>stop</li>
                    </ul>
                </div>

                <a href="/user/create/"> <jsp:include page="/WEB-INF/views/user/common/buttonCreateAhref.jsp"></jsp:include>
                    <%--<button type="button" class="button btn_default ml5" title="참여자 추가">
                    사용자 추가
                </button>
                --%></a>
                <div class="fr"><span id="RPPermissionsCnt"></span></div>
            </div>
        </div>
        <!-- 레파지토리 목록(이미지없는) :s -->
        <ul class="product_list2" id="permissionsList" name="permissionsList">
        </ul>
        <!--//레파지토리 목록(이미지없는) :e -->
        <!-- 더보기 버튼 :s -->
        <div class="table_more" id="morePermissionsListButtonArea" style="display: inline;">
            <div class="btn_more" id="btnMore" name="btnMore">more</div>
        </div>
    </div>
    <!--//contents :e -->
</div>
<!--//contaniner :e -->

<!-- Top 가기 :s -->
<div class="follow" title="Scroll Back to Top">
    <a href="#" title="top"><img src="/resources/images/a_top.gif"></a>
</div>
<!--//Top 가기 :e -->
<script>
    page = 0;
    size = 10;
    $.fn.selectDesign = function () {
        var t = $(this);
        var div = t.children("div");
        var strong = div.children("strong");
        var ul = t.children("ul");
        var li = ul.children("li");
        var button = ul.children("button");
        var door = false;

        div.click(function () {
            if (door) {
                ul.hide();
            } else {
                ul.show();
            }
            door = !door;
        });

        ul.mouseleave(function () {
            ul.hide();
            door = false;
        });

        li.click(function () {
            var txt = $(this).text();
            var val = $(this).val();
            strong.text(txt);
            strong.val(val);
            ul.hide();
        });
    };

    $(".select1").selectDesign();
    $(".select2").selectDesign();
    $(document).ready(function () {
        searchPermissions();
        //BIND : 더보기 기능 BUTTON
        $("#btnMore").on("click", function(){
            page++;
            morePermissions();
        });
        $("#buttonCreateAref").text("create user");
        $("#buttonCreateAref").addClass('button btn_default ml5');

    });
    /**
     * 참여자 정보 탭 javascript 시작
     */

    $("#search_keyword2").keyup(function (event) {
        if (event.which === 13) {
            searchPermissions();
        }
    });

    var searchPermissions = function () {

        page = 0;
        morePermissions();
    };

    var getUser = function () {
        searchPermissions();
    };

    var morePermissions = function () {
        var url = "/user/instanceUser/";
        var param1 = $("#permissionSelect1").text();
        var param2 = $("#permissionSelect2").text();
        switch (param1) {
            case "Administrator" :
                param1 = "Y";
                break;
            case "user" :
                param1 = "N";
                break;
            default:
                param1 = "";
        }
        switch (param2) {
            case "use" :
                param2 = "true";
                break;
            case "stop" :
                param2 = "false";
                break;
            default:
                param2 = "";
        }
        var param = "?page=" + page + "&size=" + size + "&createYn=" + param1 + "&active=" + param2 + "&searchUserId=" + $("#search_keyword2").val();
        url = url + param;
        procCallAjax('get', url, param, permissionCallback);
    };

    var permissionCallback = function (data) {
        var rtnMap = data.rtnMap;
        if(rtnMap.number==0){
            $("#permissionsList").children().remove();
        }
        var num = rtnMap.number * rtnMap.size + rtnMap.numberOfElements
        $("#RPPermissionsCnt").text(total' + rtnMap.totalElements + 'cases');
        if (rtnMap === null || rtnMap.content.length === 0) {
            initialPermissionList();
        } else {
            var permissions = rtnMap.content;

            for (var i = 0; i < permissions.length; i++) {
                var varPermissionHtml = '<li><a href="/user/instanceUserModify/'+permissions[i].userId+'.json\"  class="home"><dl> <dt>' + permissions[i].userId + '<dd> <ul>'
                    + '<li class="sbj_txt">';
                if (permissions[i].userName === '') {
                    varPermissionHtml = varPermissionHtml+'-';
                }else {
                    varPermissionHtml = varPermissionHtml + permissions[i].userName;
                }
                varPermissionHtml = varPermissionHtml + '</li>'
                    + '<li class="stateArea"><i class="ico_create"></i>creation date :' + permissions[i].userCreatedDate + '<span class="pr10"></span>'
                    + '<i class="ico_modify"></i>date of modification : ' + permissions[i].userModifiedDate + '</li>'
                    + '</ul>  </dd> <dd class="icon_wrap"> <ul class="ico_lst">';
                if (permissions[i].userCreateYn === 'Y') {
                    varPermissionHtml = varPermissionHtml + ' <li class="ico_area"> <img src="/resources/images/process_ico_admin.png" alt="admin image" border="0">'
                        + ' <p class="tit">Administrator</p> </li>';
                }
                if (permissions[i].userCreateYn === 'N') {
                    varPermissionHtml = varPermissionHtml + ' <li class="ico_area"> <img src="/resources/images/process_ico_contribute.png" alt="read image" border="0">'
                        + ' <p class="tit">user</p> </li>';
                }
                if (permissions[i].userActive) {
                    varPermissionHtml = varPermissionHtml + ' <li class="ico_area"> <img src="/resources/images/process_ico_ownership.png" alt="use image" border="0">'
                        + '<p class="tit">use</p>   </li>';
                } else {
                    varPermissionHtml = varPermissionHtml + ' <li class="ico_area"> <img src="/resources/images/process_ico_stop.png" alt="still image" border="0">'
                        + '<p class="tit">stop</p>   </li>';
                }
//                varPermissionHtml = varPermissionHtml + ' <li class="ico_area"> <img src="/resources/images/process_ico_stop.png" alt="삭제 이미지" border="0"> <p class="tit">삭제</p> </li>';
                varPermissionHtml = varPermissionHtml + '  </ul> </dd> </dl> </a></li>';
                $('#permissionsList').append(varPermissionHtml);
            }
        }

        if (rtnMap === null || rtnMap.last === true) {
            $("#morePermissionsListButtonArea").hide();
        }
    };
    var initialPermissionList = function(){
        var varPermissionHtml ='<li id="initRepoList" name="initRepoList"> <dl>No data was retrieved.</dl>            </li>';
        $('#permissionsList').append(varPermissionHtml);
    }

</script>