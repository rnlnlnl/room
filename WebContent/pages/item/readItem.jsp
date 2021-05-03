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
var confirmText="";
var maxOpt = 20;
var numOpt = ${fn:length(options)};

	$(function(){
		$("option[value="+"${itemBean.itemCate}"+"]").attr("selected", "true");
		$("option[value="+"${itemBean.itemColor}"+"]").attr("selected", "true");
		
		$(".disabled").attr("disabled", "disabled");
		
		if(${itemBean.isUse}){
			$("#chageItmeStateBtn").text("판매 중지");
			confirmText = "${itemBean.itemname} 상품 판매를 중지하시겠습니까?\n 상품을 중지하셔도 주문 상황은 남아있습니다.";
		}else{
			$("#chageItmeStateBtn").text("판매 재개");
			confirmText = "${itemBean.itemname} 상품 판매를 재개하시겠습니까?\n ";
		}
		
		$("#numOpt").text(numOpt);
		
		$("#imgModBtn").css("display", "none");
	});

	function imgModBtnCli(){
		$("#imgModBtn").css("display", "initial");
	}
	
	function chageItemState(){
		if(confirm(confirmText)){
			location.href="${contextPath}/item/chageItemState.do?itemNo=${itemBean.itemno}";
		}
	}
	
	function addOpt() {
		if (numOpt >= maxOpt) {
			alert("최대 20개까지 옵션 등록 가능합니다.");
		} else {
			numOpt++;
			$("#numOpt").text(numOpt);
			$("#options").append("<tr>"
									+ "<td>"
										+ "<input type='text' name='OptName'>"
									+ "</td>"
									+ "<td>"
										+ "<input type='number' name='OptCost'>"
									+ "</td>"
									+ "<td>"
										+ "<button type='button' onclick='delOpt(this)'>옵션 삭제</button>"
									+ "</td>"
								+ "</tr>");
		}
	}
	
	function delOpt(btn) {
		var tr = $(btn).parent().parent();
		tr.remove();
		
		numOpt--;
		$("#numOpt").text(numOpt);
	}
	
	function modBtn(btn) {
		$(".wrap").each(
						function(i, e) {
							var value = $(this).text();
							var name = $(this).attr("name");
							var type = $(this).attr("type")
							$(this)
									.html(
											"<input type='"+type+"' name='"+name+"' value='"+value+"'>");
						});

		$(btn).attr("onclick", "submit(this.form)");
		$(btn).text("수정");
		
		$(".disabled").removeAttr("disabled");
		$(".initDisplayNone").css("display", "initial");
		$(".roomdyHidden").css("display", "none");
		
		$(".wrap>input").unwrap();
	}
	
	function submit(form){
		$(form).submit();
	}
</script>

<form action="${contextPath}/item/itemMod.do" method="post" enctype="multipart/form-data">
	<table id="itemTable" border="1">
		<tr>
			<td>판매자</td>
			<td>
				<span name="memberId" type="text">${memberId}</span>
				<input type="hidden" name="itemNo" value="${itemBean.itemno}">
			</td>
		</tr>
		<tr>
			<td>상품이름</td>
			<td>
				<span class="wrap" name="itemName" type="text">${itemBean.itemname}</span>
			</td>
		</tr>
		<tr>
			<td>제작 예정일</td>
			<td>
				<span class="wrap" name="dueDate" type="number">${itemBean.dueDate}</span>일
			</td>
		</tr>
		<tr>
			<td>가격</td>
			<td>
				<span class="wrap" name="itemCost" type="number">${itemBean.cost}</span>
				원
			</td>
		</tr>
		<tr>
			<td>선호연령</td>
			<td>
				<span class="wrap" name="preferage" type="number">${itemBean.preferage}</span>
				살
			</td>
		</tr>
		<tr>
			<td>수량</td>
			<td>
				<span class="wrap" name="amount" type="number">${itemBean.amount}</span>
				개
			</td>
		</tr>

		<tr>
			<td>상품종류</td>
			<td>
				<span class="roomdyHidden" name="itemCate" type="text">${itemBean.itemCate}</span>
				<select name="itemCate" class="initDisplayNone">
					<option value="chair">의자</option>
					<option value="closet">옷장</option>
					<option value="light">조명</option>
					<option value="wallpaper">벽지</option>
					<option value="toy">장난감</option>
					<option value="desk">책상</option>
				</select>
			</td>
		</tr>

		<tr>
			<td>색상</td>
			<td>
				<span class="roomdyHidden" name="itemColor" type="text">${itemBean.itemColor}</span>
				<select name="itemColor" class="initDisplayNone">
					<option value="red">빨강</option>
					<option value="blue">파랑</option>
					<option value="pink">핑크</option>
					<option value="etc">기타</option>
				</select>
			</td>
		</tr>

		<tr>
			<td>스타일</td>
			<td>
				<span class="roomdyHidden" name="itemCate" type="text">${itemBean.style}</span>
				<select name="itemCate" class="initDisplayNone">
					<option value="qute">큐트</option>
					<option value="modern">모던</option>
					<option value="anymation">애니메이션</option>
					<option value="smart">스마트</option>
				</select>
			</td>
		</tr>

		<tr>
			<td>상품 이미지</td>
			<td>
				<img id="imgPriview" alt="itemImg" src="../css/images/upload/itemImg/${itemBean.itemImg}" width="320px">
				<button class="initDisplayNone" type="button" onclick="imgModBtnCli()">사진 변경</button>
				<input type="file" id="imgModBtn" name="itemImg">
				<input type="hidden" name="origItemImg" value="${itemBean.itemImg}">
			</td>
		</tr>
		<tr>
			<td>
				옵션(개수 :
				<span id="numOpt"></span>
				)
			</td>
			<td>
				<table id="options" border="1">
					<tr>
						<td>옵션이름</td>
						<td>옵션가격</td>
						<td>
							<button type="button" class="initDisplayNone" onclick="addOpt()">옵션추가</button>
						</td>
					</tr>
					<c:choose>
						<c:when test="${options==null}">
							<tr>
								<td colspan="3">등록된 옵션이 없습니다.</td>
							</tr>
						</c:when>
						<c:when test="${options!=null}">
							<c:forEach items="${options}" var="option" varStatus="step">
								<tr>
									<td>
										<span class="wrap" name="OptName" type="text">${option.optName}</span>
									</td>
									<td>
										<span class="wrap" name="OptCost" type="number">${option.optCost}</span>
									</td>
									<td>
										<button type="button" class="initDisplayNone" onclick="delOpt(this)">옵션 삭제</button>
									</td>
								</tr>
							</c:forEach>
						</c:when>
					</c:choose>
				</table>
			</td>
		</tr>
	</table>

	<button type="button" onclick="modBtn(this)">수정하기</button>

	<a href="${contextPath}/item/readItem.do?itemNo=${itemBean.itemno}">
		<button type="button" class="initDisplayNone">취소하기</button>
	</a>
	<a href="${contextPath}/item/itemList.do">
		<button type="button">목록으로</button>
	</a> 
	<button type="button"  id="chageItmeStateBtn" onclick="chageItemState()">상품 판매 중지</button>
	</form>
<script type="text/javascript">
	
</script>