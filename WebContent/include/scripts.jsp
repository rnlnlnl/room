<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<!-- 기본으로 사용되는 script -->

<!-- 페이지에서 top 버튼을 누르면 페이지 상단으로 이동되는 script -->
<script src="${contextPath}/scripts/jquery.backtotop.js"></script>

<!-- 모바일 버전 호환되게 하는 script -->
<script src="${contextPath}/scripts/jquery.mobilemenu.js"></script>

<!-- IE9 Placeholder Support : input 태그의 placeholder 속성이 호환되지 않는 웹브라우저에서 호환가능하도록 하는 script -->
<script src="${contextPath}/scripts/jquery.placeholder.min.js"></script>

<!-- 카카오 우편번호 api -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<!-- 쿠키 관리 api -->
<script src="https://cdn.jsdelivr.net/npm/js-cookie@2/src/js.cookie.min.js"></script>

<!-- fas icon 사용 api -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css" />