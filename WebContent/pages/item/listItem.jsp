<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />
<div class="hoc container clear">
	<table id="sellerItemList"  class="content">
		<tr class="tableLineSo listMemberTr">
			<th>상품번호</th>
			<th>상품이름</th>
			<th>상품이미지</th>
			<th>상품 카테고리</th>
			<th>수량</th>
			<th>금액</th>
			<th>관심수</th>
			<c:if test="${auth eq 'A' or auth eq 'a'}"><th>판매자</th></c:if>
		</tr>
		<c:forEach items="${itemList}" var="item">
			<c:if test="${item.isUse=='false'}">
				<tr style="background-color: #333;">
			</c:if>
			<c:if test="${item.isUse!='false'}">
				<tr>
			</c:if>
				<td>${item.itemno}</td>
				<td><a href="${contextPath}/item/readItem.do?itemNo=${item.itemno}">${item.itemname}</a></td>
				<td>
					<img alt="상품사진" src="../css/images/upload/itemImg/${item.itemImg}" width="300px">
				</td>
				<td>${item.itemCate}</td>
				<td>${item.amount}</td>
				<td>${item.cost}</td>
				<td>${item.heart}</td>
				<c:if test="${auth eq 'A' or auth eq 'a'}"><td>${item.seller}</td></c:if>
		</c:forEach>
	</table>
</div>
