<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/xml" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="container">
    <!-- location :s -->
    <div class="location">
        <ul>
            <li><a href="#" onclick="moveHome()" class="home">홈으로</a></li>
            <li><a href="#" onclick="moveHome()"  title="레파지토리 목록"> 레파지토리 목록 </a></li>
            <!--마지막 경로-->
            <li><a href="#" title="레파지토리 상세보기"> 레파지토리 상세보기 (${repositorydetails.name})</a></li><!--마지막 경로-->
        </ul>
        <div class="fr" style="align-content:inherit">
            <a href="/user/update/${repositorydetails.id}?type=${repositorydetails.type}">
                <button type="button" class="button btn_default" title="정보보기/수정">정보보기/수정</button>
            </a>
            <a href="/user/createRepository/">
                <jsp:include page="/WEB-INF/views/user/common/buttonCreateAhref.jsp"></jsp:include>
            </a>
        </div>
    </div>
    <!--//location :e -->
    <!-- contents :s -->
    <div class="contents">
        <!-- sub_tab :s -->
        <div class="sub_tab">
            <ul>
                <li class="fst active"><a href="#;" onClick="sub_tab(0);"><span class="file_on"></span>파일(file) <span
                        class="pl10" id="detailBrowserResultCntMain" name="detailBrowserResultCntMain">${browserResult.files.size()}</span></a></li><!--아이콘 온파일네임 파일명_on 붙이면 됨-->
                <li class=""><a href="#;" onClick="sub_tab(1);"><span class="commint"></span>커밋(Commit) <span
                        class="pl10">${ChangesetPagingResult.size()}</span></a></li>
                <li class=""><a href="#;" onClick="detail_Sub_tab(2);"><span class="contributor"></span>참여자(Contributor)
                    <span class="pl10" id="detailPermissionCntMain" name="detailPermissionCntMain">${repositorydetails.permissions.size()}</span></a></li>
                <input type="hidden" id="repositoryId" name="repositoryId" value="${repositorydetails.id}"/>
            </ul>
        </div>
        <!--//sub_tab :e -->
        <!-- sub탭 콘텐츠01 :s -->
        <div class="sub_tab_cont00">
            <div class="tab_content">
                <%@ include file="/WEB-INF/views/user/repository/repositoryBrowseList.jsp" %>
            </div>
        </div>
        <!--//sub탭 콘텐츠01 :e -->
        <!-- sub탭 콘텐츠02 :s -->
        <div class="sub_tab_cont01 mTs" style="display:none;">
            <div class="tab_content">
                <!-- 셀렉트(브랜치, Tag, 레파지토리 클론) : s -->
                <div class="rSearch_group">
                    <div class="sel_group">
                        <form name="frm" id="frm" action="" method="post" onsubmit="return false;">
                        </form>
                    </div>
                </div>
                <!--//셀렉트(브랜치, Tag, 레파지토리 클론) : e -->
                <!-- 레파지토리 목록(이미지없는) :s -->
                <ul class="product_list2">
                    <c:if test="${ChangesetPagingResult.size()==0}">
                        <li >
                            <dl>
                                <dt>조회된 데이터가 없습니다.</dt>
                            </dl>
                        </li>
                    </c:if>
                    <c:forEach items="${ChangesetPagingResult}" var="changesets" varStatus="status">
                        <li>
                            <dl>
                                <dt><a href="#">${changesets.description}</a></dt>
                                <dd>
                                    <ul>
                                        <li class="sbj_txt">${changesets.description}</li>
                                        <li class="stateArea"><i class="ico_create"></i>커밋
                                            : ${changesets.author.name}<${changesets.author.mail}></li>
                                    </ul>
                                </dd>
                                <dd class="btn_wrap">
                                    <button type="button" class="button tbl_in_btn_lg" title="소스보기" onclick="browse_search('','${changesets.id}');">소스보기</button>
                                </dd>
                            </dl>
                        </li>
                    </c:forEach>
                </ul>
                <!--//레파지토리 목록(이미지없는) :e -->
            </div>
        </div>
        <!--//sub탭 콘텐츠02 :e -->
        <!-- sub탭 콘텐츠03 :s -->
        <div class="sub_tab_cont02 mTs" style="display:none;">
            <div class="tab_subcontent" id="tabPermissionlist" style="display:block">
                <!-- 셀렉트(검색, 보기 선택, 사용자여부 선택, 레파지토리 클론) :s -->
                <%@ include file="/WEB-INF/views/user/permission/permissionList.jsp" %>
            </div>
            <div class="tab_subcontent" id="permissionCreate" style="display:none;">
                <%@ include file="/WEB-INF/views/user/permission/invitePermission.jsp" %>
            </div>
            <div class="tab_subcontent" id="permissionUpdate" style="display:none">
                <!-- 셀렉트(검색, 보기 선택, 사용자여부 선택, 레파지토리 클론) :s -->
                <%@ include file="/WEB-INF/views/user/permission/detailPermission.jsp" %>
            </div>
        </div>
        <!--//sub탭 콘텐츠03 :e -->
    </div>
    <!--//contents :e -->
    <!--permissionCreate :s -->

    <!--//permissionCreate :e -->
</div>
<!--//contaniner :e -->
<!-- Top 가기 :s -->
<div class="follow" title="Scroll Back to Top">
    <a href="#" title="top"><img src="/resources/images/a_top.gif"></a>
</div>
<!--//Top 가기 :e -->f
<script>
    var detail_Sub_tab = function (num) {
        console.log("detail_Sub_tab ::: num ::: " + num);
        sub_tab(num);
        if (num === 2) {
            searchPermissions();
        }
    };

    $("#branchWord").keyup(function (event) {
        if (event.key = 13) {
            return;
        }
        console.log("$(#branchWord).value:" + $("#branchWord").value);
        var nodeList = $("#select_branch").childNodes;
        for (var i = 0; i < nodeList.size; i++) {
            if ($("#select_branch").children('li').value.contains($("#branchWord").value)) {

            }
        }

    });

    var branch_search = function (data) {
        console("branch_search");
    };

    function rtnDate(date) {
        new Date(date);
        return rtnDate
    }
    function repoInfo() {
        $("#form_info").submit();
    }


</script>

<!--//select 스크립트-->
