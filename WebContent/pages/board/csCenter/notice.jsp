<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:set var="page" value="${param.page}" />
<c:if test="${page==null}">
	<c:set var="page" value="1" />
</c:if>
<c:if test="${page==null}">
	<c:set var="page" value="1" />
</c:if>

<h1 class="noticeTitle">공지사항</h1>
<c:if test="${auth=='A' or auth =='a'}">
	<div class="buttonPoLe">
		<a href="${contextPath}/board/postWirtePage.do?postCate=notice">
			<button class="buttonLeft" type="button">공지작성</button>
		</a>
	</div>
</c:if>
<div class="hoc container1 clear">
<table class="content">
	<thead>
		<tr class="listMemberTr" >
			<td class="listTd3 list">번 호</td>
			<td class="listTd3">종 류</td>
			<td class="listTd10">제 목</td>
			<td class="listTd8">작성일</td>
			<td class="listTd3">조회수</td>
		</tr>
	</thead>
	<c:choose>
		<c:when test="${postList == null}">
			<tr>
				<td colspan="4" class="noteNothing">공지사항 없음</td>
			</tr>
		</c:when>
		<c:when test="${postList != null}">
			<c:forEach var="notice" items="${postList}">
				<tr class="listCenter" onclick="location.href='${contextPath}/board/readPost.do?postno=${notice.postno}&postCate=notice&page=${page}'">
					<td>${notice.postno}</td>
					<td>${notice.noticecate}</td>
					<td class="Centernone">${notice.title}</td>
					<td>
						<fmt:formatDate value="${notice.writedate}" pattern="yyyy.MM.dd" />
					</td>
					<td>${notice.viewScope}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
</div>



<div id="page_control" align="center">
	<c:if test="${pageCount>1}">
		<c:if test="${startPage>pageBlock}">
			<a href="${contextPath}/board/csCenterPage.do?postCate=notice&page=${startPage-pageBlock}">이전</a>
		</c:if>
		<c:forEach begin="${startPage}" end="${endPage}" var="i">
			<a href="${contextPath}/board/csCenterPage.do?postCate=notice&page=${i}">[${i}]</a>
		</c:forEach>
		<c:if test="${endPage<pageCount}">
			<a href="${contextPath}/board/csCenterPage.do?postCate=notice&page=${startPage+pageBlock}">다음</a>
		</c:if>
	</c:if>
</div>