<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}"></c:set>
<%
	//한글 처리
	request.setCharacterEncoding("UTF-8");
%>

<div class="hoc container clear">
	<h1>주문 상세 조회</h1>
	<table class="content">
		<tr>
			<th>주문번호</th>
			<th colspan="7">${param.orderNo}</th>
		</tr>
		<tr class="center">
			<td width="7%">상품이름</td>
			<td width="7%">가격</td>
			<td width="7%">제작진행</td>
			<td width="7%">배송상태</td>
			<td width="2%">수량</td>
			<td width="7%">제작완료예상일</td>
			<td width="7%">주문옵션</td>
			<td width="7%">후기 작성</td>
		</tr>
		<c:choose>
			<c:when test="${orderItemList == null}">
				<tr>
					<td colspan="8">
						상세 주문 목록이 없습니다. 관리자에게 문의해주세요.
						<a href="${contextPath}/board/csCenterPage.do?postCate=qna">1:1 문의로 이동</a>
					</td>
				</tr>
			</c:when>
			<c:when test="${orderItemList != null}">
				<c:forEach items="${orderItemList}" var="orderItem">
					<tr class="center">
						<td width="7%">${orderItem.itemBean.itemname}</td>
						<td width="7%">${orderItem.itemBean.cost}</td>
						<td width="7%">
							<c:if test="${orderItem.orderItemBean.manuProc >= 100}">
					제작이 완료되었습니다.
				</c:if>
							<c:if test="${orderItem.orderItemBean.manuProc < 100}">
					${orderItem.orderItemBean.manuProc}%
				</c:if>
						</td>
						<td width="7%">
							<c:if test="${orderItem.orderItemBean.shipProc == null}">
							배송 전 입니다.
							</c:if>
							<c:if test="${orderItem.orderItemBean.shipProc != null}">
								<p id='${orderItem.itemBean.itemno }'></p>
								<a class='initDisplayNone' href="https://tracker.delivery/#/${orderItem.orderItemBean.parcel}/${orderItem.orderItemBean.waybill}" onclick='window.open(this.href,"배송조회","width=650,height=800"); return false'>배송조회</a>

								<script type="text/javascript">
										$.get(
											"https://apis.tracker.delivery/carriers/${orderItem.orderItemBean.parcel}/tracks/${orderItem.orderItemBean.waybill}",		
											data=>{
												console.log(data)
												const res=Object.values(data).find(x=>x.text==='배달완료')
												if(!res) {	//배달완료 상태가 아니면 이 if문 들어옴
													const res2=Object.values(data).find(x=>x.text==='상품이동중' || x.text==='상품인수' || x.text==='배송출발')
													console.log(res2)
													if(res2){	//한번더 if문으로 배송중이 아니면 배송준비중 띄움
														$('#${orderItem.itemBean.itemno }').text('배송중')
													}else{
														$('#${orderItem.itemBean.itemno }').text('배송준비중')
													}
												}else{
													//배송 완료시 구매확정 버튼 띄우기
													$('#${orderItem.itemBean.itemno }').text('배달완료')
													
												}
												
												$('#${orderItem.itemBean.itemno }').next().removeClass('initDisplayNone');
											}
										)
									</script>
							</c:if>
						</td>
						<td width="2%">${orderItem.orderItemBean.orderamount}</td>
						<td width="7%">
							<fmt:formatDate value="${orderItem.orderItemBean.dueDate}" pattern="yyyy.MM.dd" />
						</td>
						<td width="7%">
							<p id='itemno_${orderItem.itemBean.itemno }'></p>

							<script type="text/javascript">
							opt='${orderItem.orderItemBean.orderOpt}'
							
							optArray=JSON.parse(opt)
							for(const opt of optArray){
								$('#itemno_${orderItem.itemBean.itemno }').append(opt.optName+'/'+opt.optAmount+'개<br>')	
							}
						</script>
						</td>
						<td width="7%" class="paddingLe3">
							<c:choose>
								<c:when test="${orderItem.orderItemBean.reviewNo == 0}">
									<a href="${contextPath}/board/writeReview.do?orderNo=${param.orderNo}&itemName=${orderItem.itemBean.itemname}">
										<button type="button">후기 작성</button>
									</a>
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

			</c:when>
		</c:choose>
	</table>
</div>
