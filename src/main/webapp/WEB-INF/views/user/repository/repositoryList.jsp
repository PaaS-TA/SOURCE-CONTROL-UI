<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- contaniner :s -->
<div id="container">
    <!-- location :s -->
    <div class="location">
        <div class="fl">
            <ul>
                <li><a href="javascript:moveHome()" class="home">Home</a></li>
                <li><a href="javascript:moveHome()" title="${title}">${title}</a></li><!--마지막 경로-->
            </ul>
        </div>
        <div class="fr" style="padding-top: 15px;">
            <a href="/user/createRepository">
                <jsp:include page="../common/buttonCreateAhref.jsp"></jsp:include>
            </a>
        </div>
    </div>
    <!--//location :e -->
    <!-- contents :s -->
    <div class="contents">
	    <c:set var="repositories" value='${rtnList.content}'/>
	    <c:set var="page" value='${rtnList.number}'/>
	    <c:set var="size" value='${rtnList.size}'/>
        <div class="rSearch_group">
            <div class="sel_group">
                <form id="frm_search" method="get" action="/user/repository/">
                    <input type="hidden" id="page" name="page" style="width:10px" value="<c:out value='${page}' default='0'  />"/>
                    <input type="hidden" id="size" name="size" style="width:200px" value="<c:out value='${size}' default='0' />"/>
                    <input type="hidden" id="type1" name="type1" style="width:10px" value="<c:out value='${type1}' default='' />"/>
                    <input type="hidden" id="type2" name="type2" style="width:200px" value="<c:out value='${type2}' default='' />"/>
                    <input type="hidden" id="reposort" name="reposort" value="<c:out value='${reposort}' default='' />"/>
                    <div class="keyword_search">
                        <input type="text" name="repoName" id="repoSearch_keyword" value="<c:out value='${repoName}' default=''/>" style="-ms-ime-mode: active;" autocomplete="on" placeholder="Repository name"/>
                        <button type="button" class="btn_search" name="btn_repoSearch" id="btn_repoSearch"/>
                    </div>
                    <div class="selectbox select1 ml5" style="width:135px;">
                        <div>
                            <c:if test="${type1==''}"><strong id="repoListType">All Source</strong><span class="bul"></span></c:if>
                            <c:if test="${type1=='git'}"><strong id="repoListType">Git</strong><span class="bul"></span></c:if>
                            <c:if test="${type1=='svn'}"><strong id="repoListType">SVN</strong><span class="bul"></span></c:if>
                        </div>
                        <ul class="select-list">
                            <li>All Source</li>
                            <li>Git</li>
                            <li>SVN</li>
                        </ul>
                    </div>
                    <div class="selectbox select2 ml5" style="width:135px;">
                        <div>
                            <c:if test="${type2==''}"><strong id="repoListPermission">Full repository</strong><span
                                    class="bul"></span></c:if>
                            <c:if test="${type2=='READ_WRITE_OWNER'}"><strong id="repoListPermission" >Participating
                               </strong><span class="bul"></span></c:if>
                        </div>
                        <ul class="select-list">
                            <li class="selectSortType" value="" id="repo_role" >Full repository</li>
                            <li class="selectSortType" value="READ_WRITE_OWNER" id="repo_allrole" >Participating</li>
                        </ul>
                    </div>
                    <div class="selectbox select3 ml5" style="width:135px;">
                        <div>
                            <c:if test="${reposort=='lastModified_true' || reposort==''}"><strong id="repoListreposort">recent
                                update</strong><span class="bul"></span></c:if>
                            <c:if test="${reposort=='lastModified_false'}"><strong id="repoListreposort">old update
                                </strong><span class="bul"></span></c:if>
                            <c:if test="${reposort=='creationDate_true'}"><strong id="repoListreposort">latest create
                                </strong><span class="bul"></span></c:if>
                            <c:if test="${reposort=='creationDate_false'}"><strong id="repoListreposort">old create
                                </strong><span class="bul"></span></c:if>
                        </div>
                        <ul class="select-list">
                            <li id="lastModified_desc" class="selectSortType">latest update</li>
                            <li id="lastModified_asc" class="selectSortType">Oldest update</li>
                            <li id="created_desc" class="selectSortType">Newest create</li>
                            <li id="created_asc" class="selectSortType">oldest create</li>
                        </ul>
                    </div>
                    <div class="fr" style="padding-top: 15px;">
                        <span id="repositoryNumberOfElements">Total ${rtnList.totalElements}</span>
                    </div>
                </form>
            </div>
        </div>
        <%--<div class="main_tab00">
            <div class="tab_content">--%>
            <!-- 레파지토리 목록 :s -->
            <ul class="product_list" id="repositoryList" name="repositoryList">
                <c:forEach items="${rtnList.content}" var="repositories" varStatus="status">
                    <c:set var="count" value="0"/>
                    <%--참여자 권한을 체크하여 소유자인지 체크한다.--%>
                        <c:set var="permissionType" value="false"/>
                        <c:forEach items="${repositories.permissions}" var="permissions" varStatus="sts">
                            <c:if test="${permissions.name eq name && permissions.type != 'READ'}">
                                <c:set var="permissionType" value="true"/>
                            </c:if>
                        </c:forEach>
                    <li>
                        <dl>
                            <c:forEach items="${repositories.permissions}" var="permissions" varStatus="sts">
                                <c:out value="${userid}"/>
                                <%--[1-1] 권한이 있을때 표출--%>
                                <c:if test="${permissions.name eq name}">
                                    <c:set var="count" value="1"/>
                                </c:if>
                            </c:forEach>
                            <c:if test="${permissionType=='true'}">
                                <dt>
                                    <a href="/user/repositoryDetail/${repositories.id}?type=${repositories.type}">${repositories.name}</a>
                                </dt>
                            </c:if>
                            <%--[1-2] 권한이 없을때 표출--%>
                            <c:if test="${permissionType!='true'}">
                                <dt>${repositories.name}</dt>
                            </c:if>
                            <%--#소유자권한--%>
                            <dd>
                                <ul>
                                    <li class="sbj_txt">${repositories.description}</li>
                                    <li class="stateArea"><i class="ico_update"></i>last update : ${repositories.lastModified}<span class="pr10"></span>
                                        <i class="ico_create"></i>creation date : ${repositories.creationDate}</li>
                                </ul>
                            </dd>
                            <c:choose>
                                <c:when test="${repositories.type eq 'git'}">
                                    <dd class="thmb_img"><img src="/resources/images/img_git.png" alt="GIT images" border="0"></dd>
                                </c:when>
                                <c:when test="${repositories.type eq 'svn'}">
                                    <dd class="thmb_img"><img src="/resources/images/img_svn.png" alt="SVN image" border="0"></dd>
                                </c:when>
                            </c:choose>
                            <dd class="icon_wrap">
                                <ul class="ico_lst">
                                    <li class="ico_area">
                                        <c:if test="${permissionType=='true'}">
                                            <img src="/resources/images/process_ico_own.png" alt="owner image" border="0">
                                            <p class="tit">owner</p>
                                        </c:if>
                                    </li>
                                </ul>
                            </dd>
                        </dl>
                    </li>
                </c:forEach>
                <c:if test="${rtnList.totalElements==0}">
                    <li>
                        <dl>
                            <dt>No data was retrieved.</dt>
                        </dl>
                    </li>
                </c:if>
                <%--<c:if test="${rtnList.last==false}">--%>
                        <%--<dl>--%>
                            <%--<button class="btn_more"  id="btn_more" name="btnMore" >more</button>--%>
                        <%--</dl>--%>
                 <%--</c:if>--%>
            <!--//레파지토리 목록 :e -->

    <c:if test="${rtnList.last==false}">
       <button class="table_more" id="btn_more" name="btn_more">more</button>
    </c:if>
    </div>
