<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<div class="joinPageForm">
	<div class="content">
	<img alt="success" src="${contextPath}/css/imgLogo/success.png">
	
	<div class="hoc center">
	<h1>&nbsp;</h1>
		<h2>${memberId}님 주문이 성공적으로 완료되었습니다.</h2>
		<br>
		
		<a href='${contextPath}/item/listOrder.do'>주문 목록 확인<i class="fa fa-shopping-cart"></i></a><br>
		<a href="${contextPath}/item/productList.do">다른 상품 살펴보기<i class="fa fa-angle-double-right"></i></a>
		</div>
	</div>
</div>
