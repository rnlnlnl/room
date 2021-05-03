<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 기본 세트 : core 라이브러리 / contextPath 정의 / 페이지 한글 처리 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%
	request.setCharacterEncoding("UTF-8");
%>

<c:if test="${center == null}">
	<c:choose>
		<c:when test="${auth=='A'}">
			<c:set var="center" value="../include/adminCenter.jsp" />
		</c:when>
		<c:when test="${auth=='S'}">
			<c:set var="center" value="../include/sellerCenter.jsp" />
		</c:when>
		<c:otherwise>
			<c:set var="center" value="../include/defaultCenter.jsp" />
		</c:otherwise>
	</c:choose>
</c:if>

<!DOCTYPE html>
<!--Template Name: Escarine-Hol Author: <a href="https://www.os-templates.com/">OS Templates</a> Author URI: https://www.os-templates.com/ Licence: Free to use under our free template licence terms Licence URI: https://www.os-templates.com/template-terms-->
<html>
<head>
<c:choose>
	<c:when test="${auth=='A'}">
		<title>ROOMDY(관리자)</title>
	</c:when>
	<c:when test="${auth=='S'}">
		<title>ROOMDY(판매자)</title>
	</c:when>
	<c:otherwise>
		<title>ROOMDY</title>
	</c:otherwise>
</c:choose>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<link href="${contextPath}/css/layout.css" rel="stylesheet" type="text/css" media="all">
<link href="${contextPath}/css/roomdy.css" rel="stylesheet" type="text/css" media="all">
<!-- jquery 1.7.2 ver min -->
<script src="${contextPath}/scripts/jquery.min.js"></script>
</head>
<body id="top">
	<!-- ################################################################################################ -->
	<!-- Top Background Image Wrapper -->
	<c:choose>
		<c:when test="${auth=='A'}">
			<jsp:include page="../include/adminHeader.jsp" />
		</c:when>
		<c:when test="${auth=='S'}">
			<jsp:include page="../include/sellerHeader.jsp" />
		</c:when>
		<c:otherwise>
			<jsp:include page="../include/header.jsp" />
		</c:otherwise>
	</c:choose>
	<!-- End Top Background Image Wrapper -->
	<!-- ################################################################################################ -->
	<jsp:include page="${center}" />
	<!-- ################################################################################################ -->
	<jsp:include page="../include/footer.jsp" />
	<!-- JAVASCRIPTS -->
	<jsp:include page="../include/scripts.jsp" />
</body>
</html>