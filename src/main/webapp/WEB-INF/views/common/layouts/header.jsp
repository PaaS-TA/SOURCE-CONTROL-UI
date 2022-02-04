<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<div id="header">
    <div class="head_inner">
        <h1><a href="javascript:moveHome()" title="PaaS-TA Source Control" ><img alt="PaaS-TA Source Control" src="/resources/images/logo.png"><span>SCM</span></a></h1>
        <ul class="RP_title" style="float: left;display: block;position: relative;">
            <li><span class="RP_num" name="RP_cnt" id="RP_cnt"></span></li>
            <li><a href="#" class="wintoggle"><span class="RP_name">Repository List<b class="nav_arrow"></b></span></a>
                <ul id="ulToggleMenu" class="togglemenu" style="width:320px;">
                    <!--레파지토리 생성 영역 :s -->
                    <sec:authorize access="hasRole('ROLE_CREATE_Y')">
                    <li>
                        <h3><i class="glyphicon glyphicon-plus"></i>New Repository</h3>
                        <input type="text" id="topMenuRepositoryName" name="topMenuRepositoryName" placeholder="Repository name (required)">
                        <p class="desc" style="color:#fb5666; display: none" id="topMenuRepositoryNameAlert">* The format of the repository name is incorrect.</p>
                    </li>
                    <!--레파지토리 생성 영역 -->
                    <!--옵션 영역 :s -->
                    <li>
                        <h5>type</h5>
                        <select id="type_opt" name="type_opt">
                            <option value="git">Git</option>
                            <option value="svn">SVN</option>
                        </select>
                    </li>
                    <!--옵션 영역-->
                    <!--버튼 영역 :s -->
                    <li class="alignC">
                        <sec:authorize access="hasRole('ROLE_CREATE_Y')">
                        <button type="button" class="button btn_regist" title="Enrollment" id="btnTopMenuCreate">Add</button>
                        </sec:authorize>
                        <button type="button" class="button btn_regist" title="cancellation" id="btnTopMenuCancel">Cancel</button>
                    </li>
                    <!--버튼 영역-->

                    <li class="toggl_message" id="topMenuCreateResultArea" style="display: none;">
                        <span class="point01 bold" id="topMenuCreateResultName">'Repository name’</span> You have created a repository.</li>
                    </sec:authorize>
                    <li>
                        <h3><i class="glyphicon glyphicon-plus"></i>My Repository</h3>
                        <ul class="h6_ul" id="headerRepoList" name ="headerRepoList">
                        </ul>
                    </li>

                </ul>
            </li>

        </ul>
        <%@ include file="/WEB-INF/views/common/layouts/headerUser.jsp" %>
    </div>
</div>
<!-- togglemenu 스크립트 -->
<script>

$(".togglemenu")
    .mouseleave(function() {
        if( $(".wintoggle").hasClass("active") ){
            $(".wintoggle").removeClass("active");
            $(".togglemenu").hide();
        }else{
            $(".togglemenu").hide();
            $(".wintoggle").removeClass("active");
            $(".wintoggle").addClass("active");
            $(".wintoggle").next().slideDown();
        }
    });
$(".wintoggle").click(function(){
    if( $(this).hasClass("active") ){
        $(this).removeClass("active");
        $(".togglemenu").hide();
    }else{
        $(".togglemenu").hide();
        $(".wintoggle").removeClass("active");
        $(this).addClass("active");
        $(this).next().slideDown();
    }
    return false;
});
var repositoryNo = "<%=session.getAttribute("repositoryNo")%>";
var repositoryId = "<%=session.getAttribute("repositoryId")%>";


    // CREATE REPOSITORY
    var createTopMenuRepository= function () {

        var topMenuRepositoryName = document.getElementById('topMenuRepositoryName').value;
        if(!validRepositoryName(topMenuRepositoryName)){
            $("#topMenuRepositoryNameAlert").show();
            $('#topMenuRepositoryName').focus();
            return;
        }

        var reqParam = {
            name: topMenuRepositoryName,
            type: document.getElementById('type_opt').value,
            public : false
        };
        procCallAjax("post","/user/createRepository.do", reqParam, callbackCreateTopMenuRepository);
    };

    // CALLBACK
    var callbackCreateTopMenuRepository = function (data) {
        console.debug("callback");
        location.href=goHome;
    };


    // BIND
    $("#btnTopMenuCreate").on("click", function () {
        createTopMenuRepository();
    });

    $("#btnTopMenuCancel").on("click", function () {
        $('#topMenuRepositoryName').val('');
        $("#ulToggleMenu").addClass("active");
        $("#ulToggleMenu").removeClass("active");
        $("#ulToggleMenu").hide();
    });
</script>
<!--//togglemenu 스크립트 -->
<script>
    $(document).ready(function () {
        hearderRepoList();
        $("#topMenuRepositoryName").keyup(function () {
            var topMenuRepositoryName = $("#topMenuRepositoryName").val();
            if(!validRepositoryName(topMenuRepositoryName)){
                $("#topMenuRepositoryNameAlert").show();
            }else{
                $("#topMenuRepositoryNameAlert").hide();
            }
        });

    });

    <!-- 레파지토리 전체리스트가져오기 -->
    var hearderRepoList = function(){
        var url = "/user/repositoryMore/";
        var param = {
            "type":"",
            "sort":"lastModified",
            "reposort":"lastModified"};
        procCallAjax('get', url, param, headerRepoCallBack);
    };

    var headerRepoCallBack = function (data) {

        if(data.repositories==null || data.repositories.length==0){
            $("#RP_cnt").text(0);
            var varHeadHtml ='<li>No repositories were retrieved.</li>';
            $('#headerRepoList').append(varHeadHtml);
        }else{
            $("#RP_cnt").text(data.repositories.length);
            var repositories = data.repositories;
            for (var i = 0; i < repositories.length; i++) {
                var varHeadHtml ='<li><a href="/user/repositoryDetail/'+repositories[i].id+'">'+repositories[i].name+'</a></li>';
                $('#headerRepoList').append(varHeadHtml);
            }
        }
    }
</script>
