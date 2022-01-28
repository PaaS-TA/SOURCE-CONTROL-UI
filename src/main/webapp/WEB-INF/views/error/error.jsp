<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div id="container" >
    <!-- login :s -->
    <div id="loginWrap" class="loginbox">
        <div class="header" >
            <h1 style="line-height: 100px;"><img alt="PaaS-TA configuration management" src="/resources/images/logo.png"><span class>  형상관리</span>ERROR</h1>
        </div>
        <div class="input_wrap clear_fix">
            <div class="input_inner">
                <c:if test="${not empty error}">
                    <div><span class="alert-danger">${error}<br>
                            ${exception.message}<br>
                        <br>
                        <br>
                    </span></div>
                </c:if>
                <p><label class="hidden">type : ${type}</label></p>
                <p><label class="hidden">status-code : ${status}</label></p>
            </div>
            <button type="submit" class="btn_login" onclick="window.open('about:blank','_self').self.close();">close screen</button>

        </div>
    </div>
</div>