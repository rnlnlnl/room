<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<script type="text/javascript">
	$(function() {
		$(".${postCate}").removeClass("initDisplayNone");
	});
</script>

<form action="${contextPath}/board/addPost.do" method="post"  enctype="multipart/form-data">
	<div class="hoc container clear">
		<table class="content">
			<tr class="tableLineDo">
				<td class="wordPoCen postFontSizeTi">종류</td>
				<td>
					${postCate}
					<input type="hidden" name="postCate" value="${postCate}">
					<input type="hidden" name="writer" value="${memberId}">
				</td>
			</tr>
			<tr class="tableLineDo">
				<td class="wordPoCen postFontSizeTi">제 목</td>
				<td>
					<input class="writewid" type="text" name="title" required>
				</td>
			</tr>
			<tr class="tableLineSo">
				<td class="wordPoCen postFontSizeTi">작성목적</td>
				<td>
					<div class="postFontSizeTi">
						<select id="widSelect" name="noticecate" class="notice initDisplayNone">
							<option value="일반">일반</option>
							<option value="중요">중요</option>
							<option value="할인 행사">할인 행사</option>
							<option value="당첨자 발표">당첨자 발표</option>
						</select>
					</div>
					<div class="postFontSizeTi">
						<select id="widSelect" name="noticecate" class="qna initDisplayNone">
							<option value="주문/결제">주문/결제</option>
							<option value="고객정보">고객정보</option>
							<option value="배송">배송</option>
							<option value="취소">취소</option>
							<option value="이벤트/제휴/기타">이벤트/제휴/기타</option>
						</select>
					</div>
				</td>
			</tr>
			<tr>
				<td class="wordPoCen postFontSizeTi">내용</td>
				<td>
					<textarea class="writewid" name="content" required></textarea>
				</td>
			</tr>
			<tr>
				<td>
					첨부파일
					<button type="button" id="plusFileBtn">
						<i class="fa fa-plus-square-o"></i>
					</button>
				</td>
				<td>
					<div id="fileBox"></div>
				</td>
			</tr>
		</table>
		<div id="divList" class="postFontSizeTi writeButton">
			<input type="submit" value="등록하기">
			<input type="reset" value="다시작성">
			<input type="button" value="목록가기" onclick="location.href='${contextPath}/board/csCenterPage.do?postCate=${param.postCate}'">
		</div>
	</div>
</form>

<script type="text/javascript">
	var fileNo = 1;
	var maxFile = 10;

	$("#plusFileBtn")
			.click(
					function() {
						if (fileNo > maxFile) {
							alert('파일은 최대 ' + maxFile + '개까지 등록할 수 있습니다.');
						} else {
							if (fileNo == 1) {
								$("#fileBox").append("<hr>")
							}
							$("#fileBox")
									.append(
											"<p>"
													+ "<input type='file' name='file' required accept='image/*''>"
													+ "<button type='button' class='minusFileBtn'>"
													+ "<i class='fa fa-minus-square-o'></i>"
													+ "</button>" + "</p>");
							fileNo++;
						}
					});

	$(document).on("click", ".minusFileBtn", function() {
		$(this).parent().remove();
		fileNo--;
		if (fileNo == 1) {
			$("#fileBox").children("hr").remove();
		}
	});
</script>