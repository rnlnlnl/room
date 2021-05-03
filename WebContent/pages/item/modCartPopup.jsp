<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link href="${contextPath}/css/layout.css" rel="stylesheet" type="text/css" media="all">
<link href="${contextPath}/css/roomdy.css" rel="stylesheet" type="text/css" media="all">

</head>
<body>
	<div class="hoc container1 clear">
		<form id="modCartItemForm" action="${contextPath}/item/modCart.do" method="post">
			<input type="hidden" name="itemNo" value="${cartItem.itemBean.itemno}">
			<input type="hidden" name="itemAmount" value="${cartItem.cartBean.cartamount}">
			<input type="hidden" name="opts">

			<h4>주문 조건 수정</h4>
			<hr>
			<div class="wordPoCen">
				<p class="bold">${cartItem.itemBean.itemname}</p>
				<p>${cartItem.itemBean.cost}원</p>
				<img class="itemImg hoc" alt="상품사진" src="${contextPath}/css/images/upload/itemImg/${cartItem.itemBean.itemImg}">
			</div>

			<hr>

			<div>
				<c:set var="totalCost" value="0" />
				<table id="selectedOpt">
					<tr class='tableHeader'>
						<td>옵션</td>
						<td>옵션 감소</td>
						<td>옵션 증가</td>
					</tr>
					<c:forEach var="opt" items="${cartItem.optList}">
						<tr>
							<td>
								<input type="hidden" value='{"optName":"${opt.optName }","optCost":${opt.optCost },"optAmount":${opt.optAmount }} ' class='optJson'>
								옵션 ${opt.optName} - ${opt.optCost}원 수량
								<span class="optAmount">${opt.optAmount}</span>
								개
							</td>
							<td>
								<button type="button" class="minusOptBtn">
									<i class="fa fa-minus "></i>
								</button>
							</td>
							<td>
								<button type="button" class="plusOptBtn">
									<i class="fa fa-plus"></i>
								</button>
							</td>
						</tr>
						<c:set var="totalCost" value="${totalCost + (opt.optCost * opt.optAmount)}" />
					</c:forEach>
				</table>
			</div>
			<hr>
			<c:if test="${not empty optList}">
				<div class="inline">
					옵션추가 :

					<select id="optionSelect">
						<c:forEach var="opt" items="${optList}">
							<option value='{"optName":"${opt.optName}","optCost":${opt.optCost}}'>${opt.optName}+(${opt.optCost})원</option>
						</c:forEach>
					</select>

				</div>
			</c:if>
			<button type="button" id="motCartSubBtn" class=" hoc">상품 수정</button>
		</form>
	</div>


	<script type="text/javascript">
		$(function(){
			
			
			$("#motCartSubBtn").click(function(){
				var optArray = new Array();
				
				const inputs = $(".optJson").get();
				
				for(input of inputs){
					optArray.push(input.value);
				}

				$("input[name='opts']").val('[' + optArray + ']');
				
				var itemNo = $("input[name='itemNo']").val();
				var stringOptList = $("input[name='opts']").val(); 

				$.ajax({
			        type: "post",
			        url: "${contextPath}/item/modCart.do",
			        traditional : true,
			        data: {
			        	itemNo : itemNo,
			        	opts : stringOptList
			        },
			        dataType: "text",
			        success: function(result) {
			        	opener.parent.location.reload();
			        	window.close();
			        }
			    });
			});
			$(document).on("click",".plusOptBtn",function(){
				const optTag = $(this).parent().parent().children('td').eq(0).children("input[type='hidden']");

				var opt = JSON.parse(optTag.val());
				opt.optAmount += 1;
				
				optTag.val(JSON.stringify(opt));
				
				$(this).parent().parent().children('td').eq(0).children('.optAmount').text(opt.optAmount);
			});
			
			$(document).on("click",".minusOptBtn",function(){
				const optTag = $(this).parent().parent().children('td').eq(0).children("input[type='hidden']");
				
				var opt = JSON.parse(optTag.val());
				
				if(opt.optAmount == 1){
					return;
				}
				
				opt.optAmount -= 1;
				
				optTag.val(JSON.stringify(opt));
				
				$(this).parent().parent().children('td').eq(0).children('.optAmount').text(opt.optAmount);
			});
			
			$("#optionSelect").change(function(){
				selectedOptArr = new Array();
				//select에서 옵션을 선택하면 이 옵션이 이미 선택된 옵션인지 확인
				const selectedOpt = $("#selectedOpt").find("input[type='hidden']").get();
				
				for(const opt of selectedOpt){
					selectedOptArr.push(JSON.parse(opt.value))
				}
				
				var selectOpt = JSON.parse($(this).val());

				//selectedOpt 를 돌면서 동일한 선택한 옵션의 이름과 같은 이름을 가진 옵션이 있나 확인하고 없으면 undefined 반환 즉 옵션 추가
				if((selectedOptArr.find(opt => opt.optName == selectOpt.optName)) == undefined){
					
					selectOpt.optAmount = 1;
					addOpt = "<tr>"
								+ "<td>"
								+ "<input type='hidden' value='"+ JSON.stringify(selectOpt) +"' class='optJson'>"
								+ "옵션 " + selectOpt.optName + " - " + selectOpt.optCost + "원 수량"
								+ "<span class='optAmount'>" + selectOpt.optAmount + "</span>개"
								+ "</td>"
								+ "<td><button type='button' class='minusOptBtn'><i class='fa fa-minus'></i></button></td>"
								+ "<td><button type='button' class='plusOptBtn'><i class='fa fa-plus'></i></button></td>"
							+ "</tr>"

					$(".tableHeader").parent().append(addOpt);
				}else{
					alert("이미 선택한 옵션 입니다. 수량을 조정해주세요.");
				}
			});
		});
	
	</script>
</body>
</html>