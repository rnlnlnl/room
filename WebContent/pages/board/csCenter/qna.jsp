<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:if test="${memberId==null}">
	<script type="text/javascript">
		alert("1:1 문의는 로그인 후 이용해주세요.");
		window.history.back();
	</script>
</c:if>

<c:set var="page" value="${param.page}" />
<c:if test="${page==null}">
	<c:set var="page" value="1" />
</c:if>

<h1 class="noticeTitle">1:1 문의</h1>
<c:if test="${memberId != null }">
	<div class="buttonPoLe">
		<a href="${contextPath}/board/postWirtePage.do?postCate=qna">
			<button class="buttonLeft" type="button">문의하기</button>
		</a>
	</div>
</c:if>
<div id="qna" class="hoc container1 clear">
	<table class="content">
		<tr class="listMemberTr">
			<td class="listTd3 list">번 호</td>
			<td class="listTd3">종 류</td>
			<td class="listTd10">제 목</td>
			<td class="listTd8">작성일</td>
		</tr>
		<c:choose>
			<c:when test="${empty postList}">
				<tr>
					<td colspan="4" class="noteNothing">문의 없음</td>
				</tr>
			</c:when>
			<c:when test="${postList != null}">
				<c:forEach var="post" items="${postList}">
					<tr class="listCenter"
						onclick="location.href='${contextPath}/board/readPost.do?postno=${post.postno}&postCate=${param.postCate}&page=${page}'">
						<td>${post.postno}</td>
						<td>${post.noticecate}</td>
						<td class="Centernone">${post.title}</td>
						<td><fmt:formatDate value="${post.writedate}"
								pattern="yyyy.MM.dd" /></td>
					</tr>
				</c:forEach>
			</c:when>
		</c:choose>
	</table>
</div>


<div id="page_control" align="center">
	<c:if test="${pageCount>1}">
		<c:if test="${startPage>pageBlock}">
			<a
				href="${contextPath}/board/csCenterPage.do?postCate=qna&page=${startPage-pageBlock}">이전</a>
		</c:if>
		<c:forEach begin="${startPage}" end="${endPage}" var="i">
			<a
				href="${contextPath}/board/csCenterPage.do?postCate=qna&page=${i}">[${i}]</a>
		</c:forEach>
		<c:if test="${endPage<pageCount}">
			<a
				href="${contextPath}/board/csCenterPage.do?postCate=qna&page=${startPage+pageBlock}">다음</a>
		</c:if>
	</c:if>
</div>