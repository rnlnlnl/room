<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<c:if test="${param.postCate == null}">
	<c:set var="postCate" value="notice.jsp" />
</c:if>
<c:if test="${param.postCate != null}">
	<c:set var="postCate" value="${param.postCate}.jsp" />
</c:if>

<br><br>
 <div id="section" class="csCenter">
   <div class="one_third first">
		<a href="${contextPath}/board/csCenterPage.do?postCate=notice">공지사항</a>
   </div>
   <div class="one_third">
		<a href="${contextPath}/board/csCenterPage.do?postCate=faq">자주 묻는 질문</a>
    </div>
   <div class="one_third">
		<a href="${contextPath}/board/csCenterPage.do?postCate=qna">1:1문의</a>
   </div>
 <%--  <div class="one_quarter">
		<a href="${contextPath}/board/csCenterPage.do?postCate=refund">환불 및 교환 신청</a>
  </div> --%>
 </div>

<jsp:include page="csCenter/${postCate}" />