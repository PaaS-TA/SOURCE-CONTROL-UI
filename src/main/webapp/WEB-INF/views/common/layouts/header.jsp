<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<div id="header">
    <div class="head_inner">
        <h1><a title="PaaS-TA 형상관리" href="/user/repository/"><img alt="PaaS-TA 형상관리" src="/resources/images/logo.png"><span>형상관리</span></a></h1>
        <ul class="RP_title" style="float: left;display: block;position: relative;">
            <li><span class="RP_num" name="RP_cnt" id="RP_cnt"></span></li>
            <li><a href="#" class="wintoggle"><span class="RP_name">레파지토리 목록<b class="nav_arrow"></b></span></a>
                <ul id="ulToggleMenu" class="togglemenu" style="width:320px;">
                    <!--레파지토리 생성 영역 :s -->
                    <sec:authorize access="hasRole('ROLE_CREATE_Y')">
                    <li>
                        <h3><i class="glyphicon glyphicon-plus"></i>신규 생성 (New Repository)</h3>
                        <input id="topMenuRepositoryName" name="topMenuRepositoryName" type="text" placeholder="레파지토리 명(필수)">
                        <p class="desc" style="color:#fb5666;" id="topMenuRepositoryNameAlert">* 레파지토리명 형식이 올바르지 않습니다.</p>
                    </li>
                    <!--레파지토리 생성 영역 -->
                    <!--공개/비공개 영역 :s -->
                    <li style="display: none;">
                        <h5>공개여부</h5>
                        <ul>
                            <li><input type="radio" name="public" id="public0" value=true >공개(Public)</li>
                            <li><input type="radio" name="public" id="public00" value=false checked="checked">비공개(Private)</li>
                        </ul>
                    </li>
                    <!--공개/비공개 영역 :s -->
                    <!--옵션 영역 :s -->
                    <li>
                        <h5>유형</h5>
                        <select id="type_opt" name="type_opt">
                            <option value="git">Git</option>
                            <option value="svn">SVN</option>
                        </select>
                    </li>
                    <!--옵션 영역-->
                    <!--버튼 영역 :s -->
                    <li class="alignC">
                        <sec:authorize access="hasRole('ROLE_CREATE_Y')">
                        <button type="button" class="button btn_regist" title="등록" id="btnTopMenuCreate">등록</button>
                        </sec:authorize>
                        <button type="button" class="button btn_regist" title="취소" id="btnTopMenuCancel">취소</button>
                    </li>
                    <!--버튼 영역-->

                    <li class="toggl_message" id="topMenuCreateResultArea" style="display: none;">
                        <span class="point01 bold" id="topMenuCreateResultName">‘레파지토리 명’</span> 레파지토리를 생성했습니다.</li>
                    </sec:authorize>
                    <li>
                        <h3><i class="glyphicon glyphicon-plus"></i>나의 레파지토리 (My Repository)</h3>
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
        console.debug(":::::들어오니? 1탄::::");
        var topMenuRepositoryName = document.getElementById('topMenuRepositoryName').value;
        if(!validRepositoryName(topMenuRepositoryName)){
            $("#topMenuRepositoryNameAlert").show();
            $('#topMenuRepositoryName').focus();
            return;
        }
        var publicValue;

        publicValue = !!document.getElementById('public0').checked;

        var reqParam = {
            name: topMenuRepositoryName,
            type: document.getElementById('type_opt').value,
            public : publicValue
        };
        console.debug("::::들어오니? 2탄::::"+ JSON.stringify(reqParam));
        procCallAjax("post","/user/createRepository.do", reqParam, callbackCreateTopMenuRepository);
        console.debug("::::들어오니? 3탄::::");
    };

    // CALLBACK
    var callbackCreateTopMenuRepository = function (data) {
        console.debug("callback");
        location.href="/user/repository/";
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
        $("#RP_cnt").text(data.repositories.length);
        if(data.repositories==null || data.repositories.length==0){
            var varHeadHtml ='<li>조회된 레파지토리가 없습니다.</li>';
            $('#headerRepoList').append(varHeadHtml);
        }else{
            var repositories = data.repositories;
            for (var i = 0; i < repositories.length; i++) {
                var varHeadHtml ='<li><a href="/user/repositoryDetail/'+repositories[i].id+'">'+repositories[i].name+'</a></li>';
                $('#headerRepoList').append(varHeadHtml);
            }
        }
    }
</script>