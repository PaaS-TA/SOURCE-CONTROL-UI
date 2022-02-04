<!--
=================================================================
* 시 스 템 명 : 소스컨트롤러 웹 UI
* 업 무 명 : 참여자 초대
* 프로그램명 : invitePermission.jsp(참여자 추가 )
* 프로그램 개요 : 참여자 추가 화면
* 작 성 자 : 이인정
* 작 성 일 : 2018.07.10
* 화면 ID: UI-SBSC-6200
* 화면설계 ID: UI-SBSC-6200
=================================================================
수정자 / 수정일 :
수정사유 / 내역 :
=================================================================
-->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/xml" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- Form 테이블 :s -->
<table summary="This is a user invitation search table." class="tbl_form02">
    <caption>
        User Invitation Search
    </caption>
    <colgroup>
        <col style="width: *"/>
    </colgroup>
    <tbody>
    <tr>
        <th class="f_title">Source controller user search</th>
    </tr>
    <tr>
        <td>
            <input type="text" id="searchInstRepoUserId" name="searchInstRepoUserId" placeholder="User Search"   style="width:40%;">
        </td>
    </tr>
    <tr>
        <td>
            <li style="width:40%;">
                <a href="#" class="wintoggle" style="width:40%;"><span class="RP_name">User Search List (<span  name="SrchPermissionUser" id="SrchPermissionUser">0</span>)<b class="nav_arrow"></b></span></a>
                <ul class="togglemenu" style="width:320px; top:120px;padding-top:0px; position:inherit;" id="SrchPermissionUserList" name="SrchPermissionUserList"></ul>
            </li>
        </td>
    </tr>
    </tbody>
</table>
<table summary="This is a participant-created input table." class="tbl_form02" id="tbl_form02">
    <caption>
        Add participant
    </caption>
    <colgroup>
        <col style="width: *"/>
    </colgroup>
    <tbody>
    <tr>
        <th class="f_title">Invite participants</th>
    </tr>
    <tr class=""><!--사용자검색 상세내용-->
        <td class="controlbox">
            <dl>
                <dt>added user</dt>
                <dd><span class="sm_tit">ID :</span><span id="insertId"></span><br></dd>
                <dd><span class="sm_tit">name :</span><span id="insertName"></span><br></dd>
                <dd><span class="sm_tit">e-mail :</span><span id="insertEmail"></span><br></dd>
            </dl>
        </td>
    </tr>
    </tbody>
