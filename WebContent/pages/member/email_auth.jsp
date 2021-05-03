<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- JSTL의 CORE라이브러리에 속한 태그들을 사용 하기 위해 링크 작성 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- 컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%
    request.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta content="text/html; charset=UTF-8">
<title>Email 인증 요청</title>

<script src="${contextPath}/scripts/jquery.min.js"></script>
<script type="text/javascript">
	function checkAuthNum() {
		var checkNum = document.getElementById("authNum").value;
		var certNum = ${certNum};
		if (!checkNum) {
			alert("인증번호를 입력하십시오.")
		} else {
			if (checkNum == certNum) {
				alert("성공적으로 인증되었습니다.");
				opener.document.getElementById("email").readOnly = true;
				$("#checkEmail", parent.opener.document).text("√ 이메일 인증이 완료되었습니다.");
				opener.document.getElementById("certBtn").disabled = true;
				window.close();
			} else {
				alert("인증번호가 잘못되었습니다.");
				return false;
			}
		}
	}
</script>
</head>



<body>
	<h1 class="h3 mb-3">메일 인증</h1>
	<c:if test="${result == true}">
		<p>${param.email}로인증 메일이 발송되었습니다.</p>
		<div class="form-label-group mt-4">
			<input type="text" id="authNum" name="authNum" class="form-control">
			<label for="inputEmail">인증번호를 입력하세요.</label>
		</div>
		<div class="mt-3">
			<button class="btn btn-lg btn-primary btn-block" type="button" onclick="checkAuthNum()">인증번호 확인하기</button>
		</div>
	</c:if>
	<c:if test="${result != true}">
		인증 메일 전송 실패
	</c:if>
	인증번호 : ${certNum}
	<p class="mt-5 mb-3 text-muted text-center">© ROOMDY</p>
</body>
</html>