</div>
        <!--//contents :e -->
   <%-- </div>
</div>--%>
    <!--//contaniner :e -->
    <!-- Top 가기 :s -->
    <div class="follow" title="Scroll Back to Top">
        <a href="#" title="top"><img src="/resources/images/a_top.gif"></a>
    </div>
    <!--//Top 가기 :e -->
<%-- Java Script --%>
<script type="text/javascript">
    var page = 0;
    var size = 10;
    var repoSearchList = function () {
        var param2 = $("#repoListPermission").text();
        switch (param2) {
            case "Participating Repositories" :
                param2 = "READ_WRITE_OWNER";
                break;
            default:
                param2 = "";
        }
        $("#type2").val(param2);

        var param1 = $("#repoListType").text();
        switch (param1) {
            case "Git" :
                param1 = "git";
                break;
            case "SVN" :
                param1 = "svn";
                break;
            default:
                param1 = "";
        }

        $("#type1").val(param1);


        var param3 = $("#repoListreposort").text();
        switch (param3) {
            case "latest update order" :
                param3 = "lastModified_true";
                break;
            case "Oldest update order" :
                param3 = "lastModified_false";
                break;
            case "Newest creation date" :
                param3 = "creationDate_true";
                break;
            case "oldest creation date" :
                param3 = "creationDate_false";
                break;
            default:
                param3 = "";
        }
        $("#reposort").val(param3);
        $("#frm_search").submit();
    };

    $(document).ready(function () {
        $("#btn_more").click(function (event) {
            repositoryList();
        });
        $("#repoSearch_keyword").keyup(function (event) {
            if (event.which === 13) {
                repoSearchList();
            }
        });
        // BIND :: [돋보기] btn_repoSearch
        $("#btn_repoSearch").click(function () {
            repoSearchList();
        });
    });

    $.fn.selectDesign = function () {
        var t = $(this);
        var div = t.children("div");
        var strong = div.children("strong");
        var ul = t.children("ul");
        var li = ul.children("li");
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
            strong.html(txt);
            repoSearchList();
        });
    };

    $(".select1").selectDesign();
    $(".select2").selectDesign();
    $(".select3").selectDesign();

    var repositoryList = function () {
        page++;
        var url = "/user/repositoryUserMore/?";
        var param =
            "repoName ="+ $("#repoSearch_keyword").val()
            + "&type1 ="+ $("#type1").val()
            + "&type2 ="+ $("#type2").val()
            + "&reposort="+$("#reposort").val()
            + "&page="+ page++
            + "&size="+size;
        url += param;
        procCallAjax('get', url, param, callbackGetRepositoryList);
    };

    var callbackGetRepositoryList = function (data) {

        $("#repoSearch_keyword").valueOf(data.repoName);
        if(data.last){
            $("#btn_more").hide();
        }
        var repositories = data.content;
        $("#repositoryNumberOfElements").text('('+eval(data.number*data.size+data.numberOfElements)+'/'+data.totalElements+')');
       if (0 != repositories.length) {
            for (var i = 0; i < data.numberOfElements; i++) {
                var repository = repositories[i];
                /**
                 * 소유자 권한 체크
                 */
                var permissions = repository.permissions;
                var permissionType = false;
                for(var j=0; j < permissions.length; j++) {
                    if(!permissions.type!='READ'){
                        permissionType = true;
                    }
                }
                var varRepositoryHtml ="<li>\n" +
                    "    <dl>\n" +
                    "        <dt>\n";
                if(permissionType){
                    varRepositoryHtml += "            <a href='/user/repositoryDetail/"+repository.id+"&amp;type="+repository.type+"'>"+repository.name+"</a>\n" ;
                }else{
                    varRepositoryHtml += "            "+repository.name+" \n" ;
                }
                varRepositoryHtml += "        </dt>\n" +
                    "        <dd>\n" +
                    "            <ul>\n" +
                    "                <li class='sbj_txt'>"+repository.description+"</li>\n" +
                    "                <li class='stateArea'>\n" +
                    "                    <i class='ico_update'></i>last update: "+repository.lastModified+"<span class='pr10'></span>\n" +
                    "                    <i class='ico_create'></i>creation date : "+repository.creationDate+"\n" +
                    "                </li>\n" +
                    "            </ul>\n" +
                    "        </dd>\n" +
                    "        <dd class='thmb_img'><img src='/resources/images/img_"+repository.type+".png' alt='image' border='0'></dd>\n" +
                    "        <dd class='icon_wrap'>\n" +
                    "            <ul class='ico_lst'>\n" +
                    "                <li class='ico_area'>\n" ;
                if(permissionType){
                    varRepositoryHtml += "                    <img src='/resources/images/process_ico_own.png' alt='owner image' border='0'>\n"
                                        +"                    <p class='tit'>owner</p>\n";
                }
                varRepositoryHtml += "                </li>\n" +
                    "            </ul>\n" +
                    "        </dd>\n" +
                    "    </dl>\n" +
                    "</li>";
                $('#repositoryList').append(varRepositoryHtml);

            }
        }
    };
</script>
<!--//select 스크립트-->
