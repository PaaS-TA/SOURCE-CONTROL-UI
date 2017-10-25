<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/xml" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- Form 테이블 :s -->
<table summary="사용자초대 검색 테이블입니다." class="tbl_form02">
    <caption>
        사용자초대 검색
    </caption>
    <colgroup>
        <col style="width: *"/>
    </colgroup>
    <tbody>
    <tr>
        <th class="f_title">소스컨트롤러 사용자 검색</th>
    </tr>
    <tr>
        <td><input type="text" name="" placeholder="참여자 검색" style="width:59%;"></td>
    </tr>
    </tbody>
</table>
<form id="formInviteUser" method="put" action="/user/permission/${repositorydetails.id}">

    <table summary="참여자생성 입력 테이블입니다." class="tbl_form02">
        <caption>
            참여자추가
        </caption>
        <colgroup>
            <col style="width: 18%"/>
            <col style="width: *"/>
        </colgroup>
        <tbody>
        <tr>
            <th colspan="2" class="f_title">참여자 초대</th>
        </tr>
        <tr>
            <th>아이디 (<span class="essential">*필수</span>)</th>
            <td>
                <input type="text" id ="name" name="name" value="" placeholder="영문소문자, 숫자, 2자리이상" pattern="^[a-zA-Z0-9-]*$">
                <p class="desc" id="nameNotConfirmedAlert" style="color:#fb5666; ;">* 영문소문자, 숫자 2~12자로 입력해주시기 바랍니다.</p>
            </td>
        </tr>
        <tr>
            <th>이름<%-- (<span class="essential">*필수</span>)--%></th>
            <td><input type="text" name="displayName" value="" <%--placeholder="2자리 이상 입력"--%>>
                <%--<p class="desc">* 이름은 2자 이상으로 입력해 주시기 바랍니다.</p>--%>
            </td>
        </tr>
        <tr>
            <th>이메일</th>
            <td>
                <input type="email" name="mail" id="email" value="paasta@nia.or.kr" placeholder="(예) paasta@nia.or.kr" required="required"
                       pattern="^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$">
                <p class="desc" style="color:#fb5666;" id="emailNotConfirmedAlert">* 이메일 주소 형식이 올바르지 않습니다.</p>
            </td>
        </tr>
        <tr>
            <th>비밀번호 (<span class="essential">*필수</span>)</th>
            <td><input type="password" name="password" value="123456" placeholder="6자리 ~ 16자리" id="newPasswordInput">
                <p class="desc" style="color:#fb5666;">* 비밀번호는 6~16자로 입력해 주시기 바랍니다.</p>
            </td>
        </tr>
        <tr>
            <th>비밀번호 확인 (<span class="essential">*필수</span>)</th>
            <td><input type="password" name="password" value="123456" placeholder="비밀번호 다시 입력" id="confirmPasswordInput">
                <p class="desc" id="passwordNotConfirmedAlert" style="color:#fb5666; ;">* 비밀번호가 일치하지 않습니다.</p>
            </td>
        </tr>
        </tbody>
    </table>
    <!--//Form 테이블 :e -->
    <!-- 공통 Form 테이블 :s -->
    <table summary="사용여부, 설명 등의 참여자추가 선택 테이블입니다." class="tbl_form">
        <caption>
            참여자 추가 사용여부 선택 테이블
        </caption>
        <colgroup>
            <col style="width: 18%"/>
            <col style="width: *"/>
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
            <th class="last">설명 (선택)</th>
            <td>
                <textarea type="text" colos="20" rows="5" ></textarea><br>
                *사용자 정보에 보여지는 설명
            </td>
        </tr>
        </tbody>
    </table>
</form>
<!--//공통 Form 테이블 :e -->
<!--기본버튼(Right 정렬) :s -->
<div class="fr">
    <button type="button" class="button btn_default" title="초대" onclick='inviteUser();'>초대</button>
    <button type="button" class="button btn_cancel" title="취소" onclick="putPermissionCancel();">취소</button>
</div>

<!--//기본버튼(Right 정렬) :e -->
<!-- togglemenu -->
<script type="text/javascript">
    $(document).ready(function () {
        password_validation_check($("#confirmPasswordInput").val());
        name_validation_check();
        checkEmail($("#email"));
        $("#name").keyup(function () {
            name_validation_check();
        });
        $("#confirmPasswordInput").keyup(function () {
            password_validation_check($(this).val());
        });
        $("#newPasswordInput").keyup(function () {
            password_validation_check($("#confirmPasswordInput").val());
        });
        $("#email").keyup(function () {
            checkEmail($("#email"));
        });

    });
    function searchId() {
        var url = "/user/permissions/" + $("#repositoryId").val();
        var param1 = $("#permissionSelect1").text();
        var param2 = $("#permissionSelect2").text();
        var param = "?page=" + page + "&size=" + size + "&type1=" + param1 + "&type2=" + param2 + "&searchUserName=" + $("#search_keyword2").val();
        url = url + param;
        procCallAjax('get', url, param, permissionCallback);
    }

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

    function name_validation_check() {
        var result = true;

        var nameNotConfirmedAlert = $("#nameNotConfirmedAlert");
        var name = $("#name").val();
//        var r = new RegExp("[a-zA-Z0-9]");
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

    //BIND
    function inviteUser(){
        if(!password_validation_check($("#confirmPasswordInput").val())){
            //alert("패스워드를 확인하세요.");
            popupAlertClick("패스워드를 확인하세요.");
            return;
        }
        if(!name_validation_check()){
            //alert("형식에 맞는 아이디를 사용하세요.");
            popupAlertClick("형식에 맞는 아이디를 사용하세요.");
            return;
        }
        if(checkEmail($("#email"))){
            //alert("형식에 맞는 이메일을 사용하세요.");
            popupAlertClick("형식에 맞는 이메일을 사용하세요.");
        } return;
        var user= "";
        var url = "/user/permission/" + $("#repositoryId").val();
        //alert($("#password").getAttribute("readonly"));
        popupAlertClickt($("#password").getAttribute("readonly"));
        var param = {
            "user":user,
            "name":$("#name").val(),
            "type":$("#type").val(),
            "groupPermission":false

        };
//        procCallAjax('put', url, param, invitePermissionCallback);
        //$("#formInviteUser").submit();
    }

    function invitePermissionCallback(data){
        //alert(data);
        popupAlertClick(data);
    }

    function putPermissionCancel(){
        $('#permissionCreate').css('display', 'none');
        $('#tabPermissionlist').css('display', 'block');
        searchPermissions();
    }

</script>
<!--//select 스크립트-->
