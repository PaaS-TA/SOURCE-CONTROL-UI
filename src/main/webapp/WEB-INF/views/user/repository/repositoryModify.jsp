<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- contaniner :s -->
<div id="container">
    <!-- location :s -->
    <div class="location">
        <ul>
            <li><a href="/user/repository/" class="home">홈으로</a></li>
            <li><a href="#" title="">정보보기/수정</a></li><!--마지막 경로일때-->
        </ul>
    </div>
    <!--//location :e -->
    <!-- contents :s -->
    <div class="contents">
        <c:set var="repository" value="${repositoryMpdify}"></c:set>
        <!-- Form 테이블 :s -->
        <table summary="사용자생성 입력 테이블입니다." class="tbl_form02">
            <caption>
                사용자생성
            </caption>
            <colgroup>
                <col style="width: 18%" />
                <col style="width: *" />
            </colgroup>
            <tbody>
            <tr>
                <th>레파지토리 명 (<span class="essential">*필수</span>)</th>
                <td><input type="text" id="RepositoryName" name="RepositoryName" value="${repositoryMpdify.name}" placeholder="레파지토리 명은 수정이 불가능합니다." disabled /></td>
            </tr>
            <tr>
                <th>유형 (<span class="essential">*필수</span>)</th>
                <td>
                    <label><input type="radio" name="type" id="type1" value="git" <c:if test="${repositoryMpdify.type=='git'}">checked="checked" </c:if> disabled >Git</label>
                    <label><input type="radio" name="type" id="type2" value="svn" <c:if test="${repositoryMpdify.type=='svn'}">checked="checked" </c:if>  disabled >SVN</label>
                </td>
            </tr>
            <tr style="display: none">
                <th>공개여부 (<span class="essential">*필수</span>)</th>
                <td>
                    <label><input type="radio" name="public" id="public5" value="true" <c:if test="${repositoryMpdify.public_=='true'}">checked="checked" </c:if>>공개(Public)</label>
                    <label><input type="radio" name="public" id="public6" value="false" <c:if test="${repositoryMpdify.public_=='false'}">checked="checked" </c:if>>비공개(Private)</label>
                </td>
            </tr>
            <tr>
                <th>레파지토리 설명 (<span class="f12">선택</span>)</th>
                <td><textarea type="text" name="description" id="description" colos="20" rows="5" onfocus="resize(this)" placeholder="입력한 레파지토리 노출">${repositoryMpdify.description}</textarea>
                </td>
            </tr>
            </tbody>
        </table>
        <!--//Form 테이블 :e -->
        <!--기본버튼 :s -->
        <div class="fl">
            <jsp:include page="../common/buttonCreateOnclick.jsp"></jsp:include>
            <%--<button type="button" class="button btn_default" title="레파지토리 삭제" id="btnDelete">레파지토리 삭제</button>--%>
        </div>
        <div class="fr">
            <jsp:include page="../common/buttonCreateOnclick2.jsp"></jsp:include>
            <%--<button type="button" class="button btn_default" title="수정" id="btnUpdate">저장</button>--%>
            <button type="button" class="button btn_cancel" title="취소" id="btnRMCancel"  onclick="procMovePage(-1)">취소</button>
        </div>
        <!--//기본버튼 :e -->
    </div>
    <!--//contents :e -->
    <input type="hidden" id="id" name="id" value="<c:out value='${repositoryMpdify.id}' default='' />" />
    <form id = "form_modify" method="get"  action ="/user/repositoryDetail/${repositoryMpdify.id}">
    </form>
    <form id = "form_list" method="get"  action ="/user/repository/">
    </form>


</div>
<!--select 스크립트-->
<script type="text/javascript">
    // UPDATE REPOSITORY
    var updateRepository = function () {
        var id =document.getElementById('id').value;
        var publicType;
        if (document.getElementsByName("type").checked) {
            publicType = "git"
        } else {
            publicType = "svn"
        }
        var publicValue;
        publicValue = !!document.getElementById('public5').checked;

        var reqParam = {
            id : id,
            description : document.getElementById('description').value,
            public: publicValue
        };
        procCallAjax("put","/user/update/"+ id+"?type="+publicValue, reqParam, callbackUpdateRepository());
    };

    // CALLBACK
    var callbackUpdateRepository  = function (data) {
        console.log("callback");
        procPopupAlert("수정 되었습니다.",'$("#form_modify").submit()', 'return');
    };

    // DELETE
    var deleteRepository = function() {
        procCallAjax("delete","/user/repository/"+document.getElementById('id').value, null,callbackDeleteUser);
    };

    // CALLBACK
    var callbackDeleteUser = function(data) {
        procPopupAlert("삭제 되었습니다.",'$("#form_list").submit()', 'return');
    };

    // ON LOAD
    $(document.body).ready(function () {
        // BIND
        $("#buttonCreateOnclick").text("레파지토리 삭제");

        $("#buttonCreateOnclick").click(function (event) {
            if(popupConfirmClick("레파지토리 삭제 확인", "레파지토리를 삭제 하시겠습니까?", 'deleteRepository()','삭제'));
        });

        // BIND
        $("#buttonCreateOnclick2").text("수정");
        $("#buttonCreateOnclick2").click(function (event) {
            updateRepository();
        });

        // BIND
//        $("#buttonCreateOnclick3").text("취소");
//        $("#buttonCreateOnclick3").click(function (event) {
//            procMovePage(-1);
//        });

    });

</script>