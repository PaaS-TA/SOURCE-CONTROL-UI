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
            <h2>Enter Password<p>Please enter the initial password for configuration management service.</p></h2>
        </div>
        <div class="input_wrap clear_fix">
            <div class="input_inner">
                <div>
                    <input type="password" name="password1" value="" placeholder="6 to 16 characters" id="newPasswordInput">
                    <p class="desc" style="margin-left:20px;text-align:left;color:#fb5666;">* Please enter a password of 6 to 16 characters.</p>
                </div>
                <br>
                <div>
                    <input type="password" name="password2" value="" placeholder="Re-enter password" id="confirmPasswordInput">
                    <p class="desc" id="passwordNotConfirmedAlert" style="margin-left:20px;text-align:left;color:#fb5666;">* Passwords do not match.</p>
                </div>
            </div>
            <button type="submit" class="btn_login" id="btn_login">Confirm</button>
            <c:if test="${not empty error}">
                <span class="alert-danger"> Passwords do not match.</span>
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

        if((6 > confimPassword.length) || (16 < confimPassword.length) ||confimPassword === "" || confimPassword === null || confimPassword !== $("#newPasswordInput").val()){
            result = false;
        }
        var passwordNotConfirmedAlert = $("#passwordNotConfirmedAlert");
        if(result){
            passwordNotConfirmedAlert.hide();
        } else {
            passwordNotConfirmedAlert.show();
        }
        return result;
    }
    $(document).ready(function () {
        var passwordNotConfirmedAlert = $("#passwordNotConfirmedAlert");
        passwordNotConfirmedAlert.hide();

        $("#confirmPasswordInput").keyup(function () {
            password_validation_check($(this).val());

        });
        $("#confirmPasswordInput").keyup(function (event) {
            if (event.which === 13) {
                popupConfirmClick("First time password registration","Would you like to register a password?",'modify()',"등록");
            }
        });

        $("#newPasswordInput").keyup(function () {
            password_validation_check($("#confirmPasswordInput").val());
        });


        $("#btn_login").click(function () {

            if(password_validation_check($("#confirmPasswordInput").val())){
                popupConfirmClick("First time password registration","Would you like to register a password?",'modify()',"등록");
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
        popupAlertClick("Editing is complete.");
        $("#repoList").submit();
    }
</script>