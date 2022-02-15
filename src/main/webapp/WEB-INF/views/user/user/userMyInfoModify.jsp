<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- contaniner :s -->
<div id="container">
    <!-- location :s -->
    <div class="location">
        <ul>
            <li><a href="javascript:moveHome()" class="home">Home</a></li>
            <li><a href="javascript:moveHome()" title="Edit My Information">Edit my information</a></li><!--마지막 경로-->
        </ul>
    </div>
    <!--//location :e -->
    <!-- contents :s -->
    <%--<c:if test="${status==200}">--%>
    <div class="contents">
        <%--<c:out value='${message}' default='' /><br>--%>
        <%--<input type="hidden" id="name" value="${ScUser.userId}">--%>
        <input type="hidden" id="admin" value="${rtnUser.admin}">
        <input type="hidden" id="active" value="${rtnUser.active}">
        <input type="hidden" id="type" value="${rtnUser.type}">
        <!-- Form 테이블 :s -->
        <table summary="This is a table for editing my information such as ID, name, email, password, and password confirmation." class="tbl_form02">
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
                    <th>Name</th>
                    <td><input type="text" id="modifyDisplayName" name="modifyDisplayName" value="${ScUser.userName}" placeholder="2 or more characters">
                        <p class="desc"id="NameAlertCheck">Please enter your name with at least 2 characters.</p><!--경고 메시지-->
                    </td>
                </tr>
                <tr>
                    <th>Email</th>
                    <td><input type="text" name="mail" id="mail" value="${ScUser.userMail}"  placeholder="(Example)paasta@nia.or.kr">
                        <p class="desc" style="color:#fb5666;" id="emailNotConfirmedAlert">* Email address format is incorrect.</p></td>
                </tr>
                <tr>
                    <th>Password (<span class="essential">*Required</span>)</th>
                    <td><input type="password" name="password1" value="__dummypassword__" placeholder="8 to 16 characters" id="newPasswordInput">
                        <p class="desc">Please enter a password of 6 to 16 characters.</p><!--경고 메시지-->
                    </td>
                </tr>
                <tr>
                    <th>Confirm password (<span class="essential">*Required</span>)</th>
                    <td><input type="password" name="password2" value="__dummypassword__" placeholder="Confirm password" id="confirmPasswordInput">
                        <p class="desc" id="passwordNotConfirmedAlert" >* Passwords do not match.</p>
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
            <jsp:include page="../common/buttonCreateOnclick.jsp"></jsp:include>
            <button type="button" class="button btn_cancel" title="cancel" onclick="history.go(-1)">Cancel</button>
        </div>
        <!--//기본버튼 :e -->
    </div>
    <!--//contents :e -->
    <%--</c:if>--%>
</div>
<input type="hidden" name="description" id="description" colos="20" rows="5"  placeholder="User description entered" value =${ScUser.userDesc}></input>
<script>
    //validation_check
    $(document).ready(function () {

        //[1-1]modifyDisplayName check
        $("#modifyDisplayName").keyup(function () {
            var createRepositoryName = $("#modifyDisplayName").val();
            if(!validUserName(createRepositoryName)){
                $("#NameAlertCheck").show();
            }else{
                $("#NameAlertCheck").hide();
            }
        });

        password_validation_check($("#confirmPasswordInput").val());

        //After, Validation_check
        checkEmail($("#mail"));

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

        // BIND
        $("#buttonCreateOnclick").text("edit");
        $("#buttonCreateOnclick").click(function (event) {
            if(checkEmail($("#mail"))) {
                popupAlertClick("Email address format is incorrect.");
                return;
            }
            if(!password_validation_check($("#confirmPasswordInput").val())){
                popupAlertClick("Please check your password.");
                return;
            }
            popupConfirmClick("Edit user information", "Are you sure you want to edit " + name +" 's information?",'modify()',"Change");
        });
    });

    //[1-2]email validation_check
        function validEmail(email) {
        if(email==null || email =="") return false;
        var r = new RegExp ("^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$");
            return (email.match(r) == null) ? true : false;
         }

        function checkEmail(email){
            var emailNotConfirmedAlert = $("#emailNotConfirmedAlert");
            validEmail(email.val()) ? emailNotConfirmedAlert.show() : emailNotConfirmedAlert.hide();
            return validEmail(email.val());
        }

    //[1-3]password validation_check
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

    // BIND
    var modify = function () {
        var url = "/user/userMyInfoModify/"+name+".json";
     //   {"name":"ijlee@bluedigm.com","displayName":"test123","mail":"test2@aaa.aa.aa","admin":false,"active":true,"type":"xml","password":"1234556"}
        var param =  {
                        "name":name
                        ,"displayName":$("#modifyDisplayName").val()
                        ,"mail":$("#mail").val()
                        ,"admin":$("#admin").val()
                        ,"active":$("#active").val()
                        ,"type":$("#type").val()
                        ,"password":$("#confirmPasswordInput").val()
                        ,"desc":$("#description").val()
                        };
        procCallAjax('put', url, param, modifyCallback);
    };

    function modifyCallback(data){
       popupAlertClick("Editing is complete.");
       history.go(-1);
    }

</script>
<!--//select 스크립트-->
