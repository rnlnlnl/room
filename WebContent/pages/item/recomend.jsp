<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<div class="recomendTable">
	<h4 class="bestProduct">
		추천 상품 <i class="fa fa-thumbs-o-up"></i>
	</h4>
	<div class="content">
		<c:choose>
			<c:when test="${auth == null}">
				<!-- 로그인 안했을때 추천상훔 -->
				<h4>현재 ROOMDY에서 가장 HOT한 ${fn:length(styleItemList)}개의 상품입니다.</h4>
			</c:when>
			<c:when test="${auth != null}">
				<h4>고객님의 취향에 맞는 상품 중 현재 가장 인기가 많은 ${fn:length(styleItemList)}개의 상품입니다.</h4>
			</c:when>
		</c:choose>

		<div class='itemList'>
			<c:forEach var="item" items="${styleItemList }" varStatus="i">
				<div class='itemDivRecomend <c:if test="${i.index%5==0}">first</c:if>'>
					<a href="${contextPath}/item/readProduct.do?itemNo=${item.itemno}">
						<img src="${contextPath}/css/images/upload/itemImg/${item.itemImg}">
					</a>
					<br>
					<div class='itemInfoDiv'>
						<div class='nameRecomend'>${item.itemname}</div>
						<br>
						<span>판매자: ${item.seller}</span>
						<br>
						<span>가격: ${item.cost}원</span>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>
</div>
