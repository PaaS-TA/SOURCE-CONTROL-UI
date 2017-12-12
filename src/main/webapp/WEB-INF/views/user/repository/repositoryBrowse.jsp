<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/xml" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="repositoryDetailFileList">
    <div class="rSearch_group">
        <c:out value="${browserResult}"></c:out>
        <div class="sel_group">
            <c:if test="${type!='svn'}">
            <div class="selectbox branch_select fl" id="fileSelect1">
                <div>
                    <strong>브랜치:<c:out value="${browserResult.branch==null?'':browserResult.branch}"></c:out></strong><span
                        class="bul"></span>
                </div>
                <ul class="select-list" id="select_branch">
                    <input type="text" name="branchWord" maxlength="25" value="" title="브랜치 명 검색"
                           placeholder="브랜치 명 검색">
                    <c:forEach items="${branches.branches}" var="branch" varStatus="status">
                        <li onclick="browse_search('','${branch.revision}');">${branch.name}</li>
                    </c:forEach>
                </ul>
            </div>
	        </c:if>
            <c:if test="${type!='svn'}">
            <div class="selectbox tag_select ml5" id="fileSelect2">
                <div>
                    <strong>Tag: <c:out value="${browserResult.tag==null?'':browserResult.tag}"></c:out></strong>
                    <span class="bul"></span>
                </div>
                <ul class="select-list">
                    <input type="text" name="tagWord" maxlength="25" value="" title="Tag 검색" placeholder="Tag 검색">
                    <c:forEach items="${tags.tags}" var="tags" varStatus="status">
                        <li onclick="browse_search('','${tags.revision}')">${tags.name}</li>
                    </c:forEach>
                </ul>
            </div>
			</c:if>
            <div class="selectbox select3 fr" style="width:300px;" id="fileSelect3">
                <div>
                    <strong>레파지토리 클론</strong><span class="bul"></span>
                </div>
                <ul class="select-list">
                    <input type="text" name="copyUrl" id="copyUrl" maxlength="25" value="" title="레파지토리 클론"
                           style="width:75%;">
                    <button type="button" class="button sel_in_btn_lg" onclick='copycloneUrl(); return false;'
                            maxlength="25" style="width:15%;">복사
                    </button>
                </ul>
            </div>

        </div>
    </div>
    <!--//셀렉트(브랜치, Tag) : e -->
    <!-- list :s -->
    <table id="broswerTable" summary="폴더/파일명, 최종 변경사항, 최종 변경자, 마지막업데이트 등을 나타낸 Commit 게시판입니다."
           class="basic_tbl w3-hoverable">
        <caption>
            공지사항
        </caption>
        <colgroup>
            <col style="width:35%;">
            <col style="width:*">
            <col style="width:15%">
            <col style="width:15%">
        </colgroup>
        <thead>
        <tr>
            <th scope="col"><a href="#">폴더/파일명</a></th>
            <th scope="col">최종 변경사항</th>
            <th scope="col">파일 크기</th>
            <th scope="col">마지막 업데이트</th>
        </tr>
        </thead>
        <tbody id="browserResult" name="browserResult">
        </tbody>
    </table>
    <!--//list :e -->
    <!-- 설명영역 :s -->
    <div class="tema_view">
        <%--<h5>README.md</h5>--%>
        <%-- <div class="tema_view_inner">
             <h2>PaaS-TA 가이드 문서</h2>
             <dl>
                 <dt>플랫폼 설치 가이드</dt>
                 <dd><a href="#">설치 파일 다운로드 받기</a></dd>
                 <dd><a href="#">플랫폼 설치</a></dd>
                 <dd><a href="#">플랫폼 설치 자동화</a></dd>
                 <dd><a href="#">PaaS-TA 미터링 설치</a></dd>
             </dl>
             <dl>
                 <dt>서비스 설치 가이드</dt>
                 <dd><a href="#">DBMS 설치</a></dd>
                 <dd><a href="#">MongoDB</a></dd>
                 <dd><a href="#">Cubrid 설치</a></dd>
                 <dd><a href="#">MySQL</a></dd>
                 <dd><a href="#">NOSQL 설치</a></dd>
             </dl>
         </div>--%>
    </div>
    <!-- Top 가기 :s -->
    <div class="follow" title="Scroll Back to Top">
        <a href="#" title="top"><img src="/resources/images/a_top.gif"></a>
    </div>
</div>
<!--//Top 가기 :e -->
<!--select 스크립트-->
<script>
    var size = 10;
    var page = 0;

    $.fn.selectDesign = function () {
        var t = $(this);
        var div = t.children("div");
        var strong = div.children("strong");
        var ul = t.children("ul");
        var li = ul.children("li");
        var button = ul.children("button");
        var door = false;

        div.click(function () {
            if (door) {
                ul.hide();
            } else {
                ul.show();
            }
            door = !door;
        });

        ul.mouseleave(function () {
            ul.hide();
            door = false;
        });

        li.click(function () {
            var txt = $(this).text();
            strong.text(txt);
            ul.hide();
        });
    };
    $(".branch_select").selectDesign();
    $(".tag_select").selectDesign();
