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
                    <strong id="branch_str">branch:<c:out value="${browserResult.branch==null?'':browserResult.branch}"></c:out></strong>
                    <span class="bul"></span>
                </div>
                <ul class="select-list" id="select_branch">
                    <input type="text" name="branchWord" id="branchWord" maxlength="25" value="" title="Find a branch" placeholder="Find a branch" autocomplete="on">
                    <c:forEach items="${branches.branches}" var="branch" varStatus="status">
                        <li onclick="browse_search('','','${branch.revision}');" class="branch">${branch.name} </li>
                    </c:forEach>
                </ul>
            </div>
                </c:if>
            <c:if test="${type!='svn'}">
            <div class="selectbox tag_select ml5" id="fileSelect2">
                <div>
                    <strong  id="tag_str">Tag:<c:out value="${browserResult.tag==null?'':browserResult.tag}"></c:out></strong>
                    <span class="bul"></span>
                </div>
                <ul class="select-list">
                    <input type="text" name="tagWord" id="tagWord" maxlength="25" value="" title="Find a tag" placeholder="Find a tag" autocomplete="on" >
                    <c:forEach items="${tags.tags}" var="tags" varStatus="status">
                        <li onclick="browse_search('','','${tags.revision}')" class="tag">${tags.name}</li>
                    </c:forEach>
                </ul>
            </div>
                        </c:if>
            <!--//셀렉트(브랜치, Tag, 레파지토리 클론) : e -->
            <div class="selectbox select3 fr" style="width:300px;" id="fileSelect3">
                <div>
                    <strong>Repository clone</strong><span class="bul"></span>
                </div>
                <ul class="select-list">
                    <input type="text" name="copyUrl" id="copyUrl" maxlength="25" value="" title="Repository clone"
                           style="width:75%;">
                    <button type="button" class="button sel_in_btn_lg" onclick='copycloneUrl(); return false;'
                            maxlength="25" style="width:15%;">Copy
                    </button>
                </ul>
            </div>

        </div>
    </div>
    <!--//셀렉트(브랜치, Tag) : e -->
    <!-- list :s -->
    <table id="broswerTable" summary="This is a Commit bulletin board showing the folder/file name, last change, last changer, last update, etc."
           class="basic_tbl w3-hoverable">
        <caption>
            Notice
        </caption>
        <colgroup>
            <col style="width:35%;">
            <col style="width:*">
            <col style="width:15%">
            <col style="width:15%">
        </colgroup>
        <thead>
        <tr>
            <th scope="col"><a href="#">folder/file name</a></th>
            <th scope="col">Last Changes</th>
            <th scope="col">file size</th>
            <th scope="col">last update</th>
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
             <h2>PaaS-TA guide document</h2>
             <dl>
                 <dt>Platform Installation Guide</dt>
                 <dd><a href="#">Download the installation file</a></dd>
                 <dd><a href="#">Platform installation</a></dd>
                 <dd><a href="#">Automate platform installation</a></dd>
                 <dd><a href="#">Install PaaS-TA metering</a></dd>
             </dl>
             <dl>
                 <dt>Service Installation Guide</dt>
                 <dd><a href="#">DBMS installation</a></dd>
                 <dd><a href="#">MongoDB</a></dd>
                 <dd><a href="#">Cubrid installation</a></dd>
                 <dd><a href="#">MySQL</a></dd>
                 <dd><a href="#">Install NOSQL</a></dd>
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

            var class_by_name = $(this).attr('class');
            if(class_by_name == 'tag') {
                if ($("#branch_str").text() != "branch:") {
                    $("#branch_str").text("");
                }
            }
            if(class_by_name == 'branch'){
                if ($("#tag_str").text() != "Tag:") {
                    $("#tag_str").text("");
                }
            }
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
        $("#tagWord").keyup(function (event) {
            if (event.key = 13) {
                return;
                console.log("$(#tagWord).value:" + $("#tagWord").value);
                var nodeList = $("#select_tag").childNodes;
                for (var i = 0; i < nodeList.size; i++) {
                    if ($("#select_tag").children('li').val().contains($("#tagWord").value)) {
                        console.log("$(#select_tag).children('li').value" + $("#select_tag").children('li').val());
                        console.log("$(#tagWord).value" + $("#tagWord").val());
                    }
                }
            }
        });
    });

    $("#branchWord").keyup(function (event) {
        if (event.which === 13) {
            var searchString = $('#branchWord').val(),
                foundLi = $('li:contains("' + searchString + '")');
            //css적용
            foundLi.addClass('found');
            $('#branchWord').animate({ scrollTop: foundLi.offset().top});
        }
    });

    $("#tagWord").keyup(function (event) {
        if (event.which === 13) {
            var searchString = $('#tagWord').val(),
                foundLi = $('li:contains("' + searchString + '")');
            //css적용
            foundLi.addClass('found');
            $('#select_tag').animate({ scrollTop: foundLi.offset().top});
        }
    });

    //데이터 안보이게
    var copycloneUrl = function () {

        $('#clip_target').select(); // Use try & catch for unsupported browser
        try {
            // The important part (copy selected text)
            $("#copyUrl").select();
            var successful = document.execCommand('copy');
            popupAlertClick("The repository address has been copied.");
        } catch (err) {
            alert('This browser is not supported.')
        }
    };


    var browse_search = function (path, revision) {
        $('#broswerTable > tbody').empty();
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
        var varBrowserHtml = '<tr id="initRepoList" name="initRepoList"> <td colspan="4">No data was retrieved.</td>            </tr>';
        $('#browserResult').append(varBrowserHtml);
    }

    var browserContent = function (path, revision) {
        getBrowserContent(path, revision);
        console.debug("browserContent");

    };

</script>
<style> .found{background-color:gainsboro;}  #test{height:80px;  overflow:scroll;}</style>
<!--//select 스크립트-->

