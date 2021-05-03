<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />
<script type="text/javascript">
	var maxOpt = 20;
	var numOpt = 0;

	$(function() {
		$("input[name='itemImg']").on("change", imgPriview);
	});

	function imgPriview(e) {
		var files = e.target.files;
		var filesArr = Array.prototype.slice.call(files);

		filesArr.forEach(function(f) {
			if (!f.type.match("image.*")) {
				alert("확장자는 이미지 확장자만 가능합니다.");
				return;
			} else {
				var reader = new FileReader();
				reader.onload = function(e) {
					$("#imgPriview").attr("src", e.target.result);
				}
				reader.readAsDataURL(f);
			}
		});
	}

	function addOpt() {
		if (numOpt >= maxOpt) {
			alert("최대 20개까지 옵션 등록 가능합니다.");
		} else {
			numOpt++;
			$("#options")
					.append(
							"<tr id='del class='writewidTitle'" + numOpt + "'>"
									+ "<td>"
									+ "<input type='text' name='OptName' class='writewidTitle'>"
									+ "</td>"
									+ "<td>"
									
									+ "<input type='number' name='OptCost' class='writewidTitle'>"
									+ "</td>"
									+ "<td>"
									+ "<input type='button' value='옵션제거' class='btn' onclick='delOpt(this)' name='btndel"
									+ numOpt + "'>"
									+ "</td>" + "</tr>");
		}
	}

	function delOpt(btn) {
		var tr = $(btn).parent().parent();
		tr.remove();
		
		numOpt--;
	}
</script>
<div class="hoc container clear">
<form action="${contextPath}/item/itemUpload.do" method="post" enctype="multipart/form-data">
	<table class="content">
		<tr class="myPageRe bold" >
			<td class="wordPoCen">판매자</td>
			<td colspan="5">
				<input type="text" name="seller" value="${memberId}" class="writewidTitle" disabled>
			</td>
		</tr>
		<tr class="myPageRe">
			<td class="wordPoCen bold">상품이름</td>
			<td colspan="5">
				<input type="text" name="itemName" class="writewidTitle">
			</td>
		</tr>
		<tr class="myPageRe">
			<td class="wordPoCen bold">상품종류</td>
			<td >
				<select name="itemCate" class="writewidTitle">
					<option value="의자">의자</option>
					<option value="옷장">옷장</option>
					<option value="조명">조명</option>
					<option value="벽지">벽지</option>
					<option value="장난감">장난감</option>
					<option value="책상">책상</option>
				</select>
			</td>
			<td class="wordPoCen bold">색상</td>
			<td>
				<select name="itemColor" class="writewidTitle">
					<option value="빨강">빨강</option>
					<option value="파랑">파랑</option>
					<option value="핑크">핑크</option>
					<option value="기타">기타</option>
				</select>
			</td>
			<td class="wordPoCen bold">스타일</td>
			<td>
				<select name="itemCate" class="writewidTitle">
					<option value="큐트">큐트</option>
					<option value="모던">모던</option>
					<option value="애니메이션">애니메이션</option>
					<option value="스마트">스마트</option>
				</select>
			</td>
		</tr>
		
		<tr class="myPageRe">
			<td class="wordPoCen bold">제작예정일(일)</td>
			<td>
				<input type="number" name="dueDate" class="writewidTitle">
			</td>
			<td class="wordPoCen bold">선호연령(세)</td>
			<td>
				<input type="number" name="preferage" class="writewidTitle">
			</td>
			<td class="wordPoCen bold">수량</td>
			<td>
				<input type="number" name="amount" class="writewidTitle">
			</td>
		</tr>
		
		
		
		<tr class="myPageRe">
			<td class="wordPoCen bold">가격<p>(단위 : 원)</p></td>
			<td colspan="5">
				<input type="number" name="itemCost" class="writewidTitle">
			</td>
		</tr>
		
		<tr class="myPageRe">
			<td class="wordPoCen bold">상품 이미지</td>
			<td colspan="5">
				<input type="file" name="itemImg" >
				<img id="imgPriview" alt="itemImg" src="../css/images/demo/320x220.png" width="640px">
			</td>
		</tr>
		<tr class="myPageRe">
			<td class="wordPoCen bold" colspan="2">
			옵션
			<p class="blockTd"><input type="button" class="btn writewidTitle" onclick="addOpt()" value="옵션추가"></p>
			</td>
			<td colspan="4">
				
				<table id="options" >
					<tr class="wordPoCen myPageRe">
						<td>옵션이름</td>
						<td>옵션가격</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<div class="hoc center">
		<input type="submit" class="btn" value="제출" >
		<input type="reset" class="btn" value="다시 쓰기">
	</div>
</form>

</div>
