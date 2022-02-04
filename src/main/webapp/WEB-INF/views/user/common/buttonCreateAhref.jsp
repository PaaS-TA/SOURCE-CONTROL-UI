<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authorize access="hasRole('ROLE_CREATE_Y')">
<button type="button" class="button btn_default" title="create new" id="buttonCreateAref">Create new</button>
</sec:authorize>
