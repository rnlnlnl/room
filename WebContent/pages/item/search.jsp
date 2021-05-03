<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />


<c:set var="itemList" value="${searchMap.itemList}" />
<c:set var="boardList" value="${searchMap.boardList}" />

</head>
<body>

<div class="hoc container clear">
	<c:if test="${param.searchText == null}">
		<h1>검색어가 입력되지 않았습니다.</h1>
	</c:if>
	<div class="content">
		<h4 align="right">${fn:length(itemList)}개검색 됨</h4>
		<h2 align="center">상품에 관한 검색결과</h2>
		<div>
			<c:choose>
				<c:when test="${itemList == null }">
					<p>검색하신 상품이 없습니다.</p>
				</c:when>
				<c:when test="${itemList != null }">
					<c:forEach var="item" items="${itemList}" varStatus="i">
						<table >
							<tr>
								<td class="listTd10"><a href="${contextPath}/item/readProduct.do?itemNo=${item.itemno}"></a></td>
								<td class="listTd20"><a href="${contextPath}/item/readProduct.do?itemNo=${item.itemno}"><span>${item.itemname}</span></a></td>
								<td class="listTd30"><a href="${contextPath}/item/readProduct.do?itemNo=${item.itemno}"><img src="${contextPath}/css/images/upload/itemImg/${item.itemImg}" class="searchImgSize"></a></td>
								<td class="listTd15"><a href="${contextPath}/item/readProduct.do?itemNo=${item.itemno}"><span>${item.seller}</span></a></td>
								<td class="listTd15"><a href="${contextPath}/item/readProduct.do?itemNo=${item.itemno}"><span>${item.cost}원</span></a></td>
							</tr>
						</table>
						<hr class="hrMargin10">
					</c:forEach>
				</c:when>
			</c:choose>
		</div>
	</div>
	<div>
		<hr class="hrMargin10">
		<h4 align="right">${fn:length(boardList)}개검색 됨</h4>
		<h2 align="center">글에 관한 검색결과</h2>
		<div>
			<c:choose>
				<c:when test="${boardList == null }">
					<p>검색하신 글이 없습니다.</p>
				</c:when>
				<c:when test="${boardList != null }">
					<c:forEach var="board" items="${boardList }">
						<div>
							<a href="${contextPath}/board/readPost.do?postno=${board.postno}&postCate=${board.postcate}">${board.title}-${board.writer}</a>
							<hr class="hrMargin10">
						</div>
					</c:forEach>
				</c:when>
			</c:choose>
		</div>
		<%-- <div>
			<h4>Best 상품</h4>
			<c:choose>
				<c:when test="${auth == null}">
					roomdy 상품 중 가장 인기가 많은 5가지 상품입니다.
					<c:forEach var="item" items="${styleItemList}">
						<div>
							<a href="${contextPath}/item/readProduct.do?itemNo=${item.itemno}">
								<span>${item.itemname}</span>
								<!-- 상품페이지가 없어서 확인 못함 -->
								<img src="${contextPath}/css/images/upload/itemImg/${item.itemImg}">
								<!-- 상품 이미지  -->
								<span>${item.seller}</span>
								<span>${item.cost}원</span>
							</a>
							<hr>
						</div>
					</c:forEach>
				</c:when>
				<c:when test="${auth != null}">
					고객님의 취향에 맞는 상품 중 현재 가장 인기가 많은 5가지 상품입니다.
					<c:forEach var="item" items="${styleItemList}">
						<div>
							<a href="${contextPath}/item/readProduct.do?itemNo=${item.itemno}">
								<span>${item.itemname}</span>
								<!-- 상품페이지가 없어서 확인 못함 -->
								<img src="${contextPath}/css/images/upload/itemImg/${item.itemImg}">
								<!-- 상품 이미지  -->
								<span>${item.seller}</span>
								<span>${item.cost}원</span>
							</a>
							<hr>
						</div>
					</c:forEach>
				</c:when>
			</c:choose>
		</div> --%>
	</div>
</div>

	

</body>
</html>