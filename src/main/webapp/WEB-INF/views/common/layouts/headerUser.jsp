<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<ul class="nav_ibtn">
    <li><a href="#" class="wintoggle"><%=session.getAttribute("name")%><b class="nav_arrow"></b></a>
        <ul class="togglemenu" style="width:125px;">
            <li><a href="/user/userMyInfoModify">My information management</a></li>
            <sec:authorize access="hasRole('ROLE_CREATE_Y')">
            <li><a href="/user/permissionList/">User Management</a></li>
            </sec:authorize>
        </ul>
    </li>
</ul>

<!-- togglemenu 스크립트 -->
<script>
    //validation_check
    $(document).ready(function () {
//        password_validation_check($("#confirmPasswordInput").val());
        $("#name").keyup(function () {
            $("#nameCheck").show();
            name_validation_check();
        });

        $("#user_email").keyup(function () {
            $("#user_emailCheck").show();
            checkEmail($("#user_email"));
        });

        $("#UserNameCreateSucess").hide();
        //사용자 추가 메뉴 삭제
        $("#userCreateHeader").hide();
    });


    //[1-1]name
    function name_validation_check() {
        var result = true;

        var nameNotConfirmedAlert = $("#nameCheck");
        var name = $("#name").val();
        var r = new RegExp("^[a-zA-Z0-9-]*$");

        if (name.length > 2 && r.test(name)) {
            result = true;
            nameNotConfirmedAlert.hide();
        } else {
            result = false;
            nameNotConfirmedAlert.show();
        }
        return result;
    }


    //[1-2]email
    function checkEmail(email){
        var emailNotConfirmedAlert = $("#user_emailCheck");
        validEmail(email.val()) ? emailNotConfirmedAlert.show() : emailNotConfirmedAlert.hide();
        return validEmail(email.val());
    }

    function validEmail(email) {
        var r = new RegExp ("^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$");
        var r = new RegExp("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
        return (email.match(r) == null) ? true : false;
    }

    //addUser
    var addUser = function () {
        console.log("::[1]addUser consle::");
        //user_pwConfirm

        var url = "/user/addUser.do";
        var reqParam = {
            name: document.getElementById('name').value,
            displayName : document.getElementById('displayName').value,
            mail: document.getElementById('user_email').value,
            password: document.getElementById('user_pw').value
        };
        //alert(JSON.stringify(reqParam));
        console.log("::[1-1]reqParam consle::");
        procCallAjax("post", url, reqParam, addUserCallBack);
        console.log("::[1-2]addUser consle End::");

    };


    //CALLBACK
    var addUserCallBack = function (data) {
        if(data.error !=null){
            alert(data.error);
            return;
        }
        console.log("::[2]Callback addUser::");

        if(data.rtnUser.name!=null){
            popupAlertClick("User addition is complete.");

            var insertName = data.rtnUser.name;
            console.log("::innerHTML = " + insertName);
            $('#UserNameCreateSucess').innerHTML = insertName;

            console.log("data"+insertName);

        }else{
            popupAlertClick("Failed to add user.");
        }
    };


    // BIND
    $("#btnUCreate").on("click", function () {
        var validation_pw = /^.*(?=.{6,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
        if (document.getElementById('user_pw').value == null || validation_pw.test(document.getElementById('user_pw').value)) {
            popupAlertClick("Passwords do not match.");
            document.getElementById('user_pw').value = "";
            return;
        }
        else{
            addUser();
            popupAlertClick("User creation is complete.");
            $("#Insert_User_togglemenu").hide();
            //history.go(-1);
        }
        //location.reload();
        console.log("::[3]btnUCreate End::");
    });
    // BIND
    $("#btnUCancel").on("click", function () {
        if(confirm("Are you sure you want to cancel user creation?")){
            $("#Insert_User_togglemenu").hide();
        }else{
            return;
        }
        location.reload();
    });

</script>