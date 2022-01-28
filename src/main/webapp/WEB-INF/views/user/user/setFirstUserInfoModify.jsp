<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- contaniner :s -->
<div id="container">
    <!-- location :s -->
    <div class="location">
        <ul>
            <li><a href="/user/repository/${instanceId}?username=${name}" class="home">Home</a></li>
            <li><a href="#" title="Edit My Information">Information after entering password</a></li><!--마지막 경로-->
        </ul>
    </div>
    <!--//location :e -->
    <!-- contents :s -->
    <%--<c:if test="${status==200}">--%>
    <div class="contents">
        <c:out value='${message}' default='' /><br>
        <%--<input type="hidden" id="name" value="${ScUser.userId}">--%>
        <input type="hidden" id="admin" value="${rtnUser.admin}">
        <input type="hidden" id="active" value="${rtnUser.active}">
        <input type="hidden" id="type" value="${rtnUser.type}">
        <!-- Form 테이블 :s -->
        <table summary="This is a table for editing my information such as ID, name, email, password, and password confirmation." class="user_infobox">
            <caption>
			Edit My Information
            </caption>
            <colgroup>
                <col style="width: 18%" />
                <col style="width: *" />
            </colgroup>
            <tbody>
                <tr>
                    <th>ID</th>
                    <td>${ScUser.userId}</td>
                </tr>
                <tr>
                    <th>name</th>
                    <td><input type="text" id="modifyDisplayName" name="modifyDisplayName" value="${ScUser.userName}">
                    	<p class="desc">Please enter your name with at least 2 characters.</p><!--경고 메시지-->
                    </td>
                </tr>
                <tr>
                    <th>e-mail</th>
                    <td><input type="text" name="mail" id="mail" value="${ScUser.userMail}">
                    <p class="desc" style="color:#fb5666;" id="emailNotConfirmedAlert">* Email address format is incorrect.</p></td>
                </tr>
                <%--<tr>--%>
                    <%--<th>비밀번호</th>--%>
                    <%--<td><input type="password" id="modifypassword1"  value="${rtnUser.password}"></td>--%>
                <%--</tr>--%>
                <%--<tr>--%>
                    <%--<th>비밀번호 확인</th>--%>
                    <%--<td><input type="password" id="modifypassword2" value="${rtnUser.password}">--%>
                    <%--</td>--%>
                <%--</tr>--%>
                <tr>
                    <th>Password (<span class="essential">*Required</span>)</th>
                    <td><input type="password" name="password" value="__dummypassword__" placeholder="6 to 16 characters" id="newPasswordInput">
                        <p class="desc" style="color:#fb5666;">* Please enter a password of 6 to 16 characters.</p>
                    </td>
                </tr>
                <tr>
                    <th>Confirm password (<span class="essential">*Required</span>)</th>
                    <td><input type="password" name="password" value="__dummypassword__" placeholder="Re-enter password" id="confirmPasswordInput">
                        <p class="desc" id="passwordNotConfirmedAlert" style="color:#fb5666; ;">* Passwords do not match.</p>
                    </td>
                </tr>
                <tr>
                    <th colspan="2"><span class="point01">※ Please enter the password only when changing the password.</span></th>
                </tr>
            </tbody>
        </table>
        <!--//Form 테이블 :e -->
        <!--기본버튼 :s -->
        <div class="fr">
            <button type="button" class="button btn_default" title="edit" onclick="modify()">edit</button>
            <button type="button" class="button btn_cancel" title="cancel" onclick="history.go(-1)">cancel</button>
        </div>
        <!--//기본버튼 :e -->
    </div>
    <!--//contents :e -->
    <%--</c:if>--%>
</div>
<!--//contaniner :e -->
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
<script src="http://code.jquery.com/jquery-2.2.1.min.js"></script>
<script>
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
</script>

<script>
    //validation_check
    $(document).ready(function () {
        password_validation_check($("#confirmPasswordInput").val());

        $("#mail").keyup(function () {
            $("#emailNotConfirmedAlert").show();
            checkEmail($("#mail"));
        });
        $("#confirmPasswordInput").keyup(function () {
            password_validation_check($(this).val());
        });
        $("#newPasswordInput").keyup(function () {
            password_validation_check($("#confirmPasswordInput").val());
        });
    });


    //[1-1]email validation_check
        function validEmail(email) {
    //        var r = new RegExp ("^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$");
            var r = new RegExp("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
            return (email.match(r) === null) ? true : false;
        }

        function checkEmail(email){
            var emailNotConfirmedAlert = $("#emailNotConfirmedAlert");
            validEmail(email.val()) ? emailNotConfirmedAlert.show() : emailNotConfirmedAlert.hide();
            return validEmail(email.val());
        }

    //[1-2]password validation_check
    function password_validation_check(confimPassword) {
        var result = true;

        var passwordNotConfirmedAlert = $("#passwordNotConfirmedAlert");

        if (confimPassword !== $("#newPasswordInput").val()) {
            result = false;
            passwordNotConfirmedAlert.show();
        } else {
            result = true;
            passwordNotConfirmedAlert.hide();
        }

        return result;
    }

    var modify = function () {
        if(!confirm("Are you sure you want to edit?"))
            return;
        if(checkEmail($("#mail"))){
            popupAlertClick("Email address format is incorrect.");
            return;

        if(!password_validation_check($("#confirmPasswordInput").val())){
            //alert("패스워드를 확인하세요.");
            popupAlertClick("Please check your password.");
            return;
        }
     }

        var url = "/user/userMyInfoModify/"+name+".json";
     //   {"name":"ijlee@bluedigm.com","displayName":"test123","mail":"test2@aaa.aa.aa","admin":false,"active":true,"type":"xml","password":"1234556"}
        var param =  {
                        "name":name
                        ,"displayName":$("#modifyDisplayName").val()
                        ,"mail":$("#mail").val()
                        ,"admin":$("#admin").val()
                        ,"active":$("#active").val()
                        ,"type":$("#type").val()
                        ,"password":$("#password").val()
                        };
        procCallAjax('put', url, param, modifyCallback);
    };


    function modifyCallback(data){
        popupAlertClick("Editing is complete.");
        history.go(-1);
    }
</script>
<!--//select 스크립트-->