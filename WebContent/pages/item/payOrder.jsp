<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />
<div class="hoc container clear">
	<h1>상품 결제 페이지</h1>
	<div class="content">
		<form action="${contextPath}/item/order.do" method="post">
		<c:set var="totalCost" value="0"/>
		<c:forEach items="${selectedItemList}" var="selectedItem">
			<input type="hidden" name="itemNo" value='${selectedItem.itemBean.itemno}'>
			<input type="hidden" name="opt" value='${selectedItem.optList}'>
			<input type="hidden" name="cartamount" value='${selectedItem.cartBean.cartamount}'>
	
			<table>
				<tr class="postFontSizeTi bold">
					<td rowspan="4">
					<img alt="" src="${contextPath}/css/images/upload/itemImg/${selectedItem.itemBean.itemImg}">
					</td>
					<td>${selectedItem.itemBean.seller}</td>
					<td>${selectedItem.itemBean.itemname}</td>
					<td>
					<c:if test="${not empty selectedItem.optList }">
						<c:forEach var="opt" items="${selectedItem.optList}">
						${opt.optName} ${opt.optAmount}개 |
					</c:forEach>
					</c:if>
					</td>
					<td>${selectedItem.cartBean.cartamount}개</td>
					<td>${selectedItem.itemBean.cost}개</td>
					<c:set var="totalCost" value="${totalCost+selectedItem.itemBean.cost}"/>
				</tr>
			</table>
			<hr>
		</c:forEach>
	
	
		<table>
			<tr>
				<td colspan="6">
					 <button type="button" id="addrLodeBtn">저장된 정보로 주문하기</button>
				</td>
			</tr>
			<tr>
				<td rowspan="2">배송지정보</td>
				<td>수취인</td>
				<td>
					<input type="text" name="recipient">
				</td>
				<td>연락처</td>
				<td>
					<input type="tel" name="recphone">
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td >주소</td>
				<td><input type="number" name="reczipcode" id="reczipcode">
				<td><input type="button" onclick="sample6_execDaumPostcode()" class="btn" value="주소검색"></td>
				<td><input type="text" name="recaddr1" id="recaddr1"></td>
				<td><input type="text" name="recaddr2" id="recaddr2"></td>
			</tr>
			
			<tr>
				<td>결제 종류</td>
				<td colspan="5">
					<select name="pay">
						<option value="카드">카드</option>
						<option value="상품권">상품권</option>
						<option value="휴대전화 결제">휴대전화 결제</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>총 결제 금액  </td>
				<td>${totalCost }원</td>
				<td colspan="4"><button type="submit">구매하기</button></td>
			</tr>
		</table>
		
		
		
		</form>	
	</div>
</div>

<script type="text/javascript">
	$("#addrLodeBtn").click(function() {
		$("input[name='recipient']").val('${buyerInfo.name}');
		$("input[name='reczipcode']").val('${buyerInfo.zipcode}');
		$("input[name='recaddr1']").val('${buyerInfo.addr1}');
		$("input[name='recaddr2']").val('${buyerInfo.addr2}');
	});
	
	function sample6_execDaumPostcode() {
	    new daum.Postcode({
	        oncomplete: function(data) {
	            var addr = ''; // 주소 변수
	            var extraAddr = ''; // 참고항목 변수
	
	            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                addr = data.roadAddress;
	            } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                addr = data.jibunAddress;
	            }
	
	            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
	            if (data.userSelectedType === 'R') {
	                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
	                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
	                if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
	                    extraAddr += data.bname;
	                }
	                // 건물명이 있고, 공동주택일 경우 추가한다.
	                if (data.buildingName !== '' && data.apartment === 'Y') {
	                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                }
	                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
	                if (extraAddr !== '') {
	                    extraAddr = ' (' + extraAddr + ')';
	                }
	
	            }
	
	            // 우편번호와 주소 정보를 해당 필드에 넣는다.
	            document.getElementById('reczipcode').value = data.zonecode;
	            document.getElementById('recaddr1').value = addr;
	            // 커서를 상세주소 필드로 이동한다.
	            document.getElementById('recaddr2').focus();
	        }
	    }).open();
	}
</script>















