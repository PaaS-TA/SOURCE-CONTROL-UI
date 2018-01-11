<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- contaniner :s -->
<div id="container">
    <!-- location :s -->
    <div class="location">
        <ul>
            <li><a href=gohome class="home">홈으로</a></li>
            <li><a href="/user/permissionList/" title="사용자 목록">사용자 목록</a></li><!--마지막 경로-->
            <li><a href="#" title="사용자 상세/수정/삭제">사용자 상세/수정/삭제</a></li><!--마지막 경로-->
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
        <table summary="아이디, 이름, 이메일, 비밀번호, 비밀번호 확인 등의 사용자 상세/수정 테이블입니다." class="tbl_form02">
            <caption>
                사용자 상세/수정 테이블
            </caption>
            <colgroup>
                <col style="width: 18%" />
                <col style="width: *" />
            </colgroup>
            <tbody>
                <tr>
                    <th>아이디</th>
                    <td>${ScUser.userId}</td>
                </tr>
                <tr>
                    <th>이름</th>
                    <td><input type="text" id="modifyDisplayName" name="modifyDisplayName" value="${ScUser.userName}" placeholder="2자리 이상">
                        <p class="desc"id="NameAlertCheck">이름은 2자 이상으로 입력해 주시기 바랍니다.</p><!--경고 메시지-->
                    </td>
                </tr>
                <tr>
                    <th>이메일</th>
                    <td><input type="text" name="mail" id="mail" value="${ScUser.userMail}"  placeholder="(예)paasta@nia.or.kr">
                    <p class="desc" style="color:#fb5666;" id="emailNotConfirmedAlert">* 이메일 주소 형식이 올바르지 않습니다.</p></td>
                </tr>
                <tr>
                    <th>비밀번호 (<span class="essential">*필수</span>)</th>
                    <td><input type="password" name="password1" value="__dummypassword__" placeholder="6자리 ~ 16자리" id="newPasswordInput">
                        <p class="desc">비밀번호는 6~16자로 입력해 주시기 바랍니다.</p><!--경고 메시지-->
                    </td>
                </tr>
                <tr>
                    <th>비밀번호 확인 (<span class="essential">*필수</span>)</th>
                    <td><input type="password" name="password2" value="__dummypassword__" placeholder="비밀번호 확인" id="confirmPasswordInput">
                        <p class="desc" id="passwordNotConfirmedAlert" style="color:#fb5666; ;">* 비밀번호가 일치하지 않습니다.</p>
                    </td>
                </tr>
                <tr>
                    <th colspan="2"><span class="point01">※ 비밀번호는 비밀번호를 변경하는 경우에만 입력하시기 바랍니다.</span></th>
                </tr>
            </tbody>
        </table>
        <!--//Form 테이블 :e -->
        <table summary="사용여부, 설명 등의 사용자추가 선택 테이블입니다." class="tbl_form">
            <caption>
                사용자 추가 사용여부 선택 테이블
            </caption>
            <colgroup>
                <col style="width: 18%" />
                <col style="width: *" />
            </colgroup>
            <tbody>
            <tr>
                <th>사용여부 (<span class="essential">*필수</span>)</th>
                <td>
                    <label><input type="radio" name="active" value="true" <c:if test="${rtnUser.active==true}">checked="checked"</c:if>>사용</label>
                    <label><input type="radio" name="active" value="false" <c:if test="${rtnUser.active==false}">checked="checked"</c:if>>정지</label>
                </td>
            </tr>
            <tr>
                <th class="last">설명 (<span class="f12">선택</span>)</th>
                <td>
                    <%--<textarea type="text" name ="description"   colos="20" rows="5" onfocus="resize(this);">${ScUser.userDesc}</textarea>--%>
                    <textarea type="text" name="description" id="description" colos="20" rows="5"  placeholder="입력한 사용자 설명">${ScUser.userDesc}</textarea>
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
            <button type="button" class="button btn_cancel" title="취소"  onclick=" history.go(-1);">취소</button>
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
        $("#buttonCreateOnclick").text("사용자 삭제");
        $("#buttonCreateOnclick").click(function (event) {
            //$("#btnMDelete").on("click", function() {
            popupConfirmClick("사용자 삭제","사용자를 삭제 하시겠습니까?", 'deleteInstanceUserModify()',"사용자 삭제");
        });
        $("#buttonCreateOnclick2").text("사용자 수정");
        $("#buttonCreateOnclick2").click(function (event) {
            popupConfirmClick("사용자 수정","사용자 정보를 수정 하시겠습니까?", 'modify()',"사용자 수정");
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
            popupAlertClick("이메일 주소 형식이 올바르지 않습니다.");
            return;
        }
        if(!password_validation_check($("#confirmPasswordInput").val())){
            popupAlertClick("패스워드를 확인하세요.");
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
      procPopupAlert("사용자 수정이 완료되었습니다.",'$("#permissionList").submit()','return;');
    }

    // DELETE
    var deleteInstanceUserModify = function() {
        var url = "/user/instanceUserDelete.do/${ScUser.userId}";
        procCallAjax('delete', url, null, callbackDeleteInstanceUserModify);
    };

    // CALLBACK
    var callbackDeleteInstanceUserModify = function(data) {
        procPopupAlert("사용자 삭제가 완료되었습니다.",'$("#permissionList").submit()','return;');
    };


</script>
<!--//select 스크립트-->



