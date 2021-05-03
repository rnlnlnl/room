<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- JSTL의 CORE라이브러리에 속한 태그들을 사용 하기 위해 링크 작성 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- 컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />


<form method="post" action="${contextPath}/member/addLetter.do" id="writeLetter">
	<span class="inline right">제목</span>
	<input type="text" name='title' <c:if test="${not empty param.reply}">value='[답장]'</c:if>>

	<span class="inline right">받는 사람</span>
	<div id="recipientDiv" class="inline" >
		<input type="text" name='recipient' class="recipient" placeholder="버튼을 이용해 입력해주세요." <c:if test="${not empty param.reply}">value='${param.reply}'</c:if> readonly>
		<c:if test="${empty param.reply}">
			<button type="button" class="adminSend btn">관리자</button>
			<button type="button" class="sellerFind btn">판매자 찾기</button>
		</c:if>
	</div>

	<span class="inline verticalAlignTop">내용</span>
	<textarea name='content'></textarea>

	<div class="btnBox">
		<button type="submit" class="btn">전송</button>
		<button type="button" class="closeBtn btn">닫기</button>
	</div>
	
	<table id="sellerBox" class="initDisplayNone">
		<tr>
			<td>아이디</td>
			<td>회사명</td>
			<td>선택<button type="button" class="closeTableBtn btn">닫기</button></td>
		</tr>
		<c:forEach var="seller" items="${sellerList}">
			<tr>
				<td>${seller.id}</td>
				<td>${seller.name}</td>
				<td><button type="button" class="btn sellerSend">선택</button></td>
			</tr>
		</c:forEach>
	</table>
	
</form>

<script type="text/javascript">
	<c:if test="${not empty param.reply}">
		$("#recipientDiv>.recipient").addClass("replyRec");
	</c:if>

	$(".closeTableBtn").click(function(){
		$("#sellerBox").css("display", "");
	});

	$(".adminSend").click(function(){
		$(".recipient").val("admin");
	});
	
	$(".sellerSend").click(function(){
		var id = $(this).parent().parent().children().first().text();
		$(".recipient").val(id);
		$("#sellerBox").css("display", "");
	});
	
	$(".sellerFind").click(function(){
		$("#sellerBox").css("display", "table");
	});
	
</script>