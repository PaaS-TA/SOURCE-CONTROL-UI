<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
<div id="wrap">
    <div id="container">
        <form name='login' action="<c:url value='/login' />" method='POST'>
        <!-- login :s -->
        <div id="loginWrap" class="loginbox" style="margin-top: 10%;">
            <div class="header">
                <h1>LOGIN</h1>
            </div>
            <div class="input_wrap clear_fix">
                <div class="input_inner">
                    <p><label for="username" class="hidden">아이디입력</label><input type="text" name="username" id="username" class="txt_id" value="${username}"  placeholder="아이디"></p>
                    <p><label for="password" class="hidden">비밀번호입력</label><input type="password" name="password" id="password" class="txt_pw" value="${password}" placeholder="비밀번호"></p>
                </div>
                <p class="login_inner">
                    <span class="save_id">
                        <input type="checkbox" name="remember_id" id="remember_id" value="" onclick="confirmSave(this)">
                        <label for="remember_id">아이디 저장하기</label>
                    </span>
                </p>
                <button type="submit" class="btn_login">로그인</button>
                <c:if test="${not empty error}">
                    <div><span class="alert-danger">로그인에 실패하였습니다(${error})</span></div>
                </c:if>
                <c:if test="${empty error}">
                    <div>&nbsp;</div>
                </c:if>
            </div>
        </div>
        </form>
    </div>
</div>
</body>
</html>

<script>
    $(document).ready(function () {
        $('#username').focus();
        $('#modal').hide();
        getLogin();
    });
    var confirmSave=function(checkbox){
        if(checkbox.checked) {
            isRemember = confirm("이 PC에 아이디 정보를 저장하시겠습니까? ");
            if(!isRemember)
                checkbox.checked = false;
        }
        saveLogin(checkbox);
    };
    //쿠키에 저장하기, 삭제하기

    function setCookie( name, expiredays ) {
        var todayDate = new Date();
        todayDate.setDate( todayDate.getDate() + expiredays );
        document.cookie = name + "=" + $("#username").val() + "; path=/; expires=" + todayDate.toGMTString() + ";"
    }

    //쿠키값 가져오기
    function getCookie(key) {
        var cook	= document.cookie + ";";
        var idx		= cook.indexOf(key,0);
        var val		= "";
        if(idx != -1) {
            cook	= cook.substring(idx, cook.length);
            begin	= cook.indexOf("=",0) + 1;
            end		= cook.indexOf(";",begin);
            val		= unescape(cook.substring(begin, end));
        }
        return val;
    }
    //쿠키에 로그인 정보 저장
    function saveLogin(id) {
        if(id.checked) {
            setCookie("username",7);
        } else {
            setCookie("username",-1);
        }
    }
    //쿠키에서 로그인 정보가져오기
    function getLogin() {
        //userid 쿠키에서 id값을 가져온다.
        var id		= getCookie("username");
        //가져온 쿠키값이 있으면
        if(id != "") {
            $("#username").val(id);
            $("input[name=remember_id]:checkbox").prop("checked", "checked");
        }
    }
</script>
