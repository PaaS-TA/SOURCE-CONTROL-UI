<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- contaniner :s -->
<div id="container">
    <!-- location :s -->
    <div class="location">
        <ul>
            <li><a href="javascript:moveHome()" class="home">Home</a></li>
            <li><a href="/user/permissionList/" title="user list">user list</a></li><!--마지막 경로-->
            <li><a href="#" title="User Details/Edit/Delete">사용자 상세/수정/삭제</a></li><!--마지막 경로-->
        </ul>
    </div>
    <!--//location :e -->
    <!-- contents :s -->
    <%--<c:if test="${status==200}">--%>
    <div class="contents">
        <%--<c:out value='${message}' default='' /><br>--%>
        <%--<input type="hidden" id="name" value="${ScUser.userId}">--%>
        <input type="hidden" id="admin" value="${rtnUser.admin}">
        <input type="hidden" id="type" value="${rtnUser.type}">
        <!-- Form 테이블 :s -->
        <table summary="This is a user detail/edit table for ID, name, email, password, and password confirmation." class="tbl_form02">
            <caption>
                User detail/edit table
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
                    <td><input type="password" name="password1" value="__dummypassword__" placeholder="6 to 16 characters" id="newPasswordInput">
                        <p class="desc">Please enter a password of 6 to 16 characters.</p><!--경고 메시지-->
                    </td>
                </tr>
                <tr>
                    <th>Confirm password (<span class="essential">*Required</span>)</th>
                    <td><input type="password" name="password2" value="__dummypassword__" placeholder="Confirm password" id="confirmPasswordInput">
                        <p class="desc" id="passwordNotConfirmedAlert" style="color:#fb5666; ;">* Passwords do not match.</p>
                    </td>
                </tr>
                <tr>
                    <th colspan="2"><span class="point01">※ Please enter the password only when changing the password.</span></th>
                </tr>
            </tbody>
        </table>
        <!--//Form 테이블 :e -->
        <table summary="This is an optional user-added table including user status and description." class="tbl_form">
            <caption>
                Selection table on whether to use additional user
            </caption>
            <colgroup>
                <col style="width: 18%" />
                <col style="width: *" />
            </colgroup>
            <tbody>
            <tr>
                <th>User status (<span class="essential">*Required</span>)</th>
                <td>
                    <label><input type="radio" name="active" value="true" <c:if test="${rtnUser.active==true}">checked="checked"</c:if>>use</label>
                    <label><input type="radio" name="active" value="false" <c:if test="${rtnUser.active==false}">checked="checked"</c:if>>stop</label>
                </td>
            </tr>
            <tr>
                <th class="last">Description (<span class="f12">Optional</span>)</th>
                <td>
                    <%--<textarea type="text" name ="description"   colos="20" rows="5" onfocus="resize(this);">${ScUser.userDesc}</textarea>--%>
                    <textarea type="text" name="description" id="description" colos="20" rows="5"  placeholder="User description entered">${ScUser.userDesc}</textarea>
                </td>
            </tr>
            </tbody>
        </table>
        <!--기본버튼 :s -->
        <div class="fl">
            <jsp:include page="../common/buttonCreateOnclick.jsp"></jsp:include>
        </div>
        <div class="fr">
            <jsp:include page="../common/buttonCreateOnclick2.jsp"></jsp:include>
            <button type="button" class="button btn_cancel" title="cancel"  onclick=" history.go(-1);">cancel</button>
        </div>
        <!--//기본버튼 :e -->
    </div>
    <!--//contents :e -->
    <%--</c:if>--%>
</div>
<form name ="permissionList" id ="permissionList"  action = "/user/permissionList/" method="get"></form>
<!--//contaniner :e -->
<!-- Top 가기 :s -->
<div class="follow" title="Scroll Back to Top">
	<a href="#" title="top"><img src="/resources/images/a_top.gif"></a>
</div>
<!--//Top 가기 :e -->
<script>
    //validation_check
    $(document).ready(function () {

        //modifyDisplayName null check
        $("#modifyDisplayName").keyup(function () {
            var createRepositoryName = $("#modifyDisplayName").val();
            if(!validUserName(createRepositoryName)){
                $("#NameAlertCheck").show();
            }else{
                $("#NameAlertCheck").hide();
            }
        });

        password_validation_check($("#confirmPasswordInput").val());

        //after check
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
        $("#buttonCreateOnclick").text("delete user");
        $("#buttonCreateOnclick").click(function (event) {
            //$("#btnMDelete").on("click", function() {
            popupConfirmClick("delete user","Are you sure you want to delete the user?", 'deleteInstanceUserModify()',"delete user");
        });
        $("#buttonCreateOnclick2").text("edit user ");
        $("#buttonCreateOnclick2").click(function (event) {
            popupConfirmClick("edit user ","Would you like to edit user information?", 'modify()',"edit user ");
        });
    });


    //[1-1]email validation_check
        function validEmail(email) {
            if(email==null || email =="") return false;
            var r = new RegExp ("^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$");
//            var r = new RegExp("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
            return (email.match(r) == null) ? true : false;
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

        if (confimPassword != $("#newPasswordInput").val()) {
            result = false;
            passwordNotConfirmedAlert.show();
        } else {
            result = true;
            passwordNotConfirmedAlert.hide();
        }

        return result;
    }

    var modify = function () {

        if(checkEmail($("#mail"))){
            popupAlertClick("Email address format is incorrect.");
            return;
        }
        if(!password_validation_check($("#confirmPasswordInput").val())){
            popupAlertClick("Please check your password.");
            return;
        }


        var url = "/user/instanceModifyUser.do";
     //   {"name":"ijlee@bluedigm.com","displayName":"test123","mail":"test2@aaa.aa.aa","admin":false,"active":true,"type":"xml","password":"1234556"}
        var param =  {
                        "name":"${ScUser.userId}"
                        ,"displayName":$("#modifyDisplayName").val()
                        ,"mail":$("#mail").val()
                        ,"admin":$("#admin").val()
                        ,"active":$(":input:radio[name=active]:checked").val()
                        ,"type":$("#type").val()
//                        ,"password":$("#password2").val()
                        ,"password":$("#confirmPasswordInput").val()
                        ,"desc":$("#description").val()
                        };
        procCallAjax('put', url, param, modifyCallback);
    };


    function modifyCallback(data){
      procPopupAlert("User editing is complete.",'$("#permissionList").submit()','return;');
    }

    // DELETE
    var deleteInstanceUserModify = function() {
        var url = "/user/instanceUserDelete.do/${ScUser.userId}";
        procCallAjax('delete', url, null, callbackDeleteInstanceUserModify);
    };

    // CALLBACK
    var callbackDeleteInstanceUserModify = function(data) {
        procPopupAlert("User deletion complete.",'$("#permissionList").submit()','return;');
    };


</script>
<!--//select 스크립트-->



