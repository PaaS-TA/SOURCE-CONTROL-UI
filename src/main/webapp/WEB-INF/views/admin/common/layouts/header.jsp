<!--
=================================================================
* 시 스 템 명 : 슈퍼어드민 header
* 업 무 명 : 어드민 HEADER
* 프로그램명(ID header.jsp(슈퍼어드민 해더)
* 프로그램 개요 : header 화면
* 작 성 자 : 이인정
* 작 성 일 : 2018.07.13
* 화면 ID:
* 화면설계 ID:
=================================================================
수정자 / 수정일 :
수정사유 / 내역 : 슈퍼 관리자 해더 사용 수정
=================================================================
-->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="header">
    <div class="head_inner">
        <h1><a title="PaaS-TA Source Control" href="/admin/serviceInstantList"><img alt="PaaS-TA Source Control" src="/resources/images/logo.png"><span>SCM</span></a></h1>
            <ul class="nav_ibtn">
                <li><a href="#" class="wintoggle">${name}<b class="nav_arrow"></b></a>
                    <ul class="togglemenu" style="width:125px;">
                        <li><a href="/logout">Log out</a></li>
                    </ul>
                </li>
            </ul>
        </ul>
    </div>
</div>
<body>
<div id="wrap">
<!-- togglemenu 스크립트 -->
<script type="text/javascript">
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

    $(".togglemenu")
        .focusout(function() {
            if( $(".wintoggle").hasClass("active") ){
                $(".wintoggle").removeClass("active");
                $(".togglemenu").hide();
            }else{
                $(".togglemenu").hide();
                $(".wintoggle").removeClass("active");
                $(".wintoggle").addClass("active");
                $(".wintoggle").next().slideDown();
            }
        })

</script>
<script>

    var name = "<%=session.getAttribute("name")%>";
    var instanceId = "<%=session.getAttribute("instanceId")%>";
    var repositoryNo = "<%=session.getAttribute("repositoryNo")%>";
    var repositoryId = "<%=session.getAttribute("repositoryId")%>";

</script>
<!--//togglemenu 스크립트 -->
