<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%-- 컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		String id = (String) session.getAttribute("id");
	%>

	<form action="${contextPath}/member/delMember.do" method="post">
		<div>
			<h2>회원 탈퇴 하시겠습니까.</h2>
		</div>
		<div>
			<input type="button" value="네 회원탈퇴 할꺼예요">
			<a href="${contextPath}/member/main.do">
				<input type="button" value="아직 사고싶은게 남았네요">
			</a>
		</div>
	</form>
</body>
</html>