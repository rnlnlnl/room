<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- JSTL의 CORE라이브러리에 속한 태그들을 사용 하기 위해 링크 작성 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%-- 컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div id="readLetterBox">
	<span>제목</span>
	<p>${letterBean.title}</p>

	<span>
		<c:if test="${param.rs == 'r'}">
			보낸 사람
		</c:if>
		<c:if test="${param.rs == 's'}">
			받은 사람
		</c:if>
	</span>
	<p>${letterBean.recipient}</p>
	<span> 보낸 시간 </span>
	<p>
		<fmt:formatDate value="${letterBean.senddate}" pattern="yy/MM/dd a hh:mm" />
	</p>

	<div id="contentBox">${letterBean.content}</div>

	<div class="btnBox">
		<input type="hidden" id="letterNo" value="${letterBean.letterno}">
		<c:if test="${param.rs == 'r'}">
			<c:set var="letterCenter" value="receiveLetter" />
		</c:if>
		<c:if test="${param.rs == 's'}">
			<c:set var="letterCenter" value="sendLetter" />
		</c:if>
		<button type="button" class="replyBtn btn">답장</button>
		<button type="button" class="delBtn btn">삭제</button>
		<button type="button" class="listBtn btn">목록</button>
		<button type="button" class="closeBtn btn">닫기</button>
	</div>
</div>

<c:if test="">
	

</c:if>
<script type="text/javascript">
	var rs = "${param.rs}"
	var page =  ${param.page}

	$(".listBtn").click(function() {
		if(rs == 's'){
			location.href = '${contextPath}/member/letterPage.do?letterCenter=sendLetter&page='+ page;
		}else{
			location.href = '${contextPath}/member/letterPage.do?page='+ page;
		}
	});

	$(".delBtn").click(function() {
		var letterNo = [];

		letterNo.push($("#letterNo").val());

		$.ajax({
			type : "post",
			url : "${contextPath}/member/delLetter.do",
			traditional : true,
			data : ({
				letterNo : letterNo,
				rs: "${param.rs}"
			}),
			dataType : "text",
			success : function(result) {
				location.href = '${contextPath}/member/letterPage.do';
			}
		});
	});
	
	$(".replyBtn").click(function(){
		location.href = '${contextPath}/member/letterPage.do?letterCenter=writeLetter&reply=${letterBean.recipient}';
	});
</script>