<!--
=================================================================
* 시 스 템 명 : 소스컨트롤러 웹 UI
* 업 무 명 : 레파지토리에 참여된 참여자 목록
* 프로그램명permissionList.jsp.jsp(참여자 목록 리스트)
* 프로그램 개요 : 참여자 목록 리스트 화면
* 작 성 자 : 이인정
* 작 성 일 : 2018.07.10
* 화면 ID: UI-FDSC-8000
* 화면설계 ID: UI-SBSC-8000
=================================================================
수정자 / 수정일 :
수정사유 / 내역 :
=================================================================
-->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="rSearch_group">
    <div class="sel_group">
        <div class="keyword_search">
            <input id="search_keyword2" type="text" name="search_keyword2" style="-ms-ime-mode: active;"
                   value="" placeholder="Search by participant ID or name" autocomplete="on"></input>
            <button type="button" class="btn_search" title="Search by participant ID or name" onclick="searchPermissions();"></button>
        </div>
        <div class="selectbox select3 ml5" style="width:95px;">
            <div>
                <strong id="permissionSelect1">all</strong><span class="bul"></span>
            </div>
            <ul class="select-list" onclick="searchPermissions();">
                <li>all</li>
                <li>look</li>
                <li>correction</li>
            </ul>
        </div>
        <div class="selectbox select4 ml5" style="width:115px;">
            <div>
                <strong id="permissionSelect2">all</strong><span class="bul"></span>
            </div>
            <ul class="select-list" onclick="searchPermissions();">
                <li>all</li>
                <li>use</li>
                <li>stop</li>
            </ul>
        </div>
        <jsp:include page="../common/buttonCreateOnclick.jsp"></jsp:include>
        <div class="fr"><span id="RPPermissionsCnt"></span></div>
    </div>
</div>
<!-- 레파지토리 목록(이미지없는) :s -->
<ul class="product_list2" id="permissionsList" name="permissionsList">
</ul>
<!--//레파지토리 목록(이미지없는) :e -->
<!-- 더보기 버튼 :s -->
<div class="table_more" id="morePermissionsListButtonArea" name ="morePermissionsListButtonArea" style="display: none;">
    <div class="btn_more" id="btnMore" name="btnMore">more</div>
</div>
<!--//Top 가기 :e -->
<script>
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

    $(".select3").selectDesign();
    $(".select4").selectDesign();
    $(document).ready(function () {
        $("#buttonCreateOnclick").text("Add/Remove Participant");
    });
    $("#buttonCreateOnclick").click(function (event) {
        putPermissionInitial();
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
        $("#permissionsList").children().remove();
        var url = "/user/permissions/" + $("#repositoryId").val();
        var param1 = $("#permissionSelect1").text();
        var param2 = $("#permissionSelect2").text();
        switch (param1) {
            case "look" :
                param1 = "READ";
                break;
            case "correction" :
                param1 = "WRITE";
                break;
            case "owner" :
                param1 = "OWNER";
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
        var param = "?page=" + page + "&size=" + size + "&type1=" + param1 + "&type2=" + param2 + "&searchUserName=" + $("#search_keyword2").val();
        url = url + param;
        procCallAjax('get', url, param, permissionCallback);
    };

    var permissionCallback = function (data) {
//        $("#detailPermissionCntMain").text(data.rtnList.totalElements);
        if(data.rtnList.number==0){
            $("#permissionsList").children().remove();
        }
        $("#RPPermissionsCnt").text("Total "+ data.rtnList.totalElements + '  ');
        if (data.rtnList == null || data.rtnList.content.length == 0) {
            initialPermissionList();
        } else {
            var permissions = data.rtnList.content;
            for (var i = 0; i < permissions.length; i++) {
                var varPermissionHtml ='<li onclick="detailPermission(\''
                    + permissions[i].name+'\','+ '\''
                    + permissions[i].permission.permission+'\','+ '\''
                    + permissions[i].permission.no+'\')" ><a href="#"><dl> <dt>' + permissions[i].name + '<dd> <ul>'
                    + '<li class="sbj_txt">' + permissions[i].displayName + '</li>'
                    + '<li class="hidden" onclick="(\''+permissions[i].permission.no+'\')">' + permissions[i].permission.no + '</li>'
                    + '<li class="stateArea"><i class="ico_create"></i>creation date :' + permissions[i].creationDate + '<span class="pr10"></span>'
                    + '<i class="ico_modify"></i>date of modification : ' + permissions[i].lastModified + '</li>'
                    + '</ul>  </dd> <dd class="icon_wrap"> <ul class="ico_lst">'

                if (permissions[i].permission.permission === 'OWNER') {
                    varPermissionHtml = varPermissionHtml + ' <li class="ico_area"> <img src="/resources/images/process_ico_admin.png" alt="crystal image" border="0">'
                        + ' <p class="tit">owner</p> </li>';
                }
                if (permissions[i].permission.permission === 'READ') {
                    varPermissionHtml = varPermissionHtml + ' <li class="ico_area"> <img src="/resources/images/process_ico_contribute.png" alt="read image" border="0">'
                        + ' <p class="tit">look</p> </li>';
                }
                if (permissions[i].permission.permission === 'WRITE') {
                    varPermissionHtml = varPermissionHtml + ' <li class="ico_area"> <img src="/resources/images/process_ico_modify.png" alt="write image" border="0">'
                        + ' <p class="tit">writing</p> </li>';
                }
                if (permissions[i].active) {
                    varPermissionHtml = varPermissionHtml + ' <li class="ico_area"> <img src="/resources/images/process_ico_ownership.png" alt="use image" border="0">'
                        + '<p class="tit">use</p>   </li>';
                } else {
                    varPermissionHtml = varPermissionHtml + ' <li class="ico_area"> <img src="/resources/images/process_ico_stop.png" alt="still image" border="0">'
                        + '<p class="tit">stop</p>   </li>';
                }

                varPermissionHtml = varPermissionHtml + '  </ul> </dd> </dl></a> </li>';
                $('#permissionsList').append(varPermissionHtml);
            }
            if (data.rtnList === null || data.rtnList.last) {
                $('#morePermissionsListButtonArea').css('display', 'none');
            }else{
                $('#morePermissionsListButtonArea').css('display', 'block');
            }
        }
    };

    var initialPermissionList = function(){
        var varPermissionHtml ='<li id="initRepoList" name="initRepoList"><dl>No data was retrieved.</dl></li>';
        $('#permissionsList').append(varPermissionHtml);
        $('#morePermissionsListButtonArea').css('display', 'none');
    };


//    function putPermission(){)
    function putPermissionInitial(){
        $('#permissionCreate').css('display', 'block');
        $('#tabPermissionlist').css('display', 'none');
        $('#permissionUpdate').css('display', 'none');

    }
    function detailPermission(name,permission,no){
        getPermissionDetail(name,permission,no);
    }

</script>