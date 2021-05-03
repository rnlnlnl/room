<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}"></c:set>
<%
	//한글 처리
	request.setCharacterEncoding("UTF-8");
%>
<div class="tableForm">
	<!-- 판매자 메인 페이지 -->
	<h1 class='bold inspace-30'>최근 주문 들어온 상품 3개</h1>
	<table>
		<tr class="tableLineSo wordPoCen">
			<td class="listTd6">주문번호</td>
			<td class="listTd6">주문자</td>
			<td class="listTd6">상품명</td>
			<td class="listTd10">제작상태</td>
			<td class="listTd7">제작예정일</td>
			<td class="listTd8">배송상태</td>
			<td class="listTd4">주문수량</td>
			<td class="listTd10">주문옵션</td>
			<td class="listTd10">후기확인</td>
		</tr>
		<c:choose>
			<c:when test="${listSoldItem == null}">
				<tr>
					<td colspan="8">주문된 상품이 없습니다.</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${listSoldItem}" var="orderItem">
					<tr class="center">
						<td>${orderItem.orderBean.orderno}</td>
						<td>${orderItem.orderBean.orderer}</td>
						<td>${orderItem.itemBean.itemname}</td>
						<td>
							<button type="button" class="viewDueDateBtn oderDay">제작 예정일 변경</button>
							<div class="modDueDateDiv initDisplayNone">
								<input type="date" name="dueDate">
								<input type="hidden" value="${orderItem.itemBean.itemno}">
								<a class="modDueDateBtn">변경</a>
							</div>
							<c:if test="${orderItem.orderItemBean.manuProc >= 100}">
								제작 예정d일이 완료되었습니다.
							</c:if>
							<c:if test="${orderItem.orderItemBean.manuProc < 100}">
						${orderItem.orderItemBean.manuProc}%
						</c:if>
						</td>
						<td>
							<fmt:formatDate value="${orderItem.orderItemBean.dueDate}" pattern="yyyy.MM.dd" />
						</td>
						<td>
							<c:if test="${orderItem.orderItemBean.shipProc == null}">
								<p>배송 전 입니다.</p>
								<a class="btn" href='${contextPath}/item/addWaybillPopup.do?orderNum=${orderItem.orderBean.orderno}&itemNum=${orderItem.itemBean.itemno}'
									onclick='window.open(this.href,"운송장 번호입력","width=500,height=200"); return false'
								>
									<button type="button" class=''>운송장 등록</button>
								</a>
							</c:if>
							<c:if test="${orderItem.orderItemBean.shipProc != null}">
								<p>${orderItem.orderItemBean.shipProc}</p>
								<a class="btn" href='${contextPath}/item/addWaybillPopup.do?orderNum=${orderItem.orderBean.orderno}&itemNum=${orderItem.itemBean.itemno}'
									onclick='window.open(this.href,"운송장 수정","width=500,height=200"); return false'
								>
									<button type="button" class=''>운송장 수정</button>
								</a>
							</c:if>
						</td>
						<td class="wordPoCen">${orderItem.orderItemBean.orderamount}</td>

						<td>
							<p id='itemno_${orderItem.itemBean.itemno }'></p>

							<script type="text/javascript">
							opt='${orderItem.orderItemBean.orderOpt}'
							
							optArray=JSON.parse(opt)
							for(const opt of optArray){
								$('#itemno_${orderItem.itemBean.itemno }').append(opt.optName+'/'+opt.optAmount+'개<br>')	
							}
						</script>
						</td>
						<td>
							<c:choose>
								<c:when test="${orderItem.orderItemBean.reviewNo == 0}">
									후기가 등록되지 않았습니다.
								</c:when>
								<c:otherwise>
									<a href="${contextPath}/board/readPost.do?postno=${orderItem.orderItemBean.reviewNo}&postCate=review">
										<button type="button">후기 보기</button>
									</a>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
</div>