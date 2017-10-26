<!--
=================================================================
* 시 스 템 명 : 소스컨트롤러 웹 UI
* 업 무 명 : 참여자 상세
* 프로그램명 : detailPermission.jsp(참여자 상세 삭제)
* 프로그램 개요 : 참여자 추가 화면
* 작 성 자 : 이인정
* 작 성 일 : 2017.07.10
* 화면 ID: UI-SBSC-6300
* 화면설계 ID: UI-SBSC-6300
=================================================================
수정자 / 수정일 :
수정사유 / 내역 :
=================================================================
-->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Form 테이블 :s -->
<table summary="아이디, 이름, 이메일 등의 참여자정보 상세내용 테이블입니다." class="tbl_form02">
    <caption>
        참여자관리 참여자 상세/수정
    </caption>
    <colgroup>
        <col style="width: 18%">
    </colgroup>
    <tbody>
    <tr>
        <th class="f_title">참여자 정보</th>
    </tr>
    <tr class=""><!--사용자검색 상세내용-->
        <td class="controlbox">
            <dl>
                <input type="hidden" id="viewUser">
                <dd><span class="sm_tit">아이디 :</span><span id="viewId" name="viewId"></span><br></dd>
                <dd><span class="sm_tit">이름 :</span><span id="viewName" name="viewName"></span><br></dd>
                <dd><span class="sm_tit">이메일 :</span><span id="viewEmail" name="viewEmail"></span><br></dd>
            </dl>
        </td>
    </tr>
</tbody>
</table>
<!--//Form 테이블 :e -->
<!-- 공통 Form 테이블 :s -->
<table summary="권한(필수), 사용여부(필수), 설명 등의 참여자 상세/수정 테이블입니다." class="tbl_form">
    <caption>
        참여자관리 참여자 상세/수정
    </caption>
    <colgroup>
        <col style="width: 18%">
        <col style="width: *">
    </colgroup>
    <tbody>
    <tr>
        <th>권한 (<span class="essential">*필수</span>)</th>
        <td>
            <label>
                <input type="radio" name="type" value="WRITE" checked="checked">쓰기권한
                <input type="radio" name="type" value="READ">보기권한
            </label>
        </td>
    </tr>
    <tr>
    <tr>
        <th class="last">설명 (선택)</th>
        <td>
            <textarea type="text" colos="20" rows="5" id ="userPermissionName"placeholder=""></textarea>
        </td>
    </tr>
    </tbody>
</table>
<!--//공통 Form 테이블 :e -->
<!--기본버튼(Right 정렬) :s -->
<div class="fl">
    <button type="button" class="button btn_default" id="btnDPDelete" name="btnDPDelete" title="참여자 삭제">참여자 삭제</button>
</div>
<div class="fr">
    <jsp:include page="../common/buttonCreateOnclick2.jsp"></jsp:include>
    <button type="button" class="button btn_cancel" title="취소"  onclick="putPermissionCancel()">취소</button>
</div>
<!--//기본버튼(Right 정렬) :e -->
<script type="text/javascript">

    //GET data
    function detailInformation(data,param) {
        $("#viewId").html(data.ScUser.userId);
        $("#viewName").html(data.ScUser.userName);
        $("#viewEmail").html(data.ScUser.userMail);
    }

    //BIND :: buttonCreateOnclick[DELETE]
    $("#btnDPDelete").on("click", function() {
        popupConfirmClick("삭제","참여자 정보를 삭제 하시겠습니까?", "userDetailUpdateDelete()","삭제");
    });

    var userDetailUpdateDelete = function (no) {
        var url = "/user/permission/" + $("#viewUser").val();
        procCallAjax('delete', url, null, userDetailUpdateDeleteCallback);
    };

    function userDetailUpdateDeleteCallback() {
       procPopupAlert("참여자 삭제가 완료되었습니다.",'$("#permissionList").submit()','return;');
    }

    //BIND :: buttonCreateOnclick[UPDATAE]
    $("#buttonCreateOnclick2").text("수정");
    $("#buttonCreateOnclick2").click(function (event) {
        popupConfirmClick("수정","참여자 정보를 수정 하시겠습니까?", 'userDetailUpdate()',"수정");
    });

    var userDetailUpdate = function () {
        var url = "/user/permission/"+$("#viewId").val();
        var st = $(":input:radio[name=type]:checked").val();
        var param = {
             "userId":$("#viewId").val()
            ,"userName":$("#viewName").val()
            ,"userMail":$("#viewEmail").val()
            ,"permission": st
            ,"description" :$("#userPermissionName").val()
        };
;        procCallAjax('put', url, param, userDetailUpdateCallback);
        console.log("::::Confirm::::" +JSON.stringify(param));
    }

    function userDetailUpdateCallback(data) {
        if(data.status==200){
            procPopupAlert($("#viewId").html()+"사용자 수정이 완료되었습니다.",'putPermissionCancel()','return');
        }
    }

    //BIND
    function putPermissionCancel(){
        $('#permissionCreate').css('display', 'none');
        $('#permissionUpdate').css('display', 'none');
        $('#tabPermissionlist').css('display', 'block');
    }

</script>
<!--//select 스크립트-->

