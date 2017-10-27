<!--
=================================================================
* 시 스 템 명 : 소스컨트롤러 웹 UI
* 업 무 명 : 레파지토리에 참여된 참여자 목록
* 프로그램명permissionList.jsp.jsp(참여자 목록 리스트)
* 프로그램 개요 : 참여자 목록 리스트 화면
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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="rSearch_group">
    <div class="sel_group">
        <div class="keyword_search">
            <input id="search_keyword2" type="text" name="search_keyword2" style="-ms-ime-mode: active;"
                   value="" placeholder="참여자 아이디 또는 이름 검색" autocomplete="on"></input>
            <button type="button" class="btn_search" title="참여자 아이디 또는 이름 검색" onclick="searchPermissions();"></button>
        </div>
        <div class="selectbox select3 ml5" style="width:95px;">
            <div>
                <strong id="permissionSelect1">전체</strong><span class="bul"></span>
            </div>
            <ul class="select-list" onclick="searchPermissions();">
                <li>전체</li>
                <li>보기</li>
                <li>수정</li>
            </ul>
        </div>
        <div class="selectbox select4 ml5" style="width:115px;">
            <div>
                <strong id="permissionSelect2">전체</strong><span class="bul"></span>
            </div>
            <ul class="select-list" onclick="searchPermissions();">
                <li>전체</li>
                <li>사용</li>
                <li>정지</li>
            </ul>
        </div>
        <jsp:include page="../common/buttonCreateOnclick.jsp"></jsp:include>
        <div class="fr"><span id="RPPermissionsCnt"></span></div>
    </div>
</div>
<!--//셀렉트(검색, 보기 선택, 사용자여부 선택, 레파지토리 클론) :e -->
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
        searchPermissions();
        $("#buttonCreateOnclick").text("참여자 추가");
    });
    $("#buttonCreateOnclick").click(function (event) {
        putPermission();
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
            case "보기" :
                param1 = "READ";
                break;
            case "수정" :
                param1 = "WRITE";
                break;
            case "소유자" :
                param1 = "OWNER";
                break;
            default:
                param1 = "";
        }
        switch (param2) {
            case "사용" :
                param2 = "true";
                break;
            case "정지" :
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
        $("#detailPermissionCntMain").text(data.rtnList.totalElements);
        $("#RPPermissionsCnt").text(data.rtnList.numberOfElements + ' / ' + data.rtnList.totalElements + '건');
        if (data.rtnList === null || data.rtnList.content.length === 0) {
            initialPermissionList();
        } else {
            var permissions = data.rtnList.content;
            for (var i = 0; i < permissions.length; i++) {
                var varPermissionHtml ='<li> <dl> <dt>' + permissions[i].name + '<dd> <ul>'
                    + '<li class="sbj_txt" onclick="detailPermission(\''+permissions[i].name+'\',+ \''+permissions[i].permission.no+'\'+ \''+permissions[i].permission.permission+'\')">' + permissions[i].displayName + '</li>'
                    + '<li class="hidden" onclick="(\''+permissions[i].permission.no+'\')">' + permissions[i].permission.no + '</li>'
                    + '<li class="stateArea"><i class="ico_create"></i>생성일 :' + permissions[i].creationDate + '<span class="pr10"></span>'
                    + '<i class="ico_modify"></i>수정일 : ' + permissions[i].lastModified + '</li>'
                    + '</ul>  </dd> <dd class="icon_wrap"> <ul class="ico_lst">'

                if (permissions[i].permission.permission === 'OWNER') {
                    varPermissionHtml = varPermissionHtml + ' <li class="ico_area"> <img src="/resources/images/process_ico_modify.png" alt="수정 이미지" border="0">'
                        + ' <p class="tit">소유자</p> </li>';
                }
                if (permissions[i].permission.permission === 'READ') {
                    varPermissionHtml = varPermissionHtml + ' <li class="ico_area"> <img src="/resources/images/process_ico_contribute.png" alt="읽기 이미지" border="0">'
                        + ' <p class="tit">보기</p> </li>';
                }
                if (permissions[i].permission.permission === 'WRITE') {
                    varPermissionHtml = varPermissionHtml + ' <li class="ico_area"> <img src="/resources/images/process_ico_modify.png" alt="쓰기 이미지" border="0">'
                        + ' <p class="tit">쓰기</p> </li>';
                }
                if (permissions[i].active) {
                    varPermissionHtml = varPermissionHtml + ' <li class="ico_area"> <img src="/resources/images/process_ico_ownership.png" alt="사용 이미지" border="0">'
                        + '<p class="tit">사용</p>   </li>';
                } else {
                    varPermissionHtml = varPermissionHtml + ' <li class="ico_area"> <img src="/resources/images/process_ico_stop.png" alt="정지 이미지" border="0">'
                        + '<p class="tit">정지</p>   </li>';
                }

                varPermissionHtml = varPermissionHtml + '  </ul> </dd> </dl> </li>';
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
        var varPermissionHtml ='<li id="initRepoList" name="initRepoList"><dl>조회된 데이터가 없습니다.</dl></li>';
        $('#permissionsList').append(varPermissionHtml);
        $('#morePermissionsListButtonArea').css('display', 'none');

    };

    function putPermission(){
        $('#permissionCreate').css('display', 'block');
        $('#tabPermissionlist').css('display', 'none');
    }

    function detailPermission(name,no,permission){
        $("#viewUser").val(no);
        $('#permissionUpdate').css('display', 'block');
        $('#tabPermissionlist').css('display', 'none');
        $(":input:radio[name=type_datail]:checked");
        getPermissionDetail(name,no);
    }

    //BIND :: move to 'detailPermission.jsp'
    function getPermissionDetail(name){

        procCallAjax('get','/user/getInstanceUser/'+name+'.json',null,detailInformation);
    }

</script>