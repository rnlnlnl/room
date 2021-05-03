<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />


<c:if test="${empty memberId}">
	<script>
		alert("로그인 후 이용해주세요.");
		location.href = "${contextPath}/member/main.do"
	</script>
</c:if>
<div class="hoc container1 clear">
	<h1 class="center">장바구니</h1>
	<form action="${contextPath}/item/orderPage.do" method="post">
		<div class="fl_right inline btmspace-30">
			<button type="button" id='allCheck'>상품 전체선택</button>
			<button type="button" id='allUnCheck'>전체선택 해제</button>
		</div>
		<table id="cartDiv" class='content'>
			<tr class="listMemberTr">
				<td class="listTd_1">선택</td>
				<td class="listTd13">상품이미지</td>
				<td class="listTd8">상품명</td>
				<td class="listTd8 Centernone">가격/수량/총액</td>
				<td class="listTd3">주문/수정</td>
			</tr>
			<c:forEach items="${cartList}" var="cart">
				<tr class="itemDiv">
					<td>
						<input class='itemCheck margin50' type="checkbox" value="${cart.itemBean.itemno}" name='itemNo'>
					</td>
					<td>
						<img class="itemImg margin10" alt="상품사진" src="${contextPath}/css/images/upload/itemImg/${cart.itemBean.itemImg}">
					</td>
					<td id="listMemberJD">${cart.itemBean.itemname}</td>
					<td>
						<c:set var="totalCost" value="0" />
						<span>
							가격 : ${cart.itemBean.cost} 원
							<br>
							<br>
							수량 : ${cart.cartBean.cartamount} 개
						</span>
						<c:forEach var="opt" items="${cart.optList}">
							<div class="options">
								추가 옵션 :
								<span class="optName">${opt.optName}</span>
								<br>
								+
								<span class="optCost">${opt.optCost}</span>
								원
								<span class="optAmount">${opt.optAmount}</span>
								개
								<button class="inline delOptBtn" type="button">
									<i class="fa fa-minus"></i>
								</button>
							</div>
							<c:set var="totalCost" value="${totalCost+(opt.optCost*opt.optAmount)}" />
						</c:forEach>
						<br>
						<br>
						총 액 : ${totalCost+cart.itemBean.cost} 원
						<input type="hidden" value='${cart.optList}'>
					</td>
					<td class="clear buttonPadd">
						<button type="button" class="inline modCartItemBtn margin2">옵션수정</button>
						<input type="button" class="inline oneCartItemOrderBtn btn margin2" value="주문하기">
					</td>
				</tr>
			</c:forEach>

		</table>
		<hr>
		<input type="hidden" name="isDirect" value="no">
		<input class="orderBtn btn marginBo" type="submit" value="선택상품 주문하기">
		<input class='btn marginBo' type="button" value="선택상품 삭제" onclick="deleteItem()">
	</form>
</div>


<script>
$(".itemCheck").prop('checked', true);

$("#allCheck").click(function(){
	$(".itemCheck").prop('checked', true);
});

$("#allUnCheck").click(function(){
	$(".itemCheck").prop('checked', false);
});

$(".oneCartItemOrderBtn").click(function() {
    $(".itemCheck").prop('checked', false);
    $(this).parent().parent().children().first().children(".itemCheck").prop('checked', true);

    $(".orderBtn").click();
});

$(".modCartItemBtn").click(function() {
    //장바구니에 담았던 아이템을 수정하는 페이지를 팝업으로 띄움
    var itemNo = $(this).parent().parent().children(":first").children().val();
    const url = "${contextPath}/item/modCartItemPopupPage.do?itemNo=" + itemNo;

    window.open(url, '주문 수정', 'width=450,height=500');
});

$(".delOptBtn").on("click", function() {
    const jsonOptList = $(this).parent().parent().children("input[type='hidden']").val();

    var itemNo = $(this).parent().parent().parent().children(":first").children().val();
    var optName = $(this).parent().children(".optName").text();
    var optCost = $(this).parent().children(".optCost").text();
    var optAmount = $(this).parent().children(".optAmount").text();


    var optList = JSON.parse(jsonOptList);

    console.log(optList)

    var i = 0;
    for (var opt of optList) {
        if (opt.optName == optName) {
            optList.splice(i, 1);
            console.log(optList)
        }
        i++;
    }

    var stringOptList = JSON.stringify(optList);

    //ajax를 이용해 수정한 문자열을 opt 컬럼에 덮어씌움
    $.ajax({
        type: "post",
        url: "${contextPath}/item/modCart.do",
        traditional: true,
        data: {
            itemNo: itemNo,
            opts: stringOptList
        },
        dataType: "text",
        success: function(result) {
            location.reload(true)
        }
    });
});



function deleteItem() {
    const arr = []
    
    $('.itemCheck:checked').each(function(){
    	arr.push($(this).val());
    	$(this).parent().parent().remove();
    })

    $.ajax({
        type: "post",
        url: "${contextPath}/item/deleteCart.do",
        traditional: true,
        data: {
            "itemNo": arr
        },
        success: function(result) {
            alert('삭제 되었습니다.');
        }
    });
}
</script>