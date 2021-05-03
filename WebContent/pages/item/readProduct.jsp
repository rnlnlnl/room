<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<c:set var="itemBean" value="${itemInfo.itemBean}" />
<c:set var="options" value="${itemInfo.options}" />

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<script>
	var selOpt = [];
	var totalCost = 0;
	
	$(function() {
		totalCost = ${itemBean.cost};
		
		
		$("#totalCost span").text(totalCost);
		
		$("#itemAmount").change(function(){
			var amount = $(this).val();
			
			var totalCost = Number($("#totalCost span").text());

			totalCost = amount*${itemBean.cost};
			
			$("#totalCost span").text(totalCost);
		});
	})

	function add_option() {
		var selOptNo = $("#optionSelect option:selected").val();
		var total = $("#totalCost span").text();

		if (selOptNo == "delAllOpt") {
			selOpt = [];
			total = ${itemBean.cost};
			$("#totalCost span").text(total);
			$(".addOpt").remove();
		}else{
			if (selOpt.indexOf(selOptNo) < 0) {
				selOpt.push(selOptNo);

				var oriSelOption = $("#optionSelect option:selected").text();
				var subSelOpName = oriSelOption.substr(0, oriSelOption.indexOf("("));
				var subSelOpCost = oriSelOption.substring(oriSelOption.indexOf("+") + 1, oriSelOption.indexOf("원"));

				total = eval(total+ "+"+ subSelOpCost);
				
				$("#totalCost span").text(total);

				$("#calDiv>table")
						.append(
								"<tr class='addOpt' otpNo='"+selOptNo+"'>"
										+ "<td>" + subSelOpName + "</td>"
										+ "<td>" + subSelOpCost + "</td>"
										+ "<td>"
											+ "<input name='optAmount' type='number' value='1' min='1'>"
											+ "<input name='optName' type='hidden' value='" + subSelOpName + "'>"
											+ "<input name='optCost' type='hidden' value='" + subSelOpCost + "'>"
											
										+ "</td>"
										+ "<td>"
										+ "<button type='button' onclick='delOpt(this)'>옵션 삭제</button>"
										+ "</td>" + "</tr>");
			} else {
				alert("이미 선택한s 옵션입니다. 더 많은 수량이 필요하면 수량을 조절해주세요.");
			}
		}
	}

	function delOpt(btn) {
		var optNo = $(btn).parent().parent().attr("otpNo");
		var optCost = $(btn).parent().parent().children().eq(1).text();

		var total = $("#totalCost span").text();
		
		total = total - optCost;
		$("#totalCost span").text(total);
		
		var tr = $(btn).parent().parent();
		tr.remove();

		var idx = selOpt.indexOf(optNo);
		if (idx > -1)
			selOpt.splice(idx, 1)
	}

	function order() {
		if("${memberId}"==''){
			alert('로그인 후 이용해주세요.');
		}else{
			$("#productForm").attr("action", "${contextPath}/item/orderPage.do");
			$("#productForm").submit();
		}
	}
	
	function cart() {
		if("${memberId}"==''){
			alert('로그인 후 이용해주세요.');
		}else{
			var optNameList = new Array();
			var optCostList = new Array();
			var optAmountList = new Array();
			
			 $("input[name=optName]").each(function(index, item){
				 optNameList.push($(item).val());
			   });
			 $("input[name=optCost]").each(function(index, item){
				 optCostList.push($(item).val());
			   });
			 $("input[name=optAmount]").each(function(index, item){
				 optAmountList.push($(item).val());
			   });

			$.ajax({
				type: "post",
				url: "${contextPath}/item/addCart.do",
				traditional : true,
				data: ({
					itemNo : ${itemBean.itemno},
					amount : $("input[name=amount]").val(),
					itemColor : $("input[name=itemColor]").val(),
					optNames : optNameList,
					optCosts : optCostList,
					optAmounts : optAmountList
				}),
				dataType: "text",
				success: function(result) {
					var goCartList;
					if(result<0){
						goCartList = confirm("이미 장바구니에 담겨있는 상품입니다. 장바구니에서 수정해주세요.\n확인 버튼을 누르면 장바구니로 이동합니다.");
					}else if(result==0){
						alert('장바구니 추가에 실패했습니다. 다시 시도해주세요.');
					}else{
						goCartList = confirm('장바구니에 추가 되었습니다. 장바구니로 이동하시겠습니까?');
					}
					
					if(goCartList == true){
						window.location.href='${contextPath}/item/cartList.do';
					}
				}
		    });
		}
	}