</script>

<script>
    var repositoryUrl = '${repositorydetails.url}';
    var repositoryCloneUser = '${name}' + '@';
    var replaceUrl = repositoryUrl.split('//')[0] + '//';
    repositoryUrl = $("#copyUrl").val() + "" + repositoryUrl.replace(replaceUrl, replaceUrl + repositoryCloneUser);
    $("#copyUrl").val(repositoryUrl);

    $(document).ready(function () {
        browse_search('', '');
        $("#branchWord").keyup(function (event) {
            if (event.key = 13) {
                return;
                console.log("$(#branchWord).value:" + $("#branchWord").value);
                var nodeList = $("#select_branch").childNodes;
                for (var i = 0; i < nodeList.size; i++) {
                    if ($("#select_branch").children('li').val().contains($("#branchWord").value)) {
                        console.log("$(#select_branch).children('li').value" + $("#select_branch").children('li').val());
                        console.log("$(#branchWord).value" + $("#branchWord").val());
                    }
                }
            }
        });
    });


    //데이터 안보이게
    var copycloneUrl = function () {

        $('#clip_target').select(); // Use try & catch for unsupported browser
        try {
            // The important part (copy selected text)
            $("#copyUrl").select();
            var successful = document.execCommand('copy');
            popupAlertClick("레파지토리 주소가 복사 되었습니다.");
        } catch (err) {
            alert('이 브라우저는 지원하지 않습니다.')
        }
    };
    $("#branchWord").keyup(function (event) {
    });


    var browse_search = function (path, revision) {
        $('#broswerTable > tbody').empty();
        console.debug("browse_search");
        param = "disableLastCommit=" + false
            + "&disableSubRepositoryDetection=" + false
            + "&path=" + path
            + "&recursive=" + false
            + "&revision=" + revision;
        var url = "/user/repositoryDetail/" + $("#repositoryId").val() + "/browse/?" + param;
        procCallAjax('get', url, param, callbackBroswer);
    };


    var callbackBroswer = function (data) {
        sub_tab(0);
        var list = data.browserResult;
        var path = data.path;
        if (list.files === null || list.files.length === 0) {
            initialBrowserList();
        } else {
            var browser = list.newFiles;
            var paramPath = "";
            var listPath = path.split('/');
            for (var i = 0; i < listPath.length - 1; i++) {
                var paramPath = paramPath + listPath[i] + "/";
            }
            if (listPath.length > 0 && listPath[0] !== "") {
                sinnerHTML = sinnerHTML + '<tr onclick="browse_search(\'' + paramPath.substring(0, paramPath - 1) + '\'' + ', \'' + list.revision + '\'' + ')">';
                sinnerHTML = sinnerHTML + '<td class="alignL" colspan="4"> <span class="ico_folder"></span>';
                sinnerHTML = sinnerHTML + '..</td></tr>';
                $('#broswerTable > tbody:last').append(sinnerHTML);
            }
            for (var i = 0; i < browser.length; i++) {
                var sinnerHTML = '';
                if (browser[i].directory) {
                    sinnerHTML = sinnerHTML + '<tr onclick="browse_search(\'' + browser[i].path + '\'' + ', \'' + list.revision + '\'' + ')">';
                    sinnerHTML = sinnerHTML + '<td class="alignL" colspan="4"><a href="#"><span class="ico_folder"></span>';
                    sinnerHTML = sinnerHTML + browser[i].name + '</a></td></tr>'
                } else {
                    sinnerHTML = sinnerHTML + '<tr  onclick="browserContent(\'' + browser[i].path + '\'' + ', \'' + list.revision + '\'' + ')">';
                    sinnerHTML = sinnerHTML + '<td class="alignL"><a href="#"><span class="ico_file"></span>';
                    sinnerHTML = sinnerHTML + browser[i].name + '</a></td>'
                        + '<td class="alignL">' + browser[i].description + '</td>'
                        + '<td>' + browser[i].length + ' bytes</td>'
                        + '<td class="alignR">' + browser[i].slastModified + '</td></tr>';
                }
                $('#broswerTable > tbody:last').append(sinnerHTML);
            }
        }
    };
    function initialBrowserList() {
        var varBrowserHtml = '<tr id="initRepoList" name="initRepoList"> <td colspan="4">조회된 데이터가 없습니다.</td>            </tr>';
        $('#browserResult').append(varBrowserHtml);
    }

    var browserContent = function (path, revision) {


        getBrowserContent(path, revision);
        console.debug("browserContent");

    };

</script>

<!--//select 스크립트-->
