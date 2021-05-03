<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="boardBean" value="${postMap.boardBean}" />
<c:set var="fileList" value="${postMap.fileList}" />
<script type="text/javascript">
	$(function() {
		$("option[value=" + "${itemBean.noticecate}" + "]").attr("selected",
				"true");

		$("#listBtn").click(function() {
			location.href = '${contextPath}/board/csCenterPage.do?postCate=${param.postCate}&page=${param.page}';
		});
		
		$(".fileDownBtn").click(function(){
			
			var fileSrc = $(this).parent().children('span').text();
			
			$('#ifrm_filedown').attr('src', '${contextPath}/board/download.do?fileSrc=' + fileSrc);
			
		});
	});

	function modBtn(btn) {
		$(".wrap").each(function(i, e) {
			var value = $(this).text();
			var name = $(this).attr("name");
			var type = $(this).attr("type")
			$(this).html("<input type='"+type+"' name='"+name+"' value='"+value+"'>");
		});

		$(btn).attr("onclick", "submit(this.form)");
		$(btn).text("수 정");
		$(".${param.postCate}").removeClass("roomdyHidden");
		$(".initDisplayNone").css("display", "initial");
		$(".textareaMod").css("width", "100%");
		$(".roomdyHidden").css("display", "none");

		$(".wrap>input").unwrap();
	}

	function delBtn(btn) {
		var con = confirm("정말 글을 삭제하시겠습니까?");
		if(con){
			$.ajax({
		        type: "post",
		        url: "${contextPath}/board/delPost.do",
		        data: ({
		            postno : ${param.postno},
		            postCate : "${param.postCate}"
		        }),
		        dataType: "text",
		        success: function(result) {
		            if (result=="true"){
		            	alert("삭제 성공");
		            	$("#listBtn").click();
		            }
		        }
		    });
		}
	}
	
	function answerBtn() {
		
		var content = $("#content").val();

			$.ajax({
				type: "post",
				url: "${contextPath}/board/addAnswer.do",
				data: ({
					content : content,
					answerNo : "${param.postno}",
					answerCate : "${param.postCate}"
				}),
				success: function(){
					alert("답변이 등록되었습니다.");
					
				}
			});

	}

</script>


<form action="${contextPath}/board/modPost.do" method="post">
	<div id="qna" class="hoc container clear">
		<table class="content">
			<tr class="tableLineDo">
				<td class="wordPoCen postFontSizeTi verMiddle listTd5">종 류</td>
				<td class="listTd7">
					<span class="roomdyHidden">${boardBean.noticecate}</span>
					<div id="widSelect" class="initDisplayNone postFontSizeTi">
						<select name="noticecate" class="notice roomdyHidden textareaMod">
							<option value="일반">일반</option>
							<option value="중요">중요</option>
							<option value="할인 행사">할인 행사</option>
							<option value="당첨자 발표">당첨자 발표</option>
						</select>
						<select id="widSelect" name="noticecate" class="qna roomdyHidden postFontSizeTi textareaMod">
							<option value="주문/결제">주문/결제</option>
							<option value="고객정보">고객정보</option>
							<option value="배송">배송</option>
							<option value="취소">취소</option>
							<option value="이벤트/제휴/기타">이벤트/제휴/기타</option>
						</select>
					</div>
				</td>
				<td class="wordPoCen postFontSizeTi listTd3">No</td>
				<td class="wordPoCen listTd4">${param.postno}
					<input type="hidden" value="${param.postno}" name="postno">
					<input type="hidden" value="${param.postCate}" name="postCate">
					<input type="hidden" value="${param.page}" name="page">
				</td>
			</tr>
			<tr class="tableLineSo">
				<td class="wordPoCen postFontSizeTi listTd5">제 목</td>
				<td class="listTd30">
					<span class="wrap textareaMod" name="title" type="text">${boardBean.title }</span>
				</td>
				<td class="wordPoCen postFontSizeTi listTd6">작성일</td>
				<td class="listTd7">
					<span class="roomdyHidden"> <fmt:formatDate value="${boardBean.writedate}" pattern="yyyy.MM.dd" />
					</span> <span class="initDisplayNone">수정하는 현재 시간으로 변경됩니다.</span>
				</td>
			</tr>

			<tr>
				<td class="wordPoCen postFontSizeTi readIn ">내 용</td>
				<td colspan="3" class="verMiddle">
					<span class="roomdyHidden postPosi">${boardBean.content}</span>
					<textarea name="content" rows="13" cols="40" required class="initDisplayNone readIn textareaMod">${boardBean.content}</textarea>
				</td>
			</tr>
			
			<c:if test="${fileList != null }">
			<tr>
				<td>첨부파일</td>
				<td>
					<iframe id="ifrm_filedown" class="initDisplayNone"></iframe>
					<c:forEach items="${fileList}" var="file" varStatus="i">
						<p>
							<span>${file}</span>
							<button type="button" class="fileDownBtn">다운로드</button>
						</p>
					</c:forEach>
				</td>
			</tr>
		</c:if>
		</table>

		<c:if test="${memberId==(boardBean.writer) or auth == 'A' or auth == 'a'}">
			<div id="listMemberJD">
				<div id="divList" class="postFontSizeTi readBuLis">
					<button type="button" class="readbut" onclick="modBtn(this)">수 정</button>
					<button type="button" class="readbut" onclick="delBtn(this)">삭 제</button>
				</div>
			</div>
		</c:if>
		<hr style="height: 1px; background-color: #eaded6;">
		<button type="button" class="readbut" id="listBtn">목록으로</button>
	</div>
</form>
<c:if test="${param.postCate eq 'qna'}">
	<hr>
	<div class="hoc container clear">
		<h1 class="bold">답변</h1>

		<c:if test="${auth == 'A' or auth == 'a'}">

			<form action="#" method="post">
				<table>
					<tr>
						<td>
							<input type="hidden" name="answerCate" value="${postCate}">
							<input type="hidden" name="answerNo" value="${param.postno}">
							<input type="hidden" name="title" value="답글">
							<textarea name="content" id="content" rows="5" cols="150" required></textarea>
						</td>
						<td>
							<button type="button" onclick="answerBtn()">답글달기</button>
						</td>
					</tr>
				</table>
			</form>
		</c:if>
		<c:choose>
			<c:when test="${empty answerList}">
				<p class="bold">아직 답변이 달리지 않았습니다.</p>
			</c:when>
			<c:otherwise>
				<p>제목을 클릭하면 답변이 보입니다.</p>
				<c:forEach var="answer" items="${answerList}">
					<button class="accord">${answer.title}
						<span class="fl_right"><fmt:formatDate value="${answer.writedate}" pattern="yyyy.MM.dd" /></span>
					</button>
					<div class="panel">
						<p>${answer.content}</p>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</div>
</c:if>
<script type="text/javascript">
$(".accord").click(function(){
	$(this).toggleClass('active');

	
	if($(this).next('div').css('display') == 'none'){
		$(this).next('div').show();
	}else{
		$(this).next('div').hide();
	}
	
});
</script>
<style>
table.content input {
	width: 100%;
	height: 50px;
}
</style>