</script>

<div class="hoc container clear">
	<div class="content">
		<form id="productForm" method="post">
			<img id="itemImg" alt="itemImg" src="${contextPath}/css/images/upload/itemImg/${itemBean.itemImg}" width="320px">
			<div id="itemRight">
				<div id="itemInfo">
					<table id="itemInfoTable">
						<tr>
							<th class="bold" colspan="4">${itemBean.itemname}<small>(판매 : ${itemBean.seller})</small> <input type="hidden" name="itemNo" value="${itemBean.itemno}">

							</th>
						</tr>
						<tr>
							<td class='listTd20 right bold'>카테고리</td>
							<td class='listTd30'>${itemBean.itemCate}</td>
							<td class='listTd20 right bold'>스타일</td>
							<td class='listTd30'>${itemBean.style}</td>
						</tr>
						<tr>
							<td class='right bold'>색상</td>
							<td>${itemBean.itemColor}</td>
							<td class='right bold'>선호연령</td>
							<td>${itemBean.preferage}세</td>
						</tr>
						<tr>
							<td colspan="4">
								<hr>
							</td>
						</tr>
						<tr>
							<td class='right'>가격</td>
							<td class="bold">${itemBean.cost}원</td>
							<td class='right'>수량</td>
							<td>
								<input id='itemAmount' type="number" name="amount" value="1" min="1">
							</td>
						</tr>
					</table>

					<hr>

					<c:if test="${not empty options}">
						<table id="itemOptTable">
							<tr>
								<td class="right bold">옵션</td>
								<td>
									<select id="optionSelect" onchange="add_option()">
										<option selected="selected" value="delAllOpt">옵션 선택 안함</option>
										<c:forEach items="${options}" var="option">
											<option value="${option.optNo}">${option.optName}(+${option.optCost}원)</option>
										</c:forEach>
									</select>
								</td>
							</tr>

							<tr>
								<td colspan="2">
									<div id="calDiv">
										<table class='borderedbox'>
											<tr class='pointBackColor center'>
												<td class='listTd30'>옵션 이름</td>
												<td class='listTd30'>옵션 가격</td>
												<td class='listTd20'>옵션 수량</td>
												<td class='listTd20'>옵션 삭제</td>
											</tr>
										</table>
									</div>
								</td>
							</tr>
						</table>
					</c:if>



					<div id="totalCost" class='right'>
						<h4>
							총액 :
							<span></span>
							원
						</h4>
					</div>
				</div>
				<div class="inline itemBtnBox right">
					<input type="hidden" name="isDirect" value="direct">
					<button type="button" onclick="order()">바로구매</button>
					<button type="button" onclick="cart()">장바구니</button>

					<a href="${contextPath}/item/readItem.do?itemNo=${itemBean.itemno}">
						<button type="button" class="initDisplayNone">취소하기</button>
					</a>
					<a href="${contextPath}/item/itemShowroom.do">
						<button type="button" style="margin: 0">목록으로</button>
					</a>
				</div>
			</div>
		</form>




		<hr style="height: 20px;">

		<h1>상품후기</h1>
		<c:choose>
			<c:when test="${empty reviewList}">
				<div class="noReview">등록된 후기가 없습니다.</div>
			</c:when>
			<c:otherwise>
				<c:forEach items="${reviewList}" var="review">
					<div class="reviewBox center imgBox">
						<div class="imgBox" style="background-image: url('${contextPath}/css/images/upload/boardUpload/${review.fileSrc}');"></div>
						<div class="textBox">
							<div class="inline">
								<p>${review.boardBean.scope}</p>
								<p>${review.boardBean.writer}</p>
								<p>${review.boardBean.writedate}</p>
							</div>
							<p>
								<a href="${contextPath}/board/readReview.do?postno=${review.boardBean.postno}">${review.boardBean.title}</a>
							</p>
						</div>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</div>
</div>