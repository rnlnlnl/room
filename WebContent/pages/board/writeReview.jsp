<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<script>
	$(function(){
		$(".starrating li").click(function(){
			$(this).parent().children('li').children('i').removeClass("coloured fa-star").addClass("fa-star-o");
			$(this).children('i').addClass("coloured fa-star").removeClass("fa-star-o");
			$(this).prevAll('li').children('i').addClass("coloured fa-star").removeClass("fa-star-o");
			
			$("input[name='scope']").val($(this).children('i').children('em').text());
			$("#scope").text($(this).children('i').children('em').text() + "점");
		});
	});
</script>

<form action="${contextPath}/board/addReview.do" method="post" enctype="multipart/form-data">
	<input type="hidden" name='orderNo' value="${param.orderNo}">
	<div class="hoc container1 clear">
	<h1>&nbsp;</h1>
	<table class="content">
		<tr class="tableLineDo">
			<td class="wordPoCen postFontSizeTi listTd5">별점</td>
			<td class="listTd5">
				<ul class="starrating">
					<li>
						<i class="fa fa-star-o"><em>1</em></i>
					</li>
					<li>
						<i class="fa fa-star-o"><em>2</em></i>
					</li>
					<li>
						<i class="fa fa-star-o"><em>3</em></i>
					</li>
					<li>
						<i class="fa fa-star-o"><em>4</em></i>
					</li>
					<li>
						<i class="fa fa-star-o"><em>5</em></i>
					</li>
					<li>
					<input type="hidden" name="scope" readonly>
					<span id="scope"></span>
					</li>
				</ul>
			</td>
			<td class="wordPoCen postFontSizeTi listTd6">상품명</td>
			<td class="listTd20">
				${param.itemName}
			</td>
			<td class="wordPoCen postFontSizeTi listTd7">주문번호</td>
			<td class="listTd10">
				${param.orderNo}
			</td>
		</tr>
		<tr class="tableLineSo">
			<td class="wordPoCen postFontSizeTi">제목</td>
			<td colspan="5" >
				<input type="text" class="writewidTitle" name="title" required>
			</td>
		</tr>
		<tr>
			<td class="wordPoCen postFontSizeTi">내용</td>
			<td colspan="5">
				<textarea name="content" class="writewid" required></textarea>
			</td>
		</tr>
		<tr>
			<td colspan="4">
				사진 첨부(최소 1개 이상의 후기 사진을 등록해야합니다. / 최대 5개)
				<button type="button" id="plusFileBtn">
					<i class="fa fa-plus-square-o"></i>
				</button>
			</td>
			<td colspan="2">

				<div id="fileBox">
					<p>
						대표 후기 사진
						<input type='file' name='file' required accept="image/*">
					</p>
				</div>
			</td>
		</tr>
	</table>
	</div>
	
	<div id="divList" class="postFontSizeTi writeBu">
		<input type="submit" value="등록하기" class="btn">
		<input type="reset" value="다시작성" class="btn">
		<input type="button" value="목록가기" class="btn" onclick="location.href='${contextPath}/item/readOrderItem.do?orderNo=${param.orderNo}'">
	</div>
</form>


<script>
	var fileNo = 1;
	var maxFile = 4;
	
	$(function(){
		$(".starrating li").eq(0).click();
	});

	$(".starrating li").click(function() {
		$(this).parent().children('li').children('i').removeClass("coloured fa-star").addClass("fa-star-o");
		$(this).children('i').addClass("coloured fa-star").removeClass("fa-star-o");
		$(this).prevAll('li').children('i')
				.addClass("coloured fa-star").removeClass("fa-star-o");
		
		$("input[name='scope']").val(
				$(this).children('i').children('em').text());
		$("#scope").text(
				$(this).children('i').children('em').text() + "점");
	});
			

	$("#plusFileBtn").click(function() {
		if (fileNo > maxFile) {
			alert('파일은 최대 5개까지 등록할 수 있습니다.');
		} else {
			if(fileNo == 1){
				$("#fileBox").append("<hr>")
			}
			$("#fileBox")
					.append(
							"<p>"
									+ "<input type='file' name='file' required accept='image/*''>"
									+ "<button type='button' class='minusFileBtn'>"
									+ "<i class='fa fa-minus-square-o'></i> <hr>"
									+ "</button>" + "</p>");
			fileNo++;
		}
	});

	$(document).on("click", ".minusFileBtn", function() {
		$(this).parent().remove();
		fileNo--;
		if(fileNo == 1){
			$("#fileBox").children("hr").remove();
		}
	});
</script>