</table>
<!--//Form 테이블 :e -->
<!-- 공통 Form 테이블 :s -->
<table summary="This is a selection table for adding participants such as usage and description." class="tbl_form" id="tbl_form03">
    <caption>
        Select whether to use additional participants or not
    </caption>
    <colgroup>
        <col style="width: 18%"/>
        <col style="width: *"/>
    </colgroup>
    <tbody>
    <tr>
        <th>Permissions (<span class="essential">*required (<span class="essential">*Required</span>)</th>
        <td>
            <label>
                <input type="radio" name="type" value="WRITE" checked="checked">write permission
                <input type="radio" name="type" value="READ">view right
            </label>
        </td>
    </tr>
    <tr>
        <th class="last">Description (optional)</th>
        <td>
            <textarea type="text" colos="20" rows="5" id = "PemissionName" name = "PemissionName" placeholder=""></textarea>
            <p class="desc" style="color:#fb5666;display: none" id="createPemissionNameAlert">Only English is allowed for descriptions shown in user information.</p>
        </td>
    </tr>
    </tbody>
</table>
<!--//공통 Form 테이블 :e -->
<!--기본버튼(Right 정렬) :s -->
<div class="fr">
    <jsp:include page="../common/buttonCreateOnclick3.jsp"></jsp:include>
    <button type="button" class="button btn_cancel" title="Cancel" onclick="putPermissionCancel();">Cancel</button>
</div>

<!--//기본버튼(Right 정렬) :e -->
<!-- togglemenu -->
<script type="text/javascript">
    $(document).ready(function () {

        //description
        $("#PemissionName").keyup(function () {
            var createRepositoryName = $("#PemissionName").val();
            if(!validRepositoryName(createRepositoryName)){
                $("#createPemissionNameAlert").show();
            }else{
                $("#createPemissionNameAlert").hide();
            }
        });

        //hide
        $("#tbl_form02").hide();
        $('#tbl_form03').hide();

        //searchInstRepoUserId
        $("#searchInstRepoUserId").keyup(function (event) {
            if (event.which == 13) {
                searchInstRepoUserId();
            }
        });

    });

    function searchInstRepoUserId() {
        $('#SrchPermissionUserList').children().remove();
        var searchId =$("#searchInstRepoUserId").val();
        if(searchId =="" || searchId ==null){
            popupAlertClick("Enter more than one Chinese character for the user search term.");
            return;
        }
//        var url = "/user/searchPermissions/?searchUserId=" + searchId + "&repositoryId=" + $("#repositoryId").val();
        var url = "/user/searchInstanceId/"+ searchId+ "?repositoryId=" + $("#repositoryId").val();
        procCallAjax('get', url, null, searchInstRepoUserIdCallBack);
    }

    function searchInstRepoUserIdCallBack(data) {
        var loginName = "<%=session.getAttribute("name")%>";
        $("#SrchPermissionUser").text(data.rtnList.length);
        if (data.rtnList == null || data.rtnList.length == 0) {
            var varHeadHtml = '<li>No users were viewed.</li>';
            $('#SrchPermissionUserList').append(varHeadHtml);
        } else {
            var rtnList = data.rtnList;
            for (var i = 0; i < rtnList.length; i++) {
                var varHeadHtml = '<li style="height: 25px; padding-left: 10px;"><span style="display:block; width: 300px;">' + rtnList[i].userId + '&nbsp;&nbsp;&nbsp;&nbsp';
                if(rtnList[i].userId!=loginName) {
                    if (rtnList[i].userPermissionNo != "") {
                        varHeadHtml = varHeadHtml + '<button  type="button" class="btn btn-default" onclick="deletePermission(\'' + rtnList[i].userPermissionNo + '\')\">'
                            + '<span class="glyphicon glyphicon-minus"></span></button>';
                    } else {
                        varHeadHtml = varHeadHtml + '<button  type="button" class="btn btn-default" '
                            + 'onclick=\"insertPermission(\'' + rtnList[i].userId + '\',\'' + rtnList[i].userName + '\',\'' + rtnList[i].userEmail + '\')\">'
                            + '<span class="glyphicon glyphicon-plus"></span></button>';
                    }
                }else{

                }
                varHeadHtml = varHeadHtml + '</span></li>';
                $('#SrchPermissionUserList').append(varHeadHtml);
            }
        }
        $("#SrchPermissionUserList").show();
        callBackInitalInvitePermissionForm();
    }

    $("#buttonCreateOnclick3").text("addition");
    $("#buttonCreateOnclick3").click(function (event) {
    //function inviteUser() {
        var url = "/user/permission/"+$("#repositoryId").val();
        var st = $(":input:radio[name=type]:checked").val();
        var param = { userId: $("#insertId").text(),
                      permission: st,
                      description : document.getElementById('PemissionName').value
                    };
        procCallAjax('put', url, param, invitePermissionCallback);
    });

    function invitePermissionCallback(data) {
        if(data.status==200){
            procPopupAlert($("#insertId").text()+" A participant has been added.",'putPermissionCancel()','return');
         }
    }

    function deletePermission(no) {
        var url = "/user/permission/"+no;
        procCallAjax('delete', url, null, deletePermissionCallback);
    }

    var insertPermission = function (id, name, email) {
        $("#insertId").text(id);
        $("#insertName").text(name);
        $("#insertEmail").text(email);
        $('#tbl_form02').show();
        $('#tbl_form03').show();
        $("#SrchPermissionUserList").hide();
        $("#SrchPermissionUserList").parent().removeClass("active");
        $("#SrchPermissionUserList").parent().addClass("active");
        return false;
    };

    function putPermissionCancel() {
        $('#permissionCreate').css('display', 'none');
        $('#tabPermissionlist').css('display', 'block');
        //참여자 추가 검색한 결과 삭제
        initalInvitePermissionForm();
        searchPermissions();
    }
    function deletePermissionCallback(data) {
        popupAlertClick("A participant has been deleted.");
        initalInvitePermissionForm();
        putPermissionCancel();

    }

    function callBackInitalInvitePermissionForm(){
        $('#tbl_form02').hide();
        $('#tbl_form03').hide();
        $("#searchInstRepoUserId").val("");
    }

    function initalInvitePermissionForm(){
        callBackInitalInvitePermissionForm();
        $("#permissionsList").children().remove();
        $("#PemissionName").text('');
        $('#SrchPermissionUserList').children().remove();
        $("#SrchPermissionUser").text(0);
    }

</script>
<!--//select 스크립트-->

