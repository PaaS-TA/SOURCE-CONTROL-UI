<!--
=================================================================
* 시 스 템 명 : 사용자 패스워드 수정 웹 UI
* 업 무 명 : 사용자 패스워드 수정
* 프로그램명 user/permissionCreate.jsp(참여자 목록 리스트)
* 프로그램 개요 : 참여자 목록 리스트 화면
* 작 성 자 : 이인정
* 작 성 일 : 2018.07.10
* 화면 ID: UI-FDSC-8000
* 화면설계 ID: UI-SBSC-8200
=================================================================
수정자 / 수정일 :
수정사유 / 내역 :
=================================================================
-->

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!-- contaniner :s -->
<div id="container">
    <!-- login :s -->
    <div id="loginWrap" class="loginbox" style="margin-top: 10%;">
        <div class="header">
            <h2>비밀번호 입력<p>형상관리서비스를 위해 최초 비밀번호를 입력해 주시기 바랍니다.</p></h2>
        </div>
        <div class="input_wrap clear_fix">
            <div class="input_inner">
                <div>
                    <input type="password" name="password1" value="" placeholder="6자리 ~ 16자리" id="newPasswordInput">
                    <p class="desc" style="margin-left:20px;text-align:left;color:#fb5666;">* 비밀번호는 6~16자로 입력해 주시기 바랍니다.</p>
                </div>
                <br>
                <div>
                    <input type="password" name="password2" value="" placeholder="비밀번호 다시 입력" id="confirmPasswordInput">
                    <p class="desc" id="passwordNotConfirmedAlert" style="margin-left:20px;text-align:left;color:#fb5666;">* 비밀번호가 일치하지 않습니다.</p>
                </div>
            </div>
            <button type="submit" class="btn_login" id="btn_login">확인</button>
            <c:if test="${not empty error}">
                <span class="alert-danger"> 비밀번호가 일치하지 않습니다.</span>
            </c:if>
        </div>
    </div>
    <!--//login :e -->
</div>
<form name ="repoList" id ="repoList"  action = "/user/repository/" method="get"></form>
<!--//contaniner :e -->
<script>
    //[1-2]password validation_check
    function password_validation_check(confimPassword) {
        var result = true;

        var passwordNotConfirmedAlert = $("#passwordNotConfirmedAlert");

        if (confimPassword === "" || confimPassword === null || confimPassword !== $("#newPasswordInput").val()) {
            result = false;
            passwordNotConfirmedAlert.show();
        } else {
            result = true;
            passwordNotConfirmedAlert.hide();
        }

        return result;
    }
    $(document).ready(function () {
        var passwordNotConfirmedAlert = $("#passwordNotConfirmedAlert");
        passwordNotConfirmedAlert.hide();

        $("#confirmPasswordInput").keyup(function () {
            password_validation_check($(this).val());
        });
        $("#newPasswordInput").keyup(function () {
            password_validation_check($("#confirmPasswordInput").val());
        });

        $("#btn_login").click(function () {

            if(password_validation_check($("#confirmPasswordInput").val())){
                popupConfirmClick("비밀번호 최초등록","비밀번호를 등록하시겠습니까?",'modify()',"등록");
            }
        });
    });
    // BIND
    var modify = function () {

        var url = "/user/userMyInfoModify/"+name+".json";
        var param =  {
            "name":"${rtnUser.name}"
            ,"displayName":"${rtnUser.displayName}"
            ,"mail":"${rtnUser.displayName}"
            ,"admin":"${rtnUser.admin}"
            ,"active":"true"
            ,"type":"${rtnUser.type}"
            ,"password":$("#confirmPasswordInput").val()
            ,"PasswordSet":"true"
        };
        procCallAjax('put', url, param, modifyCallback);
    };

    var modifyCallback = function () {
        popupAlertClick("수정이 완료되었습니다.");
        $("#repoList").submit();
    }
</script>