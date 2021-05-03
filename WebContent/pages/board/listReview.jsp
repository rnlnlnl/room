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
<div class="hoc container clear">
	<h1>&nbsp;</h1>
	<table class="content">
		<tr class="listMemberTr ">
		<td class="listTd3">No</td>
		<td class="listTd5">제 목</td>
		<td class="listTd6">작성자</td>
		<td class="listTd5">별 점</td>
		<td class="listTd6">작성일</td>
		<td class="listTd6">조회수</td>
		</tr>
		<c:choose>
			<c:when test="${postList == null}">
				<tr>
					<td colspan="4">후기 없음</td>
				</tr>
			</c:when>
			<c:when test="${postList != null}">
				<c:forEach var="review" items="${postList}">
					<tr class="listCenter" onclick="location.href='${contextPath}/board/readReview.do?postno=${review.postno}'">
						<td class="listTd4">${review.postno}</td>
						<td class="listTd20 Centernone">${review.title}</td>
						<td class="listTd10">${review.writer}</td>
						<td>
							<ul class="starrating">
								<c:forEach begin="1" end="${review.scope}" var="i">
									<li>
										<i class="fa coloured fa-star"></i>
									</li>
								</c:forEach>
								<c:forEach begin="1" end="${5-review.scope}" var="i">
									<li>
										<i class="fa fa-star-o"></i>
									</li>
								</c:forEach>
							</ul>
						</td>
						<td  class="Centernone">
							<fmt:formatDate value="${review.writedate}" pattern="yyyy.MM.dd" />
						</td>
						<td class="listTd4">${review.viewScope}</td>
					</tr>
				</c:forEach>
			</c:when>
		</c:choose>
	</table>
</div>

	

<div id="page_control" align="center">
	<c:if test="${startPage>pageBlock}">
		<a href="${contextPath}/board/listReview.do?page=${startPage-pageBlock}">이전</a>
	</c:if>
	<c:forEach begin="${startPage}" end="${endPage}" var="i">
		<a href="${contextPath}/board/listReview.do?page=${i}">[${i}]</a>
	</c:forEach>
	<c:if test="${endPage<pageCount}">
		<a href="${contextPath}/board/listReview.do?page=${startPage+pageBlock}">다음</a>
	</c:if>
</div>
