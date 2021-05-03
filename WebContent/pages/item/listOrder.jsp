<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />


<div class="hoc container clear">
<h1>주문내역</h1>
<table class="content">
	<tr class="tableLineSo listMemberTr">
		<td class="listTd7">주문번호</td>
		<td class="listTd7">주문자</td>
		<td class="listTd7">주문날짜</td>
	</tr>
	<c:choose>
		<c:when test="${orderList==null}">
			<tr>
				<td colspan="5">주문내역이 없습니다.</td>
			</tr>
		</c:when>
		<c:when test="${orderList !=null}">
			<c:forEach var="orderbean" items="${orderList}">
				<tr class="wordPoCen">
					<td>
						<a href="${contextPath}/item/readOrderItem.do?orderNo=${orderbean.orderno}">${orderbean.orderno}</a>
					</td>
					<!-- 해당주문번호 상세리스트 -->
					<td>${orderbean.orderer}</td>
					<td>${orderbean.orderdate}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
</div>
