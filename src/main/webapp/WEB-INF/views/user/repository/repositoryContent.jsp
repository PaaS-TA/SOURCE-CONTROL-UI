<!--
=================================================================
* 시 스 템 명 : 레파지토리 소스보기 웹 UI
* 업 무 명 : 레파지토리 소스보기
* 프로그램명 user/repository/epositoryCcontent.jsp
* 프로그램 개요 : 파지토리 소스보기 화면
* 작 성 자 : 이인정
* 작 성 일 : 2018.07.10
* 화면 ID: UI-FDSC-5100
* 화면설계 ID: UI-SBSC-5100
=================================================================
수정자 / 수정일 :
수정사유 / 내역 :
=================================================================
-->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/xml" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="tema_view"><h5>커밋 :  <span class="r_data"></span></h5>
    <div class="tema_view_inner">
        <span id = "contPath" name="contPath"></span>
    </div>
</div>
<!--//설명영역 :e -->
<!-- 코드 박스 :s -->
<div class="codebox_area">
    <div class="tema_view_inner" id="browserContent" name="browserContent">
    </div>
</div>
    <!--//contents :e -->
<!-- Top 가기 :s -->
<div class="follow" title="Scroll Back to Top">
	<a href="#" title="top"><img src="./resources/images/a_top.gif"></a>
</div>
<!--//Top 가기 :e -->
<!--select 스크립트-->
<script src="http://code.jquery.com/jquery-2.2.1.min.js"></script>
<script>
    var getBrowserContent = function (path, revision) {
        console.debug("getBrowserContent");
        param = "&path="+path
            + "&revision="+revision;
        var url = "/user/repositoryDetail/"+$("#repositoryId").val()+ "/content/?"+param;
        procCallAjax('get', url, param, callbackBrowserContent);
    };

    var callbackBrowserContent = function (data) {
        $( "#repositoryBrowseList" ).hide();
        $( "#repositoryBrowseContent" ).show();
        var bype = data;
        $("#contPath").text(data.path);

        var varRepositoryHtml =data.data[0];
        $('#contPath').append(varRepositoryHtml);
    };
</script>
<!--//select 스크립트-->
