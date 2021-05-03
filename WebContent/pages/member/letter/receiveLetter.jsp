<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- JSTL의 CORE라이브러리에 속한 태그들을 사용 하기 위해 링크 작성 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%-- 컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:choose>
	<c:when test="${param.page == null}">
		<c:set var="page" value="1" />
	</c:when>
	<c:otherwise>
		<c:set var="page" value="${param.page}" />
	</c:otherwise>
</c:choose>
<table>
	<tr>
		<th><input type="checkbox" class="allCheck"></th>
		<th>보낸 사람</th>
		<th>제목</th>
		<th>날짜</th>
	</tr>
	<c:choose>
		<c:when test="${empty letterList}">
			<tr>
				<td colspan="4">받은 쪽지가 없습니다.</td>
			</tr>
		</c:when>
		<c:when test="${not empty letterList}">
			<c:forEach var="letter" items="${letterList}">
				<tr <c:if test="${!letter.isread}">class='bold'</c:if>>
					<td>
						<input type="checkbox" name='letterNo' value='${letter.letterno}'>
					</td>
					<td>
						<a href='${contextPath}/member/readLetter.do?letterNo=${letter.letterno}&rs=r&page=${page}'>${letter.sender}</a>
					</td>
					<td>
						<a href='${contextPath}/member/readLetter.do?letterNo=${letter.letterno}&rs=r&page=${page}'>${letter.title}</a>
					</td>
					<td>
						<a href='${contextPath}/member/readLetter.do?letterNo=${letter.letterno}&rs=r&page=${page}'><fmt:formatDate value="${letter.senddate}" pattern="yy/MM/dd a hh:mm" /></a>
					</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table> 

<div id="page_control" align="center">
	<c:if test="${startPage>pageBlock}">
		<a href="${contextPath}/member/letterPage.do?letterCenter=receiveLetter&page=${startPage-pageBlock}"><i class="fa fa-angle-double-left"></i></a>
	</c:if>
	<c:if test="${page != 1}">
		<a href="${contextPath}/member/letterPage.do?letterCenter=receiveLetter&page=${page-1}"><i class="fa fa-angle-left"></i></a>
	</c:if>
	<c:forEach begin="${startPage}" end="${endPage}" var="i">
		<a href="${contextPath}/member/letterPage.do?letterCenter=receiveLetter&page=${i}">[${i}]</a>
	</c:forEach>
	<c:if test="${page != pageCount}">
		<a href="${contextPath}/member/letterPage.do?letterCenter=receiveLetter&page=${page+1}"><i class="fa fa-angle-right"></i></a>
	</c:if>
	<c:if test="${endPage<pageCount}">
		<a href="${contextPath}/member/letterPage.do?letterCenter=receiveLetter&page=${startPage+pageBlock}"><i class="fa fa-angle-double-right"></i></a>
	</c:if>
</div>

<div class="btnBox">
	<button type="button" class="letterDelBtn btn">삭제</button>
	<button type="button" class="closeBtn btn">닫기</button>
</div>